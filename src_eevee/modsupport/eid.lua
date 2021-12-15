local eid = {}

if EID then
	EID:addCollectible(EEVEEMOD.CollectibleType.TAIL_WHIP, "Extends a tail out that spins in a circle, knocking back enemies and projectiles#Enemies hit are given a Weakness effect for 5 seconds, similar to that of {{Card67}} XI - Strength?#Projectiles hit can damage enemies", "Tail Whip", "en_us")
	EID:addBirthright(EEVEEMOD.PlayerType.EEVEE, "Gives the Tail Whip item in the consumable slot#Extends Eevee's tail out that spins in a circle, knocking back enemies and projectiles#Enemies hit are given a Weakness effect for 5 seconds, similar to that of {{Card67}} XI - Strength?#Projectiles hit can damage enemies")
	--Provided by Kotry!
	EID:addCollectible(EEVEEMOD.CollectibleType.TAIL_WHIP, "Extiende una cola de modo que es un ataque giratorio, empujando enemigos y disparos#Los enemigos golpeados reciben efecto de debilidad por 5 segundos, de forma similar a como lo hace {{Card67}} XI - ¿Fuerza?#Los proyectiles desviados pueden dañar enemigos", "Látigo", "spa")
	EID:addBirthright(EEVEEMOD.PlayerType.EEVEE, "Ganas el objeto Látigo en los objetos de bolsillo#Extiende una cola de modo que es un ataque giratorio, empujando enemigos y disparos#Los enemigos golpeados reciben efecto de debilidad por 5 segundos, de forma similar a como lo hace {{Card67}} XI - ¿Fuerza?#Los proyectiles desviados pueden dañar enemigos", "Eevee", "spa")
end

return eid
