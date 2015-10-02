<#
.SYNOPSIS
Converts network password manager export to readable CSV files. Outputs two files, folders.csv and secrets.csv.
.Description
Converts network password manager export to two readable CSV files, for management and later export to XML

.Parameter -Path
Location of Network Password Manager output file.
.Parameter -PathFolder
Destination path for folder csv.
.Parameter -PathSecret
Destination path for secrets csv.
.EXAMPLE
.\convert-csv.ps1 -Path c:\temp\export.csv -PathFolder c:\temp\folders.csv -PathSecret c:\secure\secrets.csv
#>
param(
	[parameter(Mandatory=$False)][string]$Path = 'C:\Users\frejuz\Documents\Scripts\Password export_import SecretServer\FakeNPMdump.csv',
	[parameter(Mandatory=$False)][string]$PathFolder = 'C:\Users\frejuz\Documents\Scripts\Password export_import SecretServer\folders.csv',
	[parameter(Mandatory=$False)][string]$PathSecret = 'C:\Users\frejuz\Documents\Scripts\Password export_import SecretServer\secrets.csv'
)
$rows = Import-Csv $Path -Delimiter ';'

$folders = $PathFolder
$secrets = $PathSecret
$secretCollection = @()
$pathCollection = @()
Measure-Command{
$rows | foreach {
	$name = $PSItem.Name
	$login = $PSItem.Login
	$password = $PSItem.Password
	$url = $PSItem.Url
	$comment = $PSItem.Comment
	if($name -like "*\*"){
		$path = $name
		$path = $path.Substring(1)
		$path = $path -replace ".$"
		$pathName = $path.split("\")
		$pHash = @{
			FolderName = $pathName[-1]
			FolderPath  = $path
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
			Type = ""
			FolderPath = $path
			SecretTemplateName = ""
			Machine = ""
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
}