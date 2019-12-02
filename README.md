# ZSH Autoactivate Conda Plugin

This ZSH plugin switches the conda environment as you move between directories.

Highly inspired from: https://github.com/bckim92/zsh-autoswitch-conda


## How it Works

Use the `link_conda_env` command to link a directory to a existing conda environment. Every time you step into this or sub directories the given environment gets activated.

The `unlink_conda_env` is used to delete the link between the directory and the conda environment.

### Example

```bash
┌> ~/code/  ............................................................... [1:12:10] <┐
└> $ take plugin-example                                                   ¯\_(ツ)_/¯ <┘

┌> ~/code/plugin-example/  ................................................ [1:12:12] <┐
└> $ link_conda_env plugin-example                                         ¯\_(ツ)_/¯ <┘

Activated conda environment: plugin-example - [Python 3.7.4]

┌> ~/code/plugin-example/  ................................................ [1:15:01] <┐
└> (conda:plugin-example) $ take test                                      ¯\_(ツ)_/¯ <┘

Activated conda environment: plugin-example - [Python 3.7.4]

┌> ~/code/plugin-example/test/  ........................................... [1:15:34] <┐
└> (conda:plugin-example) $ cd ..                                          ¯\_(ツ)_/¯ <┘

Activated conda environment: plugin-example - [Python 3.7.4]

┌> ~/code/plugin-example/  ................................................ [1:15:38] <┐
└> (conda:plugin-example) $ cd ..                                          ¯\_(ツ)_/¯ <┘

┌> ~/code/  ............................................................... [1:15:39] <┐
└> $ cd plugin-example/test                                                ¯\_(ツ)_/¯ <┘

Activated conda environment: plugin-example - [Python 3.7.4]

┌> ~/code/plugin-example/test/  ........................................... [1:15:52] <┐
└> (conda:plugin-example) $ unlink_conda_env                               ¯\_(ツ)_/¯ <┘

┌> ~/code/plugin-example/test/  ........................................... [1:36:32] <┐
└> $                                                                       ¯\_(ツ)_/¯ <┘
```

## Installation and Prerequisites

This plugins needs `conda` to be installed.

Clone this repository in oh-my-zsh's plugins directory:

```bash
git clone https://github.com/se-jaeger/zsh-autoactivate-conda ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autoactivate-conda
```

Activate the plugin in ~/.zshrc:

```bash
plugins=( [plugins...] zsh-autoactivate-conda)
```

Source `~/.zshrc` to take changes into account:

```bash
source ~/.zshrc
```

## Further Work

- [ ] Fixes
- [ ] Check before if existing link to environment