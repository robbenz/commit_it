#!/usr/bin/env bash

# die script -- just in case
die() { echo "$@" 1>&2 ; exit 1; }

# kill message when dead 
KILL="You Suck"

# function to see where to push what branch
pushing() {
    tput setaf 3;echo  What Branch?;tput sgr0 
    read -r branch
    tput setaf 3;echo  Where to? You can say 'origin', 'staging', or 'production';tput sgr0 
    read -r ans
    if [ "$ans" = "origin" ] || [ "$ans" = "staging" ] || [ "$ans" = "production" ]
    then
        git push "$ans" "$branch" 
    elif [ "$ans" = "no" ]
    then
        echo "Okay" 
    else die "$KILL"
    fi
}

# function to see how many more times
more() {
    tput setaf 2;echo More?;tput sgr0 
    read -r more
    if [ "$more" = "yes" ]
    then
        pushing
    elif [ "$more" = "no" ]
    then
        die "Goodbye" 
    else die "$KILL"
    fi
}

# function to git ftp push  |  not active yet
gitftp() {
    tput setaf 3;echo Wanna ftp?;tput sgr0
    read -r ftp 
    if [ "$ftp" = "yes" ]
    then
        git ftp push
    elif [ "$ftp" = "no" ]
    then
        echo "Okay" 
    else die "$KILL"
    fi
}

# get the root directory in case you run script from deeper into the repo

# YOU MUST RUN...  
# git config --global alias.root "rev-parse --show-toplevel" 
# FOR THIS NEXT PART TO WORK  

gr="$(git root)"
cd "$gr" 
tput setaf 3;pwd;tput sgr0 

# begin commit input
git add . -A
read -r -p "Commit description: " desc  
git commit -m "$desc"

# find out if we're pushing somewhere
tput setaf 2;echo  Wanna Do Some pushing?;tput sgr0 
read -r push 
if [ "$push" = "yes" ]
then 
    pushing # you know this function 
    until [ "$more" = "no" ]
    do
        more # you know this function
    done
elif [ "$push" = "no" ]
then
    echo "Okay" 
else die "$KILL"
fi
