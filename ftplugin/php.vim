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

" Step 2:
" After verifying that settings are valid,
" this will register this language server.
try
	" register and start phan language server
	" TODO: Add a vim variable to configure extra options
	call LanguageClient_registerServerCommands({'php':[ g:phan_php_binary, g:phan_executable_path, '--require-config-exists', '--language-server-on-stdin', '--quick', '--use-fallback-parser', '--allow-polyfill-parser', '--language-server-allow-missing-pcntl', '--language-server-enable-go-to-definition', '--project-root-directory', s:analyzed_dir]})
	" LanguageClientStart
catch
	" do nothing
endtry
