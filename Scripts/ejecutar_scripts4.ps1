# Ruta de los scripts Python
$transferScript = "C:\Mondayapp\facturasdc\transfer4.py"
$syncScript = "C:\Mondayapp\facturasdc\sync_script4.py"
$logFile = "C:\Logs\facturasdc.log"
$transferOut = "C:\Logs\transferfdc_salida.log"
$transferErr = "C:\Logs\transferfdc_error.log"
$syncOut = "C:\Logs\syncfdc_salida.log"
$syncErr = "C:\Logs\syncfdc_error.log"

# Ruta completa a python.exe (ajusta si usas entorno virtual)
$pythonPath = "python.exe"

# Funcion para escribir logs
function Write-Log {
    param ([string]$message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "$timestamp - $message" | Out-File -FilePath $logFile -Append
    Write-Host "$timestamp - $message"
}

# Iniciar registro
Write-Log "==== Inicio de la ejecucion automatica ===="

# 1. Ejecutar transfer4.py
try {
    Write-Log "Ejecutando transfer4.py..."
    $transferProcess = Start-Process -FilePath $pythonPath `
        -ArgumentList $transferScript `
        -RedirectStandardOutput $transferOut `
        -RedirectStandardError $transferErr `
        -Wait -PassThru -NoNewWindow

    if ($transferProcess.ExitCode -eq 0) {
        Write-Log "transfer4.py se ejecuto correctamente (ExitCode: 0)."
    } else {
        Write-Log "ERROR: transfer4.py fallo (ExitCode: $($transferProcess.ExitCode))."
        exit 1
    }
} catch {
    Write-Log "ERROR al ejecutar transfer4.py: $_"
    exit 1
}

# 2. Esperar 60 segundos antes de ejecutar sync_script4.py
Write-Log "Esperando 60 segundos antes de ejecutar sync_script4.py..."
Start-Sleep -Seconds 60

# 3. Ejecutar sync_script4.py
try {
    Write-Log "Ejecutando sync_script4.py..."
    $syncProcess = Start-Process -FilePath $pythonPath `
        -ArgumentList $syncScript `
        -RedirectStandardOutput $syncOut `
        -RedirectStandardError $syncErr `
        -Wait -PassThru -NoNewWindow

    if ($syncProcess.ExitCode -eq 0) {
        Write-Log "sync_script4.py se ejecuto correctamente (ExitCode: 0)."
    } else {
        Write-Log "ERROR: sync_script4.py fallo (ExitCode: $($syncProcess.ExitCode))."
        exit 1
    }
} catch {
    Write-Log "ERROR al ejecutar sync_script4.py: $_"
    exit 1
}

Write-Log "==== Ejecucion completada ===="
