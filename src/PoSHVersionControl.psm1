#0001,New-PsCommand,00.00.01,2016-06-17 20:00:00,Joseph Pulk$

# --- Global Variables --- #

# --- Module Variables --- #
$parametrs = @{
    'Name' = 'MasterRepoInfo';
    'Value' = $(ConvertFrom-Json -InputObject (Get-Content -Path "$($PSScriptRoot)\Resources\config.json" -Raw));
    'Description' = 'Array that holds all of the repository information';
    #'Visibility' = 'Private';
    #'Scope' = 'Script';

}
New-Variable @parametrs



# --- Import Functions --- #
try
{
    $manifest = Import-Csv -Path "$($PSScriptRoot)\Resources\manifest.csv"
    ForEach($file in $manifest.name)
    {
        . "$($PSScriptRoot)\Functions\$file"
    }
}
catch
{
    throw
}