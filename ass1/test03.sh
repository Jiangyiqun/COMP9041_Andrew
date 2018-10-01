# test commit error
legit.pl init
echo a>a
legit.pl commit -m add_a
legit.pl add a
legit.pl commit -m add_a
legit.pl add b
legit.pl commit -m add_b