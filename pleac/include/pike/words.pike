#!/usr/bin/pike
// section 4.18 example 4.2
// words - gather lines, present in columns

void main()
{
  array words=Stdio.stdin.read()/"\n";   // get all input
  int maxlen=sort(sizeof(words[*]))[-1]; // sort by size and pick the largest
  maxlen++;                              // add space

  // get boundaries, this should be portable
  int cols = Stdio.stdout->tcgetattr()->columns/maxlen;
  int rows = (sizeof(words)/cols) + 1;

  string mask="%{%-"+maxlen+"s%}\n";     // compute format

  words=Array.transpose(words/rows);     // split into groups as large as the
                                         // number of rows and then transpose
  write(mask, words[*]);                 // apply mask to each group
}

