#include "PlantCommon.as";
void onInit(CBlob@ this)
{
	CInventory@ inv = this.getInventory();
	this.Tag("vine"); //Hrumph.
}
void onTick(CBlob@ this)
{
	if(getNet().isServer())
	{
		u16 vinenum = this.get_u16("vinenum");
		if(this.get_u16("vinenum") >= 1)
		{
			Animation @anim = this.getSprite().getAnimation("growth");
			if (anim !is null)
			{
				u16 max_stage = anim.getFramesCount();
				u16 growth_stage = this.get_u16("growth_stage");
				u32 growth_time = this.get_u16("growth_speed");
				//print("Vine num: " + vinenum);
				//print("this.getTickSinceCreated()" + this.getTickSinceCreated());
				//print("(growth_time) + (growth_time * max_stage)" + ((growth_time) + (growth_time * max_stage)));
				if(/*this.getTickSinceCreated() > (growth_time) + (growth_time * max_stage)*/ growth_stage >= max_stage)
				{
					CBlob@ b = server_CreateBlob(this.getName(), this.getTeamNum(), this.getPosition() + Vec2f(0, -8)); //Instead make copycat blob that doesn't require the setting of 101 moar variabrus?
					if(b !is null)
					{
						copyMutation(this, b, false); //Should it mutate vine-to-vine?
						b.set_u16("vinenum", Maths::Max(int(vinenum - 1), 0));
						b.Sync("vinenum", true);
						b.Tag("flower");
						b.Sync("flower", true);
						this.Untag("flower"); //Pass the beacon :3
					}
					this.getCurrentScript().runFlags |= Script::remove_after_this;
				}
			}
		}
	}
}