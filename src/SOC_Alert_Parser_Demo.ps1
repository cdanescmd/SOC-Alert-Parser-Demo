<#
.SYNOPSIS
    SOC Alert Parser (Demo Version)
.DESCRIPTION
    Lightweight PowerShell demo script that parses a sample alert CSV file,
    displays summary information, and generates a basic HTML report.
    For full functionality and advanced parsing features, visit FreshCMD.com.
#>

# Set file paths
$InputFile  = "../demo/sample_alerts.csv"
$OutputFile = "../demo/demo_output.html"

# Validate sample file exists
if (-not (Test-Path $InputFile)) {
    Write-Host "❌ Sample data not found. Please ensure 'sample_alerts.csv' exists in the demo folder." -ForegroundColor Red
    exit
}

# Import sample alert data
$Alerts = Import-Csv -Path $InputFile

# Simple summary stats
$TotalAlerts = $Alerts.Count
$SeverityCount = $Alerts | Group-Object -Property Severity | Select-Object Name, Count

Write-Host "=== SOC Alert Parser (Demo) ===" -ForegroundColor Cyan
Write-Host "Total Alerts:`t$TotalAlerts"
Write-Host "`nAlerts by Severity:" -ForegroundColor Yellow
$SeverityCount | ForEach-Object { Write-Host "$($_.Name): $($_.Count)" }

# Generate basic HTML report
$HtmlContent = @"
<html>
<head><title>SOC Alert Parser (Demo)</title></head>
<body style='font-family:Segoe UI;'>
<h2>SOC Alert Parser (Demo Report)</h2>
<p>Total Alerts: <b>$TotalAlerts</b></p>
<h3>Alerts by Severity</h3>
<table border='1' cellpadding='6' cellspacing='0'>
<tr><th>Severity</th><th>Count</th></tr>
"@

foreach ($s in $SeverityCount) {
    $HtmlContent += "<tr><td>$($s.Name)</td><td>$($s.Count)</td></tr>"
}

$HtmlContent += "</table></body></html>"
$HtmlContent | Out-File -FilePath $OutputFile -Encoding UTF8

Write-Host "`n✅ Demo complete. HTML report generated at: $OutputFile" -ForegroundColor Green
