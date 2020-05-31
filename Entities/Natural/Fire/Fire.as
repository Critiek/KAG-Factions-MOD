// Fireplace

#include "ProductionCommon.as";
#include "Requirements.as";
#include "FireParticle.as";

void onInit( CBlob@ this )
{
	this.getShape().getConsts().mapCollisions = false;
	this.getSprite().SetEmitSound( "Fire.ogg" );

	this.SetLight( false );
	this.SetLightRadius( 0.0f );
	this.SetLightColor( SColor(255, 255, 127, 255 ) );
	
	this.set_u32("fuel", 200);

	this.Tag("fire source");
	//this.server_SetTimeToDie(60*3);
	this.getSprite().SetZ(-500.0f);
}

void onTick( CBlob@ this )
{
	CSprite@ sprite = this.getSprite();
	
	float fuel = this.get_u32("fuel");
	if(fuel > 0)sprite.SetAnimation("small"); 
	if(fuel > 30)sprite.SetAnimation("medium"); 
	if(fuel > 60)sprite.SetAnimation("big"); 
	
	CSpriteLayer@ fire = sprite.getSpriteLayer("fire_animation_large");
	
	if(fuel > 0)
	{
		this.getSprite().SetEmitSoundPaused( false );
		this.SetLight(true);
		this.SetLightRadius(fuel > 150 ? 150 : fuel + 10);
		this.SetLightColor(SColor(255 - 64 + XORRandom(64), 255, fuel > 150 ? 255: fuel / 150.0f * 255.0f,  fuel > 150 ? 127: fuel / 150.0f * 127.0f ));
		this.getSprite().SetEmitSoundVolume(fuel > 150 ? 3.0f : fuel/50.0f);
		if(getGameTime() % getTicksASecond() == 0)
		{
			if(fuel-1 > 0)
				fuel--; 
		}
		if(XORRandom(4) == 0)
		{
		if (XORRandom(3) == 0)
		{
			makeSmokeParticle(this.getPosition(), -0.05f);
	
			this.getSprite().SetEmitSoundPaused( false );
		}
		else
			makeFireParticle(this.getPosition() + getRandomVelocity( 90.0f, 3.0f, 360.0f ));
		}
		
		if (this.isInWater())
		{
			this.getSprite().Gib();
			this.server_Die();
			this.getCurrentScript().runFlags |= Script::remove_after_this;
		}
	}

	this.set_u32("fuel", fuel);
}


void onCollision( CBlob@ this, CBlob@ blob, bool solid )
{
	int fuel = this.get_u32("fuel");
	if (blob !is null && fuel < 300)
	{
		if (blob.getName() == "log")
		{
			blob.getSprite().PlaySound("SparkleShort.ogg");
			fuel += 100;
			blob.server_Die();			
		}
	}
	this.set_u32("fuel", fuel);
}

void onInit( CSprite@ this )
{
	this.SetZ(-50); //background

	//init flame layer
	CSpriteLayer@ fire = this.addSpriteLayer( "fire_animation_large", "Entities/Effects/Sprites/LargeFire.png", 16, 16, -1, -1 );

	if (fire !is null)//a
	{
		fire.SetRelativeZ( 100 );
		{				
			Animation@ anim = fire.addAnimation( "bigfire", 6, true );
			anim.AddFrame(1);
			anim.AddFrame(2);
			anim.AddFrame(3);
		}
		{
			Animation@ anim = fire.addAnimation( "smallfire", 6, true );
			anim.AddFrame(4);
			anim.AddFrame(5);
			anim.AddFrame(6);
		}
		fire.SetVisible( false );
	}
}