local eid = {}

if EID then
	EID:addCollectible(EEVEEMOD.CollectibleType.TAIL_WHIP, "Extends a tail out that spins in a circle, knocking back enemies and projectiles#Enemies hit are given a Weakness effect for 5 seconds, similar to that of {{Card67}} XI - Strength?#Projectiles hit can damage enemies", "Tail Whip", "en_us")
	EID:addBirthright(EEVEEMOD.PlayerType.EEVEE, "Gives the Tail Whip item in the consumable slot#Extends Eevee's tail out that spins in a circle, knocking back enemies and projectiles#Enemies hit are given a Weakness effect for 5 seconds, similar to that of {{Card67}} XI - Strength?#Projectiles hit can damage enemies")
end

return eid