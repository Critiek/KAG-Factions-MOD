//Armor Init
#include "Hitters.as";
void onInit(CBlob@ this) //Called whenever a blob is created. 
{
	CShape@ shape = this.getShape(); //The shape of the object, as far as I understand, the shape stores the physics stuff of the blob - except mass. Stuff like bounciness, weight, gravity scale, air resistance, etc.
	shape.SetGravityScale(0.0f); //Stops it from being affected by gravity
	//Just realised you can fiddle with Drag in the blob's .cfg file.
	if(getNet().isServer()) //Calling any function with "server" before it needs to be called server-side only, which basically means do the "getNet().isServer()" check.
	{
		this.server_SetTimeToDie(1.5f); //The life of the blob I increased this to 1.5 instead of 1, because it felt right \^>^/
	}
}
void onCollision( CBlob@ this, CBlob@ blob, bool solid ) //Called whenever it collides...
{
	CPlayer@ p = this.getDamageOwnerPlayer();
	if(p is null) return;
	CBlob@ b = p.getBlob();
	if(b is null) return;
	if(getNet().isServer())
	{
		if(blob !is null) //This is checking to see if the blob is "null" - most of the time anything you collide with will be a blob. But if you collide with a block, this returns false.
		{
			if(b.getNetworkID() == blob.getNetworkID()) return;
			if(blob.hasTag("flesh") && blob.getTeamNum() == this.getTeamNum())
			{
				blob.setVelocity((this.getVelocity() / 2.0f) + blob.getVelocity()); //Knockback should stay on?
				blob.server_Heal(0.125f); //Amount healed, if I wanted to heal the blob that is calling the script (the beam), I would use "This" at the start, instead of blob.
			}
		}
		else //So basically, if we collide with something that is not a blob (aka, a block.. probably) Then destroy the projectile.
		{
			this.server_Die(); //Kill "this"
		}
	}
}
bool doesCollideWithBlob(CBlob@ blob) //This is called whenever this blob collides with another blobs. It must return either true or false (which is what the bool at the start means). If true, then that means it will collide, if false, then don't. It will still call the onCollide function when it collides, but it won't bounce back or treat the blob as solid. 
{
	return false;
}