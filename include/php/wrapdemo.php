#!/usr/bin/php
<?php
// wrapdemo - show how wordwrap works
$input = "Folding and splicing is the work of an editor, " .
         "not a mere collection of silicon " .
         "and " .
         "mobile electrons!";
$columns = 20;
print str_repeat("0123456789", 2) . "\n";
print wordwrap('    ' . $input, $columns - 3, "\n  ") . "\n";