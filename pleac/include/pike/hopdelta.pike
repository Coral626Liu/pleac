#!/usr/bin/pike
// hopdelta - feed mail header, produce lines
//            showing delay at each hop.
int main()
{
  MIME.Message        mail = MIME.Message(Stdio.stdin.read());
  
  array           received = reverse(mail->headers->received/"\0");
  Calendar.Second lasttime = Calendar.dwim_time(mail->headers->date);

  array delays=({ ({ "Sender", "Recipient", "Time", "Delta" }) });
  delays+=({ ({ mail->headers->from, 
                array_sscanf(received[0], "from %[^ ]")[0], 
                mail->headers->date, 
                "" 
          }) });
          

  foreach(received;; string hop)
  {
    string fromby, date;
    [fromby, date] = hop/";";
    Calendar.Second thistime = Calendar.dwim_time(date);

    delays+= ({ array_sscanf(fromby, "from %[^ ]%*sby %[^ ]%*s") + 
                ({ date, lasttime->distance(thistime)->format_elapsed() }) 
             });

    lasttime=thistime;
  }

  write("%{%-=22s %-=22s %-=20s %=10s\n%}\n", delays);
  return 0;
}
