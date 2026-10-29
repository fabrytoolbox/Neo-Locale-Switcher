# Neo-Locale-Switcher.ps1 - v2.0 (Red Pill Edition)
# Cambia layout tastiera e impostazioni regionali con stile Matrix.

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# ============================================
# AUTO-ELEVAZIONE ADMIN
# ============================================
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    [System.Windows.Forms.MessageBox]::Show("Rilancio come Amministratore per applicare le modifiche di sistema...", "Privilegi", "OK", "Information")
    
    $pwshPath = Join-Path $PSHOME "pwsh.exe"
    if (-not (Test-Path $pwshPath)) { $pwshPath = "pwsh.exe" }
    
    Start-Process $pwshPath -ArgumentList "-NoProfile -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

$script:workDir = if ($PSScriptRoot) { $PSScriptRoot } else { (Get-Location).Path }
$script:logFile = Join-Path $script:workDir "NeoLocale_$(Get-Date -Format 'yyyyMMdd_HHmmss').log"

# --- CONFIGURAZIONE STILE MATRIX ---
$MatrixGreen = [System.Drawing.Color]::FromArgb(0, 255, 70)
$DarkBg = [System.Drawing.Color]::FromArgb(10, 10, 10)
$FontMatrix = New-Object Drawing.Font("Consolas", 10, [Drawing.FontStyle]::Bold)

# ============================================
# LOGGING
# ============================================
function Write-NeoLog {
    param([string]$Message, [string]$Level = "INFO")
    $ts = Get-Date -Format "HH:mm:ss"
    $line = "[$ts] [$Level] $Message"
    if ($textLog) {
        $textLog.AppendText("`r`n$line")
        $textLog.SelectionStart = $textLog.TextLength
        $textLog.ScrollToCaret()
        [System.Windows.Forms.Application]::DoEvents()
    }
    if ($script:logFile) {
        [System.IO.File]::AppendAllText($script:logFile, "$line`r`n")
    }
}

# ============================================
# FUNZIONI DI SISTEMA
# ============================================
function Set-MyKeyboard {
    param ($LangTag)
    try {
        $list = New-WinUserLanguageList $LangTag
        Set-WinUserLanguageList $list -Force
        Write-NeoLog "Keyboard set to $LangTag" "OK"
    } catch { 
        Write-NeoLog "Failed to set Keyboard: $($_.Exception.Message)" "ERROR" 
    }
}

function Set-MyRegion {
    param ($Culture, $GeoID)
    try {
        Set-Culture $Culture
        Set-WinHomeLocation -GeoId $GeoID
        Write-NeoLog "Region set to $Culture (Geo:$GeoID)" "OK"
    } catch { 
        Write-NeoLog "Failed to set Region: $($_.Exception.Message)" "ERROR" 
    }
}

# ============================================
# INIZIO LOG
# ============================================
"--- NEO LOCALE SWITCHER LOG ---`r`n" | Set-Content -Path $script:logFile -Encoding UTF8

# ============================================
# GUI
# ============================================
$form = New-Object Windows.Forms.Form
$form.Text = "NEO - LOCALE SWITCHER"
$form.BackColor = $DarkBg
$form.Size = '440,640'
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = "FixedDialog"
$form.MaximizeBox = $false

# Logo/Header
$header = New-Object Windows.Forms.Label
$header.Text = "--- SYSTEM OVERRIDE ---"
$header.ForeColor = $MatrixGreen
$header.Font = New-Object Drawing.Font("Consolas", 14, [Drawing.FontStyle]::Bold)
$header.Location = '10,10'; $header.Size = '400,30'; $header.TextAlign = "MiddleCenter"
$form.Controls.Add($header)

# --- SEZIONE KEYBOARD LAYOUT ---
$lblKey = New-Object Windows.Forms.Label
$lblKey.Text = "> SELECT INPUT LAYOUT"
$lblKey.ForeColor = $MatrixGreen; $lblKey.Location = '20,60'; $lblKey.Size = '300,20'
$lblKey.Font = $FontMatrix
$form.Controls.Add($lblKey)

$btnKeyIT = New-Object Windows.Forms.Button
$btnKeyIT.Text = "[ KEYBOARD: IT ]"; $btnKeyIT.FlatStyle = "Flat"; $btnKeyIT.ForeColor = $MatrixGreen; $btnKeyIT.BackColor = $DarkBg
$btnKeyIT.Location = '20,90'; $btnKeyIT.Size = '185,40'; $btnKeyIT.Font = $FontMatrix
$btnKeyIT.Add_Click({ Set-MyKeyboard "it-IT" })
$form.Controls.Add($btnKeyIT)

$btnKeyEN = New-Object Windows.Forms.Button
$btnKeyEN.Text = "[ KEYBOARD: US ]"; $btnKeyEN.FlatStyle = "Flat"; $btnKeyEN.ForeColor = $MatrixGreen; $btnKeyEN.BackColor = $DarkBg
$btnKeyEN.Location = '215,90'; $btnKeyEN.Size = '185,40'; $btnKeyEN.Font = $FontMatrix
$btnKeyEN.Add_Click({ Set-MyKeyboard "en-US" })
$form.Controls.Add($btnKeyEN)

# --- SEZIONE REGION ---
$lblReg = New-Object Windows.Forms.Label
$lblReg.Text = "> SELECT REGIONAL SETTINGS"
$lblReg.ForeColor = $MatrixGreen; $lblReg.Location = '20,150'; $lblReg.Size = '300,20'
$lblReg.Font = $FontMatrix
$form.Controls.Add($lblReg)

$btnRegIT = New-Object Windows.Forms.Button
$btnRegIT.Text = "[ REGION: ITALY ]"; $btnRegIT.FlatStyle = "Flat"; $btnRegIT.ForeColor = $MatrixGreen; $btnRegIT.BackColor = $DarkBg
$btnRegIT.Location = '20,180'; $btnRegIT.Size = '185,40'; $btnRegIT.Font = $FontMatrix
$btnRegIT.Add_Click({ Set-MyRegion "it-IT" 118 })
$form.Controls.Add($btnRegIT)

$btnRegUK = New-Object Windows.Forms.Button
$btnRegUK.Text = "[ REGION: UK ]"; $btnRegUK.FlatStyle = "Flat"; $btnRegUK.ForeColor = $MatrixGreen; $btnRegUK.BackColor = $DarkBg
$btnRegUK.Location = '215,180'; $btnRegUK.Size = '185,40'; $btnRegUK.Font = $FontMatrix
$btnRegUK.Add_Click({ Set-MyRegion "en-GB" 242 })
$form.Controls.Add($btnRegUK)

# --- CONSOLE LOG ---
$textLog = New-Object Windows.Forms.TextBox
$textLog.Multiline = $true; $textLog.ReadOnly = $true; $textLog.BackColor = "Black"; $textLog.ForeColor = $MatrixGreen
$textLog.Font = $FontMatrix; $textLog.Location = '20,250'; $textLog.Size = '380,250'; $textLog.BorderStyle = "FixedSingle"
$textLog.Text = "Wake up, Neo... Choosing your reality."
$textLog.ScrollBars = "Vertical"
$form.Controls.Add($textLog)

# Footer
$footer = New-Object Windows.Forms.Label
$footer.Text = "Follow the white rabbit."
$footer.ForeColor = $MatrixGreen; $footer.Font = New-Object Drawing.Font("Consolas", 8); $footer.Location = '20,510'; $footer.Size = '380,20'; $footer.TextAlign = "MiddleCenter"
$form.Controls.Add($footer)

# Pulsante Terminate
$btnExit = New-Object Windows.Forms.Button
$btnExit.Text = "TERMINATE"
$btnExit.Location = '20,540'; $btnExit.Size = '380,30'
$btnExit.FlatStyle = "Flat"; $btnExit.ForeColor = "Red"; $btnExit.BackColor = "Black"
$btnExit.Add_Click({ $form.Close() })
$form.Controls.Add($btnExit)

# ============================================
# AVVIO
# ============================================
$form.Add_Shown({
    Write-NeoLog "Sistema pronto. Scegli la tua realta'." "INFO"
})

[void]$form.ShowDialog()