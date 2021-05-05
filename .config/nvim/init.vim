if has('vim_starting')
  set nocompatible               " Be iMproved
endif

let vimplug_exists=expand('~/.config/nvim/autoload/plug.vim')

let g:vim_bootstrap_langs = "javascript"
let g:vim_bootstrap_editor = "nvim"

if !filereadable(vimplug_exists)
  echo "Installing Vim-Plug..."
  echo ""
  silent !\curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  let g:not_finish_vimplug = "yes"

  autocmd VimEnter * PlugInstall
endif

let g:loaded_ruby_provider = 0
let g:loaded_python_provider = 0
let g:python3_host_prog = '/Users/dalssaso/.ve/neovim/bin/python'

call plug#begin('~/.config/nvim/plugged')

    Plug 'chriskempson/base16-vim'
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    let g:airline#extensions#tabline#enabled = 1 " enable airline tabline
    let g:airline#extensions#tabline#tab_min_count = 1 " only show tabline if tabs are being used (more than 1 tab open)
    let g:airline#extensions#tabline#show_buffers = 1 " do not show open buffers in tabline
    let g:airline#extensions#tabline#show_splits = 0
    let g:airline_left_sep = "\uE0B4"
    let g:airline_right_sep = "\uE0B6"


    " Hashicorp specific stuff
    Plug 'hashivim/vim-terraform', {'for': 'terraform'}
        let g:terraform_align = 1
        let g:terraform_fmt_on_save = 1
        " autocmd BufRead,BufNewFile *.hcl set filetype=terraform
    Plug 'hashivim/vim-nomadproject'
    Plug 'hashivim/vim-packer'
    Plug 'hashivim/vim-vagrant'
    Plug 'hashivim/vim-vaultproject'
    Plug 'hashivim/vim-consul'

    " Dockerfile, nginx
    Plug 'docker/docker', {'for': 'dockerfile'}
    Plug 'chr4/nginx.vim'

    " Markdown
    Plug 'kannokanno/previm', {'for': 'markdown'}
    Plug 'mzlogin/vim-markdown-toc', {'for': 'markdown'}
    Plug 'tpope/vim-markdown', {'for': 'markdown'}

    " Git
    Plug 'rhysd/committia.vim'
    let g:committia_open_only_vim_starting = 1

    Plug 'airblade/vim-gitgutter'
    Plug 'junegunn/gv.vim'
    " Plug 'tpope/vim-fugitive'
    Plug 'lambdalisue/gina.vim'
    Plug 'jreybert/vimagit'


    " Utilities
    Plug 'godlygeek/tabular'
    Plug 'Shougo/vimproc.vim'
    Plug 'tpope/vim-surround'
    Plug 'tpope/vim-endwise'
    Plug 'tpope/vim-commentary'
    Plug 'ryanoasis/vim-devicons'
    Plug 'editorconfig/editorconfig-vim'
    Plug 'cohama/lexima.vim'
    Plug 'thaerkh/vim-indentguides'
        let g:indentguides_spacechar = '┆'
        let g:indentguides_tabchar = '|'
    Plug 'preservim/nerdtree'
        nnoremap <C-n> :NERDTreeToggle<CR>
        let g:NERDTreeShowHidden = 1

        " Start NERDTree when Vim is started without file arguments.
        autocmd StdinReadPre * let s:std_in=1
        autocmd VimEnter * if argc() == 0 && !exists('s:std_in') | NERDTree | endif
    Plug 'Xuyuanp/nerdtree-git-plugin'
        let g:NERDTreeGitStatusUseNerdFonts = 1
    Plug 'tiagofumo/vim-nerdtree-syntax-highlight'


    " coc
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    let g:coc_global_extensions = [
        \ 'coc-json',
        \ 'coc-git',
        \ 'coc-yaml',
        \ 'coc-elixir',
        \ 'coc-prettier',
        \ 'coc-sh',
        \ 'coc-jedi',
        \ 'coc-spell-checker',
        \ 'coc-cspell-dicts',
        \ 'coc-prettier',
        \ 'coc-yank',
        \ 'coc-marketplace',
        \ 'coc-sql',
        \ 'coc-snippets',
        \ 'coc-markdownlint',
        \ ]

    Plug 'junegunn/fzf.vim'
    if has('macunix')
        Plug $HOMEBREW_PREFIX . '/opt/fzf'
    else
        Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    endif
    if isdirectory(".git")
        " if in a git project, use :GFiles
        nmap <silent> <leader>t :GitFiles --cached --others --exclude-standard<cr>
    else
        " otherwise, use :FZF
        nmap <silent> <leader>t :FZF<cr>
    endif

    nmap <silent> <leader>s :GFiles?<cr>

    nmap <silent> <leader>r :Buffers<cr>
    nmap <silent> <leader>e :FZF<cr>
    nnoremap <silent> <Leader>C :call fzf#run({
    \   'source':
    \     map(split(globpath(&rtp, "colors/*.vim"), "\n"),
    \         "substitute(fnamemodify(v:val, ':t'), '\\..\\{-}$', '', '')"),
    \   'sink':    'colo',
    \   'options': '+m',
    \   'left':    30
    \ })<CR>

    command! FZFMru call fzf#run({
    \  'source':  v:oldfiles,
    \  'sink':    'e',
    \  'options': '-m -x +s',
    \  'down':    '40%'})

    command! -bang -nargs=* Find call fzf#vim#grep(
        \ 'rg --column --line-number --no-heading --follow --color=always '.<q-args>.' || true', 1,
        \ <bang>0 ? fzf#vim#with_preview('up:60%') : fzf#vim#with_preview('right:50%:hidden', '?'), <bang>0)
    command! -bang -nargs=? -complete=dir Files
        \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)
    command! -bang -nargs=? -complete=dir GitFiles
        \ call fzf#vim#gitfiles(<q-args>, fzf#vim#with_preview(), <bang>0)
    function! RipgrepFzf(query, fullscreen)
        let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case -- %s || true'
        let initial_command = printf(command_fmt, shellescape(a:query))
        let reload_command = printf(command_fmt, '{q}')
        let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
        call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
    endfunction

    let $FZF_DEFAULT_OPTS= $FZF_DEFAULT_OPTS
        \ . " --layout reverse"
        \ . " --pointer ' '"
        \ . " --info hidden"
        \ . " --color 'bg+:0'"

    let g:fzf_preview_window = ['right:50%:hidden', '?']
    let g:fzf_layout = { 'window': { 'width': 0.8, 'height': 0.5, 'highlight': 'Comment' } }


call plug#end()

set encoding=utf-8
set nocompatible        " No VI allowed just VIM
set autoread            " File change detection
set history=1000        " Limit history to 1000
set textwidth=0         " Disable physical wraping
set wrapmargin=0        " Disable wrapmargin
set clipboard=unnamed
set nobackup
set nowritebackup
set updatetime=300
set shortmess+=c
filetype on
filetype plugin indent on
set wrap " this is visual only
set smartindent

let base16colorspace=256

syntax on
set number
set relativenumber
if (has("termguicolors"))
 set termguicolors
endif
let $NVIM_TUI_ENABLE_TRUE_COLOR=1
let base16colorspace=256
source ~/.config/nvim/colorscheme.vim

set list
set listchars=tab:→\ ,eol:¬,trail:⋅,extends:❯,precedes:❮
set showbreak=↪

set cursorline
set tabstop=4
set softtabstop=4
set expandtab
set shiftwidth=4
set smarttab
set completeopt+=longest
set backspace=indent,eol,start
set hidden
set showcmd
set noshowmode
set wildmode=list:longest
set scrolloff=10
set shell=$SHELL
set cmdheight=1
set laststatus=2

" Searching
set ignorecase              " case insensitive searching
set smartcase               " case-sensitive if expresson contains a capital
set hlsearch                " highlight search results
set incsearch               " set incremental search, like modern browser

set showmatch               " show matching braces
set mat=2                   " how many tenths of a second to blink

" Leader mapping
let mapleader = ','

" Set paste toggle
set pastetoggle=<leader>v

" Clear search highlight
noremap <silent><space> :set hlsearch! hlsearch?<cr>

" Scroll faster
nnoremap <C-e> 7<C-e>
nnoremap <C-y> 7<C-y>

" Natural view of navigation
set splitbelow
set splitright

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" " Make <CR> auto-select the first completion item and notify coc.nvim to
" " format on enter, <cr> could be remapped by other vim plugin
" inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
"                               \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> for scroll float windows/popups.
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>
" Show yank list
nnoremap <silent> <space>y  :<C-u>CocList -A --normal yank<cr>

" Use <C-l> for trigger snippet expand.
imap <C-l> <Plug>(coc-snippets-expand)

" Use <C-j> for select text for visual placeholder of snippet.
vmap <C-j> <Plug>(coc-snippets-select)

" Use <C-j> for jump to next placeholder, it's default of coc.nvim
let g:coc_snippet_next = '<c-j>'

" Use <C-k> for jump to previous placeholder, it's default of coc.nvim
let g:coc_snippet_prev = '<c-k>'

" Use <C-j> for both expand and jump (make expand higher priority.)
imap <C-j> <Plug>(coc-snippets-expand-jump)

" Use <leader>x for convert visual selected code to snippet
xmap <leader>x  <Plug>(coc-convert-snippet)

" coc-explorer
nnoremap <space>e :CocCommand explorer<CR>


"" no one is really happy until you have this shortcuts
cnoreabbrev W! w!
cnoreabbrev Q! q!
cnoreabbrev Qall! qall!
cnoreabbrev Wq wq
cnoreabbrev Wa wa
cnoreabbrev wQ wq
cnoreabbrev WQ wq
cnoreabbrev W w
cnoreabbrev Q q
cnoreabbrev Qall qall

" Italics
highlight Comment cterm=italic
