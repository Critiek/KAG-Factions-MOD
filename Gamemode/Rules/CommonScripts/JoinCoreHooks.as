//Join and leave hooks for rulescore

#include "RPGCommon.as";
#include "Factions.as";
#define SERVER_ONLY

void onNewPlayerJoin(CRules@ this, CPlayer@ player)
{
	RPGCore@ core;
	this.get("core", @core);

	if (core !is null)
	{
		core.AddPlayer(player);
		core.ChangePlayerTeam(player, 8);
		core.ChangePlayerTeam(player, 7);
	}
}

void onPlayerLeave(CRules@ this, CPlayer@ player)
{
	RPGCore@ core;
	this.get("core", @core);

	Factions@ f;
	this.get("factions", @f);

	string username = player.getUsername();

	Faction@ fact = f.getFactionByMemberName(username);
	if(fact !is null)//if you WERE in a faction before then..
	{
		fact.removeMember(username, false);//LEAVE
	}

	if (core !is null)
	{
		core.RemovePlayer(player);
	}
}
