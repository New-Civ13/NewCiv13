////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/obj/item/weapon/storage/belt/keychain
	name = "key-chain"
	desc = "A chain to hold keys, key-chain!"
	icon = 'icons/obj/key.dmi'
	icon_state = "keychain_0"

	var/list/keys = list()
	slot_flags = SLOT_ID|SLOT_BELT|SLOT_POCKET

	w_class = ITEM_SIZE_TINY
	max_w_class = 1

	/// Integer. The amount of objects this can hold.
	storage_slots = 20
	/// Integer. The sum of the storage costs of all the items in this storage item.
	max_storage_space = 1000 // more-or-less INFINITY.

	dropsound = 'sound/effects/drop_knife.ogg' // Metallic sound.
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/obj/item/weapon/storage/belt/keychain/New()
	..()
	update_icon_state()

/obj/item/weapon/storage/belt/keychain/open()
	return

/obj/item/weapon/storage/belt/keychain/orient2hud(mob/user as mob)
	return FALSE

/obj/item/weapon/storage/belt/keychain/examine(mob/user)
	. = ..()
	if (get_dist(src, user) <= 1) // If you are examining up-close.
		to_chat(user, SPAN_NOTICE("There [length(keys) == 1 ? "is" : "are"] [length(keys)] key\s on \the [src].")) // Lots of proper sentence grammar handling.

/obj/item/weapon/storage/belt/keychain/proc/update_icon_state() // For simplicity sake.
	switch (length(keys))
		if (0 to 3)
			icon_state = "keychain_[length(keys)]"
		else
			icon_state = "keychain_many" // 3 keys on sprite, no more added. So we keep the same sprite if above 3.

/obj/item/weapon/storage/belt/keychain/attack_hand(mob/user as mob)
	if (loc != user) // Are we not holding the keychain?
		return ..(user) // Pick it up.
	else if (!length(keys)) // Do we have keys in the keychain?
		return user.put_in_active_hand(src)// No we don't, swap the object into the active hand.
	else if (length(keys) == 1) // Take out the key without the WWinput(), since we only have one key to choose from.
		user.put_in_hands(keys[1])
		user.visible_message(SPAN_NOTICE("[user] takes out \the [keys[1]] from their keychain"), SPAN_NOTICE("You take out \the [keys[1]] from your keychain."))
		keys -= keys[1]
		update_icon_state() // Order matters, update AFTER removing the key.
		return
	
	// Selective WWinput for multiple key choices.
	var/obj/item/weapon/key/which = WWinput(user, "Take out a key?", "Keychain", "Cancel", WWinput_list_or_null(keys)) // Shows the key list option(s) and a cancel, which is default. (If two keys are named the same, only one field instance will be shown. It gives out the first one? Not sure.)
	if(!which || which.loc != src) // If you cancel or if the key is not in the keychain. (Order matters or else it will runtime.)
		return
	else if (user in range(1, src)) // In range of the key-chain?
		user.put_in_hands(which)
		keys -= which
		update_icon_state() // Order matters, update AFTER removing the key.
		user.visible_message(SPAN_NOTICE("[user] takes a key from their keychain"), SPAN_NOTICE("You take out \the [which] from your keychain."))

/obj/item/weapon/storage/belt/keychain/attackby(obj/item/weapon/key/KEY as obj, mob/user as mob)
	if (!istype(KEY)) return // We type-cast in the proc parameters.

	else if (can_be_inserted(KEY)) // Returns TRUE if handled. Returns FALSE if not. Sends a message to user if FALSE, "The key-chain is full, make some space." in SPAN_NOTICE.
		handle_item_insertion(KEY) // Handles the message sent to everyone, add `prevent_warning = TRUE` to prevent that.
		keys += KEY // Add the key to the list of keys, (storage list.)
		update_icon_state() // Order matters, update AFTER adding the key.
////////////////////////////////////////////////////////////////////////////////////////////////////////////////