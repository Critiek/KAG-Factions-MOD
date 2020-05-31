#include "Factions.as";
#include "RulesCore.as";
#include "RespawnSystem.as";
#include "CTF_Structs.as";
#include "Rules/CommonScripts/BaseTeamInfo.as";



shared class RPGRespawns : RespawnSystem
{
	s16[] used;

    RPGCore@ c;

    CRules@ rules;

    CTFPlayerInfo@[] spawns;

    RPGRespawns(CRules@ _rules)
    {
        super();
        @rules = _rules; 
    }

    void SetCore(RulesCore@ _core)
    {
        RespawnSystem::SetCore(_core);
        @c = cast < RPGCore@ > (core); 
    }
    void Update()
    {
        for (uint i = 0; i < spawns.length; i++)
        {
            CTFPlayerInfo@ info = cast <CTFPlayerInfo@> (spawns[i]);

            if(info !is null)
            {
                DoSpawnPlayer(info); 
            }
        }
    }
    void AddPlayerToSpawn(CPlayer@ player)
    {
        CTFPlayerInfo@ info = cast <CTFPlayerInfo@> (core.getInfoFromPlayer(player));

        if (info is null) 
        { 
            //print("hello from AddPlayerToSpawn a");
            return;  
        }

        RemovePlayerFromSpawn(info);
        
        if (player.getTeamNum() == core.rules.getSpectatorTeamNum())
        {
            //print("hello from AddPlayerToSpawn b");
            return;  
        }

        spawns.push_back(info); 
    }
    void RemovePlayerFromSpawn(CTFPlayerInfo@ p_info)
    {
        if (p_info is null) 
        { 
            //print("hello from RemovePlayerFromSpawn");
            return; 
        }

        for(int i = 0; i < spawns.length; i++)
        {
            CTFPlayerInfo@ info = cast <CTFPlayerInfo@> (spawns[i]);
            if(info is p_info)
            {
                spawns.removeAt(i);
                i--;
            }
        } 
        //print(""+spawns.length);
    }
    void DoSpawnPlayer(CTFPlayerInfo@ p_info)
    {
        if(canSpawnPlayer(p_info))
        {
            CPlayer@ player = getPlayerByUsername(p_info.username);

            if (player is null)
            {
                //print("hello from DoSpawnPlayer");
                return;
            }
            
            Respawn(rules, player);
            RemovePlayerFromSpawn(player); 
        }
    }
    bool canSpawnPlayer(CTFPlayerInfo@ p_info)
    {
        if (p_info is null)
        {
            //print("hello from canSpawnPlayer a");
            return false; 
        }
		Factions@ f;
		rules.get("factions", @f);
        CPlayer@ p = getPlayerByUsername(p_info.username);
		bool isRaider = false;
		if(isRaider && getGameTime() % 1750 <= 30)
		{
			return false;
		}
        if(p is null)
        {
            //print("hello from canSpawnPlayer b");
            return false;
        }
        if(!isSpawning(p))
        {
            //print("hello from canSpawnPlayer c");
            return false;
        }
		
		Faction@ target = f.getFactionByMemberName(p.getUsername());
		if(target !is null)
		{
			isRaider = (target.name == "Raiders");
		}
        int x;
        p.get("lsr", x);

        bool sp = p_info.lastSpawnRequest > x + getTicksASecond()*(p.getTeamNum() == 7 ? 1 : (isRaider ? 30 : 15));

        if(sp)
        {
            RemovePlayerFromSpawn(p);
            p.set("lsr", p_info.lastSpawnRequest);
            //print("hello from canSpawnPlayer d");
            return true;
        }
        else
        {
            p_info.lastSpawnRequest = getGameTime();
        }

        //print("hello from canSpawnPlayer e");
        return false;
    }
    CBlob@ Respawn( CRules@ _rules, CPlayer@ player )
    {
        if (player !is null)
        {
            CBlob@ blob = player.getBlob();
            

            Factions@ f;
            _rules.get("factions", @f);

            RPGCore@ rc;
            _rules.get("core", @rc);

            s8 team = -1;
            
            string Class = "migrant";
            Vec2f spawnloc = getSpawnLocation(player);
			bool isRaider = false;
            Faction@ target = f.getFactionByMemberName(player.getUsername());
            if(target !is null)
            {
                team = target.getTeamNum();
				if(target.name == "Raiders")
				{
					isRaider = true;
					Class = "knight";
					if(f.factions.length >= 2)
					{
						spawnloc = getBaseLocation(f.factions[(getGameTime() % (f.factions.length - 1)) + 1].team);//Need to get the base location of an enemy, the first faction's always the raider faction.
						int number = XORRandom(100) + 500;
						if((getGameTime() / 2) % 2 == 1) //Might not work. We'll have to see C:
						{
							number *= 1;
						}
						else
						{
							number *= -1;
						}
						spawnloc.x += number;
					}
					
				}
				else
				{
					Class = "builder";
					spawnloc = getBaseLocation(team);
				}
            }
			//This doesn't work if i put it as a const. And I don't think it's much worse off here.
			string[] swords =  //Should be in order of strength.
			{
				"woodenblade",
				"woodenblade",
				"stoneblade",
				"stoneblade",
				"ironblade",
				"ironpartisan",
				"mithrildagger",
				"mithrilblade",
				"platinumblade",
				"platinumblade",
				"shadowblade",
				"shadowblade",
				"titanblade"
			};
			string[] armor =  //Should be in order of strength.
			{
				"tunic",
				"woodenarmor",
				"woodenarmor",
				"stonearmor",
				"stonearmor",
				"ironarmor",
				"ironarmor",
				"ironarmor",
				"mithrilarmor",
				"mithrilarmor",
				"platinumarmor",
				"platinumarmor",
				"titanarmor"
			};
			CBlob@ newBlob = server_CreateBlob(Class,team,spawnloc);
			if(newBlob !is null)
			{
				newBlob.server_SetPlayer(player);
				if(isRaider)
				{
					newBlob.setVelocity(Vec2f(0, -6));
					CBlob@ crate = server_CreateBlob("raft", newBlob.getTeamNum(), spawnloc);
					if(crate !is null)
					{
						crate.server_SetTimeToDie(14);
						crate.getShape().setDrag(5.0f);
						crate.setVelocity(Vec2f(0, 4)); //Will still go under, but won't spawn in the dirt if you spawn on something.
					}
					CBlob@ chicken = server_CreateBlob("chicken", newBlob.getTeamNum(), spawnloc);
					if(chicken !is null)
					{
						chicken.server_SetTimeToDie(14);
						chicken.setVelocity(Vec2f(0, 0));
						newBlob.server_Pickup(chicken);
					}
					newBlob.Tag("raider");
					{
						CBlob@ b = server_CreateBlob("knight", newBlob.getTeamNum(), spawnloc);
						if(b !is null)
						{
							newBlob.server_PutInInventory(b);
							b.getBrain().server_SetActive(true);
						}
					}
					{
						CBlob@ b = server_CreateBlob("knight", newBlob.getTeamNum(), spawnloc);
						if(b !is null)
						{
							newBlob.server_PutInInventory(b);
							b.getBrain().server_SetActive(true);
							newBlob.server_SetHealth(newBlob.getInitialHealth() * 2.0f + (XORRandom(2) / 4));
						}
					}
					float difficulty = getGameTime() / 17000;
					difficulty = Maths::Floor(difficulty);
					newBlob.server_SetHealth(newBlob.getInitialHealth() * 0.5 + (XORRandom(2) / 4));
					{ //spawn armor.
						CBlob@ b = server_CreateBlob(swords[Maths::Min(difficulty + XORRandom(2), swords.length - 1)], newBlob.getTeamNum(), spawnloc);
						if(b !is null)
						{
							newBlob.server_PutInInventory(b);
						}
					}
					{
						CBlob@ b = server_CreateBlob(armor[Maths::Min(difficulty, armor.length - 1)], newBlob.getTeamNum(), spawnloc);
						if(b !is null)
						{
							newBlob.server_PutInInventory(b);
						}
					}
				}
			}
	    
			if(blob !is null)
			{
				blob.server_SetPlayer(null);
				blob.server_Die();
			}
			return newBlob;
        }
        return null;
    }

    Vec2f getSpawnLocation( CPlayer@ player )
    {
        Vec2f[] spawnpoints;
    
        if (getMap().getMarkers("rpg_spawn", spawnpoints )) 
        {
            return spawnpoints[ XORRandom( spawnpoints.length ) ];
        }
        return Vec2f(0,0);
    }

    Vec2f getBaseLocation(u8 x)
    {
        CBlob@[] bases;
        getBlobsByTag("faction_base", @bases);
        for(int i = 0; i < bases.length; i++)
        {
            if(bases[i].getTeamNum() == x)
            {
                return bases[i].getPosition();
            }
        }
        return Vec2f(0,0);
    }

    /*s16 getNeutralTeam()
    {
    	used.clear();
    	CBlob@[] all;
		getBlobsByTag("player", @all);
		for(int i = 0; i < all.length; i++)
		{
			CBlob@ b = all[i];
			if(b.getTeamNum() < -1)// all neutral players
			{
				used.push_back(b.getTeamNum());
			}
		}
		//brute force random team finding
		s16 newTeam = 0;
		s16 temp = 0;
		bool bad = false;
		while(newTeam == 0)
		{
			temp = XORRandom(230);//gonna have to assume we are never going to have more that 200 players
			temp -= 231;
			for(int i = 0; i < used.length; i++)
			{
				if(temp == used[i])
				{
					bad = true;
					break;
				}
			}
			if(bad)
			{
				continue;
			}
			newTeam = temp;
		}

		return newTeam;
    }*/
    bool isSpawning(CPlayer@ player)
    {
        if(player !is null)
        {
            if(player.getBlob() !is null)
            {
                ////print("hello from isSpawning false");
                return false;
            }
            return true;
        }
        return true;
    }
    CTFPlayerInfo@ getInfoFromName(string username)
    {
        for (uint k = 0; k < spawns.length; k++)
        {
            if (spawns[k].username == username)
            {
                return spawns[k];
            }
        }

        return null;
    }
};

shared class RPGCore : RulesCore
{
    RPGRespawns@ rpgrespawns;

    RPGCore() 
    { 
        super();
        error("DO NOT DO THIS! INITIALISE WITH RULESCORE(RULES,RESPAWNS)"); 
    }

    RPGCore(CRules@ _rules, RespawnSystem@ _respawns) 
    { 
        super(_rules, _respawns);
    }

    //delay setup
    RPGCore(bool delay_setup) { if (delay_setup == false) error("RULESCORE: Delayed setup used incorrectly"); }

    void Setup(CRules@ _rules = null, RespawnSystem@ _respawns = null)
    {
        @rules = _rules;
        @rpgrespawns = cast <RPGRespawns@> (_respawns);

        if (rpgrespawns !is null)
        {
            rpgrespawns.SetCore(this);
        }

        SetupTeams();
        SetupPlayers();
        AddAllPlayersToSpawn(); 
    }

    void Update()
    {
        if (rpgrespawns !is null)
        {
            rpgrespawns.Update();
        }
        else
        {
            ////print("hello from Update");
        }
    }
    void SetupTeams()
    {
        teams.clear();
            
        //AddTeam(rules.getTeam(0));
    }

    void AddPlayerSpawn(CPlayer@ player)
    {

        CTFPlayerInfo@ p = rpgrespawns.getInfoFromName(player.getUsername());
        if (p is null)
        {
            AddPlayer(player);
            ////print("hello from AddPlayerSpawn a");
        }
        else
        {
            if (p.lastSpawnRequest != 0 && p.lastSpawnRequest + 5 > getGameTime()) // safety - we dont want too much requests
            {
                //printf("too many spawn requests " + p.lastSpawnRequest + " " + getGameTime());
                ////print("hello from AddPlayerSpawn b");
                return;
            }
        }

        if (player.lastBlobName.length() > 0 && p !is null)
        {
            p.blob_name = filterBlobNameToSpawn(player.lastBlobName, player);
        }

        if (rpgrespawns !is null)
        {
            rpgrespawns.RemovePlayerFromSpawn(player);
            rpgrespawns.AddPlayerToSpawn(player);
            
            if (p !is null)
            {
                p.lastSpawnRequest = getGameTime();
                player.set("lsr", getGameTime());
            }
            else
            {
                ////print("hello from AddPlayerSpawn c");
            }
        }
    }

    void ChangePlayerTeam(CPlayer@ player, int newTeamNum)
    {
        if(player is null)
            return;

        CTFPlayerInfo@ p = rpgrespawns.getInfoFromName(player.getUsername());

        if(p is null)
            return;

        if (p.team != newTeamNum)
        {
            if (g_debug > 0)
                print("CHANGING PLAYER TEAM FROM " + p.team + " to " + newTeamNum);
        }
        else
        {
            return;
        }

        if (rpgrespawns !is null)
        {
            rpgrespawns.RemovePlayerFromSpawn(player);
        }

        ChangeTeamPlayerCount(p.team, -1);
        ChangeTeamPlayerCount(newTeamNum, 1);

        //RemovePlayerBlob(player);

        u8 oldteam = player.getTeamNum();
        p.setTeam(newTeamNum);
        player.server_setTeamNum(newTeamNum);

        rpgrespawns.AddPlayerToSpawn(player);
    }

    void AddAllPlayersToSpawn()
    {
        uint len = rpgrespawns.spawns.length;
        uint salt = XORRandom(len);
        for (uint k = 0; k < len; k++)
        {
            CTFPlayerInfo@ p = rpgrespawns.spawns[((k + salt) * 997) % len];
            p.lastSpawnRequest = 0;
            CPlayer@ player = getPlayerByUsername(p.username);
            AddPlayerSpawn(player);
        }
    }

    void AddPlayer(CPlayer@ player, u8 team = 0, string default_config = "")
    {
        CTFPlayerInfo@ check = rpgrespawns.getInfoFromName(player.getUsername());
        if (check is null)
        {
            CTFPlayerInfo p(player.getUsername(), team, default_config);
            rpgrespawns.spawns.push_back(@p);
            ChangeTeamPlayerCount(p.team, 1);
        }
    }

    void onPlayerDie(CPlayer@ victim, CPlayer@ killer, u8 customData)
    {
        AddPlayerSpawn(victim);
    }
};
