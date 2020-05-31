#include "PlantCommon.as";
CBlob@ server_makeSeedFromBlob(CBlob@ this) //Makes a seed of the plant in question. Can be done on any blob, but only plants will work.
{
	if(!getNet().isServer())
	{
		return null;
	}
	return server_makeBotanySeed(this.getTeamNum(), this.getPosition(), this.get_u16("strength"), this.get_u16("growth_speed"), this.get_f32("productivity"), this.getName(), this.getInventoryName() + " Seed");
	
}
CBlob@ server_makeSeedFromCutting(CBlob@ this) //Attempts to make a seed/cutting using produce. Can be done on any blob, but only those with seed info will work!
{
	if(!getNet().isServer())
	{
		return null;
	}//Get qualities from cutting, if there aren't any, then this isn't a cutting.
	if(!this.exists("strength"))
	{
		return null;
	}
	this.server_Die(); //Kills the pheg
	return(server_makeBotanySeed(this.getTeamNum(), this.getPosition(), this.get_f32("strength"), this.get_u16("growth_speed"), this.get_f32("productivity"), this.get_string("crop"), this.get_string("crop") + " Seed"));
}
CBlob@ server_makeBotanySeed(int team, Vec2f pos, f32 strength, u16 growth_speed, f32 productivity, string crop, string seedname)
{
	if(getNet().isServer())
	{
		CBlob@ seedblob = server_CreateBlob("botanyseed", team, pos); //Pospos pok pok. Tmp tmp tmpk.
		if(seedblob !is null)
		{
			seedblob.set_u16("growth_speed", growth_speed); 
			seedblob.set_f32("strength", strength); 
			seedblob.set_f32("productivity", productivity);
			seedblob.set_string("crop", crop);
			seedblob.Sync("growth_speed", true);
			seedblob.Sync("strength", true);
			seedblob.Sync("productivity", true);
			seedblob.Sync("crop", true);
			seedblob.setInventoryName(seedname);
		}
		return seedblob;
	}
	else
	{
		return null;
	}
}