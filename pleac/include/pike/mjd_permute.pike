#!/usr/bin/pike

mapping fact=([ 1:1 ]);

int factorial(int n)
{
  if(!fact[n])
    fact[n]=n*factorial(n-1);
  return fact[n];
}

array n2pat(int N, int len)
{
  int i=1;
  array pat=({});

  while(i <= len)
  {
    pat += ({ N%i });
    N/=i;
    i++;
  }
  return pat;
}

array pat2perm(array pat)
{
  array source=indices(pat);
  array perm=({});
  while(sizeof(pat))
  {
    perm += ({ source[pat[-1]] });
    source = source[..pat[-1]-1]+source[pat[-1]+1..];
    pat=pat[..sizeof(pat)-2];
  }
  return perm;
}

array n2perm(int N, int len)
{
  return pat2perm(n2pat(N, len));
}

void main()
{
  array data;
  while(data=Stdio.stdin->gets()/" ")
  {
    int num_permutations = factorial(sizeof(data));
    for(int i; i<num_permutations; i++)
    {
      array permutation = data[n2perm(i, sizeof(data))[*]];
      write(permutation*" "+"\n");
    }
  }
}
