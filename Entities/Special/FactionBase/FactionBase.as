#include "StandardRespawnCommand.as";

void onInit(CBlob@ this)
{
	this.set_TileType("background tile", CMap::tile_castle_back);

	this.getSprite().SetZ(-10); //background/
	this.getShape().getConsts().mapCollisions = false;

	this.set_Vec2f("shop offset", Vec2f_zero);

	//stuff from tentlogic.as
	InitClasses(this);
	this.Tag("change class drop inventory");

	this.Tag("faction_base");
	this.Tag("set");

	// minimap
	this.SetMinimapOutsideBehaviour(CBlob::minimap_snap);
	this.SetMinimapVars("GUI/Minimap/MinimapIcons.png", 1, Vec2f(8, 8));
	this.SetMinimapRenderAlways(true);
}

void GetButtonsFor(CBlob@ this, CBlob@ caller)
{
	// create menu for class change
	if (canChangeClass(this, caller) && caller.getTeamNum() == this.getTeamNum())
	{
		CBitStream params;
		params.write_u16(caller.getNetworkID());
		caller.CreateGenericButton("$change_class$", Vec2f(0, 0), this, SpawnCmd::buildMenu, "Swap Class", params);
	}
}

void onCommand(CBlob@ this, u8 cmd, CBitStream @params)
{
	onRespawnCommand(this, cmd, params);
}

void onChangeTeam( CBlob@ this, const int oldTeam )
{
	if(!this.hasTag("set"))
	{
		CBitStream params;
		params.write_u8(oldTeam);
		getRules().SendCommand(getRules().getCommandID("killFaction"), params);
		this.server_Die();
	}
	else
	{
		this.Untag("set");
	}
}