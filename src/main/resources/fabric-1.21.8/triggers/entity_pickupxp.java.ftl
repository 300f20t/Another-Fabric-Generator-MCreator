<#include "procedures.java.ftl">
public static boolean eventResult = true;
public ${name}Procedure() {
	PlayerEvents.PICKUP_XP.register((entity) -> {
		if (entity != null) {
			<#assign dependenciesCode><#compress>
			<@procedureDependenciesCode dependencies, {
				"x": "entity.getX()",
				"y": "entity.getY()",
				"z": "entity.getZ()",
				"world": "entity.level()",
				"entity": "entity"
			}/>
			</#compress></#assign>
			execute(${dependenciesCode});
		}
		boolean result = eventResult;
    	eventResult = true;
    	return result;
	});
}