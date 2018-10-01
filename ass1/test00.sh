# test legit commands before legit init
echo a>a
legit.pl add a
legit.pl commit -m add_a
legit.pl log
legit.pl show :a
legit.pl rm a
legit.pl status
legit.pl branch
legit.pl branch b
legit.pl checkout b
legit.pl init
legit.pl init
