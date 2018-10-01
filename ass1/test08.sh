# test legit rm --cached
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
legit.pl rm --cached a
legit.pl rm --cached b
legit.pl rm --cached c
legit.pl rm --cached d
legit.pl rm --cached e
legit.pl rm --cached f
legit.pl rm --cached g
legit.pl rm --cached h
legit.pl rm --cached x
legit.pl status