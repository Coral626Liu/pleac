#!/usr/bin/pike
# slowcat - emulate a   s l o w  line printer
# usage: slowcat [-DELAY] [files ...]
void main(int argc, array argv)
{
  array(string) files;
  int delay = 1;

  if(argv[1][0] == '-')
  {
    files = argv[2..];
    delay = (int)argv[1][1..];
  }
  else
    files = argv[1..];

  foreach(files, string file)
  {
    string data = Stdio.read_file(file);
    foreach(data/"", string char)
    {
      write(char);
      sleep(0.005*delay);
    }
  }
}
