<#--
 # This file is part of Fabric-Generator-MCreator.
 # Copyright (C) 2020-2025, Goldorion, opensource contributors
 #
 # Fabric-Generator-MCreator is free software: you can redistribute it and/or modify
 # it under the terms of the GNU Lesser General Public License as published by
 # the Free Software Foundation, either version 3 of the License, or
 # (at your option) any later version.

 # Fabric-Generator-MCreator is distributed in the hope that it will be useful,
 # but WITHOUT ANY WARRANTY; without even the implied warranty of
 # MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 # GNU Lesser General Public License for more details.
 #
 # You should have received a copy of the GNU Lesser General Public License
 # along with Fabric-Generator-MCreator. If not, see <https://www.gnu.org/licenses/>.
-->

<#-- @formatter:off -->
<#include "../procedures.java.ftl">

/*
 *	MCreator note: This file will be REGENERATED on each build.
 */

package ${package}.init;

public class ${JavaModName}Dimensions {

	public static void load() {
		<#compress>
		<#list dimensions as dimension>
			<#if dimension.enablePortal>
			    registerPOI("${dimension.getModElement().getRegistryName()}", ${JavaModName}Blocks.${dimension.getModElement().getRegistryNameUpper()}_PORTAL, ${dimension.getModElement().getName()}Teleporter.poi);
				<#if hasProcedure(dimension.onPlayerLeavesDimension) || hasProcedure(dimension.onPlayerEntersDimension) || dimension.useCustomEffects>
            		${dimension.getModElement().getName()}Dimension.load();
            	</#if>
			</#if>
		</#list>
		</#compress>
	}
	
	private static void registerPOI(String registryName, Block portalBlock, Holder<PoiType> poi) {
		PoiType poiType = new PoiType(ImmutableSet.copyOf(portalBlock.getStateDefinition().getPossibleStates()), 0, 1);
		Registry.register(BuiltInRegistries.POINT_OF_INTEREST_TYPE, ResourceLocation.parse("${modid}:" + registryName +  "_portal"), poiType);
		poi = BuiltInRegistries.POINT_OF_INTEREST_TYPE.wrapAsHolder(poiType);
	}
}
<#-- @formatter:on -->