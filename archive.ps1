#!/usr/bin/psh
#
# Remote EVT archivation script by Richard Bruna
#
# -Ze serveru definovanych v poli presune a archivuje EVT soubory z predchoziho dne.

# VAR

$log = 'l:\archive.log'
$server = @('MODRON','SCOTA','EPONA','DON','BRID','BRID-EXMBS1')
$yesterday= "{0:yyyy-MM-dd}" -f (get-date).adddays(-1)

# move log files

$server | % {
	try {
		$remote = $_
		move-item -ea stop \\$_\e$\LOG\Archive-Security-$yesterday*,\\$_\e$\LOG\Archive-System-$yesterday* \\DON\logs$\$_\
	}
	catch [System.Management.Automation.RuntimeException]
	{	
		echo "$(date) $remote" $_ >> $log
	}
}

# archive files

$server | % {
	cd "l:\$_"
	ls *.evtx,*.evt | % { & 'C:\Program Files\WinRAR\Rar.exe' a -inul -ep1 -df $_.BaseName $_ }
}

# end

exit