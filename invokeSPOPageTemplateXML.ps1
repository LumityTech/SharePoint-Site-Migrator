$tenantUrl = "https://<tenant>.sharepoint.com" #the base url of your tenant site i.e. replace <tenant>
$siteUrlSlug = "/sites/<site>" #url slug to follow the tenant site to the site you wish to apply the template to, i.e https://<tenant>.sharepoint.com<slug>, where slug may equal '/sites/siteName'; replace <site>
$fullSiteUrl = $tenantUrl + $siteUrlSlug 
$templatePath = ".\template\template.xml" #path to the template file you wish to apply
$templatesMatch = $true

#relative url paths to branding files below. i.e. where the handlers should expect to find the files on the target site. 
$headerLogo = $siteUrlSlug + '/SiteAssets/__sitelogo__headerLogo.png' 
$headerBackground = $siteUrlSlug + '/SiteAssets/__extendedHeaderBackgroundImage__headerBanner.png'
$footerLogo = $siteUrlSlug + '/SiteAssets/__footerlogo__footerLogo.png'


if ($tenantUrl -and $siteUrlSlug -and $templatePath){    

    Write-Host "Beginning site template application script."

    Write-Host "Requesting connection to tenant."

    Connect-PnPOnline -Url $fullSiteUrl -Interactive    

    $siteTemplate = ""

    $web = Get-PnPWeb -Includes WebTemplate    

    $targetSiteTemplateType = $web.WebTemplate.Trim()

    Write-Host "Successfully connected to tenant. Connected to site: ", $web.Title, "."
        
    Switch ($targetSiteTemplateType){
        'GROUP' {Write-Host "Target site is of Teams site type."}
        'SITEPAGEPUBLISHING' {Write-Host "Target site is of Communication site type."}
        default {Write-Host "Target site is of type ", $siteTemplateType, "."}
    }    

    try {    

        $xml = [xml](Get-Content $templatePath)

        $siteTemplateType = $xml.Provisioning.Templates.ProvisioningTemplate.BaseSiteTemplate
        $siteTemplateType = $siteTemplateType -replace "#.*" #remove #0 etc from string for comparison between site template types

        Switch ($siteTemplateType){
            'GROUP' {Write-Host "Local template site is of Teams site type."}
            'SITEPAGEPUBLISHING' {Write-Host "Local template site is of Communication site type."}
            default {Write-Host "Local template site is of type ", $siteTemplateType, "."}
        }   

    } catch {
    
        $templatesMatch = $false
        Write-Host "Unable to extract site template property from XML site template."
        Write-Host "Continuing to attempt to apply template, though, issues may arise..."

    }         
    
    if($siteTemplateType -eq $targetSiteTemplateType){
        Write-Host "Site types of template and target site match."
    } else {
        $templatesMatch = $false
        Write-Host "Site types of template and taget site do not match. Template application may not be entirely successful."
    }

    Write-Host "Applying template to ", $web.Title, "."

    Invoke-PnPSiteTemplate -Path $templatePath

    Write-Host "Updating site theme."

    Set-PnPWebTheme -Theme "Therapy Focus Theme"

    Write-Host "Updating site header logo."

    if($siteTemplateType -eq "GROUP"){

        Set-PnPWebHeader -SiteLogoUrl $footerLogo 

    } else {

        Set-PnPWebHeader -SiteLogoUrl $headerLogo 

    }

    Write-Host "Updating site header display setting and background."

    if($siteTemplateType -eq "GROUP"){

        Set-PnPWebHeader -HeaderLayout Standard -HeaderEmphasis Strong -LogoAlignment Left 
        
    } else {

        Set-PnPWebHeader -HeaderLayout Extended -HeaderBackgroundImageUrl $headerBackground -HeaderEmphasis Strong -LogoAlignment Left    
        
    }

    Write-Host "Updating site footer logo, text and display settings if required."

    if(!($siteTemplateType -eq "GROUP")){

        Set-PnPFooter -LogoUrl $footerLogo -Title "Therapy Focus ©" -Enabled:$true -Layout Simple -BackgroundTheme Strong
        
    }

    Write-Host "Successfully applied site template."

    Write-Host "Disconnection from tenant."

    Disconnect-PnPOnline

} else {

    Write-Host "Error: One, some or all of the tenant url, url slug or template path variables were empty or null."

}