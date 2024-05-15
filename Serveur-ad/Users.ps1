# Importation du module Active Directory
Import-Module ActiveDirectory

# Chemin vers le fichier CSV
$CSVFile = "$env:USERPROFILE\Desktop\Liste_User.csv"

# Importation des données utilisateur depuis le fichier CSV
$CSVData = Import-CSV -Path $CSVFile

# Chemin par défaut pour la création des utilisateurs
$DefaultOUPath = "OU=Utilisateurs,OU=SolarEcoSolution,DC=SolarEcoSolution,DC=lan"

# Création des utilisateurs
foreach ($Utilisateur in $CSVData) {
$Firstname = [Text.Encoding]::ASCII.GetString([Text.Encoding]::GetEncoding("Cyrillic").GetBytes($Utilisateur.PRENOM.ToLower()))
$Lastname = [Text.Encoding]::ASCII.GetString([Text.Encoding]::GetEncoding("Cyrillic").GetBytes($Utilisateur.NOM.ToLower()))

    $SamAccountName = "$Firstname.$Lastname".ToLower()
    $UserPrincipalName = "$SamAccountName@$DomainName.lan"
    $DisplayName = "$Lastname $Firstname"
    $Password = ConvertTo-SecureString "InitialPassword123!" -AsPlainText -Force

    Try {
        # Tentative de création de l'utilisateur
        New-ADUser -SamAccountName $SamAccountName -UserPrincipalName $UserPrincipalName -Name $DisplayName -GivenName $Firstname -Surname $Lastname -Enabled $True -DisplayName $DisplayName -AccountPassword $Password -ChangePasswordAtLogon $True -Path $DefaultOUPath
        Write-Host "Utilisateur créé : $DisplayName" -ForegroundColor Green
    } Catch {
        Write-Host "Erreur lors de la création de l'utilisateur $DisplayName : $_" -ForegroundColor Red
    }
}
