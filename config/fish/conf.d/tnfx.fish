# TNFX terminal look: starship prompt, eza listings, zoxide. Each part is skipped if the tool is missing.
status is-interactive; or exit
command -q starship; and starship init fish | source
command -q zoxide; and zoxide init fish | source
if command -q eza
    alias ls='eza --icons'
    alias ll='eza -lah --icons --git'
    alias tree='eza --tree --icons'
end
