#!/usr/bin/pike
// chapter 4.2
// commify_series - show proper comma insertion in list output

array(array(string)) lists =
  ({
    ({ "just one thing" }),
    ({ "Mutt", "Jeff" }),
    ({ "Peter", "Paul", "Mary" }),
    ({ "To our parents", "Mother Theresa", "God" }),
    ({ "pastrami", "ham and cheese", "peanut butter and jelly", "tuna" }),
    ({ "recycle tired, old phrases", "ponder big, happy thoughts" }),
    ({ "recycle tired, old phrases",
       "ponder big, happy thoughts",
       "sleep and dream peacefully" }),
  });

void main()
{
  write("The list is: %s.\n", commify_list(lists[*])[*]);
}

string commify_list(array(string) list)
{
  switch(sizeof(list))
  {
    case 1: return list[0];
    case 2: return sprintf("%s and %s", @list);
    default: 
      string seperator=",";
      int count;
      while(count<sizeof(list) && search(list[count], seperator)==-1)
        count++;
      if(count<sizeof(list))
        seperator=";";
      return sprintf("%{%s"+seperator+" %}and %s", 
                     list[..sizeof(list)-2], list[-1]);
  }
}
