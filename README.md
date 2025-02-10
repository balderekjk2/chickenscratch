# chickenscratch

sharing notes on configuration hell sort of things

## newcomers

- check if you have `micro` and `nnn` available through your Linux disto's package manager i.e. apt, yum, etc
- if you do install both i.e. `sudo apt install micro nnn`
- `export EDITOR=micro` in command line
- `echo alias nnn='nnn -e' >> ~/.bashrc`
- whenever you run `nnn` it will open up file explorer in current dir -- navigate with mouse or left/right arrows
- hit right-arrow or enter key to edit file with micro, or double-click
- exit micro with "ctrl-q", or nnn with "q"

## for those who prefer to learn vim

- vim is a lot more easily configurable, but not as accessible to newcomers

> [!NOTE]
> run `bash updaterc.sh` to append this repo's `bashrc` and `vimrc` to your `~/.bashrc` and `~/.vimrc`

## bash

### [~/.bashrc](/bash/example.bashrc)
- clear scrollback with `Alt+L`
- shows git branch if relevant
  - feel free to remove `\$(__git_ps1)`
- thick cursor for visibility
- up and down arrows search through history contextually
  - i.e. 'vi ' + up/down will cycle through your 'vi ' command history

## vim

### [~/.vimrc](/vim/example.vimrc)
- for vim-enhanced (supports mouse & explorer -- if unavailable, use nano instead)
- has mouse support
- has nice colorscheme
- has helpful shortcuts
  - type 'h' to show helpful shortcuts nano-style
  - including in-file replace func (supports regex)

## nano

### [~/.nanorc](/nano/example.nanorc)
- has mouse support
- has nice colorscheme
- a less considered rc than vimrc
  - still easier to use than defaults

## django

### [admin.py](/django/admin.example.py)
- a modification of admin dashboard
- `super_seer` and `super_privileged` groups
  - `super_privileged`: has superuser privileges in their permissions
    - if not in group, sees limited amount of info about user
  - `super_seer`: sees other superusers as well as elevated groups
    - elevated\_groups are currently `super_seer` and `super_privileged` groups

### [requirements.txt](/django/requirements.txt)
- if using sqlite, you may remove `psycopg2-binary==2.9.10` from `requirements.txt`
- this is Django 4.2.18 so versioning won't match for Django 5
  - commands: `pip install --upgrade pip setuptools wheel && pip install whitenoise "django-allauth[socialaccount]" psycopg2-binary`
  - after success: `pip freeze > requirements.txt`
