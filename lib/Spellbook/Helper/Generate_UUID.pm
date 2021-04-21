package Spellbook::Helper::Generate_UUID {
    use strict;
    use warnings;
    use UUID::Tiny ':std';

    sub new {
        my ($self, $value, $param) = @_; 
        my @results = ();

        if ($value) {
            my $versions = {
                v1 => "UUID_V1",
                v2 => "UUID_V2",
                v3 => "UUID_V3",
                v4 => "UUID_V4",
                v5 => "UUID_V5"
            };
            
            my $generate = create_uuid_as_string($versions -> {$value});
            # print $generate, "\n";
        }

        return @results;
    }
}

1;