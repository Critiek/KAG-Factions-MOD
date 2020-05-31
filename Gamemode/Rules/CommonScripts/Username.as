#include "TeamColour.as";
 
void onRender(CSprite@ this)
{
        CBlob@ blob = this.getBlob();
        Vec2f center = blob.getPosition();
        Vec2f mouseWorld = getControls().getMouseWorldPos();
        const f32 renderRadius = (blob.getRadius()) * 3.0f;
        bool mouseOnBlob = (mouseWorld - center).getLength() < renderRadius;
        if (mouseOnBlob)
        {
                //VV right here VV
                Vec2f pos2d = blob.getScreenPos() + Vec2f(0, 30);
                Vec2f dim = Vec2f(24, 8);
                const f32 y = blob.getHeight() * 2.4f;
                const f32 x = blob.getWidth() * 2.4f;
                CPlayer@ player = blob.getPlayer();
                if(player !is null)
                {
                        GUI::SetFont("menu");
                        GUI::DrawTextCentered(player.getUsername(), pos2d, getTeamColor(player.getTeamNum()));
                }
        }
}