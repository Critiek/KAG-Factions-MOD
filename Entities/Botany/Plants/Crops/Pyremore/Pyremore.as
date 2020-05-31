#include "PlantCommon.as";
#include "MaterialCommon.as";
#include "FireCommon.as";
void onInit(CBlob@ this)
{
	this.Tag("fire source");
	string[][] mutagens = {{"n", "n"}, {"n", "n"}};
	this.set("mutagens", mutagens);
	
	initPlant(this, 
	1500, //growth_speed
	3, //strength
	4, //productivity
	"lantern");//produce
}

void onCollision(CBlob@ this, CBlob@ blob, bool solid, Vec2f normal, Vec2f point1)
{
	if(blob.hasTag("item") && this.hasTag("grown"))
	{
		string name = blob.getName();
		string creation = "mat_stone";
		int quantity = 60;
		if(name.find("stone") >= 0)
		{
			creation = "mat_stone";
		}
		else if(name.find("iron") >= 0)
		{
			creation = "mat_stone";
			quantity = 75;
		}
		else if(name.find("mithril") >= 0)
		{
			creation = "mat_stone";
			quantity = 100;
		}
		else if(name.find("platinum") >= 0)
		{
			creation = "mat_stone";
			quantity = 125;
		}
		else if(name.find("titan") >= 0)
		{
			creation = "mat_stone";
			quantity = 175;
		}
		else if(name.find("wood") >= 0)
		{
			creation = "mat_wood";
			quantity = 75;
		}
		else if(name == "greed")
		{
			creation = "mat_gold";
			quantity = 15;
		}
		Material::createFor(this, creation, quantity);
		blob.setVelocity(Vec2f_zero);
		blob.server_Die();
	}
}
//Testing paurs:






























































































//Y dis haf to be heur? Because otherwise it tells me wrong line. Is phag.