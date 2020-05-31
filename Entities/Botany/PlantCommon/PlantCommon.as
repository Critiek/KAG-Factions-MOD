const u8 max_level = 140; //Max water level.
void initPlant(CBlob@ this, u16 growth_speed, f32 strength, f32 productivity, string produce)//All de variabrus that plants hab!
{
	if(!this.exists("growth_stage"))
	this.set_u16("growth_stage", 0);
	if(!this.exists("growth_speed"))
	this.set_u16("growth_speed", growth_speed);
	if(!this.exists("strength"))
	this.set_f32("strength", strength); //Decides health and vulnerability to infection
	if(!this.exists("productivity"))
	this.set_f32("productivity", productivity);
	//Grown is now handled w/ a tag.
	if(!this.exists("water_level"))
	this.set_u8("water_level", max_level);
	
	if(!this.exists("produce"))
	this.set_string("produce", produce);
}
void initSeed(CBlob@ this)//All de variabrus that Seebs hab!
{
		if(!this.exists("growth_speed"))
		{
			this.set_u16("growth_speed", 1400); //Speed of growth! The higher the number, the slower it grows.
		}
		if(!this.exists("strength"))
		{
			this.set_f32("strength", 2); //The strength of the seed. Ofc is float. Decides it's vulnerability to poison, and possibly it's max water level?
		}
		if(!this.exists("productivity"))
		{
			this.set_f32("productivity", 2); //The number of things it'll produce, it's a float so because of mutation.
		}
		if(!this.exists("crop"))
		{
			this.set_string("crop", "tea"); //Blob name of the thing it creates.
		}
}
void initProduceVars(CBlob@ crop, CBlob@ produce)
{
	copyMutation(crop, produce, true);
	produce.set_string("crop", crop.getName());
	produce.Sync("crop", true);
}
void copyMutation(CBlob@ this, CBlob@ newBlob, bool mutate)
{
	u16 growth_speed = this.get_u16("growth_speed");
	f32 strength = this.get_f32("strength");
	f32 productivity = this.get_f32("productivity");
	if(mutate) //Add some randomness for evolution simulation
	{
		growth_speed = Mutate(growth_speed);
		strength = Mutate(strength);
		productivity = Mutate(productivity);
	}
	newBlob.set_u16("growth_speed", growth_speed);
	newBlob.set_f32("strength", strength);
	newBlob.set_f32("productivity", productivity);
	newBlob.Sync("growth_speed", true);
	newBlob.Sync("strength", true);
	newBlob.Sync("productivity", true);
}
float Mutate(float origin)
{
	float extra = origin;
	extra /= float(20 + XORRandom(20)); //5 - 2.5% original.
	extra += 0.15f; //Minimum of 0.15 + very small number.
	if(XORRandom(2) == 0) //50/50 chance of being pos/neg. It's just easier to fiddle with this way :{
	{
		extra = -extra;
	}
	origin += extra; //Add it on.
	if(origin < 0) //Prevent backwards-overflow errors. It's a float atm, but switches when outside 	.
	{
		return 0;
	}
	return origin;
}
CBlob@ server_CreateProduce(string produce, u8 teamNum, Vec2f pos, CBlob@ this)
{
	CBlob@ b = server_CreateBlob(produce, teamNum, pos);
	if(b !is null) //Set variables incase it gets turned into a "cutting". This could lead to some hilarius stuff, like, if produce was a bomb, then you could harvest the bomb plant, and would have to rush to turn it into a seed before it blew you up. xD
	{
		initProduceVars(this, b);
	}
	return b;
}
u8 getStatus(CBlob@ this)
{
	Vec2f pos = this.getPosition();
	CMap@ map = this.getMap();
	if(this.hasTag("virus"))
	{
		return 0;
	}
	else
	{
		Tile tile = map.getTile(pos);
		u8 sunlight = tile.light;
		SColor poscolor = map.getColorLight(pos);
		u8 light = poscolor.getLuminance();
		if(sunlight < 100 && light < 235)
		{
			return 2;
		}
		else if(this.get_u8("water_level") < 2)//Dry
		{
			return 1;
		}
	}
	return 255;
}
/*namespace Type
{
	shared enum type
	{
		crop = 0,
		berry,
		vine
	};
}*/
/*shared class PlantInfo //:C
{
	//Produce
	string produce;
	//Mutation stuff
	//Things that mutations will fiddle with.
	u16 growth_speed;   //Any way to set classes within classes? Or would that be stupid :
	f32 strength;
	f32 productivity;
	//List of blobs that it mutates with?

	
	//Growth stuff
	u16 growth_stage;
	bool grown;
	//seeds produced
	
	//Plant type -- Vine, tree, or plant?
	
	//How quickly it uses water.
	
	//Water level.
	u8 water_level;
	//Seed name.
	PlantInfo()
	{
		growth_stage = 0;
		growth_speed = 500;
		strength = 2;
		productivity = 2;
		grown = false;
		water_level = max_level;
		produce = "";
	}
}*/

/*shared class SeedInfo //Should we, if so, the produce should also have this one.
{
	//What it grows on. Should be based off of... ?
	
	//What is it's name.
	string crop;
	//Evolution traits, 0 = they don't have this one.
	u16 growth_speed;
	f32 strength;
	f32 productivity;
	SeedInfo()
	{
		growth_speed = 0;
		strength = 0;
		productivity = 0;
		crop = "";
	}
}*/