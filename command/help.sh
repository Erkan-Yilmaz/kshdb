# -*- shell-script -*-
# help.sh - gdb-like "help" debugger command
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

_Dbg_add_help help \
'help	- Print list of commands.'

typeset -i _Dbg_help_cols=6
_Dbg_do_help() {
  if ((0==$#)) ; then
      _Dbg_msg "Type 'help <command-name>' for help on a specific command.\n"
      _Dbg_msg 'Available commands:'
#       typeset -a commands
#       for 
#       commands=(${(ki)_Dbg_command_help})
#       print -C $_Dbg_help_cols $commands
   else
      typeset cmd=$1
      if [[ -n ${_Dbg_command_help[$cmd]} ]] ; then
 	  print ${_Dbg_command_help[$cmd]}
      else
	  _Dbg_expand_alias $cmd
	  typeset cmd="$expanded_alias"
	  if [[ -n ${_Dbg_command_help[$cmd]} ]] ; then
 	      print ${_Dbg_command_help[$cmd]}
	  else
      	      print "Don't have help for '$1'."
	  fi
      fi
  fi
}

_Dbg_add_alias '?' help
_Dbg_add_alias 'h' help
