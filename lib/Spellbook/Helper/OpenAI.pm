package Spellbook::Helper::OpenAI {
    use strict;
    use warnings;
    use OpenAI::API;
    use Spellbook::Core::Credentials;

    our $VERSION = '0.0.2';

    use Readonly;
    Readonly my $DEFAULT_MODEL => 'gpt-4o-mini';

    sub new {
        my ($self, $parameters) = @_;
        my ($help, $prompt, $model, @result);

        Getopt::Long::GetOptionsFromArray (
            $parameters,
            'h|help'     => \$help,
            'p|prompt=s' => \$prompt,
            'model=s'    => \$model
        );

        if ($prompt) {
            my $api_key = Spellbook::Core::Credentials -> new(['--platform' => 'openai']);

            if (!$api_key) {
                return "\n[!] No OpenAI API key found. Store one with: spellbook.pl -m Core::Credentials -p openai -v <key>\n\n";
            }

            my $selected_model = $DEFAULT_MODEL;

            if ($model) {
                $selected_model = $model;
            }

            my $openai = OpenAI::API -> new('api_key' => $api_key);

            my $response = $openai -> chat (
                'model'    => $selected_model,
                'messages' => [{'role' => 'user', 'content' => $prompt}]
            );

            my $content = $response -> {'choices'} -> [0] -> {'message'} -> {'content'};

            if ($content) {
                push @result, $content;
            }

            return @result;
        }

        if ($help) {
            return "\n"
                . "Helper::OpenAI\n"
                . "=====================\n"
                . "-h, --help     See this menu\n"
                . "-p, --prompt   Prompt text to send to the OpenAI chat API\n"
                . "    --model    Model to use (default: gpt-4o-mini)\n\n";
        }

        return 0;
    }
}

1;
