#include "RunnerTextures.as";
//--- This class isn't actually used yet, it's just hopefully gonna be a nicer way of storing all the variables and stuff in one place.
shared class WeaponInfo //---it's an object, like CBlob, CSprite, etc. Except it's one I made muhself. C:
{
	//Attacking modifiers:
	f32 dmgmult;
	f32 speedmult;
	f32 rangemult;
	f32 stunmult;
	
	//TODO: Make this bit work nicer, I'm sure there's a better way of doing it than just having 5 booleans >:
	bool can1; //Knight jab, archer weak shot, builder pickaxe.
	bool can2; //Knight slash, archer med shot, builder hammer.
	bool can3; //Knight double slash, archer long shot.
	bool can4; //Archer legolas.
	bool can5; //Knight shield, archer grapple.
	
	WeaponInfo()
	{
		dmgmult = 1.0f;
		speedmult = 1.0f;
		rangemult = 1.0f;
		stunmult = 1.0f;
		
		can1 = true;
		can2 = true;
		can3 = true;
		can4 = true;
		can5 = true;
	}
}

namespace EquipTypes
{
	enum types
	{
		unarmored = 0,
		light,
		medium,
		heavy
	}
}

//TADARARRA

void equipTexture(CSprite@ sprite, CSprite@ equipsprite) //Equipping armor.
{
	//FIRST.
	//Reset sprite based of what the equip sprite wants you to be.
	CBlob@ b = equipsprite.getBlob();
	CBlob@ blob = sprite.getBlob();
	int equiptype = EquipTypes::medium; //Default to med. 
	if(b.exists("equiptype"))
	{
		equiptype = b.get_u8("equiptype");
	}
	
	string texname;
	texname = blob.getName();
	//texname = texname.toUpper();
	texname = texname.substr(0, 1)/*.toUpper()*/ + texname.substr(1, texname.length()); //Capitalize the first letter.
	string armortype;
	switch(equiptype) //we want to set it to blob name, archer, with the first letter capitalized, plus "light", "medium", or "heavy" at the beginning. 
	{
		case(EquipTypes::unarmored):
			armortype = "Unarmored";
		break;
		case(EquipTypes::light):
			armortype = "Light";
		break;
		case(EquipTypes::medium):
			armortype = "Medium";
		break;
		case(EquipTypes::heavy):
			armortype = "Heavy";
		break;
	}
	texname = armortype + texname; //so now it should be Mediumarcher -- Can't do .toUpper(), but fortunately the file finding thing can beat dat :3
	print("ARMORTYPE: " + texname);
	
	addRunnerTextures(sprite, texname.toLower(), texname);
	
	//The name of the palette should be: Name of original filename, + Palette & .png ofc
	string palettename = equipsprite.getFilename();
	palettename = palettename.substr(0, palettename.length()-4); //Getting rid of the .png on the end
	palettename = palettename + "Palette" + ".png"; //Adding it on here xD
	string t = PaletteSwapTexture(getRunnerTextureName(sprite), palettename, 1);
	print("getRunnerTextureName: "+ getRunnerTextureName(sprite));
	
	//Only change if it's not already what we have and if it exists.
	if(sprite.getTextureName() != t && t != "")
	{
		sprite.SetTexture(t);
	}
}

namespace WeaponTypes //For visuals.
{
	enum types
	{
		KnightSword = 0,
		KnightAxe,
		KnightSpear,
		BuilderPickaxe,
		BuilderMallet,
		BuilderShovel,
		Bow,
		CrossBow,
		LongBow
	}
}

void equipLayerTexture(CBlob@ caller, CSpriteLayer@ spritelayer, CSprite@ equipsprite, u8 weapontype)//Probly gotta be dif ;-;
{
	string callername = caller.getName();
	string palette_name;
	string pal_name = "palette_";
	switch(weapontype)
	{
		case( WeaponTypes::KnightSword ):
			palette_name = "KnightSword.png";
			pal_name = pal_name + palette_name;
		break;
		case( WeaponTypes::KnightAxe ):
			palette_name = "KnightAxe.png";
			pal_name = pal_name + palette_name;
		break;
		case( WeaponTypes::KnightSpear ):
			palette_name = "KnightSpear.png";
			pal_name = pal_name + palette_name;
		break;
		case( WeaponTypes::BuilderPickaxe ):
			palette_name = "BuilderPickaxe.png";
			pal_name = pal_name + palette_name;
		break;
		case( WeaponTypes::BuilderMallet ):
			palette_name = "BuilderMallet.png";
			pal_name = pal_name + palette_name;
		break;
		case( WeaponTypes::BuilderShovel ):
			palette_name = "BuilderShovel.png";
			pal_name = pal_name + palette_name;
		break;
		case( WeaponTypes::Bow ):
			palette_name = "ArcherBow.png";
			pal_name = pal_name + palette_name;
		break;
		case( WeaponTypes::CrossBow ):
			palette_name = "ArcherCrossBow.png";
			pal_name = pal_name + palette_name;
		break;
		case( WeaponTypes::LongBow ):
			palette_name = "ArcherLongBow.png";
			pal_name = pal_name + palette_name;
		break;
	}
	//Reset texture: 	
	if(!Texture::exists(pal_name))
	{
		Texture::createFromFile(pal_name, palette_name);
	}
	spritelayer.SetTexture(pal_name);
	//Add new texture:
	//The name of the palette should be: Name of original filename, + Palette & .png ofc
	string palettename = equipsprite.getFilename();
	palettename = palettename.substr(0, palettename.length()-4);
	palettename = palettename + "Palette" + ".png";
	string t = PaletteSwapTexture(spritelayer.getTextureName(), palettename, 1);
	
	//only change if we need it and if it exists
	if(spritelayer.getTextureName() != t && t != "")
	{
		spritelayer.SetTexture(t);
	}
}