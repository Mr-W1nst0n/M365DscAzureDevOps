param (
    [Parameter()]
    [System.String]
    $AdminCredential,

    [Parameter()]
    [System.String]
    $AdminPassword
)

Configuration M365TenantConfig
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
            OrphanedPersonalSitesRetentionPeriod      = 60
            ApplicationId                             = $ConfigurationData.AllNodes.ApplicationId
            CertificateThumbprint                     = $ConfigurationData.AllNodes.CertificateId
            TenantId                                  = $ConfigurationData.AllNodes.TenantId
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
            ApplicationId                             = $ConfigurationData.AllNodes.ApplicationId
            CertificateThumbprint                     = $ConfigurationData.AllNodes.CertificateId
            TenantId                                  = $ConfigurationData.AllNodes.TenantId
        }

        SPOSharingSettings 'ConfigureSharingSettings'
        {
            Ensure                                    = 'Present'
            IsSingleInstance                          = 'Yes'
            SharingCapability                         = 'ExistingExternalUserSharingOnly'
            EnableGuestSignInAcceleration             = $false
            SharingDomainRestrictionMode              = 'BlockList'
            SharingBlockedDomainList                  = @('homecloudlab.com','contoso.com')
            DefaultSharingLinkType                    = 'Internal'
            FileAnonymousLinkType                     = 'View'
            FolderAnonymousLinkType                   = 'View'
            DefaultLinkPermission                     = 'View'
            ShowPeoplePickerSuggestionsForGuestUsers  = $false
            PreventExternalUsersFromResharing         = $true
            NotifyOwnersWhenItemsReshared             = $true
            ApplicationId                             = $ConfigurationData.AllNodes.ApplicationId
            CertificateThumbprint                     = $ConfigurationData.AllNodes.CertificateId
            TenantId                                  = $ConfigurationData.AllNodes.TenantId
        }

        SPOSite 'M365DemoSite'
        {
            Ensure                                      = 'Present'
            Title                                       = 'M365DSC - DevOps'
            Url                                         = 'https://x282t.sharepoint.com/sites/DevOps'
            Template                                    = 'STS#3'
            TimeZoneId                                  = 13
            LocaleId                                    = 1033
            Owner                                       = "MOD1@$TenantDomain"
            AnonymousLinkExpirationInDays               = 15
            CommentsOnSitePagesDisabled                 = $true
            DisableFlows                                = $true
            ApplicationId                             = $ConfigurationData.AllNodes.ApplicationId
            CertificateThumbprint                     = $ConfigurationData.AllNodes.CertificateId
            TenantId                                  = $ConfigurationData.AllNodes.TenantId
        }
    }
}

$ConfigurationData = @{
    AllNodes = @(
        @{
            NodeName = 'localhost'
            PsDscAllowPlainTextPassword = $false
            ApplicationId = '4b525de4-bc33-4294-b0a1-e482b7c4952c'
            CertificateId = '59114ACB8FF5CC5F165CB08DB88C625733740E6A'
            TenantId = 'x282t.onmicrosoft.com'
        }
    )
}

# Generate MOF file
$password = ConvertTo-SecureString $AdminPassword -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential ($AdminCredential, $password)
M365TenantConfig -ConfigurationData $ConfigurationData -AdminCredential $credential