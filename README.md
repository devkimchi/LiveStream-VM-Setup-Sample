# LiveStream VM Setup Sample #

This provides a sample ARM template and custom PowerShell script to install applications for live streaming via [Chocolatey](https://chocolatey.org/).


## Recommended Readings ##

* 한국어: TBD
* ENglish: TBD


## Getting Started ##

Click the button below to deploy this VM directly onto your Azure Portal:

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fdevkimchi%2FLiveStream-VM-Setup-Sample%2Fmain%2Fazuredeploy.json)


## Applications to Be Installed via Chocolatey ##

* [Microsoft Edge](https://www.microsoft.com/edge?WT.mc_id=devkimchicom-github-juyoo)
* [OBS](https://obsproject.com/)
* [OBS NDI Plug-in](https://obsproject.com/forum/threads/obs-ndi-newtek-ndi%E2%84%A2-integration-into-obs-studio.69240/)
* [Skype for Content Creators](https://www.skype.com/en/content-creators)


## What's Not Covered &ndash; Configurations ##

* Each application needs to be configured individually for the first time use.


## Acknowledgements ##

This sample code was inspired by my colleagues, [Henk Boelman](https://twitter.com/hboelman) and [Frank Boucher](https://twitter.com/fboucheros).

* Henk's post: [Online meetups with OBS and Skype](https://www.henkboelman.com/articles/online-meetups-with-obs-and-skype/)
* Frank's post: [Don't install your software yourself](http://www.frankysnotes.com/2018/04/dont-install-your-software-yourself.html)
