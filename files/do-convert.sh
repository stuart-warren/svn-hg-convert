#!/bin/sh

rootsvndir=~/svn # already created svn clone
trunklist=${rootsvndir}/tree-roots.txt # gets created
trunksed=${rootsvndir}/tree-roots.sed
authorlist=${rootsvndir}/authormap.txt # gets created
authorsed=${rootsvndir}/authormap.sed
rootsvnuri=file://${rootsvndir}
roothgdir=/var/lib/mercurial-server/repos/myrepos/
#hgexec=/home/localadmin/mercurial-2.2.3/hg # latest version of hg (may need to remove packaged version)
hgexec=/usr/bin/hg

touch ${trunksed}
touch ${authorsed}
# Get an up to date copy of your SVN repo
svnsync sync ${rootsvnuri}
# Get a list of repository locations with trunk directories to separate into separate HG repos
# Use $trunksed to remove odd directories like trunks within branches within trunks
svnlook tree --full-paths ${rootsvndir} | grep -e trunk/$ | sed 's:trunk/$::' | sed -f ${trunksed} > ${trunklist}
# Get list of authors and convert into HG style. Assumes username first.last style
# Use $authorsed to correct initials in usernames to full names. eg "B Marley" -> "Bob Marley"
svn log ${rootsvnuri} --quiet --xml | grep author | sed -r "s:</?author>::g" | sort | uniq | sed "s:^\(.*\)\.\(.*\)$:\1\.\2=\u\1 \u\2 \<\1\.\2@ocado.com\>:" | sed -f ${authorsed} > ${authorlist}


rm -rf ${roothgdir}/*
while read line
do
  echo "${hgexec} clone --config hgsubversion.authormap=${authorlist} --config hgsubversion.layout=standard ${rootsvnuri}${line} ${roothgdir}${line}"
  `${hgexec} clone --config hgsubversion.authormap=${authorlist} --config hgsubversion.layout=standard ${rootsvnuri}${line} ${roothgdir}${line}`
done <${trunklist}