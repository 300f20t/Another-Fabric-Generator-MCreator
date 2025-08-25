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
package ${package}.network;

import ${package}.${JavaModName};

import net.minecraft.nbt.Tag;

public class ${JavaModName}Variables {

	<#if w.hasVariablesOfScope("GLOBAL_SESSION")>
		<#list variables as var>
			<#if var.getScope().name() == "GLOBAL_SESSION">
				<@var.getType().getScopeDefinition(generator.getWorkspace(), "GLOBAL_SESSION")['init']?interpret/>
			</#if>
		</#list>
	</#if>

	<#if w.hasVariablesOfScope("GLOBAL_WORLD") || w.hasVariablesOfScope("GLOBAL_MAP")>

		<#if w.hasVariablesOfScope("GLOBAL_WORLD") || w.hasVariablesOfScope("GLOBAL_MAP")>
		public static void SyncJoin() {
			ServerEntityEvents.ENTITY_LOAD.register((entity, world) -> {
				if (entity instanceof Player) {
					if (!world.isClientSide()) {
						SavedData mapdata = MapVariables.get(world);
						SavedData worlddata = WorldVariables.get(world);
					}
				}
			});
		}

		public static void SyncChangeWorld() {
			ServerEntityWorldChangeEvents.AFTER_PLAYER_CHANGE_WORLD.register((player, origin, destination) -> {
				if (!destination.isClientSide()) {
					SavedData worlddata = WorldVariables.get(destination);
				}
			});
		}
		</#if>
	</#if>

	<#if w.hasVariablesOfScope("GLOBAL_WORLD") || w.hasVariablesOfScope("GLOBAL_MAP")>
	public static class WorldVariables extends SavedData {

		public static final SavedDataType<WorldVariables> TYPE = new SavedDataType<>("${modid}_worldvars", ctx -> new WorldVariables(),
			ctx -> CompoundTag.CODEC.xmap(
				tag -> {
					WorldVariables instance = new WorldVariables();
					instance.read(tag, ctx.levelOrThrow().registryAccess());
					return instance;
				},
				instance -> instance.save(new CompoundTag(), ctx.levelOrThrow().registryAccess())
			), null
		);

		<#list variables as var>
			<#if var.getScope().name() == "GLOBAL_WORLD">
				<@var.getType().getScopeDefinition(generator.getWorkspace(), "GLOBAL_WORLD")['init']?interpret/>
			</#if>
		</#list>

		public void read(CompoundTag nbt, HolderLookup.Provider lookupProvider) {
			<#list variables as var>
				<#if var.getScope().name() == "GLOBAL_WORLD">
					<@var.getType().getScopeDefinition(generator.getWorkspace(), "GLOBAL_WORLD")['read']?interpret/>
				</#if>
			</#list>
		}

		public CompoundTag save(CompoundTag nbt, HolderLookup.Provider lookupProvider) {
			<#list variables as var>
				<#if var.getScope().name() == "GLOBAL_WORLD">
					<@var.getType().getScopeDefinition(generator.getWorkspace(), "GLOBAL_WORLD")['write']?interpret/>
				</#if>
			</#list>
			return nbt;
		}

		public void syncData(LevelAccessor world) {
			this.setDirty();

			if (world instanceof ServerLevel level)
				level.players().forEach(player -> ServerPlayNetworking.send(player, new SavedDataSyncMessage(1, this)));
		}

		static WorldVariables clientSide = new WorldVariables();

		public static WorldVariables get(LevelAccessor world) {
			if (world instanceof ServerLevel level) {
				return level.getDataStorage().computeIfAbsent(WorldVariables.TYPE);
			} else {
				return clientSide;
			}
		}

	}

	public static class MapVariables extends SavedData {

		public static final SavedDataType<MapVariables> TYPE = new SavedDataType<>("${modid}_mapvars", ctx -> new MapVariables(),
			ctx -> CompoundTag.CODEC.xmap(
				tag -> {
					MapVariables instance = new MapVariables();
					instance.read(tag, ctx.levelOrThrow().registryAccess());
					return instance;
				},
				instance -> instance.save(new CompoundTag(), ctx.levelOrThrow().registryAccess())
			), null
		);

		<#list variables as var>
			<#if var.getScope().name() == "GLOBAL_MAP">
				<@var.getType().getScopeDefinition(generator.getWorkspace(), "GLOBAL_MAP")['init']?interpret/>
			</#if>
		</#list>

		public void read(CompoundTag nbt, HolderLookup.Provider lookupProvider) {
			<#list variables as var>
				<#if var.getScope().name() == "GLOBAL_MAP">
					<@var.getType().getScopeDefinition(generator.getWorkspace(), "GLOBAL_MAP")['read']?interpret/>
				</#if>
			</#list>
		}

		public CompoundTag save(CompoundTag nbt, HolderLookup.Provider lookupProvider) {
			<#list variables as var>
				<#if var.getScope().name() == "GLOBAL_MAP">
					<@var.getType().getScopeDefinition(generator.getWorkspace(), "GLOBAL_MAP")['write']?interpret/>
				</#if>
			</#list>
			return nbt;
		}

		public void syncData(LevelAccessor world) {
			this.setDirty();

			if (world instanceof ServerLevel level && !world.isClientSide())
				PlayerLookup.world(level).forEach(player -> ServerPlayNetworking.send(player, new SavedDataSyncMessage(0, this)));
		}

		static MapVariables clientSide = new MapVariables();

		public static MapVariables get(LevelAccessor world) {
			if (world instanceof ServerLevelAccessor serverLevelAccessor) {
				return serverLevelAccessor.getLevel().getServer().getLevel(Level.OVERWORLD).getDataStorage().computeIfAbsent(MapVariables.TYPE);
			} else {
				return clientSide;
			}
		}

	}

	public record SavedDataSyncMessage(int dataType, SavedData data) implements CustomPacketPayload {

		public static final Type<SavedDataSyncMessage> TYPE = new Type<>(ResourceLocation.fromNamespaceAndPath(${JavaModName}.MODID, "saved_data_sync"));

		public static final StreamCodec<RegistryFriendlyByteBuf, SavedDataSyncMessage> STREAM_CODEC = StreamCodec.of(
			(RegistryFriendlyByteBuf buffer, SavedDataSyncMessage message) -> {
				buffer.writeInt(message.dataType);
				if (message.data instanceof MapVariables mapVariables)
					buffer.writeNbt(mapVariables.save(new CompoundTag(), buffer.registryAccess()));
				else if (message.data instanceof WorldVariables worldVariables)
					buffer.writeNbt(worldVariables.save(new CompoundTag(), buffer.registryAccess()));
			},
			(RegistryFriendlyByteBuf buffer) -> {
				int dataType = buffer.readInt();
				CompoundTag nbt = buffer.readNbt();
				SavedData data = null;
				if (nbt != null) {
					data = dataType == 0 ? new MapVariables() : new WorldVariables();
					if(data instanceof MapVariables mapVariables)
						mapVariables.read(nbt, buffer.registryAccess());
					else if(data instanceof WorldVariables worldVariables)
						worldVariables.read(nbt, buffer.registryAccess());
				}
				return new SavedDataSyncMessage(dataType, data);
			}
		);

		@Override public Type<SavedDataSyncMessage> type() {
			return TYPE;
		}

		public static void handleData(final SavedDataSyncMessage message, final ClientPlayNetworking.Context context) {
			context.client().execute(() -> {
				if (message.dataType == 0)
					MapVariables.clientSide.read(((MapVariables) message.data).save(new CompoundTag(), context.player().registryAccess()), context.player().registryAccess());
				else
					WorldVariables.clientSide.read(((WorldVariables) message.data).save(new CompoundTag(), context.player().registryAccess()), context.player().registryAccess());
			});
		}
	}
	</#if>
}
<#-- @formatter:on -->