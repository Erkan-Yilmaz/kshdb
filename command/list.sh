# -*- shell-script -*-
# list.sh - Some listing commands
#
#   Copyright (C) 2008, 2009, 2010, 2011 
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

_Dbg_help_add list \
'list[>] [LOC|.|-] [COUNT] -- List COUNT lines of a script centered around LOC

LOC is the starting location or dot (.) for current file and
line. Subsequent list commands continue from the last line
listed. Frame switching however resets the line to dot.

If COUNT is omitted, use the setting LISTSIZE. Use "set listsize" to 
change this setting.

By default aliases "l>" and "list>" are set to list. In this case and
more generally when the alias ends in ">", rather than center lines
around LOC that will be used as the starting point.
'

# l [start|.|-] [cnt] List cnt lines from line start.

_Dbg_do_list() {
    typeset first_arg
    typeset -i adjust_line=1
    [[ ${_Dbg_orig_cmd:${#_Dbg_orig_cmd}-1} == '>' ]] && adjust_line=0
    if (( $# == 0 )) ; then
	if ((_Dbg_listline < 0 )) ; then
	    first_arg='.'
	else
	    first_arg=$_Dbg_listline
	    adjust_line=0
	fi
    else
	first_arg="$1"
	shift
    fi
    typeset count=${1:-$_Dbg_set_listsize}

    if [[ $first_arg == '.' ]] ; then
	first_arg=$_Dbg_frame_last_lineno
    elif [[ $first_arg == '-' ]] ; then
	typeset -i start_line
	if ((_Dbg_listline < 0 )) ; then
	    ((start_line=_Dbg_frame_last_lineno-_Dbg_set_listsize))
	else
	    ((start_line=_Dbg_listline-2*_Dbg_set_listsize))
	fi
	if (( start_line <= 0 )) ; then
	    ((count=count+start_line-1))
	    start_line=1
	fi
	first_arg=$start_line
    fi

    typeset filename
    typeset -i line_number
    typeset full_filename
    
    _Dbg_linespec_setup $first_arg
    
    _Dbg_last_cmd='list'
    if [[ -n $full_filename ]] ; then 
	if ((1 == adjust_line)); then
	    ((line_number -= count/2))
	fi
	(( line_number <=  0 )) && line_number=1
	_Dbg_check_line $line_number "$full_filename"
	(( $? == 0 )) && \
	    _Dbg_list "$full_filename" "$line_number" $count
    else
	_Dbg_file_not_read_in "$filename"
    fi
    return 0
}

# _Dbg_do_list_globals() {
#     (($# != 0)) && return 1
#     list=(${(k)parameters[(R)*^local*]})
#     typeset -i rc=$?
#     (( $rc != 0 )) && return $rc
#     _Dbg_list_columns
#     return $?
# }

# _Dbg_do_list_locals() {
#     (($# != 0)) && return 1
#     list=(${(k)parameters[(R)*local*]})
#     typeset -i rc=$?
#     (( $rc != 0 )) && return $rc
#     _Dbg_list_columns
#     return $?
# }

# List in column form variables having attribute $1.
# A grep pattern can be given in $2. ! indicates negation.
_Dbg_do_list_typeset_attr() {
    (($# == 0)) && return 1
    typeset attr="$1"; shift
    typeset -a columnize_list=( $(_Dbg_get_typeset_attr "$attr" $*) )
    typeset -i rc=$?
    (( rc != 0 )) && return $rc
    _Dbg_list_columns columnize_list
    return $?
}

_Dbg_alias_add l list
_Dbg_alias_add 'l>' list
_Dbg_alias_add 'list>' list
