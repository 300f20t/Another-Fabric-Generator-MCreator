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
<#include "../procedures.java.ftl">

<#assign itemsWithEntitySwing = []>
<#list w.getGElementsOfType("item") as item>
    <#if hasProcedure(item.onEntitySwing)>
    <#assign itemsWithEntitySwing += [item]>
    </#if>
</#list>
<#list w.getGElementsOfType("tool") as tool>
    <#if hasProcedure(tool.onEntitySwing)>
    <#assign itemsWithEntitySwing += [tool]>
    </#if>
</#list>

package ${package}.mixin;

@Mixin(LivingEntity.class)
public abstract class LivingEntityMixin {
	@Inject(method = "swing(Lnet/minecraft/world/InteractionHand;Z)V", at = @At("HEAD"))
	public void swing(InteractionHand hand, boolean updateSelf, CallbackInfo ci) {
		ItemStack stack = ((LivingEntity) (Object) this).getItemInHand(hand);
		if (!stack.isEmpty()) {
		<#list itemsWithEntitySwing as item>
			if (stack.getItem() instanceof ${item.getModElement().getName()}Item)
				((${item.getModElement().getName()}Item)stack.getItem()).onEntitySwing(stack, (LivingEntity) (Object) this, hand);
		</#list>
		}
	}
	
	@Inject(method = "startUsingItem(Lnet/minecraft/world/InteractionHand;)V", at = @At("HEAD"))
	public void startUsingItem(InteractionHand hand, CallbackInfo ci) {
		LivingEntity entity = (LivingEntity) (Object) this;
		ItemStack stack = entity.getItemInHand(hand);
		if (!stack.isEmpty() && !entity.isUsingItem()) {
			LivingEntityEvents.START_USE_ITEM.invoker().onStartUseItem(entity, stack);
		}
	}
}
<#-- @formatter:on -->