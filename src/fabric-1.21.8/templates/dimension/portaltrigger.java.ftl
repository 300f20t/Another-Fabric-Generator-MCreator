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
<#include "../triggers.java.ftl">

package ${package}.item;

public class ${name}Item extends Item {

	public ${name}Item(Item.Properties properties) {
		super(properties
			<#if data.igniterRarity != "COMMON">.rarity(Rarity.${data.igniterRarity})</#if>
			.durability(64)
		);
	}

	<@addSpecialInformation data.specialInformation, "item." + modid + "." + registryname/>

	@Override public InteractionResult useOn(UseOnContext context) {
		Player entity = context.getPlayer();
		BlockPos pos = context.getClickedPos().relative(context.getClickedFace());
		ItemStack itemstack = context.getItemInHand();
		Level world = context.getLevel();
		if (!entity.mayUseItemAt(pos, context.getClickedFace(), itemstack)) {
			return InteractionResult.FAIL;
		} else {
			int x = pos.getX();
			int y = pos.getY();
			int z = pos.getZ();
			boolean success = false;

			if (world.isEmptyBlock(pos) && <@procedureOBJToConditionCode data.portalMakeCondition/>) {
				${name}PortalBlock.portalSpawn(world, pos);
				itemstack.hurtAndBreak(1, entity, LivingEntity.getSlotForHand(context.getHand()));
				success = true;
			}

			<#if hasProcedure(data.whenPortaTriggerlUsed)>
				<#if hasReturnValueOf(data.whenPortaTriggerlUsed, "actionresulttype")>
					InteractionResult result = <@procedureOBJToInteractionResultCode data.whenPortaTriggerlUsed/>;
					return success ? InteractionResult.SUCCESS : result;
				<#else>
					<@procedureOBJToCode data.whenPortaTriggerlUsed/>
					return InteractionResult.SUCCESS;
				</#if>
			<#else>
				return success ? InteractionResult.SUCCESS : InteractionResult.FAIL;
			</#if>
		}
	}
}

<#-- @formatter:on -->