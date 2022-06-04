local _, addonTable = ...;

--- @type MaxDps
if not MaxDps then
	return
end

local MaxDps = MaxDps;
local UnitPower = UnitPower;
local GetSpellCount = GetSpellCount;
local LunarPower = Enum.PowerType.LunarPower;
local GetHaste = GetHaste;
local Druid = addonTable.Druid;

local Necrolord = Enum.CovenantType.Necrolord;
local Venthyr = Enum.CovenantType.Venthyr;
local NightFae = Enum.CovenantType.NightFae;
local Kyrian = Enum.CovenantType.Kyrian;

local BL = {
	MoonkinForm                = 24858,
	Wrath                      = 190984,
	Starfire                   = 194153,
	BalanceOfAllThings         = 339942,
	NaturesBalance             = 202430,
	Starsurge                  = 78674,
	Starlord                   = 202345,
	StellarDrift               = 202354,
	ConvokeTheSpirits          = 323764,
	Incarnation                = 102560,
	PreciseAlignmentConduitId  = 262,
	TimewornDreambinder        = 340049,
	Starfall                   = 191034,
	EmpowerBond                = 338142,
	LycarasFleetingGlimpse     = 340059,
	FuryOfElune                = 202770,
	Sunfire                    = 93402,
	SunfireAura                = 164815,
	AdaptiveSwarm              = 325727,
	AdaptiveSwarmAura          = 325733,
	RavenousFrenzy             = 323546,
	Moonfire                   = 8921,
	MoonfireAura               = 164812,
	TwinMoons                  = 279620,
	SoulOfTheForest            = 114107,
	PrimordialArcanicPulsar    = 338825,
	ForceOfNature              = 205636,
	CelestialAlignment         = 194223,
	KindredSpirits             = 326446,
	StellarFlare               = 202347,
	NewMoon                    = 274281,
	HalfMoon                   = 274282,
	FullMoon                   = 274283,
	WarriorOfElune             = 202425,
	OnethsPerception           = 339800,
	OnethsClearVision          = 339797,
	KindredEmpowermentEnergize = 327022,
	BalanceOfAllThingsArcane   = 339946,
	BalanceOfAllThingsNature   = 339943,

	EclipseLunar               = 48518,
	EclipseSolar               = 48517,
};

setmetatable(BL, Druid.spellMeta);

function Druid:Balance()
	local fd = MaxDps.FrameData;
	local cooldown = fd.cooldown;
	local buff = fd.buff;
	local debuff = fd.debuff;
	local talents = fd.talents;
	local lunarPower = UnitPower('player', LunarPower);

	-- Glow cooldown for Wrath and Starfire if no Eclipse is active
	MaxDps:GlowCooldown(BL.Wrath, not buff[BL.EclipseSolar].up and not buff[BL.EclipseLunar].up);
	MaxDps:GlowCooldown(BL.Starfire, not buff[BL.EclipseSolar].up and not buff[BL.EclipseLunar].up);
	
			
	-- Glow Cooldown Convoke
	MaxDps:GlowCooldown(BL.ConvokeTheSpirits, cooldown[BL.ConvokeTheSpirits].ready);
	
	-- Glow Cooldown Fury of Elune
	MaxDps:GlowCooldown(BL.FuryOfElune, talents[BL.FuryOfElune] and cooldown[BL.FuryOfElune].ready);
		
	-- Refresh Moonfire
	if debuff[BL.MoonfireAura].refreshable then
		return BL.Moonfire;
	end
	
	-- Refresh Sunfire
	if debuff[BL.SunfireAura].refreshable then
		return BL.Sunfire;
	end
	
	
	
	-- Starsurge
		-- If Lunar or Solar eclipse is up and Starsurge is usable and and Lunar/Solar eclipse have more than 10 seconds left then Starsurge
		-- If astral power > 90% then Starsurge
	if lunarPower >= 25 and
	   buff[BL.EclipseSolar].up and buff[BL.EclipseSolar].remains > 10 or
	   buff[BL.EclipseLunar].up and buff[BL.EclipseLunar].remains > 10 or
	   lunarPower >= 90 then
		return BL.Starsurge;
	end
	
	
	-- If solar eclipse is active then Wrath
	if buff[BL.EclipseSolar].up then
		return BL.Wrath;
	end

	-- If Lunar Eclipse is up then Starfire
	if buff[BL.EclipseLunar].up then
		return BL.Starfire;
	end

end