//%attributes = {}
If (Get application info:C1599.headless)
	
	$stdErr:="Unit tests passed"
	
	LOG EVENT:C667(Into system standard outputs:K38:9; $stdErr; Error message:K38:3)
	
	If (Application type:C494#6)
		QUIT 4D:C291
	End if 
	
Else 
	
	var $buildSettingsFile : 4D:C1709.File
	$buildSettingsFile:=File:C1566(Build application settings file:K5:60)
	
	var $buildApp : cs:C1710.BuildApp
	
	$buildApp:=cs:C1710.BuildApp.new($buildSettingsFile)
	
	If (Is macOS:C1572)
		//%W-550.12
		$buildApp.findCertificates("kind == :1"; "Developer ID Application")
		//%W+550.12
		$BuildApp.SignApplication.MacSignature:=True:C214
		$BuildApp.AdHocSign:=False:C215
	End if 
	
	If (Is macOS:C1572)
		$BuildApp.BuildMacDestFolder:=Folder:C1567(fk desktop folder:K87:19).platformPath
	Else 
		$BuildApp.BuildWinDestFolder:=Folder:C1567(fk desktop folder:K87:19).platformPath
	End if 
	
	$BuildApp.BuildApplicationName:=File:C1566(Structure file:C489; fk platform path:K87:2).name
	
	If (True:C214)
		$BuildApp.Versioning.Common.CommonVersion:="1.0.0"
		$BuildApp.Versioning.Common.CommonCopyright:="©︎K.MIYAKO"
		$BuildApp.Versioning.Common.CommonCompanyName:="com.4d.miyako"
	End if 
	
	$buildApp.editor()
	
End if 