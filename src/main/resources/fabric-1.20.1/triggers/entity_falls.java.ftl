<#include "procedures.java.ftl">
public ${name}Procedure() {
	LivingEntityEvents.ENTITY_FALL.register((entity, falldistance, damagemultiplier) -> {
		if (entity != null) {
			<#assign dependenciesCode><#compress>
			<@procedureDependenciesCode dependencies, {
				"x": "entity.getX()",
				"y": "entity.getY()",
				"z": "entity.getZ()",
				"damagemultiplier": "damagemultiplier",
				"distance": "falldistance",
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