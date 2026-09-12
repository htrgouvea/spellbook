package Spellbook::Core::Orchestrator {
    use strict;
    use threads;
    use warnings;
    use Readonly;
    use Getopt::Long;
    use Thread::Queue;
    use threads::shared;
    use Mojo::File;
    use Spellbook::Core::Module;
    use Spellbook::Core::Resources;

    our $VERSION = '0.0.4';

    Readonly my $DEFAULT_THREADS => 10;
    Readonly my $QUEUE_CAPACITY_PER_THREAD => 4;

    sub new {
        my ($self, $parameters) = @_;
        my ($help, $wordlist, $module, $list);

        my $threads = $DEFAULT_THREADS;

        my $parser = Getopt::Long::Parser -> new (
            config => [qw(no_ignore_case pass_through)]
        );

        $parser -> getoptionsfromarray (
            $parameters,
            'h|help'         => \$help,
            't|threads=i'    => \$threads,
            'w|wordlist=s'   => \$wordlist,
            'e|entrypoint=s' => \$module,
            'l|list=s'       => \$list
        );

        if ($module) {
            Spellbook::Core::Resources -> new();

            if ($threads < 1) {
                $threads = 1;
            }

            my $queue = Thread::Queue -> new();
            $queue -> limit = $threads * $QUEUE_CAPACITY_PER_THREAD;

            my @results :shared;
            my %seen :shared;
            my @workers;

            for (1 .. $threads) {
                push @workers, async {
                    while (defined(my $target = $queue -> dequeue())) {
                        # A module that dies must not take its worker with it.
                        # The queue is bounded, so a worker that stops draining
                        # blocks the producer forever.
                        my @response = eval {
                            Spellbook::Core::Module -> new (
                                $module, [ '--target' => $target, @{$parameters} ]
                            );
                        };

                        lock(@results);

                        foreach my $result (@response) {
                            if (exists $seen{$result}) {
                                next;
                            }

                            $seen{$result} = 1;
                            push @results, $result;
                        }
                    }
                };
            }

            my $producer;

            if ($wordlist) {
                $producer = async {
                    my $handle = Mojo::File -> new($wordlist) -> open('<');

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
                my @targets;

                if (ref $list eq 'ARRAY') {
                    @targets = @{$list};
                }

                if (defined $list && !ref $list) {
                    @targets = split /,/msx, $list;
                }

                if (@targets) {
                    $queue -> enqueue(@targets);
                }

                $queue -> end();
            }

            if ($producer) {
                $producer -> join();
            }

            foreach my $worker (@workers) {
                $worker -> join();
            }

            return @results;
        }

        if ($help) {
            return "\n"
                . "Core::Orchestrator\n"
                . "==============\n"
                . "    -h, --help          See this menu\n"
                . "    -t, --threads       Number of threads\n"
                . "    -w, --wordlist      Wordlist file\n"
                . "    -l, --list          Comma-separated targets, used when no wordlist is given\n"
                . "    -e, --entrypoint    Module to execute\n\n";
        }

        return 0;
    }
}

1;
