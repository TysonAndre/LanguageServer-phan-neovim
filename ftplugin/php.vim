if ! exists('g:phan_analyzed_directory')
	echo "LanguageServer-phan-neovim is installed, but g:phan_installed_directory is not set. It should be set to the root directory of a project with a .phan/config.php file."
else
	try
		let s:ls = globpath(&rtp,'vendor/bin/phan',1)
		let s:ls = split(s:ls,"\n")[0]
		" register and start phan language server
		" TODO: Add a vim variable to configure extra options
		call LanguageClient_registerServerCommands({'php':[ 'php', s:ls, '--require-config-exists', '--language-server-on-stdin', '--quick', '--use-fallback-parser', '--allow-polyfill-parser', '--project-root-directory', g:phan_project_directory]})
		" LanguageClientStart
	catch
		" do nothing
	endtry
endif

