# ─── Profiling (uncomment to benchmark) ──────────────────────────────
# zmodload zsh/zprof

# ─── Oh My Zsh settings (set BEFORE sourcing) ────────────────────────
export ZSH="$HOME/.oh-my-zsh"
DISABLE_AUTO_UPDATE="true"
DISABLE_MAGIC_FUNCTIONS="true"
DISABLE_COMPFIX="true"
skip_global_compinit=1

# ─── Faster, portable compinit ───────────────────────────────────────
autoload -Uz compinit
if [[ -n ~/.zcompdump(#qN.mh+24) ]]; then
    compinit
else
    compinit -C
fi

# ─── No OMZ theme — Starship takes over ──────────────────────────────
ZSH_THEME=""

# ─── Plugins ─────────────────────────────────────────────────────────
plugins=(
  git
  zsh-autosuggestions
  fast-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# ─── Autosuggestions tuning ──────────────────────────────────────────
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#663399,standout"
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=300
ZSH_AUTOSUGGEST_USE_ASYNC=1
ZSH_AUTOSUGGEST_STRATEGY=(history completion)

# ─── Global alias expansion on space ─────────────────────────────────
globalias() {
   if [[ $LBUFFER =~ '[a-zA-Z0-9]+$' ]]; then
       zle _expand_alias
       zle expand-word
   fi
   zle self-insert
}
zle -N globalias
bindkey " " globalias
bindkey "^[[Z" magic-space
bindkey -M isearch " " magic-space

# ─── SSH agent: start once, not every prompt ─────────────────────────
if [[ -z "$SSH_AUTH_SOCK" ]]; then
    eval "$(ssh-agent -s)" > /dev/null
    ssh-add ~/.ssh/id_github_sign_and_auth 2>/dev/null
fi

# ─── fnm (Fast Node Manager) ─────────────────────────────────────────
if command -v fnm &> /dev/null; then
    eval "$(fnm env --use-on-cd --shell zsh)"
fi

# ─── PATH ────────────────────────────────────────────────────────────
typeset -U path                      # dedupe PATH entries automatically
path=(
    $HOME/.local/bin
    $path
)
export PATH

# ─── History ─────────────────────────────────────────────────────────
HISTSIZE=50000
SAVEHIST=50000
HISTFILE=~/.zsh_history
setopt HIST_IGNORE_ALL_DUPS HIST_IGNORE_SPACE SHARE_HISTORY INC_APPEND_HISTORY

# ─── Starship — MUST be last so it owns the prompt ───────────────────
eval "$(starship init zsh)"

# ─── Aliases ─────────────────────────────────────────────────────────
[ -f ~/.zsh_aliases ] && source ~/.zsh_aliases

# zprof
