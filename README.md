# powerline-shell

> A Powerline-style shell prompt written in pure Bash

![powerline-shell](https://raw.githubusercontent.com/bcmarinacci/powerline-shell/master/powerline-shell.png)

## Git Status Indicators

- `⎇`: currently checked-out branch, tag, or short SHA-1 hash if the head is detached
- `✓`: repository is clean
- `✗`: repository is dirty
- `+n`: there are `n` staged files
- `⇡n`: local is ahead of remote by `n` commits
- `⇣n`: local is behind remote by `n` commits

## Installation

Download the Bash script:

```bash
$ curl https://raw.githubusercontent.com/bcmarinacci/powerline-shell/master/powerline-shell.bash > ~/.powerline-shell.bash
```

Then `source` it in your `.bash_profile` (or `.bashrc`):

```bash
$ printf "\nsource ~/.powerline-shell.bash\n" >> ~/.bash_profile
```

The theme used in the screenshot is [Tomorrow Night Eighties](https://github.com/chriskempson/tomorrow-theme/blob/master/OS%20X%20Terminal/Tomorrow%20Night%20Eighties.terminal) by Chris Kempson.
