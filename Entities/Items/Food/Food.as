void onInit(CBlob@ this)
{
	if (this.exists("food name"))
	{
		this.setInventoryName(this.get_string("food name"));
	}

	u8 index = 6;
	if (this.exists("food sprite"))
	{
		index = this.get_u8("food sprite");
	}
	//index = 6;// NO FUCK WHOEVER PUT THIS

	this.getSprite().SetFrameIndex(index);
	this.SetInventoryIcon(this.getSprite().getConsts().filename, index, Vec2f(16, 16));

	this.Tag("food");
	this.getCurrentScript().runFlags |= Script::remove_after_this;
}
