# test legit show without commit number
legit.pl init
echo a>a
legit.pl add a
legit.pl commit -m add_a
legit.pl show :a
legit.pl show :b