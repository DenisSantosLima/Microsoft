# ------------------------------------------------------------------------------
# Script Name: Remove-NonPreservedAdminUsers.ps1
# Author: Denis Santos Lima
# Date: 22/08/2024
# Version: 1.0.0
# Description: Remove todos os usuários do grupo local "Administradores" que não 
#              estão na lista de preservação definida.
# ------------------------------------------------------------------------------
# Change Log:
# 1.0.0 - 22/08/2024
#   - Script inicial para remover usuários não essenciais do grupo "Administradores"
#   - Implementação da verificação de usuários preservados
#   - Adição de tratamento para nomes completos de contas (ex: domínio\usuário)
# ------------------------------------------------------------------------------
# Usage:
#   Execute o script no PowerShell com permissões de administrador.
#   Modifique a lista $preserveUsers para incluir os usuários que você deseja preservar.
#
# GitHub Repository (Opcional):
#   Se houver um repositório Git onde o script está versionado, inclua o link aqui.
#
# ------------------------------------------------------------------------------
# Função: Remove usuários não preservados do grupo local "Administradores"

# Nome do grupo local de administradores
$adminGroup = "Administradores"

# Lista de usuários que devem ser preservados (insensível a maiúsculas/minúsculas)
$preserveUsers = @("Administrador", "Administrator", "Example3")

# Obtém a lista de membros do grupo local "Administradores"
$members = Get-LocalGroupMember -Group $adminGroup

foreach ($member in $members) {
    # Extrai apenas o nome do usuário (sem o prefixo do computador ou domínio)
    $memberName = $member.Name.Split("\")[-1]

    # Verifica se o membro não está na lista de preservação (comparação insensível a maiúsculas/minúsculas)
    if ($preserveUsers -notcontains $memberName) {
        Write-Host "Removendo usuário: $memberName"
        Remove-LocalGroupMember -Group $adminGroup -Member $member.Name
    } else {
        Write-Host "Usuário preservado: $memberName"
    }
}

# ------------------------------------------------------------------------------
# Notes:
# - Execute o script como administrador, pois manipulação de grupos requer privilégios elevados.
# - Certifique-se de revisar a lista de preservação regularmente, especialmente após mudanças no sistema.
# - Para contribuir com melhorias ou encontrar problemas, use o sistema de issues.
# ------------------------------------------------------------------------------
