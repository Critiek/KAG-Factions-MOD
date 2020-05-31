#include "PlantCommon.as";
void onInit(CBlob@ this)
{
	
	string[][] mutagens = {{"cragval", "pyremore"}};
	this.set("mutagens", mutagens);
	if(!this.exists("vinenum"))
	{
		this.set_u16("vinenum", 10);
	}
	
	//Soaks up anything you missed.
	initPlant(this, 
	50, //growth_speed
	5, //strength
	1, //productivity
	"pebble");//produce 
}

//Testing paurs:






























































































//Y dis haf to be heur? Because otherwise it tells me wrong line. Is phag.