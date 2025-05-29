![version](https://img.shields.io/badge/version-20%20R9%2B-E23089)
![platform](https://img.shields.io/static/v1?label=platform&message=mac-intel%20|%20mac-arm%20|%20win-64&color=blue)
[![license](https://img.shields.io/github/license/miyako/4d-class-buildapp)](LICENSE)

## dependencies.json

 ```json
{
	"dependencies": {
		"buildapp": {
			"github": "miyako/buildapp",
			"version": "latest"
		}
	}
}
```

Classes to edit [buildApp.4DSettings](https://doc.4d.com/4Dv20/4D/20/4D-XML-Keys-BuildApplication.100-6335734.en.html).

* Alternative to [Build4D](https://github.com/4d-depot/Build4D)
* Compatible with [BUILD APPLICATION](https://doc.4d.com/4Dv20/4D/20.2/BUILD-APPLICATION.301-6720787.en.html)
* Automatically downloads latest [4d-class-compiler](https://github.com/miyako/4d-class-compiler) from GitHub
* Supports all XML keys up to v20
* Converts XML to JSON and vice versa
* GUI editor
* `tool4d` launcher

<img src="https://github.com/user-attachments/assets/7f5e84de-71f5-488b-b5bf-e4b0101fa77b" width=500 height=auto />

<img src="https://github.com/user-attachments/assets/ccb5b914-db6e-481a-85d5-67d59c814897" width=450 height=auto />


## Usage

```4d
var $buildSettingsFile : 4D.File
$buildSettingsFile:=File(Build application settings file)

var $buildApp : cs.BuildApp.BuildApp
$buildApp:=cs.BuildApp.BuildApp.new($buildSettingsFile)

$buildApp:=cs.BuildApp.BuildApp.new($buildSettingsFile)

If (Is macOS)
	//to find licenses in keychain
	$buildApp.findCertificates("name == :1 and kind == :2"; "@miyako@"; "Developer ID Application")
	$BuildApp.SignApplication.MacSignature:=True
	$BuildApp.AdHocSign:=False
End if 

If (Is macOS)
	$BuildApp.BuildMacDestFolder:=Folder(fk desktop folder).platformPath
Else 
	$BuildApp.BuildWinDestFolder:=Folder(fk desktop folder).platformPath
End if 

$BuildApp.BuildApplicationName:=File(Structure file; fk platform path).name

//customise key
$BuildApp.Versioning.Common.CommonVersion:="1.0.0"
$BuildApp.Versioning.Common.CommonCopyright:="©︎K.MIYAKO"
$BuildApp.Versioning.Common.CommonCompanyName:="com.4d.miyako"

$buildApp.editor()
```
