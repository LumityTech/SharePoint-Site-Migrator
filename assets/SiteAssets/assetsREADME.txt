You include the following 4 image files to be used by the site template applicator to include logos and headers on your target SP site: 
1. __extendedHeaderBackgroundImage__headerBanner.png
2. __footerlogo__footerLogo.png
3. __rectSitelogo__headerLogo.png (Used for the logo rest on the banner)
4. __siteLogo__headerLogo.png (Used for thumbnails and other logos throughout, that are not the footer or Banner logo)

Note: 

You dont need to include these files if you would prefer SP to just use defaults. 

Furthermore, ensure that the naming scheme is maintained, i.e. '__siteLogo_<filename>.png'.
If you decide to alter the <filename> you will need to adjust both of the scripts to match. Note that the prefix, i.e. __siteLogo__' needs to be maintained per file as these prefixes are used by SP to identify specific branding assets.
For information on sizing limitations for these files, see: https://support.microsoft.com/en-us/office/image-sizing-and-scaling-in-sharepoint-modern-pages-dc510065-b5a5-4654-bc94-e3ecbbb57d8d
