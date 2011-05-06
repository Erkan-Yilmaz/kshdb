# -*- shell-script -*-
# help.sh - Debugger Help Routines
#
#   Copyright (C) 2002, 2003, 2004, 2005, 2006, 2007, 2008, 2010, 2011
#   Rocky Bernstein <rocky@gnu.org>
#
#   This program is free software; you can redistribute it and/or
#   modify it under the terms of the GNU General Public License as
#   published by the Free Software Foundation; either version 2, or
#   (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
#   General Public License for more details.
#   
#   You should have received a copy of the GNU General Public License
#   along with this program; see the file COPYING.  If not, write to
#   the Free Software Foundation, 59 Temple Place, Suite 330, Boston,
#   MA 02111 USA.

# A place to put help command text
typeset -A _Dbg_command_help
export _Dbg_command_help

# List of debugger commands. 
# FIXME: for now we are attaching this to _Dbg_help_add which
# is whe this is here. After moving somewhere more appropriate, relocate
# the definition.
typeset -A _Dbg_debugger_commands

# Add help text $2 for command $1
function _Dbg_help_add {
    (($# < 2)) || (($# > 4))  && return 1
    typeset -i add_command; add_command=${3:-0}
    _Dbg_command_help[$1]="$2"
    (( add_command )) && _Dbg_debugger_commands[$1]="_Dbg_do_$1"
    # if (($# == 4)); then
    # 	complete -F "$4" "$1"
    # fi
    return 0
}

# Add help text $3 for in subcommand $1 under key $2
function _Dbg_help_add_sub {
    add_command=${4:-1}
    (($# != 3)) && (($# != 4))  && return 1
    eval "_Dbg_command_help_$1[$2]=\"$3\""
    if (( add_command )) ; then
    	eval "_Dbg_debugger_${1}_commands[$2]=\"_Dbg_do_${1}_${2}\""
    fi
    return 0
}

_Dbg_help_set() {

    typeset subcmd
    if (( $# == 0 )) ; then 
        typeset -a list
        list=("${!_Dbg_command_help_show[@]}")
        sort_list 0 ${#list[@]}-1
	for subcmd in $list ; do 
	    _Dbg_help_set $subcmd 1
	done
	return 0
    fi
    
    subcmd="$1"
    typeset label="$2"
    
    if [[ -n "${_Dbg_command_help_set[$subcmd]}" ]] ; then 
	if [[ -z $label ]] ; then 
 	    _Dbg_msg "${_Dbg_command_help_set[$subcmd]}"
	    return 0
	else
	    label=$(builtin printf "set %-12s-- " $subcmd)
	fi
    fi

    case $subcmd in 
	ar | arg | args )
	    [[ -n $label ]] && label='set args -- '
	    _Dbg_msg \
		"${label}Set argument list to give program being debugged when it is started.
Follow this command with any number of args, to be passed to the program."
	    return 0
	    ;;
	an | ann | anno | annot | annota | annotat | annotate )
	    if [[ -z $label ]] ; then 
		typeset post_label='
0 == normal;     1 == fullname (for use when running under emacs).'
	    fi
	    _Dbg_msg \
		"${label}Set annotation level.$post_label"
	    return 0
	    ;;
	autoe | autoev | autoeva | autoeval )
	    _Dbg_help_set_onoff 'autoeval' 'autoeval' \
		"Evaluate unrecognized commands"
	    return 0
	    ;;
	autol | autoli | autolis | autolist )
	    typeset -l onoff="on."
	    [[ -z ${_Dbg_cmdloop_hooks['list']} ]] && onoff='off.'
	    _Dbg_msg \
		"${label}Run list command is ${onoff}"
	    return 0
	    ;;
	b | ba | bas | base | basen | basena | basenam | basename )
	    _Dbg_help_set_onoff 'basename' 'basename' \
		"Set short filenames (the basename) in debug output"
	    return 0
	    ;;
	deb|debu|debug|debugg|debugger|debuggi|debuggin|debugging )
	    _Dbg_help_set_onoff 'debugging' 'debugging' \
	      "Set debugging the debugger"
	    return 0
	    ;;
	force | dif | diff | differ | different )
	    _Dbg_help_set_onoff 'different' 'different' \
	      "Set stepping forces a different line"
	    return 0
	    ;;
	inferior-tty )
	    _Dbg_msg "${label} set tty for input and output"
	    ;;
	lin | line | linet | linetr | linetra | linetrac | linetrace )
	    typeset onoff='off.'
	    (( _Dbg_set_linetrace )) && onoff='on.'
	    _Dbg_msg \
		"${label}Set tracing execution of lines before executed is" $onoff
	    if (( _Dbg_set_linetrace )) ; then
		_Dbg_msg \
		    "set linetrace delay -- delay before executing a line is" $_Dbg_linetrace_delay
	    fi
	    return 0
	    ;;
	lis | list | lists | listsi | listsiz | listsize )
	    _Dbg_msg \
		"${label}Set number of source lines $_Dbg_debugger_name will list by default."
	    ;;
	p | pr | pro | prom | promp | prompt )
	    _Dbg_msg \
		"${label}${_Dbg_debugger_name}'s prompt is: \"$_Dbg_prompt_str\"."
	    return 0
	    ;;
	sho|show|showc|showco|showcom|showcomm|showcomma|showcomman|showcommand )
	    _Dbg_msg \
		"${label}Set showing the command to execute is $_Dbg_show_command."
	    return 0
	    ;;
	t|tr|tra|trac|trace|trace-|tracec|trace-co|trace-com|trace-comm|trace-comma|trace-comman|trace-command|trace-commands )
	    _Dbg_msg \
		"${label}Set showing debugger commands is $_Dbg_set_trace_commands."
	    return 0
	    ;;
	w | wi | wid | widt | width )
	    _Dbg_msg \
		"${label}Set line length to use in output."
	    ;;
	* )
	    _Dbg_msg \
		"There is no \"set $subcmd\" command."
    esac
}

_Dbg_help_show() {
    typeset show_cmd=$1
    
    if (( $# == 0 )) ; then 
        typeset -a list
        list=("${!_Dbg_command_help_show[@]}")
        sort_list 0 ${#list[@]}-1
        for subcmd in ${list[@]}; do
            _Dbg_help_show $subcmd 1
	done
        return 0
    fi
    
    typeset subcmd=$1
    typeset label="$2"

    if [[ -n "${_Dbg_command_help_show[$subcmd]}" ]] ; then 
	if [[ -z $label ]] ; then 
 	    _Dbg_msg "${_Dbg_command_help_show[$subcmd]}"
	    return 0
	else
	    label=$(builtin printf "show %-12s--" $subcmd)
	fi
    fi

    case $subcmd in 
	al | ali | alia | alias | aliase | aliases )
	    _Dbg_msg \
		"$label Show list of aliases currently in effect."
	    return 0
	    ;;
	ar | arg | args )
	    _Dbg_msg \
		"$label Show argument list to give when program is restarted."
	    return 0
	    ;;
	an | ann | anno | annot | annota | annotat | annotate )
	    _Dbg_msg \
		"$label Show annotation_level"
	    return 0
	    ;;
	autoe | autoev | autoeva | autoeval )
	    _Dbg_msg \
		"$label Show if we evaluate unrecognized commands."
	    return 0
	    ;;
	autol | autoli | autolis | autolist )
	    _Dbg_msg \
		"$label Run list before command loop?"
	    return 0
	    ;;
	b | ba | bas | base | basen | basena | basenam | basename )
	    _Dbg_msg \
		"$label Show if we are are to show short or long filenames."
	    return 0
	    ;;
	com | comm | comma | comman | command | commands )
	    _Dbg_msg \
		"$label Show the history of commands you typed."
	    ;;
	cop | copy| copyi | copyin | copying )
	    _Dbg_msg \
		"$label Conditions for redistributing copies of debugger."
	    ;;
	d|de|deb|debu|debug|debugg|debugger|debuggi|debuggin|debugging )
	    _Dbg_msg \
		"$label Show if we are set to debug the debugger."
	    return 0
	    ;;
	different | force)
	    _Dbg_msg \
		"$label Show if setting forces a different line."
	    ;;
	dir|dire|direc|direct|directo|director|directori|directorie|directories)
	    _Dbg_msg \
		"$label Show file directories searched for listing source."
	    ;;
	lin | line | linet | linetr | linetra | linetrac | linetrace )
	    _Dbg_msg \
		"$label Show whether to trace lines before execution."
	    ;;
	lis | list | lists | listsi | listsiz | listsize )
	    _Dbg_msg \
		"$label Show number of source lines debugger will list by default."
	    ;;
	p | pr | pro | prom | promp | prompt )
	    _Dbg_msg \
		"$label Show debugger prompt."
	    return 0
	    ;;
	t|tr|tra|trac|trace|trace-|trace-c|trace-co|trace-com|trace-comm|trace-comma|trace-comman|trace-command|trace-commands )
	    _Dbg_msg \
		'show trace-commands -- Show if we are echoing debugger commands'
	    return 0
	    ;;
	w | wa | war | warr | warra | warran | warrant | warranty )
	    _Dbg_msg \
		"$label Various kinds of warranty you do not have."
	    return 0
	    ;;
	* )
	    _Dbg_msg \
		"Undefined show command: \"$subcmd\".  Try \"help show\"."
    esac
}

