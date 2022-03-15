<#PSScriptInfo
.VERSION 0.1.1.0
.GUID 8F0E1A6A-A24A-4344-8709-D68AB7A7F456
.AUTHOR @dotjesper
.COMPANYNAME dotjesper.com
.COPYRIGHT dotjesper.com
.TAGS powershell
.LICENSEURI https://github.com/dotjesper/hello-world/blob/master/LICENSE
.PROJECTURI https://github.com/dotjesper/hello-world/
.ICONURI
.EXTERNALMODULEDEPENDENCIES
.REQUIREDSCRIPTS
.EXTERNALSCRIPTDEPENDENCIES
.RELEASENOTES https://github.com/dotjesper/hello-world/wiki/release-notes
#>
<#
.SYNOPSIS
    Hello World demonstration script.
.DESCRIPTION
    Hello World demonstration script.
.PARAMETER runSilent
    Hide download progress bar. Default is $true.
.EXAMPLE
    .\hello-world.ps1
.EXAMPLE
    .\hello-world.ps1 -Verbose
#>
#requires -version 5.1
[CmdletBinding()]
param (
    [bool]$runSilent = $true
)
begin {
     #region :: functions
    function fDownloadFilesFromRepo {
        param (
            [string]$Owner,
            [string]$Repository,
            [string]$Path,
            [string]$DestinationPath
        )
        begin {
            #Add GitHub token
            $token = "<token>"
            $headers = @{Authorization = "token $($token)"}

        }
        process {
            $baseUri = "https://api.github.com/"
            $reposargs = "repos/$Owner/$Repository/contents/$Path"
            $wr = Invoke-WebRequest -Headers $headers -Uri $($baseuri + $reposargs) -UseBasicParsing
            $objects = $wr.Content | ConvertFrom-Json
            $files = $objects | Where-Object {$_.type -eq "file"} | Select-Object -ExpandProperty download_url
            $directories = $objects | Where-Object {$_.type -eq "dir"}
            
            $directories | ForEach-Object { 
                fDownloadFilesFromRepo -Owner $Owner -Repository $Repository -Path $_.path -DestinationPath "$($DestinationPath)\$($_.name)"
            }
            
            if (-not (Test-Path $DestinationPath)) {
                # If destination path does not exist, create it...
                try {
                    New-Item -Path $DestinationPath -ItemType Directory -ErrorAction Stop | Out-Null
                } catch {
                    throw "Error creating path ""$DestinationPath""."
                }
            }
        
            foreach ($file in $files) {
                $fileDestination = Join-Path $DestinationPath (Split-Path $file -Leaf)
                try {
                    Invoke-WebRequest -Headers $headers -Uri $file -OutFile $fileDestination -UseBasicParsing -ErrorAction Stop
                    Write-Verbose -Message "Downloading ""$($file)"" to ""$fileDestination""."
                } catch {
                    throw "Error downloading ""$($file.path)""."
                }
            }
        }
        end {}
    }
    #endregion
    #
    #region :: run conditions
    #Hide download progress bar
    $envProgressPreference = $progressPreference
    if ($runSilent) {
        $ProgressPreference = "SilentlyContinue"
    }
    #endregion
}
process {
    Write-Verbose -Message "Processing repository $Owner/$Repository/$Path"
    fDownloadFilesFromRepo -Owner "dotjesper" -Repository "hello-world" -Path "sample-content" -DestinationPath ".\sample-content"
}
end {
    $ProgressPreference = $envProgressPreference
}


