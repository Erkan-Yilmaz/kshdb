# -*- shell-script -*-
# save-restore.sh - Debugger Utility Functions
#
#   Copyright (C) 2008 Rocky Bernstein rocky@gnu.org
#
#   kshdb is free software; you can redistribute it and/or modify it under
#   the terms of the GNU General Public License as published by the Free
#   Software Foundation; either version 2, or (at your option) any later
#   version.
#
#   kshdb is distributed in the hope that it will be useful, but WITHOUT ANY
#   WARRANTY; without even the implied warranty of MERCHANTABILITY or
#   FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
#   for more details.
#   
#   You should have received a copy of the GNU General Public License along
#   with kshdb; see the file COPYING.  If not, write to the Free Software
#   Foundation, 59 Temple Place, Suite 330, Boston, MA 02111 USA.

# Does things to after on entry of after an eval to set some debugger
# internal settings  
_Dbg_set_debugger_internal() {
  IFS="$_Dbg_space_IFS";
  PS4='(${.sh.file}:${.sh.lineno}:[${.sh.subshell}]): ${.sh.fun}
'
}

function _Dbg_restore_user_vars {
  IFS="$_Dbg_space_IFS";
  set -$_Dbg_old_set_opts
  IFS="$_Dbg_old_IFS";
  PS4="$_Dbg_old_PS4"
}

# Do things for debugger entry. Set some global debugger variables
# Remove trapping ourselves. 
# We assume that we are nested two calls deep from the point of debug
# or signal fault. If this isn't the constant 2, then consider adding
# a parameter to this routine.
_Dbg_set_debugger_entry() {

    _Dbg_rc=0
    _Dbg_return_rc=0
    _Dbg_old_IFS="$IFS"
    _Dbg_old_PS4="$PS4"
    _Dbg_set_debugger_internal
    _Dbg_source_journal
    if (( _Dbg_QUIT_LEVELS > 0 )) ; then
	_Dbg_do_quit $_Dbg_debugged_exit_code
    fi
}

function _Dbg_set_to_return_from_debugger {
  _Dbg_rc=$?

  _Dbg_brkpt_num=0
  _Dbg_stop_reason=''
#   if (( $1 != 0 )) ; then
#     _Dbg_last_ksh_command="$_Dbg_ksh_command"
#     _Dbg_last_curline="$_curline"
#     _Dbg_last_source_file="${.sh.file}"
#   else
#     _Dbg_last_curline==${KSH_LINENO[1]}
#     _Dbg_last_source_file=${KSH_SOURCE[2]:-$_Dbg_bogus_file}
#     _Dbg_last_ksh_command="**unsaved _kshdb command**"
#   fi

  _Dbg_restore_user_vars
}

