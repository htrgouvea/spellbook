package Spellbook::Recon::Subdomain_Generator {
    use strict;
    use warnings;
    use Getopt::Long;
    use List::MoreUtils qw(uniq);
    use Mojo::File;

    our $VERSION = '0.0.2';

    use Readonly;
    Readonly my $MAX_DIGIT      => 9;
    Readonly my $MINIMUM_LABELS => 2;
    Readonly my $LAST_INDEX     => -1;

    Readonly my %TWO_LEVEL_SUFFIX => map { $_ => 1 } qw(
        com.br net.br org.br gov.br edu.br art.br blog.br
        co.uk org.uk gov.uk ac.uk me.uk
        com.au net.au org.au gov.au
        co.jp ne.jp or.jp
        co.in gov.in net.in org.in
        com.mx com.ar com.co com.tr com.cn com.sg
    );

    Readonly my @DEFAULT_PATTERNS => (
        '{{word}}.{{root}}',
        '{{word}}-{{sub}}.{{suffix}}',
        '{{sub}}-{{word}}.{{suffix}}',
        '{{word}}.{{sub}}.{{suffix}}',
        '{{sub}}.{{word}}.{{suffix}}',
        '{{sub}}{{word}}.{{suffix}}',
        '{{word}}{{sub}}.{{suffix}}',
        '{{sub}}-{{number}}.{{suffix}}',
        '{{sub}}{{number}}.{{suffix}}',
    );

    Readonly my @DEFAULT_WORDS => qw(
        dev develop staging stage test testing qa uat prod production
        api app apps web portal admin internal corp intranet vpn mail
        git ci cd jenkins gitlab docker k8s beta demo sandbox backup db
    );

    sub _collect_inputs {
        my ($target, $list, $file, $help) = @_;
        my @inputs;

        if ($target) {
            push @inputs, $target;
        }

        if ($list) {
            push @inputs, split /,/xsm, $list;
        }

        if ($file) {
            foreach my $line (split /\r?\n/xsm, Mojo::File -> new($file) -> slurp()) {
                $line =~ s/\A\s+//xsm;
                $line =~ s/\s+\z//xsm;

                if (length $line) {
                    push @inputs, $line;
                }
            }
        }

        if (!@inputs && !$help && ! -t *STDIN) {  ## no critic (InputOutput::ProhibitInteractiveTest)
            while (my $line = <STDIN>) {  ## no critic (InputOutput::ProhibitExplicitStdin)
                $line =~ s/\A\s+//xsm;
                $line =~ s/\s+\z//xsm;

                if (length $line) {
                    push @inputs, $line;
                }
            }
        }

        return @inputs;
    }

    sub _variables {
        my ($labels) = @_;
        my @parts = @{$labels};
        my $etld_size = 1;

        if (@parts > $MINIMUM_LABELS) {
            my $candidate = join q{.}, @parts[-$MINIMUM_LABELS .. $LAST_INDEX];

            if ($TWO_LEVEL_SUFFIX{$candidate}) {
                $etld_size = $MINIMUM_LABELS;
            }
        }

        my $root_size = $etld_size + 1;

        my %vars = (
            sub    => $parts[0],
            suffix => join(q{.}, @parts[1 .. $#parts]),
            tld    => $parts[$LAST_INDEX],
            etld   => join(q{.}, @parts[-$etld_size .. $LAST_INDEX]),
        );

        if (@parts >= $root_size) {
            $vars{root} = join q{.}, @parts[-$root_size .. $LAST_INDEX];
            $vars{sld}  = $parts[-$root_size];
        }

        if (@parts < $root_size) {
            $vars{root} = join q{.}, @parts;
            $vars{sld}  = $parts[0];
        }

        foreach my $index (0 .. $#parts) {
            $vars{'sub' . ($index + 1)} = $parts[$index];
        }

        return \%vars;
    }

    sub _words {
        my ($inputs, $words_csv, $enrich) = @_;
        my @word_list;

        if ($words_csv) {
            push @word_list, split /,/xsm, $words_csv;
        }

        if ($enrich) {
            foreach my $input (@{$inputs}) {
                my @labels = split /[.]/xsm, $input;

                if (@labels > $MINIMUM_LABELS) {
                    foreach my $label (@labels[0 .. $#labels - $MINIMUM_LABELS]) {
                        push @word_list, split /-/xsm, $label;
                    }
                }
            }
        }

        @word_list = uniq @word_list;

        if (!@word_list) {
            @word_list = @DEFAULT_WORDS;
        }

        return @word_list;
    }

    sub _expand {
        my ($base, $sources) = @_;
        my @expanded = ($base);

        foreach my $source (@{$sources}) {
            my ($token, $values) = @{$source};
            my @next_expanded;

            foreach my $string (@expanded) {
                if (index($string, "{{$token}}") < 0) {
                    push @next_expanded, $string;
                }

                if (index($string, "{{$token}}") >= 0) {
                    foreach my $value (@{$values}) {
                        (my $copy = $string) =~ s/\Q{{$token}}\E/$value/gxsm;
                        push @next_expanded, $copy;
                    }
                }
            }

            @expanded = @next_expanded;
        }

        return @expanded;
    }

    sub _generate {
        my ($inputs, $patterns, $sources) = @_;
        my @result;

        foreach my $input (@{$inputs}) {
            my @labels = split /[.]/xsm, lc $input;

            if (@labels < $MINIMUM_LABELS) {
                next;
            }

            my $vars = _variables(\@labels);

            foreach my $pattern (@{$patterns}) {
                my $base = $pattern;

                foreach my $key (keys %{$vars}) {
                    my $replacement = $vars -> {$key};
                    $base =~ s/\Q{{$key}}\E/$replacement/gxsm;
                }

                foreach my $candidate (_expand($base, $sources)) {
                    if ($candidate !~ /[{][{].*?[}][}]/xsm) {
                        push @result, $candidate;
                    }
                }
            }
        }

        return @result;
    }

    sub new {
        my ($self, $parameters) = @_;
        my ($help, $target, $list, $file, $words, $enrich, $limit, @patterns, @result);

        my $parser = Getopt::Long::Parser -> new (
            config => [qw(no_ignore_case pass_through)]
        );

        $parser -> getoptionsfromarray (
            $parameters,
            'h|help'       => \$help,
            't|target=s'   => \$target,
            'list=s'       => \$list,
            'f|file=s'     => \$file,
            'p|pattern=s@' => \@patterns,
            'w|word=s'     => \$words,
            'e|enrich'     => \$enrich,
            'l|limit=i'    => \$limit
        );

        my @inputs = _collect_inputs($target, $list, $file, $help);

        if (!@inputs) {
            if ($help) {
                return "\n"
                    . "Recon::Subdomain_Generator\n"
                    . "=====================\n"
                    . "-h, --help      See this menu\n"
                    . "-t, --target    A single subdomain to permute\n"
                    . "    --list      Comma-separated subdomains to permute\n"
                    . "-f, --file      File with subdomains to permute (one per line; also reads STDIN)\n"
                    . "-p, --pattern   Permutation pattern (repeatable); vars: {{sub}} {{suffix}} {{tld}} {{sld}} {{root}} {{subN}} {{word}} {{number}}\n"
                    . "-w, --word      Comma-separated words for {{word}}\n"
                    . "-e, --enrich    Derive {{word}} values from the input subdomains\n"
                    . "-l, --limit     Limit the number of results\n\n";
            }

            return 0;
        }

        if (!@patterns) {
            @patterns = @DEFAULT_PATTERNS;
        }

        my @word_list = _words(\@inputs, $words, $enrich);
        my @multi_sources = (
            ['word',   \@word_list],
            ['number', [0 .. $MAX_DIGIT]],
        );

        @result = uniq _generate(\@inputs, \@patterns, \@multi_sources);

        if ($limit && @result > $limit) {
            @result = @result[0 .. $limit - 1];
        }

        return @result;
    }
}

1;
