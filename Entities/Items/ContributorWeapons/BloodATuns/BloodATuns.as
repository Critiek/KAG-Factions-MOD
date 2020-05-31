#include "EquipCommon.as";
//Blade Init
void onInit(CBlob@ this)
{
	//Equip tags
	//Tag it the same name as the chars that you want to be able to wear it.
	this.Tag("knight");
	
	this.set_u8("weapontype", WeaponTypes::KnightSpear );
	//Damage
	this.set_f32("rangemult", 1.25f);
	this.set_f32("dmgmult", 1.2f);
	this.set_f32("speedmult", 1.2f);

	//What kind of item is it?
	this.Tag("weapon"); //Options: "weapon" "armor" "misc"
	//I have merged bows & swords, because it's nicer that way, you're never going to get them at the same time, and they'll both be doing the same thing. This way staves & picks are also gonna be much easier to add.
	//Misc = accessories, they have no defence / damage change, but ya can use 'em for custom stuff.
}