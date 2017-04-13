# powerline-shell

> Powerline in pure Bash

![powerline-shell](https://raw.githubusercontent.com/bcmarinacci/powerline-shell/master/powerline-shell.png)

## Features

- Displays ⎇ + the current git branch name, tag, or short SHA-1 hash if the head is detached
- Displays ✓ when the current branch is clean
- Displays ✗ when the current branch is dirty
- Displays ⇡ + the number of commits when the current branch is ahead of the remote
- Displays ⇣ + the number of commits when the current branch is behind the remote
- Executes quickly
- Does not require patched fonts

## Installation

Download the Bash script:

```bash
$ curl https://raw.githubusercontent.com/bcmarinacci/powerline-shell/master/powerline-shell.bash > ~/.powerline-shell.bash
```

Then `source` it in your `.bash_profile` (or `.bashrc`):

```bash
$ printf "\nsource ~/.powerline-shell.bash\n" >> ~/.bash_profile
```

This shell prompt was inspired by [bash-powerline](https://github.com/riobard/bash-powerline).

The theme from the screenshot is [Tomorrow Night Eighties](https://github.com/chriskempson/tomorrow-theme/tree/master/OS%20X%20Terminal).
