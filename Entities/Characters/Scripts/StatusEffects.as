#include "RunnerCommon.as"
#include "Hitters.as"
#include "Knocked.as"
#include "FireCommon.as"
void onInit(CBlob@ this)
{
	this.set_f32("dmgmult", 1.0f);
	this.set_f32("speedmult", 1.0f);
	this.set_f32("defence_multiplier", 1.0f);
	this.set_f32("rangemult", 1.0f);
}
void onTick(CBlob@ this)
{
	
	
	RunnerMoveVars@ moveVars;
	if(!this.get("moveVars", @moveVars))
	{
		return;
	}
	if(this.get_u32("charge") > 0){
		
		if(this.get("moveVars", @moveVars))
		{
			//print("bah");
			moveVars.walkFactor *= 2.0f;
			moveVars.jumpFactor *= 2.0f;
		}
		this.set_u32("charge",this.get_u32("charge")-1);
	}
	/*
	CPlayer@ player = this.getPlayer();
	
	if(player !is null)
	{
		print("lvl: " + player.get_u8("nathanlvl"));
		if (player.get_u8("nathanlvl") == 0 && player.get_f32("nathanexp") > 6.0f)
		{
			client_AddToChat("Leveled up to Level 2! New Ability: CHARGE", SColor(255, 125, 0, 0));
			player.set_u8("nathanlvl", 1);
			this.set_u8("nathanlvl", 1);
			player.set_f32("nathanexp", 0.0f);
		}
		else if (player.get_u8("nathanlvl") == 1 && player.get_f32("nathanexp") > 200.0f)
		{
			client_AddToChat("Leveled up to Level 3! New Ability: Back up", SColor(255, 125, 0, 0));
			player.set_u8("nathanlvl", 2);
			this.set_u8("nathanlvl", 2);
			player.set_f32("nathanexp", -1.0f);
		}
	}*/
	
	
	string weapon = this.get_string("weapon");
	if(weapon == "shadowblade")
	{
		moveVars.walkFactor *= 1.2f;
	}
	else if(weapon == "bladeoffeathers")
	{
		moveVars.walkFactor *= 1.2f;
		moveVars.jumpFactor *= 1.5f;
	}
	else if(weapon == "bloodatuns")
	{
		moveVars.jumpFactor *= 1.6f;
	}
	else if(weapon == "greatblade")
	{
		moveVars.walkFactor *= 0.4f;
	}
	else if(weapon == "titanbow" || weapon == "titanblade" || weapon == "titanpick")
	{
		moveVars.walkFactor *= 0.75f;
	}
	//-- Armor extra affects
	string armor = this.get_string("armor");
	if(armor == "tunic")
	{
		moveVars.walkFactor *= 1.4f;
	}
	else if(armor == "titanarmor")
	{
		moveVars.walkFactor *= 0.73f;
	}
	if( armor == "direplate" )
	{
		moveVars.jumpFactor *= 3.5f;
	}
	//-- Ring extra effects
	string misc = this.get_string("misc");
	if( misc == "hellfirering" )
	{
		this.set_s16(burn_timer, 0); //NO BURNO
	}
}


f32 onHit(CBlob@ this, Vec2f worldPoint, Vec2f velocity, f32 damage, CBlob@ hitterBlob, u8 customData)
{
	if(customData == Hitters::drown)
	{
		return damage;
	}
	
	if(damage <= 0)return damage;
	f32 def = 1;
	if(this.exists("defence_multiplier"))
	{
		def = this.get_f32("defence_multiplier");
	}
	damage *= def;
	
	return damage; 
}

void onHitBlob(CBlob@ this, Vec2f worldPoint, Vec2f velocity, f32 damage, CBlob@ hitBlob, u8 customData)
{
	if(this.getName() == "knight")
	{
		if(this.get_string("weapon") == "bladeofundead")
		{
			this.set_u8("zombiespawn",this.get_u8("zombiespawn") + 1.0f);
			if(this.get_u8("zombiespawn") > 5.0f )
			{
				CBlob@ skel2 = server_CreateBlob("skeleton");
				if(skel2 !is null)
				{
					skel2.server_setTeamNum(this.getTeamNum());
					skel2.setPosition(this.getPosition() + Vec2f(0.0f, -4.0f));
					skel2.server_SetTimeToDie(40);
				}
				this.set_u8("zombiespawn",0.0f);
			}
		}
		else if(this.get_string("weapon") == "bladeoflight")
		{
			this.server_Heal(0.25f);
		}
		else if(this.get_string("weapon") == "greed" && (hitBlob.hasTag("player")))
		{
			CPlayer@ player = this.getPlayer();
			if(player !is null)
			{
				player.server_setCoins(player.getCoins() + 5);
			}
		}
		else if(this.get_string("weapon") == "hammer")
		{
			SetKnocked(hitBlob, 60);
		}
	}
	
	return;
}

void onDie(CBlob@ this)
{
	if(!this.getBrain().isActive())
	{
		if(this.exists("weapon"))
		{
			CBlob@ weapon = server_CreateBlob(this.get_string("weapon"), -1, this.getPosition());
		}
		if(this.exists("armor"))
		{
			CBlob@ armor = server_CreateBlob(this.get_string("armor"), -1, this.getPosition());
		}
		if(this.exists("misc"))
		{
			CBlob@ misc = server_CreateBlob(this.get_string("misc"), -1, this.getPosition());
		}
	}
}