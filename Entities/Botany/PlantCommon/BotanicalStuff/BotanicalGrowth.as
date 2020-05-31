//Gotta completely redo growth.
#include "PlantGrowthCommon.as";
#include "PlantCommon.as";
#include "canGrow.as";
#include "Hitters.as";

/*void onInit(CBlob@ this)
{
	if (!this.exists(grown_amount))
		this.set_u8(grown_amount, 0);
	if (!this.exists(growth_chance))
		this.set_u8(growth_chance, default_growth_chance);
	if (!this.exists(growth_time))
		this.set_u8(growth_time, default_growth_time);

	if (this.hasTag("instant_grow"))
		this.set_u8(grown_amount, growth_max);
}*/
void onInit(CBlob@ this)
{
	this.addCommandID("Mutate");
	this.Tag("plant");
	this.Tag("builder always hit");
	if(this.exists("growth_speed"))
	{
		u16 growth_speed = this.get_u16("growth_speed");
		this.getCurrentScript().tickFrequency = growth_speed * (this.isInWater() ? 8 : 1); // Grow way slower in water.
//Ingenious Geti! ... I think
	}
}

void GetButtonsFor(CBlob@ this, CBlob@ caller) //Mutagen stuff.
{
	CBitStream params;
	params.write_netid( caller.getNetworkID() );
	CBlob@ cureblob = caller.getCarriedBlob();
	if(cureblob !is null && cureblob.getName() == "mutagen" && !this.hasTag("mutatable"))
	{
		CButton@ button = caller.CreateGenericButton( "$mutagen$", Vec2f(0, 0), this, this.getCommandID("Mutate"), "Make this plant susceptible to crossbreeding.", params);
	}
}

void onTick(CBlob@ this) //Manage des shet server-side only?
{
	if(getNet().isServer())
	{
		if(getStatus(this) == 255)
		{
			u16 growth_stage = this.get_u16("growth_stage");
			u16 growth_speed = this.get_u16("growth_speed");
			this.getCurrentScript().tickFrequency = growth_speed; //Ingenious Geti! ... I think
			growth_stage += 1;
			this.set_u16("growth_stage", growth_stage);
			this.Sync("growth_stage", true);
			CSprite@ sprite = this.getSprite();
			if(!this.hasTag("grown"))
			{
				Animation@ anim = sprite.getAnimation("growth");
				
				if(anim !is null && sprite.isAnimation("growth"))
				{
					if(growth_stage > anim.getFramesCount())
					{
						this.Tag("grown");
						this.Sync("grown", true);
						//GROWN.
					}
				}
			}
		}
	}
}

void onCommand( CBlob@ this, u8 cmd, CBitStream @params )
{
	if(cmd == this.getCommandID("Mutate"))
	{
		u16 netID;
		params.saferead_netid(netID);
		CBlob@ b = getBlobByNetworkID(netID);
		if(b !is null)
		{
			CBlob@ cureblob = b.getCarriedBlob();
			if(cureblob !is null && cureblob.getName() == "mutagen")
			{
				if(getNet().isServer())
				{
					cureblob.server_Die();
				}
				this.Tag("mutatable");
			}
		}
	}
}