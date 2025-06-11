# PSADUserSession

Retrieve session details for a specified AD user across all domain-joined servers.

## Installation of Module
```Powershell
# Install (in PowerShell >= v5)
Install-Module -Name PSADUserSession
```
## Usage
Run powershell as administrator

```PowerShell
#UserSession details accross all the domain-joined servers.
Get-ADUserSession -identity "<samaccountname>"

#UserSession details of domain-joined servers present in specific OU.
Get-ADUserSession -identity "<samaccountname>" -searchbase "OU=<OU Name>,DC=<domainname>,DC=com"
```

## Output
PSCustomObject
Return PSCustomObject contain session details of user such as ServerName, SessionID,State,LogonTime

## Exception
[Click here for Exception Information](https://github.com/nihalpra1995/PSADUserSession/blob/main/EXCEPTIONS_INFO.md)
