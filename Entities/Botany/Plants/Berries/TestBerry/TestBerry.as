#include "PlantCommon.as";
void onInit(CBlob@ this)
{
	
	this.set_string("produce", "log");
	string[] mutagens = {"mat_wood", "log"};
	this.set("mutagens", mutagens);
	string[] newseeds = {"newseeds", "keg"};
	this.set("newseeds", newseeds);
	
		initPlant(this, 
	500, //growth_speed
	2, //strength
	4, //productivity
	"tealeaf");//produce
}

//Testing paurs:






























































































//Y dis haf to be heur? Because otherwise it tells me wrong line. Is phag.