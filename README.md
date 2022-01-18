# Deprecated!

I re-wrote this plugin: https://github.com/se-jaeger/zsh-activate-py-environment
Would be great if you could check that out!






# ZSH Autoactivate Environment Plugin

This ZSH plugin switches the environment as you move between directories.

Highly inspired from: https://github.com/bckim92/zsh-autoswitch-conda


## How it Works

Use the `link_environment` command to link a directory to a existing conda or virtual environment. Every time you step into this or sub directories the given environment gets activated.

The `unlink_environment` command is used to delete the link between the directory and the environment.


### Example

```bash
┌> ~/code/  ............................................................................................ [13:40:37] <┐
└> $ cd plugin-example/conda-example                                                                     ¯\_(ツ)_/¯ <┘

┌> ~/code/plugin-example/conda-example/  ............................................................... [13:41:05] <┐
└> $ link_environment conda plugin-example                                                               ¯\_(ツ)_/¯ <┘

Activated conda environment: plugin-example - [Python 2.7.16]

┌> ~/code/plugin-example/conda-example/  ............................................................... [13:41:16] <┐
└> (conda:plugin-example) $ take test                                                                    ¯\_(ツ)_/¯ <┘

Activated conda environment: plugin-example - [Python 2.7.16]

┌> ~/code/plugin-example/conda-example/test/  .......................................................... [13:41:20] <┐
└> (conda:plugin-example) $ cd ../../virtualenv-example                                                  ¯\_(ツ)_/¯ <┘

┌> ~/code/plugin-example/virtualenv-example/  .......................................................... [13:41:27] <┐
└> $ link_environment virtualenv venv                                                                    ¯\_(ツ)_/¯ <┘

Activated virtual environment: /Users/sebastian/code/plugin-example/virtualenv-example/venv - [Python 3.7.5]

┌> ~/code/plugin-example/virtualenv-example/  .......................................................... [13:41:35] <┐
└> (venv:venv) $ take test                                                                               ¯\_(ツ)_/¯ <┘

Activated virtual environment: /Users/sebastian/code/plugin-example/virtualenv-example/venv - [Python 3.7.5]

┌> ~/code/plugin-example/virtualenv-example/test/  ..................................................... [13:41:40] <┐
└> (venv:venv) $ link_environment conda plugin-example                                                   ¯\_(ツ)_/¯ <┘
There is already a linked virtualenv environment. If this is a mistake use the unlink_environment command.
The linked environment is: /Users/sebastian/code/plugin-example/virtualenv-example/venv

Activated virtual environment: /Users/sebastian/code/plugin-example/virtualenv-example/venv - [Python 3.7.5]

┌> ~/code/plugin-example/virtualenv-example/test/  ..................................................... [13:41:44] <┐
└> (venv:venv) $ unlink_environment                                                                      ¯\_(ツ)_/¯ <┘
No '.linked_env' found to unlink!

Activated virtual environment: /Users/sebastian/code/plugin-example/virtualenv-example/venv - [Python 3.7.5]

┌> ~/code/plugin-example/virtualenv-example/test/  ..................................................... [13:41:55] <┐
└> (venv:venv) $ cd ..                                                                                   ¯\_(ツ)_/¯ <┘

Activated virtual environment: /Users/sebastian/code/plugin-example/virtualenv-example/venv - [Python 3.7.5]

┌> ~/code/plugin-example/virtualenv-example/  .......................................................... [13:42:00] <┐
└> (venv:venv) $ unlink_environment                                                                      ¯\_(ツ)_/¯ <┘

┌> ~/code/plugin-example/virtualenv-example/  .......................................................... [13:42:07] <┐
└> $                                                                                                     ¯\_(ツ)_/¯ <┘                                                                     ¯\_(ツ)_/¯ <┘
```


## Installation and Prerequisites

This plugins needs `conda` to be installed.

Clone this repository in oh-my-zsh's plugins directory:

```bash
git clone https://github.com/se-jaeger/zsh-autoactivate-environment ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autoactivate-environment
```

Activate the plugin in ~/.zshrc:

```bash
plugins(
  # other plugins
  zsh-autoactivate-environment
)
```

Source `~/.zshrc` to take changes into account:

```bash
source ~/.zshrc
```

## Further Work

- [ ] Fixes
- [ ] Check if existing before link to environment
- [x] Add support for virtual envs
- [ ] Make conda installation optional
