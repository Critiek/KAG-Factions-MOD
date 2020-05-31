// Knight Workshop

#include "Requirements.as"
#include "ShopCommon.as";
#include "Descriptions.as";
#include "WARCosts.as";
#include "CheckSpam.as";
#include "ForgeCommon.as";

void onInit(CBlob@ this)
{
	CSprite@ sprite = this.getSprite();
	CSpriteLayer@ front = sprite.addSpriteLayer("label", "ForgeHeads.png", 16, 16, this.getTeamNum(), this.getSkinNum());
	if (front !is null)
	{
		front.SetOffset(Vec2f(0, 2));
		Animation@ anim = front.addAnimation("default", 0, false);
		front.SetVisible(false);
		front.SetRelativeZ(1005);
	}
	this.Tag("builder always hit");
	this.addCommandID("initshop");
	this.set_TileType("background tile", CMap::tile_wood_back);

	this.getSprite().SetZ(-50); //background
	this.getShape().getConsts().mapCollisions = false;
	// Sword Icons
	AddIconToken( "$woodenblade_$", "WoodenBlade.png", Vec2f(16,16), 0);
	AddIconToken( "$stoneblade_$", "StoneBlade.png", Vec2f(16,16), 0);
	AddIconToken( "$ironblade_$", "IronBlade.png", Vec2f(16,16), 0);
	AddIconToken( "$mithrilblade_$", "MithrilBlade.png", Vec2f(16,16), 0);
	AddIconToken( "$platinumblade_$", "PlatinumBlade.png", Vec2f(16,16), 0);
	AddIconToken( "$titanblade_$", "TitanBlade.png", Vec2f(32,32), 0);
	AddIconToken( "$ironpartisan_$", "IronPartisan.png", Vec2f(16,16), 0);
	AddIconToken( "$mithrildagger_$", "MithrilDagger.png", Vec2f(16,16), 0);
	
	// Bow Icons
	AddIconToken( "$woodenbow_$", "WoodenBow.png", Vec2f(16,16), 0);
	AddIconToken( "$stonebow_$", "StoneBow.png", Vec2f(16,16), 0);
	AddIconToken( "$ironbow_$", "IronBow.png", Vec2f(16,16), 0);
	AddIconToken( "$mithrilbow_$", "MithrilBow.png", Vec2f(16,16), 0);
	AddIconToken( "$platinumbow_$", "PlatinumBow.png", Vec2f(16,16), 0);
	AddIconToken( "$titanbow_$", "TitanBow.png", Vec2f(32,32), 0);
	AddIconToken( "$woodlongbow_$", "WoodLongBow.png", Vec2f(16,16), 0);
	AddIconToken( "$chukonu_$", "ChuKoNu.png", Vec2f(16,16), 0);
	
	// Pick Icons
	AddIconToken( "$titanpick_$", "TitanPick.png", Vec2f(16,16), 0);
	AddIconToken( "$woodenpick_$", "WoodenPick.png", Vec2f(16,16), 0);
	AddIconToken( "$stonepick_$", "StonePick.png", Vec2f(16,16), 0);
	AddIconToken( "$ironpick_$", "IronPick.png", Vec2f(16,16), 0);
	AddIconToken( "$mithrilharvester_$", "MithrilHarvester.png", Vec2f(16,16), 0);
	AddIconToken( "$platinumpick_$", "PlatinumPick.png", Vec2f(16,16), 0);
	AddIconToken( "$blurpick_$", "BlurPick.png", Vec2f(16,16), 0);
	
	
	// Misc Icons
	AddIconToken( "$emeraldring_$", "EmeraldRing.png", Vec2f(16,16), 0);
	AddIconToken( "$topazring_$", "TopazRing.png", Vec2f(16,16), 0);
	AddIconToken( "$spikedring_$", "SpikedRing.png", Vec2f(16,16), 0);
	AddIconToken( "$hellfirering_$", "HellfireRing.png", Vec2f(16,16), 0);
	AddIconToken( "$scubahelm_$", "ScubaHelm.png", Vec2f(16,16), 0);
	
	
	// Armor Icons
	AddIconToken( "$woodenarmor_$", "WoodenArmor.png", Vec2f(32,32), 0);
	AddIconToken( "$stonearmor_$", "StoneArmor.png", Vec2f(32,32), 0);
	AddIconToken( "$ironarmor_$", "IronArmor.png", Vec2f(32,32), 0);
	AddIconToken( "$mithrilarmor_$", "MithrilArmor.png", Vec2f(32,32), 0);
	AddIconToken( "$platinumarmor_$", "PlatinumArmor.png", Vec2f(32,32), 0);
	AddIconToken( "$tunic_$", "TravelersTunic.png", Vec2f(32,32), 0);
	AddIconToken( "$titanarmor_$", "TitanArmor.png", Vec2f(32,32), 0);
	AddIconToken( "$ironchain_$", "IronChainmail.png", Vec2f(32,32), 0);
	AddIconToken( "$platinumchain_$", "PlatinumChainmail.png", Vec2f(32,32), 0);
	
	
	// Special Sword Icons
	AddIconToken( "$greed_$", "Greed.png", Vec2f(16,16), 0);
	AddIconToken( "$shadowblade_$", "ShadowBlade.png", Vec2f(16,16), 0);
	AddIconToken( "$bladeoflight_$", "BladeOfLight.png", Vec2f(16,16), 0);
	AddIconToken( "$bladeofundead_$", "BladeOfUndead.png", Vec2f(16,16), 0);
    AddIconToken( "$bladeoffeathers_$", "Bladeoffeathers.png", Vec2f(16,16), 0);
	

	// SHOP
	this.set_Vec2f("shop offset", Vec2f_zero);
	this.set_Vec2f("shop menu size", Vec2f(4, 5));
	this.set_string("shop description", "Buy");
	this.set_u8("shop icon", 25);
	if(this.exists("itemindex"))
	{
		initForge(this);
	}
}
void GetButtonsFor( CBlob@ this, CBlob@ caller )
{
	if(this.hasTag("shopdone"))
	{
		return;
	}
	{
		CBitStream params;
		params.write_u8(SWORDINDEX);
		CButton@ button = caller.CreateGenericButton(15, Vec2f(-10, -6), this, this.getCommandID("initshop"), "Add Swords.", params);
		if(this.getDistanceTo(caller) < 50)
		{
			button.SetEnabled(true);
		}
		else
		{
			button.SetEnabled(false);
		}
	}
	{
		CBitStream params;
		params.write_u8(BOWINDEX);
		CButton@ button = caller.CreateGenericButton(15, Vec2f(0, -6), this, this.getCommandID("initshop"), "Add Bows.", params);
		if(this.getDistanceTo(caller) < 50)
		{
			button.SetEnabled(true);
		}
		else
		{
			button.SetEnabled(false);
		}
	}
	{
		CBitStream params;
		params.write_u8(PICKINDEX);
		CButton@ button = caller.CreateGenericButton(15, Vec2f(10, -6), this, this.getCommandID("initshop"), "Add Pickaxes.", params);
		if(this.getDistanceTo(caller) < 50)
		{
			button.SetEnabled(true);
		}
		else
		{
			button.SetEnabled(false);
		}
	}
	{
		CBitStream params;
		params.write_u8(ARMORINDEX);
		CButton@ button = caller.CreateGenericButton(15, Vec2f(-10, 0), this, this.getCommandID("initshop"), "Add Armor.", params);
		if(this.getDistanceTo(caller) < 50)
		{
			button.SetEnabled(true);
		}
		else
		{
			button.SetEnabled(false);
		}
	}
	{
		CBitStream params;
		params.write_u8(MISCINDEX);
		CButton@ button = caller.CreateGenericButton(15, Vec2f(10, 0), this, this.getCommandID("initshop"), "Add Accessories.", params);
		if(this.getDistanceTo(caller) < 50)
		{
			button.SetEnabled(true);
		}
		else
		{
			button.SetEnabled(false);
		}
	}
}
void onCommand(CBlob@ this, u8 cmd, CBitStream @params)
{
	if(cmd == this.getCommandID("initshop"))
	{
		u8 pain = params.read_u8();
		initShop(pain, this);
	}
}
void initShop(int itemindex, CBlob@ this)
{
	if(getNet().isServer())
	{
		CBlob@ newBlob = server_CreateBlobNoInit("forge");
		if(newBlob !is null)
		{
			newBlob.Tag("shopdone");
			newBlob.set_u8("itemindex", itemindex);
			newBlob.setPosition(this.getPosition());
			newBlob.server_setTeamNum(this.getTeamNum());
			this.server_Die();
		}
	}
}
void initForge(CBlob@ this)
{
	int itemindex = this.get_u8("itemindex");
	CSpriteLayer@ label = this.getSprite().getSpriteLayer("label");
	if(label !is null)
	{
		label.SetVisible(true);
		Animation@ anim = label.getAnimation("default");
		if(anim !is null)
		{
			anim.AddFrame(itemindex);
		}
	}
	switch(itemindex) //Based off of which item index you chose, actually create the shop.
	{
		case SWORDINDEX: //Swords.
		{
			{
				ShopItem@ s = addShopItem(this, "Wooden Sword", "$woodenblade_$", "woodenblade", "A sword made of wood. x1.1 dmg", false);
				AddRequirement(s.requirements, "blob", "mat_wood", "Wood", 50);
			}
			{
				ShopItem@ s = addShopItem(this, "Stone Sword", "$stoneblade_$", "stoneblade", "A sword made of stone. x1.25 dmg", false);
				AddRequirement(s.requirements, "blob", "mat_stone", "Stone", 100);
			}
			{
				ShopItem@ s = addShopItem(this, "Iron Sword", "$ironblade_$", "ironblade", "A sword made of iron. x1.5 dmg", false);
				AddRequirement(s.requirements, "blob", "mat_stone", "Stone", 200);
			}
			{
				ShopItem@ s = addShopItem(this, "Mithril Sword", "$mithrilblade_$", "mithrilblade", "A sword made of mithril. x1.75 dmg", false);
				AddRequirement(s.requirements, "blob", "mat_wood", "Wood", 100);
				AddRequirement(s.requirements, "blob", "mat_stone", "Stone", 300);
			}
			{
				ShopItem@ s = addShopItem(this, "Platinum Sword", "$platinumblade_$", "platinumblade", "A sword made of platinum. x2 dmg", false);
				AddRequirement(s.requirements, "blob", "mat_wood", "Wood", 200);
				AddRequirement(s.requirements, "blob", "mat_stone", "Stone", 350);
			}
			{
				ShopItem@ s = addShopItem(this, "Titan Sword", "$titanblade_$", "titanblade", "A sword made of titan. x3 dmg", false);
				AddRequirement(s.requirements, "blob", "mat_wood", "Wood", 350);
				AddRequirement(s.requirements, "blob", "mat_stone", "Stone", 750);
			}
			{
				ShopItem@ s = addShopItem(this, "Greed", "$greed_$", "greed", "A sword that gives you coins", false);
				AddRequirement(s.requirements, "coin", "", "Coins", 200);
				AddRequirement(s.requirements, "blob", "mat_stone", "Stone", 400);
			}
			{
				ShopItem@ s = addShopItem(this, "The Shadow Blade", "$shadowblade_$", "shadowblade", "A sword that increases speed and damage", false);
				AddRequirement(s.requirements, "coin", "", "Coins", 100);
				AddRequirement(s.requirements, "blob", "mat_stone", "Stone", 500);
			}
			{
				ShopItem@ s = addShopItem(this, "The Blade Of Light", "$bladeoflight_$", "bladeoflight", "A sword that heals and increases damage", false);
				AddRequirement(s.requirements, "coin", "", "Coins", 100);
				AddRequirement(s.requirements, "blob", "mat_wood", "Wood", 200);
				AddRequirement(s.requirements, "blob", "mat_stone", "Stone", 450);
			}
			{
				ShopItem@ s = addShopItem(this, "The Blade Of Undead", "$bladeofundead_$", "bladeofundead", "A sword that summons skeles", false);
				AddRequirement(s.requirements, "coin", "", "Coins", 50);
				AddRequirement(s.requirements, "blob", "mat_stone", "Stone", 700);
			}
			{
				ShopItem@ s = addShopItem(this, "Blade Of Feathers", "$bladeoffeathers_$", "bladeoffeathers", "A sword that increases jump height and speed, x1.0 dmg", false);
				AddRequirement(s.requirements, "blob", "mat_wood", "Wood", 500);
				AddRequirement(s.requirements, "blob", "mat_stone", "Stone", 300);
			}
			{
				ShopItem@ s = addShopItem(this, "Iron Partisan", "$ironpartisan_$", "ironpartisan", "A spear with extra range and damage, but is slower to use.", false);
				AddRequirement(s.requirements, "blob", "mat_wood", "Wood", 100);
				AddRequirement(s.requirements, "blob", "mat_gold", "Gold", 15);
				AddRequirement(s.requirements, "blob", "mat_stone", "Stone", 200);
			}
			{
				ShopItem@ s = addShopItem(this, "Mithril Dagger", "$mithrildagger_$", "mithrildagger", "A dagger, makes you slash faster, but you gotta get personal!", false);
				AddRequirement(s.requirements, "blob", "mat_wood", "Wood", 10);
				AddRequirement(s.requirements, "blob", "mat_gold", "Gold", 30);
				AddRequirement(s.requirements, "blob", "mat_stone", "Stone", 150);
			}
		}
		break;
		case BOWINDEX: //Bows
		{
			{
				ShopItem@ s = addShopItem(this, "Wooden Bow", "$woodenbow_$", "woodenbow", "A bow made of wood. x1.1 dmg", false);
				AddRequirement(s.requirements, "blob", "mat_wood", "Wood", 50);
			}
			{
				ShopItem@ s = addShopItem(this, "Stone Bow", "$stonebow_$", "stonebow", "A bow made of stone. x1.25 dmg", false);
				AddRequirement(s.requirements, "blob", "mat_stone", "Stone", 100);
			}
			{
				ShopItem@ s = addShopItem(this, "Iron Bow", "$ironbow_$", "ironbow", "A bow made of iron. x1.5 dmg", false);
				AddRequirement(s.requirements, "blob", "mat_stone", "Stone", 200);
			}
			{
				ShopItem@ s = addShopItem(this, "Mithril Bow", "$mithrilbow_$", "mithrilbow", "A bow made of mithril. x1.75 dmg", false);
				AddRequirement(s.requirements, "blob", "mat_wood", "Wood", 100);
				AddRequirement(s.requirements, "blob", "mat_stone", "Stone", 300);
			}
			{
				ShopItem@ s = addShopItem(this, "Platinum Bow", "$platinumbow_$", "platinumbow", "A bow made of platinum. x2 dmg", false);
				AddRequirement(s.requirements, "blob", "mat_wood", "Wood", 200);
				AddRequirement(s.requirements, "blob", "mat_stone", "Stone", 350);
			}
			{
				ShopItem@ s = addShopItem(this, "Titan Bow", "$titanbow_$", "titanbow", "A bow made of titan. x3 dmg", false);
				AddRequirement(s.requirements, "blob", "mat_wood", "Wood", 1000);
				AddRequirement(s.requirements, "blob", "mat_stone", "Stone", 600);
			}
			{
				ShopItem@ s = addShopItem(this, "Wooden Longbow", "$woodlongbow_$", "woodlongbow", "It's arrows fly at impressive speeds.", false);
				AddRequirement(s.requirements, "blob", "mat_wood", "Wood", 600);
				AddRequirement(s.requirements, "blob", "mat_stone", "Stone", 100);
			}
			{
				ShopItem@ s = addShopItem(this, "ChuKoNu", "$chukonu_$", "chukonu", "Shoots fast, but it's arrows aren't very powerful.", false);
				AddRequirement(s.requirements, "blob", "mat_wood", "Wood", 200);
				AddRequirement(s.requirements, "blob", "mat_stone", "Stone", 250);
			}
		}
		break;
		case PICKINDEX: //Picks - maybe split this one up, since they're 4* larger than other things.
		{
			{
				ShopItem@ s = addShopItem(this, "Wooden 'pickaxe'", "$woodenpick_$", "woodenpick", "It's a log on a stick, it digs slightly faster, and has a little better range. \nDon't ask why.", false);
				AddRequirement(s.requirements, "blob", "mat_wood", "Wood", 150);
			}
			{
				ShopItem@ s = addShopItem(this, "Stone club-pick", "$stonepick_$", "stonepick", "Like the wooden pick, but better.", false);
				AddRequirement(s.requirements, "blob", "mat_wood", "Wood", 100);
				AddRequirement(s.requirements, "blob", "mat_stone", "Stone", 100);
			}
			{
				ShopItem@ s = addShopItem(this, "Iron Pickaxe", "$ironpick_$", "ironpick", "Digs quickly, and has a slightly larger range than it's predecessors.", false);
				AddRequirement(s.requirements, "blob", "mat_wood", "Wood", 100);
				AddRequirement(s.requirements, "blob", "mat_gold", "Gold", 15);
				AddRequirement(s.requirements, "blob", "mat_stone", "Stone", 200);
			}
			{
				ShopItem@ s = addShopItem(this, "Mithril Harvester", "$mithrilharvester_$", "mithrilharvester", "Hard enough to cut stone. Digs all the faster because of it. No range increase.", false);
				AddRequirement(s.requirements, "blob", "mat_wood", "Wood", 100);
				AddRequirement(s.requirements, "blob", "mat_gold", "Gold", 15);
				AddRequirement(s.requirements, "blob", "mat_stone", "Stone", 300);
			}
			{
				ShopItem@ s = addShopItem(this, "Platinum Pickaxe", "$platinumpick_$", "platinumpick", "Furthest reach, and fastest mining.", false);
				AddRequirement(s.requirements, "blob", "mat_wood", "Wood", 200);
				AddRequirement(s.requirements, "blob", "mat_gold", "Gold", 35);
				AddRequirement(s.requirements, "blob", "mat_stone", "Stone", 400);
			}
			{
				ShopItem@ s = addShopItem(this, "Titan Pick", "$titanpick_$", "titanpick", "Effectively a prototype earthquake mallet.", false);
				AddRequirement(s.requirements, "blob", "mat_wood", "Wood", 300);
				AddRequirement(s.requirements, "blob", "mat_gold", "Gold", 75);
				AddRequirement(s.requirements, "blob", "mat_stone", "Stone", 700);
			}
			{
				ShopItem@ s = addShopItem(this, "Blur Shovel", "$blurpick_$", "blurpick", "Very fast, but annoyingly small range.", false);
				AddRequirement(s.requirements, "blob", "mat_wood", "Wood", 100);
				AddRequirement(s.requirements, "blob", "mat_gold", "Gold", 45);
				AddRequirement(s.requirements, "blob", "mat_stone", "Stone", 100);
			}
		}
		break;
		case ARMORINDEX: //Armor
		{
			{
				ShopItem@ s = addShopItem(this, "Wooden Armour", "$woodenarmor_$", "woodenarmor", "Armor made of wood", false);
				AddRequirement(s.requirements, "blob", "mat_wood", "Wood", 50);
			}
			{
				ShopItem@ s = addShopItem(this, "Travelers Tunic", "$tunic_$", "tunic", "Armor that reduces defense but increases speed, for all classes!", false);
				AddRequirement(s.requirements, "blob", "mat_wood", "Wood", 100);
			}
			{
				ShopItem@ s = addShopItem(this, "Stone Armour", "$stonearmor_$", "stonearmor", "Armor made of stone", false);
				AddRequirement(s.requirements, "blob", "mat_stone", "Stone", 100);
			}
			{
				ShopItem@ s = addShopItem(this, "Iron Armour", "$ironarmor_$", "ironarmor", "Armor made of iron", false);
				AddRequirement(s.requirements, "blob", "mat_stone", "Stone", 200);
			}
			{
				ShopItem@ s = addShopItem(this, "Mithril Armour", "$mithrilarmor_$", "mithrilarmor", "Armor made of mithril", false);
				AddRequirement(s.requirements, "blob", "mat_wood", "Wood", 100);
				AddRequirement(s.requirements, "blob", "mat_stone", "Stone", 300);
			}
			{
				ShopItem@ s = addShopItem(this, "Platinum Armour", "$platinumarmor_$", "platinumarmor", "Armor made of platinum", false);
				AddRequirement(s.requirements, "blob", "mat_wood", "Wood", 200);
				AddRequirement(s.requirements, "blob", "mat_stone", "Stone", 350);
			}
			{
				ShopItem@ s = addShopItem(this, "Titan Armour", "$titanarmor_$", "titanarmor", "Armor made of titan", false);
				AddRequirement(s.requirements, "blob", "mat_wood", "Wood", 500);
				AddRequirement(s.requirements, "blob", "mat_stone", "Stone", 1000);
			}
			{
				ShopItem@ s = addShopItem(this, "Iron Chainmail", "$ironchain_$", "ironchain", "Chainmail for archers!", false);
				AddRequirement(s.requirements, "blob", "mat_stone", "Stone", 200);
			}
			{
				ShopItem@ s = addShopItem(this, "Platinum Chainmail", "$platinumchain_$", "platinumchain", "Platinum for archers!", false);
				AddRequirement(s.requirements, "blob", "mat_wood", "Wood", 200);
				AddRequirement(s.requirements, "blob", "mat_stone", "Stone", 350);
			}
			this.set_Vec2f("shop menu size", Vec2f(8, 8));
		}
		break;
		case MISCINDEX: //Rings
		{
			{
				ShopItem@ s = addShopItem(this, "Emerald Ring", "$emeraldring_$", "emeraldring", "For knights, it fits on your big toe.", false);
				AddRequirement(s.requirements, "coin", "", "Coins", 100);
				AddRequirement(s.requirements, "blob", "mat_stone", "Stone", 50);
			}
			{
				ShopItem@ s = addShopItem(this, "Topaz Ring", "$topazring_$", "topazring", "For knights, it fits on your pinky toe.", false);
				AddRequirement(s.requirements, "coin", "", "Coins", 100);
				AddRequirement(s.requirements, "blob", "mat_stone", "Stone", 50);
			}
			{
				ShopItem@ s = addShopItem(this, "Spiked Ring", "$spikedring_$", "spikedring", "For Archers, gives your arrows extra punch!", false);
				AddRequirement(s.requirements, "coin", "", "Coins", 100);
				AddRequirement(s.requirements, "blob", "mat_stone", "Stone", 50);
			}
			{
				ShopItem@ s = addShopItem(this, "Hellfire Ring", "$hellfirering_$", "hellfirering", "For anyone, grants fire resistance.", false);
				AddRequirement(s.requirements, "coin", "", "Coins", 100);
				AddRequirement(s.requirements, "blob", "mat_stone", "Stone", 50);
			}
			{
				ShopItem@ s = addShopItem(this, "Scuba Gear", "$scubahelm_$", "scubahelm", "For anyone, makes it easier to breathe underwater.", false);
				AddRequirement(s.requirements, "coin", "", "Coins", 25);
				AddRequirement(s.requirements, "blob", "mat_stone", "Stone", 100);
			}
		}
		break;
	}
}
/*
void onTick( CBlob@ this )
{
}
void GetButtonsFor(CBlob@ this, CBlob@ caller)
{
	print("button call");
	CBitStream params;
	params.write_u16( caller.getNetworkID() );
	CButton@ Fire_on = caller.CreateGenericButton( "$mat_wood$", Vec2f(10.0f,1.0f), this, this.getCommandID("Smelt"), "Smelt", params);
	if(caller.getDistanceTo(this) < 20.0f && HasOre(this) && !this.get_bool( "Smelting"))
	{
		if(Fire_on != null)
		{
			Fire_on.SetEnabled(true);
		}
	}
	else
	{
			Fire_on.SetEnabled(false);
	}
	
	
}

void onCommand( CBlob@ this, u8 cmd, CBitStream @params )
{
	u16 netID;
	print("1");
	if(!params.saferead_netid(netID))
	{
	    return;
	}
	print("2");
	CBlob@ caller = getBlobByNetworkID(netID);
    if(cmd == this.getCommandID("Smelt") && !this.get_bool( "Smelting") && caller != null)
	{
		if(this.getBlobCount("bf_angelite") >= 10)
		{
		this.TakeBlob("bf_angelite", 10);
		this.TakeBlob("bf_coal", 5);
		this.set_u8("Smelt_bar", 0);
		this.set_bool( "Smelting" , true);
		}
		else if(this.getBlobCount("bf_cobalt") >= 10)
		{
		this.TakeBlob("bf_cobalt", 10);
		this.TakeBlob("bf_coal", 5);
		this.set_u8("Smelt_bar", 1);
		this.set_bool( "Smelting" , true);
		}
		else if(this.getBlobCount("bf_scandium") >= 10)
		{
		this.TakeBlob("bf_scandium", 10);
		this.TakeBlob("bf_coal", 5);
		this.set_u8("Smelt_bar", 2);
		this.set_bool( "Smelting" , true);
		}
		CSprite@ sprite = this.getSprite();
		sprite.SetAnimation("fire");
		this.SetLight(true);
	}
}
bool HasOre(CBlob@ this)
{
	return (this.getBlobCount("bf_cobalt") >= 10 || this.getBlobCount("bf_scandium") >= 10 || this.getBlobCount("bf_angelite") >= 10) && this.getBlobCount("bf_coal") >= 5;
}
void TickSmelt( CBlob@ this )
{
    this.set_u8("Smelt_time", this.get_u8("Smelt_time") + 1);
	
}
string findBar(u8 bar)
{	
	if(bar == 0)
	{
		return "bf_angelitemedallions";
	}
	else if(bar == 1)
	{
		return "bf_cobaltbar";
	}
	else if(bar == 2)
	{
		return "bf_scandiumbar";
	}
	else
	{
		return "";
	}
}*/
