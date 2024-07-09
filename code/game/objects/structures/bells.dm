////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/obj/structure/bell_stand
	name = "bell-stand"
	desc = "A stand with a bell!"
	icon = 'icons/obj/structures.dmi'
	icon_state = "bell_stand"
	anchored = TRUE
	density = TRUE
	not_movable = FALSE
	not_disassemblable = FALSE
	var/cooldown_bell_stand = FALSE

/obj/structure/bell_stand/attack_hand(mob/living/human/H)
	if (cooldown_bell_stand != FALSE)
		to_chat(H, SPAN_WARNING("This was already rung recently!"))
		return

	cooldown_bell_stand = TRUE
	icon_state = "bell_stand_ringing"

	playsound(loc, 'sound/effects/bell_stand.ogg', 200, FALSE, 5)
	H.visible_message(SPAN_WARNING("[H] rings \the [src]!"), SPAN_WARNING("You ring \the [src]!"))

	spawn(2 SECONDS)
		icon_state = "bell_stand"
		cooldown_bell_stand = FALSE // Reset the cooldown, allow the ring again.

/obj/structure/bell_stand/attackby(obj/item/I, mob/living/human/H) // TLDR ; unanchoring, deconstructing.
	if (!istype(H) || H.a_intent != I_HELP)
		return

	if (istype(I, /obj/item/weapon/wrench))
		H.visible_message(SPAN_WARNING("[H] starts to [anchored ? "unsecure" : "secure"] \the [src] [anchored ? "from" : "to"] the ground."), SPAN_WARNING("You start to [anchored ? "unsecure" : "secure"] \the [src] [anchored ? "from" : "to"] the ground."))
		playsound(src, 'sound/items/Ratchet.ogg', 100, TRUE)
		if (do_after(H,50,src))
			H.visible_message(SPAN_WARNING("[H] [anchored ? "unsecures" : "secures"] \the [src] [anchored ? "from" : "to"] the ground."), SPAN_WARNING("You [anchored ? "unsecure" : "secure"] \the [src] [anchored ? "from" : "to"] the ground."))
			anchored = !anchored
			return

	else if (istype(I, /obj/item/weapon/hammer))
		H.visible_message(SPAN_WARNING("[H] starts to deconstruct \the [src]."), SPAN_WARNING("You start to deconstruct \the [src]."))
		playsound(src, 'sound/items/Ratchet.ogg', 100, TRUE)
		if (do_after(H,50,src))
			H.visible_message(SPAN_WARNING("[H] deconstructs \the [src]."), SPAN_WARNING("You deconstruct \the [src]."))
			qdel(src)

////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/obj/structure/bell_stand/church
	name = "church bell-stand"
	desc = "A stand with a church bell. It looks like it could be <b>extremely</b> loud!"

/obj/structure/bell_stand/church/attack_hand(mob/living/human/H)
	if (cooldown_bell_stand != FALSE)
		to_chat(H, SPAN_WARNING("This was already rung recently!"))
		return

	cooldown_bell_stand = TRUE // Start the cooldown, 16 seconds.
	icon_state = "bell_stand_ringing"

	world << sound('sound/effects/church_bells.ogg', repeat = TRUE, wait = TRUE, channel = 777)

	H.visible_message(SPAN_WARNING("[H] rings \the [src]!"), SPAN_WARNING("You ring \the [src]!"))
	to_chat(world, SPAN_WARNING("<font size = 5>\icon[src] The church bell rings!</font>"))

	spawn(15 SECONDS)
		world << sound(null, channel = 777)
		icon_state = "bell_stand"
		cooldown_bell_stand = FALSE // Reset the cooldown, allow the ring again.

////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/obj/item/weapon/handbell
	name = "hand-bell"
	desc = "A bell, rung by hand."
	icon = 'icons/obj/items.dmi'
	icon_state = "handbell"
	item_state = "handbell"
	flags = CONDUCT
	force = WEAPON_FORCE_HARMLESS
	throwforce = WEAPON_FORCE_HARMLESS
	w_class = ITEM_SIZE_SMALL

	attack_verb = list("attacked", "whacked")
	var/cooldown_handbell = FALSE

/obj/item/weapon/handbell/attack_self(mob/user as mob) // Notice the mob/user (Just kept here for other mobs. fail-safe.)
	if (cooldown_handbell != FALSE)
		to_chat(user, SPAN_WARNING("This was already rung recently!"))
		return

	playsound(loc, 'sound/effects/handbell.ogg', 100, FALSE, 5)
	user.visible_message(SPAN_WARNING("[user] rings \the [name]!"), SPAN_WARNING("You ring \the [name]!"))

	cooldown_handbell = TRUE // Start the cooldown, 5 seconds.

	spawn(5 SECONDS)
		cooldown_handbell = FALSE // Reset the cooldown, allow the ring again.

////////////////////////////////////////////////////////////////////////////////////////////////////////////////