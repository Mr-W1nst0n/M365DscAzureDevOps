# M365DscAzureDevOps
M365Dsc CI/CD Pipelines using AzureDevOps

### Available Showcases:

- Integrate M365Dsc using Credential Authentication **(least secure!)** + AzureDevOps Self-Hosted Agent

```ruby
'01-M365Config.ps1'
'01-azure-pipelines.yml' -- #(Self-Hosted Agent)
'01-azure-pipelines-MSFTPool.yml' -- #(MSFT Hosted Agent)
```

- Integrate M365Dsc using ApplicationID + AzureDevOps Self-Hosted Agent  

```ruby
'02-M365ConfigWithCert.ps1'
'02-azure-pipelines.yml' -- #(Self-Hosted Agent)
```

- Integrate M365Dsc using Credential Authentication Encrypted + AzureDevOps Self-Hosted Agent  

```ruby
'03-M365ConfigEncrypted.ps1'
'03-azure-pipelines.yml' -- #(Self-Hosted Agent)
```

### Extra  

```ruby
- '00-ConfigureLCM.ps1' -- #(Configure LCM on Self-Hosted Pool)
- '00-Generate-SelfSignCertificate.ps1' -- #(Generate a SelfSign DSC Certificate)
```
