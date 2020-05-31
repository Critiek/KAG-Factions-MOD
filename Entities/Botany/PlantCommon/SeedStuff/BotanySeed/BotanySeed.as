#include "PlantCommon.as";
//MUUUUCH better xD
void onInit(CBlob@ this)
{
	this.getCurrentScript().tickFrequency = 50; //Meh.
	initSeed(this);
}
void onTick(CBlob@ this) //Making crop.
{
	if(getNet().isServer())
	{
		string crop = "";
		if(this.exists("crop"))	
		{
			crop = this.get_string("crop");
		}
		if(crop != "" && canGrow(this))
		{
			CBlob@ b = server_CreateBlobNoInit(crop);
			if(b !is null)
			{
				b.setPosition(this.getPosition());
				b.server_setTeamNum(this.getTeamNum());
				b.Init();
				copyMutation(this, b, false);
			}
			this.server_Die();
		}
	}
}
bool canGrow(CBlob@ this)
{
	CMap@ map = this.getMap();
	Vec2f pos = this.getPosition();
	bool groundTile = map.isTileGroundStuff(map.getTile(pos + Vec2f(0, 8)).type);
	if(groundTile && this.isOnGround() || this.getShape().isStatic())
	{
		CBlob@[] nearBlobs;
		if (map.getBlobsInRadius(pos, ((this.getRadius() * 1.5f)), @nearBlobs))
		{
			for(int i = 0; i < nearBlobs.length(); i++)
			{
				CBlob@ nearBlob = nearBlobs[i];
				if(nearBlob !is null && nearBlob.hasTag("plant"))
				{
					return false;
				}
			}
		}
		return true;
	}
	return false;
}