#!/bin/sh -l

echo "Hello $1"
time=$(date)
echo "::set-output name=time::$time"

tag_version=$1
wp_version=$(echo $1 | cut -c 2-) 
echo "::set-output name=wp_version::$wp_version"

git config --global user.name github-actions
git config --global user.email github-actions@github.com
yarn install
yarn build
git checkout -b release-$tag_version
sed -i 's/\(Version: \).*/Version: '"$wp_version"'/g' style.css
mv .distignore .gitignore
git rm -r --cached .
git add .
git commit -am 'Created Tag '"$tag_version"''
git tag $tag_version
git push origin release-$tag_version
git push origin $tag_version --force