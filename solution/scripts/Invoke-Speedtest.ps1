<#
.SYNOPSIS
    Performs a network speed test by downloading a file from a public URL.

.DESCRIPTION
    Invoke-Speedtest measures network download speed by repeatedly downloading a file
    from a specified URI and calculating the average throughput in Mbit/sec.

.PARAMETER TestCount
    Number of speed test iterations to perform. Must be between 1 and 100.
    Default is 5.

.PARAMETER TestFileUri
    URI of the file to download for the speed test. Accepts pipeline input.
    Default is a zip archive from the hello-world GitHub repository.

.EXAMPLE
    .\Invoke-Speedtest.ps1

    Runs 5 speed test iterations using the default test file URI.

.EXAMPLE
    .\Invoke-Speedtest.ps1 -TestCount 10

    Runs 10 speed test iterations using the default test file URI.

.EXAMPLE
    .\Invoke-Speedtest.ps1 -TestCount 3 -TestFileUri "https://example.com/testfile.zip"

    Runs 3 speed test iterations using a custom test file URI.

.NOTES
    Version: 1.0.0
    Author: Jesper Nielsen (@dotjesper)
    Release notes: Initial release
#>
#requires -version 5.1
[CmdletBinding(SupportsShouldProcess)]
param (
    [Parameter(Mandatory = $false, Position = 0, HelpMessage = "Number of speed test iterations to perform.")]
    [ValidateRange(1, 100)]
    [int]$TestCount = 5,

    [Parameter(Mandatory = $false, Position = 1, ValueFromPipeline, ValueFromPipelineByPropertyName, HelpMessage = "URI of the file to download for the speed test.")]
    [ValidateNotNullOrEmpty()]
    [string]$TestFileUri = "https://api.github.com/repos/dotjesper/hello-world/solutions/artifacts/assets/images.zip?archive_format=zip"
)
#region :: begin
begin {
    #region :: Environment configurations
    [version]$ScriptVersion = '1.0.0'
    Set-Variable -Name 'ScriptVersion' -Value $ScriptVersion -Option ReadOnly -Scope Script
    [double]$totalSpeedMbps = 0
    #endregion

    #region :: functions
    function Measure-NetworkSpeed {
        param (
            [Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName, HelpMessage = "URI of the file to download for the speed measurement.")]
            [string]$TestFileUri
        )
        try {
            # Create a temporary file path for the downloaded test file
            $tempFile = Join-Path -Path $env:TEMP -ChildPath "speedtest.tmp"

            # Measure the time taken to download the test file using Invoke-WebRequest
            # -UseBasicParsing avoids HTML DOM parsing, preventing security warnings and removing the dependency on Internet Explorer's engine
            $elapsedSeconds = Measure-Command { Invoke-WebRequest -Uri $TestFileUri -OutFile $tempFile -UseBasicParsing } | Select-Object -ExpandProperty TotalSeconds

            # Get the size of the downloaded file in bytes
            $fileSizeBytes = (Get-Item -Path $tempFile).Length

            # Calculate the download speed in Mbit/sec (file size in bits divided by elapsed time in seconds)
            $speedMbps = ($fileSizeBytes / $elapsedSeconds) * 8 / 1MB

            return $speedMbps
        }
        catch {
            Write-Warning -Message "Failed to measure network speed: $_"
            return 0
        }
    }
    #endregion
}
#endregion

#region :: process
process {
    try {
        # Output initial information about the speed test, including public IP and test file URI
        Write-Output -InputObject "Invoke Speedtest v$ScriptVersion"

        # Retrieve public IP address using -UseBasicParsing to avoid HTML DOM parsing and security warnings
        Write-Output -InputObject "Public IP: $((Invoke-WebRequest -Uri "https://ifconfig.me/ip" -UseBasicParsing).Content)"
        Write-Output -InputObject "Test file: $TestFileUri"

        # Validate the test file URI is reachable before starting iterations
        # -UseBasicParsing is used on all Invoke-WebRequest calls to prevent script execution from parsed HTML content
        try {
            Invoke-WebRequest -Uri $TestFileUri -Method Head -UseBasicParsing -ErrorAction Stop | Out-Null
        }
        catch {
            Write-Warning -Message "Test file URI is not reachable: $TestFileUri"
            Write-Warning -Message "Speedtest failed."
            exit 1
        }

        # Loop through the specified number of test iterations and accumulate total speed in Mbit/sec
        for ($testIteration = 0; $testIteration -lt $TestCount; $testIteration++) {

            # Update progress bar with current iteration and percentage complete
            $percentComplete = [math]::Round(($testIteration / $TestCount) * 100)
            Write-Progress -Activity "Invoke Speedtest" -Status "Iteration $($testIteration + 1) of $TestCount" -PercentComplete $percentComplete

            # Output the current iteration number and total iterations for better visibility during the speed test process
            Write-Verbose -Message "Test iteration: $($testIteration + 1) of $TestCount"

            # Measure the network speed for the current iteration and accumulate the total speed in Mbit/sec
            $totalSpeedMbps = $totalSpeedMbps + (Measure-NetworkSpeed -TestFileUri $TestFileUri)
        }

        # Complete the progress bar
        Write-Progress -Activity "Invoke Speedtest" -Completed

        # Output average speed in Mbit/sec
        Write-Output -InputObject ("Average speed: {0:N2} Mbit/sec (based on {1} iterations)" -f ($totalSpeedMbps / $TestCount), $TestCount)
    }
    catch {
        Write-Warning -Message "Speedtest failed: $_"
        exit 1
    }
}
#endregion

#region :: end
end {
    Write-Output -InputObject "Speedtest completed."
}
#endregion
