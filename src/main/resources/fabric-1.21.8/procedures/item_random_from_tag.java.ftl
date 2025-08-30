<#include "mcelements.ftl">
(BuiltInRegistries.ITEM.getRandomElementOf(TagKey.create(Registries.ITEM, ${toResourceLocation(input$b)}), RandomSource.create())
		.orElseGet(() -> BuiltInRegistries.ITEM.wrapAsHolder(Items.AIR)).value())