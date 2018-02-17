# LanguageServer-phan-neovim

**Supports Unix/Linux.** Does not support Windows right now (due to a dependency on PHP's `pcntl`).

[![Minimum PHP Version](https://img.shields.io/badge/php-%3E=7.1-8892BF.svg)](https://php.net/) [![Gitter](https://badges.gitter.im/phan/phan.svg)](https://gitter.im/phan/phan?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge)

A PHP language server plugin for [LanguageClient-neovim](https://github.com/autozimu/LanguageClient-neovim).
This uses Phan's static analysis capabilities to quickly emit diagnostic issue messages.

This uses [Phan](https://github.com/phan/phan).

Also see [LanguageServer-php-neovim](https://github.com/roxma/LanguageServer-php-neovim), which provides features that this doesn't, such as auto completion, go to definition, etc.

## Installation

Using [vim-plug](https://github.com/junegunn/vim-plug).

```vim
Plug 'TysonAndre/LanguageServer-phan-neovim',  {'do': 'composer install'}
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
