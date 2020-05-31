//Gotta completely redo growth.
#include "PlantGrowthCommon.as";
#include "PlantCommon.as";
#include "canGrow.as";
#include "Hitters.as";
#include "FireCommon.as";


void onTick(CBlob@ this)
{
	u8 water_level = this.get_u8("water_level");
	this.getCurrentScript().tickFrequency = 15;
	this.set_u8("water_level", Maths::Max(int(water_level) - 1, 0));
	if(this.isInWater())
	{
		if(water_level != max_level)
		{
			this.set_u8("water_level", max_level);
		}
	}
	else
	{
		this.set_u8("water_level", Maths::Max(int(water_level) - 1, 0));
	}
}
f32 onHit(CBlob@ this, Vec2f worldPoint, Vec2f velocity, f32 damage, CBlob@ hitterBlob, u8 customData)
{
	if(isWaterHitter(customData))
	{
		this.set_u8("water_level", max_level);
	}
	return damage;
}