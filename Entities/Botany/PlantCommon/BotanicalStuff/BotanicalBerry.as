#include "PlantCommon.as";
void onInit(CBlob@ this)
{
	CInventory@ inv = this.getInventory();
	this.Tag("berry"); //Hrumph.
	this.getCurrentScript().tickFrequency = (this.get_u16("growth_speed") * 5) / this.get_f32("productivity");
}
void onTick(CBlob@ this)
{
	CInventory@ inv = this.getInventory();
	string produce = this.get_string("produce");
	if(inv !is null && this.hasTag("grown") && produce != "" && getNet().isServer() && !inv.isFull() && getStatus(this) == 255)
	{
		CBlob@ crop = server_CreateProduce(produce, -1, this.getPosition(), this);
		if(crop !is null)
		{
			this.server_PutInInventory(crop);
		}
	}
}
bool isInventoryAccessible(CBlob@ this, CBlob@ forBlob)
{
	if(forBlob.getCarriedBlob() !is null) //If am holding shet
	{
		return false;
	}
	return true;
}