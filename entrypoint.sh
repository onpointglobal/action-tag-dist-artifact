#!/bin/sh -l

tag_version=$1
distignore=.distignore
wp_version=$(echo $1 | cut -c 2-) 
git config --global user.name github-actions
git config --global user.email github-actions@github.com
mv .distignore /tmp/.gitignore
yarn install
yarn build
if [[ ! -d dist ]]
then
    echo "Dist folder doesn't exist"
    exit 1
fi
git checkout -b release-$tag_version
mv /tmp/.gitignore .
sed -i 's/\(Version: \).*/Version: '"$wp_version"'/g' style.css
git rm -r --cached .
git add .
MESSAGE=$(git log -1 HEAD --pretty=format:%s)
git commit -am 'Created Tag '"$tag_version"' with '"$MESSAGE"''
git tag $tag_version -m "$MESSAGE"
git push origin release-$tag_version
git push origin $tag_version --force