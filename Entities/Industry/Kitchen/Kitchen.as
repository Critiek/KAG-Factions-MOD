// Knight Workshop

#include "Requirements.as"
#include "ShopCommon.as";
#include "Descriptions.as";
#include "WARCosts.as";
#include "CheckSpam.as";
#include "CTFShopCommon.as";



void onInit(CBlob@ this)
{	
	this.Tag("builder always hit");
	this.set_TileType("background tile", CMap::tile_wood_back);

	this.getSprite().SetZ(-50); //background
	this.getShape().getConsts().mapCollisions = false;
	
	AddIconToken( "$cookfish_$", "Food.png", Vec2f(16,16), 1);
	AddIconToken( "$bread_$", "Food.png", Vec2f(16,16), 4);
	AddIconToken( "$cooksteak_$", "Food.png", Vec2f(16,16), 0);
	AddIconToken( "$chickenleg_$", "Food.png", Vec2f(16,16), 3);
	AddIconToken( "$goldmoss_$", "Food.png", Vec2f(16,16), 2);

	// SHOP
	this.set_Vec2f("shop offset", Vec2f_zero);
	this.set_Vec2f("shop menu size", Vec2f(4, 2));
	this.set_string("shop description", "Buy");
	this.set_u8("shop icon", 25);
	
	{
		ShopItem@ s = addShopItem(this, "Cooked Fish", "$cookfish_$", "cookfish", "A Cooked Fish!", true);
		AddRequirement(s.requirements, "blob", "mat_wood", "Wood", 5);
		AddRequirement(s.requirements, "blob", "fishy", "Fish", 1);
	}
	{
		ShopItem@ s = addShopItem(this, "Bread", "$bread_$", "bread", "Bread", true);
		AddRequirement(s.requirements, "blob", "mat_wood", "Wood", 5);
		AddRequirement(s.requirements, "blob", "grain", "Grain", 2);
	}
	{
		ShopItem@ s = addShopItem(this, "Cooked Steak", "$cooksteak_$", "cooksteak", "A Cooked Steak!", true);
		AddRequirement(s.requirements, "blob", "mat_wood", "Wood", 5);
		AddRequirement(s.requirements, "blob", "steak", "Steak", 1);
	}
	{
		ShopItem@ s = addShopItem(this, "Chicken Legs", "$chickenleg_$", "chickenleg", "Chicken Legs!", true);
		AddRequirement(s.requirements, "blob", "chicken", "Chicken", 1);
	}
	{
		ShopItem@ s = addShopItem(this, "Gold Moss", "$goldmoss_$", "goldmoss", "Moss From Gold!", true);
		AddRequirement(s.requirements, "blob", "mat_gold", "Gold", 3);
	}
	
}



void onCommand(CBlob@ this, u8 cmd, CBitStream @params)
{
	if (cmd == this.getCommandID("shop made item"))
	{
		this.getSprite().PlaySound("/ChaChing.ogg");
	}
}