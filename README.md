# LiveStream VM Setup Sample #

This provides a sample ARM template and custom PowerShell script to install applications for live streaming via [Chocolatey](https://chocolatey.org/).


## Recommended Readings ##

* 한국어:
  * [초콜라티로 애저 VM 위에 라이브 스트리밍을 위한 애플리케이션 자동 설치하기](https://blog.aliencube.org/ko/2020/08/26/app-provisioning-on-azure-vm-with-chocolatey-for-live-streaming/)
  * [파워 플랫폼으로 일회성 애저 리소스 프로비저닝하기](https://blog.aliencube.org/ko/2020/09/02/ad-hoc-azure-resource-provisioning-via-power-platform/)
* English:
  * [Auto-installing Applications on Azure VM with Chocolatey for Live Streaming](https://devkimchi.com/2020/08/26/app-provisioning-on-azure-vm-with-chocolatey-for-live-streaming/)
  * [Ad-hoc Azure Resource Provisioning via Power Platform](https://devkimchi.com/2020/09/02/ad-hoc-azure-resource-provisioning-via-power-platform/)


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
