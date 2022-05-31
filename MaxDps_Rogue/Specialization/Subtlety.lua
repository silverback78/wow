local _, addonTable = ...;

--- @type MaxDps
if not MaxDps then return end

local MaxDps = MaxDps;
local UnitPower = UnitPower;
local UnitPowerMax = UnitPowerMax;
local GetPowerRegen = GetPowerRegen;
local InCombatLockdown = InCombatLockdown;
local ComboPoints = Enum.PowerType.ComboPoints;
local Energy = Enum.PowerType.Energy;
local Rogue = addonTable.Rogue;

local SB = {
	Shadowstrike		 = 185438,
	Stealth				 = 1784,
	SliceAndDice		 = 315496,
	Rupture				 = 1943,
	Eviscerate			 = 196819,
	Backstab			 = 53,
	ShadowDance			 = 185313,
	ShadowDanceBuff		 = 185422,
	Gloomblade			 = 200758,
	SymbolsOfDeath		 = 212283,
	ShurikenStorm		 = 197835,
	MarkedForDeath		 = 137619,
	EchoingReprimand 	 = 323547,
	CheapShot			 = 1833,
	
	ER1					 = 323557,
	ER2					 = 323558,
	ER3					 = 323559,
	ER4					 = 323560,
	ER5					 = 323561,
	ER6					 = 323562
};

setmetatable(SB, Rogue.spellMeta);

function Rogue:Subtlety()
	local fd = MaxDps.FrameData;
	local cooldown, buff, debuff, talents, azerite, currentSpell, gcd =
		fd.cooldown, fd.buff, fd.debuff, fd.talents, fd.azerite, fd.currentSpell, fd.gcd;

	local energy = UnitPower('player', 3);
	local energyMax = UnitPowerMax('player', 3);
	local energyDeficit = energyMax - energy;
	local energyRegen = GetPowerRegen();
	local energyTimeToMax = (energyMax - energy) / energyRegen;
	local comboPoints = UnitPower('player', 4);
	local comboMax = UnitPowerMax('player', 4);
	local comboDeficit = comboMax - comboPoints;

	MaxDps:GlowCooldown(SB.CheapShot, cooldown[SB.ShadowDance].ready and cooldown[SB.SymbolsOfDeath].ready);
	
	local useFinisher = (comboPoints == 1 and buff[SB.ER1].up) or
						(comboPoints == 2 and buff[SB.ER2].up) or
						(comboPoints == 3 and buff[SB.ER3].up) or
						(comboPoints == 4 and buff[SB.ER4].up) or
						(comboPoints == 5 and buff[SB.ER5].up) or
						(comboPoints == 6 and buff[SB.ER6].up) or
						comboDeficit <= 1; 
	
	if buff[SB.ShadowDanceBuff].up then
		if useFinisher and cooldown[SB.EchoingReprimand].ready then
			return SB.EchoingReprimand;
		end
		
		if useFinisher then
			return SB.Eviscerate;
		end
		
		return SB.Shadowstrike;	
	else
		if buff[SB.SliceAndDice].refreshable and comboPoints >= 3 then
			return SB.SliceAndDice;
		end
				
		if useFinisher then
			return SB.Eviscerate;
		end
		
		return SB.Backstab;
	end
end