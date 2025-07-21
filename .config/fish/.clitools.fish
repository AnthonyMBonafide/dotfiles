# Import me last
set -gx OLLAMA_API_BASE http://127.0.0.1:11434
set -gx OLLAMA_CONTEXT_LENGTH 8192

abbr n nvim
abbr ls eza
abbr l 'eza -al --icons always -b --git --total-size'
abbr lt 'eza -al --icons always -b --git --total-size -T'
abbr cd z
abbr .. 'z ..'
abbr pms 'podman machine start'

# starship init fish | source
zoxide init fish | source
