package Spellbook::Helper::Graph {
    use strict;
    use warnings;
    use Getopt::Long;
    use Readonly;
    use Spellbook::Core::Graph;

    our $VERSION = '0.0.9';

    Readonly my $DEFAULT_THREADS => 10;

    sub new {
        my ($self, $parameters) = @_;
        my ($help, $scope, $add, $query, $from, $to, $target, $value, $entrypoint, $attr, $show_attrs, $keep, $tag, $where, $pairs);

        my $threads = $DEFAULT_THREADS;

        my $parser = Getopt::Long::Parser -> new (
            config => [qw(no_ignore_case pass_through)]
        );

        $parser -> getoptionsfromarray (
            $parameters,
            'h|help'          => \$help,
            'S|scope=s'       => \$scope,
            'a|add'           => \$add,
            'q|query'         => \$query,
            'f|from=s'        => \$from,
            't|to=s'          => \$to,
            'target=s'        => \$target,
            'v|value=s'       => \$value,
            'T|threads=i'     => \$threads,
            'e|entrypoint=s'  => \$entrypoint,
            'attr=s@'         => \$attr,
            'attributes'      => \$show_attrs,
            'K|keep'          => \$keep,
            'tag=s'           => \$tag,
            'where=s'         => \$where,
            'pairs'           => \$pairs
        );

        my $attrs = Spellbook::Core::Graph::parse_attrs($attr);

        my %options = (
            from       => $from,
            to         => $to,
            target     => $target,
            value      => $value,
            entrypoint => $entrypoint,
            threads    => $threads,
            attrs      => $attrs,
            keep       => $keep,
            tag        => $tag,
            show_attrs => $show_attrs,
            where      => $where,
            pairs      => $pairs,
        );

        ($options{tag_key},   $options{tag_value})   = $tag   ? split(/=/msx, $tag,   2) : ();
        ($options{where_key}, $options{where_value}) = $where ? split(/=/msx, $where, 2) : ();

        if ($scope && $add && $from) {
            return Spellbook::Core::Graph::run_add($scope, \%options);
        }

        if ($scope && $query) {
            return Spellbook::Core::Graph::run_query($scope, \%options);
        }

        if ($help) {
            return "\n"
                . "Helper::Graph\n"
                . "=====================\n"
                . "-h, --help            See this menu\n"
                . "-S, --scope           Graph JSON file\n"
                . "-a, --add             Add a node or edge\n"
                . "-q, --query           Query the graph\n"
                . "-f, --from            From-node type (user-defined)\n"
                . "-t, --to              To-node type (user-defined)\n"
                . "--target              From-node value (omit to bulk from graph)\n"
                . "-v, --value           To-node value\n"
                . "-T, --threads         Number of threads (default: 10)\n"
                . "-e, --entrypoint      Module to resolve to-node values\n"
                . "-K, --keep            Keep existing values (default replaces them)\n"
                . "    --tag             key=value: tag -f nodes the entrypoint matches\n"
                . "    --pairs           batch entrypoint returning from:to pairs (one run)\n"
                . "    --where           key=value: filter -f nodes by attribute (with -q)\n"
                . "    --attr            key=value attribute (repeatable) for the node/edge\n"
                . "    --attributes      Read attributes instead of edges (with -q)\n";
        }

        return 0;
    }
}

1;
