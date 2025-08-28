<#assign mixins = []>
<#if w.getGElementsOfType('biome')?filter(e -> e.spawnBiome || e.spawnInCaves || e.spawnBiomeNether)?size != 0>
	<#assign mixins = mixins + ['NoiseGeneratorSettingsMixin']>
</#if>
<#if w.hasElementsOfBaseType('item')>
	<#assign mixins = mixins + [JavaModName + 'RepairItemRecipeMixin']>
	<#assign mixins = mixins + ['EntitySwingMixin']>
	<#assign mixins = mixins + ['OnItemDroppedMixin']>
</#if>
<#if w.hasElementsOfType('attribute')>
    <#assign mixins = mixins + ['AttributeSupplierAccessor']>
</#if>
<#if w.hasElementsOfType('armor')>
    <#assign mixins = mixins + ['ArmorMixin']>
</#if>

{
  "required": true,
  "package": "${package}.mixin",
  "compatibilityLevel": "JAVA_21",
  "mixins": [
	<#list mixins as mixin>"${mixin}"<#sep>,</#list>
  ],
  "client": [
  ],
  "injectors": {
    "defaultRequire": 1
  },
  "minVersion": "0.8.4"
}