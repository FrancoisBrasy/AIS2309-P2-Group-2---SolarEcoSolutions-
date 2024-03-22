Install-windowsfeature -name AD-Domain-Services 

# ADDSDEPLOYEMENT
Import-Module ADDSDeployment
Install-ADDSForest `
    -CreateDnsDelegation:$false `
    -DatabasePath "C:\Windows\NTDS" `
    -DomainMode "WinThreshold" ` # Vous devrez peut-être ajuster ce paramètre en fonction de la version exacte de Windows Server que vous utilisez.
    -DomainName "SolarEcoSolution.lan" ` # Mettre à jour avec le nouveau nom de domaine.
    -DomainNetbiosName "SOECOSOL" ` # Ceci est une suggestion pour le nom NetBIOS, qui est habituellement une version raccourcie du nom de domaine.
    -ForestMode "WinThreshold" ` # Ajustez également ce paramètre si nécessaire.
    -InstallDns:$true `
    -LogPath "C:\Windows\NTDS" `
    -NoRebootOnCompletion:$false `
    -SysvolPath "C:\Windows\SYSVOL" `
    -Force:$true

# Configure DNS forwarders
Add-DnsServerForwarder -IPAddress 192.168.1.129
