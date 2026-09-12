package Spellbook::Helper::Domain_Permutations {
    use strict;
    use warnings;
    use Getopt::Long;
    use Readonly;
    use List::MoreUtils qw(uniq);
    use Spellbook::Helper::Entropy;
    use Spellbook::Helper::Host_Normalization;
    use Spellbook::Helper::Levenshtein;
    use Spellbook::Helper::Permutations;
    use Spellbook::Recon::Host_Resolv;

    our $VERSION = '0.0.2';

    Readonly my $DEFAULT_REPEAT                => 50;
    Readonly my $DEFAULT_LIMIT                 => 100;
    Readonly my $DEFAULT_MINIMUM_SIMILARITY    => 0.70;
    Readonly my $DEFAULT_MAX_ENTROPY_DELTA     => 0.80;
    Readonly my $MINIMUM_DELETION_LABEL_LENGTH => 3;
    Readonly my $MAXIMUM_LABEL_LENGTH          => 63;
    Readonly my $INDEX_NOT_FOUND               => -1;
    Readonly my $HIGH_RISK_SCORE               => 85;
    Readonly my $MEDIUM_RISK_SCORE             => 70;
    Readonly my $MAXIMUM_SCORE                 => 100;
    Readonly my $SIMILARITY_SCORE_WEIGHT       => 70;
    Readonly my $LOW_ENTROPY_DELTA_THRESHOLD   => 0.20;
    Readonly my $LOW_ENTROPY_DELTA_SCORE_BONUS => 10;
    Readonly my $UNAVAILABLE_SCORE_BONUS       => 15;

    sub new {  ## no critic (Subroutines::ProhibitExcessComplexity)
        my ($self, $parameters) = @_;
        my ($help, $domain, $resolve, $monitor, $available_only, $unavailable_only, @result);
        my $repeat             = $DEFAULT_REPEAT;
        my $limit              = $DEFAULT_LIMIT;
        my $minimum_similarity = $DEFAULT_MINIMUM_SIMILARITY;
        my $max_entropy_delta  = $DEFAULT_MAX_ENTROPY_DELTA;

        my $parser = Getopt::Long::Parser -> new (
            config => [qw(no_ignore_case pass_through)]
        );

        $parser -> getoptionsfromarray (
            $parameters,
            'h|help'                 => \$help,
            'd|domain=s'             => \$domain,
            'v|value=s'              => \$domain,
            'r|repeat=i'             => \$repeat,
            'l|limit=i'              => \$limit,
            's|similarity=f'         => \$minimum_similarity,
            'e|entropy-delta=f'      => \$max_entropy_delta,
            'resolve'                => \$resolve,
            'monitor'                => \$monitor,
            'available-only'         => \$available_only,
            'unavailable-only'       => \$unavailable_only,
        );

        if (!$domain) {
            if (!$help) {
                return 0;
            }

            return "\n"
                    . "Helper::Domain_Permutations\n"
                    . "===========================\n"
                    . "-h, --help             See this menu\n"
                    . "-d, --domain           Domain to mutate, example: rsmbr.com\n"
                    . "-v, --value            Alias for --domain\n"
                    . "-r, --repeat           Random permutations to request from Helper::Permutations\n"
                    . "-l, --limit            Maximum results to return\n"
                    . "-s, --similarity       Minimum similarity from 0.0 to 1.0\n"
                    . "-e, --entropy-delta    Maximum Shannon entropy delta\n"
                    . "--resolve              Check DNS resolution and append availability status\n"
                    . "--monitor              Return ranked monitoring fields: domain, status, risk, score, similarity, entropy_delta, reason\n"
                    . "--available-only       Return only permutations without DNS resolution\n"
                    . "--unavailable-only     Return only permutations with DNS resolution\n\n";
        }

        my (
            $similarity_of, $entropy_of, $valid_label,
            $remove_at, $duplicate_at, $close_candidates, $is_transposition,
            $single_substitution_distance, $mutation_reason, $risk_score,
            $reason_rank, $risk_level, $split_domain, $resolves
        );

        $similarity_of = sub {
            my ($source, $candidate) = @_;
            my $source_length = length $source;
            my $candidate_length = length $candidate;
            my $max_length = $source_length > $candidate_length ? $source_length : $candidate_length;

            return 1 if $max_length == 0;

            my ($distance) = Spellbook::Helper::Levenshtein -> new([
                '--source' => $source,
                '--target' => $candidate,
            ]);

            return 1 - (($distance // 0) / $max_length);
        };

        $entropy_of = sub {
            my ($text) = @_;
            my ($value) = Spellbook::Helper::Entropy -> new(['--target' => $text]);

            return $value // 0;
        };

        $valid_label = sub {
            my ($label) = @_;

            return 0 if length $label > $MAXIMUM_LABEL_LENGTH;
            return 0 if $label !~ /\A[[:lower:]\d](?:[[:lower:]\d-]*[[:lower:]\d])?\z/msx;

            return 1;
        };

        $remove_at = sub {
            my ($chars, $index) = @_;
            my @copy = @{$chars};
            splice @copy, $index, 1;
            return join q{}, @copy;
        };

        $duplicate_at = sub {
            my ($chars, $index) = @_;
            my @copy = @{$chars};
            splice @copy, $index, 0, $copy[$index];
            return join q{}, @copy;
        };

        $close_candidates = sub {
            my ($label) = @_;
            my @chars = split //msx, $label;
            my @candidates;
            my %neighbors = (
                a => [qw(q w s z 4)],
                b => [qw(v g h n 8)],
                c => [qw(x d f v)],
                d => [qw(s e r f c x)],
                e => [qw(w s d r 3)],
                f => [qw(d r t g v c)],
                g => [qw(f t y h b v 9)],
                h => [qw(g y u j n b)],
                i => [qw(u j k o 1 l)],
                j => [qw(h u i k m n)],
                k => [qw(j i o l m)],
                l => [qw(k o p i 1)],
                m => [qw(n j k)],
                n => [qw(b h j m)],
                o => [qw(i k l p 0)],
                p => [qw(o l)],
                q => [qw(w a)],
                r => [qw(e d f t)],
                s => [qw(a w e d x z 5)],
                t => [qw(r f g y 7)],
                u => [qw(y h j i)],
                v => [qw(c f g b)],
                w => [qw(q a s e)],
                x => [qw(z s d c)],
                y => [qw(t g h u)],
                z => [qw(a s x 2)],
                0 => [qw(o)],
                1 => [qw(i l)],
                2 => [qw(z)],
                q{3} => [qw(e)],
                q{4} => [qw(a)],
                q{5} => [qw(s)],
                q{7} => [qw(t)],
                q{8} => [qw(b)],
                q{9} => [qw(g)],
            );

            foreach my $index (0 .. $#chars) {
                if (@chars > $MINIMUM_DELETION_LABEL_LENGTH) {
                    push @candidates, $remove_at -> (\@chars, $index);
                }
                push @candidates, $duplicate_at -> (\@chars, $index);

                foreach my $replacement (@{$neighbors{$chars[$index]} || []}) {
                    my @copy = @chars;
                    $copy[$index] = $replacement;
                    push @candidates, join q{}, @copy;
                }
            }

            foreach my $index (0 .. $#chars - 1) {
                my @copy = @chars;
                @copy[$index, $index + 1] = @copy[$index + 1, $index];
                push @candidates, join q{}, @copy;
            }

            foreach my $index (1 .. $#chars) {
                my @copy = @chars;
                splice @copy, $index, 0, q{-};
                push @candidates, join q{}, @copy;
            }

            return @candidates;
        };

        $is_transposition = sub {
            my ($source, $candidate) = @_;

            return 0 if length $source != length $candidate;

            my @source_chars = split //msx, $source;
            my @candidate_chars = split //msx, $candidate;
            my @diff;

            foreach my $index (0 .. $#source_chars) {
                if ($source_chars[$index] ne $candidate_chars[$index]) {
                    push @diff, $index;
                }
            }

            return 0 if @diff != 2;

            return $source_chars[$diff[0]] eq $candidate_chars[$diff[1]]
                && $source_chars[$diff[1]] eq $candidate_chars[$diff[0]];
        };

        $single_substitution_distance = sub {
            my ($source, $candidate) = @_;

            return 0 if length $source != length $candidate;

            my @source_chars = split //msx, $source;
            my @candidate_chars = split //msx, $candidate;
            my $distance = 0;

            foreach my $index (0 .. $#source_chars) {
                if ($source_chars[$index] ne $candidate_chars[$index]) {
                    $distance++;
                }
            }

            return $distance == 1 ? 1 : 0;
        };

        $mutation_reason = sub {
            my ($source, $candidate) = @_;

            if (length($candidate) == length($source) - 1) {
                return 'deletion';
            }

            if (length($candidate) == length($source) + 1) {
                return index($candidate, q{-}) != $INDEX_NOT_FOUND ? 'hyphenation' : 'duplication';
            }

            if ($is_transposition -> ($source, $candidate)) {
                return 'transposition';
            }

            if ($single_substitution_distance -> ($source, $candidate)) {
                return 'keyboard_or_lookalike_substitution';
            }

            return 'permutation';
        };

        $risk_score = sub {
            my ($similarity, $entropy_delta, $reason, $is_unavailable) = @_;
            my %reason_weight = (
                deletion                            => 22,
                duplication                         => 18,
                transposition                       => 18,
                keyboard_or_lookalike_substitution  => 16,
                hyphenation                         => 10,
                permutation                         => 5,
            );

            my $score = int(($similarity * $SIMILARITY_SCORE_WEIGHT) + (($reason_weight{$reason} || 0)));
            if ($entropy_delta <= $LOW_ENTROPY_DELTA_THRESHOLD) {
                $score += $LOW_ENTROPY_DELTA_SCORE_BONUS;
            }
            if ($is_unavailable) {
                $score += $UNAVAILABLE_SCORE_BONUS;
            }
            if ($score > $MAXIMUM_SCORE) {
                $score = $MAXIMUM_SCORE;
            }

            return $score;
        };

        $reason_rank = sub {
            my ($reason) = @_;
            my %rank = (
                deletion                            => 6,
                duplication                         => 5,
                transposition                       => 4,
                keyboard_or_lookalike_substitution  => 3,
                hyphenation                         => 2,
                permutation                         => 1,
            );

            return $rank{$reason} || 0;
        };

        $risk_level = sub {
            my ($score) = @_;

            if ($score >= $HIGH_RISK_SCORE) {
                return 'high';
            }

            if ($score >= $MEDIUM_RISK_SCORE) {
                return 'medium';
            }

            return 'low';
        };

        $split_domain = sub {
            my ($input) = @_;
            my $host = Spellbook::Helper::Host_Normalization -> new(['--target' => $input]);

            return if !$host || $host !~ /[.]/msx;

            my ($label, $suffix) = $host =~ /\A([^.]+)[.](.+)\z/msx;

            return ($label, $suffix);
        };

        $resolves = sub {
            my ($domain_name) = @_;
            my $resolved = Spellbook::Recon::Host_Resolv -> new(['--target' => $domain_name]);

            return $resolved ? 1 : 0;
        };

        $resolve = grep { $_ } $resolve, $monitor, $available_only, $unavailable_only;

        my ($label, $suffix) = $split_domain -> ($domain);

        return 0 if !$label || !$suffix;

        my @candidates = $close_candidates -> ($label);
        push @candidates, Spellbook::Helper::Permutations -> new([
            '--value'  => $label,
            '--repeat' => $repeat,
        ]);

        my $source_entropy = $entropy_of -> ($label);

        my @rows;

        foreach my $candidate (
            uniq
            grep { $valid_label -> ($_) }
            grep { $_ ne $label }
            grep { $_ } @candidates
        ) {

            my $similarity = $similarity_of -> ($label, $candidate);
            my $entropy_delta = abs $entropy_of -> ($candidate) - $source_entropy;

            next if $similarity < $minimum_similarity || $entropy_delta > $max_entropy_delta;

            my $permutation = $candidate . q{.} . $suffix;
            my $is_unavailable = $resolve ? $resolves -> ($permutation) : 0;
            my $status = $is_unavailable ? 'unavailable' : 'available';
            my %skip_status = (
                available   => $unavailable_only,
                unavailable => $available_only,
            );

            next if $skip_status{$status};

            if (!$monitor) {
                my $output = $resolve ? $permutation . "\t" . $status : $permutation;
                push @result, $output;

                last if @result >= $limit;
                next;
            }

            my $reason = $mutation_reason -> ($label, $candidate);
            my $score  = $risk_score -> (
                $similarity,
                $entropy_delta,
                $reason,
                $is_unavailable,
            );

            push @rows, {
                domain        => $permutation,
                status        => $status,
                status_rank   => $is_unavailable ? 1 : 0,
                risk          => $risk_level -> ($score),
                score         => $score,
                sort_key      => sprintf(
                    '%03d%03d%010.6f%010.6f%03d%s',
                    1 - ($is_unavailable ? 1 : 0),
                    $MAXIMUM_SCORE - $score,
                    1 - $similarity,
                    $entropy_delta,
                    $MAXIMUM_SCORE - $reason_rank -> ($reason),
                    $permutation,
                ),
                similarity    => $similarity,
                entropy_delta => $entropy_delta,
                reason        => $reason,
                reason_rank   => $reason_rank -> ($reason),
            };
        }

        @rows = sort {
            $a -> {sort_key} cmp $b -> {sort_key}
        } @rows;

        foreach my $row (@rows) {
            push @result, join "\t",
                $row -> {domain},
                $row -> {status},
                $row -> {risk},
                $row -> {score},
                sprintf('%.2f', $row -> {similarity}),
                sprintf('%.2f', $row -> {entropy_delta}),
                $row -> {reason};

            last if @result >= $limit;
        }

        return @result;
    }
}

1;
