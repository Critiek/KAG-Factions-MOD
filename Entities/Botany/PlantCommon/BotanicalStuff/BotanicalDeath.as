#include "PlantCommon.as";
//Create produce on death, also check for crossbreeding.
void onDie(CBlob@ this)
{
	Vec2f pos = this.getPosition();
	int teamNum = this.getTeamNum();
	if(this.hasTag("virus"))
	{
		return;
	}
	f32 productivity = this.get_f32("productivity");
		string produce = this.get_string("produce");
	if(this.hasTag("grown") || this.hasTag("flower"))
	{
		if(getNet().isServer())
		{
			if(!this.hasTag("berry") && produce != "" && (this.hasTag("flower") || !this.hasTag("vine")))//TODO: Move this to a seperate script?
			{
				for(int i = 0; i < productivity; i++)
				{
					server_CreateProduce(produce, teamNum, pos, this);
				}
			}
		}
		bool bork = false; //BORK BORK
		//Crossbreeding. I think this is probably a crap way of doing it, not sure...
		CBlob@[] nearBlobs;
		string[][] mutagens;
		if(this.hasTag("mutatable")
		&& this.get("mutagens", mutagens)
		&& this.getMap().getBlobsInRadius(pos, 50.0f, @nearBlobs))//If you don't bother to set these then it'll simply ignore I think
		{
			for(int n = 0; n < mutagens.length(); n++)
			{
				if(bork)
				{
					break;
				}
				for(int i = 0; i < nearBlobs.length(); i++)//Go through all blobs in area
				{
					if(bork)
					{
						break;
					}
					CBlob@ nearBlob = nearBlobs[i];
					if(nearBlob !is null && this !is nearBlob) //Tea mutating with tea!
					{
						string blobname = nearBlob.getName();
						if(blobname == mutagens[n][0] && nearBlob.hasTag("mutatable"))
						{
							this.getSprite().PlaySound("/Thunder1.ogg");
							if(getNet().isServer())
							{
								CBlob@ b = server_CreateBlob(mutagens[n][1], teamNum, pos);
								return;
							}
							break; //Not sure if this breaks out of the whole thing or not..
							bork = true;
						}
					} 	
				}
			}
		}
	}
}