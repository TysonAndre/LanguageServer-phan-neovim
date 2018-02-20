if ! exists('g:phan_analyzed_directory')
	echo "LanguageServer-phan-neovim is installed and enabled, but g:phan_installed_directory is not set to a valid directory. It should be set to the root directory of a project with a .phan/config.php file. E.g. Add `let g:phan_analyzed_directory = '~/path/to/project-with-phan-config/'` to ~/.config/nvim/init.vim or ~/.vimrc"
else
	" variable local to this script
	let s:analyzed_dir = expand(g:phan_analyzed_directory)
	let s:analyzed_dir_config_file = s:analyzed_dir . "/.phan/config.php"
	if !isdirectory(s:analyzed_dir)
		echo "LanguageServer-phan-neovim is installed and enabled, but g:phan_installed_directory='" . s:analyzed_dir . "' could not be found. It should be set to the root directory of a project with a .phan/config.php file. E.g. Add `let g:phan_analyzed_directory = '~/path/to/project-with-phan-config/'` to ~/.config/nvim/init.vim or ~/.vimrc"
	elseif !filereadable(s:analyzed_dir_config_file)
		echo "LanguageServer-phan-neovim is installed and enabled, but could not find a phan config at '" . s:analyzed_dir_config_file. "'. " . s:analyzed_dir . "' should be the root directory of a project with a .phan/config.php file. E.g. Add `let g:phan_analyzed_directory = '~/path/to/project-with-phan-config/'` to ~/.config/nvim/init.vim or ~/.vimrc"
	else
		try
			if ! exists('g:phan_php_binary')
				let g:phan_php_binary = 'php'
			endif

			let s:ls = globpath(&rtp,'vendor/phan/phan/phan',1)
			let s:ls = split(s:ls,"\n")[0]
			" register and start phan language server
			" TODO: Add a vim variable to configure extra options
			call LanguageClient_registerServerCommands({'php':[ g:phan_php_binary, s:ls, '--require-config-exists', '--language-server-on-stdin', '--quick', '--use-fallback-parser', '--allow-polyfill-parser', '--language-server-allow-missing-pcntl', '--project-root-directory', s:analyzed_dir]})
			" LanguageClientStart
		catch
			" do nothing
		endtry
	endif
endif
