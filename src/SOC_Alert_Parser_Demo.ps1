function Start-Parser {
    $CsvPath = "../demo/sample_alerts.csv"
    $TemplatePath = "../demo/template.html"
    $OutputPath = "../demo/demo_output.html"

    $alerts = Import-Csv -Path $CsvPath

    $dataRows = ($alerts | ForEach-Object {
        "<tr><td>$($_.TimeGenerated)</td><td>$($_.Source)</td><td>$($_.Severity)</td><td>$($_.Category)</td><td>$($_.Description)</td></tr>"
    }) -join "`n"

    $totalAlerts = $alerts.Count
    $timestamp = Get-Date -Format "MM/dd/yyyy HH:mm:ss"

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

    $template = Get-Content $TemplatePath -Raw

    $finalHtml = $template `
        -replace "DATA_ROWS_PLACEHOLDER", $dataRows `
        -replace "TOTAL_ALERTS_PLACEHOLDER", $totalAlerts `
        -replace "HIGH_COUNT_PLACEHOLDER", $severityCounts["High"] `
        -replace "MEDIUM_COUNT_PLACEHOLDER", $severityCounts["Medium"] `
        -replace "LOW_COUNT_PLACEHOLDER", $severityCounts["Low"] `
        -replace "REPORT_TIMESTAMP_PLACEHOLDER", $timestamp `
        -replace "CHART_DATA_PLACEHOLDER", $chartData

    $finalHtml | Out-File -FilePath $OutputPath -Encoding UTF8

    Write-Host "`n✅ Report generated at: $OutputPath" -ForegroundColor Green
    Write-Host "📂 Opening report in browser..." -ForegroundColor Cyan
    Start-Sleep -Seconds 1
    Invoke-Expression "open '$OutputPath'"
}

while ($true) {
    Clear-Host
    Write-Host ""
    Write-Host "=============================================" -ForegroundColor Cyan
    Write-Host "🔍 SOC Alert Parser Demo" -ForegroundColor Green
    Write-Host "🕒 $(Get-Date -Format 'MM/dd/yyyy hh:mm tt')" -ForegroundColor DarkGray
    Write-Host "=============================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Welcome! This tool parses sample alerts and generates a visual HTML report."
    Write-Host ""
    Write-Host "Choose an option:"
    Write-Host "1. Run parser and generate report"
    Write-Host "2. View first 10 sample alerts"
    Write-Host "3. Exit"
    Write-Host ""

    $choice = Read-Host "Enter your choice (1-3)"

    switch ($choice) {
       "1" {
    Write-Host "`nStarting parser..." -ForegroundColor Yellow
    Start-Sleep -Milliseconds 600
    Write-Host "📂 Loading alerts..."
    Start-Sleep -Milliseconds 600
    Write-Host "🧠 Analyzing severity levels..."
    Start-Sleep -Milliseconds 600
    Write-Host "🧾 Generating HTML report..."
    Start-Sleep -Milliseconds 600
    Start-Parser
    Write-Host "`nPress Enter to return to menu..."
    Read-Host
}

      "2" {
    Write-Host "`nPreviewing first 10 alerts:`n" -ForegroundColor Yellow
    Start-Sleep -Milliseconds 500
    $preview = Import-Csv -Path "../demo/sample_alerts.csv" | Select-Object -First 10 | Format-Table -AutoSize | Out-String
    Write-Host $preview
    Start-Sleep -Milliseconds 300
    Write-Host "`nPress Enter to return to menu..."
    Read-Host
}


       "3" {
    Write-Host "`nExiting demo. Goodbye!" -ForegroundColor Red
    Start-Sleep -Milliseconds 800
    [Environment]::Exit(0)
}

        default {
            Write-Host "`nInvalid choice. Please try again." -ForegroundColor Red
            Start-Sleep -Seconds 1
        }
    }
}
