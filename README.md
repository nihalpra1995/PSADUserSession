# PSADUserSession

Retrieve session details for a specified AD user across all domain-joined servers.

## Installation of Module
```Powershell
# Install (in PowerShell >= v5)
Install-Module -Name PSADUserSession
```

## Requirement
1.Run powershell as administrator.  
2.To ensure accurate and complete output, the user executing this module must have **Domain Admin** privileges or be a member of the **Local Administrators** or **Remote Desktop Users** group on all domain-joined servers.Insufficient privileges may result in incomplete or inconsistent results.

## Usage
```PowerShell
#UserSession details accross all the domain-joined servers.
Get-ADUserSession -identity "<samaccountname>"

#UserSession details of domain-joined servers present in specific OU.
Get-ADUserSession -identity "<samaccountname>" -searchbase "OU=<OU Name>,DC=<domainname>,DC=com"
```

## Output
Return PSCustomObject contain session details of user such as ServerName, SessionID,State,LogonTime

## Exception
[Click here for Exception Information](https://github.com/nihalpra1995/PSADUserSession/blob/main/EXCEPTIONS_INFO.md)
