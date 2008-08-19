# -*- shell-script -*-
# edit.sh - Debugger Edit routine

#   Copyright (C) 2008 Rocky Bernstein rocky@gnu.org
#
#   zshdb is free software; you can redistribute it and/or modify it under
#   the terms of the GNU General Public License as published by the Free
#   Software Foundation; either version 2, or (at your option) any later
#   version.
#
#   zshdb is distributed in the hope that it will be useful, but WITHOUT ANY
#   WARRANTY; without even the implied warranty of MERCHANTABILITY or
#   FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
#   for more details.
#   
#   You should have received a copy of the GNU General Public License along
#   with zshdb; see the file COPYING.  If not, write to the Free Software
#   Foundation, 59 Temple Place, Suite 330, Boston, MA 02111 USA.

#================ VARIABLE INITIALIZATIONS ====================#

_Dbg_help_add edit \
"edit [LOCATION]	-- Edit specified file at LOCATION.

If LOCATION is not given, use the current location."

_Dbg_do_edit() {
  typeset editor=${EDITOR:-ex}
  if (($# > 2)) ; then 
      _Dbg_errmsg "got $# parameters, but need 0 or 1."
      return 2
  fi
  typeset -i line_number
  if (( $# == 0 )) ; then
    _Dbg_frame_lineno
    line_number=$?
    unset _Dbg_frame_filename
    _Dbg_frame_file
    ((0 != $?)) && return 3
    ((line_number<=0)) && return 4
    full_filename=$_Dbg_frame_filename
  else
    _Dbg_linespec_setup "$1"
  fi
  if [[ ! -r $full_filename ]]  ; then 
      _Dbg_errmsg "File $full_filename is not readable"
  fi
  $editor +$line_number $full_filename
}

_Dbg_alias_add 'ed' 'edit'
