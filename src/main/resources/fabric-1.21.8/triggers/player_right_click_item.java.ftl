<#include "procedures.java.ftl">
public static boolean eventResult = true;
public ${name}Procedure() {
	UseItemCallback.EVENT.register((player, level, hand) -> {
		<#assign dependenciesCode><#compress>
			<@procedureDependenciesCode dependencies, {
			"x": "player.getX()",
			"y": "player.getY()",
			"z": "player.getZ()",
			"world": "level",
			"entity": "player"
			}/>
		</#compress></#assign>
		if (hand == player.getUsedItemHand())
			execute(${dependenciesCode});
		boolean result = eventResult;
		eventResult = true;
		return result ? InteractionResult.PASS : InteractionResult.FAIL;
	});
}
