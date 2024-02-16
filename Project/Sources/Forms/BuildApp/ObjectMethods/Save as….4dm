If (Form event code:C388=On Clicked:K2:4)
	
	$fileName:=Select document:C905(System folder:C487(Desktop:K41:16)+"buildApp.4Dsettings"; ".4DSettings;.xml"; "Save build project…"; File name entry:K24:17 | Package open:K24:8)
	
	If (OK=1)
		
		$buildProject:=File:C1566(DOCUMENT; fk platform path:K87:2)
		
		Form:C1466.BuildApp.toFile($buildProject)
		
	End if 
	
End if 