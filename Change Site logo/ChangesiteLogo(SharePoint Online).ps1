[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint.Client")
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint.Client.Runtime")

$siteUrl = Read-Host -Prompt "Enter site collection URL (https://mstechalk.sharepoint.com)" #you can also set the site URL
$userToLogin = Read-Host -Prompt "Enter Username" #you can also set the user name, make sure it should be global admin
$password = Read-Host -Prompt "Enter Password" -AsSecureString 
$sitelogoURL = "/SiteAssets/newSitelogo.jpg" #change the site logo
$clientContext = New-Object Microsoft.SharePoint.Client.ClientContext($siteUrl)
$credentials = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($userToLogin, $password) 
 
$clientContext.Credentials = $credentials
 
$web = $clientContext.get_web()
$webs = $clientContext.Web.Webs;
$clientContext.Load($webs)
$clientContext.Load($web)
 
$clientContext.ExecuteQuery()
 
function updateSubSites($subWeb) {
    $subsites = $subWeb.Webs;
    $clientContext.Load($subsites)
    $clientContext.ExecuteQuery()
    foreach ($subSite in $subsites) {
        updateSiteLogo($subWeb)
        updateSubSites($subSite)
    }
} 
 
function updateSiteLogo($subWeb) {
 $subWeb.SiteLogoUrl = $sitelogoURL
 $subWeb.Update();
 $clientContext.ExecuteQuery()
 
 Write-Host "Updated logo for " $subWeb.Title " , site url:" $subWeb.Url
}
 
updateSiteLogo($web)
 
foreach ($subWeb in $webs)
{
    write-host "inside bottom foreach"
    updateSiteLogo($subWeb)
    updateSubSites($subWeb)
}