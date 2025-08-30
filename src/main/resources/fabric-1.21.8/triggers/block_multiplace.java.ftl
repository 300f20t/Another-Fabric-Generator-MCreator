<#include "procedures.java.ftl">
public static boolean eventResult = true;
public ${name}Procedure() {
	BlockEvents.BLOCK_MULTIPLACE.register((position, entity, placed, placedAgainst) -> {
		<#assign dependenciesCode><#compress>
			<@procedureDependenciesCode dependencies, {
				"x": "position.getX()",
				"y": "position.getY()",
				"z": "position.getZ()",
				"px": "entity.getX()",
				"py": "entity.getY()",
				"pz": "entity.getZ()",
				"world": "entity.getLevel()",
				"entity": "entity",
				"blockstate": "placed",
				"placedagainst": "placedAgainst"
			}/>
		</#compress></#assign>
		execute(${dependenciesCode});
		boolean result = eventResult;
		eventResult = true;
		return result;
	});
}