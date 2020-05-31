// Knight Workshop

#include "Requirements.as"
#include "ShopCommon.as";
#include "Descriptions.as";
#include "WARCosts.as";
#include "CheckSpam.as";
#include "ProductionCommon.as";

const int splashes = 3;

void onInit(CBlob@ this)
{
	this.Tag("builder always hit");
	this.set_TileType("background tile", CMap::tile_castle_back);
	this.Tag("getthis");
	this.getSprite().SetZ(-50); //background
	this.getShape().getConsts().mapCollisions = false;
	this.set_u32("minionCD", 0);
}

void onCollision( CBlob@ this, CBlob@ blob, bool solid )
{
	if(blob !is null)
	{
		CBlob@ b = blob.getCarriedBlob();
		if(b !is null)
		{
			if(b.getName() == "bucket")
			{
				b.set_u8("filled", splashes);
				b.Sync("filled", true);
				b.getSprite().SetAnimation("full");
			}
		}
		if(blob.getName() == "bucket")
		{
			blob.set_u8("filled", splashes);
			blob.Sync("filled", true);
			blob.getSprite().SetAnimation("full");
		}
	}
}