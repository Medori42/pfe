# Fetch the page HTML from localhost:8080
try {
    $response = Invoke-WebRequest -Uri 'http://localhost:8080' -UseBasicParsing -TimeoutSec 10
    Write-Output "STATUS: $($response.StatusCode)"
    $content = $response.Content
    $preview = $content.Substring(0, [Math]::Min(5000, $content.Length))
    Write-Output "CONTENT (first 5000 chars):"
    Write-Output $preview
} catch {
    Write-Output "ERROR: $_"
}
