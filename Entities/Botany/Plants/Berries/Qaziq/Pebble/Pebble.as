void onInit(CBlob@ this)
{
	dictionary harvest;
	harvest.set("mat_stone", 8);
	this.set("harvest", harvest);//Logs leik dis
	this.Tag("builder always hit");
	this.getSprite().SetFrame(XORRandom(4));
}