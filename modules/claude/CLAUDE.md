# Claude Code Integration

This repository provides user-level Claude Code configuration shared across all projects.
The `claude` module targets **Claude Code only** — Claude Desktop is no longer configured here.

### Step-based application

`modules/claude/apply.sh` is a dispatcher. Every step is independent, so skills can be
updated without reinstalling the CLI:

```bash
sh modules/claude/apply.sh            # interactive step menu (all steps when non-TTY)
sh modules/claude/apply.sh skills     # one step
sh modules/claude/apply.sh skills mcp # several (always run in canonical order)
sh modules/claude/apply.sh all
CLAUDE_APPLY_STEPS=skills sh modules/claude/apply.sh
```

`modules/claude/backup.sh` mirrors this with `mcp` and `settings` steps.

A step whose prerequisites are missing (no `jq`, no `claude`, no resolvable `npx`)
logs a warning and skips, rather than failing the module.

### Skills are symlinked

`~/.claude/skills/<name>` are symlinks into `modules/common`, which Claude Code follows.
Consequences:

- Submodule updates take effect immediately; no re-run needed to pick up edits.
- **Claude Code edits skills in place inside the submodule.** This is detectable and
  reversible: `sh modules/claude/apply.sh doctor` reports it, `git -C modules/common
  checkout -- skills claude/skills` discards it, `git -C modules/common commit` keeps it.
  Under the previous copy-based deployment the same edit was invisible to git and was
  silently destroyed by the next apply.
- Stale skills are pruned by deleting the link. Pruning only touches symlinks whose
  target is inside `modules/common`, so hand-written skills in `~/.claude/skills/` survive.
- On first run, pre-existing real directories are moved to
  `~/.claude/skills.pre-symlink.<timestamp>/` rather than deleted.
- A moved or renamed repository leaves dangling links: the skills disappear from `/skills`,
  `doctor` lists them, and re-running the `skills` step repairs them.
- `~/.agents/skills/` (Codex CLI / Gemini CLI) defaults to copy mode because their
  symlink support is unverified. Set `AGENTS_SKILLS_MODE=symlink` to opt in.

### settings.json merge semantics

`~/.claude/settings.json` is merged, not overwritten, so UI-written keys survive:

- `permissions` and `hooks` are **repository-owned** and replaced wholesale, so a key
  removed from the repository is also removed from the live file.
- Every other key is deep-merged, preserving local values such as `modelSettings`.
- The previous file is snapshotted to `~/.claude/.dotfiles-backups/` first.
- `backup.sh settings` writes back an allowlist (`$schema`, `permissions`, `model`,
  `tui`, `hooks`, `statusLine`, `env`, `cleanupPeriodDays`, and the notification keys)
  so machine-local UI state never enters the submodule.

`tui` is pinned to `fullscreen`. The default `classic` renderer draws inline into the
terminal scrollback without the alternate screen, so once a frame grows taller than the
pane, or the pane width changes and the terminal reflows, it can no longer erase what has
scrolled off and re-emits it: duplicated bands of lines and tables rendered half at the
old width and half at the new one. Measured here under tmux at 120x20 with a width
change: `classic` left 7 distinct lines repeated up to 14 times in the scrollback,
`fullscreen` left none (`#{alternate_on}` 0 vs 1). The cost is that Claude Code owns the
screen, so tmux copy-mode no longer scrolls its output — the `alternate_on` branch of the
WheelUp binding in `tmux/.tmux.conf` forwards the wheel to Claude Code instead. Revert
per machine with `/tui default`.

Bash permission rules match with `*` wildcards. A trailing ` *` and a trailing `:*` are
equivalent, so `Bash(git status *)` and `Bash(git status:*)` both match `git status` and
`git status --short`; the permission dialog writes the space form. `:*` is recognized
only at the end of a pattern. Put the `*` after the subcommand: `Bash(git *)` allows
every git command.

### Notifications

Notifications use the built-in `preferredNotifChannel` setting, not hooks. It is pinned to
`terminal_bell` because the default `auto` sends a desktop notification only in iTerm2,
Ghostty and Kitty, and inside tmux it sends nothing at all. Measured with a permission
prompt left waiting (standalone BEL bytes in the pane output): `TERM_PROGRAM=tmux` gave
0 with `auto` and 1 with `terminal_bell`; `Apple_Terminal` gave 1 with either, and
`notifications_disabled` gave 0. Whether the bell makes a sound, badges the Dock icon or
bounces it is decided by the Terminal.app profile (Settings > Profiles > Advanced > Bell),
which the `terminal` module shares.

Mobile push (`inputNeededNotifEnabled`, `agentPushNotifEnabled`) is explicitly off.

### Subagent model

`CLAUDE_CODE_SUBAGENT_MODEL=opus` with `CLAUDE_CODE_SUBAGENT_MODEL_FORCE=1` keeps
subagents, teammates and workflow agents on Opus when the main session runs Fable. Forks
and skills that run in a subagent with `model: inherit` still use the main model.

**Customization:** user-level overrides go in `~/.claude/settings.json`; per-project
rules in `.claude/settings.local.json`.

### MCP servers

MCP is configured for the Claude Code **user scope** via `claude mcp add-json`, not by
editing `~/.claude.json` directly (that file is live client state the CLI writes
continuously).

`modules/claude/mcp-servers.json` uses `{{NPX}}`, `{{NODE_BIN}}` and `{{HOME}}`
placeholders, resolved at apply time by `resolve_npx` (`mise which npx`, falling back to
`command -v npx`). This keeps the template free of node versions and lets the Linux and
Windows dotfiles repositories share the same file by swapping the resolver.

`backup.sh mcp` reverses the substitution, normalizing version-pinned mise paths back to
placeholders. Servers present in the user scope but absent from the template are reported,
never deleted automatically — promote them with `bash modules/claude/backup.sh mcp`.
