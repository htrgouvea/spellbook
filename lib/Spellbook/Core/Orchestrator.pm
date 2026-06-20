package Spellbook::Core::Orchestrator {
    use strict;
    use threads;
    use warnings;
    use Readonly;
    use Getopt::Long;
    use Thread::Queue;
    use threads::shared;
    use Mojo::File;

    our $VERSION = '0.0.3';

    Readonly my $DEFAULT_THREADS    => 10;
    Readonly my $DEFAULT_BATCH_SIZE => 1000;

    sub _flush {
        my ($buffer, $output) = @_;

        if (!@{$buffer}) {
            return 0;
        }

        my $handle = Mojo::File -> new($output) -> open('>>');

        foreach my $line (@{$buffer}) {
            print {$handle} $line, "\n";
        }

        my $count = scalar @{$buffer};

        # Release the already processed results from memory.
        @{$buffer} = ();

        return $count;
    }

    sub new {
        my ($self, $parameters) = @_;
        my ($help, $wordlist, $module, $list, $output);

        my $threads = $DEFAULT_THREADS;
        my $batch   = $DEFAULT_BATCH_SIZE;

        Getopt::Long::GetOptionsFromArray (
            $parameters,
            'h|help'         => \$help,
            't|threads=i'    => \$threads,
            'w|wordlist=s'   => \$wordlist,
            'e|entrypoint=s' => \$module,
            'l|list=s'       => \$list,
            'o|output=s'     => \$output,
            'b|batch=i'      => \$batch
        );

        if ($module) {
            my $queue = Thread::Queue -> new();
            my @results :shared;
            my @buffer  :shared;
            my %seen    :shared;
            my $written :shared = 0;

            # In streaming mode start the output file fresh so a run never
            # mixes its results with data left over from a previous one.
            if ($output) {
                Mojo::File -> new($output) -> spurt(q{});
            }

            if ($wordlist) {
                async {
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
                $queue -> enqueue(@{$list});
                $queue -> end();
            }

            for (1 .. $threads) {
                async {
                    while (defined(my $target = $queue -> dequeue())) {
                        my @response = Spellbook::Core::Module -> new (
                            $module, [ '--target' => $target, @{$parameters} ]
                        );

                        lock(%seen);

                        foreach my $result (@response) {
                            if (exists $seen{$result}) {
                                next;
                            }

                            $seen{$result} = 1;

                            if ($output) {
                                push @buffer, $result;
                            }
                            else {
                                push @results, $result;
                            }
                        }

                        # Periodically persist processed results to disk and
                        # free the in-memory buffer.
                        if ($output && @buffer >= $batch) {
                            $written += _flush(\@buffer, $output);
                        }
                    }
                };
            }

            while (threads -> list(threads::running) > 0) {
                foreach my $thread (threads -> list(threads::all)) {
                    $thread -> join();
                }
            }

            if ($output) {
                $written += _flush(\@buffer, $output);

                return "\n[+] $written results written to $output\n";
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
                . "    -e, --entrypoint    Module to execute\n"
                . "    -o, --output        Stream results to a file, freeing memory\n"
                . "    -b, --batch         Results buffered before each flush to disk\n\n";
        }

        return 0;
    }
}

1;
