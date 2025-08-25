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
package ${package};

import org.apache.logging.log4j.Logger;
import org.apache.logging.log4j.LogManager;
import ${package}.init.*;

public class ${JavaModName} implements ModInitializer {

	public static final Logger LOGGER = LogManager.getLogger(${JavaModName}.class);

	public static final String MODID = "${modid}";

	@Override
	public void onInitialize() {
		// Start of user code block mod constructor
		// End of user code block mod constructor

		LOGGER.info("Initializing ${JavaModName}");

		<#if w.hasElementsOfType("tab")>${JavaModName}Tabs.load();</#if>
		<#if w.hasElementsOfType("gamerule")>${JavaModName}GameRules.load();</#if>
		<#if w.hasElementsOfType("potion")>${JavaModName}Potions.load();</#if>
		<#if w.hasElementsOfType("attribute")>${JavaModName}Attributes.load();</#if>
		<#if w.hasElementsOfBaseType("feature")>${JavaModName}Features.load();</#if>
		<#if w.getGElementsOfType("recipe")?filter(e -> e.recipeType == "Brewing")?size != 0>${JavaModName}BrewingRecipes.load();</#if>
		<#if w.hasElementsOfType("tab")>${JavaModName}Tabs.load();</#if>
		<#if w.hasElementsOfType("itemextension")>${JavaModName}ItemExtensions.load();</#if>
		<#if w.hasElementsOfType("procedure")>${JavaModName}Procedures.load();</#if>
		<#if w.getGElementsOfType("command")?filter(e -> e.type != "CLIENTSIDE")?size != 0>${JavaModName}Commands.load();</#if>
		<#if w.hasElementsOfType("potioneffect")>${JavaModName}MobEffects.load();</#if>
		<#if w.getGElementsOfType('biome')?filter(e -> e.hasVines() || e.hasFruits())?size != 0>${JavaModName}Biomes.load();</#if>
		<#if w.getGElementsOfType('biome')?filter(e -> e.spawnBiome || e.spawnInCaves || e.spawnBiomeNether)?size != 0>ServerLifecycleEvents.SERVER_STARTING.register(${JavaModName}Biomes::load);</#if>
		<#if w.hasElementsOfType("keybind")>${JavaModName}KeyMappingsServer.serverLoad();</#if>
		<#if w.hasElementsOfType("villagertrade")>${JavaModName}Trades.registerTrades();</#if>
		<#if w.hasElementsOfType("gui")>${JavaModName}Menus.load();</#if>
		
		<#if w.hasVariablesOfScope("GLOBAL_WORLD") || w.hasVariablesOfScope("GLOBAL_MAP")>
			PayloadTypeRegistry.playS2C().register(${JavaModName}Variables.SavedDataSyncMessage.TYPE, ${JavaModName}Variables.SavedDataSyncMessage.STREAM_CODEC);
			${JavaModName}Variables.SyncJoin();
			${JavaModName}Variables.SyncChangeWorld();
		</#if>

		// Start of user code block mod init
		// End of user code block mod init
	}

	// Start of user code block mod methods
	// End of user code block mod methods
}
<#-- @formatter:on -->