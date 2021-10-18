set backspace=indent,eol,start
" set the runtime path to include Vundle and initialize

call plug#begin('~/.vim/plugged')
"dirtree
Plug 'scrooloose/nerdtree'
Plug 'jistr/vim-nerdtree-tabs'


" VIM enhancements
"Plug 'ciaranm/securemodelines'
"Plug 'editorconfig/editorconfig-vim'
"Plug 'justinmk/vim-sneak'

" GUI enhancements
Plug 'itchyny/lightline.vim'
Plug 'machakann/vim-highlightedyank'
Plug 'andymass/vim-matchup'


" Fuzzy finder
Plug 'airblade/vim-rooter'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

" Semantic language support
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/lsp_extensions.nvim'
Plug 'nvim-lua/completion-nvim'

" Syntactic language support
Plug 'cespare/vim-toml'
Plug 'stephpy/vim-yaml'
Plug 'rust-lang/rust.vim'
Plug 'rhysd/vim-clang-format'

"Auto-Indentation"
"Plug 'vim-scripts/indentpython.vim'

"vim theme
Plug 'morhetz/gruvbox'
call plug#end()



" LSP configuration
lua << END
local lspconfig = require('lspconfig')
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  --Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<space>a', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)

  -- Forward to other plugins
  require'completion'.on_attach(client)
end

local servers = { 'pyright', 'rust_analyzer' }
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    }
  }
end

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = true,
    signs = true,
    update_in_insert = true,
  }
)
END

if executable('ag')
	set grepprg=ag\ --nogroup\ --nocolor
endif
if executable('rg')
	set grepprg=rg\ --no-heading\ --vimgrep
	set grepformat=%f:%l:%c:%m
endif


"pep8
au BufNewFile,BufRead *.py
    \ set tabstop=4 |
    \ set softtabstop=4 |
    \ set shiftwidth=4 |
    \ set textwidth=79 |
    \ set expandtab |
    \ set autoindent |
    \ set fileformat=unix

"js/css/html
au BufNewFile,BufRead *.js, *.html, *.css
    \ set tabstop=2 |
    \ set softtabstop=2 |
    \ set shiftwidth=2

"Auto-Indentation"
highlight BadWhitespace ctermbg=red guibg=red2
au BufRead,BufNewFile *.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/
set encoding=utf-8


let g:python_highlight_all=1
syntax on

" Open hotkeys
map <C-p> :Files<CR>
nmap <leader>; :Buffers<CR>

" Quick-save
nmap <leader>w :w<CR>

" rust
let g:rustfmt_autosave = 1
let g:rustfmt_emit_files = 1
let g:rustfmt_fail_silently = 0
let g:rust_clip_command = 'xclip -selection clipboard'

" Completion
" Better completion
" menuone: popup even when there's only one match
" noinsert: Do not insert text until a selection is made
" noselect: Do not select, force user to select one from the menu
set completeopt=menuone,noinsert,noselect
" Better display for messages
set cmdheight=2
" You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=300


" Proper search
set incsearch
set ignorecase
set smartcase
set gdefault


" Move by line
nnoremap j gj
nnoremap k gk

" No arrow keys --- force yourself to use the home row
"nnoremap <up> <nop>
"nnoremap <down> <nop>
"inoremap <up> <nop>
"inoremap <down> <nop>
"inoremap <left> <nop>
"inoremap <right> <nop>

" Left and right can switch buffers
"nnoremap <left> :bp<CR>
"nnoremap <right> :bn<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Use <Tab> and <S-Tab> to navigate through popup menu
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" use <Tab> as trigger keys
imap <Tab> <Plug>(completion_smart_tab)
imap <S-Tab> <Plug>(completion_smart_s_tab)

" Enable type inlay hints
autocmd CursorHold,CursorHoldI *.rs :lua require'lsp_extensions'.inlay_hints{ only_current_line = true }

" Use <TAB> for selections ranges.
" nmap <silent> <TAB> <Plug>(coc-range-select)
" xmap <silent> <TAB> <Plug>(coc-range-select)

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Ctrl+h to stop searching
vnoremap <C-h> :nohlsearch<cr>
nnoremap <C-h> :nohlsearch<cr>

" dirtree
let g:tagbar_left = 1
let g:tagbar_vertical = 25
let NERDTreeWinPos = 'left'
map <C-n> <plug>NERDTreeTabsToggle<CR>
let NERDTreeIgnore=['\.pyc$', '\~$'] "ignore files in NERDTree



" Permanent undo
set undodir=~/.nvimdid
set undofile

"vim theme
let g:gruvbox_invert_selection=0
set bg=dark
set colorcolumn=80
set cursorline
set relativenumber " Relative line numbers
set nu
autocmd vimenter * ++nested colorscheme gruvbox
filetype plugin indent on    " required

