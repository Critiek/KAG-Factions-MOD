//not server only so the client also gets the game event setup stuff

#include "GameplayEvents.as";
#include "Factions.as";

const int coinsOnDamageAdd = 1;
const int coinsOnKillAdd = 20;

const int coinsOnDeathLosePercent = 100;
const int coinsOnTKLose = 0;

const int coinsOnBuild = 1.5;
const int coinsOnBuildWood = 1.5;
const int coinsOnBuildWorkshop = 15;

string[] names;
u8 timer = 0;

Random _r(0xca7a);

void onTick(CRules@ this)
{
	timer++;
	if(timer < 30)
		return;

	for(int i = 0; i < getPlayerCount(); i++)
	{
		CPlayer@ p = getPlayer(i);
		if(p.getTeamNum() == 7)
		{
			if(p.getCoins() < 120)
				p.server_setCoins(p.getCoins()+_r.NextRanged(3));
		}
	}
	timer = 0;
}

void onPlayerDie(CRules@ this, CPlayer@ victim, CPlayer@ killer, u8 customData)
{ 
	if (!getNet().isServer())
		return;

	if(victim is null)
	{
		//print("victim is null in onPlayerDie");
		return;
	}
	if(killer is null)
	{
		//print("killer is null in onPlayerDie");
		return;
	}

	Factions@ f;
	this.get("factions", @f);

	Faction@ vFact = f.getFactionByMemberName(victim.getUsername());
	Faction@ kFact = f.getFactionByMemberName(killer.getUsername());

	if(vFact is null || kFact is null)
	{
		return;
	}

	if (killer !is victim && kFact.team != vFact.team)
	{
		killer.server_setCoins(killer.getCoins() + coinsOnKillAdd);
	}
	else if (kFact.team == vFact.team)
	{
		killer.server_setCoins(killer.getCoins() - coinsOnTKLose);
	}

	s32 lost = victim.getCoins() * (coinsOnDeathLosePercent * 0.01f);

	victim.server_setCoins(victim.getCoins() - lost);

	CBlob@ blob = victim.getBlob();
	
	if (blob !is null)
		server_DropCoins(blob.getPosition(), XORRandom(lost));
}


f32 onPlayerTakeDamage(CRules@ this, CPlayer@ victim, CPlayer@ killer, f32 DamageScale)
{
	if (!getNet().isServer())
		return DamageScale;
		
/////////////////////////////////////////////////////////
	if(victim is null)
	{
		//print("victim is null in onPlayerTakeDamage");
		return DamageScale;
	}
	if(killer is null)
	{
		//print("killer is null in onPlayerTakeDamage");
		return DamageScale;
	}

	Factions@ f;
	this.get("factions", @f);

	Faction@ vFact = f.getFactionByMemberName(victim.getUsername());
	Faction@ kFact = f.getFactionByMemberName(killer.getUsername());

	if(vFact is null || kFact is null)
	{
		return DamageScale;
	}

	killer.server_setCoins(killer.getCoins() + DamageScale * coinsOnDamageAdd / this.attackdamage_modifier);
	
	return DamageScale;
}

void onCommand(CRules@ this, u8 cmd, CBitStream @params)
{
	if (!getNet().isServer())
		return;

	if (cmd == getGameplayEventID(this))
	{
		GameplayEvent g(params);

		CPlayer@ p = g.getPlayer();
		if (p !is null)
		{
			u32 coins = 0;

			switch (g.getType())
			{
				case GE_built_block:

				{
					g.params.ResetBitIndex();
					u16 tile = g.params.read_u16();
					if (tile == CMap::tile_castle)
					{
						coins = coinsOnBuild;
					}
					else if (tile == CMap::tile_wood)
					{
						coins = coinsOnBuildWood;
					}
				}

				break;

				case GE_built_blob:

				{
					g.params.ResetBitIndex();
					string name = g.params.read_string();

					if (name.findFirst("door") != -1 ||
					        name == "wooden_platform" ||
					        name == "trap_block" ||
					        name == "spikes")
					{
						coins = coinsOnBuild;
					}
					else if (name == "building")
					{
						coins = coinsOnBuildWorkshop;
					}
				}

				break;
			}

			if (coins > 0)
			{
				p.server_setCoins(p.getCoins() + coins);
			}
		}
	}
}