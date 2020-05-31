// Knight Workshop

#include "MaterialCommon.as";

void onInit(CBlob@ this)
{
	this.set_TileType("background tile", CMap::tile_castle_back);
	this.getSprite().SetZ(-50); //background
	this.getShape().getConsts().mapCollisions = false;
	this.getCurrentScript().tickFrequency = 354; //:3
}

void onTick(CBlob@ this)
{
	CInventory@ inv = this.getInventory();
	
	for(int i = 0; i < inv.getItemsCount(); i++)
	{
		CBlob@ blob = inv.getItem(i);
		if(blob.hasTag("item"))
		{
			string name = blob.getName();
			string creation = "mat_stone";
			int quantity = 40;
			if(name.find("stone") >= 0)
			{
				creation = "mat_stone";
			}
			else if(name.find("iron") >= 0)
			{
				creation = "mat_stone";
				quantity = 30;
			}
			else if(name.find("mithril") >= 0)
			{
				creation = "mat_stone";
				quantity = 50;
			}
			else if(name.find("platinum") >= 0)
			{
				creation = "mat_stone";
				quantity = 70;
			}
			else if(name.find("titan") >= 0)
			{
				creation = "mat_stone";
				quantity = 100;
			}
			else if(name.find("wood") >= 0)
			{
				creation = "mat_wood";
				quantity = 40;
			}
			else if(name == "greed")
			{
				creation = "mat_gold";
				quantity = 8;
			}
			if(getNet().isServer())
			{
				CBlob@ mat = server_CreateBlob(creation, this.getTeamNum(), this.getPosition());
				if(mat !is null)
				{
					mat.server_SetQuantity(quantity);
					this.server_PutInInventory(mat);
					blob.server_Die();
				}
			}
			break;
		}
	}
}