# Bash completion for happ-killswitch
_happ_killswitch() {
    local cur prev words cword
    _init_completion || return
    local commands="on off status refresh spoof watch lan-on lan-off install uninstall version help"
    if [[ ${cword} -eq 1 ]]; then
        COMPREPLY=( $(compgen -W "${commands}" -- ${cur}) )
    fi
}
complete -F _happ_killswitch happ-killswitch
