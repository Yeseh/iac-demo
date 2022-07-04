bicep build main.bicep
az deployment sub create `
    --location westeurope `
    --template-file main.json `
    --parameters parameters.json `
    --confirm-with-what-if