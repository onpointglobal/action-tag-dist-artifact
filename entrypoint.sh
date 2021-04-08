#!/bin/sh -l

tag_version=$1
file_to_bump_version=$2

build_theme () {
    yarn install
    yarn build
    if [[ ! -d dist ]]
    then
        echo "Dist folder doesn't exist"
        exit 1
    fi
    sed -i 's/\(Version: \).*/Version: '"$tag_version"'/g' "$file_to_bump_version"
}

build_plugin () {
    if [ -f "package.json" ];
    then
        yarn install
        yarn build
    fi
    old_version=$(awk '/Version/ {print $3}' "$file_to_bump_version")
    sed -i -r 's:'"$old_version"':'"$tag_version"':g' "$file_to_bump_version"
}


distignore=.distignore
composer_package_name=$(jq -r '.type' composer.json)
git config --global user.name github-actions
git config --global user.email github-actions@github.com
mv .distignore /tmp/.gitignore

if [ "wordpress-theme" == "$composer_package_name" ]; then
    build_theme $tag_version
fi

if [ "wordpress-plugin" == "$composer_package_name" ]; then
    build_plugin $tag_version
fi

mv /tmp/.gitignore .

reqsubstr="RC"
if [ -z "${tag_version##*$reqsubstr*}" ]; then
  tag_version=${tag_version:: -2} 
fi

git checkout -b $tag_version
git rm -r --cached .
git add .
MESSAGE=$(git log -1 HEAD --pretty=format:%s)
git commit -am 'Created Tag '"$tag_version"' with '"$MESSAGE"''
git tag v$tag_version -m "$MESSAGE"
# git push v$tag_version
git push origin $tag_version --follow-tags