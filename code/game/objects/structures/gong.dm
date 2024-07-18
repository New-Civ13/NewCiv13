/obj/structure/gong
	name = "gong"
	icon = 'icons/obj/structures.dmi'
	icon_state = "gong"
	anchored = TRUE
	density = TRUE
	not_movable = FALSE
	not_disassemblable = FALSE
	var/cooldown_gong = FALSE

/obj/structure/gong/attackby(var/obj/item/I, var/mob/living/human/H)
	if (!istype(H))
		return
	if (H.a_intent != I_HELP)
		return

	if (istype(I, /obj/item/weapon/wrench))
		H.visible_message(SPAN_WARNING("[H] starts to [anchored ? "unsecure" : "secure"] \the [src] [anchored ? "from" : "to"] the ground."), SPAN_WARNING("You start to [anchored ? "unsecure" : "secure"] \the [src] [anchored ? "from" : "to"] the ground."))
		playsound(src, 'sound/items/Ratchet.ogg', 100, TRUE)
		if (do_after(H, 50, src))
			H.visible_message(SPAN_WARNING("[H] [anchored ? "unsecures" : "secures"] \the [src] [anchored ? "from" : "to"] the ground."), SPAN_WARNING("You [anchored ? "unsecure" : "secure"] \the [src] [anchored ? "from" : "to"] the ground."))
			anchored = !anchored
			return

	if (istype(I, /obj/item/weapon/hammer))
		H.visible_message(SPAN_WARNING("[H] starts to deconstruct \the [src]."), SPAN_WARNING("You start to deconstruct \the [src]."))
		playsound(src, 'sound/items/Ratchet.ogg', 100, TRUE)
		if (do_after(H, 50, src))
			H.visible_message(SPAN_WARNING("[H] deconstructs \the [src]."), SPAN_WARNING("You deconstruct \the [src]."))
			qdel(src)
			return

	if (istype(I, /obj/item/weapon/gongmallet))
		if (cooldown_gong != FALSE)
			return

			cooldown_gong = TRUE
			playsound(loc, 'sound/effects/gong.ogg', 200, FALSE, 5)
			H.visible_message(SPAN_WARNING("[H] hits \the [src]!"), SPAN_WARNING("You hit \the [src]!"))

			spawn(75)
				cooldown_gong = FALSE
