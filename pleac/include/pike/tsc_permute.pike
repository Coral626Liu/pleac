#!/usr/bin/pike

void main()
{
  string line;
  while(line=Stdio.stdin->gets())
  {
    permute(line/" ");
  }
}

void permute(array items, array|void perms)
{
  if(!perms)
    perms=({});
  if(!sizeof(items))
    write((perms*" ")+"\n");
  else
  {
    foreach(items; int i;)
    {
      array newitems=items[..i-1]+items[i+1..];
      array newperms=items[i..i]+perms;
      permute(newitems, newperms);
    }
  }
}
