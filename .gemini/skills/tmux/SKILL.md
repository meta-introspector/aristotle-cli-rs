---
name: "tmux"
description: "Tmux session management — capture pane content, list sessions/windows/panes, navigate between windows, send commands to panes, and monitor git status across all open worktrees. Use when reviewing the tmux landscape, capturing state from running sessions, or sending commands to specific panes."
---

# tmux — Session Management Skill

## Capture All Panes

Capture every pane across all sessions with git status, lsof, and content:

```bash
bash ~/projects/tmux/capture.sh
# Output → ~/projects/tmux/logs/capture-<timestamp>.txt
```

## List Sessions / Windows / Panes

```bash
tmux list-sessions                    # All sessions
tmux list-windows -a                  # All windows across sessions
tmux list-panes -a -F '#{session_name} #{window_index} #{pane_id} #{pane_pid} #{pane_current_path}'
```

## Navigate

```bash
tmux select-window -t 4               # Switch to window 4
tmux send-keys -t 0:4 'command' Enter # Send command to session 0, window 4
```

## Capture Specific Pane

```bash
tmux capture-pane -t 0:4 -p           # Capture window 4 content
tmux capture-pane -t 0:4.%74 -p       # Capture specific pane
```

## Git Status Across All Panes

```bash
tmux list-panes -a -F '#{pane_current_path}' | while read path; do
  if [ -d "$path/.git" ] || [ -f "$path/.git" ]; then
    echo "=== $path ==="
    (cd "$path" && git status -sb --untracked-files=no)
  fi
done
```

## Current Session Layout

```
Session 0: 13 windows
  0: pi            — worktrees/test2
  1: forge          — forgecode
  2: pi             — zombie_driver2
  3: emacs          — forgecode
  4: pi collection  — diagonalize (OUR WORK)
  5: pi             — vendormod refactor
  6: python3Z       — lean-split-tool + aristotle
  7: kilo           — cargo-vendormod
  10: pi            — kilocode-d8-2a
  11: pi            — sparql-gui
  12: pi fixing nginx — tiles-publication (3 commits ahead)
  14: pi            — kilocode-d8-2a
  16: node          — nora + tmux capture
```

## Tile Integration

Each pane's working directory maps to a DASL tile:

| Window | Project | Tile |
|--------|---------|------|
| 4 | diagonalize | `diagonalize-tile` :8082 |
| 11 | sparql-gui | `sparql-gui-tile` |
| 16 | nora | `nora-monitor-tile` :4000 |

## Key Files

- `~/projects/tmux/capture.sh` — full pane capture with git/lsof/content
- `~/projects/tmux/logs/` — capture output directory
- `~/projects/dotagents/TMUX_LANDSCAPE.md` — documented landscape
