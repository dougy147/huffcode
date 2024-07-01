#Uncomment next line when using as conventional module
#package Huffman;

sub make_tuple {
    #      [ frequency , char ]
    # e.g. [ 0.2 , "a" ]
    return [$_[0], $_[1]]
}

sub make_node {
    # node = [ freq_sum, left/right branch node ]
    #   e.g. [0.2, {'left' => [0.1, "x"], 'right' => node }]
    if (!exists $_[1]) {
	# Single argument = leaf
	return $_[0]
    } else {
	return [
	    $_[0][0] + $_[1][0], # frequency of the node
	    {
		left  => $_[0],  # values of each branch of node
		right => $_[1],
	    }
	]
    }
}

sub string_to_freq_tuples {
    # Returns freq tuples given an input.
    # e.g. "hello" => ([0.2, "h"], [0.2, "e"] ... )
    my $str     = shift;
    my $str_len = length $str;
    my %table;
    for my $char (split //, $str) {
	(! exists $table{$char}) ? $table{$char} = 1 : $table{$char}++;
    }
    my @freqs;
    for (keys %table) {
	push(@freqs, make_tuple $table{$_} /= $str_len, $_);
    }
    return @freqs;
}

sub sort_freq_list {
    # in ascending order
    my ($array_ref) = shift;
    my $l = scalar @{$array_ref}; # size of reference array
    for my $i (0..$l - 1 - 1) {
	for my $j ($i..$l - 1) {
	    if ($array_ref->[$j][0] <= $array_ref->[$i][0]) {
		my $swap = $array_ref->[$j];
		$array_ref->[$j] = $array_ref->[$i];
		$array_ref->[$i] = $swap;
	    }
	}
    }
}

sub print_tree {

    sub print_at_depth {
	my ($node, $depth, $acc) = @_;
	my $node_freq = $node->[0];
	print "\t"x($depth) . "Node ($node_freq)\n";

	if (ref $node->[1] eq "HASH") {
	    # then not a leaf
	    print_at_depth ($node->[1]{'left'}, $depth+1, $acc . "0");
	    print_at_depth ($node->[1]{'right'}, $depth+1, $acc . "1");
	} else {
	    # then it is a leaf
	    my $node_char = $node->[1];
	    print "\t"x($depth+1) . "($node_freq, $node_char, $acc)\n";
	}
    }

    my (@tree) = @_;
    print_at_depth ($tree[0], 0, "");
}

sub make_tree {
    my ($queue) = @_;
    my @tree;

    while (1) {
	if (scalar @{$queue} == 1) {
    	    push(@tree, make_node $queue->[0]);
    	    last;
    	} else {
    	    my $left  = shift @{$queue};
    	    my $right = shift @{$queue};
    	    push(@{$queue}, make_node $left, $right);
	    sort_freq_list $queue;
    	}
    }
    return @tree;
}

sub traverse_tree {
    my ($node, $depth, $acc, $huff_map) = @_;
    my $node_freq = $node->[0];

    if (ref $node->[1] eq "HASH") {
	traverse_tree ($node->[1]{'left'}, $depth+1, $acc . "0", $huff_map);
	traverse_tree ($node->[1]{'right'}, $depth+1, $acc . "1", $huff_map);
    } else {
	my $node_char = $node->[1];
	$huff_map->{$node_char} = $acc;
    }
}

sub huffman_code {
    my (@tree) = @_;
    my %huffman_table;
    traverse_tree @tree, 0, "", \%huffman_table;
    return %huffman_table;
}

sub print_encoding_table {
    my (%huff_table) = @_;

    # Pretty print (superfluous)
    my ($max_key, $max_val) = (0,0);
    for (keys %huff_table) { $max_key = length $_ > $max_key ? length $_ : $max_key; }
    for (values %huff_table) { $max_val = length $_ > $max_val ? length $_ : $max_val; }

    # Print encoding table
    print "\t+" . "-"x(8 + $max_key + $max_val) . "+\n";
    for (keys %huff_table) {
	my $key_len = length $_;
	my $val_len = length $huff_table{$_};
	print "\t| \"$_\" => " . $huff_table{$_} . (" ")x($max_key+$max_val-$key_len-$val_len) . " |\n";
    }
    print "\t+" . "-"x(8 + $max_key + $max_val) . "+\n";
}

sub print_encoded_input {
    my ($str, %huff_table) = @_;
    for (split //, $str) { print $huff_table{$_} }
    print "\n";
}

1;
