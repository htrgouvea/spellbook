package Spellbook::Helper::CDN_Checker {
    use strict;
    use warnings;
    use JSON;
    use Net::IP;
    use Spellbook::Core::UserAgent;
    use Spellbook::Recon::Get_IP;

    sub new {
            my ($self, $parameters) = @_;
            my ($help, $target, @result);

            Getopt::Long::GetOptionsFromArray (
                $parameters,
                "h|help"     => \$help,
                "t|target=s" => \$target
            );

            return <<"EOT" if $help;

Helper::CDN_Checker
=====================
-h, --help     See this menu
-t --target    Define a target\n\n";

EOT

            return 0 unless $target;

            my $ip = Spellbook::Recon::Get_IP -> new (["--target" => $target]);
            return 0 unless $ip;

            my $cnd_list  = "https://raw.githubusercontent.com/projectdiscovery/cdncheck/main/cmd/generate-index/sources_data.json";
            my $useragent = Spellbook::Core::UserAgent -> new ();
            my $request   = $useragent -> get($cnd_list);

            return 0 unless $request->code == 200;

            my $data    = decode_json($request -> content);
            my $content = $data -> {"cdn"}; # we have others options

            my $target_ip = Net::IP->new($ip);

            for my $provider (keys %{$content}) {
                for my $range (@{$content->{$provider}}) {
                    my $cdn_range = Net::IP->new($range);
                    if ($cdn_range->overlaps($target_ip)) {
                        push @result, $target;
                        return @result;
                    }
                }
            }

            return @result;
        }
}

1;