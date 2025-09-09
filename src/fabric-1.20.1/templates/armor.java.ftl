<#--
 # This file is part of Fabric-Generator-MCreator.
 # Copyright (C) 2012-2020, Pylo
 # Copyright (C) 2020-2023, Pylo, opensource contributors
 # Copyright (C) 2020-2023, Goldorion, opensource contributors
 #
 # Fabric-Generator-MCreator is free software: you can redistribute it and/or modify
 # it under the terms of the GNU Lesser General Public License as published by
 # the Free Software Foundation, either version 3 of the License, or
 # (at your option) any later version.
 #
 # Fabric-Generator-MCreator is distributed in the hope that it will be useful,
 # but WITHOUT ANY WARRANTY; without even the implied warranty of
 # MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 # GNU Lesser General Public License for more details.
 #
 # You should have received a copy of the GNU Lesser General Public License
 # along with Fabric-Generator-MCreator.  If not, see <https://www.gnu.org/licenses/>.
-->

<#-- @formatter:off -->
<#include "mcitems.ftl">
<#include "procedures.java.ftl">
<#include "triggers.java.ftl">

<#assign tabMap = w.getCreativeTabMap()>
<#assign vanillaTabs = tabMap.keySet()?filter(e -> !e?starts_with('CUSTOM:'))>
<#assign customTabs = tabMap.keySet()?filter(e -> e?starts_with('CUSTOM:'))>

<#-- Helpers -->
<#function _norm s>
  <#return (s?upper_case)?replace("^CUSTOM:", "", "r")?replace("[^A-Z0-9]", "", "r")>
</#function>

<#function _const s>
  <#return (s)?replace("^CUSTOM:", "", "r")?upper_case?replace("[^A-Z0-9]", "_", "r")>
</#function>

<#function _match tabElement piece>
  <#local e = _norm(tabElement)>
  <#local base = _norm(name)>

  <#if piece == "HELMET">
    <#return e == base || e == base + "HELMET">
  <#elseif piece == "CHESTPLATE">
    <#return e == base + "CHESTPLATE" || e == base + "BODY">
  <#elseif piece == "LEGGINGS">
    <#return e == base + "LEGGINGS" || e == base + "LEGS">
  <#elseif piece == "BOOTS">
    <#return e == base + "BOOTS">
  </#if>

  <#return false>
</#function>

package ${package}.item;

import net.minecraft.sounds.SoundEvent;
import net.fabricmc.api.Environment;

public abstract class ${name}Item extends ArmorItem {

	public ${name}Item(Type type, Item.Properties properties) {
		super(new ArmorMaterial() {
			@Override public int getDurabilityForType(Type type) {
				return new int[]{13, 15, 16, 11}[type.getSlot().getIndex()] * ${data.maxDamage};
			}

			@Override public int getDefenseForType(Type type) {
				return new int[] { ${data.damageValueBoots}, ${data.damageValueLeggings}, ${data.damageValueBody}, ${data.damageValueHelmet} }[type.getSlot().getIndex()];
			}

			@Override public int getEnchantmentValue() {
				return ${data.enchantability};
			}

			@Override public SoundEvent getEquipSound() {
				<#if data.equipSound.getMappedValue()?has_content>
					<#if data.equipSound.getUnmappedValue().startsWith("CUSTOM:")>
						return ${JavaModName}Sounds.${data.equipSound?replace(modid + ":", "")?upper_case};
					<#else>
					<#assign s=data.equipSound>
						return BuiltInRegistries.SOUND_EVENT.get(new ResourceLocation("${s}"));
					</#if>
				<#else>
					return null;
				</#if>
			}

			@Override public Ingredient getRepairIngredient() {
				return ${mappedMCItemsToIngredient(data.repairItems)};
			}

			@Environment(EnvType.CLIENT)
			@Override public String getName() {
				return "${data.armorTextureFile}";
			}

			@Override public float getToughness() {
				return ${data.toughness}f;
			}

			@Override public float getKnockbackResistance() {
				return ${data.knockbackResistance}f;
			}
		}, type, properties);
	}

	<#if data.enableHelmet>
		public static class Helmet extends ${name}Item {
			public Helmet() {
				super(Type.HELMET, new Item.Properties()<#if data.helmetImmuneToFire>.fireResistant()</#if>);

        <#list vanillaTabs as tabName>
        	<#list tabMap.get(tabName) as tabElement>
                <#if _match(tabElement, "HELMET")>
                    <#if tabName == "DECORATIONS">
                        ItemGroupEvents.modifyEntriesEvent(CreativeModeTabs.NATURAL_BLOCKS).register(content -> content.accept(this));
                    <#elseif tabName == "REDSTONE">
                        ItemGroupEvents.modifyEntriesEvent(CreativeModeTabs.REDSTONE_BLOCKS).register(content -> content.accept(this));
                    <#elseif tabName == "FOOD">
                        ItemGroupEvents.modifyEntriesEvent(CreativeModeTabs.FOOD_AND_DRINKS).register(content -> content.accept(this));
                    <#elseif tabName == "TOOLS">
                        ItemGroupEvents.modifyEntriesEvent(CreativeModeTabs.TOOLS_AND_UTILITIES).register(content -> content.accept(this));
                    <#elseif tabName == "MATERIALS">
                        ItemGroupEvents.modifyEntriesEvent(CreativeModeTabs.INGREDIENTS).register(content -> content.accept(this));
                    <#elseif tabName == "MISC">
                        ItemGroupEvents.modifyEntriesEvent(CreativeModeTabs.SPAWN_EGGS).register(content -> content.accept(this));
                    <#elseif tabName == "TRANSPORTATION">
                        ItemGroupEvents.modifyEntriesEvent(CreativeModeTabs.FUNCTIONAL_BLOCKS).register(content -> content.accept(this));
                    <#elseif tabName == "BREWING">
                        ItemGroupEvents.modifyEntriesEvent(CreativeModeTabs.COLORED_BLOCKS).register(content -> content.accept(this));
                    <#elseif tabName == "COMBAT">
                        ItemGroupEvents.modifyEntriesEvent(CreativeModeTabs.COMBAT).register(content -> content.accept(this));
                    <#else>
                        ItemGroupEvents.modifyEntriesEvent(CreativeModeTabs.${tabName}).register(content -> content.accept(this));
                    </#if>
                </#if>
        	</#list>
        </#list>

        <#list customTabs as tabName>
            <#assign TAB_CONST = _const(tabName)>
            <#list tabMap.get(tabName) as tabElement>
                <#if _match(tabElement, "HELMET")>
                    ItemGroupEvents.modifyEntriesEvent(${JavaModName}Tabs.TAB_${TAB_CONST}).register(content -> content.accept(this));
                </#if>
            </#list>
        </#list>
			}
		    <@addSpecialInformation data.helmetSpecialInformation/>
		}
	</#if>

	<#if data.enableBody>
		public static class Chestplate extends ${name}Item {
			public Chestplate() {
				super(Type.CHESTPLATE, new Item.Properties()<#if data.bodyImmuneToFire>.fireResistant()</#if>);

        <#list vanillaTabs as tabName>
        	<#list tabMap.get(tabName) as tabElement>
                <#if _match(tabElement, "CHESTPLATE")>
                    <#if tabName == "DECORATIONS">
                        ItemGroupEvents.modifyEntriesEvent(CreativeModeTabs.NATURAL_BLOCKS).register(content -> content.accept(this));
                    <#elseif tabName == "REDSTONE">
                        ItemGroupEvents.modifyEntriesEvent(CreativeModeTabs.REDSTONE_BLOCKS).register(content -> content.accept(this));
                    <#elseif tabName == "FOOD">
                        ItemGroupEvents.modifyEntriesEvent(CreativeModeTabs.FOOD_AND_DRINKS).register(content -> content.accept(this));
                    <#elseif tabName == "TOOLS">
                        ItemGroupEvents.modifyEntriesEvent(CreativeModeTabs.TOOLS_AND_UTILITIES).register(content -> content.accept(this));
                    <#elseif tabName == "MATERIALS">
                        ItemGroupEvents.modifyEntriesEvent(CreativeModeTabs.INGREDIENTS).register(content -> content.accept(this));
                    <#elseif tabName == "MISC">
                        ItemGroupEvents.modifyEntriesEvent(CreativeModeTabs.SPAWN_EGGS).register(content -> content.accept(this));
                    <#elseif tabName == "TRANSPORTATION">
                        ItemGroupEvents.modifyEntriesEvent(CreativeModeTabs.FUNCTIONAL_BLOCKS).register(content -> content.accept(this));
                    <#elseif tabName == "BREWING">
                        ItemGroupEvents.modifyEntriesEvent(CreativeModeTabs.COLORED_BLOCKS).register(content -> content.accept(this));
                    <#elseif tabName == "COMBAT">
                        ItemGroupEvents.modifyEntriesEvent(CreativeModeTabs.COMBAT).register(content -> content.accept(this));
                    <#else>
                        ItemGroupEvents.modifyEntriesEvent(CreativeModeTabs.${tabName}).register(content -> content.accept(this));
                    </#if>
                </#if>
        	</#list>
        </#list>

        <#list customTabs as tabName>
            <#assign TAB_CONST = _const(tabName)>
            <#list tabMap.get(tabName) as tabElement>
                <#if _match(tabElement, "CHESTPLATE")>
                    ItemGroupEvents.modifyEntriesEvent(${JavaModName}Tabs.TAB_${TAB_CONST}).register(content -> content.accept(this));
                </#if>
            </#list>
        </#list>
			}
		    <@addSpecialInformation data.bodySpecialInformation/>
		}
	</#if>

	<#if data.enableLeggings>
		public static class Leggings extends ${name}Item {
			public Leggings() {
				super(Type.LEGGINGS, new Item.Properties()<#if data.leggingsImmuneToFire>.fireResistant()</#if>);

        <#list vanillaTabs as tabName>
        	<#list tabMap.get(tabName) as tabElement>
                <#if _match(tabElement, "LEGGINGS")>
                    <#if tabName == "DECORATIONS">
                        ItemGroupEvents.modifyEntriesEvent(CreativeModeTabs.NATURAL_BLOCKS).register(content -> content.accept(this));
                    <#elseif tabName == "REDSTONE">
                        ItemGroupEvents.modifyEntriesEvent(CreativeModeTabs.REDSTONE_BLOCKS).register(content -> content.accept(this));
                    <#elseif tabName == "FOOD">
                        ItemGroupEvents.modifyEntriesEvent(CreativeModeTabs.FOOD_AND_DRINKS).register(content -> content.accept(this));
                    <#elseif tabName == "TOOLS">
                        ItemGroupEvents.modifyEntriesEvent(CreativeModeTabs.TOOLS_AND_UTILITIES).register(content -> content.accept(this));
                    <#elseif tabName == "MATERIALS">
                        ItemGroupEvents.modifyEntriesEvent(CreativeModeTabs.INGREDIENTS).register(content -> content.accept(this));
                    <#elseif tabName == "MISC">
                        ItemGroupEvents.modifyEntriesEvent(CreativeModeTabs.SPAWN_EGGS).register(content -> content.accept(this));
                    <#elseif tabName == "TRANSPORTATION">
                        ItemGroupEvents.modifyEntriesEvent(CreativeModeTabs.FUNCTIONAL_BLOCKS).register(content -> content.accept(this));
                    <#elseif tabName == "BREWING">
                        ItemGroupEvents.modifyEntriesEvent(CreativeModeTabs.COLORED_BLOCKS).register(content -> content.accept(this));
                    <#elseif tabName == "COMBAT">
                        ItemGroupEvents.modifyEntriesEvent(CreativeModeTabs.COMBAT).register(content -> content.accept(this));
                    <#else>
                        ItemGroupEvents.modifyEntriesEvent(CreativeModeTabs.${tabName}).register(content -> content.accept(this));
                    </#if>
                </#if>
        	</#list>
        </#list>

        <#list customTabs as tabName>
            <#assign TAB_CONST = _const(tabName)>
            <#list tabMap.get(tabName) as tabElement>
                <#if _match(tabElement, "LEGGINGS")>
                    ItemGroupEvents.modifyEntriesEvent(${JavaModName}Tabs.TAB_${TAB_CONST}).register(content -> content.accept(this));
                </#if>
            </#list>
        </#list>
			}
		    <@addSpecialInformation data.leggingsSpecialInformation/>
		}
	</#if>

	<#if data.enableBoots>
		public static class Boots extends ${name}Item {
			public Boots() {
				super(Type.BOOTS, new Item.Properties()<#if data.bootsImmuneToFire>.fireResistant()</#if>);

        <#list vanillaTabs as tabName>
        	<#list tabMap.get(tabName) as tabElement>
                <#if _match(tabElement, "BOOTS")>
                    <#if tabName == "DECORATIONS">
                        ItemGroupEvents.modifyEntriesEvent(CreativeModeTabs.NATURAL_BLOCKS).register(content -> content.accept(this));
                    <#elseif tabName == "REDSTONE">
                        ItemGroupEvents.modifyEntriesEvent(CreativeModeTabs.REDSTONE_BLOCKS).register(content -> content.accept(this));
                    <#elseif tabName == "FOOD">
                        ItemGroupEvents.modifyEntriesEvent(CreativeModeTabs.FOOD_AND_DRINKS).register(content -> content.accept(this));
                    <#elseif tabName == "TOOLS">
                        ItemGroupEvents.modifyEntriesEvent(CreativeModeTabs.TOOLS_AND_UTILITIES).register(content -> content.accept(this));
                    <#elseif tabName == "MATERIALS">
                        ItemGroupEvents.modifyEntriesEvent(CreativeModeTabs.INGREDIENTS).register(content -> content.accept(this));
                    <#elseif tabName == "MISC">
                        ItemGroupEvents.modifyEntriesEvent(CreativeModeTabs.SPAWN_EGGS).register(content -> content.accept(this));
                    <#elseif tabName == "TRANSPORTATION">
                        ItemGroupEvents.modifyEntriesEvent(CreativeModeTabs.FUNCTIONAL_BLOCKS).register(content -> content.accept(this));
                    <#elseif tabName == "BREWING">
                        ItemGroupEvents.modifyEntriesEvent(CreativeModeTabs.COLORED_BLOCKS).register(content -> content.accept(this));
                    <#elseif tabName == "COMBAT">
                        ItemGroupEvents.modifyEntriesEvent(CreativeModeTabs.COMBAT).register(content -> content.accept(this));
                    <#else>
                        ItemGroupEvents.modifyEntriesEvent(CreativeModeTabs.${tabName}).register(content -> content.accept(this));
                    </#if>
                </#if>
        	</#list>
        </#list>

        <#list customTabs as tabName>
            <#assign TAB_CONST = _const(tabName)>
            <#list tabMap.get(tabName) as tabElement>
                <#if _match(tabElement, "BOOTS")>
                    ItemGroupEvents.modifyEntriesEvent(${JavaModName}Tabs.TAB_${TAB_CONST}).register(content -> content.accept(this));
                </#if>
            </#list>
        </#list>
			}
		    <@addSpecialInformation data.bootsSpecialInformation/>
		}
	</#if>
}
<#-- @formatter:on -->
