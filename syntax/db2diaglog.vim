" Vim syntax file
" Language:     DB2 db2diag.log file
" Maintainer:   Jacobo de Vera
" URL:          http://blog.jacobodevera.com/
" Last Change:  2009 Jun 22
" Version:      1.0.0

" ---- Setup ---- {{{
" Remove any old syntax settings
syn clear
syn case ignore

if exists("b:current_syntax")
  finish
endif
let s:cpo_save = &cpo
set cpo&vim

" All matches are case sensitive
syn case match

" ---- End Setup ---- }}}

" Each record begins with a non-blank line and ends with a blank line
" -------------------------------------------------------------------
syn region ddlEntry start="^[^$]" end="^$" keepend contains=TOP fold

  " First Line of each record {{{
  " -----------------------------
  syn region ddlTimeStamp start="^[0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\}-" end="\s" keepend transparent nextgroup=ddlRecId skipwhite
    syn match ddlTimeStampSeparator "-"                                              containedin=ddlTimeStamp contained
    syn match ddlDate               "^[0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\}"              containedin=ddlTimeStamp contained
    syn match ddlTime               "[0-9]\{2\}\.[0-9]\{2\}\.[0-9]\{2\}\.[0-9]\{6\}" containedin=ddlTimeStamp contained
    syn match ddlTimeZone           "[0-9][0-9][0-9]\s"                              containedin=ddlTimeStamp contained

  " Record Id, this is normally not highlighted, it does not provide any
  " useful information.
  " --------------------------------------------------------------------
  syn region ddlRecId start="\<I" start="\<E" end="\s" nextgroup=ddlLevel

  " Log level of each record. Some levels, i.e. Error and Severe, have
  " a special highlighting to make them stand out.
  " --------------------------------------------------------------------
  syn region ddlLevel matchgroup=ddlFieldName start="LEVEL" end="$"
    syn match ddlErrorLevel  "Error"     containedin=ddlLevel  contained
    syn match ddlSevereLevel "Severe.*"  containedin=ddlLevel  contained

  " ---- End Of First Line ---- }}}

  " Fields that do not extend to new lines {{{
  " ------------------------------------------

  " PID TID PROC
  " ------------
  syn region ddlFieldsPid matchgroup=ddlFieldName start="^PID" end="$"
    syn match ddlFieldsInPidLine /TID\>\|PROC\>/ containedin=ddlFieldsPid contained

  " INSTANCE NODE DB
  " ----------------
  syn region ddlFieldsInstance matchgroup=ddlFieldName start="^INSTANCE" end="$"
    syn match ddlFieldsInInstanceLine /NODE\>\|DB\>[^$]/ containedin=ddlFieldsInstance contained

  " START
  " -----
  syn region ddlFieldsStart matchgroup=ddlFieldName start="^START" end="$"

  " APPHDL APPID
  " ------------
  syn region ddlFieldsApphdl matchgroup=ddlFieldName start="^APPHDL" end="$"
    syn match ddlFieldsInApphdlLine /APPID\>/ containedin=ddlFieldsApphdl contained

  " AUTHID
  " ------
  syn region ddlFieldsAuthid matchgroup=ddlFieldName start="^AUTHID" end="$"

  " EDUID EDUNAME
  " -------------
  syn region ddlFieldsEduid matchgroup=ddlFieldName start="^EDUID" end="$"
    syn match ddlFieldsInEduidLine /EDUNAME\>/ containedin=ddlFieldsEduid contained

  " FUNCTION probe
  " --------------
  syn region ddlFieldsFunction matchgroup=ddlFieldName start="^FUNCTION" end="$" keepend
    syn match ddlFunctionName /,[^,]*,[^,]*/ containedin=ddlFieldsFunction contained
    syn match ddlPreFuncName /,[^,]*,\s*/ containedin=ddlFunctionName contained
    syn match ddlFieldsInFunctionLine /\<probe\>/ containedin=ddlFieldsFunction contained

  " MESSAGE
  " -------
  syn region ddlFieldsMessage matchgroup=ddlFieldName start="^MESSAGE" end="$"

  " CALLED OSERR
  " ------------
  syn region ddlFieldsCalled matchgroup=ddlFieldName start="^CALLED" end="$"
    syn match ddlFieldsInCalledLine /OSERR\>/ containedin=ddlFieldsCalled contained

  " RETCODE
  " -------
  syn region ddlFieldsRetcode matchgroup=ddlFieldName start="^RETCODE" end="$"
  
  " CHANGE FROM TO
  " --------------
  syn region ddlFieldsChange matchgroup=ddlFieldName start="^CHANGE" end="$"
    syn match ddlFieldsInChangeLine /\<FROM\c\>\|\<TO\c\>/ containedin=ddlFieldsChange contained

  " IMPACT
  " ------
  syn region ddlFieldsImpact matchgroup=ddlFieldName start="^IMPACT" end="$"
  
  " ---- End Of Fields that do not extend to new lines ---- }}}

  " Fields that span across several lines {{{
  
  " DATA and ARG
  " ------------
  " 
  " This region contains each DATA and ARG items.
  " ---------------------------------------------
  syn region ddlArgDataRegion start=/^\(DATA\|ARG\)\s\+#[1-9][0-9]\?\s*\>/ms=s end=/^$/ end=/^DATA/re=e-4,he=e-4,me=e-4 end=/^ARG/re=e-3,he=e-3,me=e-3 end=/^CALLSTCK/re=e-8,he=e-8,me=e-8 keepend
 
     " First line of the DATA or ARG field.
     " ------------------------------------
     syn region ddlArgDataFirstLine matchgroup=ddlFieldName start=/^\(DATA\|ARG\)\s\+#[1-9][0-9]\?\s*\>/ end="$" containedin=ddlArgDataRegion contained transparent

        " Type and size in bytes appear in both DATA and ARG fields.
        " ----------------------------------------------------------
        syn match ddlArgDataType /:\s[^,]\+/hs=s+2 containedin=ddlArgDataFirstLine contained
        syn match ddlArgDataSize /[0-9]\+\s\+bytes/ containedin=ddlArgDataFirstLine contained
 

  " CALLSTCK
  " --------
  "
  " This region contains the whole CALLSTCK field
  " ---------------------------------------------
  syn region ddlFieldsCallStack matchgroup=ddlFieldName start="^CALLSTCK" end=/^$/ keepend
 
     " Callstack entry index (does not include the surrounding bracket)
     " ----------------------------------------------------------------
     syn region ddlCallStackIndex start=/^\s*\[/hs=e+1 end=/\]/he=s-1 contained containedin=ddlFieldsCallStack
     
     " Function name in the callstack
     " ------------------------------
     syn region ddlCallStackFunction start=/0x[0-9a-fA-F]\+\s\+/hs=e+1 end=/\s\++/he=e-1 contained containedin=ddlFieldsCallStack

  " ---- End Of Fields that span across several lines ---- }}}


" ---- Colouring associations ---- {{{
"  
hi link ddlFieldName            Label

hi link ddlDate                 Number
hi link ddlTime                 Special
hi link ddlTimeZone             Number
hi link ddlTimeStampSeparator   Operator

hi link ddlRecId                NONE

hi link ddlLevel                Type
hi link ddlErrorLevel           Error
hi link ddlSevereLevel          Error

hi link ddlFieldsInPidLine      ddlFieldName
hi link ddlFieldsInInstanceLine ddlFieldName
hi link ddlFieldsInApphdlLine   ddlFieldName
hi link ddlFieldsInEduidLine    ddlFieldName
hi link ddlFieldsInFunctionLine ddlFieldName
hi link ddlFieldsInCalledLine   ddlFieldName
hi link ddlFieldsInChangeLine   ddlFieldName

hi link ddlFunctionName         Function
hi link ddlPreFuncName          NONE

hi link ddlArgDataRegion        NONE
hi link ddlArgDataType          Type
hi link ddlArgDataSize          Number

hi link ddlCallStackIndex       Number
hi link ddlCallStackFunction    Macro

" ---- End Of Colouring associations ---- }}}

let b:current_syntax = "db2diaglog"

let &cpo = s:cpo_save
unlet s:cpo_save

" vim: ts=4:sw=4:expandtab

" WHAT FOLLOWS COULD BE A SEPARATE FILE IN ~/.vim/after/syntax/db2diaglog.vim

" Vim syntax file
" Language:     DB2 db2diag.log file extension (HexDump in DATA/ARG field)
" Maintainer:   Jacobo de Vera
" URL:          http://blog.jacobodevera.com/
" Last Change:  2009 Jun 22
" Version:      1.0.0

" This file is intended as an example or template to help someone extend the
" syntax of db2diag.log files so that specific types of data dumps are also
" highlighted.
"
" This particular example highlights Hexdumps in DATA and ARG fields.
"
" Some parts of this template must always be included in order to integrate
" this parcial highlighting with the general one. All this is indicated in the
" comments below.


" Special syntax for HexDump in DATA and ARG
" ------------------------------------------------------------------------
" To use as a template, you must change the region's name and the starting
" pattern (to make it match with the data type you are highlighting). 
" ------------------------------------------------------------------------
syn region ddlHexDump start=/^.*Hexdump.*$/hs=e+1,ms=s,rs=e+1 end=/^$/ end=/^DATA/ end=/^ARG/ contained containedin=ddlArgDataRegion

	" We need to re-highlight the DATA or ARG label, the type and the size
	" in bytes
	" --------------------------------------------------------------------
	" To use as a template, replace the substring ddlHexDump with the name
	" you chose for the region above in the next three syntax commands.
	" You must also change the DataType pattern to make it match the data
	" type you are highlighting.
	" --------------------------------------------------------------------
	
	" DATA or ARG field label
	" -----------------------
	syn match ddlHexDumpDataLabel /^\(DATA\|ARG\)\s\+#[1-9][0-9]\?\s*/ containedin=ddlHexDump contained

	" Type
	" ----
	syn match ddlHexDumpDataType /:\sHexdump/hs=s+2 containedin=ddlHexDump contained

	" Size in bytes
	" -------------
	syn match ddlHexDumpDataSize /[0-9]\+\s\+bytes/ containedin=ddlHexDump contained

	
" Compulsory Highlight Groups links
" --------------------------------------------------------------------
" These links must be here in order to maintain compatibility with the
" main syntax for db2diag.log
" --------------------------------------------------------------------
" To use as a template, replace the HexDump substring in the links 
" below with a suitable name for the data type you are highlighting.
" --------------------------------------------------------------------
hi link ddlHexDumpDataLabel   ddlFieldName
hi link ddlHexDumpDataType    ddlArgDataType
hi link ddlHexDumpDataSize    ddlArgDataSize


" -----------------------------------------------------------------------------
" OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO
" -----------------------------------------------------------------------------
"
" The commands below above are there to ensure compatibility with the main
" syntax highlighting for db2diag.log files.
" The commands below these lines are the actual customisation of the particular
" data type; Hexdump in this case.
"
" -----------------------------------------------------------------------------
" OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO
" -----------------------------------------------------------------------------

" Custom highlight for the Hexdump type
syn match ddlHexDumpAddress /^0x[0-9a-fA-F]\+\s\+:/ containedin=ddlHexDump contained
syn match ddlHexDumpAscii /.\{16\}\s*$/ containedin=ddlHexDump contained
syn match ddlHexDumpAsciiDot /\./  containedin=ddlHexDumpAscii contained
syn match ddlHexDumpSep /:/ containedin=ddlHexDumpAddress contained


hi link ddlHexDumpAddress Number
hi link ddlHexDumpAscii Keyword
hi link ddlHexDumpSep Identifier

" vim: ts=4:sw=4:expandtab:fdm=marker
