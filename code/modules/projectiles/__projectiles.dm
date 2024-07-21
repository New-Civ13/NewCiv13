//ancient stuff
/obj/item/projectile/bullet/rifle/stoneball
	damage = DAMAGE_VERY_HIGH + 26
	penetrating = 4
	armor_penetration = ARMOR_CLASS*2

// XVIII Century stuff
/obj/item/projectile/bullet/rifle/musketball
	damage = DAMAGE_VERY_HIGH + 47
	penetrating = 5
	armor_penetration = ARMOR_CLASS*2

/obj/item/projectile/bullet/rifle/musketball_pistol
	damage = DAMAGE_HIGH + 12
	penetrating = 2
	armor_penetration = ARMOR_CLASS

/obj/item/projectile/bullet/rifle/blunderbuss
	damage = DAMAGE_VERY_HIGH + 35
	penetrating = 2
	armor_penetration = ARMOR_CLASS*3

/obj/item/projectile/arrow
	embed = TRUE
	sharp = TRUE
	var/volume = 5
	flags = FALSE

/obj/item/projectile/arrow/flint
	damage = DAMAGE_MEDIUM-10
	penetrating = 1
	armor_penetration = ARMOR_CLASS*1
	icon_state = "arrow_flint"
	embed = FALSE
	sharp = FALSE

/obj/item/projectile/arrow/stone
	damage = DAMAGE_MEDIUM-10
	penetrating = 1
	armor_penetration = ARMOR_CLASS*1
	icon_state = "stone"
	embed = FALSE
	sharp = FALSE

/obj/item/projectile/arrow/arrow
	damage = DAMAGE_LOW-28
	penetrating = 0
	armor_penetration = FALSE
	icon_state = "arrow"
	embed = FALSE
	sharp = FALSE

/obj/item/projectile/arrow/arrow/fire
	damage = DAMAGE_LOW
	penetrating = 0
	armor_penetration = ARMOR_CLASS*1
	icon_state = "arrow"
	damage_type = BURN
	embed = FALSE
	sharp = FALSE

/obj/item/projectile/arrow/arrow/fire/gods
	damage = DAMAGE_OH_GOD
	penetrating = 100
	armor_penetration = ARMOR_CLASS*50
	icon_state = "arrow_god"
	damage_type = BURN
	gibs = TRUE
	crushes = TRUE

/obj/item/projectile/arrow/arrow/flint
	damage = DAMAGE_MEDIUM
	penetrating = 0
	armor_penetration = ARMOR_CLASS
	icon_state = "arrow_flint"

/obj/item/projectile/arrow/arrow/stone
	damage = DAMAGE_MEDIUM
	penetrating = 0
	armor_penetration = ARMOR_CLASS
	icon_state = "arrow_stone"

/obj/item/projectile/arrow/arrow/sandstone
	damage = DAMAGE_MEDIUM
	penetrating = 0
	armor_penetration = ARMOR_CLASS
	icon_state = "arrow_sandstone"

/obj/item/projectile/arrow/arrow/copper
	damage = DAMAGE_MEDIUM+1
	penetrating = 0
	armor_penetration = ARMOR_CLASS
	icon_state = "arrow_copper"

/obj/item/projectile/arrow/arrow/iron
	damage = DAMAGE_MEDIUM+2
	penetrating = 1
	armor_penetration = ARMOR_CLASS
	icon_state = "arrow_iron"

/obj/item/projectile/arrow/arrow/bronze
	damage = DAMAGE_MEDIUM+3
	penetrating = 1
	armor_penetration = ARMOR_CLASS*2
	icon_state = "arrow_bronze"

/obj/item/projectile/arrow/arrow/steel
	damage = DAMAGE_MEDIUM+4
	penetrating = 1
	armor_penetration = ARMOR_CLASS*2
	icon_state = "arrow_steel"

/obj/item/projectile/arrow/arrow/modern
	damage = DAMAGE_MEDIUM+5
	penetrating = 1
	armor_penetration = ARMOR_CLASS*2
	icon_state = "arrow_modern"

/obj/item/projectile/arrow/arrow/vial
	damage = DAMAGE_MEDIUM
	penetrating = 1
	armor_penetration = ARMOR_CLASS
	icon_state = "arrow_vial"
	volume = 15

/obj/item/projectile/arrow/arrow/vial/New()
	..()
	create_reagents(volume)

/obj/item/projectile/arrow/arrow/vial/poisonous
	New()
		..()
		reagents.add_reagent("batrachotoxin",15)

/obj/item/projectile/arrow/bolt/vial/poisonous
	New()
		..()
		reagents.add_reagent("batrachotoxin",15)

/obj/item/projectile/arrow/arrow/fire/on_impact(var/atom/A)
	if (A && ishuman(A))
		var/mob/living/M = A
		if (prob(10))
			M.fire_stacks += 1
		M.IgniteMob()
	spawn (0.01)
		qdel(src)
	..()

//BOLTS
/obj/item/projectile/arrow/bolt
	damage = DAMAGE_LOW-20+5
	penetrating = 1
	armor_penetration = ARMOR_CLASS*1
	icon_state = "bolt_iron"

/obj/item/projectile/arrow/bolt/flint
	damage = DAMAGE_MEDIUM+5
	penetrating = 0
	armor_penetration = ARMOR_CLASS*1
	icon_state = "bolt_flint"

/obj/item/projectile/arrow/bolt/stone
	damage = DAMAGE_MEDIUM+5
	penetrating = 0
	armor_penetration = ARMOR_CLASS*1
	icon_state = "bolt_stone"

/obj/item/projectile/arrow/bolt/sandstone
	damage = DAMAGE_MEDIUM+5
	penetrating = 0
	armor_penetration = ARMOR_CLASS*1
	icon_state = "bolt_sandstone"

/obj/item/projectile/arrow/bolt/copper
	damage = DAMAGE_MEDIUM+1+5
	penetrating = 0
	armor_penetration = ARMOR_CLASS*1
	icon_state = "bolt_copper"

/obj/item/projectile/arrow/bolt/iron
	damage = DAMAGE_MEDIUM+5+5
	penetrating = 1
	armor_penetration = ARMOR_CLASS*2
	icon_state = "bolt_iron"

/obj/item/projectile/arrow/bolt/bronze
	damage = DAMAGE_MEDIUM+8+5
	penetrating = 1
	armor_penetration = ARMOR_CLASS*2
	icon_state = "bolt_bronze"

/obj/item/projectile/arrow/bolt/steel
	damage = DAMAGE_MEDIUM+11+5
	penetrating = 1
	armor_penetration = ARMOR_CLASS*2
	icon_state = "bolt_steel"

/obj/item/projectile/arrow/bolt/modern
	damage = DAMAGE_MEDIUM+11+5
	penetrating = 1
	armor_penetration = ARMOR_CLASS*2
	icon_state = "bolt_modern"

/obj/item/projectile/arrow/bolt/fire
	damage = DAMAGE_LOW+5
	penetrating = 0
	armor_penetration = ARMOR_CLASS*1
	icon_state = "bolt"
	damage_type = BURN
	embed = FALSE
	sharp = FALSE

/obj/item/projectile/arrow/bolt/fire/gods
	damage = DAMAGE_OH_GOD
	penetrating = 100
	armor_penetration = ARMOR_CLASS*20
	icon_state = "bolt_god"
	damage_type = BURN
	gibs = TRUE
	crushes = TRUE

/obj/item/projectile/arrow/bolt/fire/on_impact(var/atom/A)
	if (A && isliving(A))
		var/mob/living/M = A
		if (prob(10))
			M.fire_stacks += 1
		if (M)
			M.IgniteMob()
	spawn (0.01)
		qdel(src)
	..()

/obj/item/projectile/arrow/bolt/vial
	damage = DAMAGE_MEDIUM
	penetrating = 1
	armor_penetration = ARMOR_CLASS*1
	icon_state = "bolt_vial"
	volume = 15

/obj/item/projectile/arrow/on_impact(var/atom/A)
	if (istype(src, /obj/item/projectile/arrow/bolt/vial) || istype(src, /obj/item/projectile/arrow/arrow/vial))
		if (reagents)
			if (ishuman(A))
				var/mob/living/human/H = A
				reagents.trans_to_mob(H, volume, CHEM_BLOOD)
			else
				reagents.trans_to(A, volume)
	..()

/obj/item/projectile/grenade/smoke
	name = "smoke grenade"

	kill_count = 10

	var/datum/effect/effect/system/smoke_spread/bad/smoke

	New()
		..()
		smoke = PoolOrNew(/datum/effect/effect/system/smoke_spread/bad)
		smoke.attach(src)

	on_hit(atom/hit_atom)
		name += " (Used)"
		playsound(loc, 'sound/effects/smoke.ogg', 50, TRUE, -3)
		smoke.set_up(5, FALSE, usr.loc)
		spawn(0)
			smoke.start()
			sleep(10)
			smoke.start()
			sleep(10)
			smoke.start()
			sleep(10)
			smoke.start()

	on_impact(atom/hit_atom)
		on_hit(hit_atom)

/obj/item/projectile/bullet/rifle/a65x50
	damage = DAMAGE_VERY_HIGH + 11
	penetrating = 5
	armor_penetration = ARMOR_CLASS*4
/obj/item/projectile/bullet/rifle/a65x50/weak/New()
	..()
	damage = (damage)/2
	penetrating = 3
	armor_penetration = ARMOR_CLASS*0.5

/obj/item/projectile/bullet/rifle/a65x52
	damage = DAMAGE_VERY_HIGH
	penetrating = 5
	armor_penetration = ARMOR_CLASS*4

/obj/item/projectile/bullet/rifle/a8x53
	damage = DAMAGE_VERY_HIGH + 13
	penetrating = 6
	armor_penetration = 37

/obj/item/projectile/bullet/rifle/a8x50
	damage = DAMAGE_VERY_HIGH + 20
	penetrating = 6
	armor_penetration = ARMOR_CLASS*4

/obj/item/projectile/bullet/rifle/a8x50/weak/New()
	..()
	damage = (damage)/2
	penetrating = 1
	armor_penetration = 19

/obj/item/projectile/bullet/rifle/a762x54
	damage = DAMAGE_VERY_HIGH + 40
	penetrating = 6
	armor_penetration = ARMOR_CLASS*4
	tracer_type = /obj/effect/projectile/tracer

/obj/item/projectile/bullet/rifle/a762x54/weak/New()
	..()
	damage = (damage)/2
	penetrating = 1
	armor_penetration = ARMOR_CLASS*3
	tracer_type = /obj/effect/projectile/tracer/red

/obj/item/projectile/bullet/pistol/a762x38
	damage = DAMAGE_LOW + 6
	penetrating = 2
	armor_penetration = ARMOR_CLASS*3

/obj/item/projectile/bullet/pistol/a8x27
	damage = DAMAGE_LOW - 6
	penetrating = 1
	armor_penetration = ARMOR_CLASS*2

/obj/item/projectile/bullet/pistol/a32
	damage = DAMAGE_LOW - 3
	penetrating = 1
	armor_penetration = ARMOR_CLASS*2

/obj/item/projectile/bullet/pistol/a32acp
	damage = DAMAGE_LOW - 8
	penetrating = 2
	armor_penetration = ARMOR_CLASS*2

/obj/item/projectile/bullet/pistol/webly445
	damage = DAMAGE_MEDIUM_HIGH + 7
	penetrating = 1
	armor_penetration = ARMOR_CLASS*2

/obj/item/projectile/bullet/pistol/a38
	damage = DAMAGE_MEDIUM+4
	penetrating = 1
	armor_penetration = ARMOR_CLASS*2

/obj/item/projectile/bullet/pistol/a380acp
    damage = DAMAGE_LOW - 9
    penetrating = 2
    armor_penetration = ARMOR_CLASS*2

/obj/item/projectile/bullet/pistol/a41
	damage = DAMAGE_LOW - 11
	penetrating = 1
	armor_penetration = 3

/obj/item/projectile/bullet/pistol/a43
	damage = DAMAGE_VERY_HIGH - 4
	penetrating = 1
	armor_penetration = ARMOR_CLASS*2

/obj/item/projectile/bullet/pistol/a45
	damage = DAMAGE_VERY_HIGH - 3
	penetrating = 1
	armor_penetration = ARMOR_CLASS*2

/obj/item/projectile/bullet/pistol/a455
	damage = DAMAGE_MEDIUM_HIGH + 7
	penetrating = 1
	armor_penetration = ARMOR_CLASS*2

/obj/item/projectile/bullet/rifle/a44
	damage = DAMAGE_HIGH + 4
	penetrating = 2
	armor_penetration = ARMOR_CLASS*2

/obj/item/projectile/bullet/rifle/a44magnum
	damage = DAMAGE_HIGH+50
	penetrating = 2
	armor_penetration = ARMOR_CLASS*2

/obj/item/projectile/bullet/rifle/a4570
	damage = DAMAGE_VERY_HIGH + 58
	penetrating = 3
	armor_penetration = ARMOR_CLASS*2

/obj/item/projectile/bullet/rifle/a792x57
	damage = DAMAGE_VERY_HIGH + 46
	penetrating = 5
	armor_penetration = ARMOR_CLASS*5
	tracer_type = /obj/effect/projectile/tracer

/obj/item/projectile/bullet/rifle/a792x57/weak/New()
	..()
	damage = (damage)/2
	penetrating = 3
	armor_penetration = ARMOR_CLASS*3
	tracer_type = /obj/effect/projectile/tracer/green

/obj/item/projectile/bullet/rifle/a765x53
	damage = DAMAGE_VERY_HIGH + 20
	penetrating = 5
	armor_penetration = ARMOR_CLASS*4

/obj/item/projectile/bullet/rifle/a765x25
	damage = DAMAGE_LOW + 2
	penetrating = 2
	armor_penetration = ARMOR_CLASS*2

/obj/item/projectile/bullet/rifle/a7x57
	damage = DAMAGE_VERY_HIGH + 17
	penetrating = 5
	armor_penetration = ARMOR_CLASS*4

/obj/item/projectile/bullet/rifle/a77x58
	damage = DAMAGE_VERY_HIGH + 20
	penetrating = 5
	armor_penetration = ARMOR_CLASS*4

/obj/item/projectile/bullet/rifle/a77x58_wood
	damage = 2
	penetrating = 0
	armor_penetration = FALSE

/obj/item/projectile/bullet/rifle/a77x58/weak/New()
	..()
	damage = (damage)/2
	penetrating = 4
	armor_penetration = ARMOR_CLASS*4

/obj/item/projectile/bullet/rifle/a577
	damage = DAMAGE_VERY_HIGH + 88
	penetrating = 3
	armor_penetration = ARMOR_CLASS*4

/obj/item/projectile/bullet/rifle/a303
	damage = DAMAGE_VERY_HIGH + 19
	penetrating = 4
	armor_penetration = ARMOR_CLASS*4

/obj/item/projectile/bullet/rifle/a303/weak/New()
	..()
	damage = (damage)/2
	penetrating = 3
	armor_penetration = ARMOR_CLASS*3

/obj/item/projectile/bullet/rifle/a3006
	damage = DAMAGE_VERY_HIGH + 35
	penetrating = 4
	armor_penetration = ARMOR_CLASS*4
	tracer_type = /obj/effect/projectile/tracer

/obj/item/projectile/bullet/rifle/a3006/weak/New()
	..()
	damage = (damage)/2
	penetrating = 3
	armor_penetration = ARMOR_CLASS*3
	tracer_type = /obj/effect/projectile/tracer/red

/obj/item/projectile/bullet/pistol/c9mm_jap_revolver
	damage = DAMAGE_LOW + 2
	penetrating = 1
	armor_penetration = ARMOR_CLASS*2

/obj/item/projectile/bullet/pistol/c8mmnambu
	damage = DAMAGE_LOW + 1
	penetrating = 1
	armor_penetration = ARMOR_CLASS*2

/obj/item/projectile/bullet/pistol/a9x19
	damage = DAMAGE_LOW
	penetrating = 2
	armor_penetration = ARMOR_CLASS*2

/obj/item/projectile/bullet/pistol/a9x18
	damage = DAMAGE_LOW
	penetrating = 2
	armor_penetration = ARMOR_CLASS*2

/obj/item/projectile/bullet/pistol/a792x33
	damage = DAMAGE_HIGH + 5
	penetrating = 3
	armor_penetration = ARMOR_CLASS*2

/obj/item/projectile/bullet/pistol/rubber/a762x25
	damage = 3

/obj/item/projectile/bullet/rifle/a762x33
	damage = DAMAGE_HIGH + 10
	penetrating = 3
	armor_penetration = ARMOR_CLASS*3

/obj/item/projectile/bullet/rifle/a762x39
	damage = DAMAGE_HIGH + 12
	penetrating = 3
	armor_penetration = ARMOR_CLASS*3
	tracer_type = /obj/effect/projectile/tracer

/obj/item/projectile/bullet/rifle/a545x39
	damage = DAMAGE_MEDIUM_HIGH + 15
	penetrating = 3
	armor_penetration = ARMOR_CLASS*3

/obj/item/projectile/bullet/pistol/rubber/a54x39
	damage = 4

/obj/item/projectile/bullet/rifle/a762x51
	damage = DAMAGE_VERY_HIGH + 23
	penetrating = 5
	armor_penetration = ARMOR_CLASS*4
	tracer_type = /obj/effect/projectile/tracer

/obj/item/projectile/bullet/rifle/a762x51/weak/New()
	..()
	damage = (damage)/2
	penetrating = 3
	armor_penetration = ARMOR_CLASS*4
	tracer_type = /obj/effect/projectile/tracer/green

/obj/item/projectile/bullet/rifle/a556x45
	damage = DAMAGE_HIGH + 3
	penetrating = 3
	armor_penetration = ARMOR_CLASS*3

/obj/item/projectile/bullet/pistol/a765x25
	damage = DAMAGE_LOW + 2
	penetrating = 2
	armor_penetration = 7

/obj/item/projectile/bullet/pistol/a762x25
	damage = DAMAGE_MEDIUM_HIGH + 4
	penetrating = 2
	armor_penetration = ARMOR_CLASS*2

/obj/item/projectile/bullet/pistol/a57x28
	damage = DAMAGE_LOW - 12
	penetrating = 2
	armor_penetration = ARMOR_CLASS*4

/obj/item/projectile/bullet/rifle/a58x42
	damage = DAMAGE_HIGH + 2
	penetrating = 3
	armor_penetration = ARMOR_CLASS*3

/obj/item/projectile/bullet/rifle/a50cal
	damage = DAMAGE_OH_GOD + 95
	penetrating = 10
	armor_penetration = ARMOR_CLASS*10
	heavy_armor_penetration = 10
	tracer_type = /obj/effect/projectile/tracer

/obj/item/projectile/bullet/rifle/a50cal/weak/New()
	..()
	damage = (damage)/2
	penetrating = 10
	armor_penetration = ARMOR_CLASS*8
	tracer_type = /obj/effect/projectile/tracer/red

/obj/item/projectile/bullet/rifle/a50cal_ap
	damage = DAMAGE_MEDIUM + 5
	penetrating = 40
	armor_penetration = ARMOR_CLASS*15
	heavy_armor_penetration = 50
	tracer_type = /obj/effect/projectile/tracer/red

/obj/item/projectile/bullet/rifle/a50cal_he
	damage = DAMAGE_LOW + 20
	penetrating = 12
	armor_penetration = ARMOR_CLASS*5
	tracer_type = /obj/effect/projectile/tracer/red

/obj/item/projectile/bullet/rifle/a50cal_he/on_impact(var/atom/A)
	impact_effect()
	playsound(src, "ric_sound", 50, TRUE, -2)
	if (istype(A, /turf))
		var/turf/T = A
		if (!istype(T, /turf/floor/beach) && !istype(T, /turf/floor/broken_floor))
			T.ChangeTurf(/turf/floor/dirt/burned)
		explosion(T, 1, 0, 2, 1)
	if (istype(A, /obj/structure/vehicleparts/frame))
		var/obj/structure/vehicleparts/frame/T = A
		var/turf/TU
		if (!istype(TU, /turf/floor/beach) && !istype(TU, /turf/floor/broken_floor))
			TU.ChangeTurf(/turf/floor/dirt/burned)
		explosion(T, 1, 0, 2, 1)
	if (istype(A, /obj/structure/simple_door))
		var/obj/structure/simple_door/T = A
		var/turf/TU
		if (!istype(TU, /turf/floor/beach) && !istype(TU, /turf/floor/broken_floor))
			TU.ChangeTurf(/turf/floor/dirt/burned)
		explosion(T, 1, 0, 2, 1)
	else
		var/turf/T = A
		if (!istype(T, /turf/floor/beach) && !istype(T, /turf/floor/broken_floor))
			T.ChangeTurf(/turf/floor/dirt/burned)
		explosion(T, 1, 0, 2, 1)

/obj/item/projectile/bullet/rifle/a127
	damage = DAMAGE_OH_GOD + 65
	penetrating = 20
	armor_penetration = ARMOR_CLASS*10
	heavy_armor_penetration = 34
	tracer_type = /obj/effect/projectile/tracer/red

/obj/item/projectile/bullet/rifle/a145
	damage = DAMAGE_OH_GOD + 90
	penetrating = 20
	armor_penetration = ARMOR_CLASS*15
	heavy_armor_penetration = 45
	tracer_type = /obj/effect/projectile/tracer/red

/obj/item/projectile/bullet/rifle/a15115
	damage = DAMAGE_OH_GOD + 90
	penetrating = 20
	armor_penetration = ARMOR_CLASS*15
	heavy_armor_penetration = 45
	tracer_type = /obj/effect/projectile/tracer

/obj/item/projectile/bullet/rifle/a15115_ap
	damage = DAMAGE_MEDIUM + 64
	penetrating = 40
	armor_penetration = ARMOR_CLASS*20
	heavy_armor_penetration = 55
	tracer_type = /obj/effect/projectile/tracer

/obj/item/projectile/bullet/rifle/a15115_aphe
	damage = DAMAGE_LOW + 25
	penetrating = 30
	armor_penetration = 65
	heavy_armor_penetration = 45
	tracer_type = /obj/effect/projectile/tracer

/obj/item/projectile/bullet/rifle/a15115_aphe/on_impact(var/atom/A)
	impact_effect()
	playsound(src, "ric_sound", 50, TRUE, -2)
	if (istype(A, /turf))
		var/turf/T = A
		if (!istype(T, /turf/floor/beach) && !istype(T, /turf/floor/broken_floor))
			T.ChangeTurf(/turf/floor/dirt/burned)
		explosion(T, 0, 0, 2, 1)
	if (istype(A, /obj/structure/vehicleparts/frame))
		var/obj/structure/vehicleparts/frame/T = A
		var/turf/TU
		if (!istype(TU, /turf/floor/beach) && !istype(TU, /turf/floor/broken_floor))
			TU.ChangeTurf(/turf/floor/dirt/burned)
		explosion(T, 1, 0, 2, 1)
	if (istype(A, /obj/structure/simple_door))
		var/obj/structure/simple_door/T = A
		var/turf/TU
		if (!istype(TU, /turf/floor/beach) && !istype(TU, /turf/floor/broken_floor))
			TU.ChangeTurf(/turf/floor/dirt/burned)
		explosion(T, 1, 0, 2, 1)
	if (istype(A, /obj/item/weapon/reagent_containers/glass/barrel/fueltank))
		var/obj/item/weapon/reagent_containers/glass/barrel/fueltank/T = A
		var/turf/TU
		if (!istype(TU, /turf/floor/beach) && !istype(TU, /turf/floor/broken_floor))
			TU.ChangeTurf(/turf/floor/dirt/burned)
		explosion(T, 1, 0, 3, 1)
	else
		var/turf/T = A
		if (!istype(T, /turf/floor/beach) && !istype(T, /turf/floor/broken_floor))
			T.ChangeTurf(/turf/floor/dirt/burned)
		explosion(T, 0, 0, 2, 1)

/obj/item/projectile/bullet/rifle/a145_ap
	damage = DAMAGE_OH_GOD + 80
	penetrating = 25
	armor_penetration = ARMOR_CLASS*20
	heavy_armor_penetration = 45
	tracer_type = /obj/effect/projectile/tracer/green

/obj/item/projectile/bullet/rifle/a792x94
	damage = DAMAGE_OH_GOD + 85
	penetrating = 20
	armor_penetration = ARMOR_CLASS*10
	heavy_armor_penetration = 30
	tracer_type = /obj/effect/projectile/tracer/green

/obj/item/projectile/bullet/rifle/a792x94_ap
	damage = DAMAGE_OH_GOD + 80
	penetrating = 25
	armor_penetration = ARMOR_CLASS*15
	heavy_armor_penetration = 40
	tracer_type = /obj/effect/projectile/tracer/green

/obj/item/projectile/bullet/pistol/a44p
	damage = DAMAGE_LOW - 20
	penetrating = 1
	armor_penetration = ARMOR_CLASS*2

/obj/item/projectile/bullet/rifle/a9x39
	damage = DAMAGE_VERY_HIGH + 23
	penetrating = 5
	armor_penetration = ARMOR_CLASS*3
	alpha = 128
	tracer_type = null

/obj/item/projectile/bullet/rifle/a357
	damage = DAMAGE_HIGH+30
	penetrating = 2
	armor_penetration = ARMOR_CLASS*3

// Shotguns

/obj/item/projectile/bullet/pellet/buckshot
	kill_count = 20
	agony = 42
	name = "buckshot pellet"
	icon_state = "pellets"
	damage = DAMAGE_VERY_HIGH + 35
	armor_penetration = ARMOR_CLASS*2

/obj/item/projectile/bullet/shotgun/slug
	name = "shotgun slug"
	damage = DAMAGE_MEDIUM_HIGH
	armor_penetration = ARMOR_CLASS*4

/obj/item/projectile/bullet/shotgun/beanbag
	name = "beanbag"
	damage = 5
	armor_penetration = FALSE
	agony = 60
	check_armor = "melee"

	embed = FALSE
	sharp = FALSE

/obj/item/projectile/bullet/shotgun/breaching
	name = "breaching slug"
	damage = DAMAGE_LOW + 5
	armor_penetration = ARMOR_CLASS*5

	embed = FALSE
	sharp = FALSE

/obj/item/projectile/bullet/shotgun/incendiary
	name = "incendiary slug"
	damage = DAMAGE_LOW
	armor_penetration = ARMOR_CLASS*2