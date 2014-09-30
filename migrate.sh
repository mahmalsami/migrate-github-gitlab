#!/bin/bash

# HOWTO
# 1 - set your token, see: https://gitlab.company-name.fr/profile/account
# 2 - set the tables: ORGAS_GITHUB REPOS_GITHUB GROUPS_GITLAB REPOS_GITLAB NAMESPACE_GROUPS_GITLAB
# 3 - run !

#Tested from Github enterprise and Gitlab enterprise

# set your Gitlab personal token here:
token=RanDoMTocken


GIT_SERVER_FROM=git@github.company-name.fr:
GIT_SERVER_TO=git@gitlab.company-name.fr:


ORGAS_GITHUB=(
orga-1-in-github
orga-2-in-github
orga-3-in-github
)


REPOS_GITHUB=(
repo-1-in-orga-1-in-github
repo-2-in-orga-2-in-github
repo-3-in-orga-3-in-github
)


#Existing destination groups in Gitlab
GROUPS_GITLAB=(
destination-group-1-in-gitlab
destination-group-2-in-gitlab
destination-group-3-in-gitlab
)

#New Gitlabs repo to be created
#This names must be available
REPOS_GITLAB=(
new-repo-1-in-group-1-in-gitlab
new-repo-2-in-group-1-in-gitlab
new-repo-3-in-group-1-in-gitlab
)

#A namespace_id is specific to a group
#Please check documentation for further informations
#http://doc.gitlab.com/ee/api/groups.html
NAMESPACE_GROUPS_GITLAB=(
251
246
246
)



for (( r = 0 ; r < ${#REPOS_GITHUB[@]} ; r++ )) do

echo "GitHub repo name: "${REPOS_GITHUB[$r]}
echo "GitHub repo url: "$GIT_SERVER_FROM${ORGAS_GITHUB[$r]}/${REPOS_GITHUB[$r]}.git

echo "GitLab repo name: "${REPOS_GITLAB[$r]}
echo "GitLab repo url: "$GIT_SERVER_TO${GROUPS_GITLAB[$r]}/${REPOS_GITLAB[$r]}.git
echo "GitLab group namespace id: "${NAMESPACE_GROUPS_GITLAB[$r]}


# Create repo on GitLab
curl -H "Content-Type:application/json" https://gitlab.company-name.fr/api/v3/projects?private_token=$token -d "{ \"name\": \"${REPOS_GITLAB[$r]}\" , \"namespace_id\": \"${NAMESPACE_GROUPS_GITLAB[$r]}\" }"


git clone --mirror $GIT_SERVER_FROM${ORGAS_GITHUB[$r]}/${REPOS_GITHUB[$r]}.git

cd ${REPOS_GITHUB[$r]}.git

git remote set-url origin $GIT_SERVER_TO${GROUPS_GITLAB[$r]}/${REPOS_GITLAB[$r]}.git
git push --mirror -u origin

cd .. && rm -rf ${REPOS_GITHUB[$r]}.git

done