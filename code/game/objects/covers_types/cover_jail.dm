/obj/covers/jail
	name = "jail"
	desc = "Do not use this."
	icon = 'icons/turf/walls.dmi'
	icon_state = "woodjail"
	passable = TRUE
	not_movable = TRUE
	density = TRUE
	opacity = FALSE
	amount = 1
	layer = 3
	health = 100000
	wall = TRUE
	explosion_resistance = 100
	material = "Wood"
	hardness = 15

/obj/covers/jail/attackby(obj/item/W as obj, mob/living/human/user as mob)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	if (istype(W,/obj/item/weapon/material/kitchen/utensil/spoon) || istype(W,/obj/item/weapon/material/kitchen/utensil/fork))
		var/obj/item/weapon/material/kitchen/utensil/I = W
		if (I.shiv < 10)
			I.shiv++
			visible_message("<span class='warning'>[user] sharpens \the [I] on \the [src]!</span>")
			if (I.shiv >= 10)
				user.drop_from_inventory(I)
				var/obj/item/weapon/material/kitchen/utensil/knife/shank/SHK = new /obj/item/weapon/material/kitchen/utensil/knife/shank(user,I.material.name)
				user.put_in_hands(SHK)
				to_chat(user, "\The [I] turns into a shank.")
				qdel(I)
	if (istype(W,/obj/item/weapon/material/kitchen/utensil/chopsticks))
		var/obj/item/weapon/material/kitchen/utensil/I = W
		if (I.shiv < 10)
			I.shiv++
			visible_message("<span class='warning'>[user] sharpens \the [I] on \the [src]!</span>")
			if (I.shiv >= 10)
				user.drop_from_inventory(I)
				var/obj/item/weapon/material/kitchen/utensil/knife/shank/wood/SHK = new /obj/item/weapon/material/kitchen/utensil/knife/shank/wood(user,I.material.name)
				user.put_in_hands(SHK)
				to_chat(user, "\The [I] turns into a shank.")
				qdel(I)

	else if (istype(W,/obj/item/weapon/weldingtool))
		if (material != "Steel")
			to_chat(user, "This is the wrong tool.")
		else
			user.visible_message(SPAN_WARNING("[user] starts disassembling \the [src]..."), SPAN_WARNING("You start disassembling \the [src]..."), "You hear the turning of something.")
			playsound(loc, 'sound/effects/extinguish.ogg', 50, TRUE)
			if (do_after(user, 30, target = src))
				for (var/i = TRUE, i <= buildstackamount, i++)
					new buildstack(get_turf(src))
				qdel(src)
				return
	else if (istype(W,/obj/item/weapon/wrench))
		if (material != "Wood")
			to_chat(user, "This is the wrong tool.")
		else
			user.visible_message(SPAN_WARNING("[user] starts disassembling \the [src]..."), SPAN_WARNING("You start disassembling \the [src]..."), "You hear the turning of something.")
			playsound(loc, 'sound/items/Screwdriver.ogg', 50, TRUE)
			if (do_after(user, 30, target = src))
				for (var/i = TRUE, i <= buildstackamount, i++)
					new buildstack(get_turf(src))
				qdel(src)
	else if (istype(W,/obj/item/weapon/metalfile))
		if (material != "Steel")
			to_chat(user, "This is the wrong tool.")
		else
			user.visible_message(SPAN_WARNING("[user] starts filing through \the [src]..."), SPAN_WARNING("You start filing through \the [src]..."), "You hear metallic filing.")
			playsound(loc, 'sound/items/Screwdriver.ogg', 50, TRUE)
			if (do_after(user, 1000, target = src))
				for (var/i = TRUE, i <= buildstackamount, i++)
					new buildstack(get_turf(src))
				qdel(src)
				return
	else if (istype(W,/obj/item/weapon))
		to_chat(user, "You pound the bars uselessly!")
		return
	return TRUE

/obj/covers/jail/bullet_act(var/obj/item/projectile/P)
	return PROJECTILE_CONTINUE

/obj/covers/jail/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if (istype(mover, /obj/effect/effect/smoke))
		return TRUE
	else if (istype(mover, /obj/item/projectile))
		return TRUE
	..()

/obj/covers/jail/woodjail
	name = "wood jail bars"
	desc = "To keep prisoners in."
	icon = 'icons/turf/walls.dmi'
	icon_state = "woodjail"
	passable = TRUE
	not_movable = TRUE
	density = TRUE
	opacity = TRUE
	amount = 1
	layer = 3
	health = 6
	wall = TRUE
	explosion_resistance = 0
	buildstackamount = 8
	buildstack = /obj/item/stack/material/wood
	opacity = FALSE
	material = "Wood"
	passable = FALSE

/obj/covers/jail/steeljail
	name = "steel jail bars"
	desc = "To keep prisoners in better."
	icon = 'icons/turf/walls.dmi'
	icon_state = "steeljail"
	passable = TRUE
	not_movable = TRUE
	density = TRUE
	opacity = TRUE
	amount = 1
	layer = 3
	health = 800
	wall = TRUE
	explosion_resistance = 65
	buildstackamount = 8
	buildstack = /obj/item/stack/rods
	opacity = FALSE
	material = "Steel"
	passable = FALSE
	flammable = FALSE


