#include "PlantCommon.as";
void onInit(CBlob@ this)
{
	string[][] mutagens = {{"tea", "splintling"}, {"splintling", "cragval"}, {"jacobladder", "tomato"}};
	this.set("mutagens", mutagens);
	
	initPlant(this, 
	1000, //growth_speed
	1, //strength
	4, //productivity
	"tealeaf");//produce
}

//Testing paurs:






























































































//Y dis haf to be heur? Because otherwise it tells me wrong line. Is phag. Hart brake.