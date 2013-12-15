" includefixer.vim - Sorts C/C++ header files categorically
" Maintainer: Deon Poncini
" Version:    0.1

if exists('g:loaded_include_fixer')
  finish
endif
let g:loaded_include_fixer = 1

let s:cstd = ["assert",
            \ "ctype",
            \ "errno",
            \ "fenv",
            \ "float",
            \ "inttypes",
            \ "iso646",
            \ "limits",
            \ "locale",
            \ "math",
            \ "setjmp",
            \ "signal",
            \ "stdarg",
            \ "stdbool",
            \ "stddef",
            \ "stdint",
            \ "stdio",
            \ "stdlib",
            \ "string",
            \ "tgmath",
            \ "time",
            \ "uchar",
            \ "wchar",
            \ "wctype"]

let s:cxxstd = ["array",
            \ "deque",
            \ "forward_list",
            \ "list",
            \ "map",
            \ "queue",
            \ "set",
            \ "stack",
            \ "unordered_map",
            \ "unordered_set",
            \ "vector",
            \ "fstream",
            \ "iomanip",
            \ "ios",
            \ "iosfwd",
            \ "iostream",
            \ "istream",
            \ "ostream",
            \ "sstream",
            \ "streambuf",
            \ "atomic",
            \ "condition_variable",
            \ "future",
            \ "mutex",
            \ "thread",
            \ "algorithm",
            \ "bitset",
            \ "chrono",
            \ "codecvt",
            \ "complex",
            \ "exception",
            \ "functional",
            \ "initializer_list",
            \ "iterator",
            \ "limits",
            \ "locale",
            \ "memory",
            \ "new",
            \ "numeric",
            \ "random",
            \ "ratio",
            \ "regex",
            \ "stdexcept",
            \ "string",
            \ "system_error",
            \ "tuple",
            \ "typeindex",
            \ "typeinfo",
            \ "type_traits",
            \ "utility",
            \ "valarray"]

function! s:RecordIncludes(includes, lines)
    call add(a:includes,getline("."))
    call add(a:lines,line("."))
endfunction

function! s:ClearEmpty(start,end)
    " delete every empty line between the start and end ranges of includes
    if (line(".") < a:start)
        return
    elseif(line(".") > a:end)
        return
    endif
    execute 'delete _'
endfunction

function! s:IsModule(include, filename)
    let l:mh = substitute(a:include,"include","","")
    let l:mh = substitute(l:mh," ","","g")
    let l:mh = substitute(l:mh,"#","","g")
    let l:mh = substitute(l:mh,"\"","","g")
    let l:mh = substitute(l:mh,"<","","")
    let l:mh = substitute(l:mh,">","","")
    let l:mh = substitute(l:mh,"[.].*","","")
    " check if it is the module header
    return l:mh ==# a:filename
endfunction

function! s:IsBoost(include)
    return a:include =~# '[<"]boost/.*[>"]'
endfunction

function! s:IsQt(include)
    return a:include =~# '[<"]Q[A-Zt].*[>"]'
endfunction

function! s:IsCStd(include)
   for l:h in s:cstd
       if a:include =~# '[<"]c'.l:h.'[>"]'
           return 1
       elseif a:include =~# '[<"]'.l:h.'\.h[>"]'
           return 1
       endif
   endfor
   return 0
endfunction

function! s:IsCxxStd(include)
    for l:h in s:cxxstd
        if a:include =~# '[<"]'.l:h.'[>"]'
            return 1
        endif
    endfor
    return 0
endfunction

function! s:SetupCustom(list)
    if exists('g:include_fixer_custom') == 0
        return
    endif

    let l:i = 0
    while l:i < len(g:include_fixer_custom)
        call add(a:list,[])
        let l:i = l:i + 1
    endwhile
endfunction

function! s:IsCustom(list, include)
    if exists('g:include_fixer_custom') == 0
        return 0
    endif

    let l:i = 0
    while l:i < len(g:include_fixer_custom)
        if a:include =~# g:include_fixer_custom[l:i]
            call add(a:list[l:i],a:include)
            return 1
        endif
        let l:i = l:i + 1
    endwhile
    return 0
endfunction

function! s:WriteOut(start,list)
    " check the list is empty
    if len(a:list) == 0
        return a:start
    endif

    let l:end = a:start + len(a:list)

    " sort the list
    call sort(a:list)

    " write out the list and an empty line
    call append(a:start,a:list)
    call append(l:end,"")
    return l:end + 1
endfunction

function! s:FixIncludes()
    " store the list of includes
    let l:includes = []
    let l:lines = []

    " for each include, store it and delete it
    %g/#include/call <SID>RecordIncludes(l:includes, l:lines)

    if len(l:includes) == 0
        return
    endif

    let l:start = l:lines[0] - 1
    let l:end = l:lines[len(l:lines)-1]
    %g/^\s*$/call <SID>ClearEmpty(l:start, l:end)
    " now we can delete all the includes
    %g/#include/d

    " split and write out the includes
    let l:module = []
    let l:local  = []
    let l:boost  = []
    let l:qt     = []
    let l:cstd   = []
    let l:cxxstd = []
    let l:custom = []
    call <SID>SetupCustom(l:custom)

    " get the filename without extension
    let l:fr = substitute(expand('%:t'),"[.].*","","")

    " iterate and sort
    for l:i in l:includes
        if <SID>IsModule(l:i,l:fr)
            call add(l:module,l:i)
        elseif <SID>IsBoost(l:i)
            call add(l:boost,l:i)
        elseif <SID>IsQt(l:i)
            call add(l:qt,l:i)
        elseif <SID>IsCStd(l:i)
            call add(l:cstd,l:i)
        elseif <SID>IsCxxStd(l:i)
            call add(l:cxxstd,l:i)
        elseif <SID>IsCustom(l:custom,l:i)
        else
            call add(l:local,l:i)
        endif
    endfor

    " write out all the groups
    let l:next = <SID>WriteOut(l:start,l:module)
    let l:next = <SID>WriteOut(l:next,l:local)

    let l:i = 0
    while l:i < len(l:custom)
        let l:next = <SID>WriteOut(l:next,l:custom[l:i])
        let l:i = l:i + 1
    endwhile

    let l:next = <SID>WriteOut(l:next,l:boost)
    let l:next = <SID>WriteOut(l:next,l:qt)
    let l:next = <SID>WriteOut(l:next,l:cstd)
    let l:next = <SID>WriteOut(l:next,l:cxxstd)

endfunction

command! FixIncludes call <SID>FixIncludes()
