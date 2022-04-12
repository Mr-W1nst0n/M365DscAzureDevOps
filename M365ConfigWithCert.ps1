param (
    [Parameter()]
    [System.String]
    $OrgName,

    [Parameter()]
    [System.String]
    $TenantId,

    [Parameter()]
    [System.String]
    $ApplicationId,

    [Parameter()]
    [System.String]
    $CertificateId
)

Configuration M365TenantConfig
{
    param (
        [parameter(Mandatory = $true)]
        [System.String]
        $OrgName,

        [Parameter(Mandatory = $true)]
        [System.String]
        $TenantId,

        [Parameter(Mandatory = $true)]
        [System.String]
        $ApplicationId,

        [Parameter(Mandatory = $true)]
        [System.String]
        $CertificateId
    )
  
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
            ApplicationId                             = $ApplicationId
            CertificateThumbprint                     = $CertificateId
            TenantId                                  = $TenantId
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
            ApplicationId                             = $ApplicationId
            CertificateThumbprint                     = $CertificateId
            TenantId                                  = $TenantId
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
            ApplicationId                             = $ApplicationId
            CertificateThumbprint                     = $CertificateId
            TenantId                                  = $TenantId
        }

        SPOSite 'M365DemoSite'
        {
            Ensure                                      = 'Present'
            Title                                       = 'M365DSC - DevOps'
            Url                                         = 'https://x282t.sharepoint.com/sites/DevOps'
            Template                                    = 'STS#3'
            TimeZoneId                                  = 13
            LocaleId                                    = 1033
            Owner                                       = "MOD1@$OrgName"
            AnonymousLinkExpirationInDays               = 15
            CommentsOnSitePagesDisabled                 = $true
            DisableFlows                                = $true
            ApplicationId                             = $ApplicationId
            CertificateThumbprint                     = $CertificateId
            TenantId                                  = $TenantId
        }
    }
}

$ConfigurationData = @{
    AllNodes = @(
        @{
            NodeName = 'localhost'
            PsDscAllowPlainTextPassword = $false
        }
    )
}

# Generate MOF file
M365TenantConfig -ConfigurationData $ConfigurationData -OrgName $OrgName -TenantId $TenantId -ApplicationId $ApplicationId -CertificateId $CertificateId