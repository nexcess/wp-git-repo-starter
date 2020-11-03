#!/usr/bin/env bash
#
# This script automatically cleans up a clone of the nexcess/wp-git-repo-starter
# repository to give users a clean slate to build their WordPress site upon.
#
# WARNING: Running this script will delete this script, so please use with caution!
#
# USAGE:
#
#     bash refresh-repo.sh
#
# Link: https://github.com/nexcess/wp-git-repo-starter

function error() {
	printf "\033[0;31m%s\033[0;0m\n" "$1"
}

function step() {
	printf "\033[0;36m%s\033[0;0m" "$1"
}

function success() {
	printf "\033[0;32m%s\033[0;0m\n" "$1"
}

function warning() {
	printf "\033[43;30m%s\033\033[0m\n" "$1"
}

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../" >/dev/null 2>&1 && pwd)"
ALL_COMPLETE=1

# First, ensure this is being used against the sample repository.
#
# If so, remove the current .git directory and run `git init`.
step 'Resetting the Git repository...'
if ! git remote -v | grep -q nexcess/wp-git-repo-starter; then
	error 'FAIL'
	warning 'Git repo origin differs from https://github.com/nexcess/wp-git-repo-starter'
	echo "
To avoid deleting any commits you may have made, we will not delete ${PROJECT_ROOT}/.git

You may manually perform this action by running:
    rm -rf ${PROJECT_ROOT}/.git && git init ${PROJECT_ROOT}"

    ALL_COMPLETE=0
elif ! rm -rf "${PROJECT_ROOT}/.git" && git init "$PROJECT_ROOT"; then
	error 'FAIL'
	warning 'Unable to reset the git repository'
	echo "
You may manually perform this action by running:
    rm -rf \"${PROJECT_ROOT}/.git\" && \"git init ${PROJECT_ROOT}\""

    ALL_COMPLETE=0
else
	success 'OK'
fi

# Move the example composer.json file.
step 'Initializing Composer...'
if ! mv -n "${PROJECT_ROOT}/composer.json.example" "${PROJECT_ROOT}/composer.json"; then
	error 'FAIL'
	warning 'Unable to automatically create composer.json'
	echo "
composer.json.example could not be copied to composer.json.

If you wish to use Composer for your project, you may manually perform this action by running:
    mv \"${PROJECT_ROOT}/composer.json.example\" \"${PROJECT_ROOT}/composer.json\""

    ALL_COMPLETE=0
else
	success 'OK'
fi

# Remove the README and LICENSE files.
step 'Removing README.md...'
if ! rm "${PROJECT_ROOT}/README.md" "${PROJECT_ROOT}/LICENSE.txt"; then
	error 'FAIL'
	warning 'Unable to delete README.md and/or LICENSE.txt'
	echo "
You may manually delete these files by running:
	rm ${PROJECT_ROOT}/README.md LICENSE.txt"

	ALL_COMPLETE=0
else
	success 'OK'
fi

# Finally, delete this script.
step 'Cleaning up this script...'
if ! rm "$0"; then
	warning "Unable to delete ${PROJECT_ROOT}/bin/refresh-repo.sh"
	echo "
You may delete this script by running:
	rm $0

If you would like to remove the entire bin/ directory, you may run:
	rm -rf \"${PROJECT_ROOT}/bin\""

	ALL_COMPLETE=0
fi

# Delete the bin/ directory if it's now empty.
if [ ! "$(ls -A "${PROJECT_ROOT}/bin")" ]; then
	rmdir "${PROJECT_ROOT}/bin"
fi
success 'OK'

echo
if [ "$ALL_COMPLETE" = 0 ]; then
	error 'Not all steps were completed successfully, please review the output for further instructions.'
	exit 1
fi

success 'The repository has been reset, enjoy!'
