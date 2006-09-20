#!/usr/bin/php
<?php
// randcap: filter to randomly capitalize 20% of the letters
function randcase($word) {
  return rand(0, 100) < 20 ? ucfirst($word) : lcfirst($word);
}
function lcfirst($word) {
  return strtolower(substr($word, 0, 1)) . substr($word, 1);
}
while (!feof(STDIN)) {
  print preg_replace("/(\w)/e", "randcase('\\1')", fgets(STDIN));
}