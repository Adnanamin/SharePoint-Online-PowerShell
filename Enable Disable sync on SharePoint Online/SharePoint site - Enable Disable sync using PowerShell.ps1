#####################################################################
#Author: Adnan Amin
#Blog: https://mstechtalk.com
#Twitter: @adnan_amin
#Enable / disable sync option for a SharePoint Site (site collection and sub sites) 
#####################################################################


Add-Type -Path "C:\Program Files\Common Files\microsoft shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.dll"
Add-Type -Path "C:\Program Files\Common Files\microsoft shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.Runtime.dll"

#Fuction to enable or disable sync in a document library
function EnableDisableSiteSync ($siteURL, $action)
{ 
     try 
    {  
        $cred= Get-Credential

        $ctx = New-Object Microsoft.SharePoint.Client.ClientContext($siteURL) 
        $credentials = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($cred.Username, $cred.Password)
        $ctx.Credentials = $credentials 
   
        $web= $ctx.Web
        $ctx.Load($web)
        #$ctx.Load($web.Webs) ##uncomment this if you need to run for all subsites under this site
        $ctx.ExecuteQuery()
        
       
        $web.ExcludeFromOfflineClient=$action
        $web.Update()
        $ctx.ExecuteQuery()
        
        #if you want run the script for all subsites under this site then follow run below cmdlets

        #foreach ($subsite in $web.Webs)
        #{
        #    $ctx.load($subsite)
        #    $ctx.ExecuteQuery()
        #    $subsite.ExcludeFromOfflineClient=$action
        #    $subsite.Update()
        #    $ctx.ExecuteQuery()
        #}

    }
    catch [System.Exception] 
    { 
        Write-Host -ForegroundColor Red $_.Exception.ToString()    
    }     
} 
 

EnableDisableSiteSync -siteURL "https://mstalk.sharepoint.com" -action "True"