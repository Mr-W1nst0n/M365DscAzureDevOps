Clear-Host
Set-Location -Path $PSScriptRoot

# Input Parameters  
$CertPassword = Read-Host 'Set a Certificate Password'

$cert = New-SelfSignedCertificate -Subject 'CN=Microsoft365DSC' -DnsName 'Microsoft365DSC' -CertStoreLocation 'Cert:\LocalMachine\My' -KeyExportPolicy Exportable -Type DocumentEncryptionCertLegacyCsp -HashAlgorithm SHA256
$password = ConvertTo-SecureString $CertPassword -AsPlainText -Force
Export-PfxCertificate -Cert $cert -FilePath ./M365ClientCert.pfx -Password $password | Out-Null
Export-Certificate -Cert $cert -FilePath ./M365ClientCert.cer | Out-Null

Write-Host "$($cert.Thumbprint) Generated and Exported" -ForegroundColor Green