#include "Factions.as";
#include "RPGCommon.as";
#include "MakeSign.as";
//#define SERVER_ONLY;

void onRestart( CRules@ this )
{
    this.server_setShowHoverNames(false);

    Factions _factions();
    this.set("factions", @_factions);
	
	Factions@ f;
	this.get("factions", @f);
    RPGRespawns res(this);
    RPGCore core(this, res);
    this.set("core", @core);

    this.SetCurrentState(GAME);
    AddSpawnSigns();
    for(int i = 0; i < getPlayerCount(); i++)
    {
        CPlayer@ p = getPlayer(i);
        if(p !is null)
            p.server_setTeamNum(7);//aka factionless
    }
	CMap@ map = getMap();
	{
	string name = "Raiders";
	//CBlob@ raiderBase = server_CreateBlob("factionbase", 4, Vec2f(map.tilemapwidth / 2 * map.tilesize, map.tilemapheight / 2 * map.tilesize)); //RAIDERS GOT NO BASE YO
	//if(raiderBase !is null)
	{
		f.createFaction(name, "nobody");
		Faction@ fact2 = f.getFactionByName(name);
		//raiderBase.server_setTeamNum(fact2.team);
		//raiderBase.Tag("raiderbase");
	}
	}
/*
	{
	string name = "GOUH";
	
	CBlob@ raiderBase = server_CreateBlob("factionbase", 4, Vec2f(map.tilemapwidth / 2 * map.tilesize, map.tilemapheight / 8 * map.tilesize));
	if(raiderBase !is null)
	{
		f.createFaction(name, "nobody");
		Faction@ fact2 = f.getFactionByName(name);
		raiderBase.server_setTeamNum(fact2.team);
		raiderBase.Tag("raiderbase");
	}
	}
*/
}

void onInit( CRules@ this )
{
    onRestart( this );
}

void AddSpawnSigns()
{
    if(getNet().isClient())
        return;
    Vec2f[] spawnpoints;
    CMap@ map = getMap();
    if(map !is null)
    {
        map.getMarkers("rpg_spawn", spawnpoints );
        for(uint i = 0; i < spawnpoints.length; ++i)
        {
            CBlob@ b = createSign(spawnpoints[i]+Vec2f(0,8),"Type !help to learn the faction commmands");
            b.Tag("spawnsign");
        }
    }
}