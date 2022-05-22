local _, addonTable = ...;

--- @type MaxDps
if not MaxDps then
	return
end

local MaxDps = MaxDps;
local Rogue = addonTable.Rogue;

local OL = {
	Stealth              = 1784,
	MarkedForDeath       = 137619,
	LoadedDice           = 256170,
	SnakeEyes            = 275863,
	GhostlyStrike        = 196937,
	DeeperStratagem      = 193531,

	SkullAndCrossbones   = 199603,
	TrueBearing          = 193359,
	RuthlessPrecision    = 193357,
	GrandMelee           = 193358,
	BuriedTreasure       = 199600,
	Broadside            = 193356,

	BladeFlurry          = 13877,
	Opportunity          = 195627,
	QuickDraw            = 196938,
	PistolShot           = 185763,
	KeepYourWitsAboutYou = 288988,
	Deadshot             = 272940,
	SinisterStrike       = 193315,
	KillingSpree         = 51690,
	BladeRush            = 271877,
	Vanish               = 1856,
	Ambush               = 8676,
	CheapShot			 = 1833,
	KidneyShot			 = 408,
	AdrenalineRush       = 13750,
	RollTheBones         = 315508,
	SliceAndDice         = 315496,
	BetweenTheEyes       = 315341,
	Dispatch             = 2098,
	DirtyTricks			 = 108216,
	Gouge				 = 1776,
	
	ER1					 = 323557,
	ER2					 = 323558,
	ER3					 = 323559,
	ER4					 = 323560,
	ER5					 = 323561,
	ER6					 = 323562,
	
	Sepsis               = 328305,
	SepsisAura           = 347037,
	Flagellation		 = 323654,
	SerratedBoneSpear	 = 328547,
	SerratedBoneSpearAura= 324073,
	EchoingReprimand 	 = 323547,
	Feint				 = 1966,
	CrimsonVial			 = 185311,

	StealthAura          = 1784,
	VanishAura           = 11327,
	InstantPoison        = 315584
};

local RTB = {
	Broadside			=	193356,
	BuriedTreasure		=	199600,
	GrandMelee			=	193358,
	RuthlessPrecision	=	193357,
	SkullAndCrossbones	=	199603,
	TrueBearing			=	193359
};

local CN = {
	None      = 0,
	Kyrian    = 1,
	Venthyr   = 2,
	NightFae  = 3,
	Necrolord = 4
};

setmetatable(OL, Rogue.spellMeta);

function Rogue:Outlaw()
	local fd = MaxDps.FrameData;
	local cooldown = fd.cooldown;
	local buff = fd.buff;
	local debuff = fd.debuff;
	local comboPoints = UnitPower('player', 4);
	local comboPointsMax = UnitPowerMax('player', 4);
	local energy = UnitPower('player', 3);
	local energyMax = UnitPowerMax('player', 3);
	local inCombat = UnitAffectingCombat("player");
	local stealthed = IsStealthed();
	
	--Health Percent
	local PlayerHealth = (UnitHealth('player')/UnitHealthMax('player'))*100
	
	--RTB Tracker
	local rollTheBonesBuffCount = 0;
	if buff[OL.SkullAndCrossbones].up then rollTheBonesBuffCount = rollTheBonesBuffCount + 1; end
	if buff[OL.TrueBearing].up        then rollTheBonesBuffCount = rollTheBonesBuffCount + 2; end
	if buff[OL.RuthlessPrecision].up  then rollTheBonesBuffCount = rollTheBonesBuffCount + 1; end
	if buff[OL.GrandMelee].up         then rollTheBonesBuffCount = rollTheBonesBuffCount + 1; end
	if buff[OL.BuriedTreasure].up     then rollTheBonesBuffCount = rollTheBonesBuffCount + 1; end
	if buff[OL.Broadside].up          then rollTheBonesBuffCount = rollTheBonesBuffCount + 2; end
	
	local RTB_Reroll = rollTheBonesBuffCount < 2;
	
	local ERMatch = (comboPoints == 1 and buff[OL.ER1].up) or
					(comboPoints == 2 and buff[OL.ER2].up) or
					(comboPoints == 3 and buff[OL.ER3].up) or
					(comboPoints == 4 and buff[OL.ER4].up) or
					(comboPoints == 5 and buff[OL.ER5].up) or
					(comboPoints == 6 and buff[OL.ER6].up); 

	MaxDps:GlowCooldown(OL.EchoingReprimand, cooldown[OL.EchoingReprimand].ready);
	MaxDps:GlowCooldown(OL.Feint, cooldown[OL.Feint].ready and not buff[OL.Feint].up);
	MaxDps:GlowCooldown(OL.CrimsonVial, cooldown[OL.CrimsonVial].ready and PlayerHealth <= 90);
	
	if cooldown[OL.RollTheBones].ready and (rollTheBonesBuffCount == 0 or RTB_Reroll) and not debuff[OL.CheapShot].up and not debuff[OL.KidneyShot].up then
		return OL.RollTheBones;
	end
	
	if cooldown[OL.SliceAndDice].ready and buff[OL.SliceAndDice].remains < 5 and comboPoints >= 3 and not debuff[OL.CheapShot].up and not debuff[OL.KidneyShot].up then
		return OL.SliceAndDice;
	end
	
	if stealthed or buff[OL.VanishAura].up then
		return OL.CheapShot;
	end
		
	if ERMatch or comboPoints >= comboPointsMax - 1 then
		if cooldown[OL.BetweenTheEyes].ready then
			return OL.BetweenTheEyes;
		end
		
		if cooldown[OL.KidneyShot].ready and comboPoints >= comboPointsMax - 1 and not debuff[OL.CheapShot].up then
			return OL.KidneyShot;
		end
		
		if not cooldown[OL.KidneyShot].ready then
			return OL.Dispatch;
		end
	end

	return Rogue:OutlawBuilder();
end

function Rogue:OutlawBuilder()
	local fd = MaxDps.FrameData;
	local cooldown = fd.cooldown;
	local buff = fd.buff;
	local covenantId = fd.covenant.covenantId;
		
	if buff[OL.Opportunity].up then
		return OL.PistolShot;
	end
	
	return OL.SinisterStrike;	
end
