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

$config = array();
foreach (preg_split("/\n/", $data) as $pair) {
  list($in, $out) = preg_split("/\s*=>\s*/", trim($pair));
  if (!$in || !$out) continue;
  $config[$in] = $out;
}

$ln = 1;
while (!feof($input)) {
  $i = 0;
  preg_match("/^(\s*)(.*)/", fgets($input), $matches); // emit leading whitespace
  fwrite($output, $matches[1]);
  foreach (preg_split("/(\s+)/", $matches[2], -1, PREG_SPLIT_DELIM_CAPTURE) as $token) { // preserve trailing whitespace
    fwrite($output, ($i++ & 1) ? $token : (array_key_exists($token, $config) ? $config[$token] : $token));
  }
}