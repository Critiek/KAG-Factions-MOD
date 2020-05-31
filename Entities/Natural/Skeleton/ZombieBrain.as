//brain

#define SERVER_ONLY

#include "PressOldKeys.as";
#include "AnimalConsts.as";

//const string delay_property = "delay1";
const string delay2_property = "delay2";
const string delay3_property = "delay3";

void onInit( CBrain@ this )
{
	CBlob @blob = this.getBlob();
	blob.set_u8( delay_property , 5+XORRandom(5));
	blob.set_u8( delay2_property , 5+XORRandom(5));
	blob.set_u8( delay3_property , 5+XORRandom(5));
	blob.set_u8(state_property, MODE_IDLE);

	if (!blob.exists(terr_rad_property)) 
	{
		blob.set_f32(terr_rad_property, 32.0f);
	}

	if (!blob.exists(target_searchrad_property))
	{
		blob.set_f32(target_searchrad_property, 400.0f);
	}

	if (!blob.exists(personality_property))
	{
		blob.set_u8(personality_property,0);
	}

	if (!blob.exists(target_lose_random))
	{
		blob.set_u8(target_lose_random,14);
	}

	if (!blob.exists("random move freq"))
	{
		blob.set_u8("random move freq",2);
	}	

	this.getCurrentScript().removeIfTag	= "dead";   
	this.getCurrentScript().runFlags |= Script::tick_blob_in_proximity;
	this.getCurrentScript().runFlags |= Script::tick_not_attached;
	this.getCurrentScript().runProximityTag = "flesh";
	this.getCurrentScript().runProximityRadius = 200.0f;
	//this.getCurrentScript().tickFrequency = 5;


}


void onTick( CBrain@ this )
{
	CBlob @blob = this.getBlob();

	u8 delay = blob.get_u8(delay_property);
	delay--;
	u8 delay2 = blob.get_u8(delay2_property);
	u8 delay3 = blob.get_u8(delay3_property);
	

	if (delay == 0)
	{
		delay = 4+XORRandom(8);

		Vec2f pos = blob.getPosition();
		bool facing_left = blob.isFacingLeft();

		{
			u8 mode = blob.get_u8(state_property);
			u8 personality = blob.get_u8(personality_property);
		
			//printf("mode " + mode);

			//"blind" attacking
			if (mode == MODE_TARGET)
			{
				CBlob@ target = getBlobByNetworkID(blob.get_netid(target_property));

				if (target is null || XORRandom( blob.get_u8(target_lose_random) ) == 0 || target.isInInventory() )
				{
					mode = MODE_IDLE;
				}
				else
				{
					Vec2f tpos = target.getPosition();

					f32 search_radius = blob.get_f32(target_searchrad_property);

					if ((tpos - pos).getLength() >= (search_radius))
					{
						mode = MODE_IDLE;
					}
					
					blob.setKeyPressed( (tpos.x < pos.x) ? key_left : key_right, true);

					if (personality & DONT_GO_DOWN_BIT == 0 || (blob.isOnGround() && tpos.y <= pos.y+3*blob.getRadius()))
					{
						blob.setKeyPressed( (tpos.y < pos.y) ? key_up : key_down, true);
					}
				}
			}

			else //mode == idle
			{
				delay2--;
				if (personality != 0 && delay2 == 0) //we have a special personality
				{
					delay2 = 15+XORRandom(8);
					
					f32 search_radius = blob.get_f32(target_searchrad_property);
					string name = blob.getName();

					CBlob@[] blobs;
					blob.getMap().getBlobsInRadius( pos, search_radius, @blobs );

					for (uint step = 0; step < blobs.length; ++step)
					{
						//TODO: sort on proximity? done by engine?
						CBlob@ other = blobs[step];
						
						if (other is blob) continue; //lets not run away from / try to eat ourselves...
						


						if (personality & AGGRO_BIT != 0 && other.getTeamNum() != blob.getTeamNum() && other.hasTag("getthis")) //aggressive
						{
							
								mode = MODE_TARGET;
								print(other.getName());
								blob.set_netid(target_property,other.getNetworkID());
								break;
							
						}
					}
				}
				if (blob.getTickSinceCreated() > 30) // delay so we dont get false terriroty pos
				{
					delay3--;
					if (delay3 == 0) {
						delay3 = 15+XORRandom(8);
						blob.setKeyPressed( key_up, true );
					}
					
					
					//if (blob.isOnWall()) {
					//	if (blob.getTeamNum() == 0) {
					//		blob.AddForce( Vec2f(-150.0f,-150.0f) );
					//	}
					//	if (blob.getTeamNum() == 1) {
					//		blob.AddForce( Vec2f(150.0f,-150.0f) );
					//	}
					//	blob.setKeyPressed( key_up, true );
					//}
					
					if (blob.isOnWall()) {
						if (blob.getTeamNum() == 0) {
							blob.setKeyPressed( key_left, true );
						}
						if (blob.getTeamNum() == 1) {
							blob.setKeyPressed( key_right, true );
						}
						blob.setKeyPressed( key_up, true );
					}
					
						if (blob.getTeamNum() == 0 && mode != MODE_TARGET)
						{	
							blob.setKeyPressed( key_right, true );
						}
						if (blob.getTeamNum() == 1 && mode != MODE_TARGET)
						{
							blob.setKeyPressed( key_left, true );
						}


				}

			}

			blob.set_u8(state_property, mode);
		}
	}
	else
	{
		PressOldKeys( blob );
	}

	blob.set_u8(delay_property, delay);
	blob.set_u8(delay2_property, delay2);
	blob.set_u8(delay3_property, delay3);
}
