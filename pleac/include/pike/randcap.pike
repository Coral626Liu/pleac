#!/usr/bin/pike
// randcap: filter to randomly capitalize 20% of the letters

void main()
{
  string input;
  while(input=Stdio.stdin.read(1))
    write(randcap(input));
}

string randcap(string char)
{
  if(random(100)<20)
    char=String.capitalize(char);
  return char;
}
