#include "PlantCommon.as";
#include "MakeBotanySeed.as";
void onInit(CBlob@ this)
{
	this.addCommandID("CreateSeed");
	this.SetLight(true);
	this.SetLightRadius(64.0f);
	this.SetLightColor(SColor(255, 255, 240, 171));
}
void GetButtonsFor(CBlob@ this, CBlob@ caller)
{
	if(caller !is null)
	{
		CBitStream params;
		params.write_netid( caller.getNetworkID() );
		CButton@ button = caller.CreateGenericButton( "$mat_wood$", Vec2f(0, 0), this, this.getCommandID("CreateSeed"), "Create a seed from your held crops!", params);
	}
}
void onCommand( CBlob@ this, u8 cmd, CBitStream @params )
{
	if(cmd == this.getCommandID("CreateSeed"))
	{
		u16 netID;
		params.saferead_netid(netID);
		CBlob@ b = getBlobByNetworkID(netID);
		if(b !is null)
		{
			CBlob@ produce = b.getCarriedBlob();
			if(produce !is null)
			{
				if(getNet().isServer())
				{
					CBlob@ seed = server_makeSeedFromCutting(produce);
					if(seed !is null)
					{
						b.server_PutInInventory(seed);
					}
				}
			}
		}
	}
}