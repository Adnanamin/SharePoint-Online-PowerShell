######################################################################
#Author: Adnan Amin
#Blog: https://mstechtalk.com
#Twitter: @adnan_amin
# Enable / disable sync option for a SharePoint Document Library 
######################################################################


Add-Type -Path "C:\Program Files\Common Files\microsoft shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.dll"
Add-Type -Path "C:\Program Files\Common Files\microsoft shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.Runtime.dll"

#Fuction to enable or disable sync in a document library
function EnableDisableSync ($siteURL, $libraryName, $action)
{ 
     try 
    {  
        $cred= Get-Credential

        $ctx = New-Object Microsoft.SharePoint.Client.ClientContext($siteURL) 
        $credentials = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($cred.Username, $cred.Password)
        $ctx.Credentials = $credentials 
   
        $list = $ctx.Web.Lists.GetByTitle($libraryName) 
        $ctx.Load($list) 
        $ctx.ExecuteQuery() 
 
        #Operation Type 
        if ($action -eq "Enable")  
        {  
        Write-Host "Enabling sync on document library"
            $list.ExcludeFromOfflineClient=$false 
            
        }else { 
            Write-Host "Disabling sync on document library"
            $list.ExcludeFromOfflineClient=$true 
        }     
        $list.Update() 
        $ctx.ExecuteQuery() 
        $ctx.Dispose() 
    } 
    catch [System.Exception] 
    { 
        Write-Host -ForegroundColor Red $_.Exception.ToString()    
    }     
} 
 

EnableDisableSync -siteURL "https://mstalk.sharepoint.com" -libraryName "Documents" -action "Enable"