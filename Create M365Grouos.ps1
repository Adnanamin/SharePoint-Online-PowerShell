#Install-Module -Name SharePointPnPPowerShellOnline -AllowClobber -force
Connect-PnPOnline -Url "https://mstechtalkdemodev-admin.sharepoint.com/" -UseWebLogin 
#Disconnect-PnPOnline


Connect-PnPOnline –Graph 

$path = "D:\CEShop\groupstest.csv"


function StartGroupCreation()
{
$AllGroups = Import-Csv -Path $path 

 foreach ($group in $AllGroups) {

    $Groupname = ''
    $Owners = ''
    $Members = ''
    $Groupalias = ''
    $Description = ''
    $Groupprivacy = ''

 
    $Groupname = $group.Name
    $Owners =  $group.Owners
    $Members = $group.Members
    $Groupalias = $group.Email
    $Groupprivacy = "Private"

    try
    {    
        CreateMicrosoft365Group -Groupname $Groupname -Groupalias $Groupalias -Owners $Owners -Members $Members -Groupprivacy $Groupprivacy
    }
    catch
    { write-host -f Red "`tError:" $_.Exception.Message }
  }

}


function CreateMicrosoft365Group($Groupname, $Groupalias, $Owners, $Members,  $Groupprivacy)
{   
    $Groupalias = $Groupalias
    $arrOwners = $Owners.split(',')
    $arrMembers = $Members.split(',')
    
    #Write-Host 'Owners ' $arrOwners.Count 
    #Write-Host 'Owners: ' $arrOwners
    #Write-Host 'Members ' $arrMembers.Count
    #Write-Host 'Members: ' $arrMembers

    $NewGroup = ''
    Write-Host 'Started creation ofM365 Group: ' + $Groupname
    if ($Groupprivacy -eq 'Private')
    {
        $NewGroup = New-PnPMicrosoft365Group -DisplayName $Groupname -MailNickname $Groupalias -Description $Groupname -Owners $arrOwners -Members $arrMembers -IsPrivate
    }
    else
    {
        $NewGroup = New-PnPMicrosoft365Group -DisplayName $Groupname -MailNickname $Groupalias -Description $Groupname -Owners $arrOwners -Members $arrMembers 
    }
     Write-Host Write-Host 'Created creation ofM365 Group: ' + $Groupname -ForegroundColor Green

     Write-Host 'Update Group permissions'
     
    Add-PnPMicrosoft365GroupOwner -Identity $Groupalias -Users $arrOwners 
    Add-PnPMicrosoft365GroupMember -Identity $Groupalias -Users $arrMembers
    Write-Host 'Updated Group permissions' -ForegroundColor Green

}

$memb = 'Amber.Wilson@mstechtalkdemodev.onmicrosoft.com,Ben.Jones@mstechtalkdemodev.onmicrosoft.com,adnan@mstechtalkdemodev.onmicrosoft.com'

$membar = $memb.Split(',') -join(',')

Add-PnPMicrosoft365GroupMember -Identity 'admin2' -Users $memb.split(',')

Add-PnPMicrosoft365GroupOwner -Identity 'adminFinal2' -Users Amber.Wilson@mstechtalkdemodev.onmicrosoft.com 
Add-PnPMicrosoft365GroupMember -Identity 'admin' -Users Amber.Wilson@mstechtalkdemodev.onmicrosoft.com,Ben.Jones@mstechtalkdemodev.onmicrosoft.com,adnan@mstechtalkdemodev.onmicrosoft.com

Add-PnPMicrosoft365GroupOwner -Identity "admin5" -Users "AdeleV@mstechtalkdemodev.onmicrosoft.com","AlexW@mstechtalkdemodev.onmicrosoft.com"

Add-PnPMicrosoft365GroupMember -Identity 'admin5' -Users AdeleV@mstechtalkdemodev.onmicrosoft.com,AlexW@mstechtalkdemodev.onmicrosoft.com

New-PnPMicrosoft365Group  -DisplayName 'Admin test' -Description 'admins ' -MailNickname 'admintest' -Owners AdeleV@mstechtalkdemodev.onmicrosoft.com,AlexW@mstechtalkdemodev.onmicrosoft.com -Members AdeleV@mstechtalkdemodev.onmicrosoft.com,AlexW@mstechtalkdemodev.onmicrosoft.com


StartGroupCreation