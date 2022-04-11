Clear-Host
Set-Location -Path $PSScriptRoot

# Input Parameters  
$CertPassword = Read-Host 'Set a Certificate Password' -MaskInput

$cert = New-SelfSignedCertificate -Subject 'CN=Microsoft365DSC' -CertStoreLocation 'Cert:\LocalMachine\My' -KeyExportPolicy Exportable -KeySpec Signature
$password = ConvertTo-SecureString $CertPassword -AsPlainText -Force
Export-PfxCertificate -Cert $cert -FilePath ./M365ClientCert.pfx -Password $password | Out-Null
Export-Certificate -Cert $cert -FilePath ./M365ClientCert.cer | Out-Null

Write-Host "$($cert.Thumbprint) Generated and Exported" -ForegroundColor Green