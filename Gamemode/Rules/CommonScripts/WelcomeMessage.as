//only run on the client, no synced or shared state at all
#define CLIENT_ONLY
//script-local variables
//wont be cleared between games
bool show_message = true;
u32 wait_time = 60;//ticks

void onTick(CRules@ this)
{
	if (!show_message) return;

	if (wait_time > 0)//waiting so the message gets added after the other notifications
		wait_time--;
	else
	{
		CPlayer@ localPlayer = getLocalPlayer();
		if (localPlayer is null) return;

		SColor color = SColor(255, 240, 5, 5);

		client_AddToChat("Welcome to KAG factions!, " + localPlayer.getCharacterName() + "!", color);
		client_AddToChat("Type !help to get some help", color);
		client_AddToChat("Make sure to join our discord! https://discord.gg/VnzFfzT", color);
		client_AddToChat("Have fun!", color);
		show_message = false;
	}
}
