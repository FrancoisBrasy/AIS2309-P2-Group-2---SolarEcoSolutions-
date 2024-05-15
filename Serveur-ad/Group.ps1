# Importation du module Active Directory
Import-Module ActiveDirectory

# Chemin vers le fichier CSV
$CSVFile = "$env:USERPROFILE\Desktop\Liste_User.csv"

# Importation des données utilisateur depuis le fichier CSV
$CSVData = Import-CSV -Path $CSVFile

# Table de correspondance entre le service et le CN du groupe
$serviceToGroupMapping = @{
    "R&D/Qualité" = "CN=R&D,OU=Groupe_Utilisateurs,OU=SolarEcoSolution,DC=SolarEcoSolution,DC=lan"
    "Direction" = "CN=DG,OU=Groupe_Utilisateurs,OU=SolarEcoSolution,DC=SolarEcoSolution,DC=lan"
    "Finances" = "CN=DAF,OU=Groupe_Utilisateurs,OU=SolarEcoSolution,DC=SolarEcoSolution,DC=lan"
    "Service commercial" = "CN=Commerciaux,OU=Groupe_Utilisateurs,OU=SolarEcoSolution,DC=SolarEcoSolution,DC=lan"
    "Informatique" = "CN=IT,OU=Groupe_Utilisateurs,OU=SolarEcoSolution,DC=SolarEcoSolution,DC=lan"
    "Production" = "CN=Production,OU=Groupe_Utilisateurs,OU=SolarEcoSolution,DC=SolarEcoSolution,DC=lan"
    "Logistique/approvisionnement" = "CN=Logistique,OU=Groupe_Utilisateurs,OU=SolarEcoSolution,DC=SolarEcoSolution,DC=lan"
    "Expédition" = "CN=Logistique,OU=Groupe_Utilisateurs,OU=SolarEcoSolution,DC=SolarEcoSolution,DC=lan"
    "Maintenance" = "CN=Maintenance,OU=Groupe_Utilisateurs,OU=SolarEcoSolution,DC=SolarEcoSolution,DC=lan"
    "Atelier" = "CN=Atelier,OU=Groupe_Utilisateurs,OU=SolarEcoSolution,DC=SolarEcoSolution,DC=lan"
    "Dpt Administratif & Financier" = "CN=DAF,OU=Groupe_Utilisateurs,OU=SolarEcoSolution,DC=SolarEcoSolution,DC=lan"
}

# Ajout des utilisateurs aux groupes
foreach ($Utilisateur in $CSVData) {
    $Firstname = $Utilisateur.PRENOM
    $Lastname = $Utilisateur.NOM
    $Service = $Utilisateur.SERVICE
    $SamAccountName = "$Firstname.$Lastname".ToLower()
    
    # Récupération du DN du groupe basé sur la table de correspondance
    $GroupDN = $serviceToGroupMapping[$Service]

    If (-not $GroupDN) {
        Write-Host "Aucun groupe trouvé pour le service : $Service" -ForegroundColor Red
        Continue
    }

    Try {
        # Tentative d'ajout de l'utilisateur au groupe
        Add-ADGroupMember -Identity $GroupDN -Members $SamAccountName
        Write-Host "Utilisateur $SamAccountName ajouté au groupe $GroupDN" -ForegroundColor Green
    } Catch {
        Write-Host "Erreur lors de l'ajout de l'utilisateur $SamAccountName au groupe $GroupDN : $_" -ForegroundColor Red
    }
}
