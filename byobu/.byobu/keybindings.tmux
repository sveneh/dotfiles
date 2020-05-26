# Default Byobu Prefix Key (C-a instead of C-b)
unbind-key -n C-a
set -g prefix ^A
set -g prefix2 F12
bind a send-prefix

# re-bind F2 so that automatic rename works
unbind-key -n F2
bind-key   -n F2 new-window -c "#{pane_current_path}"
