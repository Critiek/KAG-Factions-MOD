//Misc Init
//provides imunity to fire.
void onInit(CBlob@ this)
{
	//Equip tags
	//Tag it the same name as the chars that you want to be able to wear it.
	this.Tag("knight");
	this.Tag("archer");
	this.Tag("builder");
	//Damage
	
	//What kind of item is it?
	this.Tag("misc"); //Options: "weapon" "armor" "misc"
	//I have merged bows & swords, because it's nicer that way, you're never going to get them at the same time, and they'll both be doing the same thing. This way staves & picks are also gonna be much easier to add.
	//Misc = accessories, they have no defence / damage change, but ya can use 'em for custom stuff.
}