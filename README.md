# SCRD Water Meter DIY Read

Read Sunshine Coast Regional District Neptune R900 water meters using a low-cost Software Defined Radio (SDR) receiver and the open-source rtl_433 software package.

This project provides step-by-step instructions for residents who wish to monitor their own water consumption using publicly transmitted radio telemetry.

![Project Banner](docs/assets/banner.png)

## Overview

This guide documents a working method for receiving Neptune R900 water meter broadcasts using:

* NooElec NESDR Mini SDR
* rtl_433
* Windows 64-bit

In testing, the stock antenna was able to receive approximately five nearby water meters from inside a home, suggesting a practical reception radius of roughly 50 metres.

## Hardware Required

### SDR Receiver

NooElec NESDR Mini SDR

[https://www.amazon.ca/NooElec-NESDR-Mini-Compatible-Packages/dp/B009U7WZCA/](https://amzn.to/4dQuXSq) **Affiliate Link**

![SDR Receiver Screenshot](docs/screenshots/sdr-receiver.png)

## Software Required

### rtl_433

This guide uses the rtl_433 fork maintained at:

https://github.com/altontoth/rtl_433

Download the Windows x64 release or build from source.

## SDR Driver Installation

1. Plug in the SDR.
2. Download and run [Zadig](https://zadig.akeo.ie/).
3. Select **Options → List All Devices**.
4. Select the **RTL2832U device**.
5. Confirm the device shows as **RTL2838UHIDIR or Bulk-In Interface 0**.
6. Install the **WinUSB driver**.
7. Wait for installation to complete.
8. Disconnect and reconnect the SDR.

![Driver Installation Screenshot](docs/screenshots/sdr-install-zadig.png)

## Identifying Your Meter

Open the meter box lid and locate the Neptune meter ID.

Record the number exactly as shown.

![Meter ID Location Example](docs/screenshots/meter-id-location.png)

## Reading All Meters Within Range

Open Command Prompt:

```cmd
cd C:\rtl_433-win
rtl_433 -f 915000000 -R 228 -F http -F csv:readings.csv
```

This command:

* Tunes to 915 MHz
* Enables Neptune protocol 228
* Saves readings to CSV
* Launches a local web interface

## Viewing Live Data

While rtl_433 is running:

http://localhost:8433/

![Live View Example](docs/screenshots/rtl433-live-view.png)

## Saving Data to Excel

The command above creates:

```text
readings.csv
```

Open the file directly in Excel.

![Excel Output Example](docs/screenshots/excel-output.png)

## Reading Only Your Meter

Use the included batch file:

```bat
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
```

Replace the meter ID with your own.

## Understanding Neptune R900 Broadcasts

Neptune R900 endpoints periodically transmit meter readings over the 915 MHz ISM band.

rtl_433 includes support for Neptune devices through Protocol 228.

The software decodes broadcasts and reports:

* Meter ID
* Consumption reading
* Signal information
* Timestamp

## Range Observations

Observed performance with the stock antenna:

* Approximately 5 meters received indoors
* Roughly 50 metre radius
* No antenna upgrades tested yet

Performance will vary based on:

* Terrain
* Building materials
* Antenna placement
* Radio interference

## Troubleshooting

### No Data Received

Verify:

* SDR drivers installed correctly
* SDR connected
* Protocol 228 enabled
* Frequency set to 915 MHz

### Web Interface Not Loading

Ensure rtl_433 is currently running.

### CSV Not Appearing

Verify rtl_433 is being launched from the intended folder.

## Disclaimer

This project is not affiliated with the Sunshine Coast Regional District, Neptune Technology Group, rtl_433, or NooElec.

The author provides these instructions for educational purposes only.

Users are responsible for complying with all applicable laws and regulations. Only access and monitor water meter data that you are authorized to access.
