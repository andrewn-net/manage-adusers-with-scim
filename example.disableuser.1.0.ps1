# Get Active Directory user details
$searchUser = Read-Host 'Lookup a user by name'

Get-ADUser -Filter "Name -like '*$searchUser*'" | FT Name,SamAccountName -A

# Enter in SamAccountName
$selectedUser = Read-Host 'Enter SamAccountName to disable account in AD and Slack'

# Disable user in Active Directory

Disable-ADAccount -Identity $selectedUser

# Call Slack SCIM API - replace SCIM-TOKEN with actual token

$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$headers.Add("Authorization", 'SCIM-TOKEN')

$URI_getID = "https://api.slack.com/scim/v1/Users/?filter=userName eq $selectedUser"

$json = Invoke-RestMethod -Uri $URI_getID -Headers $headers

# Store user ID in variable

$userID = $json.Resources.id

$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$headers.Add("Authorization", 'SCIM-TOKEN')

$URI_disableUser = "https://api.slack.com/scim/v1/Users/$userID"
Invoke-RestMethod -Uri $URI_disableUser -Headers $headers -Method Delete
