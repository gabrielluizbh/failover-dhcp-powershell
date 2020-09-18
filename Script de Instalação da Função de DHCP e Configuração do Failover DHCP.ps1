# Script de Instalação da Função de DHCP e Configuração do Failover DCHP - Créditos Gabriel Luiz - www.gabrielluiz.com ##


Install-WindowsFeature -Name DHCP -IncludeManagementTools -Restart # Instalação do Função de DHCP.


Install-WindowsFeature -Name RSAT-DHCP # Instalação da Ferramenta de Gerenciamento Remoto da Função de DHCP.


Add-DhcpServerInDC -DnsName DHCP2.gabrielluiz.local -IPAddress 10.101.0.202 # Autoriza o servidor DHCP no Active Directory.


Set-ItemProperty -Path registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\ServerManager\Roles\12 -Name ConfigurationState -Value 2 # Remove o aviso do Servidor DHCP no Gerenciador do Servidor.


Get-DhcpServerV4Scope # Verifica os escopos criados.


Get-DhcpServerV4Scope 10.101.0.0 | FL  # Verifica o escopo criado atráves do ID do escopo.



# Tipos de configurações do Failover DHCP.



# Modo Espera ativa (Hot Standby) - Servidor parceiro fica ativo em quanto aguarda uma falha do servidor DHCP principal.


Add-DhcpServerv4Failover -ComputerName DHCP.gabrielluiz.local -Name GabrielLuiz-Failover -PartnerServer DHCP2.gabrielluiz.local -ScopeId 10.101.0.0 -ServerRole Active -SharedSecret "@abc123" -Force



# Modo Espera ativa (Hot Standby) - Servidor parceiro fica em espera em quanto aguarda uma falha do servidor DHCP principal.


Add-DhcpServerv4Failover -ComputerName DHCP.gabrielluiz.local -Name GabrielLuiz-Failover -PartnerServer DHCP2.gabrielluiz.local -ScopeId 10.101.0.0 -ServerRole Standby -SharedSecret "@abc123" -Force



<# 

Modo Espera ativa (Hot Standby) - Servidor parceiro fica ativo em quanto aguarda uma falha do servidor DHCP principal.

10% dos endereços IP escopos serão reservados para o servidor DHCP que esta em espera.

O Prazo de Entrega Máximo do Cliente (Maximum Client Lead Time) será de 2 horas, ele define quanto tempo o servidor em espera deve esperar antes de assumir o controle do escopo.

#>

 
Add-DhcpServerv4Failover -ComputerName "DHCP.gabrielluiz.local" -Name "GabrielLuiz-Failover" -ParnerServer "DHCP2.gabrielluiz.local" -ScopeId 10.101.0.0 -ReservePercent 10 -MaxClientLeadTime 2:00:00 -AutoStateTransition $True -StateSwitchInterval 2:00:00


# Modo Balancear carga (Load balance) com 70% das locações alocadas no servidor DHCP principal.

Add-DhcpServerv4Failover –ComputerName DHCP.gabrielluiz.local –PartnerServer DHCP2.gabrielluiz.local –Name GabrielLuiz-Failover –ScopeID 10.101.0.0 –LoadBalancePercent 70 –SharedSecret "@abc123" -Force


<# 

Modo Balancear carga (Load balance) com 70% das locações alocadas no servidor DHCP principal.

O Prazo de Entrega Máximo do Cliente (Maximum Client Lead Time) será de 2 horas, ele define quanto tempo o servidor em espera deve esperar antes de assumir o controle do escopo.

#> 

Add-DhcpServerv4Failover -ComputerName "DHCP.gabrielluiz.local" -Name "GabrielLuiz-Failover" -PartnerServer "DHCP2.gabrielluiz.local" -ScopeId 10.101.0.0 -LoadBalancePercent 70 -MaxClientLeadTime 2:00:00 -AutoStateTransition $True -StateSwitchInterval 2:00:00


# Remover a relações de failover.

Remove-DhcpServerv4Failover -ComputerName "DHCP.gabrielluiz.local" -Name "GabrielLuiz-Failover"


# Replica a configuração do escopo entre os servidores DHCP parceiros de failover.

Invoke-DhcpServerv4FailoverReplication -ComputerName "DHCP.gabrielluiz.local" -Name "GabrielLuiz-Failover"



# Obtém as relações de failover configuradas no serviço de servidor DHCP para o nome de relacionamento de failover específico.



# Obter informações de failover para um relacionamento.

Get-DhcpServerv4Failover -ComputerName "DHCP.gabrielluiz.local" -Name "GabrielLuiz-Failover"


# Obtenha informações de failover para todos os relacionamentos.


Get-DhcpServerv4Failover -ComputerName "DHCP.gabrielluiz.local"


# Obtenha informações de failover para um relacionamento que contenha um escopo.

Get-DhcpServerv4Failover -ComputerName "DHCP.gabrielluiz.local" -ScopeId 10.101.0.0



<# 

Referências:

https://docs.microsoft.com/pt-br/previous-versions/windows/it-pro/windows-server-2012-R2-and-2012/dn338978(v=ws.11)/?WT.mc_id=WDIT-MVP-5003815

https://docs.microsoft.com/pt-br/previous-versions/windows/it-pro/windows-server-2012-R2-and-2012/dn338983(v=ws.11)/?WT.mc_id=WDIT-MVP-5003815

https://docs.microsoft.com/pt-br/previous-versions/windows/it-pro/windows-server-2012-R2-and-2012/dn338976(v=ws.11)/?WT.mc_id=WDIT-MVP-5003815

https://docs.microsoft.com/pt-br/previous-versions/windows/it-pro/windows-server-2012-R2-and-2012/dn338975(v=ws.11)?WT.mc_id=WDIT-MVP-5003815

https://docs.microsoft.com/en-us/powershell/module/dhcpserver/add-dhcpserverv4failover?view=win10-ps/?WT.mc_id=WDIT-MVP-5003815

https://docs.microsoft.com/en-us/powershell/module/dhcpserver/get-dhcpserverv4failover?view=win10-ps/?WT.mc_id=WDIT-MVP-5003815

https://docs.microsoft.com/en-us/powershell/module/servermanager/install-windowsfeature?view=winserver2012r2-ps/?WT.mc_id=WDIT-MVP-5003815

https://docs.microsoft.com/en-us/powershell/module/dhcpserver/Add-DhcpServerInDC?view=winserver2012r2-ps/?WT.mc_id=WDIT-MVP-5003815

https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.management/set-itemproperty?view=powershell-7/?WT.mc_id=WDIT-MVP-5003815

https://docs.microsoft.com/en-us/powershell/module/dhcpserver/get-dhcpserverv4scope?view=win10-ps/?WT.mc_id=WDIT-MVP-5003815

https://docs.microsoft.com/en-us/powershell/module/dhcpserver/remove-dhcpserverv4failover?view=win10-ps/?WT.mc_id=WDIT-MVP-5003815

https://docs.microsoft.com/en-us/powershell/module/dhcpserver/invoke-dhcpserverv4failoverreplication?view=win10-ps/?WT.mc_id=WDIT-MVP-5003815

#>