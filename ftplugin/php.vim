if ! exists('g:phan_analyzed_directory')
	echo "LanguageServer-phan-neovim is installed and enabled, but g:phan_installed_directory is not set to a valid directory. It should be set to the root directory of a project with a .phan/config.php file. E.g. Add `let g:phan_analyzed_directory = '~/path/to/project-with-phan-config/'` to ~/.config/nvim/init.vim"
else
	try
		if ! exists('g:phan_php_binary')
			let g:phan_php_binary = 'php'
		endif

		let s:ls = globpath(&rtp,'vendor/phan/phan/phan',1)
		let s:ls = split(s:ls,"\n")[0]
		" register and start phan language server
		" TODO: Add a vim variable to configure extra options
		call LanguageClient_registerServerCommands({'php':[ g:phan_php_binary, s:ls, '--require-config-exists', '--language-server-on-stdin', '--quick', '--use-fallback-parser', '--allow-polyfill-parser', '--language-server-allow-missing-pcntl', '--project-root-directory', g:phan_analyzed_directory]})
		" LanguageClientStart
	catch
		" do nothing
	endtry
endif

