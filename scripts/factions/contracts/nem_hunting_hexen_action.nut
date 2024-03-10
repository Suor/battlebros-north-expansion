this.nem_hunting_hexen_action <- this.inherit("scripts/factions/faction_action", {
	m = {
		Home = null
	},
	function create()
	{
		this.m.ID = "nem_hunting_hexen_action";
		this.m.Cooldown = this.World.getTime().SecondsPerDay * 14;
		this.m.IsStartingOnCooldown = false;
		this.m.IsSettlementsRequired = true;
		this.faction_action.create();
	}
	
	function setHome( _home)
	{
		this.m.Home = _home;
	}

	function onUpdate( _faction )
	{
		if (!this.Const.DLC.Unhold)
		{
			return;
		}
		
		if (_faction.getType() != this.Const.FactionType.Barbarians)
		{
			return;
		}

		if (!_faction.isReadyForContract())
		{
			return;
		}

		if (this.World.Assets.getBusinessReputation() < 900)
		{
			return;
		}
		this.logInfo("check: " + this.m.ID);
		
		this.m.Score = 1;
	}

	function onClear()
	{
	}

	function onExecute( _faction )
	{
		local contract = this.new("scripts/contracts/contracts/nem_hunting_hexen_contract");
		contract.setFaction(_faction.getID());
		contract.setHome(this.m.Home);
		contract.setEmployerID(this.m.Home.getChieftain());
		this.World.Contracts.addContract(contract);
	}

});

