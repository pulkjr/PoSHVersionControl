#0001,New-PsCommand,00.00.01,2016-06-17 20:00:00,Joseph Pulk$

[xml]$config = Get-Content "$($PSScriptRoot)\Resources\config.xml"
# --- Global Variables --- #

# --- Module Variables --- #
New-Variable -Name MasterRepoPath -Value $config.PoSHVersionControl.distro.path -Description "The path to the Repository" -Visibility Private -Scope Script
New-Variable -Name MasterTemplatePath -Value $config.PoSHVersionControl.userPreference.defaultTemplate.name -Description "The path to the template file." -Visibility Private -Scope Script

# --- Import Functions --- #
try {
    $manifest = Import-Csv "$($PSScriptRoot)\Resources\manifest.csv"
    ForEach($file in $manifest.name){
        . "$($PSScriptRoot)\Functions\$file"
    }
}
catch {
    throw
}