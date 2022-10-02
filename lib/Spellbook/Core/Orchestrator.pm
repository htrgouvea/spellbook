package Spellbook::Core::Orchestrator {
    use strict;
    use threads;
    use warnings;
    use Getopt::Long;
    use Thread::Queue;
    use threads::shared;
    use Spellbook::Helper::Read_File;
    
    sub new {
        my ($self, $parameters) = @_;
        my ($help, $wordlist, $module);

        my $threads   = 10;
        
        Getopt::Long::GetOptionsFromArray (
            $parameters,
            "h|help"         => \$help,
            "t|threads=i"    => \$threads,
            "w|wordlist=s"   => \$wordlist,
            "e|entrypoint=s" => \$module
        );

        if ($module) {
            my $queue = Thread::Queue -> new(Spellbook::Helper::Read_File -> new(["--file", $wordlist]));
            
            $queue -> end();
            my @results :shared;
            
            async {
                while (defined(my $target = $queue -> dequeue())) {
                    my @response = Spellbook::Core::Module -> new (
                        $module,
                        [ "--target" => $target, @$parameters ]
                    );
                    
                    lock(@results);
                    
                    if (@response) {
                        push @results, @response;
                    }
                }
            } 
            
            for 1 .. $threads;

            while (threads -> list(threads::running) > 0) { 
                $_ -> join() for threads -> list(threads::all);
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