<#
  .SYNOPSIS
   Retrieves session details for a specified AD user across all domain-joined servers.

  .DESCRIPTION
   This module checks the connectivity status of each domain-joined server, and if the server is online, 
   it retrieves session information for the specified Active Directory user.

   No workstations will be included (List Could be BIG in larger environment)

  .PARAMETER identity
   SamAccountName of the AD user you are searching for.
   This parameter is mandatory.

  .PARAMETER searchbase
   Specifies Active Directory path where the search should begin.
   This parameter is optional. If not specified, the command searches session information across all domain-joined servers.

  .EXAMPLES
   Get-ADUserSession -identity "testuser001"
   search user session of testuser001 in all the domain-joined servers.
   
  .EXAMPLES
   Get-ADUserSession -identity "testuser001" -searchbase "OU=AppServers,DC=domaintest,DC=com"
   search user session of testuser001 in domain-joined servers present in Appservers OU only.

  .REQUIREMENTS
     - Run as Administrator is mandatory.
     - Run this module either in DC or RSAT server.

 .OUTPUT
  Return PSCustomObject contain session details such as ServerName, SessionID,State,LogonTime

  .NOTES
   Author: Nihal Prasad
   Created: 06/10/25
   Version: 1.1.0


 #>

Function Get-ADUserSession
{
[CmdletBinding()]
param(
[Parameter(Mandatory = $true)]
[string] $identity,
$searchbase
)

try
{
$result = @()

Write-Progress -Activity "Checking $identity in AD"
Start-Sleep -Seconds 2
$usr = Get-ADUser -Identity $identity | Select Name,Enabled

if($usr.Enabled)
{

if($searchbase -ne $null)
{
$servers = Get-ADComputer -LDAPFilter "(&(OperatingSystem=*Server*)(!(useraccountcontrol:1.2.840.113556.1.4.804:=2)))" -SearchBase $searchbase | select -ExpandProperty Name
}
else
{
$servers = Get-ADComputer -LDAPFilter "(&(OperatingSystem=*Server*)(!(useraccountcontrol:1.2.840.113556.1.4.804:=2)))" | select -ExpandProperty Name
}

Foreach($svr in $servers)
{

    if(Test-Connection -ComputerName $svr -Count 1 -ErrorAction SilentlyContinue)
    {
    Write-Progress -Activity "Finding User Session of $identity" -Status "Checking UserSession in $svr"
    $users = quser /server:$svr 2>$null | Select-Object -Skip 1
    }
    else
    {
    $users = $null
    }

if($users -ne $null)
{
$userdetails = @()

    foreach ($user in $users) 
        {

        $sessiondetails = ($user.Trim() -replace '\s+',' ' -split '\s')

         if($sessiondetails.Count -eq 8)
         {
            $userdetails += [pscustomobject]@{
             name = $sessiondetails[0]
             id = $sessiondetails[2]
             State = $sessiondetails[3]
             LoginTime = ($sessiondetails[5]+" "+$sessiondetails[6]+" "+$sessiondetails[7])
             }
         }
        elseif ($sessiondetails.Count -eq 7)
         {
            $userdetails += [pscustomobject]@{
             name = $sessiondetails[0]
             id = $sessiondetails[1]
             State = $sessiondetails[2]
             LoginTime = ($sessiondetails[4]+" "+$sessiondetails[5]+" "+$sessiondetails[6])
             }
         }
    }

    foreach ($userdetail in $userdetails)
    {
        if($userdetail.name -eq $identity)
        {
         $result += [pscustomobject]@{
         ServerName = $svr
         SessionID = $userdetail.id
         State = $userdetail.State
         LoginTime = $userdetail.LoginTime
         }
        }
    }
}

}

if($result -ne $null)
{
Write-Host "`nDetails of the $identity session are shown below." -ForegroundColor Green
$result
}
else
{
Write-Host "$identity session has not found in any of AD Servers`n" -ForegroundColor Cyan
}

}
else
{
Write-host "$identity is disabled in AD , hence this user cannot login to any server" -ForegroundColor Cyan
}
}
catch
{
$supportURL = "https://github.com/nihalpra1995/PSADUserSession/blob/main/EXCEPTIONS_INFO.md"
Write-Host "An error occurred while trying to run the requested operation.`nPlease visit this URL for assistance: $supportURL" -ForegroundColor Red
}
}
