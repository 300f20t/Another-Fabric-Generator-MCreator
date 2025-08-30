<#include "procedures.java.ftl">
public static boolean eventResult = true;
public ${name}Procedure() {
	PlayerBlockBreakEvents.BEFORE.register((world, player, pos, state, blockentity) -> {
		<#assign dependenciesCode><#compress>
			<@procedureDependenciesCode dependencies, {
			"x": "pos.getX()",
			"y": "pos.getY()",
			"z": "pos.getZ()",
			"px": "player.getX()",
			"py": "player.getY()",
			"pz": "player.getZ()",
			"world": "world",
			"entity": "player",
			"blockstate": "state"
			}/>
		</#compress></#assign>
		execute(${dependenciesCode});
		boolean result = eventResult;
		eventResult = true;
		return result;
	});
}