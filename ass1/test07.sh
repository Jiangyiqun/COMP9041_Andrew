# test legit rm --force --cached
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
legit.pl rm --force --cached a
legit.pl rm --force --cached b
legit.pl rm --force --cached c
legit.pl rm --force --cached d
legit.pl rm --force --cached e
legit.pl rm --force --cached f
legit.pl rm --force --cached g
legit.pl rm --force --cached h
legit.pl rm --force --cached x
legit.pl status