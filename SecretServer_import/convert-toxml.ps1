<#
.SYNOPSIS
Generates an XML file for import in SecretServer.
.Description
Generates an XML file for import in SecretServer.
.Parameter -Target
Where to save the xml-file
.Parameter -PathFolder
Target path for folder csv.
.Parameter -PathSecret
Target path for secrets csv.
.EXAMPLE
.\convert-toxml.ps1 -Target c:\temp\export.csv -PathFolder c:\temp\folders.csv -PathSecret c:\secure\secrets.csv
#>
param(
	[parameter(Mandatory=$False)][string]$Target = 'C:\Users\frejuz\Documents\Scripts\Password export_import SecretServer\secretserver.xml',
	[parameter(Mandatory=$False)][string]$PathFolder = 'C:\Users\frejuz\Documents\Scripts\Password export_import SecretServer\folders.csv',
	[parameter(Mandatory=$False)][string]$PathSecret = 'C:\Users\frejuz\Documents\Scripts\Password export_import SecretServer\secrets.csv'
)

$folders = import-csv $PathFolder -Delimiter ';'
$secrets = import-csv $PathSecret -Delimiter ';'

$xmlWriter = New-Object System.XML.XmlTextWriter($Target,$null)

$xmlWriter.Formatting = 'Indented'
$xmlWriter.Indentation = 3
$xmlWriter.IndentChar = " "
$xmlWriter.WriteStartDocument()
$xmlWriter.WriteStartElement('ImportFile')
 $xmlWriter.WriteAttributeString("xmlns:xsi", "http://www.w3.org/2001/XMLSchema-instance")
 $xmlWriter.WriteAttributeString("xmlns.xsd", "http://www.w3.org/2001/XMLSchema")
$xmlWriter.WriteStartelement("Folders")
$folders | foreach {
	$isRootFolder = $PSItem.ToString().split('\').length -eq 1 

	$xmlWriter.WriteStartElement("Folder")
	$xmlWriter.WriteElementString("FolderName", $PSItem.FolderName)
	$xmlWriter.WriteElementString("FolderPath", $PSItem.FolderPath)
	$xmlWriter.WriteStartElement("Permissions")
	if($isRootFolder){
		$xmlWriter.WriteStartElement("Permission")
		$xmlWriter.WriteElementString("View", "true")
		$xmlWriter.WriteElementString("Edit", "true")
		$xmlWriter.WriteElementString("Owner", "true")
		$xmlWriter.WriteElementString("UserName", "SS_Administrator")
		$xmlWriter.WriteEndElement()
		$xmlWriter.WriteStartElement("Permission")
		$xmlWriter.WriteElementString("View", "true")
		$xmlWriter.WriteElementString("Edit", "true")
		$xmlWriter.WriteElementString("Owner", "true")
		$xmlWriter.WriteElementString("GroupName", "SysPartner.local\FS_Ekonomi")
		$xmlWriter.WriteEndElement()
		$xmlWriter.WriteStartElement("Permission")
		$xmlWriter.WriteElementString("View", "true")
		$xmlWriter.WriteElementString("Edit", "true")
		$xmlWriter.WriteElementString("Owner", "false")
		$xmlWriter.WriteElementString("GroupName", "Everyone")
		$xmlWriter.WriteEndElement()
	}
	$xmlWriter.WriteEndElement()
	$xmlWriter.WriteEndElement()
}
$xmlWriter.WriteEndElement()
   $xmlWriter.WriteStartElement("Groups")
   $xmlWriter.WriteEndElement()
   $xmlWriter.WriteStartElement("SecretTemplates")
   $xmlWriter.WriteEndElement()
   $xmlWriter.WriteStartElement("Secrets")
    $secrets | foreach {
		$Machine = $PSItem.SecretName
		$Server = ($PSItem.FolderPath).split('\')
		$Username = $PSItem.login
		$Password = $PSItem.password
		$Notes = $PSItem.comment
		$url = $PSItem.url

		$xmlWriter.WriteStartElement("Secret")
		$xmlWriter.WriteElementString("SecretName", $PSItem.Name)
		$xmlWriter.WriteElementString("SecretTemplateName", $PSItem.SecretTemplateName)
		$xmlWriter.WriteElementString("FolderPath", $PSItem.FolderPath)
		$xmlWriter.WriteStartElement("Permissions")
		$xmlWriter.WriteEndElement()
		$xmlWriter.WriteStartElement("SecretItems")
		switch($PSItem.SecretTemplateName){
			"Windows Account" {
								$xmlWriter.WriteStartElement("SecretItem")
								$xmlWriter.WriteElementString("FieldName", "Machine")
								$xmlWriter.WriteElementString("Value", $Server[-1])
								$xmlWriter.WriteEndElement()
								$xmlWriter.WriteStartElement("SecretItem")
								$xmlWriter.WriteElementString("FieldName", "Username")
								$xmlWriter.WriteElementString("Value", $Username)
								$xmlWriter.WriteEndElement()
								$xmlWriter.WriteStartElement("SecretItem")
								$xmlWriter.WriteElementString("FieldName", "Password")
								$xmlWriter.WriteElementString("Value", $Password)
								$xmlWriter.WriteEndElement()
								$xmlWriter.WriteStartElement("SecretItem")
								$xmlWriter.WriteElementString("FieldName", "Notes")
								$xmlWriter.WriteElementString("Value", $Notes)
								$xmlWriter.WriteEndElement()
			}
			"Web Password" {
								$xmlWriter.WriteStartElement("SecretItem")
								$xmlWriter.WriteElementString("FieldName", "URL")
								if($url -like ''){
									$xmlWriter.WriteElementString("Value", $Server[-1])
								} else {
									$xmlWriter.WriteElementString("Value", $Url)
								}
								$xmlWriter.WriteEndElement()
								$xmlWriter.WriteStartElement("SecretItem")
								$xmlWriter.WriteElementString("FieldName", "UserName")
								$xmlWriter.WriteElementString("Value", $Username)
								$xmlWriter.WriteEndElement()
								$xmlWriter.WriteStartElement("SecretItem")
								$xmlWriter.WriteElementString("FieldName", "Password")
								$xmlWriter.WriteElementString("Value", $Password)
								$xmlWriter.WriteEndElement()
								$xmlWriter.WriteStartElement("SecretItem")
								$xmlWriter.WriteElementString("FieldName", "Notes")
								$xmlWriter.WriteElementString("Value", $Notes)
								$xmlWriter.WriteEndElement()
			}
			"HP iLO Account (SSH)" {
								$xmlWriter.WriteStartElement("SecretItem")
								$xmlWriter.WriteElementString("FieldName", "IP Address / Host Name")
								$xmlWriter.WriteElementString("Value", $url)
								$xmlWriter.WriteEndElement()
								$xmlWriter.WriteStartElement("SecretItem")
								$xmlWriter.WriteElementString("FieldName", "Username")
								$xmlWriter.WriteElementString("Value", $Username)
								$xmlWriter.WriteEndElement()
								$xmlWriter.WriteStartElement("SecretItem")
								$xmlWriter.WriteElementString("FieldName", "Password")
								$xmlWriter.WriteElementString("Value", $Password)
								$xmlWriter.WriteEndElement()
								$xmlWriter.WriteStartElement("SecretItem")
								$xmlWriter.WriteElementString("FieldName", "Notes")
								$xmlWriter.WriteElementString("Value", $Notes)
								$xmlWriter.WriteEndElement()
			}
			"MySql Account" {
								$xmlWriter.WriteStartElement("SecretItem")
								$xmlWriter.WriteElementString("FieldName", "Server")
								$xmlWriter.WriteElementString("Value", $Server[-1])
								$xmlWriter.WriteEndElement()
								$xmlWriter.WriteStartElement("SecretItem")
								$xmlWriter.WriteElementString("FieldName", "Username")
								$xmlWriter.WriteElementString("Value", $Username)
								$xmlWriter.WriteEndElement()
								$xmlWriter.WriteStartElement("SecretItem")
								$xmlWriter.WriteElementString("FieldName", "Password")
								$xmlWriter.WriteElementString("Value", $Password)
								$xmlWriter.WriteEndElement()
								$xmlWriter.WriteStartElement("SecretItem")
								$xmlWriter.WriteElementString("FieldName", "Notes")
								$xmlWriter.WriteElementString("Value", $Notes)
								$xmlWriter.WriteEndElement()
			}
			"Unix Root Account (SSH)" {
								$xmlWriter.WriteStartElement("SecretItem")
								$xmlWriter.WriteElementString("FieldName", "Machine")
								$xmlWriter.WriteElementString("Value", $Server[-1])
								$xmlWriter.WriteEndElement()
								$xmlWriter.WriteStartElement("SecretItem")
								$xmlWriter.WriteElementString("FieldName", "Username")
								$xmlWriter.WriteElementString("Value", $Username)
								$xmlWriter.WriteEndElement()
								$xmlWriter.WriteStartElement("SecretItem")
								$xmlWriter.WriteElementString("FieldName", "Password")
								$xmlWriter.WriteElementString("Value",$Password)
								$xmlWriter.WriteEndElement()
								$xmlWriter.WriteStartElement("SecretItem")
								$xmlWriter.WriteElementString("FieldName", "Notes")
								$xmlWriter.WriteElementString("Value", $Notes)
								$xmlWriter.WriteEndElement()
			}
			"SQL Server Account" {
								$xmlWriter.WriteStartElement("SecretItem")
								$xmlWriter.WriteElementString("FieldName", "Server")
								$xmlWriter.WriteElementString("Value", $Server[-1])
								$xmlWriter.WriteEndElement()
								$xmlWriter.WriteStartElement("SecretItem")
								$xmlWriter.WriteElementString("FieldName", "Username")
								$xmlWriter.WriteElementString("Value", $Username)
								$xmlWriter.WriteEndElement()
								$xmlWriter.WriteStartElement("SecretItem")
								$xmlWriter.WriteElementString("FieldName", "Password")
								$xmlWriter.WriteElementString("Value", $Password)
								$xmlWriter.WriteEndElement()
								$xmlWriter.WriteStartElement("SecretItem")
								$xmlWriter.WriteElementString("FieldName", "Notes")
								$xmlWriter.WriteElementString("Value", $Notes)
								$xmlWriter.WriteEndElement()
			}
			"AD Service Account" {
								$xmlWriter.WriteStartElement("SecretItem")
								$xmlWriter.WriteElementString("FieldName", "Domain")
								$xmlWriter.WriteElementString("Value", "SP")
								$xmlWriter.WriteEndElement()
								$xmlWriter.WriteStartElement("SecretItem")
								$xmlWriter.WriteElementString("FieldName", "Username")
								$xmlWriter.WriteElementString("Value", $Username)
								$xmlWriter.WriteEndElement()
								$xmlWriter.WriteStartElement("SecretItem")
								$xmlWriter.WriteElementString("FieldName", "Password")
								$xmlWriter.WriteElementString("Value", $Password)
								$xmlWriter.WriteEndElement()
								$xmlWriter.WriteStartElement("SecretItem")
								$xmlWriter.WriteElementString("FieldName", "Notes")
								$xmlWriter.WriteElementString("Value", $Notes)
								$xmlWriter.WriteEndElement()
			}
		}
		$xmlWriter.WriteEndElement()
		$xmlWriter.WriteEndElement()

	}
   $xmlWriter.WriteEndElement()
$xmlWriter.WriteEndElement()
$xmlWriter.WriteEndElement()

$xmlWriter.WriteEndDocument()
$xmlWriter.Flush()
$xmlWriter.Close()

notepad $path