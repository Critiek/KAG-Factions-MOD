// Plant animation
#include "PlantCommon.as";
#include "PlantGrowthCommon.as";

void onInit(CSprite@ this)
{
	this.ReloadSprites(0, 0); //Alweys normal colurz
	CBlob@ blob = this.getBlob();
	this.SetZ(10.0f);
	this.getCurrentScript().tickFrequency = 30;
	if(!blob.hasTag("vine"))
	{
		CSpriteLayer@ dirt = this.addSpriteLayer("dirt", "DirtLayer.png", 16, 16);
		if(dirt !is null)
		{
			dirt.SetOffset(Vec2f(0, -5) - this.getOffset() / 2);
			dirt.SetRelativeZ(this.getRelativeZ()+0.5f);
			Animation@ wet = dirt.addAnimation("wet", 0, false);
			if(wet !is null)
			{
				dirt.SetAnimation(wet);
				wet.AddFrame(0);
			}
			Animation@ dry = dirt.addAnimation("dry", 0, false);
			if(dry !is null)
			{
				dry.AddFrame(1);
			}
			Animation@ mutatable = dirt.addAnimation("mutatable", 0, false);
			if(mutatable !is null)
			{
				mutatable.AddFrame(2);
			}
		}
	}
	CSpriteLayer@ status = this.addSpriteLayer("status", "PlantBubble.png", 32, 32);
	if(status !is null)
	{
		Animation@ anim = status.addAnimation("default", 0, false);
		if(anim !is null)
		{
			anim.AddFrame(0);
			anim.AddFrame(1);
			anim.AddFrame(2);
			//anim.AddFrame(3);
			status.SetAnimation(anim);
		}
		status.SetVisible(false);
		status.SetOffset(Vec2f(0, -25));
	}
}
void onTick(CSprite@ this)
{
	CBlob@ blob = this.getBlob();
	u8 water_level = blob.get_u8("water_level");
	u16 growth_stage = blob.get_u16("growth_stage");
	bool grown = blob.hasTag("grown");
	if(grown)
	{
		//this.getCurrentScript().runFlags |= Script::remove_after_this;
	}
	Animation @anim = this.getAnimation("growth");
	if (anim !is null)
	{
		int max_stage = anim.getFramesCount();
		
		this.SetAnimation(anim);
		anim.SetFrameIndex(Maths::Min(growth_stage, max_stage));
		//print("Growth stage: "+ growth_stage);
		if(growth_stage > max_stage)
		{
			CInventory@ inv = blob.getInventory();
			if(inv !is null && inv.getItemsCount() >= 1)
			{
				this.SetAnimation("berried");
			}
			else
			{
				if(blob.hasTag("vine") && blob.hasTag("flower"))
				{
					this.SetAnimation("flower");
				}
				else
				{
					this.SetAnimation("grown");
				}
			}
		}
	}
	if(!blob.hasTag("vine"))
	{
		CSpriteLayer@ dirt = this.getSpriteLayer("dirt"); //Dirteh stuff *c:*
		if(dirt !is null)
		{
			if(blob.hasTag("mutatable"))
			{
				dirt.SetAnimation("mutatable");
			}
			else if(water_level < 2)
			{
				dirt.SetAnimation("dry");
			}
			else
			{
				dirt.SetAnimation("wet");
			}
		}
	}
	u8 statusindex = getStatus(blob);
	CSpriteLayer@ status = this.getSpriteLayer("status");
	if(status !is null)
	{
		if(statusindex == 255)
		{
			status.SetVisible(false);
		}
		else
		{
			status.SetFrameIndex(statusindex);
			status.SetVisible(true);
		}
	}
	if(blob.hasTag("virus"))
	{
		ParticleAnimated("PoisonBubble.png", blob.getPosition() + Vec2f(XORRandom(10) - 5, XORRandom(4)), Vec2f(0, -(10 + XORRandom(10)) / 10.0f), 0.0f, 1.0f, 20.0f + XORRandom(30.0f), 0.03f, false);
	}
}
/*
void onTick(CSprite@ this)
{
	CBlob@ blob = this.getBlob();
	bool isGrown = blob.hasTag(grown_tag);
	if (isGrown)
	{
		Animation @anim = this.getAnimation("grown");
		if (anim !is null)
		{
			this.SetAnimation(anim);
			anim.setFrameFromRatio(1.0f - (blob.getHealth() / blob.getInitialHealth()));
		}
	}
	else
	{
		Animation @anim = this.getAnimation("growth");
		if (anim !is null)
		{
			this.SetAnimation(anim);
			u8 amount = blob.get_u8(grown_amount);
			f32 ratio = f32(amount) / f32(growth_max);

			anim.setFrameFromRatio(ratio);
		}
	}
}
*/