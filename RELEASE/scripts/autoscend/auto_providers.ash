
float providePlusCombat(int amt, location loc, boolean doEquips, boolean speculative) {
	auto_log_info((speculative ? "Checking if we can" : "Trying to") + " provide " + amt + " positive combat rate, " + (doEquips ? "with" : "without") + " equipment", "blue");

	float alreadyHave = numeric_modifier("Combat Rate");
	float need = amt - alreadyHave;

	if (need > 0) {
		auto_log_debug("We currently have " + alreadyHave + ", so we need an extra " + need);
	} else {
		auto_log_debug("We already have enough!");
	}

	float delta = 0;

	float result() {
		return numeric_modifier("Combat Rate") + delta;
	}

	if (doEquips) {
		string max = "200combat " + amt + "max";
		if (speculative) {
			simMaximizeWith(loc, max);
		} else {
			addToMaximize(max);
			simMaximize(loc);
		}
		delta = simValue("Combat Rate") - numeric_modifier("Combat Rate");
		auto_log_debug("With gear we can get to " + result());
	}

	boolean pass() {
		return result() >= amt;
	}

	if(pass()) {
		return result();
	}

	// first lets do stuff that is "free" (as in has no MP cost, item use or can be freely removed/toggled)
	
	if (have_effect($effect[Become Superficially Interested]) > 0) {
		visit_url("charsheet.php?pwd=&action=newyouinterest");
		if(pass()) {
			return result();
		}
	}

	foreach eff in $effects[Driving Stealthily, The Sonata of Sneakiness, In The Darkness] {
		uneffect(eff);
		if(pass()) {
			return result();
		}
	}

	if (get_property("_horsery") == "dark horse") {
		if (!speculative) {
			horseNone();
		}
		delta += (-1.0 * numeric_modifier("Horsery:dark horse", "Combat Rate")); // horsery changes don't happen until pre-adventure so this needs to be manually added otherwise it won't count.
		auto_log_debug("We " + (speculative ? "can remove" : "will remove") + " Dark Horse, we will have " + result());
	} else if (!speculative) {
		horseMaintain();
	}
	if(pass()) {
		return result();
	}

	void handleEffect(effect eff) {
		if (speculative) {
			delta += numeric_modifier(eff, "Combat Rate");
			if (eff == $effect[Musk of the Moose] && have_effect($effect[Smooth Movements]) > 0) {
				delta += (-1.0 * numeric_modifier($effect[Smooth Movements], "Combat Rate")); // numeric_modifer doesn't take into account uneffecting the opposite skill so we have to add it manually.
			}
		}
		auto_log_debug("We " + (speculative ? "can gain" : "just gained") + " " + eff.to_string() + ", now we have " + result());
	}

	boolean tryEffects(boolean [effect] effects) {
		foreach eff in effects {
			if (buffMaintain(eff, 0, 1, 1, speculative)) {
				handleEffect(eff);
			}
			if (pass()) {
				return true;
			}
		}
		return false;
	}
	
	// Do the April band
	auto_setAprilBandCombat();

	// Now handle buffs that cost MP, items or other resources

	shrugAT($effect[Carlweather\'s Cantata Of Confrontation]);
	if (tryEffects($effects[
		Musk of the Moose,
		Carlweather's Cantata of Confrontation,
		Blinking Belly,
		Song of Battle,
		Frown,
		Angry,
		Screaming! \ SCREAMING! \ AAAAAAAH!,
		Coffeesphere,
		Unmuffled
	])) {
		return result();
	}

	if (tryEffects($effects[
		Taunt of Horus,
		Patent Aggression,
		Lion in Ambush,
		Everything Must Go!,
		Hippy Stench,
		High Colognic,
		Celestial Saltiness,
		Simply Irresistible,
		Crunching Leaves,
		Romantically Roused,
		Crunchy Steps
	])) {
		return result();
	}

	if(canAsdonBuff($effect[Driving Obnoxiously])) {
		if (!speculative) {
			asdonBuff($effect[Driving Obnoxiously]);
		}
		handleEffect($effect[Driving Obnoxiously]);
	}

	if(my_meat() > 100 + meatReserve()) {
		tryEffects($effects[Waking the Dead]);
	}

	if(pass()) {
		return result();
	}

	return result();
}

float providePlusCombat(int amt, boolean doEquips, boolean speculative)
{
	return providePlusCombat(amt, my_location(), doEquips, speculative);
}

boolean providePlusCombat(int amt, location loc, boolean doEquips)
{
	return providePlusCombat(amt, loc, doEquips, false) >= amt;
}

boolean providePlusCombat(int amt, boolean doEquips)
{
	return providePlusCombat(amt, my_location(), doEquips);
}

boolean providePlusCombat(int amt, location loc)
{
	return providePlusCombat(amt, loc, true);
}

boolean providePlusCombat(int amt)
{
	return providePlusCombat(amt, my_location());
}

float providePlusNonCombat(int amt, location loc, boolean doEquips, boolean speculative) {
	auto_log_info((speculative ? "Checking if we can" : "Trying to") + " provide " + amt + " negative combat rate, " + (doEquips ? "with" : "without") + " equipment", "blue");

	// numeric_modifier will return -combat as a negative value and +combat as a positive value
	// so we will need to invert the return values otherwise this will be wrong (since amt is supposed to be positive).
 	float alreadyHave = -1.0 * numeric_modifier("Combat Rate");
	float need = amt - alreadyHave;

	if (need > 0) {
		auto_log_debug("We currently have " + alreadyHave + ", so we need an extra " + need);
	} else {
		auto_log_debug("We already have enough!");
	}

	float delta = 0;

	float result() {
		return (-1.0 * numeric_modifier("Combat Rate")) + delta;
	}

	if (doEquips) {
		string max = "-200combat " + amt + "max";
		if (speculative) {
			simMaximizeWith(max);
		} else {
			addToMaximize(max);
			simMaximize();
		}
		delta = (-1.0 * simValue("Combat Rate")) - (-1.0* numeric_modifier("Combat Rate"));
		auto_log_debug("With gear we can get to " + result());
	}

	boolean pass() {
		return result() >= amt;
	}

	if(pass()) {
		return result();
	}


	// first lets do stuff that is "free" (as in has no MP cost, item use or can be freely removed/toggled)

	if (have_effect($effect[Become Intensely Interested]) > 0) {
		visit_url("charsheet.php?pwd=&action=newyouinterest");
		if(pass()) {
			return result();
		}
	}

	foreach eff in $effects[Carlweather\'s Cantata Of Confrontation, Driving Obnoxiously] {
		uneffect(eff);
		if(pass()) {
			return result();
		}
	}

	if (isHorseryAvailable() && my_meat() > horseCost() && get_property("_horsery") != "dark horse") {
		if (!speculative) {
			horseDark();
		}
		delta += (-1.0 * numeric_modifier("Horsery:dark horse", "Combat Rate")); // horsery changes don't happen until pre-adventure so this needs to be manually added otherwise it won't count.
		auto_log_debug("We " + (speculative ? "can gain" : "will gain") + " Dark Horse, we will have " + result());
	} else if (!speculative) {
		horseMaintain();
	}
	if(pass()) {
		return result();
	}


	void handleEffect(effect eff) {
		if (speculative) {
			delta += (-1.0 * numeric_modifier(eff, "Combat Rate"));
			if (eff == $effect[Smooth Movements] && have_effect($effect[Musk of the Moose]) > 0) {
				delta += numeric_modifier($effect[Musk of the Moose], "Combat Rate"); // numeric_modifer doesn't take into account uneffecting the opposite skill so we have to add it manually.
			}
		}
		auto_log_debug("We " + (speculative ? "can gain" : "just gained") + " " + eff.to_string() + ", now we have " + result());
	}

	boolean tryEffects(boolean [effect] effects) {
		foreach eff in effects {
			if (buffMaintain(eff, 0, 1, 1, speculative)) {
				handleEffect(eff);
			}
			if (pass()) {
				return true;
			}
		}
		return false;
	}
	
	// Do the April band
	auto_setAprilBandNonCombat();

	// Now handle buffs that cost MP, items or other resources

	shrugAT($effect[The Sonata of Sneakiness]);
	if (tryEffects($effects[
		Shelter Of Shed,
		Brooding,
		Muffled,
		Smooth Movements,
		The Sonata of Sneakiness,
		Song of Solitude,
		Inked Well,
		Bent Knees,
		Extended Toes,
		Ink Cloud,
		Cloak of Shadows,
		Chocolatesphere,
		Disquiet Riot
	])) {
		return result();
	}

	if ((-1.0 * auto_birdModifier("Combat Rate")) > 0) {
		if (tryEffects($effects[Blessing of the Bird])) {
			return result();
		}
	}

	if ((-1.0 * auto_favoriteBirdModifier("Combat Rate")) > 0) {
		if (tryEffects($effects[Blessing of Your Favorite Bird])) {
			return result();
		}
	}

	if (tryEffects($effects[
		Ashen,
		Predjudicetidigitation,
		Patent Invisibility,
		Ministrations in the Dark,
		Fresh Scent,
		Become Superficially interested,
		Gummed Shoes,
		Simply Invisible,
		Inky Camouflage,	
		Celestial Camouflage,
		Feeling Lonely,
		Feeling Sneaky,
		Ultra-Soft Steps,
		Hippy Antimilitarism
	])) {
		return result();
	}

	if(canAsdonBuff($effect[Driving Stealthily])) {
		if (!speculative) {
			asdonBuff($effect[Driving Stealthily]);
		}
		handleEffect($effect[Driving Stealthily]);
	}
	if(pass()) {
		return result();
	}

	//blooper ink costs 15 coins without which it will error when trying to buy it, so that is the bare minimum we need to check for
	//However we don't want to waste our early coins on it as they are precious. So require at least 400 coins before buying it.
	if(in_plumber() && 0 == have_effect($effect[Blooper Inked]) && item_amount($item[coin]) > 400) {
		if (!speculative) {
			retrieve_item(1, $item[blooper ink]);
		}
		if (tryEffects($effects[Blooper Inked])) {
			return result();
		}
	}

	// Glove charges are a limited per-day resource, lets do this last so we don't waste possible uses of Replace Enemy
	if (auto_hasPowerfulGlove() && tryEffects($effects[Invisible Avatar])) {
		return result();
	}

	return result();
}

float providePlusNonCombat(int amt, boolean doEquips, boolean speculative)
{
	return providePlusNonCombat(amt, my_location(), doEquips, speculative);
}

boolean providePlusNonCombat(int amt, location loc, boolean doEquips)
{
	return providePlusNonCombat(amt, loc, doEquips, false) >= amt;
}

boolean providePlusNonCombat(int amt, boolean doEquips)
{
	return providePlusNonCombat(amt, my_location(), doEquips);
}

boolean providePlusNonCombat(int amt, location loc)
{
	return providePlusNonCombat(amt, loc, true);
}

boolean providePlusNonCombat(int amt)
{
	return providePlusNonCombat(amt, my_location());
}

float provideInitiative(int amt, location loc, boolean doEquips, boolean speculative)
{
	auto_log_info((speculative ? "Checking if we can" : "Trying to") + " provide " + amt + " initiative, " + (doEquips ? "with" : "without") + " equipment", "blue");

	float alreadyHave = numeric_modifier("Initiative");
	float need = amt - alreadyHave;

	if(need > 0)
	{
		auto_log_debug("We currently have " + alreadyHave + ", so we need an extra " + need);
	}
	else
	{
		auto_log_debug("We already have enough!");
	}

	float delta = 0;

	float result()
	{
		return numeric_modifier("Initiative") + delta;
	}

	if(doEquips)
	{
		string max = "500initiative " + amt + "max";
		if(speculative)
		{
			simMaximizeWith(loc, max);
		}
		else
		{
			addToMaximize(max);
			simMaximize(loc);
		}
		delta = simValue("Initiative") - numeric_modifier("Initiative");
		auto_log_debug("With gear we can get to " + result());
	}

	boolean pass()
	{
		return result() >= amt;
	}

	if(pass())
		return result();

	if (!speculative && doEquips)
	{
		handleFamiliar("init");
		if(pass())
			return result();
	}

	void handleEffect(effect eff)
	{
		if(speculative)
		{
			delta += numeric_modifier(eff, "Initiative");
		}
		auto_log_debug("We " + (speculative ? "can gain" : "just gained") + " " + eff.to_string() + ", now we have " + result());
	}

	boolean tryEffects(boolean [effect] effects)
	{
		foreach eff in effects
		{
			if(buffMaintain(eff, 0, 1, 1, speculative))
				handleEffect(eff);
			if(pass())
				return true;
		}
		return false;
	}

	if(tryEffects($effects[
		Cletus's Canticle of Celerity,
		Springy Fusilli,
		Soulerskates,
		Walberg's Dim Bulb,
		Song of Slowness,
		Your Fifteen Minutes,
		Suspicious Gaze,
		Bone Springs,
		Living Fast,
		Nearly Silent Hunting,
		Stretched,
	]))
		return result();

	if(canAsdonBuff($effect[Driving Quickly]))
	{
		if(!speculative)
			asdonBuff($effect[Driving Quickly]);
		handleEffect($effect[Driving Quickly]);
	}
	if(pass())
		return result();

	if(bat_formBats(speculative))
	{
		handleEffect($effect[Bats Form]);
	}
	if(pass())
		return result();

	if(auto_birdModifier("Initiative") > 0)
	{
		if(tryEffects($effects[Blessing of the Bird]))
			return result();
	}

	if(auto_favoriteBirdModifier("Initiative") > 0)
	{
		if(tryEffects($effects[Blessing of Your Favorite Bird]))
			return result();
	}

	if(doEquips && auto_have_familiar($familiar[Grim Brother]) && (have_effect($effect[Soles of Glass]) == 0) && (get_property("_grimBuff").to_boolean() == false))
	{
		if(!speculative)
		{
			// We must visit the familiar's page before we can select the choice.
			auto_log_debug("Attempting to visit Grim brother");
			visit_url("familiar.php?action=chatgrim&pwd", true);
			auto_log_debug("Attempting to select Soles of Glass");
			visit_url("choice.php?pwd&whichchoice=835&option=1", true);
		}
			
		handleEffect($effect[Soles of Glass]);
		if(pass())
			return result();
	}

	if(tryEffects($effects[
		Adorable Lookout,
		Alacri Tea,
		All Fired Up,
		Clear Ears\, Can't Lose,
		Fishy\, Oily,
		The Glistening,
		Human-Machine Hybrid,
		Patent Alacrity,
		Provocative Perkiness,
		Sepia Tan,
		Sugar Rush,
		Ticking Clock,
		Well-Swabbed Ear,
		Poppy Performance
	]))
		return result();

	if(auto_sourceTerminalEnhanceLeft() > 0 && have_effect($effect[init.enh]) == 0 && auto_is_valid($effect[init.enh]))
	{
		if(!speculative)
			auto_sourceTerminalEnhance("init");
		handleEffect($effect[init.enh]);
		if(pass())
			return result();
	}

	if(doEquips && auto_canBeachCombHead("init"))
	{
		if(!speculative)
			auto_beachCombHead("init");
		handleEffect(auto_beachCombHeadEffect("init"));
		if(pass())
			return result();
	}

	if(doEquips && auto_haveCCSC() && have_effect($effect[Peppermint Rush]) == 0 && !get_property("_candyCaneSwordLyle").to_boolean()) {
		if (!speculative) {
			equip($item[candy cane sword cane]);
			string temp = visit_url("place.php?whichplace=monorail&action=monorail_lyle");
		}
		handleEffect($effect[Peppermint Rush]);
		if(pass())
			return result();
	}

	if(doEquips && amt >= 400)
	{
		if(!get_property("_bowleggedSwaggerUsed").to_boolean() && buffMaintain($effect[Bow-Legged Swagger], 0, 1, 1, speculative))
		{
			if(speculative)
				delta += delta + numeric_modifier("Initiative");
			auto_log_debug("With Bow-Legged Swagger we " + (speculative ? "can get to" : "now have") + " " + result());
		}
		if(pass())
			return result();
	}

	return result();
}

float provideInitiative(int amt, boolean doEquips, boolean speculative)
{
	return provideInitiative(amt, my_location(), doEquips, speculative);
}

boolean provideInitiative(int amt, location loc, boolean doEquips)
{
	return provideInitiative(amt, loc, doEquips, false) >= amt;
}

boolean provideInitiative(int amt, boolean doEquips)
{
	return provideInitiative(amt, my_location(), doEquips);
}

int [element] provideResistances(int [element] amt, location loc, boolean doEquips, boolean speculative)
{
	string debugprint = "Trying to provide ";
	foreach ele,goal in amt
	{
		debugprint += goal;
		debugprint += " ";
		debugprint += ele;
		debugprint += " resistance, ";
	}
	debugprint += (doEquips ? "with equipment" : "without equipment");
	auto_log_info(debugprint, "blue");

	if(amt[$element[stench]] > 0)
	{
		uneffect($effect[Flared Nostrils]);
	}
	
	int [element] gearLoss;
	if(!doEquips)
	{	//trying to provide without equipment also means trying to reach goal without value provided by current equipment
		//currently equipment is not being locked and may be changed in pre adv after the provider returns success
		//so may need to take into account removal of what is provided by current equipment to compensate
		//must reduce the result (not raise goal value) since other functions look at the result
		string unequipsString;
		foreach sl in $slots[hat,weapon,off-hand,back,shirt,pants,acc1,acc2,acc3,familiar]
		{
			//simulate removing all gear regardless of individual res modifiers, must account for familiar weight or outfit bonus
			if(equipped_item(sl) != $item[none]) unequipsString += "unequip " + sl + "; ";
		}
		if(unequipsString != "")
		{
			cli_execute("speculate quiet; " + unequipsString);
			foreach ele in amt
			{
				//record the amount that would be lost to modify the result with
				gearLoss[ele] = min(0,simValue(ele + " resistance") - numeric_modifier(ele + " resistance"));
			}
		}
	}

	int [element] delta;

	int result(element ele)
	{
		return numeric_modifier(ele + " Resistance") + delta[ele] + gearLoss[ele];
	}

	int [element] result()
	{
		int [element] res;
		foreach ele in amt
		{
			res[ele] = result(ele);
		}
		return res;
	}

	string resultstring()
	{
		string s = "";
		foreach ele in amt
		{
			if(s != "")
			{
				s += ", ";
			}
			s += result(ele) + " " + ele.to_string() + " resistance";
		}
		return s;
	}

	void handleEffect(effect eff)
	{
		if(speculative)
		{
			foreach ele in amt
			{
				delta[ele] += numeric_modifier(eff, ele + " Resistance");
			}
		}
		auto_log_debug("We " + (speculative ? "can gain" : "just gained") + " " + eff.to_string() + ", now we have " + resultstring());
	}

	boolean pass(element ele)
	{
		return result(ele) >= amt[ele];
	}

	boolean pass()
	{
		foreach ele in amt
		{
			if(!pass(ele))
				return false;
		}
		if (canChangeFamiliar() && $familiars[Trick-or-Treating Tot, Mu, Exotic Parrot] contains my_familiar()) {
			// if we pass while having a resist familiar equipped, make sure we keep it equipped
			// otherwise we may end up flip-flopping from the resist familiar and something else
			// which could cost us adventures if switching familiars affects our resistances enough
			handleFamiliar(my_familiar());
		}
		return true;
	}

	if(doEquips)
	{
		if(speculative)
		{
			string max = "";
			foreach ele,goal in amt
			{
				if(max.length() > 0)
				{
					max += ",";
				}
				max += "2000" + ele + " resistance " + goal + "max";
			}
			simMaximizeWith(loc, max);
		}
		else
		{
			foreach ele,goal in amt
			{
				addToMaximize("2000" + ele + " resistance " + goal + "max");
			}
			simMaximize(loc);
		}
		foreach ele in amt
		{
			delta[ele] = simValue(ele + " Resistance") - numeric_modifier(ele + " Resistance");
		}
		auto_log_debug("With gear we can get to " + resultstring());
	}

	if(pass())
		return result();

	boolean tryEffects(boolean [effect] effects)
	{
		foreach eff in effects
		{
			boolean effectMatters = false;
			foreach ele in amt
			{
				if(!pass(ele) && numeric_modifier(eff, ele + " Resistance") > 0)
				{
					effectMatters = true;
				}
			}
			if(!effectMatters)
			{
				continue;
			}
			if(buffMaintain(eff, 0, 1, 1, speculative))
			{
				handleEffect(eff);
			}
			if(pass())
				return true;
		}
		return false;
	}

	// effects from skills
	if(tryEffects($effects[
		Elemental Saucesphere,
		Astral Shell,
		Hide of Sobek,
		Spectral Awareness,
		Scariersauce,
		Scarysauce,
		Blessing of the Bird,
		Blessing of Your Favorite Bird,
		Feeling Peaceful,
		Shifted Reality,
	]))
		return result();

	if(bat_formMist(speculative))
		handleEffect($effect[Mist Form]);
	if(pass())
		return result();

	if(doEquips && canChangeFamiliar())
	{
		familiar resfam = $familiar[none];
		foreach fam in $familiars[Trick-or-Treating Tot, Mu, Exotic Parrot]
		{
			if(auto_have_familiar(fam))
			{
				resfam = fam;
				break;
			}
		}
		if(resfam != $familiar[none])
		{
			// need to use now so maximizer will see it
			use_familiar(resfam);
			if(resfam == $familiar[Trick-or-Treating Tot])
			{
				cli_execute("acquire 1 li'l candy corn costume");
			}
			// update maximizer scores with familiar
			simMaximize(loc);
			foreach ele in amt
			{
				delta[ele] = simValue(ele + " Resistance") - numeric_modifier(ele + " Resistance");
			}
		}
		if(pass()) {
			return result();
		}
	}

	if(doEquips)
	{
		// effects from items that we'd have to buy or have found
		if(tryEffects($effects[
			Red Door Syndrome,
			Well-Oiled,
			Oiled-Up,
			Egged On,
			Flame-Retardant Trousers,
			Fireproof Lips,
			Insulated Trousers,
			Fever From the Flavor,
			Smelly Pants,
			Neutered Nostrils,
			Can't Smell Nothin\',
			Spookypants,
			Balls of Ectoplasm,
			Hyphemariffic,
			Sleaze-Resistant Trousers,
			Hyperoffended,
			Covered in the Rainbow,
			Temporarily Filtered,
			Gritty,
			Too Shamed,
			Twangy,
			minor invulnerability,
			Incredibly Healthy
		]))
			return result();
	}

	return result();
}

int [element] provideResistances(int [element] amt, boolean doEquips, boolean speculative)
{
	return provideResistances(amt, my_location(), doEquips, speculative);
}

boolean provideResistances(int [element] amt, location loc, boolean doEquips)
{
	int [element] res = provideResistances(amt, doEquips, false);
	foreach ele, i in amt
	{
		if(res[ele] < i)
			return false;
	}
	return true;
}

boolean provideResistances(int [element] amt, boolean doEquips)
{
	return provideResistances(amt, my_location(), doEquips);
}

float [stat] provideStats(int [stat] amt, location loc, boolean doEquips, boolean speculative)
{
	string debugprint = "Trying to provide ";
	foreach st,goal in amt
	{
		debugprint += goal;
		debugprint += " ";
		debugprint += st;
		debugprint += ", ";
	}
	debugprint += (doEquips ? "with equipment" : "without equipment");
	auto_log_info(debugprint, "blue");

	float [stat] delta;

	float result(stat st)
	{
		return my_buffedstat(st) + delta[st];
	}

	float [stat] result()
	{
		float [stat] res;
		foreach st in amt
		{
			res[st] = result(st);
		}
		return res;
	}

	string resultstring()
	{
		string s = "";
		foreach st in amt
		{
			if(s != "")
			{
				s += ", ";
			}
			s += result(st) + " " + st.to_string();
		}
		return s;
	}

	void handleEffect(effect eff)
	{
		if(speculative)
		{
			foreach st in amt
			{
				delta[st] += numeric_modifier(eff, st);
				delta[st] += numeric_modifier(eff, st + " Percent") * my_basestat(st) / 100.0;
			}
		}
		auto_log_debug("We " + (speculative ? "can gain" : "just gained") + " " + eff.to_string() + ", now we have " + resultstring());
	}

	boolean pass(stat st)
	{
		return result(st) >= amt[st];
	}

	boolean pass()
	{
		foreach st in amt
		{
			if(!pass(st))
				return false;
		}
		return true;
	}

	if(doEquips)
	{
		if(speculative)
		{
			string max = "";
			foreach st,goal in amt
			{
				if(max.length() > 0)
				{
					max += ",";
				}
				max += "200" + st + " " + goal + "max";
			}
			simMaximizeWith(loc, max);
		}
		else
		{
			foreach st,goal in amt
			{
				addToMaximize("200" + st + " " + goal + "max");
			}
			simMaximize(loc);
		}
		foreach st in amt
		{
			delta[st] = simValue("Buffed " + st) - my_buffedstat(st);
		}
		auto_log_debug("With gear we can get to " + resultstring());
	}

	if(pass())
		return result();

	boolean tryEffects(boolean [effect] effects)
	{
		foreach eff in effects
		{
			boolean effectMatters = false;
			foreach st in amt
			{
				if(!pass(st) && (numeric_modifier(eff, st) > 0 || numeric_modifier(eff, st + " Percent") > 0))
				{
					effectMatters = true;
				}
			}
			if(!effectMatters)
			{
				continue;
			}
			if(buffMaintain(eff, 0, 1, 1, speculative))
			{
				handleEffect(eff);
			}
			if(pass())
				return true;
		}
		return false;
	}

	if(tryEffects($effects[
		// muscle effects
		Juiced and Loose,					//+50% mus. nuclear autumn only. 3 MP/adv
		Quiet Determination,				//+25% mus. facial expression. 1 MP/adv
		Rage of the Reindeer,				//+10% mus. +10 weapon dmg. 1 MP/adv
		Power Ballad of the Arrowsmith,		//+10 mus. +20 maxHP. song. 5 MP (duration varies).
		Seal Clubbing Frenzy,				//+2 mus. 0.2 MP/adv
		Patience of the Tortoise,			//+1 mus. +3 maxHP. 0.2 MP/adv
		
		// myst effects
		Mind Vision,						//+50% mys. nuclear autumn only. 3 MP/adv
		Quiet Judgement,					//+25% mys. facial expression. 1 MP/adv
		The Magical Mojomuscular Melody,	//+10 mys. +20 maxMP. song. 3 MP (duration varies).
		Pasta Oneness,						//+2 mys. 0.2 MP/adv
		Saucemastery,						//+1 mys. +3 maxMP. 0.2 MP/adv

		// moxie effects
		Impeccable Coiffure,				//+50% mox. nuclear autumn only. 3 MP/adv
		Song of Bravado,					//+15% all. NOT a song. 10 MP/adv
		The Moxious Madrigal,				//+10 mox. song. 2 MP (duration varies).
		Disco State of Mind,				//+2 mox. 0.2 MP/adv
		Mariachi Mood,						//+1 mox. +3 maxHP. 0.2 MP/adv

		// all-stat effects
		Cheerled,							//+50% all. Class=Pig Skinner
		Big,								//+20% all. 1.5 MP/adv
		Song of Bravado,					//+15% all. NOT a song. 10 MP/adv
		Stevedave's Shanty of Superiority,	//+10% all. song. 30 MP (duration varies).

		// varying effects
		Blessing of the Bird,
		Blessing of Your Favorite Bird,
		Feeling Excited,
	]))
		return result();

	if(auto_have_skill($skill[Quiet Desperation]))		//+25% mox. facial expression. 1 MP/adv
		tryEffects($effects[Quiet Desperation]);
	else
		tryEffects($effects[Disco Smirk]);				//+10 mox. facial expression. 1 MP/adv

	if(pass())
		return result();

	// buffs from items
	if(doEquips)
	{
		if(tryEffects($effects[
			// muscle effects
			Browbeaten,
			Extra Backbone,
			Extreme Muscle Relaxation,
			Faboooo,
			Feroci Tea,
			Fishy Fortification,
			Football Eyes,
			Go Get \'Em\, Tiger!,
			Lycanthropy\, Eh?,
			Marinated,
			Phorcefullness,
			Rainy Soul Miasma,
			Savage Beast Inside,
			Steroid Boost,
			Spiky Hair,
			Sugar Rush,
			Superheroic,
			Temporary Lycanthropy,
			Truly Gritty,
			Vital,
			Woad Warrior,

			// myst effects
			Baconstoned,
			Erudite,
			Far Out,
			Glittering Eyelashes,
			Liquidy Smoky,
			Marinated,
			Mystically Oiled,
			OMG WTF,
			Paging Betty,
			Rainy Soul Miasma,
			Ready to Snap,
			Rosewater Mark,
			Seeing Colors,
			Sweet\, Nuts,

			// moxie effects
			Almost Cool,
			Bandersnatched,
			Busy Bein' Delicious,
			Butt-Rock Hair,
			Funky Coal Patina,
			Liquidy Smoky,
			Locks Like the Raven,
			Lycanthropy\, Eh?,
			Memories of Puppy Love,
			Newt Gets In Your Eyes,
			Notably Lovely,
			Oiled Skin,
			Radiating Black Body&trade;,
			Spiky Hair,
			Sugar Rush,
			Superhuman Sarcasm,
			Unrunnable Face,
			Gaffe Free,
			Poppy Performance,

			// all-stat effects
			Confidence of the Votive,
			Pyrite Pride,
			Human-Human Hybrid,
			Industrial Strength Starch,
			Mutated,
			Seriously Mutated,
			Pill Power,
			Slightly Larger Than Usual,
			Standard Issue Bravery,
			Tomato Power,
			Vital,
			Triple-Sized,
		]))
			return result();

		foreach st in amt
		{
			if(!pass(st) && auto_canBeachCombHead(st.to_string()))
			{
				if(!speculative)
					auto_beachCombHead(st.to_string());
				handleEffect(auto_beachCombHeadEffect(st.to_string()));
			}
		}
		if(pass())
			return result();
	}

	return result();
}

float [stat] provideStats(int [stat] amt, boolean doEquips, boolean speculative)
{
	return provideStats(amt, my_location(), doEquips, speculative);
}

boolean provideStats(int [stat] amt, location loc, boolean doEquips)
{
	float [stat] res = provideStats(amt, doEquips, false);
	foreach st, i in amt
	{
		if(res[st] < i)
		{
			return false;
		}
	}
	return true;
}

boolean provideStats(int [stat] amt, boolean doEquips)
{
	return provideStats(amt, my_location(), doEquips);
}

float provideMuscle(int amt, location loc, boolean doEquips, boolean speculative)
{
	int [stat] statsNeeded;
	statsNeeded[$stat[muscle]] = amt;
	float [stat] res = provideStats(statsNeeded, loc, doEquips, speculative);
	return res[$stat[muscle]];
}

float provideMuscle(int amt, boolean doEquips, boolean speculative)
{
	return provideMuscle(amt, my_location(), doEquips, speculative);
}

boolean provideMuscle(int amt, location loc, boolean doEquips)
{
	return provideMuscle(amt, loc, doEquips, false) >= amt;
}

boolean provideMuscle(int amt, boolean doEquips)
{
	return provideMuscle(amt, my_location(), doEquips);
}

float provideMysticality(int amt, location loc, boolean doEquips, boolean speculative)
{
	int [stat] statsNeeded;
	statsNeeded[$stat[mysticality]] = amt;
	float [stat] res = provideStats(statsNeeded, loc, doEquips, speculative);
	return res[$stat[mysticality]];
}

float provideMysticality(int amt, boolean doEquips, boolean speculative)
{
	return provideMysticality(amt, my_location(), doEquips, speculative);
}

boolean provideMysticality(int amt, location loc, boolean doEquips)
{
	return provideMysticality(amt, loc, doEquips, false) >= amt;
}

boolean provideMysticality(int amt, boolean doEquips)
{
	return provideMysticality(amt, my_location(), doEquips);
}

float provideMoxie(int amt, location loc, boolean doEquips, boolean speculative)
{
	int [stat] statsNeeded;
	statsNeeded[$stat[moxie]] = amt;
	float [stat] res = provideStats(statsNeeded, loc, doEquips, speculative);
	return res[$stat[moxie]];
}

float provideMoxie(int amt, boolean doEquips, boolean speculative)
{
	return provideMoxie(amt, my_location(), doEquips, speculative);
}

boolean provideMoxie(int amt, location loc, boolean doEquips)
{
	return provideMoxie(amt, loc, doEquips, false) >= amt;
}

boolean provideMoxie(int amt, boolean doEquips)
{
	return provideMoxie(amt, my_location(), doEquips);
}

