LINKED_ENV_FILE=".linked_env"
CONDA_TYPE="conda"
VENV_TYPE="virtualenv"


# Finds the path to the nearest .linked_env file
# Returns empty string or the proper path to parent .linked_env
function _check_linked_env_path()
{
    local check_dir=$1

    if [[ -f "$check_dir/$LINKED_ENV_FILE" ]]; then

        printf "$check_dir/$LINKED_ENV_FILE"
        return
    else
        if [[ "$check_dir" = "/" ]]; then
            printf ""
            return
        fi
        _check_linked_env_path "$(dirname "$check_dir")"
    fi
}

# Helper to activate a conda environment
function _activate_conda_env()
{    
    conda_env_name=$1
    conda activate $conda_env_name

    printf "\nActivated conda environment: " 
    printf "$conda_env_name - "
    printf "[$(python --version 2>&1)]\n\n"
}

# Helper to activate a virtual env
function _activate_virtual_env()
{
    virtual_env_path=$1
    source "$virtual_env_path/bin/activate"

    printf "\nActivated virtual environment: " 
    printf "$virtual_env_path - "
    printf "[$(python --version 2>&1)]\n\n"
}

# Helper to deactivate an environment
function _deactivate_env()
{
    # this does not harm
    conda deactivate

    # deactivate virtual env if one is activated
    if [[ ! -z "$VIRTUAL_ENV" ]]; then

        deactivate
    fi  
}

# Hook function gets executed after stepping into directory
# Checks if conda environment is linked or virtual env is exiting
function check_linked_env()
{
    # prevent double activated environments
    # problem while moving in nested environments
    _deactivate_env   

    linked_env_path=$(_check_linked_env_path $PWD)

    if [[ ! -z $linked_env_path ]]; then

        IFS=';' read -r -A env_config <$linked_env_path

        if [[ ${env_config[1]} == $CONDA_TYPE ]]; then

            # give environment name
            _activate_conda_env ${env_config[2]}

        elif [[ ${env_config[1]} == $VENV_TYPE ]]; then
        
            # give path to virtual env folder
            _activate_virtual_env ${env_config[2]}

        else
            printf "Received unknown environment name: "
            printf ${env_config[1]}
            printf "\n"

            return # exit would close the current shell because plugins are sourced not executed ..
        fi
    fi
}

# Command to link the current directory to the give conda environment
function link_environment()
{
    linked_env_path=$(_check_linked_env_path $PWD)

    if [[ ! -z $linked_env_path ]]; then

        IFS=';' read -r -A env_config <$linked_env_path

        printf "There is already a linked ${env_config[1]} environment. If this is a mistake use the unlink_environment command.\n"
        printf "The linked environment is: ${env_config[2]}\n"

        check_linked_env # keep the current environment active

        return # exit would close the current shell because plugins are sourced not executed ..

    elif [[ $# -ne 2 ]] ; then
        printf "Exactly two arguments are necessary. The type of the environment ('$CONDA_TYPE' or '$VENV_TYPE') and its name.\n"
        return # exit would close the current shell because plugins are sourced not executed ..

    else
        # TODO: check arguments first.

        # field delimiter is ';' to prevent issues with directory names that contain spaces
        if [[ $1 == $CONDA_TYPE ]]; then

            printf "$1;$2" > $LINKED_ENV_FILE

        elif [[ $1 == $VENV_TYPE ]]; then
        
            printf "$1;$PWD/$2" > $LINKED_ENV_FILE

        fi

        check_linked_env
    fi
}

# Command to unlink the current directory from the conda environment
function unlink_environment()
{
    _deactivate_env

    if [[ -f $LINKED_ENV_FILE ]]; then

        rm -f $LINKED_ENV_FILE
    else
        printf "No '$LINKED_ENV_FILE' found to unlink!\n"

        check_linked_env # keep the current environment active

        return # exit would close the current shell because plugins are sourced not executed ..
    fi
}


##########################################################################################


# check the requirements
if ! type conda > /dev/null; then
    export DISABLE_AUTOACTIVATE_ENVIRONMENT="1"
    echo "zsh-autoactivate-conda requires conda to be installed!\n"
    
    add-zsh-hook -D chpwd check_linked_env # Delete the function from the hook array
fi

if [[ -z "$DISABLE_AUTOACTIVATE_ENVIRONMENT" ]]; then
    autoload -Uz add-zsh-hook
    add-zsh-hook -D chpwd check_linked_env
    add-zsh-hook chpwd check_linked_env
fi
