#!/bin/sh -l

set -e  # Exit immediately if a command exits with a non-zero status

tag_version=$1
file_to_bump_version=$2
folders_to_check=$3  # Optional space-separated list of folder paths

check_folders() {
    if [ -n "$folders_to_check" ]; then
        echo "Checking specified folders..."
        for folder in $folders_to_check; do
            if [ ! -d "$folder" ]; then
                echo "Expected folder $folder is missing"
                exit 1
            fi
        done
    else
        echo "No specific folders to check"
    fi
}

build_theme () {
    yarn install
    yarn build
		check_folders
    sed -i 's/\(Version: \).*/Version: '"$tag_version"'/g' "$file_to_bump_version"
}

build_plugin () {
    if [ -f "package.json" ];
    then
        yarn install
        yarn build
    fi
		check_folders
    old_version=$(awk '/Version/ {print $3}' "$file_to_bump_version")
    sed -i -r 's:'"$old_version"':'"$tag_version"':g' "$file_to_bump_version"
}


distignore=.distignore
composer_package_name=$(jq -r '.type' composer.json)
git config --global user.name github-actions
git config --global user.email github-actions@github.com
mv .distignore /tmp/.gitignore

reqsubstr="RC"
if [ -z "${tag_version##*$reqsubstr*}" ]; then
  tag_version=${tag_version:: -2} 
fi

if [ "wordpress-theme" == "$composer_package_name" ]; then
    build_theme $tag_version
fi

if [ "wordpress-plugin" == "$composer_package_name" ]; then
    build_plugin $tag_version
fi

mv /tmp/.gitignore .



git checkout -b $tag_version
git rm -r --cached .
git add .
MESSAGE=$(git log -1 HEAD --pretty=format:%s)
git commit -am 'Created Tag '"$tag_version"' with '"$MESSAGE"''
git tag v$tag_version -m "$MESSAGE"
git push origin v$tag_version --force
# git push origin v$tag_version --follow-tags