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
 # along with Fabric-Generator-MCreator.  If not, see <https://www.gnu.org/licenses/>.
-->
<#-- @formatter:off -->
package ${package}.event;

public class LivingEntityEvents {

	public static final Event<StartUseItem> START_USE_ITEM = EventFactory.createArrayBacked(StartUseItem.class, (callbacks) -> (entity, itemstack) -> Arrays.stream(callbacks).forEach(callback -> callback.onStartUseItem(entity, itemstack)));
	public static final Event<EntityHeal> ENTITY_HEAL = EventFactory.createArrayBacked(EntityHeal.class, (callbacks) -> (entity, amount) -> Arrays.stream(callbacks).allMatch(event -> event.onEntityHeal(entity, amount)));
    public static final Event<EntityBlock> ENTITY_BLOCK = EventFactory.createArrayBacked(EntityBlock.class, (callbacks) -> (entity, damagesource, amount) -> Arrays.stream(callbacks).allMatch(event -> event.onEntityBlock(entity, damagesource, amount)));

	@FunctionalInterface
	public interface StartUseItem {
		void onStartUseItem(Entity entity, ItemStack itemstack);
	}

	@FunctionalInterface
	public interface EntityHeal {
		boolean onEntityHeal(Entity entity, float amount);
	}

	@FunctionalInterface
	public interface EntityBlock {
		boolean onEntityBlock(Entity entity, DamageSource damagesource, double amount);
	}
		
}
<#-- @formatter:on -->