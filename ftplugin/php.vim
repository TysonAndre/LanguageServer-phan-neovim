try
	let s:ls = globpath(&rtp,'vendor/phan/phan/phan',1)
	let s:ls = split(s:ls,"\n")[0]

	" register and start phan language server
	" TODO: Add a vim variable to configure extra options
	call LanguageClient_registerServerCommands({'php':[ 'php', s:ls, '--language-server-on-stdin', '--quick']})
	" LanguageClientStart
catch
	" do nothing
endtry
