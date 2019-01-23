# powerline-shell

> A Powerline-style shell prompt written in pure Bash

![powerline-shell](https://raw.githubusercontent.com/bcmarinacci/powerline-shell/master/screenshot.png)

## Features

- The path relative to the repository's top-level directory is displayed if the current working directory is a Git repository
- The absolute path of the directory is displayed if the current working directory is not a Git repository
- The start of the prompt is green if the exit code of the last command was 0
- The start of the prompt is red if the exit code of the last command was a nonzero number

## Git Status Indicators

- `⎇`: currently checked-out branch, tag, or short SHA-1 hash if the head is detached
- `✓`: repository is clean
- `✗`: repository is dirty
- `+n`: there are `n` staged files
- `-n`: there are `n` unstaged files
- `?n`: there are `n` untracked files
- `¢n`: there are `n` stashes
- `⇡n`: local is ahead of remote by `n` commits
- `⇣n`: local is behind remote by `n` commits

## Installation

Download the Bash script:

```bash
$ curl https://raw.githubusercontent.com/bcmarinacci/powerline-shell/master/powerline-shell.bash > ~/.powerline-shell.bash
```

Then source it in your `.bashrc` (or `.bash_profile`):

```bash
$ printf ". ~/.powerline-shell.bash\n" >> ~/.bash_profile
```

## Prior Art

https://github.com/arcticicestudio/nord-terminal-app<br />
https://github.com/chriskempson/tomorrow-theme<br />
https://github.com/magicmonty/bash-git-prompt<br />
https://github.com/powerline/powerline<br />
https://github.com/riobard/bash-powerline<br />
https://github.com/robinbentley/oceanic-next-macos-terminal<br />
https://github.com/voronianski/oceanic-next-color-scheme
