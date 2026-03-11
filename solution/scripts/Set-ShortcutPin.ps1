<#
.SYNOPSIS
    Attempts to pin or unpin a shortcut or app to the Windows taskbar or Start Menu
    using shell verbs.

.DESCRIPTION
    Set-ShortcutPin uses the Shell.Application COM object to discover and invoke
    pin-related shell verbs on shortcut files (.lnk) or installed applications.

    The script supports two modes of operation:
    - Shortcut mode: Provide a path to a .lnk shortcut file using -ShortcutPath.
    - App mode: Provide an application display name using -AppName to search the
      shell:AppsFolder virtual folder, which contains all installed applications
      including modern/UWP apps (e.g., "Get Started", "Microsoft 365 Copilot").

    Use the -ListApps parameter to discover all installed applications and their
    display names before attempting a pin operation.

    Windows 11 compatibility: Microsoft has restricted programmatic pinning
    through shell verbs on Windows 11. Taskbar pinning verbs have been removed
    entirely. Start Menu pin and unpin verbs are still present, but Windows may
    block the operation with an access denied error for some apps when invoked
    from a script context rather than the interactive shell UI. Use the -ListVerbs
    parameter to check which verbs are available on your system.

    For enterprise and managed deployments, consider using Start Menu and Taskbar
    layout policies through Microsoft Intune or provisioning packages instead.

.PARAMETER ShortcutPath
    The full path to the shortcut (.lnk) file to pin. Cannot be combined with
    -AppName or -ListApps.

.PARAMETER AppName
    The display name of an installed application to pin. Searches the shell:AppsFolder
    virtual folder which includes both classic and modern/UWP apps. Supports wildcard
    matching. Cannot be combined with -ShortcutPath or -ListApps.

.PARAMETER Target
    Specifies the pin target location. Valid values are StartMenu, Taskbar, or Both.
    Default is StartMenu.

.PARAMETER Pin
    Pins the shortcut or app to the target location. This is the default action
    when neither -Pin nor -Unpin is specified.

.PARAMETER Unpin
    Unpins the shortcut or app from the target location instead of pinning it.

.PARAMETER ListVerbs
    Lists all available shell verbs for the shortcut or app without performing any
    pin operation. Useful for diagnosing which pin verbs are available on your
    Windows version.

.PARAMETER ListApps
    Lists all installed applications from the shell:AppsFolder virtual folder.
    Useful for discovering the exact display name to use with the -AppName parameter.
    Cannot be combined with -ShortcutPath or -AppName.

.EXAMPLE
    .\Set-ShortcutPin.ps1 -ShortcutPath "C:\Users\Public\Desktop\MyApp.lnk"

    Attempts to pin the shortcut to the Start Menu.

.EXAMPLE
    .\Set-ShortcutPin.ps1 -ShortcutPath "C:\Users\Public\Desktop\MyApp.lnk" -Target Taskbar -Pin

    Pins the shortcut to the taskbar.

.EXAMPLE
    .\Set-ShortcutPin.ps1 -ShortcutPath "C:\Users\Public\Desktop\MyApp.lnk" -Target Both -Pin -Verbose

    Pins the shortcut to both the Start Menu and taskbar with verbose output.

.EXAMPLE
    .\Set-ShortcutPin.ps1 -ShortcutPath "C:\Users\Public\Desktop\MyApp.lnk" -ListVerbs

    Lists all available shell verbs for the shortcut.

.EXAMPLE
    .\Set-ShortcutPin.ps1 -ShortcutPath "C:\Users\Public\Desktop\MyApp.lnk" -Target Taskbar -Unpin

    Unpins the shortcut from the taskbar.

.EXAMPLE
    .\Set-ShortcutPin.ps1 -AppName "Get Started" -Target StartMenu -Pin

    Pins the Get Started app to the Start Menu.

.EXAMPLE
    .\Set-ShortcutPin.ps1 -AppName "Microsoft 365 Copilot" -ListVerbs

    Lists all available shell verbs for the Microsoft 365 Copilot app.

.EXAMPLE
    .\Set-ShortcutPin.ps1 -AppName "Microsoft*" -ListVerbs

    Lists verbs for all apps matching the wildcard pattern "Microsoft*".

.EXAMPLE
    .\Set-ShortcutPin.ps1 -ListApps

    Lists all installed applications from the shell:AppsFolder.

.NOTES
    Version: 1.1.0
    Author: Jesper Nielsen (@dotjesper)
    Release notes: Added -AppName parameter for modern/UWP app support and -ListApps for app discovery
#>
#requires -version 5.1
[CmdletBinding(SupportsShouldProcess, DefaultParameterSetName = "Shortcut")]
param (
    [Parameter(Mandatory, Position = 0, ParameterSetName = "Shortcut", HelpMessage = "The full path to the shortcut (.lnk) file to pin.")]
    [Alias("Path")]
    [ValidateNotNullOrEmpty()]
    [string]$ShortcutPath,

    [Parameter(Mandatory, Position = 0, ParameterSetName = "App", HelpMessage = "The display name of an installed application to pin. Supports wildcards.")]
    [ValidateNotNullOrEmpty()]
    [string]$AppName,

    [Parameter(Mandatory = $false, ParameterSetName = "Shortcut", HelpMessage = "Specifies the pin target location: StartMenu, Taskbar, or Both.")]
    [Parameter(Mandatory = $false, ParameterSetName = "App", HelpMessage = "Specifies the pin target location: StartMenu, Taskbar, or Both.")]
    [Alias("T")]
    [ValidateSet("StartMenu", "Taskbar", "Both")]
    [string]$Target = "StartMenu",

    [Parameter(Mandatory = $false, ParameterSetName = "Shortcut", HelpMessage = "Pins the shortcut to the target location.")]
    [Parameter(Mandatory = $false, ParameterSetName = "App", HelpMessage = "Pins the app to the target location.")]
    [Alias("P")]
    [switch]$Pin,

    [Parameter(Mandatory = $false, ParameterSetName = "Shortcut", HelpMessage = "Unpins the shortcut from the target location.")]
    [Parameter(Mandatory = $false, ParameterSetName = "App", HelpMessage = "Unpins the app from the target location.")]
    [Alias("U")]
    [switch]$Unpin,

    [Parameter(Mandatory = $false, ParameterSetName = "Shortcut", HelpMessage = "Lists all available shell verbs for the shortcut.")]
    [Parameter(Mandatory = $false, ParameterSetName = "App", HelpMessage = "Lists all available shell verbs for the app.")]
    [switch]$ListVerbs,

    [Parameter(Mandatory, ParameterSetName = "ListApps", HelpMessage = "Lists all installed applications from the shell:AppsFolder.")]
    [switch]$ListApps
)
#region :: begin
begin {
    #region :: Environment configurations
    [version]$ScriptVersion = '1.1.0'
    Set-Variable -Name 'ScriptVersion' -Value $ScriptVersion -Option ReadOnly -Scope Script
    #endregion

    #region :: Invocation details
    Write-Verbose -Message "Script name: $($myInvocation.myCommand.name)"
    Write-Verbose -Message "Script version: $ScriptVersion"
    Write-Verbose -Message "Windows version: $([System.Environment]::OSVersion.VersionString)"
    Write-Verbose -Message "Windows build: $(([System.Environment]::OSVersion.Version).Build)"
    #endregion

    #region :: Validate shortcut path (Shortcut parameter set only)
    if ($PSCmdlet.ParameterSetName -eq "Shortcut") {
        if (-not (Test-Path -Path $ShortcutPath)) {
            Write-Warning -Message "Shortcut not found: $ShortcutPath"
            exit 1
        }
        $resolvedPath = (Resolve-Path -Path $ShortcutPath).Path
        if ([System.IO.Path]::GetExtension($resolvedPath) -ne '.lnk') {
            Write-Warning -Message "File is not a shortcut (.lnk): $resolvedPath"
            exit 1
        }
        Write-Verbose -Message "Shortcut path: $resolvedPath"
    }
    #endregion

    #region :: Shell verb patterns for pin operations
    # Verb names vary by Windows version and locale; matching by key substrings
    if ($Unpin) {
        $startMenuVerbPatterns = @('unpin from start', 'unpinfromstart', 'Unpin from &Start')
        $taskbarVerbPatterns = @('unpin from tas', 'unpinfromtaskbar', 'Unpin from tas&kbar')
    }
    else {
        $startMenuVerbPatterns = @('pin to start', 'pintostartscreen', 'Pin to &Start')
        $taskbarVerbPatterns = @('pin to tas', 'pintotaskbar', 'Pin to tas&kbar')
    }
    # Default to pin when neither -Pin nor -Unpin is specified
    if (-not $Pin -and -not $Unpin) {
        $Pin = [switch]::new($true)
    }
    if ($Pin -and $Unpin) {
        Write-Warning -Message "Cannot specify both -Pin and -Unpin. Use one or the other."
        exit 1
    }
    $actionLabel = if ($Unpin) { "Unpin" } else { "Pin" }
    #endregion

    #region :: functions
    function Find-ShellVerb {
        param (
            [Parameter(Mandatory, Position = 0, HelpMessage = "The collection of shell verbs to search.")]
            [object]$Verbs,

            [Parameter(Mandatory, Position = 1, HelpMessage = "An array of substring patterns to match against verb names.")]
            [string[]]$Patterns
        )
        foreach ($verb in $Verbs) {
            foreach ($pattern in $Patterns) {
                if ($verb.Name -and $verb.Name -like "*$pattern*") {
                    return $verb
                }
            }
        }
        return $null
    }
    #endregion
}
#endregion

#region :: process
process {
    try {
        Write-Output -InputObject "Set-ShortcutPin v$ScriptVersion"

        # Create Shell.Application COM object used by all parameter sets
        $shell = New-Object -ComObject Shell.Application

        #region :: ListApps mode - enumerate all installed applications
        if ($PSCmdlet.ParameterSetName -eq "ListApps") {
            Write-Output -InputObject "Installed applications from shell:AppsFolder:"
            Write-Output -InputObject ("-" * 60)

            # Access the shell:AppsFolder virtual folder containing all installed apps
            $appsFolder = $shell.Namespace("shell:AppsFolder")
            $appNames = @()
            foreach ($app in $appsFolder.Items()) {
                $appNames += $app.Name
            }
            $appNames | Sort-Object | ForEach-Object {
                Write-Output -InputObject "  $_"
            }
            $appCount = $appNames.Count

            Write-Output -InputObject ("-" * 60)
            Write-Output -InputObject "Total apps: $appCount"
            return
        }
        #endregion

        #region :: Resolve the target shell item based on parameter set
        $item = $null
        $itemDisplayName = $null

        if ($PSCmdlet.ParameterSetName -eq "Shortcut") {
            # Display shortcut details using WScript.Shell COM object
            $wshShell = New-Object -ComObject WScript.Shell
            $shortcut = $wshShell.CreateShortcut($resolvedPath)
            Write-Verbose -Message "Target: $($shortcut.TargetPath)"
            Write-Verbose -Message "Arguments: $($shortcut.Arguments)"
            Write-Verbose -Message "Working directory: $($shortcut.WorkingDirectory)"
            Write-Verbose -Message "Description: $($shortcut.Description)"
            [System.Runtime.InteropServices.Marshal]::ReleaseComObject($wshShell) | Out-Null

            # Access the shortcut file through Shell.Application
            $folderPath = Split-Path -Path $resolvedPath -Parent
            $fileName = Split-Path -Path $resolvedPath -Leaf
            $folder = $shell.Namespace($folderPath)
            $item = $folder.ParseName($fileName)
            $itemDisplayName = $fileName
        }
        elseif ($PSCmdlet.ParameterSetName -eq "App") {
            # Search shell:AppsFolder for the application by display name
            Write-Verbose -Message "Searching shell:AppsFolder for app: $AppName"
            $appsFolder = $shell.Namespace("shell:AppsFolder")
            $matchingApps = @()

            foreach ($app in $appsFolder.Items()) {
                if ($app.Name -like $AppName) {
                    $matchingApps += $app
                }
            }

            if ($matchingApps.Count -eq 0) {
                Write-Warning -Message "No application found matching: $AppName"
                Write-Warning -Message "Use -ListApps to see all available application names."
                exit 1
            }

            if ($matchingApps.Count -gt 1 -and -not $ListVerbs) {
                Write-Warning -Message "Multiple applications found matching: $AppName"
                foreach ($app in $matchingApps) {
                    Write-Warning -Message "  $($app.Name)"
                }
                Write-Warning -Message "Use a more specific name or an exact match."
                exit 1
            }

            # Process each matching app (multiple only when -ListVerbs is used)
            foreach ($matchedApp in $matchingApps) {
                $item = $matchedApp
                $itemDisplayName = $matchedApp.Name
                Write-Verbose -Message "Found app: $itemDisplayName"
                Write-Verbose -Message "App path: $($matchedApp.Path)"
            }
        }

        if ($null -eq $item) {
            Write-Warning -Message "Failed to access item through Shell.Application."
            exit 1
        }
        #endregion

        # Retrieve all available verbs for the item
        $verbs = $item.Verbs()
        Write-Verbose -Message "Available verbs: $($verbs.Count)"

        #region :: List verbs mode - display all available verbs and exit
        if ($ListVerbs) {
            # When using -AppName with wildcards, list verbs for each match
            if ($PSCmdlet.ParameterSetName -eq "App" -and $matchingApps.Count -gt 1) {
                foreach ($matchedApp in $matchingApps) {
                    $appVerbs = $matchedApp.Verbs()
                    Write-Output -InputObject "Available shell verbs for: $($matchedApp.Name)"
                    Write-Output -InputObject ("-" * 50)
                    foreach ($verb in $appVerbs) {
                        if ($verb.Name) {
                            $isPinVerb = ""
                            foreach ($pattern in ($startMenuVerbPatterns + $taskbarVerbPatterns)) {
                                if ($verb.Name -like "*$pattern*") {
                                    $isPinVerb = " <-- pin-related"
                                    break
                                }
                            }
                            Write-Output -InputObject "  $($verb.Name)$isPinVerb"
                        }
                    }
                    Write-Output -InputObject ("-" * 50)
                    Write-Output -InputObject ""
                }
                return
            }

            Write-Output -InputObject "Available shell verbs for: $itemDisplayName"
            Write-Output -InputObject ("-" * 50)
            foreach ($verb in $verbs) {
                if ($verb.Name) {
                    $isPinVerb = ""
                    foreach ($pattern in ($startMenuVerbPatterns + $taskbarVerbPatterns)) {
                        if ($verb.Name -like "*$pattern*") {
                            $isPinVerb = " <-- pin-related"
                            break
                        }
                    }
                    Write-Output -InputObject "  $($verb.Name)$isPinVerb"
                }
            }
            Write-Output -InputObject ("-" * 50)
            Write-Output -InputObject "Total verbs: $($verbs.Count)"
            return
        }
        #endregion

        # Attempt Start Menu pin/unpin
        if ($Target -eq "StartMenu" -or $Target -eq "Both") {
            Write-Verbose -Message "Searching for Start Menu $($actionLabel.ToLower()) verb..."
            $startVerb = Find-ShellVerb -Verbs $verbs -Patterns $startMenuVerbPatterns

            if ($startVerb) {
                if ($PSCmdlet.ShouldProcess($itemDisplayName, "$actionLabel - Start Menu")) {
                    Write-Verbose -Message "Invoking verb: $($startVerb.Name)"
                    try {
                        $startVerb.DoIt()
                        Write-Output -InputObject "Start Menu: $actionLabel verb invoked successfully for '$itemDisplayName'."
                    }
                    catch [System.UnauthorizedAccessException] {
                        Write-Warning -Message "Start Menu: Access denied when invoking '$($startVerb.Name)' for '$itemDisplayName'."
                        Write-Warning -Message "Windows 11 blocks programmatic pin operations from scripts, even when the verb is available."
                        Write-Warning -Message "Use the Start Menu UI to pin this item manually, or use Microsoft Intune Start Menu layout policies."
                    }
                }
            }
            else {
                Write-Warning -Message "Start Menu: No $($actionLabel.ToLower()) verb available for '$itemDisplayName'."
                Write-Warning -Message "This operation may not be supported on this Windows version."
            }
        }

        # Attempt Taskbar pin/unpin
        if ($Target -eq "Taskbar" -or $Target -eq "Both") {
            Write-Verbose -Message "Searching for Taskbar $($actionLabel.ToLower()) verb..."
            $taskbarVerb = Find-ShellVerb -Verbs $verbs -Patterns $taskbarVerbPatterns

            if ($taskbarVerb) {
                if ($PSCmdlet.ShouldProcess($itemDisplayName, "$actionLabel - Taskbar")) {
                    Write-Verbose -Message "Invoking verb: $($taskbarVerb.Name)"
                    try {
                        $taskbarVerb.DoIt()
                        Write-Output -InputObject "Taskbar: $actionLabel verb invoked successfully for '$itemDisplayName'."
                    }
                    catch [System.UnauthorizedAccessException] {
                        Write-Warning -Message "Taskbar: Access denied when invoking '$($taskbarVerb.Name)' for '$itemDisplayName'."
                        Write-Warning -Message "Windows 11 blocks programmatic pin operations from scripts, even when the verb is available."
                        Write-Warning -Message "Use the taskbar UI to pin this item manually, or use Microsoft Intune taskbar layout policies."
                    }
                }
            }
            else {
                Write-Warning -Message "Taskbar: No $($actionLabel.ToLower()) verb available for '$itemDisplayName'."
                Write-Warning -Message "Taskbar pinning via shell verbs is not supported on Windows 11 22H2 and later."
            }
        }
    }
    catch {
        Write-Warning -Message "Pin operation failed: $_"
        exit 1
    }
}
#endregion

#region :: end
end {
    # Release COM object
    if ($shell) {
        [System.Runtime.InteropServices.Marshal]::ReleaseComObject($shell) | Out-Null
    }
    Write-Output -InputObject "Script completed."
}
#endregion
