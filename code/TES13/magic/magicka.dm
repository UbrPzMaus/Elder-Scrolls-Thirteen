//for TES13 magicka-based spells.

/obj/effect/proc_holder/spell/magicka
	name = "Spell"
	desc = "A magic spell using magicka."
	panel = "Spells"
	sound = null //The sound the spell makes when it is cast
	anchored = TRUE // Crap like fireball projectiles are proc_holders, this is needed so fireballs don't get blown back into your face via atmos etc.
	school = "restoration" //restoration for healing, destruction for elemental damage, illusion for mind tricks, conjuration for summons, and alteration for changing the physical world

	charge_type = "holdervar" //consumes magicka
	holder_var_type = "magicka" //^
	holder_var_amount = 20 //base magicka cost of default spell (overridden by every spell, ever). negative values = spell regenerates magicka.
	holder_var_name = "magicka" //for displaying

	clothes_req = FALSE //see if it requires magic clothes (note: these give +magicka regen anyway)
	nonabstract_req = FALSE //spell can only be cast by mobs that are physical entities
	stat_allowed = FALSE //see if it requires being conscious/alive, need to set to 1 for ghostpells
	phase_allowed = FALSE // If true, the spell can be cast while phased, eg. blood crawling, ethereal jaunting
	antimagic_allowed = FALSE // If false, the spell cannot be cast while under the effect of antimagic
	invocation = "FUS RO DAH!" //what is uttered when the wizard casts the spell
	invocation_emote_self = null
	invocation_type = "none" //can be none, whisper, emote and shout
	range = 7 //the range of the spell; outer radius for aoe spells
	message = "" //whatever it says to the guy affected by it
	selection_type = "view" //can be "range" or "view"
	spell_level = 0 //if a spell can be taken multiple times, this raises
	level_max = 0 //you can't learn spells more than once
	cooldown_min = 0 //see above
	player_lock = TRUE //If it can be used by simple mobs

	overlay = 0
	overlay_icon = 'icons/obj/wizard.dmi'
	overlay_icon_state = "spell"
	overlay_lifespan = 0

	action_icon = 'icons/mob/actions/actions_spells.dmi'
	action_icon_state = "spell_default"
	action_background_icon_state = "bg_spell"
	base_action = /datum/action/spell_action/spell



/////////////////////////////////////
//////////YER A WIZARD HARRY/////////
/////////////////////////////////////

//Called on Life() for human mobs, every 2 seconds or so

/obj/item
	var/gear_magicka_regen = 0
	var/gear_max_magicka = 0

/mob/living/carbon/human/proc/handle_magicka(mob/user = usr)
	var/gear_magicka_regen_total = 0 //start at 0- time to calculate how much magicka you regen.
	var/gear_max_magicka_total = 0 //ditto, but for maxmagicka
	var/list/body_parts = list(head, wear_mask, wear_suit, w_uniform, back, gloves, shoes, belt, s_store, glasses, ears, wear_neck, wear_id) //everywhere except pockets
	for(var/bp in body_parts)
		if(istype(bp, /obj/item))
			var/obj/item/C = bp
			if(C.gear_magicka_regen > 0)
				gear_magicka_regen_total += C.gear_magicka_regen
			if(C.gear_max_magicka > 0)
				gear_max_magicka_total += C.gear_max_magicka
	total_mrr = gear_magicka_regen_total + magicka_recharge_rate
	maxMagicka = gear_max_magicka_total + baseMagicka

	if(magicka < 0) //you can't have negative magicka
		magicka = 0 //so stop trying

	if(magicka > maxMagicka) //you also can't have more than your max
		magicka = maxMagicka //so stop trying

	if(anti_magic_check() || stat == DEAD || (health <= crit_threshold && (stat == SOFT_CRIT || stat == UNCONSCIOUS)))
		magicka = 0 //you're either dead, KO'd, or under an antimagic effect, so set magicka to 0...
		if(src.mind) //avoids runtimes by checking spell lists of people who don't have minds yet
			if(src.mind.spell_list) //don't run this for muggles, duh.
				for(var/obj/effect/proc_holder/spell/magicka/channelled/spell in src.mind.spell_list) //and cancel any active channels...
					if(spell.channel == 1):
						spell.disable(src)
						to_chat(src, "<span class='warning'>Your [spell.name] fizzles out.</span>")
		return //and don't allow any magicka to be recovered.

	if(src.mind) //avoids runtimes by checking spell lists of people who don't have minds yet
		if(src.mind.spell_list) //don't run this for muggles, duh.
			for(var/obj/effect/proc_holder/spell/magicka/channelled/spell in src.mind.spell_list) //and then take away magicka for channels.
				if(spell.channel == 1): //but only if it's active
					spell.effect(src) //do whatever effect the channel has- e.g. heal caster
					magicka -= spell.drain
					if(magicka < spell.drain) //if you can't afford the drain, cancel the channel.
						to_chat(src, "<span class='warning'>You can't sustain this spell any longer!</span>")
						spell.disable(src)
					return //you can't recover magicka while channelling.

	if(magicka < maxMagicka)
		magicka = min(maxMagicka, magicka += total_mrr) //less than max magicka? recover total MRR, up to your max.


/obj/item/bedsheet/archmage //debug item for testing magic easier
	name = "\improper Arch-Mage's cloak"
	desc = "Made from the dreams of those who wonder at the stars, this cloak is imbued with powerful magic, and can enhance the magical capabilities of whoever wears it."
	icon_state = "sheetcosmos"
	item_color = "cosmos"
	dream_messages = list("the infinite cosmos", "Hans Zimmer music", "a flight through space", "the galaxy", "being fabulous", "shooting stars")
	light_power = 2
	light_range = 1.4
	gear_magicka_regen = 40
	gear_max_magicka = 500