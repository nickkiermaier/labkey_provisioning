#!/bin/bash
set -e # exit if any command fails

LABKEY_ROOT=./labkey
if ! test -d $LABKEY_ROOT/$LABKEY_BRANCH
  then
    mkdir $LABKEY_ROOT
  else
    rm -rf $LABKEY_ROOT
    mkdir $LABKEY_ROOT
fi

# For using trunk
# LABKEY_URL=https://svn.mgt.labkey.host/stedi/trunk
# GIT_BRANCH=develop

# For using branches
LABKEY_BRANCH=release20.7-SNAPSHOT
GIT_BRANCH=$LABKEY_BRANCH
LABKEY_URL=https://svn.mgt.labkey.host/stedi/branches/$LABKEY_BRANCH/


if test -d $LABKEY_ROOT/$LABKEY_BRANCH; then
  echo "Labkey directory exists: $LABKEY_ROOT/$LABKEY_BRANCH, please empty and re-run the script."
  exit 1
fi

# checkout main app
echo "Checkout Main App" # https://www.labkey.org/Documentation/wiki-page.view?name=devMachine#checkout
cd $LABKEY_ROOT || exit
svn checkout "$LABKEY_URL"


# ensure main repo successful
if [ $? -eq 0 ]; then
    echo "SVN PULL SUCCESSFUL"
else
    echo "SVN PULL NOT SUCCESSFUL"
    exit 1
fi

# # clone modules
echo "Download labkey modules" # https://www.labkey.org/Documentation/wiki-page.view?name=devMachine#coregit

# clone modules in server folder
cd $LABKEY_BRANCH/server || exit
git clone https://github.com/LabKey/testAutomation.git
cd testAutomation || exit
git checkout $GIT_BRANCH
cd ..

# clone labkey modules in server/modules folder
cd modules || exit

for repo in platform commonAssays custommodules discvrlabkeymodules ehrModules LabDevKitModules dataintegration tnprc_ehr
do
	git clone git@github.com:LabKey/$repo.git
	# ensure main repo successful
  if [ ! $? -eq 0 ]; then
      echo "Git clone of $repo not successful.  Please ensure $repo can be downloaded, and rerun script. (Is git installed, accessible on PATH, and are your SSH keys set up properly?)"
      exit 1
  fi
	cd $repo || exit
	git checkout $GIT_BRANCH
	cd ..
done

echo "Pull Labkey Code Successful."