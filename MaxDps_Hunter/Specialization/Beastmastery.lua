local _, addonTable = ...;

--- @type MaxDps
if not MaxDps then return end
local MaxDps = MaxDps;
local Hunter = addonTable.Hunter;

local BM = {
	TarTrap         = 187698,
	SoulforgeEmbers = 336745,
	BestialWrath    = 19574,
	ScentOfBlood    = 193532,
	CounterShot     = 147362,
	AspectOfTheWild = 193530,
	BarbedShot      = 217200,
	MultiShot       = 2643,
	Flare           = 1543,
	DeathChakram    = 325028,
	WildSpirits     = 328231,
	ResonatingArrow = 308491,
	Stampede        = 201430,
	FlayedShot      = 324149,
	KillShot        = 53351,
	ChimaeraShot    = 53209,
	Bloodshed       = 321530,
	AMurderOfCrows  = 131894,
	Barrage         = 120360,
	KillCommand     = 34026,
	DireBeast       = 120679,
	CobraShot       = 193455,
	FreezingTrap    = 187650,
	FlayersMark     = 324156,

	-- Pet Auras
	BeastCleave     = 268877,
	Frenzy          = 272790,
	KillingFrenzy   = 363760,

	-- Target Auras
	BarbedShotAura  = 217200,
};

setmetatable(BM, Hunter.spellMeta);

local auraMetaTable = {
	__index = function()
		return {
			up          = false,
			count       = 0,
			remains     = 0,
			duration    = 0,
			refreshable = true,
		};
	end
};

function Hunter:BeastMastery()
	local fd = MaxDps.FrameData;
	local cooldown = fd.cooldown;
	local buff = fd.buff;
	local gcd = fd.gcd;
	local pet = fd.pet;
	local targetHp = MaxDps:TargetPercentHealth();
	
	if not fd.pet then
		fd.pet = {};
		setmetatable(fd.pet, auraMetaTable);
	end
	MaxDps:CollectAura('pet', fd.timeShift, fd.pet);
	
	MaxDps:GlowCooldown(BM.MultiShot, buff[BM.KillingFrenzy].up and buff[BM.BeastCleave].remains < gcd * 2);
	
	if cooldown[BM.KillShot].ready and targetHp < 0.2 then
		return BM.KillShot;
	end
	
	-- Use Barbed Shot if you're at max charges
	if cooldown[BM.BarbedShot].ready and cooldown[BM.BarbedShot].charges >= 2 then
		return BM.BarbedShot;
	end

	-- Use all BarbedShot charges before using Bestial Wrath
	if cooldown[BM.BarbedShot].ready and cooldown[BM.BestialWrath].remains <= 20 then
		return BM.BarbedShot;
	end

	-- Use Barbed Shot to refresh if there are less than 2 GCDs left until it falls off
	if cooldown[BM.BarbedShot].ready and pet[BM.Frenzy].up and pet[BM.Frenzy].remains <= gcd * 2 then
		return BM.BarbedShot;
	end
	
	-- Use Barbed Shot if you have fewer than 3 stacks of Frenzy
	if cooldown[BM.BarbedShot].ready and pet[BM.Frenzy].count < 3 then
		return BM.BarbedShot;
	end
	
	if cooldown[BM.KillShot].ready and buff[BM.FlayersMark].up then
		return BM.KillShot;
	end
			
	if cooldown[BM.FlayedShot].ready then
		return BM.FlayedShot;
	end
	
	if cooldown[BM.BestialWrath].ready then
		return BM.BestialWrath;
	end
	
	if cooldown[BM.KillCommand].ready then
		return BM.KillCommand;
	end
end
