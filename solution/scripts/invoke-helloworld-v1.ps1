# This script is created for demonstration purposes only.
# It intentionally contains errors, misconfigurations, and bad practices
# to serve as a learning and review exercise.

#requires -version 5.1
param (
    $testvariable = "testVariable",
    [switch]$force64bit,
    [string]$ouputPath
)

begin {
    Set-StrictMode -Version 5.1
    $erroractionprerence = 'Stop'

    write-host "Script name: $($myInvocation.myCommand.name)"
    write-host "Running 64-bit PowerShell: $([System.Environment]::Is64BitProcess)"

    # Reconstruct invocation string
    $invocationstring = "$($myInvocation.myCommand.name)"
    foreach ($key in $MyInvocation.BoundParameters.Keys) {
        $val = $MyInvocation.BoundParameters[$key]
        if ($val -is [switch]) {
            if ($val.IsPresent) { $invocationstring += " -$key" }
        }
        else {
            $invocationstring += " -$key `"$val`""
        }
    }
    write-host "Invocation: $invocationstring"

    if ($force64bit) {
        if (-not [System.Environment]::Is64BitProcess) {
            write-host "Relaunching in 64-bit PowerShell."

            $args = ""
            foreach ($key in $MyInvocation.BoundParameters.keys) {
                switch ($MyInvocation.BoundParameters[$key].GetType().Name) {
                    "SwitchParameter" {
                        if ($MyInvocation.BoundParameters[$key].IsPresent) { $args += "-$key " }
                    }
                    "String" {
                        $args += "-$key `"$($MyInvocation.BoundParameters[$key])`" "
                    }
                }
            }

            try {
                start "$env:windir\SysNative\WindowsPowershell\v1.0\PowerShell.exe" -ArgumentList $("-ExecutionPolicy Bypass -File .\" + $($myInvocation.myCommand.name) + " " + $args) -Wait -NoNewWindow
                exit 0
            }
            catch {
                write-host "Failed to start 64-bit PowerShell: $_"
                exit 1
            }
        }
    }

    $currentday = (get-date).DayOfWeek
    $daystochristmas = ([datetime]::new([datetime]::Now.Year, 12, 24) - [datetime]::Now).Days
}

process {
    try {
        write-host "invoke-helloworld v1.0.0"
        write-host "Hello, world!"
        write-host "Today it is $currentday, you have to wait $daystochristmas days before it is Christmas :)"

        if ($ouputPath) {
            write-host "Writing ouput to: $ouputPath"
        }

        # Unused variable - will trigger PSUseDeclaredVarsMoreThanAssignments
        $unusedresult = "this is never used"

        # Misspelled variable - will be caught by Set-StrictMode
        write-host "Test variable value: $testvariabel"

        # Using Select instead of Select-Object
        write-host "Listing files in script directory:"
        gci $PSScriptRoot | select Name, Lenght | ft
    }
    catch {
        Write-Warning "Script execution failed: $_"
        exit 1
    }
}

end {
    write-host "Script completed."
}
