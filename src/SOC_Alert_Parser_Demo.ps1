# Paths (relative to /src/)
$CsvPath = "../demo/sample_alerts.csv"
$TemplatePath = "../demo/template.html"
$OutputPath = "../demo/demo_output.html"

# Load alerts
$alerts = Import-Csv -Path $CsvPath

# Build HTML table rows
$dataRows = ($alerts | ForEach-Object {
    "<tr><td>$($_.TimeGenerated)</td><td>$($_.Source)</td><td>$($_.Severity)</td><td>$($_.Category)</td><td>$($_.Description)</td></tr>"
}) -join "`n"

# Count total alerts
$totalAlerts = $alerts.Count

# Generate timestamp
$timestamp = Get-Date -Format "MM/dd/yyyy HH:mm:ss"

# Count severities
$severityCounts = @{
    "Critical" = 0
    "High"     = 0
    "Medium"   = 0
    "Low"      = 0
}
foreach ($alert in $alerts) {
    $severity = $alert.Severity
    if ($severityCounts.ContainsKey($severity)) {
        $severityCounts[$severity]++
    }
}
$chartData = "$($severityCounts["Critical"]), $($severityCounts["High"]), $($severityCounts["Medium"]), $($severityCounts["Low"])"

# Load template
$template = Get-Content $TemplatePath -Raw

# Replace placeholders
$finalHtml = $template `
    -replace "DATA_ROWS_PLACEHOLDER", $dataRows `
    -replace "TOTAL_ALERTS_PLACEHOLDER", $totalAlerts `
    -replace "HIGH_COUNT_PLACEHOLDER", $severityCounts["High"] `
    -replace "MEDIUM_COUNT_PLACEHOLDER", $severityCounts["Medium"] `
    -replace "LOW_COUNT_PLACEHOLDER", $severityCounts["Low"] `
    -replace "REPORT_TIMESTAMP_PLACEHOLDER", $timestamp `
    -replace "CHART_DATA_PLACEHOLDER", $chartData

# Output final HTML
$finalHtml | Out-File -FilePath $OutputPath -Encoding UTF8

Write-Host "✅ Demo complete. Enhanced HTML report generated at: $OutputPath"
