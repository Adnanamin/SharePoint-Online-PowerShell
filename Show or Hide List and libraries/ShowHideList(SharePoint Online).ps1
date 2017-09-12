[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint.Client")
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint.Client.Runtime")

#Variables for Processing

$userName="admin@mstechtalk.com"
$password =Read-Host -Prompt "Enter Password" -AsSecureString 


#Setup Credentials to connect
$credentials = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($userName,$password)

function ShowHideList($siteUrl, $listName, $showHideValue)
{
    #Set up the context
    $context = New-Object Microsoft.SharePoint.Client.ClientContext($siteUrl)
    $context.Credentials = $credentials

    #Get the List
    $list = $context.Web.Lists.GetByTitle($listName)
    $list.Hidden = $showHideValue
    $list.Update()
    $context.ExecuteQuery()
    if ($showHideValue -eq $true)
    {
        Write-Host "$listName hidden successfully!"
    }else{
        Write-Host "$listName enabled/shown successfully!"
    }
}

#function call
#site URL, List/Library name, $true/$false
ShowHideList "https://mstalk.sharepoint.com" "Opportunities" $false