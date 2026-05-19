<#PSScriptInfo
.VERSION 1.0.0
.GUID 6e438042-3575-445f-9536-0525bb034e49
.AUTHOR @dotjesper
.COMPANYNAME dotjesper.com
.COPYRIGHT dotjesper.com
.TAGS powershell hyper-v vm hydration provisioning
.LICENSEURI https://github.com/dotjesper/hello-world/blob/main/LICENSE
.PROJECTURI https://github.com/dotjesper/hello-world/
.ICONURI
.EXTERNALMODULEDEPENDENCIES
.REQUIREDSCRIPTS
.EXTERNALSCRIPTDEPENDENCIES
.RELEASENOTES https://github.com/dotjesper/hello-world/blob/main/solution#release-notes
#>

<#
.SYNOPSIS
    Creates and configures Hyper-V virtual machines from a template or blank disk.

.DESCRIPTION
    New-VMHydration creates one or more Hyper-V virtual machines with configurable
    settings including memory, processor count, virtual hard disk, network adapter,
    TPM, and boot order. Supports deploying from a VHD template with unattend.xml
    injection or creating new blank virtual hard disks.

    When no virtual switch is specified, the script auto-selects the switch if only
    one exists, or presents a numbered menu when multiple switches are available.
    The menu includes an option to create VMs without a network adapter.

.PARAMETER ComputerName
    The name of the Hyper-V host. Defaults to localhost.

.PARAMETER VMNames
    An array of virtual machine names to create.

.PARAMETER VMSuffix
    An optional suffix to append to each VM name.

.PARAMETER VMRoot
    The root path where virtual machine files will be stored.

.PARAMETER VMStart
    Start virtual machines after creation.

.PARAMETER AddVMDvdDrive
    Add a DVD drive to each virtual machine. When combined with -ISOPath,
    the ISO is mounted and boot order prioritizes the DVD drive.

.PARAMETER ISOPath
    The path to an ISO file to mount in the DVD drive.

.PARAMETER TemplatePath
    The path to a VHD template file to copy for each virtual machine.

.PARAMETER UnattendPath
    The directory containing unattend XML files named per VM (e.g., VM01.xml).

.PARAMETER VHDName
    The filename for the virtual hard disk. Defaults to disk0.vhdx.

.PARAMETER VHDSize
    The size of the virtual hard disk when creating a new blank disk. Defaults to 128GB.

.PARAMETER ProcessorCount
    The number of virtual processors. Defaults to 4.

.PARAMETER VMNetworkAdapterVlan
    The VLAN ID to assign to the VM network adapter.

.PARAMETER SwitchName
    The name of the virtual switch. When omitted, the script auto-selects the
    switch if only one exists, or prompts for selection when multiple are available.

.PARAMETER Generation
    The virtual machine generation (1 or 2). Defaults to 2.

.PARAMETER StartupBytes
    The startup memory in bytes. Defaults to 4GB.

.PARAMETER MaximumBytes
    The maximum dynamic memory in bytes. Defaults to 4GB.

.PARAMETER MinimumBytes
    The minimum dynamic memory in bytes. Defaults to 1024MB.

.PARAMETER EnableVirtualTPM
    Enable the virtual TPM on the virtual machine.

.PARAMETER ExposeVirtualizationExtensions
    Expose virtualization extensions to the virtual machine (nested virtualization).

.PARAMETER AutomaticStartAction
    The automatic start action for the virtual machine. Defaults to Nothing.

.PARAMETER AutomaticStopAction
    The automatic stop action for the virtual machine. Defaults to Save.

.PARAMETER CheckpointType
    The checkpoint type for the virtual machine. Defaults to Disabled.

.PARAMETER HorizontalResolution
    The horizontal resolution for the virtual machine video. Defaults to 1366.

.PARAMETER VerticalResolution
    The vertical resolution for the virtual machine video. Defaults to 768.

.PARAMETER ResolutionType
    The resolution type for the virtual machine video. Defaults to Single.

.EXAMPLE
    .\New-VMHydration.ps1 -VMNames 'VM01','VM02' -VMRoot 'E:\Virtual Machines'

    Creates two virtual machines with new blank virtual hard disks using default settings.

.EXAMPLE
    .\New-VMHydration.ps1 -VMNames 'VM01' -VMRoot 'E:\Virtual Machines' -TemplatePath 'D:\Templates\base.vhdx' -EnableVirtualTPM

    Creates a virtual machine from a VHD template with TPM enabled.

.EXAMPLE
    .\New-VMHydration.ps1 -VMNames 'VM01' -VMRoot 'E:\Virtual Machines' -AddVMDvdDrive

    Creates a virtual machine with an empty DVD drive attached.

.EXAMPLE
    .\New-VMHydration.ps1 -VMNames 'VM01' -VMRoot 'E:\Virtual Machines' -AddVMDvdDrive -ISOPath 'D:\ISOs\windows.iso'

    Creates a virtual machine with a DVD drive mounted with the specified ISO.

.NOTES
    Version: 1.0.0
    Author: Jesper Nielsen (@dotjesper)
    Release notes: Initial release
#>

#requires -version 5.1 -modules Hyper-V -runasadministrator

[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory = $false, HelpMessage = 'Enter the name of the Hyper-V host.')]
    [ValidateNotNullOrEmpty()]
    [string]$ComputerName = 'localhost',

    [Parameter(Mandatory, HelpMessage = 'Enter the name of the new virtual machine(s).')]
    [ValidateNotNullOrEmpty()]
    [string[]]$VMNames,

    [Parameter(Mandatory = $false, HelpMessage = 'Enter a suffix to append to each VM name.')]
    [ValidateNotNullOrEmpty()]
    [string]$VMSuffix,

    [Parameter(Mandatory = $false, HelpMessage = 'Enter the root path for virtual machine files.')]
    [ValidateScript({ Test-Path $_ })]
    [string]$VMRoot = 'E:\Virtual Machines',

    [Parameter(Mandatory = $false, HelpMessage = 'Start virtual machines after creation.')]
    [switch]$VMStart,

    [Parameter(Mandatory = $false, HelpMessage = 'Add a DVD drive to each virtual machine.')]
    [switch]$AddVMDvdDrive,

    [Parameter(Mandatory = $false, HelpMessage = 'Enter the path to the ISO file.')]
    [ValidateScript({ Test-Path $_ })]
    [string]$ISOPath,

    [Parameter(Mandatory = $false, HelpMessage = 'Enter the path to the VHD template file.')]
    [ValidateScript({ Test-Path $_ })]
    [string]$TemplatePath,

    [Parameter(Mandatory = $false, HelpMessage = 'Enter the directory containing unattend XML files.')]
    [string]$UnattendPath = "$([Environment]::GetFolderPath('MyDocuments'))",

    [Parameter(Mandatory = $false, HelpMessage = 'Virtual hard disk filename.')]
    [ValidateNotNullOrEmpty()]
    [string]$VHDName = 'disk0.vhdx',

    [Parameter(Mandatory = $false, HelpMessage = 'Virtual hard disk size in bytes.')]
    [ValidateNotNullOrEmpty()]
    [int64]$VHDSize = 128GB,

    [Parameter(Mandatory = $false, HelpMessage = 'Number of virtual processors.')]
    [ValidateRange(1, 128)]
    [int]$ProcessorCount = 4,

    [Parameter(Mandatory = $false, HelpMessage = 'VLAN ID for the VM network adapter.')]
    [int]$VMNetworkAdapterVlan,

    [Parameter(Mandatory = $false, HelpMessage = 'Virtual switch name.')]
    [ValidateNotNullOrEmpty()]
    [string]$SwitchName,

    [Parameter(Mandatory = $false, HelpMessage = 'Virtual machine generation.')]
    [ValidateSet(1, 2)]
    [int]$Generation = 2,

    [Parameter(Mandatory = $false, HelpMessage = 'Startup memory in bytes.')]
    [ValidateNotNullOrEmpty()]
    [int64]$StartupBytes = 4GB,

    [Parameter(Mandatory = $false, HelpMessage = 'Maximum dynamic memory in bytes.')]
    [ValidateNotNullOrEmpty()]
    [int64]$MaximumBytes = 4GB,

    [Parameter(Mandatory = $false, HelpMessage = 'Minimum dynamic memory in bytes.')]
    [ValidateNotNullOrEmpty()]
    [int64]$MinimumBytes = 1024MB,

    [Parameter(Mandatory = $false, HelpMessage = 'Enable virtual TPM on the virtual machine.')]
    [switch]$EnableVirtualTPM,

    [Parameter(Mandatory = $false, HelpMessage = 'Expose virtualization extensions for nested virtualization.')]
    [switch]$ExposeVirtualizationExtensions,

    [Parameter(Mandatory = $false, HelpMessage = 'Automatic start action for the virtual machine.')]
    [ValidateSet('Nothing', 'StartIfRunning', 'Start')]
    [string]$AutomaticStartAction = 'Nothing',

    [Parameter(Mandatory = $false, HelpMessage = 'Automatic stop action for the virtual machine.')]
    [ValidateSet('TurnOff', 'Save', 'ShutDown')]
    [string]$AutomaticStopAction = 'Save',

    [Parameter(Mandatory = $false, HelpMessage = 'Checkpoint type for the virtual machine.')]
    [ValidateSet('Disabled', 'Production', 'ProductionOnly', 'Standard')]
    [string]$CheckpointType = 'Disabled',

    [Parameter(Mandatory = $false, HelpMessage = 'Horizontal resolution for the virtual machine video.')]
    [ValidateNotNullOrEmpty()]
    [int]$HorizontalResolution = 1366,

    [Parameter(Mandatory = $false, HelpMessage = 'Vertical resolution for the virtual machine video.')]
    [ValidateNotNullOrEmpty()]
    [int]$VerticalResolution = 768,

    [Parameter(Mandatory = $false, HelpMessage = 'Resolution type for the virtual machine video.')]
    [ValidateSet('Single', 'Default', 'Maximum')]
    [string]$ResolutionType = 'Single'
)
#region :: begin
begin {
    #region :: Environment configurations
    [version]$ScriptVersion = '1.0.0'
    Set-Variable -Name 'ScriptVersion' -Value $ScriptVersion -Option ReadOnly -Scope Script
    Set-StrictMode -Version Latest
    $ErrorActionPreference = 'Stop'
    #endregion

    #region :: Invocation details
    Write-Verbose -Message "Script name: $($myInvocation.myCommand.name)"
    Write-Verbose -Message "Script version: $ScriptVersion"
    Write-Verbose -Message "Hyper-V host: $ComputerName"
    Write-Verbose -Message "VM root: $VMRoot"
    Write-Verbose -Message "VM count: $($VMNames.Count)"
    #endregion

    #region :: Validate VM root
    if (-not (Test-Path $VMRoot)) {
        Write-Warning -Message "$VMRoot does not exist - hydration terminated."
        exit 1
    }
    #endregion

    #region :: Resolve virtual switch
    if (-not $SwitchName) {
        $availableSwitches = Get-VMSwitch -ComputerName $ComputerName -ErrorAction SilentlyContinue

        if (-not $availableSwitches -or $availableSwitches.Count -eq 0) {
            Write-Warning -Message 'No virtual switches found - VMs will be created without a network adapter.'
            $SwitchName = $null
        }
        elseif ($availableSwitches.Count -eq 1) {
            $SwitchName = $availableSwitches[0].Name
            Write-Verbose -Message "Auto-selected virtual switch: $SwitchName"
        }
        else {
            Write-Output -InputObject 'Multiple virtual switches found. Please select one:'
            Write-Output -InputObject '  [0] No switch (no network adapter)'

            for ($i = 0; $i -lt $availableSwitches.Count; $i++) {
                Write-Output -InputObject "  [$($i + 1)] $($availableSwitches[$i].Name)"
            }

            $selection = Read-Host -Prompt 'Enter the number of the virtual switch to use'

            if ($selection -match '^\d+$' -and [int]$selection -eq 0) {
                $SwitchName = $null
                Write-Verbose -Message 'No virtual switch selected - VMs will be created without a network adapter.'
            }
            elseif ($selection -match '^\d+$' -and [int]$selection -ge 1 -and [int]$selection -le $availableSwitches.Count) {
                $SwitchName = $availableSwitches[[int]$selection - 1].Name
                Write-Verbose -Message "Selected virtual switch: $SwitchName"
            }
            else {
                Write-Warning -Message 'Invalid selection - hydration terminated.'
                exit 1
            }
        }
    }
    else {
        # Validate the provided switch name exists
        $switchExists = Get-VMSwitch -ComputerName $ComputerName -Name $SwitchName -ErrorAction SilentlyContinue

        if (-not $switchExists) {
            Write-Warning -Message "Virtual switch '$SwitchName' not found on the Hyper-V host - hydration terminated."
            exit 1
        }
    }

    Write-Verbose -Message "Virtual switch: $(if ($SwitchName) { $SwitchName } else { 'None' })"
    #endregion
}
#endregion

#region :: process
process {
    #region :: Main logic
    $vmIndex = 0
    $vmTotal = $VMNames.Count

    foreach ($vmName in $VMNames) {
        $vmIndex++

        if ($null -ne $VMSuffix) {
            $vmName = "$vmName.$VMSuffix"
        }

        # Update progress bar with current VM and percentage complete
        $percentComplete = [math]::Round(($vmIndex / $vmTotal) * 100)
        Write-Progress -Activity 'Hydrating virtual machines' -Status "VM $vmIndex of $vmTotal - $($vmName.ToUpper())" -PercentComplete $percentComplete

        Write-Verbose -Message "Setting paths for $vmName"

        $virtualMachinePath = Join-Path -Path $VMRoot -ChildPath "$vmName\Virtual Machine"
        $virtualHardDisksPath = Join-Path -Path $VMRoot -ChildPath "$vmName\Virtual Hard Disks"
        $vhdPath = Join-Path -Path $virtualHardDisksPath -ChildPath $VHDName

        Write-Verbose -Message "Virtual Machine Path: $virtualMachinePath"
        Write-Verbose -Message "Virtual Hard Disks Path: $vhdPath"

        #region :: Early exit - VM or VHD already exists
        if (Get-VM -Name $vmName -ErrorAction SilentlyContinue) {
            Write-Warning -Message "$($vmName.ToUpper()) already exists - skipping."
            continue
        }

        if (Test-Path $vhdPath) {
            Write-Warning -Message "$vhdPath already exists - skipping $($vmName.ToUpper())."
            continue
        }
        #endregion

        #region :: Early exit - ShouldProcess
        if (-not $PSCmdlet.ShouldProcess($vmName, 'Create and configure virtual machine')) {
            continue
        }
        #endregion

        try {
            #region :: Create virtual machine
            Write-Verbose -Message "Creating $($vmName.ToUpper())"

            $newVMParams = @{
                ComputerName       = $ComputerName
                Name               = $vmName
                NoVHD              = $true
                Generation         = $Generation
                MemoryStartupBytes = $StartupBytes
                Path               = $virtualMachinePath
            }

            if ($SwitchName) {
                $newVMParams['SwitchName'] = $SwitchName
            }

            $newVM = New-VM @newVMParams
            #endregion

            #region :: Configure virtual hard disk
            if (-not (Test-Path -Path $virtualHardDisksPath)) {
                New-Item -Path $virtualHardDisksPath -ItemType Directory | Out-Null
            }

            if ($TemplatePath -and (Test-Path -Path $TemplatePath)) {
                Write-Verbose -Message "Copying $TemplatePath to $vhdPath"
                Copy-Item -Path $TemplatePath -Destination $vhdPath -Force | Out-Null

                # Inject unattend.xml if a matching file exists
                $unattendFile = Join-Path -Path $UnattendPath -ChildPath "$vmName.xml"

                if (Test-Path $unattendFile) {
                    try {
                        Write-Verbose -Message "Mounting $vhdPath"
                        Mount-VHD -Path $vhdPath -Passthru | Out-Null

                        # WORKAROUND: Allow time for the VHD to become available after mounting
                        Start-Sleep -Seconds 2

                        $vhdDriveLetter = Get-DiskImage -ImagePath $vhdPath |
                            Get-Disk |
                            Get-Partition |
                            Get-Volume |
                            Select-Object -ExpandProperty DriveLetter

                        $vhdDriveRoot = "$($vhdDriveLetter -replace ' ', ''):"
                        $pantherPath = Join-Path -Path $vhdDriveRoot -ChildPath 'Windows\Panther\Unattend.xml'

                        Write-Verbose -Message "Copying $unattendFile to $pantherPath"
                        Copy-Item -Path $unattendFile -Destination $pantherPath -Force | Out-Null

                        # WORKAROUND: Allow time for the copy to complete before dismounting
                        Start-Sleep -Seconds 2
                    }
                    finally {
                        Write-Verbose -Message "Dismounting $vhdPath"
                        Dismount-VHD -Path $vhdPath | Out-Null
                    }
                }
                else {
                    Write-Warning -Message "$unattendFile not found - skipping unattend injection."
                }
            }
            else {
                Write-Verbose -Message "Creating $vhdPath [$($VHDSize / 1GB)GB]"

                $newVHDParams = @{
                    ComputerName = $ComputerName
                    Path         = $vhdPath
                    SizeBytes    = $VHDSize
                    Dynamic      = $true
                }
                New-VHD @newVHDParams | Out-Null
            }

            $addHDDParams = @{
                ComputerName   = $ComputerName
                VMName         = $vmName
                Path           = $vhdPath
                ControllerType = 'SCSI'
            }
            Add-VMHardDiskDrive @addHDDParams
            #endregion

            #region :: Configure virtual machine settings
            Set-VM -ComputerName $ComputerName -Name $vmName -Notes $vmName

            $setVMParams = @{
                ComputerName         = $ComputerName
                Name                 = $vmName
                AutomaticStartAction = $AutomaticStartAction
                AutomaticStopAction  = $AutomaticStopAction
                CheckpointType       = $CheckpointType
            }
            Set-VM @setVMParams

            if ($AddVMDvdDrive) {
                $dvdParams = @{
                    ComputerName = $ComputerName
                    VMName       = $vmName
                }

                if ($ISOPath -and (Test-Path $ISOPath)) {
                    $dvdParams['Path'] = $ISOPath
                }

                Add-VMDvdDrive @dvdParams

                if ($dvdParams.ContainsKey('Path')) {
                    Set-VMFirmware -ComputerName $ComputerName -VMName $vmName -BootOrder $($newVM.DVDDrives), $($newVM.HardDrives), $($newVM.NetworkAdapters)
                }
                else {
                    Set-VMFirmware -ComputerName $ComputerName -VMName $vmName -BootOrder $($newVM.HardDrives), $($newVM.DVDDrives), $($newVM.NetworkAdapters)
                }
            }
            else {
                Set-VMFirmware -ComputerName $ComputerName -VMName $vmName -BootOrder $($newVM.HardDrives), $($newVM.NetworkAdapters)
            }

            $memoryParams = @{
                ComputerName         = $ComputerName
                VMName               = $vmName
                DynamicMemoryEnabled = $true
                MaximumBytes         = $MaximumBytes
                MinimumBytes         = $MinimumBytes
                StartupBytes         = $StartupBytes
            }
            Set-VMMemory @memoryParams

            $processorParams = @{
                ComputerName   = $ComputerName
                VMName         = $vmName
                Count          = $ProcessorCount
                Maximum        = 80
                RelativeWeight = 100
            }
            Set-VMProcessor @processorParams

            if ($EnableVirtualTPM) {
                Write-Verbose -Message "Adding local key protector and enabling virtual TPM for $vmName"
                Set-VMKeyProtector -ComputerName $ComputerName -VMName $vmName -NewLocalKeyProtector
                Enable-VMTPM -ComputerName $ComputerName -VMName $vmName
            }

            if ($ExposeVirtualizationExtensions) {
                Write-Verbose -Message "Exposing virtualization extensions for $vmName"
                Set-VMProcessor -ComputerName $ComputerName -VMName $vmName -ExposeVirtualizationExtensions $true
            }

            if ($VMNetworkAdapterVlan) {
                Write-Verbose -Message "Setting VLAN $VMNetworkAdapterVlan for $vmName"
                Set-VMNetworkAdapterVlan -VMName $vmName -Access -VlanId $VMNetworkAdapterVlan
            }

            # Configure virtual machine video resolution
            $videoParams = @{
                VMName               = $vmName
                HorizontalResolution = $HorizontalResolution
                VerticalResolution   = $VerticalResolution
                ResolutionType       = $ResolutionType
            }
            Set-VMVideo @videoParams
            #endregion

            #region :: Start virtual machine
            if ($VMStart) {
                Write-Verbose -Message "Starting $vmName"
                Start-VM -Name $vmName -ComputerName $ComputerName
            }
            #endregion

            Write-Verbose -Message "$($vmName.ToUpper()) completed."
        }
        catch {
            Write-Warning -Message "Failed to create $($vmName.ToUpper()): $_"
        }
    }

    # Complete the progress bar
    Write-Progress -Activity 'Hydrating virtual machines' -Completed
    #endregion
}
#endregion

#region :: end
end {
    Write-Output -InputObject "Hydration completed."
}
#endregion
