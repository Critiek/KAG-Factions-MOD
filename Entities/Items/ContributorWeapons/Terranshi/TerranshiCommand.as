void healTiles(CBlob@ this, Vec2f pos)
{
	CMap@ map = this.getMap();
	CInventory@ inv = this.getInventory();
	if(inv is null) return;
	for(int x = pos.x - 16; x < pos.x + 16; x += map.tilesize)
	{
		for(int y = pos.y - 16; y < pos.y + 16; y += map.tilesize)
		{
			Vec2f newPos = Vec2f(x, y);
			Tile tile = map.getTile(newPos);
			uint16 type = tile.type;
			if(map.isTileGround(type))
			{
				map.server_SetTile(newPos, CMap::tile_ground);
				//Check for nothing above
				if(map.getTile(newPos + Vec2f(0, -map.tilesize)).type == 0)
				{
					map.server_SetTile(newPos + Vec2f(0, -map.tilesize), CMap::tile_grass);
				}
			}
			else if(map.isTileGrass(type))
			{
				map.server_SetTile(newPos, CMap::tile_grass+XORRandom(3));
			}//Costly stuff
			else if(map.isTileCastle(type))
			{
				if(inv.isInInventory("mat_stone", 5))
				{
					map.server_SetTile(newPos, CMap::tile_castle);
					inv.server_RemoveItems("mat_stone", 5);
				}
			}
			else if(map.isTileStone(type))
			{
				if(inv.isInInventory("mat_stone", 12))
				{
					map.server_SetTile(newPos, CMap::tile_thickstone);
					inv.server_RemoveItems("mat_stone", 12);
				}
			}
			else if(map.isTileThickStone(type))
			{
				if(inv.isInInventory("mat_stone", 24))
				{
					map.server_SetTile(newPos, CMap::tile_thickstone);
					inv.server_RemoveItems("mat_stone", 24);
				}
			}
			else if(map.isTileWood(type))
			{
				if(inv.isInInventory("mat_wood", 4))
				{
					map.server_SetTile(newPos, CMap::tile_wood);
					inv.server_RemoveItems("mat_wood", 4);
				}
			}
		}
	}
}