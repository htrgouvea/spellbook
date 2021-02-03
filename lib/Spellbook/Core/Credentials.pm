package Spellbook::Core::Credentials {
    use strict;
    use warnings;
    use Mojo::File;
    use Mojo::JSON qw(decode_json);

    sub new {
        my ($self, $platform) = @_;
        my $credentials = Mojo::File -> new(".config/credentials.json");
        my $read = $credentials -> slurp();
        my $content = decode_json($read);

        return $content -> {$platform};
    }
}



1;