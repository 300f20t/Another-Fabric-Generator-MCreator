<#include "procedures.java.ftl">
public static boolean eventResult = true;
public ${name}Procedure() {
	ItemEvents.BONEMEAL_USED.register((position, entity, itemstack, blockstate) -> {
		<#assign dependenciesCode><#compress>
			<@procedureDependenciesCode dependencies, {
				"x": "position.getX()",
				"y": "position.getY()",
				"z": "position.getZ()",
				"world": "entity.level()",
				"itemstack": "itemstack",
				"entity": "entity",
				"blockstate": "blockstate"
			}/>
		</#compress></#assign>
		execute(${dependenciesCode});
		boolean result = eventResult;
		eventResult = true;
		return result;
	});
}