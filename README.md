# LanguageServer-phan-neovim

[![Minimum PHP Version](https://img.shields.io/badge/php-%3E=7.1-8892BF.svg)](https://php.net/) [![Gitter](https://badges.gitter.im/phan/phan.svg)](https://gitter.im/phan/phan?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge)

A PHP language server plugin for [LanguageClient-neovim](https://github.com/autozimu/LanguageClient-neovim).
This uses Phan's static analysis capabilities to quickly emit diagnostic issue messages.

This uses [Phan](https://github.com/phan/phan).

Also see [LanguageServer-php-neovim](https://github.com/roxma/LanguageServer-php-neovim), which provides features that this doesn't, such as auto completion, go to definition, etc.

## Features

+ Adds improved [error detection from Phan](https://github.com/phan/phan#features) to neovim.
+ Analyze code while you're typing.
+ Analyze remaining statements of code with syntax errors.

## Issue Tracker

**Note: This is just the [neovim plugin that spawns Phan](https://github.com/TysonAndre/LanguageServer-phan-neovim). Phan is implemented purely in PHP [in its own repository](https://github.com/phan/phan),
bugs in Phan analysis need to be fixed there and all issues should be reported [there](https://github.com/phan/phan/issues).**

However, bugs in this neovim plugin (crashes, etc) or related to the language server protocol should be reported [in this plugin's issue tracker](https://github.com/TysonAndre/LanguageServer-phan-neovim/issues)

## Examples

### Error Detection

![Phan error detection demo](https://raw.githubusercontent.com/TysonAndre/LanguageServer-phan-neovim/master/images/error_detection.png)

### Error Detection (Tolerating Syntax Errors)

![Phan error tolerant parsing demo](https://raw.githubusercontent.com/TysonAndre/LanguageServer-phan-neovim/master/images/tolerant_parsing.png)

## Installation

### Dependencies:

1. PHP 7.1+ must be installed.
   You can either add it to your PATH or set the `g:phan_php_binary` setting in `~/.config/nvim/init.vim`. (e.g. `let g:phan_php_binary = '/usr/local/php7.1/bin/php'`)
2. Your Operating System should be Unix/Linux. There is experimental support for Windows.
   (Phan's Language Server Protocol support depends on `pcntl` module being installed, which is only available on those platforms)
   There is a slower fallback which manually saves and restores Phan's state.

3. (Optional) For optimal performance and accuracy of analysis,
   [the `php-ast` PECL extension](https://pecl.php.net/package/ast) should be installed and enabled.

Using [vim-plug](https://github.com/junegunn/vim-plug).

See https://github.com/junegunn/vim-plug#usage if you are unfamiliar with vim-plug. After adding the plugins to your neovim config, `:PlugInstall` must be called to install the plugins.

```vim
" call plug#begin('~/.local/share/nvim/plugged') " uncomment if this does not exist

Plug 'TysonAndre/LanguageServer-phan-neovim',  {'do': 'composer install'}
" Currently, the Phan Language Server only works with a single directory and that directory must be manually configured.
let g:phan_analyzed_directory = '~/path/to/project-with-phan-config/'

" Dependency:
Plug 'autozimu/LanguageClient-neovim', { 'branch': 'next', 'do': 'bash install.sh' }

" call plug#end() " uncomment if this does not exist
```

If you install this plugin manually, then execute the following commands in this directory:

```sh
composer install
```

## Configuration

```vim
autocmd FileType php LanguageClientStart
```
