param (
    [Parameter()]
    [System.String]
    $AdminCredential,

    [Parameter()]
    [System.String]
    $AdminPassword,

    [Parameter()]
    [System.String]
    $CertificateId,

    [Parameter()]
    [System.String]
    $CertificatePath
)

Configuration M365TenantConfig
{
    param (
        [parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $AdminCredential,

        [Parameter(Mandatory = $true)]
        [System.String]
        $CertificateId,

        [Parameter(Mandatory = $true)]
        [System.String]
        $CertificatePath
    )

    $TenantDomain = $AdminCredential.UserName.Split('@')[1]
  
    Import-DscResource -ModuleName 'Microsoft365DSC'

    Node localhost
    {
        ODSettings 'OneDriveSedttings'
        {
            Ensure                                    = 'Present'
            IsSingleInstance                          = 'Yes'
            BlockMacSync                              = $true
            DisableReportProblemDialog                = $true
            ExcludedFileExtensions                    = @("ps1")
            NotificationsInOneDriveForBusinessEnabled = $true
            NotifyOwnersWhenInvitationsAccepted       = $true
            OneDriveForGuestsEnabled                  = $false
            OrphanedPersonalSitesRetentionPeriod      = 90
            Credential                                = $AdminCredential
        }

        SPOAccessControlSettings 'ConfigureAccessControlSettings'
        {
            Ensure                                    = 'Present'
            IsSingleInstance                          = 'Yes'
            CommentsOnSitePagesDisabled               = $true
            DisallowInfectedFileDownload              = $false
            DisplayStartASiteOption                   = $false
            ExternalServicesEnabled                   = $false
            SocialBarOnSitePagesDisabled              = $true
            Credential                                = $AdminCredential
        }

        SPOSharingSettings 'ConfigureSharingSettings'
        {
            Ensure                                    = 'Present'
            IsSingleInstance                          = 'Yes'
            SharingCapability                         = 'ExistingExternalUserSharingOnly'
            EnableGuestSignInAcceleration             = $false
            SharingDomainRestrictionMode              = 'BlockList'
            SharingBlockedDomainList                  = @('homecloudlab.com','contoso.com','fabrikam.com')
            DefaultSharingLinkType                    = 'Internal'
            FileAnonymousLinkType                     = 'View'
            FolderAnonymousLinkType                   = 'View'
            DefaultLinkPermission                     = 'View'
            ShowPeoplePickerSuggestionsForGuestUsers  = $false
            PreventExternalUsersFromResharing         = $true
            NotifyOwnersWhenItemsReshared             = $true
            Credential                                = $AdminCredential
        }

        SPOSite 'M365DemoSite'
        {
            Ensure                                    = 'Present'
            Title                                     = 'M365DSC - DevOps'
            Url                                       = 'https://x282t.sharepoint.com/sites/DevOps'
            Template                                  = 'STS#3'
            TimeZoneId                                = 13
            LocaleId                                  = 1033
            Owner                                     = "MOD1@$TenantDomain"
            AnonymousLinkExpirationInDays             = 15
            CommentsOnSitePagesDisabled               = $true
            DisableFlows                              = $true
            Credential                                = $AdminCredential
        }
    }
}

$ConfigurationData = @{
    AllNodes = @(
        @{
            NodeName = 'localhost'
		    PSDscAllowDomainUser = $true
            PsDscAllowPlainTextPassword = $false
            CertificateFile = $CertificatePath
            Thumbprint = $CertificateId
        }
    )
}

# Generate MOF file
$password = ConvertTo-SecureString $AdminPassword -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential ($AdminCredential, $password)
M365TenantConfig -ConfigurationData $ConfigurationData -AdminCredential $credential -CertificateId $CertificateId -CertificatePath $CertificatePath