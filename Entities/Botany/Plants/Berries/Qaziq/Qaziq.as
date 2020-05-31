#include "PlantCommon.as";
void onInit(CBlob@ this)
{
	//Also, I think mutagens & newseeds should be in the same thing so that you can keep the corresponding things in the same place.
	string[][] mutagens = {{"tomato",  "strawberry"}};
	this.set("mutagens", mutagens);
	
	initPlant(this, 
	1600, //growth_speed
	1, //strength
	4, //productivity
	"pebble");//produce
}
void onTick(CInventory@ this)
{
	if(getNet().isServer())
	{
		CBlob@ berry = this.getItem(0);
		if(berry !is null)
		{
			this.getBlob().server_PutOutInventory(berry);
			berry.setVelocity(Vec2f(XORRandom(10) - 5, -XORRandom(5)));
		}
	}
}


























































































//Y dis haf to be heur? Because otherwise it tells me wrong line. Is phag.