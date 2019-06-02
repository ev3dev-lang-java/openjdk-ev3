#!/usr/bin/awk -f
# Credit and kudos to https://stackoverflow.com/a/29138871
BEGIN {
  if (ARGC != 2) {
    print "git-describe-remote.awk <repo>"
    exit
  }
  FS = "[ /^]+"
  while ("git ls-remote " ARGV[1] "| sort -Vk2" | getline) {
    if (!sha)
      sha = substr($0, 1, 7)
    tag = $3
  }
  printf "%s\n", tag
}
