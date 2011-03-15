# -*- shell-script -*-
# set.sh - debugger settings
#
#   Copyright (C) 2002,2003,2006,2007,2008,2010,2011 Rocky Bernstein 
#   <rocky@gnu.org>
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

# Sets whether or not to display command to be executed in debugger prompt.
# If yes, always show. If auto, show only if the same line is to be run
# but the command is different.

typeset -i _Dbg_linewidth; _Dbg_linewidth=${COLUMNS:-80} 
typeset -i _Dbg_linetrace_expand=0 # expand variables in linetrace output
typeset -f _Dbg_linetrace_delay=0  # sleep after linetrace

typeset -i _Dbg_set_autoeval=0     # Evaluate unrecognized commands?
typeset -i _Dbg_set_listsize=10    # How many lines in a listing? 

# Sets whether or not to display command before executing it.
typeset _Dbg_set_trace_commands='off'

_Dbg_help_add set ''  1 # Help routine is elsewhere

# Load in "show" subcommands
for _Dbg_file in ${_Dbg_libdir}/command/set_sub/*.sh ; do 
    source $_Dbg_file
done

_Dbg_do_set() {
    typeset -l set_cmd=$1
    typeset -l rc
    if [[ $set_cmd == '' ]] ; then
	_Dbg_msg "Argument required (expression to compute)."
	return;
    fi
    shift
    case $set_cmd in 
	ar | arg | args )
	    _Dbg_do_set_args $@
	    ;;
	an | ann | anno | annot | annota | annotat | annotate )
	    _Dbg_do_set_annotate $@
	    ;;
	autoe | autoev | autoeva | autoeval )
	    _Dbg_set_onoff "$1" 'autoeval'
	    ;;
	autol | autoli | autolis | autolist )
	    _Dbg_do_set args $@
	    ;;
	b | ba | bas | base | basen | basena | basenam | basename )
	    _Dbg_set_onoff "$1" 'basename'
	    ;;
	de|deb|debu|debug|debugg|debugger|debuggi|debuggin|debugging )
	    _Dbg_set_onoff $1 'debugging'
	    ;;
	e | ed | edi | edit | editi | editin | editing )
	    _Dbg_set_editing $@
	    ;;
	force | dif | diff | differ | different )
	    _Dbg_set_onoff "$1" 'different'
	    ;;
	hi|his|hist|histo|histor|history)
	    _Dbg_do_set_history $@
	    ;;
	inferior-tty )
	    _Dbg_set_tty $@
	    ;;
	lin | line | linet | linetr | linetra | linetrac | linetrace )
	    _Dbg_do_set_linetrace $@
	    ;;
	li | lis | list | lists | listsi | listsiz | listsize )
	    _Dbg_do_set_listsize $@
	    ;;
	lo | log | logg | loggi | loggin | logging )
	    _Dbg_cmd_set_logging $*
	    ;;
	p | pr | pro | prom | promp | prompt )
	    _Dbg_prompt_str="$1"
	    ;;
	sho|show|showc|showco|showcom|showcomm|showcomma|showcomman|showcommand )
	    _Dbg_do_set_showcommand $@
	    ;;
	t|tr|tra|trac|trace|trace-|trace-c|trace-co|trace-com|trace-comm|trace-comma|trace-comman|trace-command|trace-commands )
	    _Dbg_do_set_trace_commands $@
	    ;;
	w | wi | wid | width )
	    _Dbg_do_set_width $@
	    ;;
	*)
	    _Dbg_undefined_cmd "set" "$set_cmd"
	    return 1
    esac
    return 0
}
