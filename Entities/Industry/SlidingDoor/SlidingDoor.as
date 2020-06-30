// Swing Door logic

#include "GenericButtonCommon.as"
#include "Hitters.as"
#include "FireCommon.as"
#include "MapFlags.as";

void onInit(CBlob@ this)
{
	

	this.set_TileType("background tile", CMap::tile_castle_back);
	this.getSprite().SetZ(-50);

	AttachmentPoint@ SLIDE = this.getAttachments().getAttachmentPointByName("SLIDE");

	this.getShape().SetOffset(Vec2f(0,0));
	this.getShape().SetRotationsAllowed(false);

	this.Tag("blocks sword");
	this.Tag("blocks water");

	this.addCommandID("open");
	this.addCommandID("close");

	this.set_bool("state", true); // opened
}

void onTick(CSprite@ this)
{
	CBlob@ blob = this.getBlob();

	if (blob.hasTag("close"))
	{
		blob.Untag("close");
		this.SetAnimation("close");
	}

	if (blob.hasTag("open"))
	{
		blob.Untag("open");
		this.SetAnimation("open");
	}
}

void onTick(CBlob@ this)
{
	if (this.getTickSinceCreated()==10)
	{
		Vec2f tilepos = this.getPosition() + Vec2f(0, -20);
		Vec2f tilepos2 = this.getPosition() + Vec2f(0, 16);
		Vec2f tilepos3 = this.getPosition() + Vec2f(0, 8);
		Vec2f tilepos4 = this.getPosition() + Vec2f(0, -4);
		Vec2f tilepos5 = this.getPosition() + Vec2f(0, -8);
		Vec2f tilepos6 = this.getPosition() + Vec2f(0, -16);

		getMap().server_SetTile(tilepos, CMap::tile_castle_back);
		getMap().server_SetTile(tilepos2, CMap::tile_castle_back);
		getMap().server_SetTile(tilepos3, CMap::tile_castle_back);
		getMap().server_SetTile(tilepos4, CMap::tile_castle_back);
		getMap().server_SetTile(tilepos5, CMap::tile_castle_back);
		getMap().server_SetTile(tilepos6, CMap::tile_castle_back);

		CBlob@ slide = server_CreateBlob("slide", this.getTeamNum(), this.getPosition() - Vec2f(0,0));
			if (slide !is null)
			{
    			this.server_AttachTo(slide, "SLIDE");
			}
		this.getAttachments().getAttachmentPointByName("SLIDE").offset = Vec2f(-4,0);
	}
}

void GetButtonsFor(CBlob@ this, CBlob@ caller)
{
	bool state = this.get_bool("state");
	CBitStream params;
	params.write_u16(caller.getNetworkID());
	CBlob@ blob = getLocalPlayerBlob();
	if (blob.getTeamNum() == this.getTeamNum() && state == true)
	{
		caller.CreateGenericButton(11, Vec2f(0, 0), this, this.getCommandID("close"), "Close", params);
	}
	if (blob.getTeamNum() == this.getTeamNum() && state == false)
	{
		caller.CreateGenericButton(11, Vec2f(0, 0), this, this.getCommandID("open"), "Open", params);
	}
}

void onCommand(CBlob@ this, u8 cmd, CBitStream @params)
{
	if (cmd == this.getCommandID("close"))
	{
		this.Untag("open");
		this.Tag("close");

		Sound::Play("/SlidingDoor.ogg", this.getPosition(), 1.00f, 1.00f);
		this.getAttachments().getAttachmentPointByName("SLIDE").offset = Vec2f(-4,20);

		this.set_bool("state", false);
	}

	if (cmd == this.getCommandID("open"))
	{
		this.Tag("open");
		this.Untag("close");

		Sound::Play("/SlidingDoor.ogg", this.getPosition(), 1.00f, 1.00f);
		this.getAttachments().getAttachmentPointByName("SLIDE").offset = Vec2f(-4,0);

		this.set_bool("state", true);
	}
}