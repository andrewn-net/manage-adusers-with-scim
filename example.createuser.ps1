# Enter details for new user

$firstname = Read-Host 'Enter first name of new user'
$surname = Read-Host 'Enter surname of new user'
$username = Read-Host 'Enter username of new user'
$email = Read-Host 'Enter email address of new user'

$fullname = $firstname + " " + $surname

# Create new user in Active Directory

New-ADUser -Name $fullname -GivenName $firstname -Surname $surname -SamAccountName $username -UserPrincipalName $email -Enabled $true -AccountPassword (Read-Host -AsSecureString "AccountPassword")

# Call Slack SCIM API  - replace SCIM-TOKEN with actual token

$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$headers.Add("Authorization", 'SCIM-TOKEN')

$URI = "https://api.slack.com/scim/v1/Users/"

$person = @{
    schemas="urn:scim:schemas:core:1.0"
    userName=$username
    nickName=$username
    name = 
        @{"givenName"=$firstname; "familyName"=$surname}
        
    emails = @(
        @{"value"=$email; "primary"="true"}
        )
}

$json = $person | ConvertTo-Json

Invoke-RestMethod $URI -Method POST -Body $json -ContentType 'application/json' -Headers $headers
