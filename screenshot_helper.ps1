Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$outputDir = 'C:\Users\B.Medori\.gemini\antigravity\brain\74cd3432-ab38-4c94-a8a1-81b0dcc0e8d8'

if (!(Test-Path $outputDir)) {
    New-Item -ItemType Directory -Path $outputDir -Force | Out-Null
}

# Open the URL in the default browser
Start-Process "http://localhost:8080"

# Wait for browser to load
Start-Sleep -Seconds 5

# Take screenshot of entire screen
$screen = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds
$bitmap = New-Object System.Drawing.Bitmap($screen.Width, $screen.Height)
$graphics = [System.Drawing.Graphics]::FromImage($bitmap)
$graphics.CopyFromScreen($screen.Location, [System.Drawing.Point]::Empty, $screen.Size)

$layoutPath = Join-Path $outputDir 'layout_screenshot.png'
$loginPath  = Join-Path $outputDir 'login_screenshot_new.png'

$bitmap.Save($layoutPath, [System.Drawing.Imaging.ImageFormat]::Png)
$bitmap.Save($loginPath, [System.Drawing.Imaging.ImageFormat]::Png)

$graphics.Dispose()
$bitmap.Dispose()

Write-Output "Screenshots saved:"
Write-Output "  $layoutPath"
Write-Output "  $loginPath"
