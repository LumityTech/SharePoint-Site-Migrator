$url = "https://<tenant>.sharepoint.com/sites/<site>/" #site to import template from replace <tenant> and <site>
$configFilePath = ".\SPPNPConfigExtraction.json" #path to JSON config, included - see https://developer.microsoft.com/en-us/json-schemas/pnp/provisioning/201910/extract-configuration.schema.json for schema
$outPath = ".\template\template.xml" #path to output template as xml - include intended file name i.e. \path\file.xml

if ($url -and $configFilePath -and $outPath){    

    Write-Host "Beginning SPO site template export script."

    Write-Host "Requesting connection to tenant."

    Connect-PnPOnline -Url $url -Interactive

    $web = Get-PnPWeb

    Write-Host "Successfully connected to tenant. Connected to site: ", $web.Title, "."

    Write-Host "Exporting Site Template from tenant site."

    Get-PnPSiteTemplate -Configuration $configFilePath -Out $outPath        

    Write-Host "Manually adding footer logo and header background to SiteAssets folder of template."

    Add-PnPFileToSiteTemplate -Path $outPath -Source '.\assets\SiteAssets\__extendedHeaderBackgroundImage__headerBanner.png' -Folder '/SiteAssets' 
    
    Add-PnPFileToSiteTemplate -Path $outPath -Source '.\assets\SiteAssets\__footerlogo__footerLogo.png' -Folder '/SiteAssets' 

    Write-Host "Successfully exported site template, completely."

    Write-Host "Disconnecting from tenant."

    Disconnect-PnPOnline

} else {

    Write-Host "Error: One, some or all of the url, config file path or out path variables were empty or null. Please update them within the script before running."

}