#!/bin/sh

svnrepodir=~/svn

svnadmin create $svnrepodir
echo '#!/bin/sh' > $svnrepodir/hooks/pre-revprop-change
chmod +x $svnrepodir/hooks/pre-revprop-change

echo "Enter the full url for the root of your remote SVN repository:"
read remoterepo
#svnsync init file://$svnrepodir http://python-nose.googlecode.com/svn
svnsync init file://$svnrepodir $remoterepo
svnsync sync file://$svnrepodir