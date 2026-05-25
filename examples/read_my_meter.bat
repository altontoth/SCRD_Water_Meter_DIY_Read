@echo off
REM Set the desired water meter ID and output file
set "METER_ID=12345678"
set "OUTPUT_FILE=my_meter_readings.csv"

REM Add a header to the CSV file if it doesn't already exist
if not exist "%OUTPUT_FILE%" echo Timestamp,ID,Consumption > "%OUTPUT_FILE%"

REM Start rtl_433 and process data for the specified Neptune-R900 ID
echo Starting rtl_433 for %DURATION% seconds...
rtl_433 -f 915000000 -R 228 -F http -F json | powershell -Command ^
    "foreach ($line in $input) { $json = $line | ConvertFrom-Json; if ($json.id -eq %METER_ID%) { Add-Content -Path '%OUTPUT_FILE%' -Value ([string]::Format('{0},{1},{2}', (Get-Date -Format 'yyyy-MM-dd HH:mm:ss'), $json.id, $json.consumption)) } }"
