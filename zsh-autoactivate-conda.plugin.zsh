CONDA_ENV_FILE=".conda_env"

# Finds the path to the nearest .conda_env file
function _check_conda_env_path()
{
    local check_dir=$1

    if [[ -f "${check_dir}/$CONDA_ENV_FILE" ]]; then

        printf "${check_dir}/$CONDA_ENV_FILE"
        return 
    else
        if [[ "$check_dir" = "/" ]]; then
            return
        fi
        _check_conda_env_path "$(dirname "$check_dir")"
    fi
}

# Hook function gets executed after stepping into directory
# Checks if conda environment is linked
function check_conda_env()
{
    conda_env_path=$(_check_conda_env_path "$PWD")
    
    if [[ -f $conda_env_path ]]; then

        conda_env_name="$(<$conda_env_path)"
        conda activate $conda_env_name

        printf "\nActivated conda environment: " 
        printf "$conda_env_name - "
        printf "[$(python --version 2>&1)]\n\n"
    else
        conda deactivate
    fi
}

# Command to link the current directory to the give conda environment
function link_conda_env()
{
    if [[ -f $CONDA_ENV_FILE ]]; then

        printf "$CONDA_ENV_FILE file already exists. If this is a mistake use the unlink_conda_env command.\n"
        printf "The linked conda env is: "$(<$CONDA_ENV_FILE)""

    elif [[ $# -ne 1 ]] ; then
        # TODO: fix me..
        printf("Exactly one argument is necessary. The name of the conda environment to link.\n")

    else
        printf $1 > $CONDA_ENV_FILE
        check_conda_env
    fi
}

# Command to unlink the current directory from the conda environment
function unlink_conda_env()
{
    conda deactivate

    conda_env_path=$(_check_conda_env_path "$PWD")
    rm -f $conda_env_path
}


##########################################################################################

# check the requirements
if ! type conda > /dev/null; then
    export DISABLE_AUTOACTIVATE_CONDA_ENV="1"
    echo "zsh-autoactivate-conda requires conda to be installed!\n"
    
    add-zsh-hook -D chpwd check_conda_env # Delete the function from the hook array
fi

if [[ -z "$DISABLE_AUTOACTIVATE_CONDA_ENV" ]]; then
    autoload -Uz add-zsh-hook
    add-zsh-hook -D chpwd check_conda_env
    add-zsh-hook chpwd check_conda_env
fi
