# PowerShell script to test the HTTPS server
# This script demonstrates testing the HTTPS server with different methods

Write-Host "Testing HTTPS Server on https://localhost:3443" -ForegroundColor Green
Write-Host ""

# Test 1: Using Invoke-WebRequest (PowerShell native)
Write-Host "Test 1: Using Invoke-WebRequest (bypassing certificate check)" -ForegroundColor Yellow
try {
    # For PowerShell 6+ (PowerShell Core)
    $response = Invoke-WebRequest -Uri https://localhost:3443 -SkipCertificateCheck -ErrorAction Stop
    Write-Host "Response: $($response.Content)" -ForegroundColor Green
} catch {
    # For Windows PowerShell 5.1, we need to use a workaround
    Write-Host "PowerShell 5.1 detected, using certificate bypass workaround..." -ForegroundColor Yellow
    add-type @"
        using System.Net;
        using System.Security.Cryptography.X509Certificates;
        public class TrustAllCertsPolicy : ICertificatePolicy {
            public bool CheckValidationResult(
                ServicePoint srvPoint, X509Certificate certificate,
                WebRequest request, int certificateProblem) {
                return true;
            }
        }
"@
    [System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy
    try {
        $response = Invoke-WebRequest -Uri https://localhost:3443
        Write-Host "Response: $($response.Content)" -ForegroundColor Green
    } catch {
        Write-Host "Error: $_" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "Test 2: Attempting without certificate bypass (should fail)" -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri https://localhost:3443 -ErrorAction Stop
    Write-Host "Response: $($response.Content)" -ForegroundColor Green
} catch {
    Write-Host "Expected Error (certificate validation failed): $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "This is expected behavior for self-signed certificates!" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Note: If you have curl.exe installed, you can also test with:" -ForegroundColor Cyan
Write-Host "  curl.exe -k https://localhost:3443" -ForegroundColor Cyan
Write-Host "  curl.exe https://localhost:3443  (will show certificate error)" -ForegroundColor Cyan

