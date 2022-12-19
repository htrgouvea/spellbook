package Spellbook::Helper::HackerOne_Scraper {
    use strict;
    use warnings;
    use LWP::UserAgent;
    use Spellbook::Core::Credentials;
    
    # THIS IS A DRAFT MODULE
    
    sub new {
        my ($self, $parameters)= @_;
        my ($help, $target, @result);

        Getopt::Long::GetOptionsFromArray (
            $parameters,
            "h|help"     => \$help,
            "t|target=i" => \$target
        );

        my $token = Spellbook::Core::Credentials -> new(["--platform" => "hackerone"]);

        if ($token) {
            my $userAgent = LWP::UserAgent -> new();
            
            # curl "https://api.hackerone.com/v1/me/programs" -X GET -u "<YOUR_API_USERNAME>:<YOUR_API_TOKEN>" -H 'Accept: application/json'
            # curl "https://api.hackerone.com/v1/programs/{id}/structured_scopes" -X GET -u "<YOUR_API_USERNAME>:<YOUR_API_TOKEN>" -H 'Accept: application/json'
        }

        if ($help) {
            return "
                \rHelper::HackerOne_Scraper
                \r=====================
                \r-h, --help     See this menu
                \r-t, --target   Program ID from HackerOne\n\n";
        }

        return 0;
    }
}   

1;


use lib './lib';
use Mojo::JSON qw(encode_json);
use HackerOne;

my $h1 = HackerOne -> new(token => 'H1-TOKEN', user => "H1-user");
my $next = $h1 -> programs();

while (my $programs = $next -> ()) {
    for my $program (map { $_ -> {attributes} } $programs -> @*) {
        if ($program -> {offers_bounties}) {
            mkdir(my $dir = "programs/$program->{handle}");
            open(my $scope, ">$dir/scope.json");
            print $scope encode_json($h1 -> get_scope($program -> {handle})), "\n";
            close($scope);
        }
    }
}

#print encode_json($h1->get_program("uber")), "\n";
#print encode_json($h1->get_scope("uber", "URL")), "\n";

package HackerOne {
    use Mojo::URL;
    use MIME::Base64;
    use Mojo::UserAgent;

    sub new {
        my ($self, %args) = @_;
        bless {
            user    => $args{user},
            token   => $args{token},
            agent   => Mojo::UserAgent->new(),
        }, $self
    }

    sub agent {
        $_[0] -> {agent}
    }

    sub auth {
        my ($self) = @_;
        "Basic " . encode_base64($self -> {user} . ":" . $self -> {token}, "")
    }

    sub get {
        my ($self, $endpoint) = @_;
        my $url = ($endpoint =~ /^https:\/\//) ? $endpoint : "https://api.hackerone.com/v1/$endpoint";

        $self -> agent -> get(
             $url => {
                Accept        => 'application/json',
                Authorization => $self -> auth()
            }
        ) -> result -> json
    }

    sub programs {
        my ($self) = @_;
        my $next = 'hackers/programs';

        return sub {
            return undef unless $next;
            my $result = $self -> get($next);

            $next = $result -> {links} -> {next};
            $result -> {data}
        }
    }

    sub get_program {
        my ($self, $handle) = @_;

        $self -> get("hackers/programs/$handle")
    }

    sub get_scope {
        my ($self, $handle, $type) = @_;
        my $scope = $self -> get_program($handle) -> {relationships} -> {structured_scopes} -> {data};

        [
            grep {
                !defined($type) || $_ -> {asset_type} eq $type
            } map {
                $_ -> {attributes}
            }
            
            $scope -> @*
        ]
    }
}