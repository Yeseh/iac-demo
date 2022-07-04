Param (
    [Parameter(Mandatory = $true)][string] $Registry
)

Connect-AzContainerRegistry -Name $Registry


Get-Childitem $PSScriptRoot -Filter *.bicep -Recurse -Exclude 'main.bicep' | ForEach-Object {
    $fullPath = $_.FullName
    $subPath = $_.FullName.Replace($PSScriptRoot, "")
    # TODO: Check linux vs windows paths!
    $subPathParts = $subPath.Split("\")
    $filename = $subPathParts[$subPathParts.Length - 1]

    $modulePath = $subPath.Replace($filename, "")
    $moduleName = $filename.Replace(".bicep", "")
    # NOTE: Normally you'd use an actual versioning scheme here, just use latest for demo purposes
    $moduleVersion = 'latest' #$guid #$Matches[2]
    $modulePath = $modulePath.Substring(1, $modulePath.Length - 1).Substring(0, $modulePath.Length - 2).Replace("\", "/")
    $publishTarget = "br:$Registry.azurecr.io/bicep/$modulePath/$moduleName`:$moduleVersion"

    try {
        Publish-AzBicepModule -FilePath $fullPath -Target $publishTarget
        Write-Host "    => Published $publishTarget succesfully!" -ForegroundColor Green
    }
    catch {
        Write-Host "    => Failed to publish $publishTarget" -ForegroundColor Red
    }
}