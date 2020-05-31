#include "PlantCommon.as";
void onInit(CBlob@ this)
{
	
	string[][] mutagens = {{"qaziq", "strawberry"}, {"cragval", "iorn"}};
	this.set("mutagens", mutagens);
	if(!this.exists("vinenum"))
	{
		this.set_u16("vinenum", 4);
	}
	


	initPlant(this, 
	200, //growth_speed
	1.5f, //strength
	3, //productivity
	"tomatofruit");//produce 
}

//Testing paurs:






























































































//Y dis haf to be heur? Because otherwise it tells me wrong line. Is phag.