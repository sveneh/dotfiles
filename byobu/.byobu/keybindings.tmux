# Default Byobu Prefix Key (C-a instead of C-b)
unbind-key -n C-a
set -g prefix ^A
set -g prefix2 F12
bind a send-prefix

# re-bind F2 so that automatic rename works
unbind-key -n F2
bind-key   -n F2 new-window -c "#{pane_current_path}"

# https://stackoverflow.com/questions/51639540/tmux-scroll-mode-vim-keybindings
set-window-option -g mode-keys vi
bind-key -T copy-mode-vi v send -X begin-selection
bind-key -T copy-mode-vi V send -X select-line
bind-key -T copy-mode-vi y send -X copy-pipe-and-cancel 'xclip -in -selection clipboard'
