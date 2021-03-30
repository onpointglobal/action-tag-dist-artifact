#!/bin/sh -l

tag_version=$1
version_file_name=$2

build_theme () {
    yarn install
    yarn build
    if [[ ! -d dist ]]
    then
        echo "Dist folder doesn't exist"
        exit 1
    fi
    sed -i 's/\(Version: \).*/Version: '"$wp_version"'/g' "$version_file_name"
}

build_plugin () {
    if [ -f "package.json" ];
    then
        yarn install
        yarn build
    fi
    old_version=$(awk '/Version/ {print $3}' op_tools_plugin.php)
    sed -i -r 's:'"$old_version"':'"$wp_version"':g' "$version_file_name"
}


distignore=.distignore
wp_version=$(echo $tag_version | cut -c 2-) 
composer_package_name=$(jq -r '.type' composer.json)
git config --global user.name github-actions
git config --global user.email github-actions@github.com
mv .distignore /tmp/.gitignore

if [ "wordpress-theme" == "$composer_package_name" ]; then
    build_theme $wp_version
fi

if [ "wordpress-plugin" == "$composer_package_name" ]; then
    build_plugin
fi

mv /tmp/.gitignore .
git checkout -b release-$tag_version
git rm -r --cached .
git add .
MESSAGE=$(git log -1 HEAD --pretty=format:%s)
git commit -am 'Created Tag '"$tag_version"' with '"$MESSAGE"''
git tag $tag_version -m "$MESSAGE"
git push origin release-$tag_version
git push origin $tag_version --force