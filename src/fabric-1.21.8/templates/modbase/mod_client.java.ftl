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

@Environment(EnvType.CLIENT) public class ${JavaModName}Client implements ClientModInitializer {

	@Override
	public void onInitializeClient() {
		// Start of user code block mod constructor
		// End of user code block mod constructor

		<#if w.getGElementsOfType("command")?filter(e -> e.type == "CLIENTSIDE")?size != 0>${JavaModName}Commands.clientLoad();</#if>
		<#if w.hasElementsOfType("keybind")>${JavaModName}KeyMappings.clientLoad();</#if>
		<#if w.hasElementsOfType("overlay")>${JavaModName}Overlays.clientLoad();</#if>
		<#if w.hasElementsOfType("gui")>${JavaModName}Screens.clientLoad();</#if>
		<#if w.hasJavaModels()>${JavaModName}Models.clientLoad();</#if>
		<#if w.hasElementsOfBaseType("entity")>${JavaModName}EntityRenderers.clientLoad();</#if>
		<#if w.hasElementsOfType("particle")>${JavaModName}Particles.clientLoad();</#if>
		<#if w.hasElementsOfBaseType("block")>${JavaModName}BlocksRenderers.clientLoad();</#if>
		<#if w.hasElementsOfType("fluid")>${JavaModName}Fluids.clientLoad();</#if>

		<#if w.hasVariablesOfScope("GLOBAL_WORLD") || w.hasVariablesOfScope("GLOBAL_MAP")>
			ClientPlayNetworking.registerGlobalReceiver(${JavaModName}Variables.SavedDataSyncMessage.TYPE, ${JavaModName}Variables.SavedDataSyncMessage::handleData);
		</#if>

		// Start of user code block mod init
		// End of user code block mod init
	}

	// Start of user code block mod methods
	// End of user code block mod methods
}
<#-- @formatter:on -->