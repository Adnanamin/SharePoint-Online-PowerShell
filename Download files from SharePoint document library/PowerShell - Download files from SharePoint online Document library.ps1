#####################################################################
#Author: Adnan Amin
#Blog: https://mstechtalk.com
#Twitter: @adnan_amin
#Downloading files from SharePoint online Document library to local machine
#####################################################################
#################### Parameters ###########################################
$webUrl = "https://mstalk.sharepoint.com/";
$listUrl = "Documents";
$destination = "D:\test"
###########################################################################

#Connect-PnPOnline -Url $webUrl 
Connect-PnPOnline -Url $webUrl -UseWebLogin;
$web = Get-PnPWeb
$list = Get-PNPList -Identity $listUrl

function ProcessFolder($folderUrl, $destinationFolder) {

    $folder = Get-PnPFolder -RelativeUrl $folderUrl
    $tempfiles = Get-PnPProperty -ClientObject $folder -Property Files
   
    if (!(Test-Path -path $destinationfolder)) {
        $dest = New-Item $destinationfolder -type directory 
    }

    $total = $folder.Files.Count
    For ($i = 0; $i -lt $total; $i++) {
        $file = $folder.Files[$i]
        Write-Host "Copying file " $file.Name " at " $destinationfolder
        Get-PnPFile -ServerRelativeUrl $file.ServerRelativeUrl -Path $destinationfolder -FileName $file.Name -AsFile
    }
}

function ProcessSubFolders($folders, $currentPath) {
    foreach ($folder in $folders) {
        $tempurls = Get-PnPProperty -ClientObject $folder -Property ServerRelativeUrl    
        #Avoid Forms folders
        if ($folder.Name -ne "Forms") {
            $targetFolder = $currentPath +"\"+ $folder.Name;
            ProcessFolder $folder.ServerRelativeUrl.Substring($web.ServerRelativeUrl.Length) $targetFolder 
            $tempfolders = Get-PnPProperty -ClientObject $folder -Property Folders
            write-host "Processing folder: " $folder.Name " .. at " $currentPath
            ProcessSubFolders $tempfolders $targetFolder
        }
    }
}


ProcessFolder $listUrl $destination + "\" 
#Write-Host "listUrl: " $listUrl

#Download files in folders
$tempfolders = Get-PnPProperty -ClientObject $list.RootFolder -Property Folders
Write-Host "tempfolders: " $tempfolders
ProcessSubFolders $tempfolders $destination + "\"