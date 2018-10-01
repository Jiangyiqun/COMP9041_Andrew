# test legit rm --force
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
legit.pl rm --force a
legit.pl rm --force b
legit.pl rm --force c
legit.pl rm --force d
legit.pl rm --force e
legit.pl rm --force f
legit.pl rm --force g
legit.pl rm --force h
legit.pl rm --force x
legit.pl status