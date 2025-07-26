package Spellbook::Cloud::Account_Identifier {
    use strict;
    use warnings;
    use MIME::Base32 qw(decode_base32);
    use Math::BigInt;

    our $VERSION = '0.0.1';

    sub new {
        my ($self, $parameters) = @_;
        my ($help, $key);

        Getopt::Long::GetOptionsFromArray (
            $parameters,
            'h|help'  => \$help,
            'k|key=s' => \$key
        );
            
        if ($key) {
            my $trimmed_AWSKeyID = substr($key, 4);
            my $decoded          = decode_base32($trimmed_AWSKeyID);
            
            my $decoded_prefix = substr($decoded, 0, 6);
            my $bigint_value = Math::BigInt -> new('0x' . unpack("H*", $decoded_prefix));
            
            my $mask      = Math::BigInt -> new('0x7fffffffff80');
            my $accountID = ($bigint_value & $mask) >> 7;

            return $accountID;
        }

        if ($help) {
            return "
                \rCloud::Account_Identifier
                \r==============
                \r-h, --help       See this menu
                \r-k, --key        Provides the AWS key for extracting the account ID.\n\n";
        }
        
        return 0;
    }    
}

1;