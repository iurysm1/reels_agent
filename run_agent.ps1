# run_agent.ps1
$ErrorActionPreference = "Stop"

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$venvPython = Join-Path $here ".venv\Scripts\python.exe"
$runPy = Join-Path $here "run.py"

if (!(Test-Path $venvPython)) {
  Write-Host "Ambiente virtual não encontrado: $venvPython"
  Write-Host "Rode o install.ps1 primeiro."
  Pause
  exit 1
}

if (!(Test-Path $runPy)) {
  Write-Host "Não achei o run.py em: $runPy"
  Pause
  exit 1
}

# (Opcional) Se você quiser garantir um cwd fixo:
Push-Location $here
try {
  & $venvPython $runPy
} finally {
  Pop-Location
}
