#!/usr/bin/pike
// chapter 1.12
// wrapdemo - show how wrapping with sprintf works
void main()
{
  array(string) input = ({ "Folding and splicing is the work of an editor,",
                           "not a mere collection of silicon",
                           "and",
                           "mobile electrons!"});
  int columns = 20;

  write("0123456789"*2+"\n");
  write(wrap(input*" ", 20, "  ", "  ")+"\n");
}

// unlike the perl version here leadtab is relative to nexttab, 
// to get a shorter lead use a negative int value. this allows the default of 0
// to be a lead indent that is the same as nexttab, and it also has the
// advantage of allowing you to change the indent without having to worry about
// the lead getting messed up.
// a negative lead will cut away from the nexttab which will be visible if you
// use something other than spaces
string wrap(string text, void|int width, 
            void|string|int nexttab, void|string|int leadtab)
{
  string leadindent="";
  string indent=""; 
  string indent2="";

  if(!width)
    width=Stdio.stdout->tcgetattr()->columns;

  if(stringp(nexttab))
  {
    indent=nexttab;
    width-=sizeof(nexttab);  // this will be off if there are chars that have a
                             // different width than 1.
  }
  else if(intp(nexttab))
  {
    indent=" "*nexttab;
    width-=nexttab;
  }

  if(stringp(leadtab))
    leadindent=leadtab;
  else if(intp(leadtab))
    if(leadtab > 0)
      leadindent=" "*leadtab;
    else if(leadtab < 0)
    {
      write(indent+".\n");
      indent=indent[..(sizeof(indent)+leadtab)-1];
      write(indent+".\n");
      indent2=text[..-leadtab-1]; 
      text=text[-leadtab..];
    }
  return sprintf("%^s%=*s%-=*s", indent, sizeof(indent2), indent2, 
                                 width, leadindent+text);
}
