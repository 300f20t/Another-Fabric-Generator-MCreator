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
<#include "../mcitems.ftl">
<#include "../procedures.java.ftl">

<#assign mx = (data.W - data.width) / 2>
<#assign my = (data.H - data.height) / 2>
<#assign slotnum = 0>

package ${package}.world.inventory;

import ${package}.${JavaModName};

public class ${name}Menu extends AbstractContainerMenu implements ${JavaModName}Menus.MenuAccessor {

	public final Map<String, Object> menuState = new HashMap<>() {
		@Override public Object put(String key, Object value) {
			<#-- Prevent arbitrary data storage beyond the menu state -->
			if (!this.containsKey(key) && this.size() >= ${data.components?size}) return null;
			return super.put(key, value);
		}
	};

	public final Level world;
	public final Player entity;
	public int x, y, z;
	private ContainerLevelAccess access = ContainerLevelAccess.NULL;

	private final Container inventory;

	private final Map<Integer, Slot> customSlots = new HashMap<>();

	public ${name}Menu(int id, Inventory inv, FriendlyByteBuf extraData) {
		this(id, inv, new SimpleContainer(${data.getMaxSlotID() + 1}));
		BlockPos pos = null;
		if (extraData != null) {
			pos = extraData.readBlockPos();
			this.x = pos.getX();
			this.y = pos.getY();
			this.z = pos.getZ();
		}
	}

	public ${name}Menu(int id, Inventory inv, Container container) {
		super(${JavaModName}Menus.${REGISTRYNAME}, id);

		this.entity = inv.player;
		this.world = inv.player.level();

		this.inventory = container;

		<#if data.type == 1>
			<#list data.components as component>
				<#if component.getClass().getSimpleName()?ends_with("Slot")>
					<#assign slotnum += 1>
	   				this.addSlot(new Slot(inventory, ${component.id}, ${(component.x - mx)?int + 1},
						${(component.y - my)?int + 1}) {
						private final int slot = ${component.id};


	   				<#if hasProcedure(component.disablePickup) || component.disablePickup.getFixedValue()>
						@Override public boolean mayPickup(Player entity) {
							return <@procedureOBJToConditionCode component.disablePickup false true/>;
						}
					</#if>

					<#if hasProcedure(component.onSlotChanged)>
						@Override public void setChanged() {
							super.setChanged();
							slotChanged(${component.id}, 0, 0);
						}
					</#if>

					<#if hasProcedure(component.onTakenFromSlot)>
						@Override public void onTake(Player entity, ItemStack stack) {
							super.onTake(entity, stack);
							slotChanged(${component.id}, 1, 0);
						}
					</#if>

					<#if hasProcedure(component.onStackTransfer)>
						@Override public void onQuickCraft(ItemStack a, ItemStack b) {
							super.onQuickCraft(a, b);
							slotChanged(${component.id}, 2, b.getCount() - a.getCount());
						}
					</#if>

					<#if component.getClass().getSimpleName() == "InputSlot">
						<#if hasProcedure(component.disablePlacement) || component.disablePlacement.getFixedValue()>
							@Override public boolean mayPlace(ItemStack itemstack) {
								return <@procedureOBJToConditionCode component.disablePlacement false true/>;
							}
						<#elseif component.inputLimit.toString()?has_content>
							@Override public boolean mayPlace(ItemStack stack) {
								<#if component.inputLimit.getUnmappedValue().startsWith("TAG:")>
									<#assign tag = "\"" + component.inputLimit.getUnmappedValue().replace("TAG:", "") + "\"">
									return stack.is(TagKey.create(Registries.ITEM, ResourceLocation.parse(${tag})));
								<#else>
									return ${mappedMCItemToItem(component.inputLimit)} == stack.getItem();
								</#if>
							}
						</#if>
					<#elseif component.getClass().getSimpleName() == "OutputSlot">
						@Override public boolean mayPlace(ItemStack stack) {
							return false;
						}
					</#if>
					});
				</#if>
			</#list>

			<#assign coffx = ((data.width - 176) / 2 + data.inventoryOffsetX)?int>
			<#assign coffy = ((data.height - 166) / 2 + data.inventoryOffsetY)?int>

			for (int si = 0; si < 3; ++si)
				for (int sj = 0; sj < 9; ++sj)
					this.addSlot(new Slot(inv, sj + (si + 1) * 9, ${coffx} + 8 + sj * 18, ${coffy}+ 84 + si * 18));

			for (int si = 0; si < 9; ++si)
				this.addSlot(new Slot(inv, si, ${coffx} + 8 + si * 18, ${coffy} + 142));
		</#if>

		<#if hasProcedure(data.onOpen)>
		   <@procedureOBJToCode data.onOpen/>
		</#if>
	}

	@Override public boolean stillValid(Player player) {
		return this.inventory.stillValid(player);
	}

	<#if data.type == 1>
		@Override public ItemStack quickMoveStack(Player playerIn, int index) {
			ItemStack itemstack = ItemStack.EMPTY;
			Slot slot = (Slot) this.slots.get(index);

			if (slot != null && slot.hasItem()) {
				ItemStack itemstack1 = slot.getItem();
				itemstack = itemstack1.copy();

				if (index < ${slotnum}) {
					if (!this.moveItemStackTo(itemstack1, ${slotnum}, this.slots.size(), true))
						return ItemStack.EMPTY;
					slot.onQuickCraft(itemstack1, itemstack);
				} else if (!this.moveItemStackTo(itemstack1, 0, ${slotnum}, false)) {
					if (index < ${slotnum} + 27) {
						if (!this.moveItemStackTo(itemstack1, ${slotnum} + 27, this.slots.size(), true))
							return ItemStack.EMPTY;
					} else {
						if (!this.moveItemStackTo(itemstack1, ${slotnum}, ${slotnum} + 27, false))
							return ItemStack.EMPTY;
					}
					return ItemStack.EMPTY;
				}

				if (itemstack1.isEmpty())
					slot.setByPlayer(ItemStack.EMPTY);
				else
					slot.setChanged();

				if (itemstack1.getCount() == itemstack.getCount())
					return ItemStack.EMPTY;

				slot.onTake(playerIn, itemstack1);
			}
			return itemstack;
		}

		<#-- #47997 -->
		@Override ${mcc.getMethod("net.minecraft.world.inventory.AbstractContainerMenu", "moveItemStackTo", "ItemStack", "int", "int", "boolean")
			.replace("itemStack", "itemstack")
			.replace("slot.setChanged();", "slot.set(itemstack);")}

		@Override public void removed(Player playerIn) {
			super.removed(playerIn);

			<#if hasProcedure(data.onClosed)>
				<@procedureOBJToCode data.onClosed/>
			</#if>
		}

		<#if data.hasSlotEvents()>
			private void slotChanged(int slotid, int ctype, int meta) {
				if(this.world != null && this.world.isClientSide()) {
					ClientPlayNetworking.send(new ${name}SlotMessage(slotid, x, y, z, ctype, meta));
				}
			}
		</#if>
	<#else>
		@Override public ItemStack quickMoveStack(Player playerIn, int index) {
			return ItemStack.EMPTY;
		}
		<#if hasProcedure(data.onClosed)>
			@Override public void removed(Player playerIn) {
				super.removed(playerIn);
				<@procedureOBJToCode data.onClosed/>
			}
		</#if>
	</#if>

	@Override public Map<Integer, Slot> getSlots() {
		return Collections.unmodifiableMap(customSlots);
	}

	@Override public Map<String, Object> getMenuState() {
		return menuState;
	}

	public static void screenInit() {
		<#assign btid = 0>
		<#assign stid = 0>
		<#list data.components as component>
			<#if component.getClass().getSimpleName() == "Button" ||  component.getClass().getSimpleName() == "ImageButton">
				<#if hasProcedure(component.onClick)>
					ServerPlayNetworking.registerGlobalReceiver(${name}ButtonMessage.TYPE, ${name}ButtonMessage::apply);
				</#if>
				<#assign btid +=1>
			<#elseif component.getClass().getSimpleName()?ends_with("Slot")>
				<#if hasProcedure(component.onSlotChanged) || hasProcedure(component.onTakenFromSlot) || hasProcedure(component.onStackTransfer)>
					PayloadTypeRegistry.playC2S().register(${name}SlotMessage.TYPE, ${name}SlotMessage.STREAM_CODEC);
					ServerPlayNetworking.registerGlobalReceiver(${name}SlotMessage.TYPE, ${name}SlotMessage::apply);
				</#if>
				<#assign stid +=1>
			</#if>
		</#list>
	}
}
<#-- @formatter:on -->