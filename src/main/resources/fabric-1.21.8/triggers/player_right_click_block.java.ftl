<#include "procedures.java.ftl">
public static boolean eventResult = true;
public ${name}Procedure() {
	UseBlockCallback.EVENT.register((player, level, hand, hitResult) -> {
		<#assign dependenciesCode><#compress>
			<@procedureDependenciesCode dependencies, {
			"x": "hitResult.getBlockPos().getX()",
			"y": "hitResult.getBlockPos().getY()",
			"z": "hitResult.getBlockPos().getZ()",
			"world": "level",
			"entity": "player",
			"direction": "hitResult.getDirection()",
			"blockstate": "hitResult.getBlockPos()"
			}/>
		</#compress></#assign>
		if (hand == player.getUsedItemHand())
		    execute(${dependenciesCode});
		boolean result = eventResult;
		eventResult = true;
		return result ? InteractionResult.PASS : InteractionResult.FAIL;
	});
}