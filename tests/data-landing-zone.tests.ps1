Describe "Data Landing Zone Tests" {
    BeforeAll {
        $paramJson = Get-Content "./parameters.json" | Out-String | ConvertFrom-Json
        $project = $paramJson.parameters.project.value
        $dlzTags = $paramJson.parameters.dlzTags.value
        $dlzLocation = $paramJson.parameters.dlzLocation.value
        $dlzAddressSubspace = $paramJson.parameters.dlzLocation.value
        $rgName = "rg-${project}"
    }

    It "It should create a resource group" {
        $rg = Get-AzResourceGroup -Name $rgName 

        $rg.ResourceGroupName | Should -Be $rgName
    }

    It "It should create a storage account" {
        $trimmedProj = $project.Replace("-", "")
        $expAccountName = "dls${trimmedProj}"
        $rgName 
        $expAccountName
        $account = Get-AzStorageAccount -ResourceGroupName $rgName -Name $expAccountName

        $account.StorageAccountName | Should -Be $expAccountName
        $account.Sku.Name | Should -Be 'Standard_LRS'
        $account.Kind | Should -Be 'StorageV2'
        $account.Location | Should -Be $dlzLocation
    }
}