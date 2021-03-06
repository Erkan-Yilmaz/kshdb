# complete.sh - gdb-like 'complete' command
#
#   Copyright (C) 2010, 2011 Rocky Bernstein <rocky@gnu.org>
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

if [[ $0 == ${.sh.file##*/} ]] ; then
    src_dir=${.sh.file%/*}
    top_dir=${src_dir}/..
    for lib_file in help alias ; do source $top_dir/lib/${lib_file}.sh; done
fi

_Dbg_help_add complete \
'complete PREFIX-STR...

Show command completion strings for PREFIX-STR
' 1

_Dbg_do_complete() {
    typeset -a args; args=($@)
    _Dbg_matches=()
    if (( ${#args[@]} == 2 )) ; then
      _Dbg_subcmd_complete ${args[0]} ${args[1]}
    elif (( ${#args[@]} == 1 )) ; then 
	# FIXME: add in aliases
	typeset -a COMPREPLY
	typeset list
	list="${!_Dbg_debugger_commands[@]}"
	compgen_opt_words "$list" "${args[0]}"
	_Dbg_matches=( ${COMPREPLY[@]} )
    fi  
    typeset -i i
    for (( i=0;  i < ${#_Dbg_matches[@]}  ; i++ )) ; do 
      _Dbg_msg ${_Dbg_matches[$i]}
    done
}

# Demo it.
if [[ $0 == ${.sh.file##*/} ]] ; then
    source $top_dir/lib/complete.sh
    source $top_dir/command/help.sh 
    _Dbg_libdir=$top_dir/lib
    source $_Dbg_libdir/msg.sh
    for _Dbg_file in $src_dir/d*.sh ; do 
	source $_Dbg_file
    done
    
    _Dbg_args='complete'
    _Dbg_do_help complete
    _Dbg_do_complete d
fi
