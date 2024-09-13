# Defina o KB que deseja instalar
$kbNumber = "5005565"  # Substitua pelo número do KB desejado

# Cria o objeto de busca de atualizações
$updateSession = New-Object -ComObject Microsoft.Update.Session
$updateSearcher = $updateSession.CreateUpdateSearcher()

# Busca por atualizações específicas com base no número do KB
$searchCriteria = "IsInstalled=0 AND UpdateID LIKE '%$kbNumber%'"
$searchResult = $updateSearcher.Search($searchCriteria)

# Verifica se há atualizações correspondentes ao KB fornecido
if ($searchResult.Updates.Count -eq 0) {
    Write-Host "Nenhuma atualização correspondente ao KB $kbNumber foi encontrada."
    exit
}

# Adiciona a atualização encontrada à coleção de atualizações para instalação
$updatesToInstall = New-Object -ComObject Microsoft.Update.UpdateColl
foreach ($update in $searchResult.Updates) {
    Write-Host "Encontrada atualização: $($update.Title)"
    $updatesToInstall.Add($update) | Out-Null
}

# Instala as atualizações encontradas
if ($updatesToInstall.Count -gt 0) {
    Write-Host "Iniciando o download e instalação da atualização KB$kbNumber..."
    $installer = New-Object -ComObject Microsoft.Update.Installer
    $installer.Updates = $updatesToInstall
    $installationResult = $installer.Install()

    # Verifica o resultado da instalação
    if ($installationResult.ResultCode -eq 2) {
        Write-Host "Atualização KB$kbNumber instalada com sucesso!"
    } else {
        Write-Host "Houve problemas na instalação da atualização. Código de resultado: $($installationResult.ResultCode)"
    }

    # Suprime qualquer reinicialização solicitada
    if ($installationResult.RebootRequired -eq $true) {
        Write-Host "Atualização instalada, mas reinicialização foi suprimida."
    } else {
        Write-Host "Nenhuma reinicialização necessária."
    }
}

# Não forçar reinicialização
Write-Host "Instalação concluída. Reinicialização suprimida."

exit 0
