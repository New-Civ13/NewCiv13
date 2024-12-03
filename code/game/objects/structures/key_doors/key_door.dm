/obj/structure/door/key
	var/breachable = TRUE
	material = "iron"
	icon = 'icons/obj/doors/material_doors_leonister.dmi'

/obj/structure/door/key/civilization
	var/faction = null
	locked = TRUE

/obj/structure/door/key/civilization/attack_hand(mob/living/human/H)
	if(!ishuman(H)) return //; we typecast in the proc argument

	if(H.civilization == faction)
		if(operating) return
		if(density)
			Open()
		else
			Close()
	else
		H.visible_message(SPAN_NOTICE("[H] knocks at \the [src]."), SPAN_NOTICE("You knock at \the [src]."))
		playsound(get_turf(src), "doorknock", 75, TRUE)

/obj/structure/door/key/civilization/Bumped(mob/living/human/H)
	if(!ishuman(H)) return //; we typecast in the proc argument

	if(H.civilization == faction)
		if(density && !operating)
			Open()
	else
		H.visible_message(SPAN_NOTICE("[H] knocks at \the [src]."), SPAN_NOTICE("You knock at \the [src]."))
		playsound(get_turf(src), "doorknock", 75, TRUE)

/obj/structure/door/key/civilization/Crossed(mob/living/human/H)
	if(!ishuman(H)) return //; we typecast in the proc argument

	if(H.civilization == faction)
		if(!density && !operating)
			spawn(10) // Auto-close.
				if (!operating)
					Close()

/obj/structure/door/key/custom/attackby(obj/item/W as obj, mob/user as mob)
	if (istype(W, /obj/item/weapon/key))
		if (W.code == custom_code)
			locked = !locked
			user.visible_message(SPAN_NOTICE("[user] [locked ? "locks" : "unlocks"] \the [src]."), SPAN_NOTICE("You [locked ? "lock" : "unlock"] \the [src]"))
			playsound(get_turf(src), 'sound/effects/door_lock_unlock.ogg', 100)
		else
			to_chat(user, SPAN_WARNING("This key does not match this lock!"))
	else if (istype(W, /obj/item/weapon/storage/belt/keychain))
		for (var/obj/item/weapon/key/KK in W.contents)
			if (KK.code == custom_code)
				locked = !locked
				user.visible_message(SPAN_NOTICE("[user] [locked ? "locks" : "unlocks"] \the [src]."), SPAN_NOTICE("You [locked ? "lock" : "unlock"] \the [src]"))
				playsound(get_turf(src), 'sound/effects/door_lock_unlock.ogg', 100)
				return // Stop cycling through the keys.
		if (W.code != custom_code)
			to_chat(user, SPAN_WARNING("None of the keys match this lock!"))
	else if (istype(W, /obj/item/weapon/lockpick))
		if (locked)
			var/mob/living/human/H = user
			if (H.getStatCoeff("dexterity") < 1.7)
				to_chat(user, SPAN_WARNING("You don't have the skills to use this.")) // I feel like this shouldn't only check for the skill, it should be based on a prob to successfully pick BASED on skill.
				return
			else
				visible_message(SPAN_DANGER("[user] starts picking the [src.name]'s lock with the [W]!"))
				if (do_after(user, 35*H.getStatCoeff("dexterity"), src))
					if(prob(H.getStatCoeff("dexterity")*35))
						user << SPAN_NOTICE("You pick the lock.")
						locked = !locked
						return
					else if (prob(60))
						qdel(W)
						user << SPAN_NOTICE("Your lockpick broke!")
						return
				return
	else
		if (check_force(W, user))
			if (istype(material, /material/wood || /material/wood/soft))
				playsound(get_turf(src), 'sound/effects/wooddoorhit.ogg', 100)
			else
				playsound(get_turf(src), 'sound/effects/grillehit.ogg', 100)

			// update_damage(-W.force)

/obj/structure/door/key/attackby(obj/item/W as obj, mob/user as mob)
	if (istype(W, /obj/item/weapon/key))
		if (W.code != custom_code)
			to_chat(user, SPAN_WARNING("This key does not match this lock!"))
			return
		locked = !locked
		user.visible_message(SPAN_NOTICE("[user] [locked ? "locks" : "unlocks"] \the [src]."), SPAN_NOTICE("You [locked ? "lock" : "unlock"] \the [src]"))
		playsound(get_turf(src), 'sound/effects/door_lock_unlock.ogg', 100)
	else if (istype(W, /obj/item/weapon/storage/belt/keychain))
		if(!W.contents.len)
			to_chat(user, SPAN_WARNING("\The [W] has no keys!"))
			return
		for (var/obj/item/weapon/key/KK in W.contents)
			if (KK.code == custom_code) // Does any key match?
				locked = !locked
				user.visible_message(SPAN_NOTICE("[user] [locked ? "locks" : "unlocks"] \the [src]."), SPAN_NOTICE("You [locked ? "lock" : "unlock"] \the [src]."))
				playsound(get_turf(src), 'sound/effects/door_lock_unlock.ogg', 100)
				return
		if (W.code != custom_code)
			if(W.contents.len > 1)
				to_chat(user, SPAN_WARNING("None of the keys on \the [W] match this lock!"))
			else
				to_chat(user, SPAN_WARNING("\The key on \the [W] does not match this lock!"))
	else if (istype(W, /obj/item/weapon/lockpick))
		if (locked)
			var/mob/living/human/H = user
			if (H.getStatCoeff("dexterity") < 1.7)
				to_chat(user, SPAN_WARNING("You don't have the skills to use this.")) // I feel like this shouldn't only check for the skill, it should be based on a prob to successfully pick BASED on skill.
				return
			visible_message(SPAN_DANGER("[user] starts picking the [src.name]'s lock with the [W]!"))
			if(!do_after(user, 35*H.getStatCoeff("dexterity"), src))
				return
			if(prob(H.getStatCoeff("dexterity")*35))
				to_chat(user, SPAN_NOTICE("You pick the lock."))
				locked = FALSE
				return
			else if (prob(60))
				to_chat(user, SPAN_WARNING("Your lockpick broke!"))
				qdel(W)
				return
			else
				to_chat(user, SPAN_WARNING("You failed to pick the lock!"))
				
	else if (istype(W, /obj/item/weapon/gun/projectile/shotgun/pump))
		var/obj/item/weapon/gun/projectile/shotgun/pump/pump = W
		if ((breachable && density) && (istype(pump.chambered, /obj/item/ammo_casing/shotgun/buckshot) || istype(pump.chambered, /obj/item/ammo_casing/shotgun/slug) || istype(pump.chambered, /obj/item/projectile/bullet/shotgun/breaching)) && pump.consume_next_projectile())
			user.visible_message(SPAN_WARNING("[user] breaches \the [src]!"), SPAN_WARNING("You breach \the [src]!"))
			pump.Fire(src, user)
			playsound(loc, 'sound/weapons/heavysmash.ogg', 50, 1)
			operating = DOOR_OPERATING_YES
			// Door-related changes.
			locked = FALSE
			density = FALSE
			opacity = FALSE
			// END.
			update_icon()
			operating = DOOR_OPERATING_NO
			// This notifies any atoms to update if necessary.
			for (var/atom/movable/lighting_overlay/L in view(7*3, src))
				L.update_overlay()
			// This notifies any roofs in the surrounding atoms to not be transparent anymore.
			for(var/obj/roof/R in range(1, src))
				R.update_transparency(TRUE)
			new/obj/effect/sparks(loc) // Just light.
			
	else
		if (check_force(W, user))
			if (istype(material, /material/wood || /material/wood/soft))
				playsound(get_turf(src), 'sound/effects/wooddoorhit.ogg', 100)
			if (istype(material, /material/paper))
				playsound(get_turf(src), 'sound/effects/cardboardpunch.ogg', 100)
			else
				playsound(get_turf(src), 'sound/effects/grillehit.ogg', 100)
			
/obj/structure/door/key/custom/attack_hand(mob/user as mob)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	if (!locked) return TryToSwitchState(user)

	if (user.a_intent == I_HELP)
		user.visible_message(SPAN_NOTICE("[user] knocks at \the [src]."), SPAN_NOTICE("You knock at \the [src]."))
		for (var/mob/living/hearer in viewers(7, src))
			if (hearer != user)
				to_chat(hearer, SPAN_NOTICE("You hear a knock at \the [src]."))
		playsound(get_turf(src), "doorknock", 75, TRUE)
	else if (user.a_intent == I_DISARM || user.a_intent == I_GRAB)
		user.visible_message(SPAN_WARNING("[user] bangs on \the [src]."), SPAN_WARNING("You bang on \the [src]."))
		for (var/mob/living/hearer in viewers(7, src))
			if (hearer != user)
				to_chat(hearer, SPAN_NOTICE("You hear a bang at \the [src]."))
		playsound(get_turf(src), "doorknock", 100, TRUE)
	else // I_HARM.
		user.visible_message(SPAN_DANGER("[user] kicks \the [src]!"), SPAN_DANGER("You kick \the [src]!"))
		if (istype(material, /material/wood))
			playsound(get_turf(src), 'sound/effects/wooddoorhit.ogg', 100)
		else
			playsound(get_turf(src), 'sound/effects/grillehit.ogg', 100)
		
		// Scuffed attack animation begin.
		pixel_x += 1.5
		pixel_y += 1.5
		sleep(1)
		pixel_x = initial(pixel_x)
		pixel_y = initial(pixel_y)
		// END.

/obj/structure/door/key/attack_hand(mob/user as mob)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	if (!locked)
		return ..(user)

	if (user.a_intent == I_HELP)
		user.visible_message(SPAN_NOTICE("[user] knocks at \the [src]."), SPAN_NOTICE("You knock at \the [src]."))
		for (var/mob/living/hearer in viewers(7, src))
			if (hearer != user)
				to_chat(hearer, SPAN_NOTICE("You hear a knock at \the [src]."))
		playsound(get_turf(src), "doorknock", 75, TRUE)
	else if (user.a_intent == I_DISARM || user.a_intent == I_GRAB)
		user.visible_message(SPAN_WARNING("[user] bangs on \the [src]."), SPAN_WARNING("You bang on \the [src]."))
		for (var/mob/living/hearer in viewers(7, src))
			if (hearer != user)
				to_chat(hearer, SPAN_NOTICE("You hear a bang at \the [src]."))
		playsound(get_turf(src), "doorknock", 100, TRUE)
	else // I_HARM
		user.visible_message(SPAN_WARNING("[user] kicks \the [src]!"), SPAN_WARNING("You <b>kick</b> \the [src]!"))
		if (istype(material, /material/wood) || istype(material, /material/wood/soft))
			playsound(get_turf(src), 'sound/effects/wooddoorhit.ogg', 100)
		if (istype(material, /material/paper))
			playsound(get_turf(src), 'sound/effects/cardboardpunch.ogg', 100)
		else
			playsound(get_turf(src), 'sound/effects/grillehit.ogg', 100)

		// Scuffed attack animation begin.
		pixel_x += 1.5
		pixel_y += 1.5
		sleep(1)	
		pixel_x = initial(pixel_x)
		pixel_y = initial(pixel_y)
		// END.

		take_damage(10)

/obj/structure/door/key/anyone/attack_hand(mob/user as mob)
	return ..(user)

/obj/structure/door/key/Bumped(atom/user)
	if (!locked)
		if(operating) return
		return TryToSwitchState(user)

/obj/structure/door/key/custom/Bumped(atom/user)
	if (!locked)
		if(operating) return
		return TryToSwitchState(user)

/obj/structure/door/key/anyone/Bumped(atom/user)
	if(operating) return
	return TryToSwitchState(user)

/*
/obj/structure/door/key/proc/update_damage(amt)
	current_health += amt
	damage_display()
	if (current_health <= 0)
		if (istype(src, /obj/structure/door/key/anyone/shoji))
			visible_message(SPAN_DANGER("The shoji door is torn apart!"))
		else if (istype(src,  /obj/structure/door/key/anyone/nordic || /obj/structure/door/key/anyone/wood || /obj/structure/door/key/anyone/rustic || /obj/structure/door/key/anyone/aztec|| /obj/structure/door/key/anyone/singledoor/privacy || /obj/structure/door/key/anyone/singledoor/housedoor))
			visible_message(SPAN_DANGER("[src] collapses into a pile of wood splinters!"))
			new /obj/item/stack/material/wood(loc)
			new /obj/item/stack/material/wood(loc)
			qdel(src)
		else if (istype(src, /obj/structure/door/key/anyone/doubledoor/wood || /obj/structure/door/key/anyone/nordic || /obj/structure/door/key/anyone/wood || /obj/structure/door/key/anyone/rustic || /obj/structure/door/key/anyone/aztec|| /obj/structure/door/key/anyone/singledoor/privacy || /obj/structure/door/key/anyone/singledoor/housedoor))
			visible_message(SPAN_DANGER("[src] collapses into a pile of wood splinters!"))
			new /obj/item/stack/material/woodplank(loc)
			new /obj/item/stack/material/woodplank(loc)
			qdel(src)
		else if (istype(src, /obj/structure/door/key/anyone/doubledoor/bamboo))
			visible_message(SPAN_DANGER("[src] collapses into a pile of bamboo splinters!"))
			new /obj/item/stack/material/bamboo(loc)
			new /obj/item/stack/material/bamboo(loc)
			qdel(src)
		else if (istype(src, /obj/structure/door/key/anyone/doubledoor/stone || /obj/structure/door/key/anyone/doubledoor/marble || /obj/structure/door/key/anyone/roman))
			visible_message(SPAN_DANGER("[src] collapses into a pile of stone rubble!"))
			new /obj/item/stack/material/stone(loc)
			new /obj/item/stack/material/stone(loc)
			qdel(src)
		else if (istype(src, /obj/structure/door/key/anyone/doubledoor/sandstone))
			visible_message(SPAN_DANGER("[src] collapses into a pile of sandstone rubble!"))
			new /obj/item/stack/material/sandstone(loc)
			new /obj/item/stack/material/sandstone(loc)
			qdel(src)
		else if (istype(src, /obj/structure/door/key/anyone/doubledoor/marble))
			visible_message(SPAN_DANGER("[src] collapses into a pile of marble rubble!"))
			new /obj/item/stack/material/marble(loc)
			new /obj/item/stack/material/marble(loc)
			qdel(src)
		else if (istype(src, /obj/structure/door/key/anyone/doubledoor/bone))
			visible_message(SPAN_DANGER("[src] collapses into a pile of bones!"))
			new /obj/item/stack/material/bone(loc)
			new /obj/item/stack/material/bone(loc)
			qdel(src)
		else
			visible_message(SPAN_DANGER("\The [src] breaks!"))
		qdel(src)

/obj/structure/door/key/proc/damage_display()
	if(current_health < max_health / 4 && !showed_damage_messages[1])
		visible_message(SPAN_DANGER("[src] looks like it's about to break!"))
		showed_damage_messages[1] = TRUE

	else if(current_health < (max_health / 2) && !showed_damage_messages[2])
		visible_message(SPAN_DANGER("[src] looks seriously damaged!"))
		showed_damage_messages[2] = TRUE

	else if (current_health < (max_health * 3/4) && !showed_damage_messages[3])
		visible_message(SPAN_DANGER("[src] starts to show signs of damage."))
		showed_damage_messages[3] = TRUE
*/
