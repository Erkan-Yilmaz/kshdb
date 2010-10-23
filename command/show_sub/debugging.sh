# -*- shell-script -*-
# "show debugging" debugger command
#
#   Copyright (C) 2010 Rocky Bernstein rocky@gnu.org
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

_Dbg_do_show_debugging() {
    typeset onoff=${1:-'on'}
    [[ -n $label ]] && label='debugger: '
    typeset onoff="off."
    (( $_Dbg_debugging )) && onoff='on.'
    _Dbg_msg \
	"${label}Allow debugging the debugger is" $onoff
    return 0
}
