#!/usr/bin/php
<?php
$data = <<<DATA
  analysed=> analyzed
  built-in=> builtin
  chastized   => chastised
  commandline => command-line
  de-allocate => deallocate
  dropin  => drop-in
  hardcode=> hard-code
  meta-data   => metadata
  multicharacter  => multi-character
  multiway=> multi-way
  non-empty   => nonempty
  non-profit  => nonprofit
  non-trappable   => nontrappable
  pre-define  => predefine
  preextend   => pre-extend
  re-compiling=> recompiling
  reenter => re-enter
  turnkey => turn-key
DATA;

$scriptName = $argv[0];
$verbose = ($argc > 1 && $argv[1] == "-v" && array_shift($argv));
$change = array();
foreach (preg_split("/\n/", $data) as $pair) {
  list($in, $out) = preg_split("/\s*=>\s*/", trim($pair));
  if (!$in || !$out) continue;
  $change[$in] = $out;
}
if (count($argv) > 1)  {
  // no in-place edit in PHP
  // preserve old files
  $orig = $argv[1] . ".orig";
  copy($argv[1], $orig);
  $input = fopen($orig, "r");
  $output = fopen($argv[1], "w");
} else if ($scriptName != "-") {
  $input = STDIN;
  trigger_error("$scriptName: Reading from stdin\n", E_USER_WARNING);
}
$ln = 1;
while (!feof($input)) {
  $line = fgets($input);
  foreach ($change as $in => $out) {
    $line = preg_replace("/$in/", $out, $line, -1, $count);
    if ($count > 0 && $verbose) {
      fwrite(STDERR, "$in => $out at $argv[1] line $ln.\n");
    }
  }
  @fwrite($output, $line);
  $ln++;
}