void onInit(CBlob@ this)
{
	dictionary harvest;
	harvest.set("mat_gold", 8);
	this.set("harvest", harvest);//Logs leik dis
	this.Tag("builder always hit");
	this.getSprite().SetFrame(XORRandom(4));
}