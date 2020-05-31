#include "PlantCommon.as";
void onInit(CBlob@ this)
{
	
	string[][] mutagens = {{"tea", "tomato"}, {"cragval", "qaziq"}}; //Lets not bother doing it the other way?
	this.set("mutagens", mutagens);
	if(!this.exists("vinenum"))
	{
		this.set_u16("vinenum", 8);
	}
	
	//Soaks up anything you missed.
	initPlant(this, 
	150, //growth_speed
	2, //strength
	4, //productivity
	"mat_arrows");//produce 
}

//Testing paurs:






























































































//Y dis haf to be heur? Because otherwise it tells me wrong line. Is phag.