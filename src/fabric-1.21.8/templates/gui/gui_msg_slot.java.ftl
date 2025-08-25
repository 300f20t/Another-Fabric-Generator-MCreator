<#--
 # This file is part of Fabric-Generator-MCreator.
 # Copyright (C) 2012-2020, Pylo
 # Copyright (C) 2020-2025, Pylo, opensource contributors
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

package ${package}.network;

public record ${name}SlotMessage(int slotID, int x, int y, int z, int changeType, int meta) implements CustomPacketPayload {

	public static final Type<${name}SlotMessage> TYPE = new Type<>(ResourceLocation.fromNamespaceAndPath(${JavaModName}.MODID, "${registryname}_slots"));

	public static final StreamCodec<RegistryFriendlyByteBuf, ${name}SlotMessage> STREAM_CODEC = StreamCodec.of(
			(RegistryFriendlyByteBuf buffer, ${name}SlotMessage message) -> {
				buffer.writeInt(message.slotID);
				buffer.writeInt(message.x);
				buffer.writeInt(message.y);
				buffer.writeInt(message.z);
				buffer.writeInt(message.changeType);
				buffer.writeInt(message.meta);
			},
			(RegistryFriendlyByteBuf buffer) -> new ${name}SlotMessage(buffer.readInt(), buffer.readInt(), buffer.readInt(), buffer.readInt(), buffer.readInt(), buffer.readInt())
	);

	@Override public Type<${name}SlotMessage> type() {
		return TYPE;
	}

	public static void apply(${name}SlotMessage payload, ServerPlayNetworking.Context context) {
		int slot = payload.slotID();
		int x = payload.x();
		int y = payload.y();
		int z = payload.z();
		int changeType = payload.changeType();
		int meta = payload.meta();
		Entity entity = context.player();
		Level world = entity.level();

		context.server().execute(() -> {
			// security measure to prevent arbitrary chunk generation
			if (!world.hasChunkAt(new BlockPos(x, y, z)))
				return;

			<#list data.components as component>
				<#if component.getClass().getSimpleName()?ends_with("Slot")>
					<#if hasProcedure(component.onSlotChanged)>
						if (slot == ${component.id} && changeType == 0) {
							<@procedureOBJToCode component.onSlotChanged/>
						}
					</#if>
					<#if hasProcedure(component.onTakenFromSlot)>
						if (slot == ${component.id} && changeType == 1) {
							int amount = meta;
							<@procedureOBJToCode component.onTakenFromSlot/>
						}
					</#if>
					<#if hasProcedure(component.onStackTransfer)>
						if (slot == ${component.id} && changeType == 2) {
							int amount = meta;
							<@procedureOBJToCode component.onStackTransfer/>
						}
					</#if>
				</#if>
			</#list>
		});
	}
}
<#-- @formatter:on -->
