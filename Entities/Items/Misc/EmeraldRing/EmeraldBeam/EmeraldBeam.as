//Armor Init
#include "Hitters.as";
void onInit(CBlob@ this)
{
	CShape@ shape = this.getShape();
	shape.SetGravityScale(0.0f);
	if(getNet().isServer())
	{
		this.server_SetTimeToDie(1.0f);
	}
}
void onCollision( CBlob@ this, CBlob@ blob, bool solid )
{
	if(getNet().isServer())
	{
		if(blob !is null)
		{
			
			CPlayer@ p = this.getDamageOwnerPlayer();
			if(p is null) return;
			CBlob@ b = p.getBlob();
			if(b is null) return;
			if(b.getNetworkID() == blob.getNetworkID()) return;
			
			
			if(blob.hasTag("flesh") && blob.getTeamNum() != this.getTeamNum())
			{
				blob.setVelocity((this.getVelocity() * 1.0f) + blob.getVelocity());
				this.server_Hit(blob, this.getPosition(), this.getVelocity(), 0.125f, Hitters::sword, false);
			}
		}
		else
		{
			this.server_Die();
		}
	}
}
bool doesCollideWithBlob(CBlob@ blob)
{
	return false;
}