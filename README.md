# LanguageServer-phan-neovim

A PHP language server plugin for [LanguageClient-neovim](https://github.com/autozimu/LanguageClient-neovim).
This uses Phan's static analysis capabilities to quickly emit diagnostic issue messages.

This uses [Phan](https://github.com/phan/phan).

**NOTE: This won't work until https://github.com/phan/phan/pull/1144 is merged.**

Also see https://github.com/autozimu/LanguageClient-neovim, which provides features this doesn't, such as auto completion, go to definition, etc.

## Installation

Using [vim-plug](https://github.com/junegunn/vim-plug).

```vim
Plug 'roxma/LanguageServer-phan-neovim',  {'do': 'composer install'}
" Dependency:
Plug 'autozimu/LanguageClient-neovim', { 'do': ':UpdateRemotePlugins' }
```

If you install this plugin manually, then execute the following commands in this directory:

```sh
composer install
```

## Configuration

```vim
autocmd FileType php LanguageClientStart
```
