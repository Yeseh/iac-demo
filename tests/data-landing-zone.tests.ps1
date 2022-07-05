Describe "Data Landing Zone Tests" {
    BeforeAll {
        $paramJson = Get-Content "./parameters.json" | Out-String | ConvertFrom-Json
        $project = $paramJson.parameters.project.value
        $dlzTags = $paramJson.parameters.dlzTags.value
        $dlzLocation = $paramJson.parameters.dlzLocation.value
        $dlzAddressSubspace = $paramJson.parameters.dlzLocation.value;
    }

    It "It should create a resource group" {
        $rgName = "rg-${project}"

        $rg = Get-AzResourceGroup -Name $rgName 

        $rg.ResourceGroupName | Should -Be $rgName
    }
}