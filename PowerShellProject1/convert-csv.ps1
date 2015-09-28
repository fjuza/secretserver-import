#
# convert_csv.ps1
#
$rows = Import-Csv 'C:\users\frejuz\Documents\Scripts\Password export_import SecretServer\FakeNPMdump.csv' -Delimiter ';'

$folders = 'C:\users\frejuz\Documents\Scripts\Password export_import SecretServer\folders.csv'
$secrets = 'C:\users\frejuz\Documents\Scripts\Password export_import SecretServer\secrets.csv'
$secretCollection = @()
$pathCollection = @()
$rows | foreach {
	$name = $PSItem.Name
	$login = $PSItem.Login
	$password = $PSItem.Password
	$url = $PSItem.Url
	$comment = $PSItem.Comment
	
	if($name -like "*\*"){
		#Write-Host "test"
		#$name
		$path = $name
		$path = $path.Substring(1)
		$path = $path -replace ".$"
		$pathName = $name.split("\")
		$pHash = @{
			FolderName = $pathName[-1]
			FolderPath  = $name

		}
		$pObject = New-Object psobject -Property $pHash
		$pathCollection += $pObject
	}


	if($name[0] -notlike "*\*"){
		$hash = $null
		$object = $null
		if($comment -ne $null){
			$comment = $comment.replace('#13','##BR##')
		}
		$hash = @{
			FolderPath = $path
			SecretTemplateName = ""
			Name = $name
			Login = $login
			Password = $password
			Url = $url
			Comment = $comment
		}
		$object = New-Object psobject -Property $hash
		$secretCollection += $object
		
	}

}
$secretCollection | Export-Csv -Delimiter ';' -Path $secrets -NoTypeInformation
$pathCollection | Export-Csv -Delimiter ';' -Path $folders -NoTypeInformation