// Nursery

#include "ProductionCommon.as";
#include "Requirements.as"
//#include "MakeSeed.as"
#include "WARCosts.as";

void onInit( CBlob@ this )
{
	this.set_string("produce sound", "/PopIn");
	//Parameter Syntax (this(leave the same), Name the person sees, png icon, description, time to make, boolean is in box?, max amout)
	ShopItem@ item = addProductionItem(this, "Mines", "mine", "mine", "A regular mine", 40, false, 2);

	this.set_TileType("background tile", CMap::tile_wood_back);
	this.getSprite().getConsts().accurateLighting = true;
	this.getSprite().SetZ(-50); //background
	this.getShape().getConsts().mapCollisions = false;
}

// leave a pile of wood	after death
void onDie(CBlob@ this)
{
	if (getNet().isServer())
	{
		CBlob@ blob = server_CreateBlob( "mat_wood", this.getTeamNum(), this.getPosition() );
		if (blob !is null)
		{
			blob.server_SetQuantity( COST_WOOD_NURSERY/2 );
		}
	}
}
