// Knight Workshop

#include "Requirements.as"
#include "ShopCommon.as";
#include "Descriptions.as";
#include "WARCosts.as";
#include "CheckSpam.as";



void onInit(CBlob@ this)
{	
	this.Tag("builder always hit");
	this.set_TileType("background tile", CMap::tile_castle_back);

	this.getSprite().SetZ(-50); //background
	this.getShape().getConsts().mapCollisions = false;
	
	AddIconToken( "$antidote$", "Antidote.png", Vec2f(8,8), 0);
	AddIconToken( "$seedotron$", "SeedOTron.png", Vec2f (32, 32), 0);
	AddIconToken( "$botanyseed$", "Seed.png", Vec2f(8, 8), 0);
	AddIconToken( "$tealeaves$", "TeaLeaf.png", Vec2f(8, 8), 0);

	// SHOP
	this.set_Vec2f("shop offset", Vec2f_zero);
	this.set_Vec2f("shop menu size", Vec2f(4, 2));
	this.set_string("shop description", "Buy");
	this.set_u8("shop icon", 25);
	
	{
		ShopItem@ s = addShopItem(this, "Seed 'O Tron", "$seedotron$", "seedotron", "Makes Seeds from plants with FIRE.", true);
		AddRequirement(s.requirements, "coin", "", "Coins", 75);
	}
	{
		ShopItem@ s = addShopItem(this, "Plant Cure", "$antidote$", "antidote", "An antidote for infected plants.", true);
		AddRequirement(s.requirements, "coin", "", "Coins", 15);
	}
	{
		ShopItem@ s = addShopItem(this, "Mutagen", "$mutagen$", "mutagen", "Gives plants the ability to crossbreed!", true);
		AddRequirement(s.requirements, "coin", "", "Coins", 10);
	}
	{
		ShopItem@ s = addShopItem(this, "Tea Seed", "$botanyseed$", "botanyseed", "Tea bush seed to begin your botanical empire!", true);
		AddRequirement(s.requirements, "coin", "", "Coins", 50);
	}
	{
		ShopItem@ s = addShopItem(this, "Sell leaves", "$tealeaves$", "coin-4", "Sell tea leaves for 4 coins", true);
		AddRequirement(s.requirements, "blob", "tealeaf", "Tea Leaf", 1);
		s.spawnNothing = true;
	}
}



void onCommand(CBlob@ this, u8 cmd, CBitStream @params)
{
	if (cmd == this.getCommandID("shop made item"))
	{
		this.getSprite().PlaySound("/ChaChing.ogg");
		if(getNet().isServer())
		{
			u16 caller, item;
			if(!params.saferead_netid(caller) || !params.saferead_netid(item))
			{
				return;
			}
			
			string name = params.read_string();
			CBlob@ callerBlob = getBlobByNetworkID(caller);
			string[] spl = name.split("-");
			
			if (spl[0] == "coin")
			{
				CPlayer@ callerPlayer = callerBlob.getPlayer();
				if (callerPlayer is null) return;
				
				callerPlayer.server_setCoins(callerPlayer.getCoins() + parseInt(spl[1]));
			}
		}
	}
}