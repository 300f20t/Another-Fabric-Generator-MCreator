<#assign mineableblocks = []>
<#list blocks as block>
</#list>

{
	"replace": false,
	"values": [<#list mineableblocks as block>"${generator.getResourceLocationForModElement(block.getModElement())}"<#if block?has_next>,</#if></#list>]
}