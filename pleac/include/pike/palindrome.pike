#!/usr/bin/pike
// chapter 1.6
void main(int argc, array(string) argv)
{
  string data=Stdio.read_file(argv[1]);
  foreach(data/"\n", string line)
  {
    if(line==reverse(line) && sizeof(line)>5)
    write("%s\n", line);
  }
}
