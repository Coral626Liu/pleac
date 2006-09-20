#!/usr/bin/php
<?php
// slowcat - emulate a   s l o w   line printer
// usage: php slowcat.php [-DELAY] file
$delay = 1;
if (preg_match('/(.)/', $argv[1], $matches)) {
    $delay = $matches[1];
    array_shift($argv);
};
$handle = @fopen($argv[1], 'r');
while (!feof($handle)) {
    foreach (str_split(fgets($handle)) as $char) {
        print $char;
        usleep(5000 * $delay);
    }
}