#0002,pub_Pull-PsCommand.ps1,00.00.01,2016-06-27 20:00:00,pulk $
function Pull-PsCommand{
    <#
 
    .SYNOPSIS
    Pull a PowerShell Commandlet from the repo
 
    .DESCRIPTION
    This cmdlet will checkout a specific commandlet from the repository then 

    .PARAMETER Name
    The Name of the commandlet to be exported 
    Usage: -Name [string]

    .EXAMPLE
    Pull-PsCommand -name Update-Module

    Checks out the Update-Module Function for editing and opens it in ISE.
 
    #>
    [CmdletBinding(DefaultParameterSetName=”Set 1”, SupportsShouldProcess=$false, ConfirmImpact=’Low’ )]
    [OutputType([psobject], ParameterSetName="Version")]
    Param(
        [switch]$SkipDownload
        ,
        [switch]$force
        ,
        [Parameter(ParameterSetName='Version')]
        [switch]$Version
    )
    dynamicparam {
        $attributes = new-object System.Management.Automation.ParameterAttribute
        $attributes.ParameterSetName = "Set 1"
        $attributes.Mandatory = $true
        $attributeCollection = new-object -Type System.Collections.ObjectModel.Collection[System.Attribute]
        $attributeCollection.Add($attributes)
        $values = (ls "$PSScriptRoot" -Filter "*.ps1").name
        $ValidateSet = new-object System.Management.Automation.ValidateSetAttribute($values)
        $attributeCollection.Add($ValidateSet)

        $dynParam1 = new-object -Type System.Management.Automation.RuntimeDefinedParameter("Name", [string], $attributeCollection)
        $paramDictionary = new-object -Type System.Management.Automation.RuntimeDefinedParameterDictionary
        $paramDictionary.Add("Name", $dynParam1)

        #Repo Lookup
        $attributes = new-object System.Management.Automation.ParameterAttribute
        $attributes.ParameterSetName = "RepositoryLookup"
        $attributes.Mandatory = $true
        $attributeCollection = new-object -Type System.Collections.ObjectModel.Collection[System.Attribute]
        $attributeCollection.Add($attributes)
        $values = (ls "$script:MasterRepoPath" -Filter "*.ps1").name
        $ValidateSet = new-object System.Management.Automation.ValidateSetAttribute($values)
        $attributeCollection.Add($ValidateSet)

        $dynParam1 = new-object -Type System.Management.Automation.RuntimeDefinedParameter("NameOnRepo", [string], $attributeCollection)
        $paramDictionary.Add("NameOnRepo", $dynParam1)
        return $paramDictionary 
    }
    BEGIN{
        if($version){
            $Ver = New-Object -TypeName psobject -Property @{Name=$null;Module=$null;Version=$null;Author=$null;Created=$null;Revised=$null}
            $Ver.Name = "Pull-PsCommand"
            $Ver.Module = "PoSHVersionControl"
            $Ver.Version = "00.00.01"
            $Ver.Author = "Joseph Pulk"
            $Ver.Created = "06/27/2015"
            $Ver.Revised = "06/27/2015"
            Return $ver
            break
        }
        $greenCheck = @{
            Object = [Char]8730
            ForeGroundColor = 'Green'
            NoNewLine = $True
        }
        function Compare-RepoCopy(){
            $RepoModify = (ls "$script:MasterRepoPath\$name" -ErrorAction SilentlyContinue).LastWriteTime
            $LocalModify = (ls "$PSScriptRoot\$name"  -ErrorAction SilentlyContinue).LastWriteTime
            if(!$RepoModify){
                Write-Warning -Message "File Only Exists Locally! Run `"Commit-PsCommand -name $name`" to ensure the copy is saved to repo."
            }
            if($LocalModify -gt $RepoModify){
                Write-Warning "Local Copy is newer than Repo. If you would like to download the latest copy rerun command with -force switch"
                if($force){
                    cp "$script:MasterRepoPath\$name" "$PSScriptRoot\$name"
                }
            }
            else{
                Write-Host "Downloading Updated Copy from Repository"
                try{
                    cp "$script:MasterRepoPath\$name" "$PSScriptRoot\$name"
                    Write-Host @greenCheck
                    Write-Host -ForegroundColor Green " $name was downloaded successfully"
                }
                catch{}
            }
        }
    }
    PROCESS{
        if($PSBoundParameters.Name){
            $name = $PSBoundParameters.Name
        }
        elseif($PSBoundParameters.NameOnRepo){
            $name = $PSBoundParameters.NameOnRepo
        }

        if($name){
            if(Test-Path $("$PSScriptRoot\$name.checkout") -ErrorAction SilentlyContinue){
                Write-Host -ForegroundColor Green "File checked out locally already, opening in ISE."
                
                if(!$SkipDownload){ 
                    Compare-RepoCopy
                }
                PowerShell_ISE -file "$PSScriptRoot\$name"
            }
            elseif(Test-Path ("$script:MasterRepoPath\$name.checkout") -ErrorAction SilentlyContinue){
                $details = Import-Csv -Path "$script:MasterRepoPath\Functions\$name.checkout"
                if($details.Name -eq ([Environment]::UserName)){
                    Write-Host -ForegroundColor Green "You already checked this file from the PoSH Repo."
                    
                    if(!$SkipDownload){
                        Compare-RepoCopy
                    }
                    Write-Host "Checking out locally and Opening in ISE."
                    $details | Export-Csv -NoTypeInformation "$PSScriptRoot\$name.checkout"
                    PowerShell_ISE -file "$PSScriptRoot\$name" 
                }
                else{
                    Write-Error -Message "$name was checked out by $($details.name) on $($details.date) for version $($details.version)"
                }
            }
            else{
                $CheckOut = New-Object -TypeName psobject -Property @{Command=$name;Name=([Environment]::UserName);date=(get-date);version=0}
                $CheckOut | Export-Csv -NoTypeInformation "$script:MasterRepoPath\$name.checkout"
                $CheckOut | Export-Csv -NoTypeInformation "$PSScriptRoot\$name.checkout"
                if(!$SkipDownload){
                    Compare-RepoCopy
                }
                PowerShell_ISE -file "$PSScriptRoot\$name"

            }
        }
    }
}

if ($MyInvocation.ScriptName -match '.psm1$') {
    Export-ModuleMember -Function Pull-PsCommand
}
