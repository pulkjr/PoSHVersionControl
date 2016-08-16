#0001,Get-PsTemplates_pub.ps1,00.00.01,2016-06-17 20:00:00,Joseph Pulk$
function Get-PsTemplates{
    <#
 
      .SYNOPSIS
      Display the current templates currently saved.
 
      .DESCRIPTION
      This cmdlet will Create a New ps1 file on the module and check it out. This will include the necessary changelog files.

      .PARAMETER CommandVerb
      The verb used for the beginning of the commands name. e.g. Get, Set, Resume...
      Usage: -CommandVerb [string]

      .PARAMETER Subject
      The Subject that the command will look at. e.g. NcVscanPolicy, NcVolConfig, NcVol...
      Usage: -Subject [string]

      .PARAMETER Scope
      The Scope that the command will be visible under. This indicates whether the command will be visible to the end user for execution (Public) or only visible to commands within the module (Private)
      Usage: -Scope [string]

      .EXAMPLE
      New-PsCommand -CommandVerb Get -Subject NcVolConfig -Scope Public

      This will create a new Command Called Get-NcVolConfig with all of the details added to the file.
 
    #>
    [CmdletBinding(DefaultParameterSetName=”Set 1”, SupportsShouldProcess=$True, ConfirmImpact=’Low’ )]
    [OutputType([psobject], ParameterSetName="Set 1")]
    [OutputType([psobject], ParameterSetName="Version")]
    Param(
        [Parameter(ParameterSetName='Set 1')]
        [String]$Name
     ,
        [Parameter(ParameterSetName='Version')]
        [switch]$Version
    )
    BEGIN{
        if($version){
            $Ver = New-Object -TypeName psobject -Property @{Name=$null;Module=$null;Version=$null;Author=$null;Created=$null;Revised=$null}
            $Ver.Name = "New-PsCommand"
            $Ver.Module = "PoSHVersionControl"
            $Ver.Version = "00.00.01"
            $Ver.Author = "Joseph R. Pulk"
            $Ver.Created = "01/26/2015"
            $Ver.Revised = "01/29/2015"
            Return $ver        }    }    PROCESS{      return $script:MasterRepoInfo.userPreferences.Templates    }}

if ($MyInvocation.ScriptName -match '.psm1$') {
    Export-ModuleMember -Function Get-PsTemplates
}