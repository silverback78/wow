local _, addonTable = ...;

--- @type MaxDps
if not MaxDps then return end
local MaxDps = MaxDps;
local Hunter = addonTable.Hunter;
local IsSpellInRange = IsSpellInRange;
local GetSpellInfo = GetSpellInfo;

local SV = {
	SteelTrap          = 162488,
	Harpoon            = 190925,
	WildfireInfusion   = 271014,
	AlphaPredator      = 269737,
	MongooseBite       = 259387,
	MongooseFury       = 259388,
	CoordinatedAssault = 266779,
	AspectOfTheEagle   = 186289,
	AMurderOfCrows     = 131894,
	Carve              = 187708,
	WildfireBomb       = 259495,
	GuerrillaTactics   = 264332,
	Chakrams           = 259391,
	KillCommand        = 259489,
	Butchery           = 212436,
	FlankingStrike     = 269751,
	SerpentSting       = 259491,
	VipersVenom        = 268501,
	TermsOfEngagement  = 265895,
	TipOfTheSpear      = 260285,
	RaptorStrike       = 186270,
	BirdsOfPrey        = 260331,
	LatentPoison       = 273283,
	FlayedShot         = 324149,
	FlayersMark        = 324156,
	KillShot           = 320976,

	PheromoneBomb      = 270323,
	ShrapnelBomb       = 270335,
	VolatileBomb       = 271045,

	InternalBleeding   = 270343,
};

local A = {
	UpCloseAndPersonal = 278533,
	LatentPoison       = 273283,
	VenomousFangs      = 274590,
	WildernessSurvival = 278532,
	BlurOfTalons       = 277653,
};

setmetatable(SV, Hunter.spellMeta);

function Hunter:SurvivalBombId()
	if MaxDps:FindSpell(SV.PheromoneBomb) then
		return SV.PheromoneBomb;
	elseif MaxDps:FindSpell(SV.VolatileBomb) then
		return SV.VolatileBomb;
	elseif MaxDps:FindSpell(SV.ShrapnelBomb) then
		return SV.ShrapnelBomb
	else
		return SV.WildfireBomb;
	end
end

function Hunter:Survival()
	local fd = MaxDps.FrameData;
	local cooldown = fd.cooldown;
	local targetHp = MaxDps:TargetPercentHealth();
	local BombSpell = Hunter:SurvivalBombId();
	local buff = fd.buff;
	local debuff = fd.debuff;
	
	MaxDps:GlowCooldown(SV.CoordinatedAssault, cooldown[SV.CoordinatedAssault].ready);

	if cooldown[SV.KillShot].ready and targetHp < 0.2 then
		return SV.KillShot;
	end
		
	if cooldown[SV.KillShot].ready and buff[SV.FlayersMark].up then
		return SV.KillShot;
	end
	
	if cooldown[SV.WildfireBomb].charges == 2 then
		return BombSpell;
	end
	
	if cooldown[SV.FlayedShot].ready then
		return SV.FlayedShot;
	end
			
	if debuff[SV.SerpentSting].refreshable then
		return SV.SerpentSting;
	end
	
	if cooldown[SV.WildfireBomb].ready then
		return BombSpell;
	end
	
	if cooldown[SV.KillCommand].ready then
		return SV.KillCommand;
	end
end
