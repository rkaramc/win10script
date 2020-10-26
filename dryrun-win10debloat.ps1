Import-Module .\core-win10debloat.psm1 -Force

$dryrun = "DRYRUN"
$tweaks = (
    "BeginDebloat",

    ### Require administrator privileges ###
	"RequireAdmin",
	"CreateRestorePoint",
    # "UpdateSettingsOOShutup10",
    # "InstallChocolatey",
	# "Install7Zip",
	# "InstallNotepadplusplus",
	# "InstallIrfanview",
	# "InstallVLC",
	# "InstallAdobe",
	# "InstallBrave",
	# "ChangeDefaultApps",
    
    "DebloatAll", 

    "EnableDarkMode",    # "DisableDarkMode",
    "EndDebloat"
)

function BeginDebloat () {
	Write-Output "Beginning..."
}

function EndDebloat () {
	Write-Output "End"
}

##########
# Parse parameters and apply tweaks
##########

# Normalize path to preset file
$preset = ""
$PSCommandArgs = $args
If ($args -And $args[0].ToLower() -eq "-preset") {
	$preset = Resolve-Path $($args | Select-Object -Skip 1)
	$PSCommandArgs = "-preset `"$preset`""
}

# Load function names from command line arguments or a preset file
If ($args) {
	$tweaks = $args
	If ($preset) {
		$tweaks = Get-Content $preset -ErrorAction Stop | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne "" -and $_[0] -ne "#" }
	}
}

# Call the desired tweak functions
$tweaks | ForEach-Object { Invoke-Expression "$_ $dryrun" }

