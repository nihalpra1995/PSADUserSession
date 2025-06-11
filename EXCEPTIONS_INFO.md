# Exception Information

## Exception

1. The '**-Identity**' parameter does not appear to contain a valid SamAccountName.
2. The specified user could not be found in Active Directory.
3. The '**-SearchBase**' parameter contains an invalid OU path.
4. This module must be run on a Domain Controller or a machine with RSAT tools installed.

## Solution

1. The '**-Identity**' parameter does not appear to contain a valid SamAccountName.  
   Please use correct SamAccountName of the user and try again.

2. The specified user could not be found in Active Directory.  
   Ensure the user exists in Active Directory before running this module.

3. The '**-SearchBase**' parameter contains an invalid OU path.  
   The value provided for **-SearchBase** should be a valid and represent an OU path in Active Directory.
   Example Format: "OU=AppServers,DC=domaintest,DC=com" or "OU=AppServers,OU=Servers,DC=domaintest,DC=com"

4. This module must be run on a Domain Controller or a machine with RSAT tools installed.  
   This module requires execution on a Domain Controller or a system with the Remote Server Administration Tools (RSAT)          installed.
  
   
   

