" Verify that this plugin is configured correctly.
" If it isn't, then print an error message to stdout.

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

" Locate the Phan PHP binary
if ! exists('g:phan_php_binary')
	let g:phan_php_binary = 'php'
endif

if ! exists('g:phan_executable_path')
	let s:ls = globpath(&rtp,'vendor/phan/phan/phan',1)
	let s:ls = split(s:ls,"\n")[0]
	let g:phan_executable_path = s:ls
endif

try
	" register and start phan language server
	" TODO: Add a vim variable to configure extra options
	call LanguageClient_registerServerCommands({'php':[ g:phan_php_binary, g:phan_executable_path, '--require-config-exists', '--language-server-on-stdin', '--quick', '--use-fallback-parser', '--allow-polyfill-parser', '--language-server-allow-missing-pcntl', '--project-root-directory', s:analyzed_dir]})
	" LanguageClientStart
catch
	" do nothing
endtry
