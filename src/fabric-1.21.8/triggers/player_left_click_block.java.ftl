<#include "procedures.java.ftl">
public static boolean eventResult = true;
public ${name}Procedure() {
	AttackBlockCallback.EVENT.register((player, level, hand, pos, direction) -> {
		<#assign dependenciesCode><#compress>
			<@procedureDependenciesCode dependencies, {
			"x": "pos.getX()",
			"y": "pos.getY()",
			"z": "pos.getZ()",
			"world": "level",
			"entity": "player",
			"direction": "direction",
			"blockstate": "level.getBlockState(pos)"
			}/>
		</#compress></#assign>
		if (hand == player.getUsedItemHand())
		    execute(${dependenciesCode});
		boolean result = eventResult;
		eventResult = true;
		return result ? InteractionResult.PASS : InteractionResult.FAIL;
	});
}