$folders = import-csv 'C:\users\frejuz\Documents\Scripts\Password export_import SecretServer\folders.csv' -Delimiter ';'
$secrets = import-csv 'C:\users\frejuz\Documents\Scripts\Password export_import SecretServer\secrets.csv' -Delimiter ';'


$path = & 'C:\users\frejuz\documents\scripts\Password export_import SecretServer\test1.xml'
$xmlWriter = New-Object System.XML.XmlTextWriter($path,$null)

$xmlWriter.Formatting = 'Indented'
$xmlWriter.Indentation = 3
$xmlWriter.BaseStreamIndentChar = " "

$xmlWriter.WriteStartDocument()

$xmlWriter.WriteProcessingInstruction("xml","version='1.0' encoding='UTF-16'")
$xmlWriter.WriteStartElement('ImportFile')
 $xmlWriter.WriteAttributeString("xmlns:xsi", "http://www.w3.org/2001/XMLSchema-instance")
 $xmlWriter.WriteAttributeString("xmlns.xsd", "http://www.w3.org/2001/XMLSchema")
$xmlWriter.WriteStartelement("Folders")
$folders | foreach {
	$isRootFolder = $PSItem.split('\').length -eq 1 

	$xmlWriter.WriteStartElement("Folder")
	 $xmlWriter.WriteElementString("FolderName", $PSItem.FolderName)
	 $xmlWriter.WriteElementString("FolderPath", $PSItem.FolderPath)
	 $xmlWriter.WriteStartElement("Permissions")
	if($isRootFolder){
	  $xmlWriter.WriteStartElement("Permission")
	   $xmlWriter.WriteElementString("View", "true")
	   $xmlWriter.WriteElementString("edit", "true")
	   $xmlWriter.WriteElementString("owner", "true")
	   $xmlWriter.WriteElementString("UserName", "SS_Administrator")
	  $xmlWriter.WriteEndElement()
	  $xmlWriter.WriteStartElement("Permission")
	   $xmlWriter.WriteElementString("View", "true")
	   $xmlWriter.WriteElementString("edit", "true")
	   $xmlWriter.WriteElementString("owner", "false")
	   $xmlWriter.WriteElementString("GroupName", "Everyone")
	  $xmlWriter.WriteEndElement()
	}
	 $xmlWriter.WriteEndElement()
	$xmlWriter.WriteEndElement()
}
   $xmlWriter.WriteStartElement("Groups")
   $xmlWriter.WriteEndElement()
   $xmlWriter.WriteStartElement("SecretTemplates")
   $xmlWriter.WriteEndElement()
   $xmlWriter.WriteStartElement("Secrets")
    $secrets | foreach {
		$xmlWriter.WriteElementString("SecretName", $PSItem.SecretName)
		$xmlWriter.WriteElementString("SecretTemplateName", $PSItem.SecretTemplateName)
		$xmlWriter.WriteElementString("FolderPath", $PSItem.FolderPath)
		$xmlWriter.WriteStartElement("Permissions")
		$xmlWriter.WriteEndElement()
		$xmlWriter.WriteStartElement("SecretItems")
		 $xmlWriter.WriteElementString("FieldName", "URL")
		 $xmlWriter.WriteElementString("Value", $PSItem.url)
		$xmlWriter.WriteEndElement()

	}
   $xmlWriter.WriteEndElement()
$xmlWriter.WriteEndElement()
$xmlWriter.WriteEndElement()
