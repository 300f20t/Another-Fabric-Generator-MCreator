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
package ${package}.mixin;

@Mixin(Player.class)
public abstract class PlayerMixin {

	@Inject(method = {"tick"}, at = @At("TAIL"))
	private void tick(CallbackInfo ci) {
		PlayerEvents.END_PLAYER_TICK.invoker().onEndTick((Player) (Object) this);
	}

	@Inject(method = {"giveExperiencePoints(I)V"}, at = @At("HEAD"))
	private void giveExperiencePoints(int amount, CallbackInfo ci) {
		PlayerEvents.XP_CHANGE.invoker().onXpChange((Player) (Object) this, amount);
	}

	@Inject(method = {"giveExperienceLevels(I)V"}, at = @At("HEAD"))
	private void giveExperienceLevels(int amount, CallbackInfo ci) {
		PlayerEvents.LEVEL_CHANGE.invoker().onLevelChange((Player) (Object) this, amount);
	}
}
<#-- @formatter:on -->