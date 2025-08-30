<#include "procedures.java.ftl">
public ${name}Procedure() {
	LivingEntityEvents.ENTITY_HEAL.register((entity, amount) -> {
		if (entity!=null) {
			<#assign dependenciesCode><#compress>
			<@procedureDependenciesCode dependencies, {
				"x": "entity.getX()",
				"y": "entity.getY()",
				"z": "entity.getZ()",
				"world": "entity.level()",
				"entity": "entity",
				"amount": "amount"
				}/>
			</#compress></#assign>
			execute(${dependenciesCode});
		}
		return true;
	});
}