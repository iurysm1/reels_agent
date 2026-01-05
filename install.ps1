# install.ps1
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

# ======= CONFIGURE AQUI =======
$RepoOwner = "iurysm1"
$RepoName  = "reels_agent"
$Branch    = "main"
$ShortcutName = "Agente IA"
# ==============================

# Pasta de instalação (por usuário, sem precisar admin)
$InstallRoot = Join-Path $env:LOCALAPPDATA "$RepoOwner\$RepoName"
$ZipUrl = "https://github.com/$RepoOwner/$RepoName/archive/refs/heads/$Branch.zip"
$TempZip = Join-Path $env:TEMP "$RepoName-$Branch.zip"
$TempExtract = Join-Path $env:TEMP "$RepoName-$Branch-extract"

function Get-PythonExe {
  # tenta py launcher primeiro (melhor no Windows)
  $py = Get-Command py -ErrorAction SilentlyContinue
  if ($py) { return "py" }

  $python = Get-Command python -ErrorAction SilentlyContinue
  if ($python) { return "python" }

  throw "Python não encontrado. Instale Python 3.10+ e tente novamente."
}

function Ensure-Dir($Path) {
  if (!(Test-Path $Path)) { New-Item -ItemType Directory -Path $Path | Out-Null }
}

Write-Host "Baixando repositório: $ZipUrl"
Write-Host "Instalando em: $InstallRoot"

# Limpa temporários
if (Test-Path $TempZip) { Remove-Item $TempZip -Force }
if (Test-Path $TempExtract) { Remove-Item $TempExtract -Recurse -Force }

# Baixa ZIP
Invoke-WebRequest -Uri $ZipUrl -OutFile $TempZip -UseBasicParsing

# Extrai
Ensure-Dir $TempExtract
Expand-Archive -Path $TempZip -DestinationPath $TempExtract -Force

# O zip do GitHub vem como: RepoName-Branch
$ExtractedFolder = Join-Path $TempExtract "$RepoName-$Branch"
if (!(Test-Path $ExtractedFolder)) {
  # fallback: pega a primeira pasta do extract
  $ExtractedFolder = (Get-ChildItem $TempExtract -Directory | Select-Object -First 1).FullName
}

# Remove instalação anterior e copia nova
if (Test-Path $InstallRoot) {
  Write-Host "Removendo instalação anterior..."
  Remove-Item $InstallRoot -Recurse -Force
}
Ensure-Dir (Split-Path -Parent $InstallRoot)
Copy-Item $ExtractedFolder $InstallRoot -Recurse -Force

# Descobre Python
$pythonCmd = Get-PythonExe

Write-Host "Criando ambiente virtual (.venv)..."
Push-Location $InstallRoot
try {
  if ($pythonCmd -eq "py") {
    & py -3 -m venv ".venv"
  } else {
    & python -m venv ".venv"
  }

  $VenvPython = Join-Path $InstallRoot ".venv\Scripts\python.exe"
  if (!(Test-Path $VenvPython)) { throw "Falha ao criar venv (não achei $VenvPython)." }

  Write-Host "Atualizando pip..."
  & $VenvPython -m pip install --upgrade pip

  $Req = Join-Path $InstallRoot "requirements_win.txt"
  if (Test-Path $Req) {
    Write-Host "Instalando dependências (requirements.txt)..."
    & $VenvPython -m pip install -r $Req
  } else {
    Write-Host "Aviso: requirements.txt não encontrado. Pulando instalação de deps."
  }

  # Copia .env.example -> .env se ainda não existir
  $EnvExample = Join-Path $InstallRoot ".env.example"
  $EnvFile = Join-Path $InstallRoot ".env"
  if ((Test-Path $EnvExample) -and !(Test-Path $EnvFile)) {
    Copy-Item $EnvExample $EnvFile
    Write-Host "Criei .env a partir de .env.example. Ajuste variáveis se necessário."
  }

  # Cria atalho na Área de Trabalho
  $Desktop = [Environment]::GetFolderPath("Desktop")
  $ShortcutPath = Join-Path $Desktop "$ShortcutName.lnk"

  $WshShell = New-Object -ComObject WScript.Shell
  $Shortcut = $WshShell.CreateShortcut($ShortcutPath)

  # Atalho chamando o run_agent.ps1
  $Shortcut.TargetPath = "$env:SystemRoot\System32\WindowsPowerShell\v1.0\powershell.exe"
  $Shortcut.Arguments = "-NoProfile -ExecutionPolicy Bypass -File `"$InstallRoot\run_agent.ps1`""
  $Shortcut.WorkingDirectory = $InstallRoot

  $IconPath = Join-Path $InstallRoot "assets\icon.ico"
  if (Test-Path $IconPath) {
    $Shortcut.IconLocation = $IconPath
  }

  $Shortcut.Save()

  Write-Host ""
  Write-Host "✅ Instalação concluída!"
  Write-Host "Atalho criado em: $ShortcutPath"
  Write-Host "Pasta instalada em: $InstallRoot"
} finally {
  Pop-Location
}

# Limpa temporários
if (Test-Path $TempZip) { Remove-Item $TempZip -Force }
if (Test-Path $TempExtract) { Remove-Item $TempExtract -Recurse -Force }