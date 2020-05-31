#include "PlantCommon.as";
void onInit(CBlob@ this)
{
	//Also, I think mutagens & newseeds should be in the same thing so that you can keep the corresponding things in the same place.
	string[][] mutagens = {{"jacobladder", "qaziq"}, {"splintling", "jacobladder"}, {"tomato", "iorn"}, {"iorn", "pyremore"}}; //Mutagen, result Should probably be a dictionary, but I'm not sure how 2 use, and it'd be useful to be able to have more than one result / mutagen.
	this.set("mutagens", mutagens);
	
	initPlant(this, 
	1100, //growth_speed
	1, //strength
	1, //productivity
	"boulder");//produce
}

//Testing paurs:






























































































//Y dis haf to be heur? Because otherwise it tells me wrong line. Is phag.