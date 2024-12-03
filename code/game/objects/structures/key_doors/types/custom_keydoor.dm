/* File reserved for custom types other than the default metal door that starts locked on /obj/structure/door/key/custom */

/obj/structure/door/key/custom/doubledoor
	name = "large double-door"
	desc = "A large set of improper doors. if you can see this, report this to a developer."
	material = null // This isn't supposed to be spawned.
	icon = 'icons/obj/doors/material_doors_fwoosh.dmi'
	max_health = 200

/obj/structure/door/key/custom/doubledoor/New()
	if(!material)
		CRASH("anyone/doubledoor; called without the material variable set. Are you trying to spawn in the parent doubledoor?")
	..()

/obj/structure/door/key/custom/doubledoor/bone //for tribes
	name = "large bone double-door"
	material = "bone"
	desc = "A large set of bone doors."

/obj/structure/door/key/custom/doubledoor/marble //psuedo-material
	name = "large marble double-door"
	material = "marble"
	desc = "A large set of marble doors."

/obj/structure/door/key/custom/doubledoor/stone
	name = "large stone double-door"
	material = "stone"
	desc = "A large set of stone doors."

/obj/structure/door/key/custom/doubledoor/sandstone
	name = "large sandstone double-door"
	material = "sandstone"
	desc = "A large set of sandstone doors."

/obj/structure/door/key/custom/doubledoor/tin
	name = "large tin double-door"
	material = "tin"
	max_health = 200
	desc = "A large set of tin doors. With enough effort they could be soon broken through."

/obj/structure/door/key/custom/doubledoor/lead
	name = "large lead double-door"
	material = "lead"
	desc = "A large set of lead doors."

/obj/structure/door/key/custom/doubledoor/copper
	name = "large copper double-door"
	material = "copper"
	desc = "A large set of copper doors."

/obj/structure/door/key/custom/doubledoor/bronze
	name = "large bronze double-door"
	material = "bronze"
	max_health = 250
	desc = "A large set of well built and sturdy bronze doors."

/obj/structure/door/key/custom/doubledoor/iron
	name = "large iron double-door"
	material = "iron"
	max_health = 300
	desc = "A large set of strong iron doors."

/obj/structure/door/key/custom/doubledoor/steel
	name = "large reinforced steel double-door"
	material = "steel"
	max_health = 400
	desc = "A large set of reinforced steel doors."
	breachable = FALSE

/obj/structure/door/key/custom/doubledoor/silver
	name = "large silver double-door"
	material = "silver"
	desc = "A large set of shimmering silver doors."
	breachable = FALSE

/obj/structure/door/key/custom/doubledoor/gold
	name = "large gold double-door"
	material = "gold"
	desc = "A large set of glimmering gold doors."

/obj/structure/door/key/custom/singledoor/privacy
	name = "wooden privacy door"
	icon = 'icons/obj/doors/material_doors_fwoosh.dmi'
	base_icon_state = "private"
	icon_state = "private"
	material = "wood"
	desc = "A wood-paneled privacy door."
	max_health = 250
	override_material = TRUE // This has a custom icon.
