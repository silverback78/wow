local _, addonTable = ...;

--- @type MaxDps
if not MaxDps then return end

local MaxDps = MaxDps;
local UnitPower = UnitPower;
local UnitPowerMax = UnitPowerMax;
local ComboPoints = Enum.PowerType.ComboPoints;
local Energy = Enum.PowerType.Energy;
local Rogue = addonTable.Rogue;


-- Assassination
local AS = {
	Vanish			 = 1856,
	MarkedForDeath   = 137619,
	Vendetta         = 79140,
	Subterfuge       = 108208,
	Garrote          = 703,
	Rupture          = 1943,
	Nightstalker     = 14062,
	Exsanguinate     = 200806,
	DeeperStratagem  = 193531,
	
	MasterAssassin   = 255989,
	ToxicBlade       = 245388,
	PoisonedKnife    = 185565,
	FanOfKnives      = 51723,
	HiddenBlades     = 270061,
	Blindside        = 111240,
	BlindsideAura    = 121153,
	VenomRush        = 152152,
	CrimsonTempest   = 121411,
	Mutilate         = 1329,
	Envenom          = 32645,
	Shiv			 = 5938,
	Ambush           = 8676,
	
	CheapShot		 = 1833,
	KidneyShot		 = 408,
	Feint			 = 1966,
	CrimsonVial		 = 185311,

	SharpenedBlades  = 272916,
	InternalBleeding = 154904,
	SliceAndDice	 = 315496,
	
	--Covenant
	Sepsis               = 328305,
	SepsisAura           = 347037,
	Flagellation		 = 323654,
	SerratedBoneSpear	 = 328547,
	SerratedBoneSpearAura = 324073,
	EchoingReprimand 	 = 323547,

	-- Auras
	Stealth         	 = 1784,
	VanishAura           = 11327,
	InstantPoison        = 315584,
	DeadlyPoison     	 = 2823,
	DeadlyPoisonAura 	 = 2818,
	ShivAura			 = 319504,
	SubterfugeAura		 = 115192,
	HiddenBladesAura	 = 270070,
	MasterAssassinAura   = 256735,
	
	--Lego
	MarkOfTheMasterAssassin	= 7111,
};

local CN = {
	None      = 0,
	Kyrian    = 1,
	Venthyr   = 2,
	NightFae  = 3,
	Necrolord = 4
};

setmetatable(AS, Rogue.spellMeta);

local auraMetaTable = {
	__index = function()
		return {
			up          = false,
			count       = 0,
			remains     = 0,
			refreshable = true,
		};
	end
};

function Rogue:Assassination()
	local fd = MaxDps.FrameData;
	local cooldown, buff, debuff = fd.cooldown, fd.buff, fd.debuff;
	
	local combo = UnitPower('player', ComboPoints);
	local useBuilder = combo  < UnitPowerMax('player', ComboPoints) - 1;
	local stealthed = buff[AS.SubterfugeAura].up or buff[AS.Stealth].up or buff[AS.VanishAura].up;
	
	MaxDps:GlowCooldown(AS.MarkedForDeath, cooldown[AS.MarkedForDeath].ready);
	
	if combo >= 2 and not buff[AS.SliceAndDice].up then
		return AS.SliceAndDice;
	end	
		
	if useBuilder then
		if cooldown[AS.Garrote].ready and debuff[AS.Garrote].refreshable then
			return AS.Garrote;
		end		
	else
		if cooldown[AS.KidneyShot].ready and cooldown[AS.Shiv].remains <= 2 then
			return AS.KidneyShot;
		end
		
		if debuff[AS.Rupture].refreshable then
			return AS.Rupture;
		end
		
		return AS.Envenom;
	end
end