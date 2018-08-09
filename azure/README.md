# GoChain - Azure ARM templates for Marketplace
The templates that drive the offerings in Azure Marketplace are contained in this repository.  This includes both single VM and multi VM deployments.  Along with these are the assets for the offers in the marketplace and the custom UI definitions.

# Deployment types
There are 3 primary deployment types that will deployed as offers to the Azure marketplace.

* Common assets - The common [assets](assets) are stored here.  These are the icons/images and metadata for the azure marketplace publishing portal.

* Single VM - These assets are contained in the [single](single) folder.  The following assets will be deployed with this template.
    * Virtual machine
    * Virtual network
    * Netowrk Interface
    * Public IP Address
    * Network security group
    * Virtual machine extension/script

# Testing 
Before publishing the templates to Azure, it is best to test the deployments to ensure any issues are resolved, without having to wait for the publishing process to complete.  There are 2 primary tests that should be performed.

* ARM Template - To test the core functionality of the infrastructure templates a few steps will be required.  If this is the first time testing, there is an additional step.

    1. (*Only needed the first time*) Install [Storage Explorer](https://azure.microsoft.com/en-us/features/storage-explorer/) if not already installed.  This will be needed to store the nested templates/scripts for testing.
    2. Create a [storage account](https://portal.azure.com/#create/Microsoft.StorageAccount-ARM) in Azure.
    3. Create a container inside this storage account, this can be named any name you like and the access level to this container should be public (can be set by right clicking the container in storage explore and Set Public Access Level (*Public read access for container and blobs*))
    4. Now upload the files under the [common folder](single/common) to this container. `NOTE: Do not upload the common folder, it should just be everything contained within the common folder.`
    5. Next copy the [template](single/marketplace/dev/mainTemplate.json) to the clipboard.
    6. Open the [Template Deployment](https://portal.azure.com/#create/Microsoft.Template) app in Azure marketplace.  Select the option to *Build your own template in the editor*.  Remove the existing json in the editor and paste the template you copied in step 5 here.
    7. The last parameter, baseUrl, should contain the url to the storage container for the assets, created in step 3 above.  `NOTE: Ensure the trailing slash is removed from the path.  Also, the path can easily be obtained by highlighting the container in storage explore and selecting the option Copy URL in the buttons above it in the storage explorer UI.` 
    8. Hit Save and Azure will parse the template and present a UI (a bit ugly :) ), however it will allow you to enter parametes for the template and execute it. `NOTE: It would be best to create unique resource groups when testing, to make clean up easier`
* UI Definition - To test the custom ui definition in Azure, sideloading in the Azure management portal can be used. `NOTE: The UI will be pure UI and will not feed any underlying template when sideloading.`  This allows the developer to see the customer experience which will after publishing, be joined the underlying ARM template to feed the parameters required there.
    1. Follow steps 1-3 from the ARM template section above if needed.
    2. Now upload the [createUIDefinition.json](single/marketplace/dev/createUiDefinition.json) to this container.
    3. Ensure the [test file](test/createUIDefinitionTest) is pointing to this json file in step 2.  `NOTE: This must be URL encoded`
    4. Copy the full string in the [test file](test/createUIDefinitionTest) to an internet browser.  The UI will render and allow the developer to execute the steps.
