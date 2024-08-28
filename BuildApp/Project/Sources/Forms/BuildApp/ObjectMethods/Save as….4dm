If (Form event code:C388=On Clicked:K2:4)
	
	var $buildSettingsFile : 4D:C1709.File
	$buildSettingsFile:=File:C1566(Build application settings file:K5:60; *)
	If ($buildSettingsFile=Null:C1517)
		$buildSettingsFile:=Folder:C1567(Folder:C1567("/PROJECT/"; *).platformPath; fk platform path:K87:2).parent.folder("Settings").file("buildApp.4DSettings")
		$buildSettingsFile.parent.create()
	End if 
	
	$fileName:=Select document:C905($buildSettingsFile.platformPath; ".4DSettings;.xml"; "Save build project…"; File name entry:K24:17 | Package open:K24:8)
	
	If (OK=1)
		
		$buildProject:=File:C1566(DOCUMENT; fk platform path:K87:2)
		
		Form:C1466.BuildApp.toFile($buildProject)
		
	End if 
	
End if 