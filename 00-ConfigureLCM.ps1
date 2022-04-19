Clear-Host
Set-Location -Path $PSScriptRoot

# Input Parameters  
$CertificateId = Read-Host 'Inject the DSC Certificate Thumbprint'

Configuration ConfigureLCM
{
 Import-DscResource -ModuleName PSDesiredStateConfiguration

 node 'localhost'
 {
    LocalConfigurationManager
    {
        CertificateId = $CertificateId
    }
 }
}

# Generate MOF file
ConfigureLcm

#Apply Configuration
winrm quickconfig -force
Set-DscLocalConfigurationManager -Path ./ConfigureLCM -Verbose