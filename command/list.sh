# -*- shell-script -*-
# list.sh - Some listing commands
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

# _Dbg_help_add list \
# 'list [START|.|FN] [COUNT] -- List lines of a script.

# START is the starting line or dot (.) for current line. Subsequent
# list commands continue from the last line listed. If a function name
# is given list the text of the function.

# If COUNT is omitted, use the setting LISTSIZE. Use "set listsize" to 
# change this setting.'

# # l [start|.] [cnt] List cnt lines from line start.
# # l sub       List source code fn

# _Dbg_do_list() {
#     typeset first_arg
#     if (( $# > 0 )) ; then
# 	first_arg="$1"
# 	shift
#     else
# 	first_arg='.'
#     fi
    
#     if [[ $first_arg == '.' ]] ; then
# 	echo "$_Dbg_frame_last_filename"
# 	echo "$*"
# 	_Dbg_list $_Dbg_frame_last_filename $*
# 	return $?
#     fi

#     typeset filename
#     typeset -i line_number
#     typeset full_filename
    
#     _Dbg_linespec_setup $first_arg
    
#     if [[ -n $full_filename ]] ; then 
# 	(( $line_number ==  0 )) && line_number=1
# 	_Dbg_check_line $line_number "$full_filename"
# 	(( $? == 0 )) && \
# 	    _Dbg_list "$full_filename" "$line_number" $*
# 	return $?
#     else
# 	_Dbg_file_not_read_in $filename
# 	return 1
#     fi
# }

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
    (( $rc != 0 )) && return $rc
    _Dbg_list_columns columnize_list
    return $?
}

