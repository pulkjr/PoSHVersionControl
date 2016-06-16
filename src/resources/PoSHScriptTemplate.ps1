#%ID%,%SCRIPTNAME%,%VERSION%,%DATE%,%AUTHORNAME%$

function %FUNCTIONNAME%{
    <#
    .SYNOPSIS
    <Place Synopsis HERE>
 
    .DESCRIPTION
    Place Description HERE

    .PARAMETER Name
    The Name to be used by the command
    Usage: -Name [string]

    .EXAMPLE
    %FUNCTIONNAME% -Name 

    Description of EXAMPLE

 
    .NOTES
        Script Name: %FUNCTIONNAME%

        Change log: 
        See %CHANGELOG%
 
    #>
    [CmdletBinding(DefaultParameterSetName="Set 1”, SupportsShouldProcess=$True, ConfirmImpact="Low" )]
    Param
    (
        [Parameter(Mandatory=$true, ParameterSetName='Set 1',HelpMessage="The Name of the...",position=0)]
        $Name
        ,
        [Parameter(ParameterSetName='Version')]
        [switch]$Version
    )

    BEGIN
    {
        if($version){
            $Ver = New-Object -TypeName psobject -Property @{Name=$null;Module=$null;Version=$null;Author=$null;Created=$null;Revised=$null}
            $Ver.Name = "%SCRIPTNAME%"
            $Ver.Module = "%MODULENAME%"
            $Ver.Version = "%VERSION%"
            $Ver.Author = "%AUTHORNAME%"
            $Ver.Created = "%CREATEDDATE%"
            $Ver.Revised = "%CREATEDDATE%"
            Return $ver
            break
        }

    }
    PROCESS{
        
        
    }
    END{

    }
}

if ($MyInvocation.ScriptName -match '.psm1$') {
    Export-ModuleMember -Function %FUNCTIONNAME%
}
