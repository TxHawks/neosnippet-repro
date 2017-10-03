" Automatically install Vim-Plug if it is not yet installed
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

" Call vim-plug to manage plugins
call plug#begin('~/.config/nvim/plugged')

" The LanguageClient requires some extra steps to install correctly.
" See: https://github.com/autozimu/LanguageClient-neovim/blob/master/INSTALL.md
" JavaScript/Typescript: yarn global add javascript-typescript-langserver
" Flow: yarn global add flow-language-server
Plug 'autozimu/LanguageClient-neovim', { 'do': ':UpdateRemotePlugins' }

Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'mhartington/nvim-typescript', {'do': 'yarn global add typescript', 'for': ['typescript']}
Plug 'ternjs/tern_for_vim', { 'do': 'yarn', 'for': ['javascript'] }
Plug 'Shougo/echodoc.vim'
Plug 'Shougo/neosnippet'
Plug 'Shougo/neosnippet-snippets'
Plug 'pangloss/vim-javascript'

" Add plugins to &runtimepath
call plug#end()

scriptencoding utf-8

filetype on
filetype plugin indent on

" Better Unix/Win compatibility
set viewoptions=folds,options,cursor,unix,slash

" Allow for cursor beyond last character
set virtualedit=onemore

" Enabel spell checking
set spell

" Allow buffer switching without saving
set hidden

" Session options
set sessionoptions=buffers,curdir,winpos

" Handle tmux $TERM quirks
if $TERM =~ '^screen-256color' || $TERM =~ '^tmux-256color'
  map <Esc>OH <Home>
  map! <Esc>OH <Home>
  map <Esc>OF <End>
  map! <Esc>OF <End>
endif

" Make neovim use guicolors
set termguicolors

" Show list instead of just completing
set wildmenu

" Command <Tab> completion, list matches,
" then longest common part
set wildmode=list:longest,full

set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*/.tmp/*,*/.sass-cache/*,*/node_modules/*,*.keep,*.DS_Store

" Use tags instead of includes for completions (much faster)
set complete-=i

"## (Plugin) neosnippet {{{
  " Enable function param completion
  let g:neosnippet#enable_completed_snippet = 1

  imap <C-e>     <Plug>(neosnippet_expand_or_jump)
  smap <C-e>     <Plug>(neosnippet_expand_or_jump)
  xmap <C-e>     <Plug>(neosnippet_expand_target)

  " Marker concealment
  if has('conceal')
    set conceallevel=2 concealcursor=niv
  endif
" }}}

"## (Plugin) deoplete {{{
  " Enable deoplete on startup
  let g:deoplete#enable_at_startup = 1

  let g:deoplete#enable_smart_case = 1
  let g:deoplete#max_menu_width = 0

  if !exists('g:deoplete#omni#input_patterns')
    let g:deoplete#omni#input_patterns = {}
  endif

  if !exists('g:deoplete#omni#functions')
    let g:deoplete#omni#functions = {}
  endif

  " Close the documentation window when completion is done
  autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif
" }}}

"## (Plugin) LanguageClient-neovim {{{

  " Language servers need to be installed independently:
  " JavaScript/Typescript: yarn global add javascript-typescript-langserver
  " Flow: yarn global add flow-language-server
        " \ 'javascript': ['flow-language-server', '--try-flow-bin', '--stdio'],
        " \ 'javascript.jsx': ['flow-language-server', '--try-flow-bin', '--stdio'],
  let g:LanguageClient_serverCommands = {
    \ 'javascript': ['javascript-typescript-stdio'],
    \ 'javascript.jsx': ['javascript-typescript-stdio'],
    \ 'typescript': ['javascript-typescript-stdio'],
    \ 'typescript.tsx': ['javascript-typescript-stdio'],
    \ }

  " Automatically start language servers.
  let g:LanguageClient_autoStart = 1
  autocmd FileType javascript LanguageClientStart
  autocmd FileType javascript.jsx LanguageClientStart

  function! SetLanguageClientToFlow()
    LanguageClientStop
    echom 'language client stopped 1'
    let g:LanguageClient_serverCommands.javascript = ['flow-language-server', '--try-flow-bin', '--stdio']
    let g:LanguageClient_serverCommands.javascript.jsx = ['flow-language-server', '--try-flow-bin', '--stdio']
    LanguageClientStart

    echom 'Switched to Flow language client 2'
  endfunc

  function! SetLanguageClientToJs()
    :LanguageClientStop
    echom 'language client stopped'
    let g:LanguageClient_serverCommands.javascript = ['javascript-typescript-stdio']
    let g:LanguageClient_serverCommands.javascript.jsx = ['javascript-typescript-stdio']
    :LanguageClientStart

    echom 'Switched to js language client'
  endfunc

  nnoremap <Leader>lf :call SetLanguageClientToFlow()<cr>
  nnoremap <Leader>lj :call SetLanguageClientToJs()<cr>
" }}}

"## (Plugin) deoplete-typescript {{{
 
  " If set to 1, the type info for the symbol under the cursor 
  " will be displayed in the echo area.
  let g:nvim_typescript#type_info_on_hold = 1
  " If set to 1, the function signature will be printed to the echo area.
  " let g:nvim_typescript#signature_complete = 1

  " inoremap <silent><C-d> <Esc>:TSDoc<cr>=<C-w>p<C-W>pi
  " nnoremap <C-d> :TSDoc<cr> <c-w>p
  autocmd FileType typescript,typescript.tsx nnoremap <buffer><silent> gd :TSDefPreview<cr>=<c-w>p
  autocmd FileType typescript,typescript.tsx nnoremap <buffer><silent> <C-I> :TSImport<CR>
  autocmd FileType typescript,typescript.tsx inoremap <buffer><silent> <C-I> <Esc>:TSImport<CR>
  autocmd FileType typescript,typescript.tsx nnoremap <buffer><silent> <f2> <Esc>:TSRename<CR>

" }}}

"## (Plugin) tern-for-vim {{{

if exists('g:plugs["tern_for_vim"]')
  let g:tern_request_timeout = 1
  let g:tern_show_argument_hints = 'on_move'
  let g:tern_show_signature_in_pum = '1'
  let g:tern_map_keys = '1'
  let g:tern#is_show_argument_hints_enabled='1'

  " Use tern_for_vim.
  let g:tern#command = ["tern"]
  let g:tern#arguments = ["--persistent"]

  " Keybindings {{{
    autocmd FileType javascript,javascript.jsx nnoremap <buffer><silent> gd :TernDefPreview<cr>=<c-w>p
    autocmd FileType javascript,javascript.jsx nnoremap <buffer><silent> <f2> <Esc>:TernRename<CR>
    " This is here just for reference. Actually kept in deoplete settings section
    " autocmd FileType javascript setlocal omnifunc=tern#Complete
  " }}}
endif

" }}}
