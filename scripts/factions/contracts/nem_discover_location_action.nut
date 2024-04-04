this.nem_discover_location_action <- this.inherit("scripts/factions/faction_action", {
	m = {
		Home = null
	},
	function create()
	{
		this.m.ID = "nem_discover_location_action";
		this.m.Cooldown = this.World.getTime().SecondsPerDay * 12;
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
		if (this.World.State.getRegions().len() == 0)
		{
			return;
		}

		if (!this.Const.DLC.Unhold)
		{
			return;
		}

		if (!_faction.isReadyForContract())
		{
			return;
		}
		
		if (_faction.getType() != this.Const.FactionType.Barbarians)
		{
			return;
		}

		if (this.World.getTime().Days <= 3 && this.Math.rand(1, 100) < 20 || this.Math.rand(1, 100) > 10)
		{
			return;
		}

		local locations = clone this.World.FactionManager.getFactionOfType(this.Const.FactionType.Undead).getSettlements();
		locations.extend(this.World.FactionManager.getFactionOfType(this.Const.FactionType.Zombies).getSettlements());
		locations.extend(this.World.FactionManager.getFactionOfType(this.Const.FactionType.Barbarians).getSettlements());
		locations.extend(this.World.FactionManager.getFactionOfType(this.Const.FactionType.Bandits).getSettlements());
		local myTile = _faction.getSettlements()[0].getTile();
		local lowestDistance = 9000;

		foreach( b in locations )
		{
			if (b.isDiscovered() || b.isLocationType(this.Const.World.LocationType.Unique))
			{
				continue;
			}

			if (!this.World.State.getRegion(b.getTile().Region).Center.IsDiscovered)
			{
				continue;
			}

			local region = this.World.State.getRegion(b.getTile().Region);

			if (!region.Center.IsDiscovered)
			{
				continue;
			}

			if (region.Discovered < 0.25)
			{
				this.World.State.updateRegionDiscovery(region);
			}

			if (region.Discovered < 0.25)
			{
				continue;
			}

			local d = myTile.getDistanceTo(b.getTile());

			if (d < lowestDistance)
			{
				lowestDistance = d;
			}
		}

		if (lowestDistance >= 20)
		{
			return;
		}

		this.m.Score = 1;
	}

	function onClear()
	{
	}

	function onExecute( _faction )
	{
		local contract = this.new("scripts/contracts/contracts/discover_location_contract");
		contract.setFaction(_faction.getID());
		contract.setEmployerID(this.m.Home.getChieftain().getID());
		contract.setHome(this.m.Home);
		contract.setOrigin(this.m.Home);
		contract.setup();
		this.World.Contracts.addContract(contract);
	}

});

