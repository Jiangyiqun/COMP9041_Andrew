# test legit rm
legit.pl init
touch a b c d e f g h
legit.pl add a b c d e f
legit.pl commit -m 'first commit'
echo hello >a
echo hello >b
echo hello >c
legit.pl add a b
echo world >a
rm d
legit.pl rm e
legit.pl add g
legit.pl status
legit.pl rm a
legit.pl rm b
legit.pl rm c
legit.pl rm d
legit.pl rm e
legit.pl rm f
legit.pl rm g
legit.pl rm h
legit.pl rm x
legit.pl status