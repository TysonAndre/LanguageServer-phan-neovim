" LanguageServer-phan-neovim
" Source: https://github.com/tysonandre/languageserver-phan-neovim
" Documentation for this project can be found by
" ':help LanguageServer-phan-neovim'


" Step 1:
" Verify that this plugin is configured correctly.
" If it isn't, then print an error message to stdout.

""
" @setting g:phan_analyzed_directory
" The root directory of a project with a .phan/config.php file.
" This is mandatory.

" Verify that the directory is configured
if ! exists('g:phan_analyzed_directory')
	echo "LanguageServer-phan-neovim is installed and enabled, but g:phan_installed_directory is not set to a valid directory. It should be set to the root directory of a project with a .phan/config.php file. E.g. Add `let g:phan_analyzed_directory = '~/path/to/project-with-phan-config/'` to ~/.config/nvim/init.vim or ~/.vimrc"
	finish
endif

" Verify that the directory exists and contains .phan/config.php
" Variables beginning with s: are variables local to this script
let s:analyzed_dir = expand(g:phan_analyzed_directory)
let s:analyzed_dir_config_file = s:analyzed_dir . "/.phan/config.php"
if !isdirectory(s:analyzed_dir)
	echo "LanguageServer-phan-neovim is installed and enabled, but g:phan_installed_directory='" . s:analyzed_dir . "' could not be found. It should be set to the root directory of a project with a .phan/config.php file. E.g. Add `let g:phan_analyzed_directory = '~/path/to/project-with-phan-config/'` to ~/.config/nvim/init.vim or ~/.vimrc"
	finish
elseif !filereadable(s:analyzed_dir_config_file)
	echo "LanguageServer-phan-neovim is installed and enabled, but could not find a phan config at '" . s:analyzed_dir_config_file. "'. " . s:analyzed_dir . "' should be the root directory of a project with a .phan/config.php file. E.g. Add `let g:phan_analyzed_directory = '~/path/to/project-with-phan-config/'` to ~/.config/nvim/init.vim or ~/.vimrc"
	finish
endif

""
" @setting g:phan_php_binary
" The binary used to run Phan. Defaults to 'php'.

if ! exists('g:phan_php_binary')
	let g:phan_php_binary = 'php'
endif

""
" @setting g:phan_executable_path
" The PHP phan binary (or Phar).
" Defaults to the version that was hopefully installed with this
" package by `composer.phar install`.

if ! exists('g:phan_executable_path')
	let s:ls = globpath(&rtp,'vendor/phan/phan/phan',1)
	let s:ls = split(s:ls,"\n")[0]
	let g:phan_executable_path = s:ls
endif

if !filereadable(s:analyzed_dir_config_file)
	echo "LanguageServer-phan-neovim is installed and enabled, but could not find a phan executable at '" . g:phan_executable_path. "'."
	finish
endif

let s:cmd = [ g:phan_php_binary, g:phan_executable_path, '--require-config-exists', '--language-server-on-stdin', '--project-root-directory', s:analyzed_dir]

""
" @setting g:phan_quick
" Enable this to speed up Phan analysis by not recursing into function calls.
" Set this to 0 to disable.
" Defaults to 1 (enabled)

if !exists('g:phan_quick') || g:phan_quick
	let g:phan_quick=1
	call add(s:cmd, '--quick')
endif

""
" @setting g:phan_analyze_only_on_save
" Enable this to run Phan analysis only on file save
" (Not while editing the file)
" This will reduce CPU used and make crashes less likely.
" Disabled by default.

if exists('g:phan_analyze_only_on_save') && g:phan_analyze_only_on_save
	call add(s:cmd, '--language-server-analyze-only-on-save')
endif

""
" @setting g:phan_allow_missing_pcntl
" Enabled by default.
" If set to 1, this extension will use a substitute for pcntl if pcntl is not installed (New and experimental).
" This must be set to 1 on Windows.
" Set this to 0 to disable.
" Defaults to 1 (enabled)

if !exists('g:phan_allow_missing_pcntl') || g:phan_allow_missing_pcntl
	let g:phan_allow_missing_pcntl=1
	call add(s:cmd, '--language-server-allow-missing-pcntl')
endif

""
" @setting g:phan_use_fallback_parser
" Enabled by default. make a best effort at analyzing the remaining valid statements of PHP files with syntax errors.
" Set this to 0 to disable.
" Default is 1 (enabled)

if !exists('g:phan_use_fallback_parser') || g:phan_use_fallback_parser
	let g:phan_use_fallback_parser=1
	call add(s:cmd, '--use-fallback-parser')
endif

""
" @setting g:phan_allow_polyfill_parser
" If set to 1 (default), this extension will run even if php-ast is not installed.
" Installing php-ast is strongly recommended for performance reasons and for consistency with full Phan analysis.
" This can be set to 0 to make Phan refuse to start without php-ast

if !exists('g:phan_allow_polyfill_parser') || g:phan_allow_polyfill_parser
	let g:phan_allow_polyfill_parser=1
	call add(s:cmd, '--allow-polyfill-parser')
endif

""
" @setting g:phan_unused_variable_detection
" Set this to 1 to enable unused variable and parameter detection (analyzes the implementations of functions, methods, and closures)"
" Defaults to 0 (disabled)

if exists('g:phan_unused_variable_detection') && g:phan_unused_variable_detection
	call add(s:cmd, '--unused-variable-detection')
endif

""
" @setting g:phan_memory_limit
" The memory limit of Phan (the php language server) in bytes.
" Format: Number[K|M|G] (e.g. '1G' or '200M').
" Omit for no memory limit (default).

if exists('g:phan_memory_limit')
	if g:phan_memory_limit =~ '[0-9]\+[KMG]\?'
		call extend(s:cmd, ['--memory-limit', g:phan_memory_limit])
	else
		echo "LanguageServer-phan-neovim was passed invalid memory limit " . g:phan_memory_limit
	endif
endif

""
" @setting g:phan_enable_go_to_definition
" Enable this to make Phan support 'Go To Definition' requests.
" Set this to 0 to disable.
" Enabled by default.

if !exists('g:phan_enable_go_to_definition') || g:phan_enable_go_to_definition
	let g:phan_enable_go_to_definition=1
	call add(s:cmd, '--language-server-enable-go-to-definition')
endif

""
" @setting g:phan_enable_hover
" Enable this to make Phan support 'Hover' requests.
" Set this to 0 to disable.
" Enabled by default.

if !exists('g:phan_enable_hover') || g:phan_enable_hover
	let g:phan_enable_hover=1
	call add(s:cmd, '--language-server-enable-hover')
endif

""
" @setting g:phan_enable_completion
" When enabled, Phan supports 'Completion' requests.
" Set this to 0 to disable.
" Enabled by default.

if !exists('g:phan_enable_completion') || g:phan_enable_completion
	let g:phan_enable_completion=1
	call add(s:cmd, '--language-server-enable-completion')
endif

""
" @setting g:phan_hide_category_of_issues
" If true, this will omit Phan's category name from diagnostic
" (a.k.a. issue) messages.
" Off by default.

if exists('g:phan_hide_category_of_issues') && g:phan_hide_category_of_issues
	call add(s:cmd, '--language-server-hide-category')
endif

""
" @setting g:phan_additional_cli_flags
" Set this to an array to add custom CLI flags when starting the Phan daemon.
" (Example: let g:phan_additional_cli_flags = ['--strict-type-checking'])
" Defaults to the empty array.

if exists('g:phan_additional_cli_flags')
	call extend(s:cmd, g:phan_additional_cli_flags)
endif

" Step 2:
" After verifying that settings are valid,
" this will register this language server.
try
	" register and start phan language server
	" TODO: Add a vim variable to configure extra options
	call LanguageClient_registerServerCommands({'php': (s:cmd)})
	" LanguageClientStart
catch
	" do nothing
endtry
