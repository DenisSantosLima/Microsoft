# Configurações para não incluir drivers na busca
$searcher = New-Object -ComObject Microsoft.Update.Searcher

# Modifica a query para buscar atualizações que não estão instaladas e não incluem drivers
$searchCriteria = "IsInstalled=0 AND Type='Software'"

# Busca por atualizações com a query ajustada
$searchResult = $searcher.Search($searchCriteria)

# Verifica se há atualizações disponíveis
if ($searchResult.Updates.Count -eq 0) {
    Write-Host "Não há atualizações pendentes."
    exit
}

# Lista as atualizações encontradas
$updatesToInstall = New-Object -ComObject Microsoft.Update.UpdateColl
foreach ($update in $searchResult.Updates) {
    Write-Host "Encontrada atualização: $($update.Title)"
    $updatesToInstall.Add($update) | Out-Null
}

# Instala as atualizações encontradas
if ($updatesToInstall.Count -gt 0) {
    Write-Host "Iniciando a instalação das atualizações..."
    $installer = New-Object -ComObject Microsoft.Update.Installer
    $installer.Updates = $updatesToInstall
    $installationResult = $installer.Install()

    # Verifica o resultado da instalação
    if ($installationResult.ResultCode -eq 2) {
        Write-Host "Atualizações instaladas com sucesso!"
    } else {
        Write-Host "Houve problemas na instalação das atualizações. Código de resultado: $($installationResult.ResultCode)"
    }

    # Suprime qualquer reinicialização solicitada
    if ($installationResult.RebootRequired -eq $true) {
        Write-Host "Atualizações instaladas, mas reinicialização foi suprimida."
    } else {
        Write-Host "Nenhuma reinicialização necessária."
    }
}

# Não forçar reinicialização
Write-Host "Instalação concluída. Reinicialização suprimida."

exit 0
