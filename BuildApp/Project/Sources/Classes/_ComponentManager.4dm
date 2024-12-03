property environment4d : 4D:C1709.File
property dependencies : 4D:C1709.File
property github : 4D:C1709.Folder
property temp : 4D:C1709.Folder
property components : Collection
property WITH_GITHUB : Boolean

Class constructor
	
	This:C1470.environment4d:=This:C1470._findEnvironment4dJson()
	This:C1470.dependencies:=This:C1470._findDependenciesJson()
	This:C1470.github:=This:C1470._findGitHubFolder()
	This:C1470.temp:=Folder:C1567(Temporary folder:C486; fk platform path:K87:2).folder(Generate UUID:C1066)
	This:C1470.components:=[]
	This:C1470._parseJson(This:C1470.dependencies)
	This:C1470._parseJson(This:C1470.environment4d)
	
Function get WITH_GITHUB : Boolean
	
	return True:C214  //False
	
Function _path($root : Object; $path : Text)
	
	var $node : Object
	$node:=This:C1470._expand($root)
	
	If ($path="file://@")
		$path:=Substring:C12($path; 8)
	End if 
	
	Case of 
		: ($path="/@")  //absolute path
			$node:=Folder:C1567("/")
		: (OB Instance of:C1731($node; 4D:C1709.File))
			$node:=$node.parent
	End case 
	
	var $pathComponents : Collection
	$pathComponents:=Split string:C1554($path; "/"; sk ignore empty strings:K86:1)
	var $pathComponent : Text
	For each ($pathComponent; $pathComponents)
		Case of 
			: ($pathComponent="..")
				$node:=$node.parent
			: ($pathComponent=".")
				continue
			Else 
				$node:=$node.folder($pathComponent)
		End case 
	End for each 
	
	If ($node#Null:C1517)
		If ($node.exists)
			return $node
		Else 
			$parent:=$node.parent
			If ($parent#Null:C1517)
				$node:=$parent.file($node.fullName)
				If ($node.exists)
					return $node
				End if 
			End if 
		End if 
	End if 
	
Function _findGitHubFolder() : 4D:C1709.Folder
	
	var $githubFolder : 4D:C1709.Folder
	
	Case of 
		: (Is macOS:C1572)
			$githubFolder:=Folder:C1567(fk home folder:K87:24).folder("Library/Caches/4D/Dependencies/.github")
		: (Is Windows:C1573)
			$githubFolder:=Folder:C1567(fk home folder:K87:24).folder("AppData/Local/4D/Dependencies/.github")
		Else 
			return 
	End case 
	
	If ($githubFolder.exists)
		return $githubFolder
	End if 
	
Function _parseJson($file : 4D:C1709.File)
	
	If (OB Instance of:C1731($file; 4D:C1709.File)) && ($file.exists)
		
		var $json : Object
		$json:=JSON Parse:C1218($file.getText(); Is object:K8:27)
		
		If ($json#Null:C1517)
			var $dependencies : Object
			$dependencies:=$json.dependencies
			If ($dependencies#Null:C1517)
				var $componentName : Text
				var $component : Variant
				For each ($componentName; $dependencies)
					$component:=$dependencies[$componentName]
					Case of 
						: (Value type:C1509($component)=Is text:K8:3)
							
							var $item : Object
							$item:=This:C1470._path($file; $component)
							If ($item#Null:C1517)
								This:C1470.components.push($item)
							End if 
							
						: (Value type:C1509($component)=Is object:K8:27) && (This:C1470.WITH_GITHUB)
							
							This:C1470.temp.create()
							
							var $token; $version; $URL : Text
							$token:=This:C1470.github.token#Null:C1517 ? This:C1470.github.token : ""
							$version:=This:C1470.github.version#Null:C1517 ? This:C1470.github.version : ""
							
							Case of 
								: ($version="") || ($version="*")
									$URL:="https://github.com/"+$component.github+"/releases/latest/download/"+$componentName+".zip"
									$options:={}
									$options.headers:={Accept: "application/vnd.github+json"}
									If ($token#"")
										$options.headers.Authorization:="Bearer "+$token
									End if 
									$options.method:="GET"
									var $hr : 4D:C1709.HTTPRequest
									$hr:=4D:C1709.HTTPRequest.new($URL; $options)
									$hr.wait()
									If ($hr.response.status=200)
										var $componentsFolder : 4D:C1709.Folder
										$componentsFolder:=This:C1470.github.parent.folder("Components")
										$componentsFolder.create()
										var $componentsFile : 4D:C1709.File
										$componentsFile:=$componentsFolder.file($componentName+".zip")
										$componentsFile.setContent($hr.response.body)
										var $zip : 4D:C1709.ZipArchive
										$zip:=ZIP Read archive:C1637($componentsFile)
										$item:=$zip.root.copyTo(This:C1470.temp)
										$componentFolders:=$item.folders(fk ignore invisible:K87:22).query("extension in :1"; [".4dbase"])
										$componentFiles:=$item.files(fk ignore invisible:K87:22).query("extension in :1"; [".4DC"; ".4DZ"])
										$items:=$componentFolders.combine($componentFiles)
										If ($items.length#0)
											This:C1470.components.push($items[0])
										End if 
									End if 
							End case 
					End case 
				End for each 
			End if 
		End if 
	End if 
	
Function _expand($item : Object) : Object
	
	If (OB Instance of:C1731($item; 4D:C1709.File)) || (OB Instance of:C1731($item; 4D:C1709.Folder))
		return OB Class:C1730($item).new($item.platformPath; fk platform path:K87:2)
	End if 
	
Function _findDependenciesJson() : 4D:C1709.File
	
	var $sourcesFolder : 4D:C1709.Folder
	$sourcesFolder:=This:C1470._expand(Folder:C1567("/SOURCES/"; *))
	var $file : 4D:C1709.File
	$file:=$sourcesFolder.file("dependencies.json")
	If ($file.exists)
		return $file
	End if 
	
Function _findEnvironment4dJson() : 4D:C1709.File
	
	var $packageFolder : 4D:C1709.Folder
	$packageFolder:=This:C1470._expand(Folder:C1567("/PACKAGE/"; *))
	var $folder : 4D:C1709.Folder
	$folder:=$packageFolder
	var $file : 4D:C1709.File
	Repeat 
		If ($folder=Null:C1517)
			break
		End if 
		$file:=$folder.file("environment4d.json")
		If ($file.exists)
			return $file
		End if 
		$folder:=$folder.parent
	Until ($folder=Null:C1517)