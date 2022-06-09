#!/bin/bash
set -e

export SETTINGS_FILE="./$1"
export SHELL_FILE_NAME="set_env.sh"
export ENV_FILE_NAME=$4

service mysql start 
mysql -e "CREATE DATABASE test"

# Setup database
python /modify_settings.py
echo "Alter Settings File"

# Setup user environment vars
if [[ ! -z $ENV_FILE_NAME ]]; then
    echo "Setting up your environment variables"
    python /setup_env_script.py
    . ./$SHELL_FILE_NAME
fi

pip install setuptools-scm==5.0.2
pip install -r $3
echo "Migrating DB"
python manage.py migrate

echo "Running your tests"

# TODO: Find a better alternative
if [ "${2,,}" == "true" ]; then
    echo "Enabled Parallel Testing"
    python manage.py test --parallel
else 
    python manage.py test $5
fi
