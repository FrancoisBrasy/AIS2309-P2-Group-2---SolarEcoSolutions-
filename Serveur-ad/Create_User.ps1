$Header = 'Prenom','Nom','Société','Site','Service','fonction','Manager','email','Téléphone fixe','Téléphone portable','Nomadisme - Télétravail'
$CSVFile = "C:\Users\Administrator\Desktop\temp-aduser.csv"
$CSVData = Import-CSV -Path $CSVFile -Delimiter "," -Encoding UTF8 -Header $Header | Where-Object { $_.PSObject.Properties.Value -ne '' } 
$DomainName = 'SolarEcoSolution'

# Déclaration des nouveaux groupes en fonction des services
$research = "CN=R&D_user,OU=Utilisateurs,DC=SolarEcoSolution,DC=lan"
$generalManagement = "CN=DG_user,OU=Utilisateurs,DC=SolarEcoSolution,DC=lan"
$accounting = "CN=DAF_user,OU=Utilisateurs,DC=SolarEcoSolution,DC=lan"
$sales = "CN=Commerciaux_user,OU=Utilisateurs,DC=SolarEcoSolution,DC=lan"
$it = "CN=IT_user,OU=Utilisateurs,DC=SolarEcoSolution,DC=lan"
$production = "CN=Production_user,OU=Utilisateurs,DC=SolarEcoSolution,DC=lan"
$logistics = "CN=Logistique_Expedition_user,OU=Utilisateurs,DC=SolarEcoSolution,DC=lan"
$maintenance = "CN=Maintenance_user,OU=Utilisateurs,DC=SolarEcoSolution,DC=lan"
$workshop = "CN=Atelier_user,OU=Utilisateurs,DC=SolarEcoSolution,DC=lan"

Foreach($Utilisateur in $CSVDATA )
{   
    $Firstname = [Text.Encoding]::ASCII.GetString([Text.Encoding]::GetEncoding("Cyrillic").GetBytes($Utilisateur.Prenom.ToLower()))
    $Lastname = [Text.Encoding]::ASCII.GetString([Text.Encoding]::GetEncoding("Cyrillic").GetBytes($Utilisateur.Nom.ToLower()))
    $Name = "$Firstname.$Lastname"
    $SamAccountName = "$Firstname.$Lastname"
    $UserPrincipalName = "$Firstname.$Lastname@$DomainName.lan"
    $password = "SolarEcoSolutionComp@ny2Reset"
    $UtilisateurSite = [Text.Encoding]::ASCII.GetString([Text.Encoding]::GetEncoding("Cyrillic").GetBytes($Utilisateur.Site.ToLower()))
    $UtilisateurService = [Text.Encoding]::ASCII.GetString([Text.Encoding]::GetEncoding("Cyrillic").GetBytes($Utilisateur.Service.ToLower()))

    # Assignation du chemin d'accès au groupe correspondant au service de l'utilisateur
    switch ($UtilisateurService)
    {
        "r&d" { $Path = $research }
        "dg" { $Path = $generalManagement }
        "daf" { $Path = $accounting }
        "commerciaux" { $Path = $sales }
        "it" { $Path = $it }
        "production" { $Path = $production }
        "logistique,expédition" { $Path = $logistics }
        "maintenance" { $Path = $maintenance }
        "atelier" { $Path = $workshop }
        default { $Path = "OU=Utilisateurs,DC=SolarEcoSolution,DC=lan" }
    }

    try
    {
        # Création de l'utilisateur dans l'AD avec les attributs fournis
        New-ADUser `
            -SamAccountName $SamAccountName `
            -UserPrincipalName $UserPrincipalName `
            -Name $Name `
            -GivenName $Firstname `
            -Surname $Lastname `
            -Enabled $True `
            -ChangePasswordAtLogon $True `
            -DisplayName "$Lastname, $Firstname" `
            -AccountPassword (convertto-securestring $password -AsPlainText -Force) `
            -Path $Path `
            -Office $UtilisateurSite


                 # Ajout de l'utilisateur au groupe AD correspondant
        Add-ADGroupMember -Identity $Path -Members $SamAccountName
        Write-Host "Le compte est créé : $($SamAccountName)" -ForegroundColor white -BackgroundColor green
    }
    catch
    {
        Write-Host "Une erreur est survenue : $($SamAccountName)" -ForegroundColor white -BackgroundColor red
    }
}
