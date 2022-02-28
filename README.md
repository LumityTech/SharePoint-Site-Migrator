# Sharepoint Template Scripts 

## Overview 

This repo contains scripts and configuration files to copy a Sharepoint Online site to another site. 
The project heavily leverages the PNP Sharepoint powershell package/cmdlet to automate tasks. 

As of Feb 2022, there is no way to easily apply templates to SPO sites natively within SPO. Hence the creation of this project.

## Structure

- Export-SPOPageTemplateAsXML.ps1

A Powershell script used to handle exporting an existing SPO site as a template. The process utilizes the Powershell PNP SP package to pull the site assets stored on the site and generate an XML file representing the site template. 

- Invoke-POPageTemplateXML.ps1

A Powershell script use to handle applying a SPO page XML template. The process specifically requires the export script to have been run prior, the template generated is then used by the invoke script. 

- SPPNPConfigExtraction.json

A JSON file that includes the configuration options when running the export script. This JSON file is dictated by Microsoft and specifies the handlers and handler options to run, when performing the template retrieval on your SPO site tenant.
Details on the JSON file and its standard here: https://aka.ms/sppnp-extract-configuration-schema

- assets Folder

Here, all site assets are stored. ideally, naming should be preserved from project, but you can replace these files with your own branding files.

- template Folder

Here, the template files and folders are created and stored during the export script run. You can manually delete the contents of this folder after you applied a template safely (i.e. after the full guide has been followed in the 'Templating Guide')


## How to use

### Before Starting 

- Ensure the scripts and folders are in the following structure:

```
scripts
|   Export
|   Invoke
|   SPPNPConfigExtraction.json
|
└───template
|
└───assets
    |
    └───SiteAssets
        branding materials here

```

- Ensure you have access to your SPO tenant site with admin credentials

- Ensure you have access to a terminal or IDE to run the ps scripts

- Terminal administrator rights shouldn't be required

- Replace the site assets files in the assets folder with your prefered branding/imagery. Ensure the naming of the files is preserved, exactly. Or remove them if you'd like no logos and headers added/altered (note: this may incur errors in the terminal during run time but these shouldnt be an issue).

### Templating Process

1. Alter the variables at the top of the export script where required. You should only need to update the $url variable if you have copied the project. The $url variable is the URL to the site you wish to create a template out of. 

2. Run the export script, allow auth as requested.

3. Ensure you address any errors encountered as a result. Note that if you have moved files (i.e. especially the asset files) or renamed things after copying the project, you may need to reflect these changes in the script.

4. Alter the variables at the top of the invoke script where required. You should only need to update the $tenantUrl and $siteUrlSlug varibles. Such that the $tenantUrl variable reflects the url to your tenant site and the $siteUrlSlug matches the relative path to the SPO site you wish to apply the template to.

5. If you altered the assets files in the asset folder, you will need to update the relative web urls specified in the $headerlogo, $headerBackground and $footerlogo vars to match. 

6. Ensure you have created another site to which you would like the template applied on your tenant. Furthermore, it is **very important** that the new site is of the same type as the site the template was taken from (i.e. Teams or Communication site). You will need the url address of the new site, once you have created it.  

7. Run the invoke script, allow auth as requested. 

8. Address any errors in the terminal and if all runs well, inspect the new site to ensure the template as applied correctly.

## Caveats

### Teams sites vs Communications

The variations in site types between team sites and communication sites means that both need to be handled differently when invoking a template. 
The invoke script will auto handle applying templates to these two site types. 
It's important to note though however: 

- The invoke script will test to ensure the template and target site types match. 
- invoke compares the Template ID for the tempalte and target site, these IDs are discussed in this document: https://vladtalkstech.com/2019/12/sharepoint-online-site-template-id-list-for-powershell.html
- Currently, when creating new sites, you have the option of creating a Team site (ID: GROUP#0) or Communication Site (ID: SITEPAGEPUBLISHING#0). You need to ensure that the template you export and the type of the site you wish to target have matching types. 
- If the site types don't match, the script will still attempt to apply the template to the target site as best it can. 
- Depending on whether the target site is detected to be a teams or communications site, the template application and features applied will be different. 

Variance in template application: 

- Team sites will not have a footer applied as footers are not supported for teams sites by SPO. 
- For teams sites, I've used the footerlogo instead of the headerlogo; you can alter this in the script. 
- Team sites headers are set to a Standard display, rather than Extended; this is my own preference, you can update this as required. 

### Naming of branding assets

The naming of the brand assets is quite important, SPO recognizes certain prefixes for files for registering branding siteassets, such as logos, etc.

You include the following 4 image files to be used by the site template applicator to include logos and headers on your target SP site: 
1. __extendedHeaderBackgroundImage__headerBanner.png
2. __footerlogo__footerLogo.png
3. __rectSitelogo__headerLogo.png (Used for the logo rest on the banner)
4. __siteLogo__headerLogo.png (Used for thumbnails and other logos throughout, that are not the footer or Banner logo)

Note: 

You dont need to include these files if you would prefer SP to just use defaults. 

Furthermore, ensure that the naming scheme is maintained, i.e. '__siteLogo_<filename>.png'.
If you decide to alter the <filename> you will need to adjust both of the scripts to match. Note that the prefix, i.e. __siteLogo__' needs to be maintained per file as these prefixes are used by SP to identify specific branding assets.
For information on sizing limitations for these files, see: [here](https://support.microsoft.com/en-us/office/image-sizing-and-scaling-in-sharepoint-modern-pages-dc510065-b5a5-4654-bc94-e3ecbbb57d8d)
