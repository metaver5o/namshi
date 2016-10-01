#!/bin/sh

# challenge proposed at:
# https://github.com/namshi/coding-challenges/blob/master/automation.md
# Marco Matos - 09/27/16

export github_user="dockerizer"
export file="test.txt"
export gitkey="                               "

# load curl with your credentials
alias curl="curl -H 'Authorization: token $gitkey'"

# set user url
export github_url="https://github.com/"
export github_api="https://api.github.com/"

# loading full block comment
[ -z $BASH ] || shopt -s expand_aliases
alias BEGINCOMMENT="if [ ]; then"
alias ENDCOMMENT="fi"

# export repositories URL
REPOURL=`curl -s "https://api.github.com/users/\$github_user/repos?type=owner"| \
         grep -w "url" | grep repos|awk {'print $2'} | tr -d "\"" | tr -d "\,"  `

# inform which repos are we going to scan
REPO_NUMBER=`echo $REPOURL | wc -w`

# Repo Counter
printf '%s\n'  "Scanned $REPO_NUMBER repositories"

# Search for given $FILE into repositories
REPO_NAME=`curl -s https://api.github.com/users/\$github_user/repos | \
                grep  -w name| grep -v labels | awk {'print $2'} | tr -d "\"" |  tr -d "\","`

echo "Searching after - $file :"

for x in `echo $REPOURL | tr " " "\n"` ;
  do  echo "$x"   & \
      curl -s $x/contents/ | grep -w "path" | awk {'print $2'} | tr -d "\"" | tr -d "\," ;
  done


BEGINCOMMENT
echo 001
for x in `echo $REPO_NAME`; do
  echo $x;
done

# Exporting $clone_url (.git)
clone_url=`curl -s $REPOURL | grep -w "clone_url" | awk {'print $2'} | tr -d "\"" | tr -d "\," `

# Showing repos candidates to cloning
printf '%s\n' "Printing URLs to clone"
echo "##############################################################"
printf '%s\n' "$clone_url" | grep $github_user | uniq -u
printf '%s\n' "   "

# Starting to clone repos in current dir
printf '%s\n' "Cloning URLs"
echo "##############################################################"
for x in `echo $clone_url | grep $github_user | uniq -u` ;
  do git clone $x ;
done

printf '%s\n' "   "


# backup files:                                                   # updates database to use locate command
#  updatedb ; for x in `locate VERSION.txt` ;                      # exports  all file locations to VAR $x
#  do mkdir -p $x/BKP/ &  cp -rfvaup $x $x/BKP/; done              # the -rfvaup flag will copy recursively
                                                                  # and incrementally updates only changed files
                                                                  # creates a BKP dir for each VERSION.txt and
                                                                  # backups them up

# remove N:                                                       # exports  all file locations to VAR $x
#  for x in `locate VERSION.txt`;                                  # removes N from prefix in VERSION files using sed
#  do sed -i -e 's/Nx.y.z/x.y.z/g' $x > $x_new_VERSION.txt & \     # updating to a _new_ version file, which
#  cat $x_new_VERSION.txt > $x;                                    # overwrites original file with changed values
#  done

# uncomment / run this routine after                              # warns maintainer to check results first
# checking if changes were ok                                     # cleans by deleting backup dirs and

# cleaning script files                                           # _new_ version files.
#  for x in `locate VERSION.txt` ;                                #
#  do rm -rfv $x/BKP/ & rm -rfv $x_new_VERSION.txt ;  done        # now what remains are VERSION.txt
                                                                  #  files without N prefix

                                                                  # If I had to apply this change to a whole remote repo
                                                                  # should have to git clone everything, than commit to repo
                                                                  # after run this shell on top directory.

# PYTHON

#export github-url / version-dir/  backup-dir/

ENDCOMMENT
