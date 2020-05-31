shared class Factions
{
	Faction@[] factions;
	
	Factions(){}

	u8 canCreateFaction(string name, string leader)
	{
		s8 team_number = getUnusedTeamNum();

		if(team_number == -1)
			return 1;

		if(nameIsTaken(name))
			return 2;

		return 0;
	}

	void createFaction(string name, string leader)
	{
		clearEmptyFactions();
		s8 team_number = getUnusedTeamNum();

		Faction f(name, leader, team_number);
		factions.push_back(@f);
	}
	void removeFaction(s8 team)
	{
		for(int i = 0; i < factions.length; i++)
		{
			if(factions[i].team == team)
			{	
				//print("wow");
				factions[i].removeAllMembers();
				factions.removeAt(i);
				break;
			}
		}
	}
	bool nameIsTaken(string name)
	{
		for(int i = 0; i < factions.length; i++)
		{
			if(factions[i].name.toLower() == name.toLower())
			{
				return true;
			}
		}
		return false;
	}
	s8 getUnusedTeamNum()
	{
		s8[] used;
		s8[] nums = {0,1,2,3,4,5,6};
		for(int i = 0; i < factions.length; i++)
		{
			used.push_back(factions[i].team);
		}
		used.sortAsc();
		if(used.length > 0) 
		{
			for(int i = 0; i < used.length; i++)
			{
				for(int j = 0; j < nums.length; j++)
				{
					if(used[i] == nums[j])
					{
						nums.removeAt(j);
						j--;
					}
				}
			}
			for(int i = 0; i < nums.length; i++)
			{
				//print(""+nums[i]);
			}
		}
		if(nums.length > 0)
		{
			return nums[XORRandom(nums.length)];
		}
		return -1;
	}
	Faction@ getFactionByMemberName(string _member)
	{
		//print("fl "+factions.length);
		for( int i = 0; i < factions.length; i++)
    	{
	        for(int j = 0; j < factions[i].members.length; j++)
        	{
        		//print("ml "+factions[i].members.length);
	            //print("j = " + factions[i].members[j].toLower() + " :::: " + _member.toLower());
	            if(factions[i].members[j].toLower() == _member.toLower())
	            {
	            	//print("successfully returned faction from name");
                	return factions[i];
	            }
        	}
    	}
    	//print("could not get faction from name");
    	return null;
	}

	Faction@ getFactionByName(string _name)
	{

		for( int i = 0; i < factions.length; i++)
    	{
	        if(factions[i].name == _name)
	        {
	         	//print("successfully returned faction from f name");
              	return factions[i];
	        }
        }
    	//print("could not get faction from f name");
    	return null;
	}
	Faction@ getFactionByTeamNum(s8 team_number)
	{
		for( int i = 0; i < factions.length; i++)
    	{
	        if(factions[i].team == team_number)
	        {
	         	//print("successfully returned faction from f name");
              	return factions[i];
	        }
        }
    	//print("could not get faction from f name");
    	return null;
	}
	void clearEmptyFactions()
	{
		for( int i = 0; i < factions.length; i++)
    	{
	        if(factions[i].members.length == 0)
	        {
	        	factions.removeAt(i);
	        	i = -1;
	        }
    	}
	}
	void removeAllInvitations(string _member)
	{//this is used after you join a faction so that you cant just change your mind at any time.
		for(int i = 0; i < factions.length; i++)
		{
			factions[i].declineInv(_member);
		}
	}
}

shared class Faction
{
	s8 team;
	string name;
	string leader;
	string[] members;
	string[] welcome;
	string[] moderators;

	Faction(string _name, string _leader, s8 _team)
	{
		//print("**" + _team);
		name = _name;
		leader = _leader;
		team = _team;
		addMember(leader);
		//print("successfully created a new faction called " + name + " with leader " + leader);
	}
	bool addMember(string _member)
	{
		members.push_back(_member);
		CPlayer@ p = getPlayerByUsername(_member);
		if(p !is null)
		{
			CBlob@ b = p.getBlob();
			if(b !is null)
			{
				b.server_setTeamNum(team);
				return true;
			}
		}
		return false;
	}
	void removeMember(string _member, bool force)
	{
		for(int i = 0; i < members.length; i++)
		{
			if(members[i] == _member)
			{
				members.removeAt(i);
				if(_member == leader && !force)
				{
					findNewLeader();	
				}
				//print("successfully removed " + _member + " from " + name);
				return;
			}
		}
	}
	void removeAllMembers()
	{
		while(members.length > 0)
		{
			members.removeAt(0);
		}
	}
	void promote(string _user)
	{
		moderators.push_back(_user);
	}
	void demote(string _user)
	{
		s8 index = moderators.find(_user);
		if(index != -1)
			moderators.removeAt(index);
	}
	void changeLeader(string _leader)
	{
		removeMember(leader, true);
		addMember(leader);
		leader = _leader;
		//print("the new leader for " + name + " is " + leader);
	}
	void findNewLeader()
	{
		//print("FIND NEW LEADER()!!!");
		if(members.length > 0)
		{
			leader = members[0];
		}
		else
		{
			CBitStream params;
			params.write_u8(team);
			getRules().SendCommand(getRules().getCommandID("killFaction"), params);
		}
	}
	s8 getTeamNum()
	{
		return team;
	}
	void invite(string _playerName)
	{
		welcome.push_back(_playerName);
	}
	void declineInv(string _playerName)
	{
		for(int i = 0; i < welcome.length; i++)
		{
			if(welcome[i] == _playerName)
			{
				welcome.removeAt(i);
				i--;
			}
		}
	}
	bool isOnTheList(string _member)
	{
		s8 index = welcome.find(_member);
		return index != -1;
	}
}
