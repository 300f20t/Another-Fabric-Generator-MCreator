<#-- @formatter:off -->
{
  "schemaVersion": 1,
  "id": "${settings.getModID()}",
  "version": "${settings.getCleanVersion()}",

  "name": "${JavaConventions.escapeStringForJava(settings.getModName())}",
<#if settings.getDescription()?has_content>
  "description": "${JavaConventions.escapeStringForJava(settings.getDescription())}",
</#if>
<#if settings.getAuthor()?has_content>
  "authors": [
	"${JavaConventions.escapeStringForJava(settings.getAuthor())}"
  ],
</#if>
<#if settings.getWebsiteURL()?has_content>
  "contact": {
	"homepage": "${JavaConventions.escapeStringForJava(settings.getWebsiteURL())}",
	"sources": ""
  },
</#if>
  "license": "${settings.getLicense()}",
<#if settings.getModPicture()?has_content>
  "icon": "assets/${modid}/icon.png",
</#if>
  "environment": "*",
  "entrypoints": {
	"main": [
	  "${package}.${JavaModName}"
	],
	"client":[
	  "${package}.ClientInit"
	]
  },
  "depends": {
	"fabricloader": ">=0.17.2",
	"fabric": "*",
	"minecraft": "~1.21",
	"java": ">=21"
  }
}
<#-- @formatter:on -->
