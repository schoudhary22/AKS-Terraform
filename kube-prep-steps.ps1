#### Parameters

$keyvaultname = "xxxxx"
$location = "xxxxx"
$keyvaultrg = "xxxxxx"
$sshkeysecret = "xxxxx"
$spnclientid = "xxxxxx"
$clientidkvsecretname = "xxxxxx"
$spnclientsecret = "xxxxxx"
$spnkvsecretname = "xxxxx"
$spnname = "xxxxxx"


#### Create Key Vault

New-AzResourceGroup -Name $keyvaultrg -Location $location

New-AzKeyVault -Name $keyvaultname -ResourceGroupName "myResourceGroup" -Location $location


#### create an ssh key for setting up password-less login between agent nodes.

ssh-keygen  -f ~/.ssh/id_rsa_terraform


#### Add SSH Key in Azure Key vault secret

$pubkey = cat ~/.ssh/id_rsa_terraform.pub

$Secret = ConvertTo-SecureString -String $pubkey -AsPlainText -Force

Set-AzKeyVaultSecret -VaultName $keyvaultname -Name $sshkeysecret -SecretValue $Secret


#### Store service principal Client id in Azure KeyVault

$Secret = ConvertTo-SecureString -String $spnclientid -AsPlainText -Force

Set-AzKeyVaultSecret -VaultName $keyvaultname -Name $clientidkvsecretname -SecretValue $Secret


#### Store service principal Secret in Azure KeyVault

$Secret = ConvertTo-SecureString -String $spnclientsecret -AsPlainText -Force

Set-AzKeyVaultSecret -VaultName $keyvaultname -Name $spnkvsecretname -SecretValue $Secret


#### Provide Keyvault secret access to SPN using Keyvault access policy

Set-AzKeyVaultAccessPolicy -VaultName $keyvaultname -ServicePrincipalName $spnname -PermissionsToSecrets Get,Set
