#/usr/bin/pike
void main(int argc, array(string) argv)
{
  string data = Stdio.read_file(argv[1]);
  int checksum;

  foreach(data ;; int char)
    checksum += char;

  checksum %= pow(2,16)-1;
  write("%d\n", checksum);
}
