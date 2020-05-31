#include "EquipCommon.as";
//Armor Init
void onInit(CBlob@ this)
{
	//Equip tags
	//Tag it the same name as the chars that you want to be able to wear it.
	this.Tag("archer");

	//Visual weapon type
	this.set_u8("weapontype", WeaponTypes::LongBow );
	
	//Damage
	this.set_f32("dmgmult", 1.0f);
	this.set_f32("rangemult", 1.7f);
	this.set_f32("speedmult", 10.0f);
	//What kind of item is it?
	this.Tag("weapon"); //Options: "weapon" "armor" "misc"
	//I have merged bows & swords, because it's nicer that way, you're never going to get them at the same time, and they'll both be doing the same thing. This way staves & picks are also gonna be much easier to add.
	//Misc = accessories, they have no defence / damage change, but ya can use 'em for custom stuff.


	//Preventing num:
	this.set_u16("cancelnum", 385); //5 * 7 * 11 //This one should prevent all but legolas & long shot & grapple
	
	
	//Now this is a little more fancy; it's a method of preventing certain attacks.	it's a little odd,
	//But it's the first functional way that I thought that would only require 1 number. I think it's sounder than it sounds.
	//Every attack is given a prime number, but not 1. Whenever you use an attack, it divides whatever number this weapon has by it's own number.
	//Then if that number is whole, the attack goes through.
	//So if I wanted to be able to jab and double slash, ez pz way would be to do (jab number(2)) * (doubleslash number(5))
	//2 * 5 = 10. Slash's attack is 3. 10 / 2 = whole. 10 / 3 = not whole. 10 / 5 = whole.
	
	//Numbers
	
	//Knight:
	//Jab: 2
	//Slash: 3
	//Double Slash: 5
	//Shield: 7 - shield etc. will probably be moved to the shield item if we ever add one in.
	
	//Archer:
	//Weak shot: 2
	//Med shot: 3
	//Long shot: 5
	//Legolas shot: 7
	//Grapple: 11
	
	//Builder:
	//Pickaxe: 2
	//Hammer: 3
}