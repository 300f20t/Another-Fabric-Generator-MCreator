<#include "mcelements.ftl">
<#-- @formatter:off -->
if(${input$entity} instanceof ServerPlayer _ent) {
    final double _pos_x = ${input$x};
	final double _pos_y = ${input$y};
	final double _pos_z = ${input$z};
	_ent.openMenu(new MenuProvider() {

		@Override public Component getDisplayName() {
			return Component.literal("${field$guiname}");
		}

		@Override public AbstractContainerMenu createMenu(int id, Inventory inventory, Player player) {
			return new ${(field$guiname)}Menu(id, inventory, new FriendlyByteBuf(Unpooled.buffer()).writeBlockPos(BlockPos.containing(_pos_x, _pos_y, _pos_z)));
		}

	});
}
<#-- @formatter:on -->