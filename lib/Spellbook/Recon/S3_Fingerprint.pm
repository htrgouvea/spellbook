package Spellbook::Recon::S3_Fingerprint {
    use strict;
    use warnings;
    use Spellbook::Core::UserAgent;
    use Spellbook::Helper::Normalize_Target;

    our $VERSION = '0.0.1';

    use Readonly;
    Readonly my @FINGERPRINTS => (
        { name => 'Amazon S3',                    server => qr/AmazonS3/ixsm },
        { name => 'Microsoft Azure Blob Storage', server => qr/Windows-Azure-Blob/ixsm, headers => ['x-ms-request-id', 'x-ms-version'] },
        { name => 'Google Cloud Storage',         server => qr/UploadServer/ixsm, headers => ['x-guploader-uploadid'] },
        { name => 'Alibaba Cloud OSS',            server => qr/AliyunOSS/ixsm, headers => ['x-oss-request-id'] },
        { name => 'Cloud.ru Advanced (Huawei OBS)', server => qr/\AOBS/ixsm, headers => ['x-obs-request-id', 'x-obs-id-2'] },
        { name => 'Cloud.ru Evolution',           server => qr/Evolution\s+API\s+Gateway/ixsm },
        { name => 'MinIO',                        server => qr/MinIO/ixsm },
        { name => 'LocalStack S3',                server => qr/TwistedWeb/ixsm },
        { name => 'VK Cloud',                     headers => ['x-host', 'x-req-id'] },
        { name => 'OpenStack Swift',              headers => ['x-openstack-request-id', 'x-trans-id'] },
        { name => 'Ceph Object Gateway (RGW)',    headers => ['x-rgw-object-type'], request_id => qr/\Atx[[:xdigit:]]/ixsm },
        { name => 'S3-compatible (unidentified)', headers => ['x-amz-id-2', 'x-amz-request-id'] },
    );

    sub _match_evidence {
        my ($response, $fingerprint) = @_;

        if ($fingerprint -> {server}) {
            my $server = $response -> header('Server') // q{};

            if ($server =~ $fingerprint -> {server}) {
                return "Server: $server";
            }
        }

        foreach my $name (@{$fingerprint -> {headers} // []}) {
            my $value = $response -> header($name);

            if (defined $value) {
                return "$name: $value";
            }
        }

        if ($fingerprint -> {request_id}) {
            my $request_id = $response -> header('x-amz-request-id') // q{};

            if ($request_id =~ $fingerprint -> {request_id}) {
                return "x-amz-request-id: $request_id";
            }
        }

        return q{};
    }

    sub new {
        my ($self, $parameters) = @_;
        my ($help, $target, @result);

        Getopt::Long::GetOptionsFromArray (
            $parameters,
            'h|help'     => \$help,
            't|target=s' => \$target
        );

        if ($target) {
            $target = Spellbook::Helper::Normalize_Target -> new(['--target' => $target]);

            my $user_agent = Spellbook::Core::UserAgent -> new();
            my $response = $user_agent -> get($target);

            foreach my $fingerprint (@FINGERPRINTS) {
                my $evidence = _match_evidence($response, $fingerprint);

                if (length $evidence) {
                    push @result, "$fingerprint->{name} [$evidence]";
                    last;
                }
            }

            return @result;
        }

        if ($help) {
            return "\n"
                . "Recon::S3_Fingerprint\n"
                . "=====================\n"
                . "-h, --help     See this menu\n"
                . "-t, --target   Storage endpoint to fingerprint (identifies the S3-compatible provider)\n\n";
        }

        return 0;
    }
}

1;
