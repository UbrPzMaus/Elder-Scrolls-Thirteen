//example/debug self spell:

/obj/effect/proc_holder/spell/magicka/self //Targets only the caster, fire-and-forget.
	range = -1 //Duh

/obj/effect/proc_holder/spell/magicka/self/choose_targets(mob/user = usr)
	if(!user)
		revert_cast()
		return
	perform(null,user=user)

/*
/obj/effect/proc_holder/spell/magicka/self/basic_heal //Debug self-cast F&F magicka spell
	name = "Lesser Heal"
	desc = "Heals a small amount of brute and burn damage."
	human_req = TRUE
	holder_var_amount = 10
	school = "restoration"
	sound = 'sound/magic/staff_healing.ogg'

/obj/effect/proc_holder/spell/magicka/self/basic_heal/cast(mob/living/carbon/human/user) //Note the lack of "list/targets" here. Instead, use a "user" var depending on mob requirements.
	//Also, notice the lack of a "for()" statement that looks through the targets. This is, again, because the spell can only have a single target.
	user.visible_message("<span class='warning'>A wreath of gentle light passes over [user]!</span>", "<span class='notice'>You wreath yourself in healing light!</span>")
	user.adjustBruteLoss(-10)
	user.adjustFireLoss(-10)

/datum/spellbook_entry/lesserheal
	name = "Lesser Heal"
	spell_type = /obj/effect/proc_holder/spell/magicka/self/basic_heal
*/

/obj/effect/proc_holder/spell/magicka/channelled //for spells that can be toggled on and off. These spells must affect the caster- to affect others, give them an in-hand item or something.
	var/drain = 0 //drain per 2 seconds
	var/channel = 0
	holder_var_amount = 0 //base cost to activate and deactivate. keep this at 0, since effects only happen on Life() when drain magicka is removed.
	range = -1 //ONLY for self-target spells! see Disintegrate if you want to force an item into their hand that they can affect others with.

/obj/effect/proc_holder/spell/magicka/channelled/proc/disable(mob/user = usr) //custom proc required for each channel to remove any active buffs.
	return

/obj/effect/proc_holder/spell/magicka/channelled/proc/effect(mob/user = usr) //custom proc required for each channel- effect refreshes every 2 seconds (e.g. invisibility).
	return

/obj/effect/proc_holder/spell/magicka/channelled/choose_targets(mob/user = usr)
	if(!user)
		revert_cast()
		return
	perform(null,user=user)

//example/debug channelled spell:

/*
/obj/effect/proc_holder/spell/magicka/channelled/basic_heal_over_time //Debug self-cast heal-over-time magicka spell
	name = "Lesser Heal Over Time"
	desc = "Heals a small amount of brute and burn damage over time."
	human_req = TRUE
	holder_var_amount = 0 //free to activate
	drain = 5 //but costs 5 per 2s to keep it active
	school = "restoration"
	sound = 'sound/magic/staff_healing.ogg'

/obj/effect/proc_holder/spell/magicka/channelled/basic_heal_over_time/cast(mob/living/carbon/human/user)
	if(user.magicka == 0) //no magicka (or antimagic, or dead...)? can't cast
		return 0
	else if(channel == 0)
		user.visible_message("<span class='warning'>A wreath of gentle light passes over [user]!</span>", "<span class='notice'>You wreath yourself in healing light!</span>")
		channel = 1
	else
		channel = 0
		user.visible_message("<span class='warning'>The light around [user] fades!</span>", "<span class='notice'>The healing light around you fades!</span>")

/obj/effect/proc_holder/spell/magicka/channelled/basic_heal_over_time/effect(mob/living/carbon/user) //only checked while active.
	to_chat(user, "<span class='notice'>(DEBUG) You can feel your flesh knitting together!</span>")
	user.adjustBruteLoss(-5)
	user.adjustFireLoss(-5)

/obj/effect/proc_holder/spell/magicka/channelled/basic_heal_over_time/disable(mob/living/carbon/user) //if force disable
	channel = 0
	user.visible_message("<span class='warning'>The light around [user] fades!</span>", "<span class='notice'>The healing light around you fades!</span>")

/datum/spellbook_entry/lesserhealovertime
	name = "Lesser Heal Over Time"
	spell_type = /obj/effect/proc_holder/spell/magicka/channelled/basic_heal_over_time
*/


/obj/effect/proc_holder/spell/magicka/channelled/inhand //for channelled spells that give you an in-hand object for the duration (e.g. healing hands, conjure sword)
	var/inhand_type = /obj/item/gun/medbeam/healinghands //what does it put in your hand?

/obj/effect/proc_holder/spell/magicka/channelled/inhand/cast(mob/living/carbon/human/user)
	if(user.magicka == 0) //no magicka (or antimagic, or dead...)? can't cast
		return 0
	else if(channel == 0)
		channel = 1
		to_chat(user, "<span class='warning'>You begin channelling magicka into your hand!</span>")
	else
		channel = 0
		to_chat(user, "<span class='warning'>You stop channelling magicka into your hand!</span>")
		user.magicka += holder_var_amount //refund any extra magicka you used from casting the cancel
		for(var/obj/item/H in user.held_items) //delete the healing hands
			if(istype(H, inhand_type))
				qdel(H)

/obj/effect/proc_holder/spell/magicka/channelled/inhand/effect(mob/living/carbon/user) //only checked while active.
	for(var/obj/item/H in user.held_items) //if you already have one, don't give another
		if(istype(H, inhand_type))
			return
	var/obj/item/I = new inhand_type(user)
	if(user.can_equip(I, SLOT_HANDS))
		user.put_in_hands(I)
	else
		if (user.get_num_arms() <= 0)
			to_chat(user, "<span class='warning'>You dont have any usable hands!</span>")
			qdel(I)
		else
			to_chat(user, "<span class='warning'>Your hands are full!</span>")
			qdel(I)

/obj/effect/proc_holder/spell/magicka/channelled/inhand/disable(mob/living/carbon/user) //if force disable
	channel = 0
	for(var/obj/item/H in user.held_items) //delete the inhand_type
		if(istype(H, inhand_type))
			qdel(H)

/*/obj/item/gun/medbeam/healinghands
	name = "healing hand"
	desc = "A hand charged with restorative energy."
	icon = 'icons/obj/items_and_weapons.dmi'
	lefthand_file = 'icons/mob/inhands/misc/touchspell_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/touchspell_righthand.dmi'
	icon_state = "zapper"
	item_state = "zapper"
	item_flags = ABSTRACT | DROPDEL
	w_class = WEIGHT_CLASS_HUGE
	force = 0
	throwforce = 0
	throw_range = 0
	throw_speed = 0
	healamt = 5 //heals 5 brute/burn and [5/4] oxy/tox per tick.
	max_range = 4
	pin = /obj/item/firing_pin/magic

/obj/item/gun/medbeam/healinghands/Initialize()
	. = ..()
	add_trait(ABSTRACT_ITEM_TRAIT)

/obj/item/gun/medbeam/healinghands/handle_suicide() //Stops people trying to commit suicide to heal themselves
	return

/obj/item/gun/medbeam/healinghands/dropped(mob/user) //if you drop it, cancel the spell.
	if(user.mind)
		if(user.mind.spell_list)
			for(var/obj/effect/proc_holder/spell/magicka/channelled/inhand/healinghands/spell in user.mind.spell_list)
				if(spell.channel == 1):
					spell.channel = 0

*/

/obj/item/melee/spellholder
	name = "\improper spellholder"
	desc = "You shouldn't be seeing this!"
	icon = 'icons/obj/items_and_weapons.dmi'
	lefthand_file = 'icons/mob/inhands/misc/touchspell_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/touchspell_righthand.dmi'
	icon = 'icons/obj/items_and_weapons.dmi'
	lefthand_file = 'icons/mob/inhands/misc/touchspell_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/touchspell_righthand.dmi'
	icon_state = "zapper"
	item_state = "zapper"
	item_flags = ABSTRACT | DROPDEL
	w_class = WEIGHT_CLASS_HUGE
	force = 0
	throwforce = 0
	throw_range = 0
	throw_speed = 0
	var/obj/effect/proc_holder/spell/magicka/channelled/inhand/linkedspell = null

/obj/item/melee/spellholder/Initialize()
	. = ..()
	add_trait(ABSTRACT_ITEM_TRAIT)

/obj/item/melee/spellholder/dropped(mob/user) //if you drop it, cancel the spell.
	if(user.mind)
		if(user.mind.spell_list)
			for(linkedspell in user.mind.spell_list)
				if(linkedspell.channel == 1)
					linkedspell.channel = 0