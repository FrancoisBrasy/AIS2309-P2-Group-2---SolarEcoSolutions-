# Création de l'unité d'organisation SolarEcoSolution
$MonDomaine="SolarEcoSolution"
New-ADOrganizationalUnit -Name "SolarEcoSolution" -Path "DC=$MonDomaine,DC=lan"

# Création des sous-unités d'organisation Machines, Utilisateurs et Serveurs sous SolarEcoSolution
$UO_Name = "Machines", "Utilisateurs", "Serveurs"

foreach($UO in $UO_Name){
    try {
        New-ADOrganizationalUnit -Name "$UO" -Path "OU=$MonDomaine,DC=SolarEcoSolution,DC=lan" -ProtectedFromAccidentalDeletion $true
        Write-Host "UO est créé : $($UO)" -ForegroundColor white -BackgroundColor green
    }
    catch {
        Write-Host "Une erreur est survenue : $($UO)" -ForegroundColor white -BackgroundColor red
    }
}

# Ajout des groupes aux sous-unités Utilisateurs
$ouUtilisateurs = Get-ADOrganizationalUnit -Filter {Name -eq "Utilisateurs"}

# Définition des groupes à créer en se basant sur les services spécifiés
$groupes = @{
    "R&D" = "Research and Development";
    "DG" = "General Management";
    "DAF" = "Administrative and Financial Directorate";
    "Commerciaux" = "Sales Team";
    "IT" = "Information Technology";
    "Production" = "Production";
    "Logistique, Expédition" = "Logistics, Shipping";
    "Maintenance" = "Maintenance";
    "Atelier" = "Workshop"
}

foreach ($key in $groupes.Keys) {
    $group = "${key}_user" # Création du nom du groupe pour les utilisateurs
    try {
        New-ADGroup -Name $group -GroupCategory Security -GroupScope Global -Path $ouUtilisateurs.DistinguishedName
        Write-Host "Le groupe utilisateur est créé : $($group)" -ForegroundColor white -BackgroundColor green
    } 
    catch {
        Write-Host "Une erreur est survenue pour le groupe utilisateur : $($group)" -ForegroundColor white -BackgroundColor red
    }
}
