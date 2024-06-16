/*
 * Pill Bottles*
 * 
 * To-do: refactor the "for" statements into a proc
 */
/obj/item/weapon/storage/pill_bottle
	name = "pill bottle"
	desc = "An airtight container for storing medication."
	icon_state = "pill_canister"
	icon = 'icons/obj/chemical.dmi'
	item_state = "contsolid"
	w_class = ITEM_SIZE_SMALL
	can_hold = list(/obj/item/weapon/reagent_containers/pill,/obj/item/weapon/dice,/obj/item/weapon/paper)
	allow_quick_gather = TRUE
	use_to_pickup = TRUE
	use_sound = null
	max_storage_space = 20
	var/pill_amount = 14

/obj/item/weapon/storage/pill_bottle/attackby(var/obj/item/I, var/mob/user)
	if (istype(I, /obj/item/weapon/pen))
		var/label = sanitize(input(user, "What do you want to label the pill bottle as?") as text, 50)
		name = label
		return TRUE
	return ..(I, user)

/obj/item/weapon/storage/pill_bottle/antitox
	name = "bottle of Dylovene pills"
	desc = "Contains pills used to counter toxins."

	New()
		..()
		for (var/i=1, i <= pill_amount, i++)
			new /obj/item/weapon/reagent_containers/pill/antitox(src)

/obj/item/weapon/storage/pill_bottle/paracetamol
	name = "bottle of paracetamol pills"
	desc = "Contains pills used to counter mild to moderate pain."

	New()
		..()
		for (var/i=1, i <= pill_amount, i++)
			new /obj/item/weapon/reagent_containers/pill/paracetamol(src)

/obj/item/weapon/storage/pill_bottle/penicillin
	name = "bottle of penicillin pills"
	desc = "An antibiotic. Effective against many microbial diseases."

/obj/item/weapon/storage/pill_bottle/penicillin/New()
	..()
	for (var/i=1, i <= pill_amount, i++)
		new /obj/item/weapon/reagent_containers/pill/penicillin(src)

/obj/item/weapon/storage/pill_bottle/tramadol
	name = "bottle of Tramadol pills"
	desc = "Contains pills used to relieve pain."

	New()
		..()
		for (var/i=1, i <= pill_amount, i++)
			new /obj/item/weapon/reagent_containers/pill/tramadol(src)

/obj/item/weapon/storage/pill_bottle/pervitin
	name = "bottle of Pervitin pills"
	desc = "Contains pills of methamphetamine."

	New()
		..()
		for (var/i=1, i <= pill_amount, i++)
			new /obj/item/weapon/reagent_containers/pill/pervitin(src)

/obj/item/weapon/storage/pill_bottle/potassium_iodide
	name = "bottle of potassium iodide pills"
	desc = "Contains pills of potassium iodide, used for radiation poisoning."

	New()
		..()
		for (var/i=1, i <= pill_amount, i++)
			new /obj/item/weapon/reagent_containers/pill/potassium_iodide(src)

/obj/item/weapon/storage/pill_bottle/citalopram
	name = "bottle of Citalopram pills"
	desc = "Contains pills used to stabilize a patient's mood."

	New()
		..()
		for (var/i=1, i <= pill_amount, i++)
			new /obj/item/weapon/reagent_containers/pill/citalopram(src)
