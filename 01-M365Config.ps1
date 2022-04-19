param (
    [Parameter()]
    [System.String]
    $AdminCredential,

    [Parameter()]
    [System.String]
    $AdminPassword
)

Configuration M365Config
{
    param (
        [parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $AdminCredential
    )

    $TenantDomain = $AdminCredential.UserName.Split('@')[1]
    
    Import-DscResource -ModuleName 'Microsoft365DSC'

    Node localhost
    {
        TeamsUser 'AddTeamUser'
        {
            TeamName   = 'Retail'
            User       = "jsnow@$TenantDomain"
            Role       = 'Member'
            Ensure     = 'Present'
            Credential = $AdminCredential
        }
    }
}

$ConfigurationData = @{
    AllNodes = @(
        @{
            NodeName = 'localhost'
	        PSDscAllowDomainUser = $true            
	        PsDscAllowPlainTextPassword = $true
        }
    )
}

# Generate MOF file
$password = ConvertTo-SecureString $AdminPassword -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential ($AdminCredential, $password)
M365Config -ConfigurationData $ConfigurationData -AdminCredential $credential