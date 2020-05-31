#include "EquipCommon.as";
//Armor Init
void onInit(CBlob@ this)
{
	//Equip tags
	//Tag it the same name as the chars that you want to be able to wear it.
	this.Tag("builder");

	//Visual weapon type
	this.set_u8("weapontype", WeaponTypes::BuilderPickaxe );
	
	//Damage
	this.set_f32("dmgmult", 2.0f);
	this.set_f32("rangemult", 1.5f);
	//What kind of item is it?
	this.Tag("weapon"); //Options: "weapon" "armor" "misc"
	//I have merged bows & swords, because it's nicer that way, you're never going to get them at the same time, and they'll both be doing the same thing. This way staves & picks are also gonna be much easier to add.
	//Misc = accessories, they have no defence / damage change, but ya can use 'em for custom stuff.
}