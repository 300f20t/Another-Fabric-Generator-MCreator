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

public class PlayerEvents {

	public static final Event<TickEnd> END_PLAYER_TICK = EventFactory.createArrayBacked(TickEnd.class, (callbacks) -> (entity) -> Arrays.stream(callbacks).forEach(callback -> callback.onEndTick(entity)));
	public static final Event<XPChange> XP_CHANGE = EventFactory.createArrayBacked(XPChange.class, (callbacks) -> (entity, amount) -> Arrays.stream(callbacks).forEach(callback -> callback.onXpChange(entity, amount)));
	public static final Event<LevelChange> LEVEL_CHANGE = EventFactory.createArrayBacked(LevelChange.class, (callbacks) -> (entity, amount) -> Arrays.stream(callbacks).forEach(callback -> callback.onLevelChange(entity, amount)));

	@FunctionalInterface
	public interface TickEnd {
		void onEndTick(Player player);
	}

	@FunctionalInterface
	public interface XPChange {
		void onXpChange(Player player, int amount);
	}

	@FunctionalInterface
	public interface LevelChange {
		void onLevelChange(Player player, int amount);
	}
}
<#-- @formatter:on -->