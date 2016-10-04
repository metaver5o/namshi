#!/bin/sh

# challenge proposed at:
# https://github.com/namshi/coding-challenges/blob/master/automation.md
# Marco Matos - 09/27/16

# uncomment / run this routine after                      # warns maintainer to check results first
# checking if changes were ok                             # cleans by deleting backup dirs and


# First acting in remote side

export github_user="mmatoscom"                            # Exporting github username
export file="Dockerfile"                                  # Exporting filename to search (like NVERSION.txt)
export new_filename="NDockerfile"                         # Updated filename (like VERSION.txt)
export gitkey="UPDATE WITH YOUR OWN API KEY"              # Exporting your GitHub API key
                                                          # so you wont be blocked by
                                                          # too much requests

# load curl with your credentials                         # Adding API key to all curl requests
alias curl="curl -H 'Authorization: token $gitkey'"

# set user url
export github_url="https://github.com/"                   # Exporting GitHub URLs so we dont
export github_api="https://api.github.com/"               # need to type so often

# loading full block comment
#[ -z $BASH ] || shopt -s expand_aliases
#alias BEGINCOMMENT="if [ ]; then"
#alias ENDCOMMENT="fi"

# Exporting repository full URL
REPOURL=`curl -s "https://api.github.com/users/\$github_user/repos?type=owner"| \
         grep -w "url" | grep repos|awk {'print $2'} | tr -d "\"" | tr -d "\,"  `

# inform which repos are we going to scan
REPO_NUMBER=`echo $REPOURL | wc -w`

# Repo Counter
printf '%s\n'  "Scanned $REPO_NUMBER repositories"

# Exporting repositories names into a VAR
REPO_NAME=`curl -s https://api.github.com/users/\$github_user/repos | \
                grep -w name| grep -v labels | awk {'print $2'} | tr -d "\"" |  tr -d "\","`

# Just to highlight what we are after :
echo "Searching after - $file :"

# Here, only repositories containing given $file, will be cloned.
# IMPROVEMENT: need to git clone only $file not entire repo.
# git archive --remote=$r  $file | tar -x

for x in `echo $REPOURL | tr " " "\n"` ;
  do
  echo "$x"
  r="https://github.com/$github_user/"`echo $x | rev | cut -d/ -f1 | rev`".git"
  curl -s $x/contents/ | grep -w "path" | grep $file > /dev/null && git clone $r
done

# Now on, files are updated locally.

# After renaming all of them, if we are repo owners,
# its is possible to commit them back to GitHub with
# the correct names.

# backup files:
# this routine is commented, as we are now copying
# intead of renaming - old file keeps available.
# I kept here for analysis purposes
                                                                   # updates database to use locate command
#updatedb ;                                                        # exports  all file locations to VAR $x
#for x in `locate $file` ;                                         # and updates only new / changed files
#  do                                                              # creates a BKP dir for each $file and
#  mkdir -p $x/BKP/ &  cp -rfvaup $x $x/BKP/$file                  # backups them up. -p keeps permissions.
#done

# rename files with N prefix:                                      # exports  all file locations to VAR $x
for x in `ls  . | grep -v sh`; do                                                # the -rfvaup flag will copy recursively
cp -rfv $x/$file $x/$new_filename                                      # replaces copying into new file
done                                                               # updating to a _new_ version file, which

#  git add -A
#  git commit -a -m "updating filename for namshi.sh"
#  git push origin master

#echo "ok now you've made it :-)"
