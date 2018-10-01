# test legit commands before firtst commit
legit.pl init
echo a>a
legit.pl add a
legit.pl log
legit.pl show :a
legit.pl rm a
legit.pl status
legit.pl branch
legit.pl branch b
legit.pl checkout b