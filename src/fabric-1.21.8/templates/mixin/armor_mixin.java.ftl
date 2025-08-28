<#--
 # This file is part of Fabric-Generator-MCreator.
 # Copyright (C) 2020-2025, Goldorion, opensource contributors
 #
 # Fabric-Generator-MCreator is free software: you can redistribute it and/or modify
 # it under the terms of the GNU Lesser General Public License as published by
 # the Free Software Foundation, either version 3 of the License, or
 # (at your option) any later version.

 # Fabric-Generator-MCreator is distributed in the hope that it will be useful,
 # but WITHOUT ANY WARRANTY; without even the implied warranty of
 # MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 # GNU Lesser General Public License for more details.
 #
 # You should have received a copy of the GNU Lesser General Public License
 # along with Fabric-Generator-MCreator.  If not, see <https://www.gnu.org/licenses/>.
-->
package ${package}.mixin;

@Mixin(EquipmentClientInfo.Layer.class)
public abstract class ArmorMixin {
    @Shadow @Final public ResourceLocation textureId;

    @Inject(method = "getTextureLocation", at = @At("HEAD"), cancellable = true)
    public void getTextureLocation(EquipmentClientInfo.LayerType layerType, CallbackInfoReturnable<ResourceLocation> cir) {
        if (textureId.getNamespace().equals(${JavaModName}.MODID)) {
            ResourceLocation newLoc = ResourceLocation.fromNamespaceAndPath(textureId.getNamespace(), "textures/models/armor/" + textureId.getPath());
            cir.setReturnValue(newLoc);
            cir.cancel();
        }
    }
}