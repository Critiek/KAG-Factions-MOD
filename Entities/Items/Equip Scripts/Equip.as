#include "RunnerTextures.as";
#include "EquipCommon.as";
void onInit( CBlob@ this )
{
	this.addCommandID("equip");
	this.set_u8("cooldown", 40);
	this.Sync("cooldown", true);
	this.Tag("item");
}

void GetButtonsFor( CBlob@ this, CBlob@ caller )
{
	CBitStream params;
	params.write_u16(caller.getNetworkID());
	//if(caller)
	if(this.get_u8("cooldown") == 1)
	{
		if(this.isAttachedTo(caller))
		{
			CButton@ button = caller.CreateGenericButton(15, Vec2f_zero, this, this.getCommandID("equip"), "Equip this Item!", params);
			if(button !is null)
			{
				if(this.hasTag(caller.getName()))
				{
					button.SetEnabled(true);
				}
				else
				{
					button.SetEnabled(false);
				}
			}
		}
		else
		{
			//No button.
		}
	}
}
void onCommand( CBlob@ this, u8 cmd, CBitStream @params )
{
	if (cmd == this.getCommandID("equip"))
	{
		CBlob@ caller = getBlobByNetworkID(params.read_u16());
		if (caller !is null)
		{
			CSprite@ callersprite = caller.getSprite();
			if(this.hasTag(caller.getName()) && this.isAttachedTo(caller))
			{
				if (this.hasTag("weapon"))
				{
					u8 weapontype = 0;
					if(this.exists("weapontype"))
					{
						weapontype = this.get_u8("weapontype");
					}
					if(caller.getName() == "archer")
					{
						CSpriteLayer@ weapon = callersprite.getSpriteLayer("frontarm");
						if(weapon !is null)
						{
							equipLayerTexture(caller, weapon, this.getSprite(), weapontype);
						}
					}
					else
					{
						CSpriteLayer@ weapon = callersprite.getSpriteLayer("weapon");
						if(weapon !is null)
						{
							equipLayerTexture(caller, weapon, this.getSprite(), weapontype);
						}
					}
					if(caller.exists("weapon"))
					{
						CBlob@ weapon = server_CreateBlob(caller.get_string("weapon"), -1, caller.getPosition());
					}
					
					
					float dmgmult = 1.0f;
					float speedmult = 1.0f; //The three variables you can fiddle with, they're set to 1.0f so that if you forget to set it on a weapon, it will not keep the old variable.
					float rangemult = 1.0f;
					uint16 cancelnum = 2310; // 2 * 3 * 5 * 7 * 11. Means it's gotta be a u16 D:
					
					caller.set_string("weapon", this.getName());
					
					if(this.exists("cancelnum"))
					{
						cancelnum = this.get_u16("cancelnum");
					}
					if(this.exists("dmgmult"))
					{
						dmgmult = this.get_f32("dmgmult");
					}
					if(this.exists("speedmult"))
					{
						speedmult = this.get_f32("speedmult");
					}
					if(this.exists("rangemult"))
					{
						rangemult = this.get_f32("rangemult");
					}
					
					caller.set_f32("dmgmult", dmgmult);
					caller.set_f32("speedmult", speedmult);
					caller.set_f32("rangemult", rangemult);
					caller.set_u16("cancelnum", cancelnum);
					this.server_Die();
				}
				else if (this.hasTag("armor"))
				{
					equipTexture(caller.getSprite(), this.getSprite());
					if(caller.exists("armor"))
					{
						CBlob@ armor = server_CreateBlob(caller.get_string("armor"), -1, caller.getPosition());
					}
					/*CSpriteLayer@ armor = caller.getSprite().getSpriteLayer("armor");
					if(armor !is null)//How do I get the name of the thing... FOUND IT \o/
					{
						armor.ReloadSprite(this.getSprite().getFilename());
						armor.SetFrame(1);
					}*/
					caller.set_string("armor",this.getName());
					if(this.exists("defence_multiplier"))
					{
						caller.set_f32("defence_multiplier", this.get_f32("defence_multiplier"));
					}
					
					this.server_Die();
				}
				else if (this.hasTag("misc"))
				{
					if(caller.exists("misc"))
					{
						CBlob@ misc = server_CreateBlob(caller.get_string("misc"), -1, caller.getPosition());
					}
					caller.set_string("misc",this.getName());
					this.server_Die();
				}
				else
				{
					warn("Couldn't find any weapon type tags for item: " + this.getName());
				}
			}
		}	
	}
}

void onTick(CBlob@ this) //I jus' realised what this is for \o/
{
	if(this.get_u8("cooldown") > 1)
	{
		this.set_u8("cooldown", this.get_u8("cooldown") - 1);
	}
}