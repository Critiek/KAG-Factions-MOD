#include "PlantCommon.as";
void onInit(CBlob@ this)
{
	string[][] mutagens = {{"tea", "cragval"}, {"cragval", "jacobladder"}};
	this.set("mutagens", mutagens);
	
	initPlant(this, 
	500, //growth_speed
	1, //strength
	4, //productivity
	"log");//produce
}

//Testing paurs:






























































































//Y dis haf to be heur? Because otherwise it tells me wrong line. Is phag.