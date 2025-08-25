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

package ${package}.entity;

@Environment(EnvType.CLIENT) public class ${name}EntityProjectile extends AbstractArrow implements ItemSupplier {

	public static final ItemStack PROJECTILE_ITEM = ${mappedMCItemToItemStackCode(data.rangedAttackItem)};

	public ${name}EntityProjectile(EntityType<? extends ${name}EntityProjectile> type, Level world) {
		super(type, world);
	}

	public ${name}EntityProjectile(EntityType<? extends ${name}EntityProjectile> type, double x, double y, double z, Level world) {
		super(type, x, y, z, world, PROJECTILE_ITEM, null);
	}

	public ${name}EntityProjectile(EntityType<? extends ${name}EntityProjectile> type, LivingEntity entity, Level world) {
		super(type, entity, world, PROJECTILE_ITEM, null);
	}

	@Override protected void doPostHurtEffects(LivingEntity livingEntity) {
		super.doPostHurtEffects(livingEntity);
		livingEntity.setArrowCount(livingEntity.getArrowCount() - 1);
	}

	@Override public ItemStack getItem() {
		return PROJECTILE_ITEM;
	}

	@Override protected ItemStack getDefaultPickupItem() {
		return ${mappedMCItemToItemStackCode(data.rangedAttackItem)};
	}
}
<#-- @formatter:on -->