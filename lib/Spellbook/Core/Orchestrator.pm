package Spellbook::Core::Orchestrator {
    use strict;
    use threads;
    use warnings;
    use Readonly;
    use Getopt::Long;
    use Thread::Queue;
    use threads::shared;
    use Mojo::File;

    our $VERSION = '0.0.2';

    Readonly my $DEFAULT_THREADS => 10;

    sub new {
        my ($self, $parameters) = @_;
        my ($help, $wordlist, $module, $list);

        my $threads = $DEFAULT_THREADS;

        Getopt::Long::GetOptionsFromArray (
            $parameters,
            'h|help'         => \$help,
            't|threads=i'    => \$threads,
            'w|wordlist=s'   => \$wordlist,
            'e|entrypoint=s' => \$module,
            'l|list=s'       => \$list
        );

        if ($module) {
            my $queue = Thread::Queue -> new();
            my @results :shared;
            my %seen :shared;

            if ($wordlist) {
                async {
                    my $handle = Mojo::File -> new($wordlist) -> openr();

                    while (defined(my $line = $handle -> getline())) {
                        chomp $line;

                        if (length $line) {
                            $queue -> enqueue($line);
                        }
                    }

                    $queue -> end();
                };
            }

            if (!$wordlist) {
                $queue -> enqueue(@{$list});
                $queue -> end();
            }

            for (1 .. $threads) {
                async {
                    while (defined(my $target = $queue -> dequeue())) {
                        my @response = Spellbook::Core::Module -> new (
                            $module, [ '--target' => $target, @$parameters ]
                        );

                        lock(@results);

                        if (@response) {
                            foreach my $result (@response) {
                                if (!exists $seen{$result}) {
                                    $seen{$result} = 1;
                                    push @results, $result;
                                }
                            }
                        }
                    }
                };
            }

            while (threads -> list(threads::running) > 0) {
                foreach my $thread (threads -> list(threads::all)) {
                    $thread -> join();
                }
            }

            return @results;
        }

        if ($help) {
            return "
                \rCore::Orchestrator
                \r==============
                \r\t-h, --help          See this menu
                \r\t-t, --threads       Number of threads
                \r\t-w, --wordlist      Wordlist file
                \r\t-e, --entrypoint    Module to execute\n\n";
        }

        return 0;
    }
}

1;