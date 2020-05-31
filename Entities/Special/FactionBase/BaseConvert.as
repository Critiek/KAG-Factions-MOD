/*
 * convertible if enemy outnumbers friends in radius
 */

const string counter_prop = "capture ticks";
const string raid_tag = "under raid";
const int capture_seconds = 15;
const int capture_radius = 80;

const string friendly_prop = "capture friendly count";
const string enemy_prop = "capture enemy count";

void onInit(CBlob@ this)
{
	this.addCommandID("convert");
	this.getCurrentScript().tickFrequency = 30;
	this.set_s16(counter_prop, capture_seconds);
	this.set_s16(friendly_prop, 0);
	this.set_s16(enemy_prop, 0);
}

//add
void onAttach(CBlob@ this, CBlob@ attached, AttachmentPoint @attachedPoint)
{/*
	if (!this.hasTag("convert on sit"))
		return;

	if (attachedPoint.socket &&
	        attached.getTeamNum() != this.getTeamNum() &&
	        attached.hasTag("player"))
	{
		this.server_setTeamNum(attached.getTeamNum());
	}
*/}

void onTick(CBlob@ this)
{
	if (!getNet().isServer()) return;

	bool reset_timer = true;
	bool sync = false;

	Vec2f pos = this.getPosition();
	CBlob@[] blobsInRadius;
	if (this.getMap().getBlobsInBox(pos - Vec2f(16, 8), pos + Vec2f(16, 8), @blobsInRadius))
	{
		// count friendlies and enemies
		int attackersCount = 0;
		int friendlyCount = 0;

		int attackerTeam = 255;
		Vec2f pos = this.getPosition();
		for (uint i = 0; i < blobsInRadius.length; i++)
		{
			CBlob @b = blobsInRadius[i];
			if (b !is this && b.hasTag("player") && !b.hasTag("dead"))
			{
				if (b.getTeamNum() != this.getTeamNum())
				{
					/*Vec2f bpos = b.getPosition();
					if (bpos.x > pos.x - this.getWidth() / 1.0f && bpos.x < pos.x + this.getWidth() / 1.0f &&
					        bpos.y < pos.y + this.getHeight() / 1.0f && bpos.y > pos.y - this.getHeight() / 1.0f)
					{*/
						attackersCount++;
						attackerTeam = b.getTeamNum();
					//}
				}
				else
				{
					friendlyCount++;
				}
			}
		}

		int ticks = capture_seconds;
		if (this.hasTag(raid_tag))
		{
			ticks = this.get_s16(counter_prop);
		}

		if (attackersCount > 0 || ticks < capture_seconds)
		{
			//convert
			if (attackersCount > friendlyCount)
			{
				ticks--;
			}
			//un-convert gradually
			else if (attackersCount < friendlyCount || attackersCount == 0)
			{
				ticks = Maths::Min(ticks + 1, capture_seconds);
			}

			this.set_s16(counter_prop, ticks);
			this.Tag(raid_tag);

			if (ticks <= 0)
			{
				this.server_setTeamNum(attackerTeam);
				reset_timer = true;
			}
			else
			{
				this.set_s16(friendly_prop, friendlyCount);
				this.set_s16(enemy_prop, attackersCount);
				reset_timer = false;
			}

			sync = true;
		}
	}
	else
	{
		this.Untag(raid_tag);
	}

	if (reset_timer)
	{
		this.set_s16(friendly_prop, 0);
		this.set_s16(enemy_prop, 0);

		this.set_s16(counter_prop, capture_seconds);
		this.Untag(raid_tag);
		sync = true;
	}

	if (sync)
	{
		this.Sync(friendly_prop, true);
		this.Sync(enemy_prop, true);

		this.Sync(counter_prop, true);
		this.Sync(raid_tag, true);
	}

}

void onChangeTeam(CBlob@ this, const int oldTeam)
{
	if (this.getTeamNum() >= 0 && this.getTeamNum() < 10)
	{
		CSprite@ sprite = this.getSprite();
		if (sprite !is null)
		{
			sprite.PlaySound("/VehicleCapture");
		}

		ConvertPoint(this, "VEHICLE");
		ConvertPoint(this, "DOOR");
	}
}

void ConvertPoint(CBlob@ this, const string pointName)
{
	/*AttachmentPoint@ point = this.getAttachments().getAttachmentPointByName(pointName);
	if (point !is null)
	{
		CBlob@ blob = point.getOccupied();
		if (blob !is null)
		{
			blob.server_setTeamNum(this.getTeamNum());
		}
	}*/
}


// alert and capture progress bar

void onRender(CSprite@ this)
{
	if (g_videorecording)
		return;

	CBlob@ blob = this.getBlob();
	if (blob is null || !blob.hasTag(raid_tag))
		return;

	Vec2f pos2d = getDriver().getScreenPosFromWorldPos(blob.getPosition() + Vec2f(0.0f, -blob.getHeight()));

	s16 friendlyCount = blob.get_s16(friendly_prop);
	s16 enemyCount = blob.get_s16(enemy_prop);

	// draw background pane
	f32 hwidth = 45 + Maths::Max(0, Maths::Max(friendlyCount, enemyCount) - 3) * 8;
	f32 hheight = 30;

	// sit it above the rest of everything
	pos2d.y -= hheight;

	GUI::DrawPane(pos2d - Vec2f(hwidth, hheight), pos2d + Vec2f(hwidth, hheight));

	//draw balance of power
	for (int i = 1; i <= friendlyCount; i++)
		GUI::DrawIcon("VehicleConvertIcon.png", 0, Vec2f(8, 16), pos2d + Vec2f(i * 8 - 8, -24), 1.0f, blob.getTeamNum());
	for (int i = 1; i <= enemyCount; i++)
		GUI::DrawIcon("VehicleConvertIcon.png", 1, Vec2f(8, 16), pos2d + Vec2f(i * -8 - 8, -24), 1.0f);

	//draw capture bar
	f32 padding = 4.0f;
	s32 captureTime = blob.get_s16(counter_prop);
	GUI::DrawProgressBar(Vec2f(pos2d.x - hwidth + padding, pos2d.y + hheight - 18 - padding),
	                     Vec2f(pos2d.x + hwidth - padding, pos2d.y + hheight - padding),
	                     1.0f - float(captureTime) / float(capture_seconds));

}
