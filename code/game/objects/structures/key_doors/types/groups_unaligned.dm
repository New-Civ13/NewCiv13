// not locked at all - no key, of course
#define ANYONE_CODE 995 * 3

/obj/structure/door/key/anyone
	material = "iron"
	custom_code = -1

/obj/structure/door/key/anyone/wood
	material = "wood"
	max_health = 150

/obj/structure/door/key/anyone/shoji
	name = "shoji door"
	material = "paper"
	max_health = 50
	open_sound = 'sound/machines/shoji_door_open.ogg'
	close_sound = 'sound/machines/shoji_door_close.ogg'

/* See key_door.dm for relevant information about shoji ^, as the code is partitioned*/

/obj/structure/door/key/anyone/rustic
	name = "rustic door"
	material = "log"
	icon_state = "rustic"
	max_health = 100
	override_material = TRUE // This has a custom icon.

/obj/structure/door/key/anyone/nordic
	material = "log"
	name = "nordic door"
	icon_state = "nordic"
	max_health = 150
	override_material = TRUE // This has a custom icon.

/obj/structure/door/key/anyone/aztec
	material = "wood"
	name = "aztec door"
	icon_state = "aztec"
	max_health = 150
	override_material = TRUE // This has a custom icon.

/obj/structure/door/key/anyone/roman
	material = "stone"
	name = "roman door"
	icon_state = "roman"
	max_health = 200
	override_material = TRUE // This has a custom icon.

/obj/structure/door/key/anyone/blast
	material = "steel"
	name = "mechanical blast door"
	icon_state = "blast"
	max_health = 900
	override_material = TRUE // This has a custom icon.
	open_sound = 'sound/effects/rollermove.ogg'
	close_sound = 'sound/effects/rollermove.ogg'

/obj/structure/door/key/anyone/doubledoor
	name = "large double-door"
	desc = "A large set of improper doors. if you can see this, report this to a developer."
	material = null // Not supposed to be spawned.
	icon = 'icons/obj/doors/material_doors_fwoosh.dmi'
	max_health = 200

/obj/structure/door/key/anyone/doubledoor/New()
	if(!material)
		CRASH("anyone/doubledoor; called without the material variable set. Are you trying to spawn in the parent doubledoor?")
	..()

/obj/structure/door/key/anyone/doubledoor/wood
	name = "large wood double-door"
	material = "wood"
	desc = "A large set of wood doors."
	max_health = 150

/obj/structure/door/key/anyone/doubledoor/bamboo
	name = "large bamboo double-door"
	material = "bamboo"
	desc = "A large set of bamboo doors."
	max_health = 150

/obj/structure/door/key/anyone/doubledoor/bone //for tribes
	name = "large bone double-door"
	material = "bone"
	desc = "A large set of bone doors."

/obj/structure/door/key/anyone/doubledoor/marble
	name = "large marble double-door"
	material = "marble"
	desc = "A large set of marble doors."

/obj/structure/door/key/anyone/doubledoor/stone
	name = "large stone double-door"
	material = "stone"
	desc = "A large set of stone doors."

/obj/structure/door/key/anyone/doubledoor/sandstone
	name = "large stone double-door"
	material = "sandstone"
	desc = "A large set of sandstone doors."

/obj/structure/door/key/anyone/doubledoor/tin
	name = "large tin double-door"
	material = "tin"
	max_health = 150
	desc = "A large set of tin doors."

/obj/structure/door/key/anyone/doubledoor/lead
	name = "large lead double-door"
	material = "lead"
	desc = "A large set of lead doors."

/obj/structure/door/key/anyone/doubledoor/copper
	name = "large copper double-door"
	material = "copper"
	desc = "A large set of copper doors."

/obj/structure/door/key/anyone/doubledoor/bronze
	name = "large bronze double-door"
	material = "bronze"
	max_health = 250
	desc = "A large set of well built and sturdy bronze doors."

/obj/structure/door/key/anyone/doubledoor/iron
	name = "large iron double-door"
	material = "iron"
	max_health = 300
	desc = "A large set of strong iron doors."

/obj/structure/door/key/anyone/doubledoor/steel
	name = "large reinforced steel double-door"
	material = "steel"
	desc = "A large set of reinforced steel doors."

/obj/structure/door/key/anyone/doubledoor/steel/store_door
	name = "store double-door"
	desc = "A large steel and glass double-door."
	max_health = 150
	icon = 'icons/obj/doors/material_doors.dmi'
	base_icon_state = "storedoor"
	icon_state = "storedoor"
	override_material = TRUE // This has a custom icon.
	override_opacity = TRUE // This is see-through at all times.
	opacity = FALSE // This has windows.

/obj/structure/door/key/anyone/doubledoor/silver
	name = "large silver double-door"
	material = "silver"
	desc = "A large set of shimmering silver doors."

/obj/structure/door/key/anyone/doubledoor/gold
	name = "large gold double-door"
	material = "gold"
	desc = "A large set of glimmering gold doors."

/obj/structure/door/key/anyone/singledoor/privacy
	name = "wooden privacy door"
	icon = 'icons/obj/doors/material_doors_fwoosh.dmi'
	icon_state = "private"
	material = "wood"
	desc = "A wood-paneled privacy door."
	override_material = TRUE // This has a custom icon.
/obj/structure/door/key/anyone/singledoor/privacy/New(newloc, material_name)
	..()

/obj/structure/door/key/anyone/singledoor/housedoor
	name = "wooden house door"
	icon = 'icons/obj/doors/material_doors_fwoosh.dmi'
	icon_state = "housedoor"
	material = "wood"
	desc = "A wood-paneled house door with see-through windows."
	override_material = TRUE // This has a custom icon.
	override_opacity = TRUE // This has windows.
/obj/structure/door/key/anyone/singledoor/housedoor/New(newloc, material_name)
	..()
	opacity = FALSE // You can see-through this.

/obj/structure/door/key/anyone/ship
	name = "wooden ship door"
	desc = "A round-wooden ship door."
	icon = 'icons/obj/doors/material_doors_leonister.dmi'
	icon_state = "ship"
	material = "log"
	override_material = TRUE
	max_health = 150

/obj/structure/door/key/anyone/high_sec
	name = "secure door"
	icon = 'icons/obj/doors/rapid_pdoor.dmi'
	icon_state = "secure"
	desc = "A sturdy and secure sliding door."
	material = "steel"
	override_material = TRUE // This has a custom icon.
	
#undef ANYONE_CODE

