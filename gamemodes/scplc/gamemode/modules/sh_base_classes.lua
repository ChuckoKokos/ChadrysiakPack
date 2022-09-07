CLASSD_MODELS = {
	"models/player/kerry/class_d_1.mdl",
	"models/player/kerry/class_d_2.mdl",
	"models/player/kerry/class_d_3.mdl",
	"models/player/kerry/class_d_4.mdl",
	"models/player/kerry/class_d_5.mdl",
	"models/player/kerry/class_d_6.mdl",
	"models/player/kerry/class_d_7.mdl",
	"models/player/kleiner.mdl",
	"models/player/phoenix.mdl",
	"models/player/charple.mdl",
	"models/player/gman_high.mdl",
	"models/player/skeleton.mdl",
}

HEISENBERG_MODELS = {
	"models/agent_47/agent_47.mdl",
}

JESSE_MODELS = {
	"models/bloocobalt/splinter cell/chemsuit_cod.mdl"
}

ALIEN_MODELS = {
	"models/player/scoutplayer/scout.mdl",
}

VETERAND_MODELS = {
	"models/player/kerry/class_jan_2.mdl",
	"models/player/kerry/class_jan_3.mdl",
	"models/player/kerry/class_jan_4.mdl",
	"models/player/kerry/class_jan_5.mdl",
	"models/player/kerry/class_jan_6.mdl",
	"models/player/kerry/class_jan_7.mdl",
}

SCI_MODELS = {
	"models/bmscientistcits/p_female_01.mdl",
	"models/bmscientistcits/p_female_02.mdl",
	"models/bmscientistcits/p_female_03.mdl",
	"models/bmscientistcits/p_female_04.mdl",
	"models/bmscientistcits/p_female_06.mdl",
	"models/bmscientistcits/p_female_07.mdl",
	"models/bmscientistcits/p_male_01.mdl",
	"models/bmscientistcits/p_male_02.mdl",
	"models/bmscientistcits/p_male_03.mdl",
	"models/bmscientistcits/p_male_04.mdl",
	"models/bmscientistcits/p_male_05.mdl",
	"models/bmscientistcits/p_male_06.mdl",
	"models/bmscientistcits/p_male_07.mdl",
	"models/bmscientistcits/p_male_08.mdl",
	"models/bmscientistcits/p_male_09.mdl",
	"models/bmscientistcits/p_male_10.mdl",
	"models/scp/apsci_cohrt.mdl",
	"models/scp/apsci_male_02.mdl",
	"models/scp/apsci_male_03.mdl",
	"models/scp/apsci_male_05.mdl",
	"models/scp/apsci_male_07.mdl",
	"models/scp/apsci_male_08.mdl",
	"models/scp/apsci_male_09.mdl",
}

GUARD_MODELS = {
	"models/player/alski/security.mdl",
	"models/player/alski/security2.mdl",
	"models/player/alski/security3.mdl",
	"models/player/alski/security4.mdl",
	"models/player/alski/security5.mdl",
	"models/player/alski/security6.mdl",
	"models/player/alski/security7.mdl",
	"models/player/alski/security8.mdl",
	"models/player/alski/security9.mdl",
}

MTF_MODELS = {
	"models/npc/portal/male_02_garde.mdl",
	"models/npc/portal/male_04_garde.mdl",
	"models/npc/portal/male_05_garde.mdl",
	"models/npc/portal/male_06_garde.mdl",
	"models/npc/portal/male_07_garde.mdl",
	"models/npc/portal/male_08_garde.mdl",
	"models/npc/portal/male_09_garde.mdl",
}

CI_MODELS = {
	"models/kerry/player/merriweather/male_01.mdl",
	"models/kerry/player/merriweather/male_02.mdl",
	"models/kerry/player/merriweather/male_03.mdl",
	"models/kerry/player/merriweather/male_04.mdl",
	"models/kerry/player/merriweather/male_05.mdl",
	"models/kerry/player/merriweather/male_06.mdl",
	"models/kerry/player/merriweather/male_07.mdl",
	"models/kerry/player/merriweather/male_08.mdl",
	"models/kerry/player/merriweather/male_09.mdl",
}

BANDITS_MODELS = {
	"models/player/stalker/bandit_brown.mdl",
	"models/player/phoenix.mdl",
}

CHADRYSIACZEK_MODELS = {
	"models/player/pyroplayer/pyro.mdl",
}

RAIDEN_MODELS = {
	"models/Ninja/raidenmgrplayerm.mdl",
}

SAM_MODELS = {
	"models/Ninja/sam.mdl",
}

SAUL_MODELS = {
	"models/player/saul/saul.mdl"
}

REZNOV_MODELS = {
	"models/player/leatherhoff/viktor_reznov.mdl"
}

PRICE_MODELS = {
	"models/arachnit/callofduty/modern_warfare_remastered/characters/sas/cpt_john_price/cpt_john_price_tactical_player.mdl"
}

SHEPARD_MODELS = {
	"models/shepard.mdl"
}

DUDE_MODELS = {
	"models/player/player_postal_dude.mdl",
	"models/player/postal2_dude.mdl",
}

hook.Add( "SLCRegisterClassGroups", "BaseGroups", function()
	AddClassGroup( "classd", 49, SPAWN_CLASSD )
	AddClassGroup( "sci", 21, SPAWN_SCIENT )
	AddClassGroup( "mtf", 30, SPAWN_MTF )

	AddSupportGroup( "mtf_ntf", 75, SPAWN_SUPPORT_MTF, -1 )
	//AddSupportGroup( "mtf_fire", 25, SPAWN_SUPPORT_MTF )
	AddSupportGroup( "mtf_alpha", 10, SPAWN_SUPPORT_MTF, -1, function()
		SetRoundStat( "mtfalphaspawned", true )
	end, function()
		local round = GetTimer( "SLCRound" )
		if !IsValid( round ) or round:GetRemainingTime() <= round:GetTime() / 2 then
			return !GetRoundStat( "mtfalphaspawned" )
		end

		return false
	end )
	AddSupportGroup( "ci", 25, SPAWN_SUPPORT_CI, -1 )
	AddSupportGroup( "bandits", 5, SPAWN_SUPPORT_BANDITS, -1 )
	AddSupportGroup( "pdudes", 5, SPAWN_SUPPORT_PDUDES, -1 )
end )

hook.Add( "SLCRegisterPlayerClasses", "BaseClasses", function()
	--[[-------------------------------------------------------------------------
	CLASS D
	---------------------------------------------------------------------------]]
	RegisterClass( "classd", "classd", CLASSD_MODELS, {
		team = TEAM_CLASSD,
		weapons = {"hobo_swep_shoe", "climb_swep2"},
		ammo = {},
		chip = "",
		omnitool = false,
		health = 115,
		walk_speed = 100,
		run_speed = 225,
		sanity = 75,
		vest = nil,
		price = 0,
		max = 0,
	} )
	
	RegisterClass( "saul", "classd", SAUL_MODELS, {
		team = TEAM_CLASSD,
		weapons = {"hobo_swep_shoe", "climb_swep2"},
		ammo = {},
		chip = "",
		omnitool = false,
		health = 115,
		walk_speed = 100,
		run_speed = 225,
		sanity = 75,
		vest = nil,
		price = 0,
		max = 1,
	} )
	
	RegisterClass( "jesse", "classd", JESSE_MODELS, {
		team = TEAM_CLASSD,
		weapons = {"hobo_pinkman", "climb_swep2"},
		ammo = {},
		chip = "",
		omnitool = false,
		health = 130,
		walk_speed = 100,
		run_speed = 225,
		sanity = 75,
		vest = nil,
		price = 0,
		max = 1,
	} )

	/*RegisterClass( "test1", "classd", CLASSD_MODELS, {
		team = TEAM_CLASSD,
		weapons = {"hobo_swep_shoe", "climb_swep2"},
		ammo = {},
		chip = "",
		omnitool = false,
		health = 125,
		walk_speed = 100,
		run_speed = 225,
		sanity = 75,
		vest = nil,
		price = 0,
		max = 0,
	} )*/

	RegisterClass( "ciagent", "classd", CLASSD_MODELS, {
		team = TEAM_CI,
		weapons = { "weapon_taser", "hobo_swep_shoe", "climb_swep2" },
		ammo = {},
		chip = "jan",
		omnitool = true,
		health = 150,
		walk_speed = 110,
		run_speed = 250,
		sanity = 100,
		vest = nil,
		price = 0,
		max = 1,
		persona = { team = TEAM_CLASSD, class = "classd" },
	} )
	
	RegisterClass( "scoucik", "classd", ALIEN_MODELS, {
		team = TEAM_CLASSD,
		weapons = { "tf_weapon_scattergun", "climb_swep2" },
		ammo = { tf_weapon_scattergun = 32 },
		chip = "",
		omnitool = false,
		health = 80,
		walk_speed = 150,
		run_speed = 270,
		sanity = 100,
		vest = nil,
		price = 0,
		max = 1,
	} )

	--[[-------------------------------------------------------------------------
	SCI
	---------------------------------------------------------------------------]]
	RegisterClass( "sci", "sci", SCI_MODELS, {
		team = TEAM_SCI,
		weapons = {},
		ammo = {},
		chip = "sci2",
		omnitool = true,
		health = 100,
		walk_speed = 100,
		run_speed = 225,
		sanity = 100,
		vest = nil,
		price = 0,
		max = 0,
	} )
	
	RegisterClass( "heisenberg", "sci", HEISENBERG_MODELS, {
		team = TEAM_SCI,
		weapons = {"hobo_heisenberg", "cw_mr96",},
		ammo = { cw_mr96 = 18 },
		chip = "sci2",
		omnitool = true,
		health = 100,
		walk_speed = 100,
		run_speed = 225,
		sanity = 100,
		vest = nil,
		price = 0,
		max = 1,
	} )

	RegisterClass( "sciassistant", "sci", SCI_MODELS, {
		team = TEAM_SCI,
		weapons = {},
		ammo = {},
		chip = "sci1",
		omnitool = true,
		health = 100,
		walk_speed = 100,
		run_speed = 225,
		sanity = 50,
		vest = nil,
		price = 0,
		max = 0,
	} )

	RegisterClass( "seniorsci", "sci", SCI_MODELS, {
		team = TEAM_SCI,
		weapons = {},
		ammo = {},
		chip = "sci3",
		omnitool = true,
		health = 120,
		walk_speed = 110,
		run_speed = 225,
		sanity = 125,
		vest = nil,
		price = 0,
		max = 1,
	} )

	--[[-------------------------------------------------------------------------
	MTF
	---------------------------------------------------------------------------]]
	RegisterClass( "guard", "mtf", GUARD_MODELS, {
		team = TEAM_MTF,
		weapons = { "item_slc_radio", "item_slc_camera", "cw_mp5" },
		ammo = { cw_mp5 = 180 },
		chip = "guard",
		omnitool = true,
		health = 110,
		walk_speed = 100,
		run_speed = 230,
		sanity = 100,
		vest = "guard",
		price = 0,
		max = 0,
		skin = 4,
	} )

	RegisterClass( "lightguard", "mtf", GUARD_MODELS, {
		team = TEAM_MTF,
		weapons = { "item_slc_radio", "item_slc_flashlight", "item_slc_battery", "cw_p99" },
		ammo = { cw_p99 = 120 },
		chip = "guard",
		omnitool = true,
		health = 100,
		walk_speed = 110,
		run_speed = 250,
		sanity = 100,
		vest = nil,
		price = 0,
		max = 0,
		skin = 4,
	} )

	RegisterClass( "heavyguard", "mtf", GUARD_MODELS, {
		team = TEAM_MTF,
		weapons = { "item_slc_radio", "item_slc_camera", "cw_m3super90" },
		ammo = { cw_m3super90 = 32 },
		chip = "guard",
		omnitool = true,
		health = 140,
		walk_speed = 100,
		run_speed = 230,
		sanity = 100,
		vest = "heavyguard",
		price = 0,
		max = 0,
		skin = 4,
	} )

	RegisterClass( "specguard", "mtf", GUARD_MODELS, {
		team = TEAM_MTF,
		weapons = { "item_slc_radio", "item_slc_nvg", "item_slc_gasmask", "cw_g36c" },
		ammo = { cw_g36c = 180 },
		chip = "guard",
		omnitool = true,
		health = 125,
		walk_speed = 100,
		run_speed = 230,
		sanity = 120,
		vest = "specguard",
		price = 0,
		max = 0,
		skin = 3,
		bodygroups = { nvg = 1 }
	} )

	RegisterClass( "chief", "mtf", GUARD_MODELS, {
		team = TEAM_MTF,
		weapons = { "item_slc_radio", "item_slc_camera", "weapon_taser", "cw_ump45" },
		ammo = { cw_ump45 = 150 },
		chip = "chief",
		omnitool = true,
		health = 115,
		walk_speed = 100,
		run_speed = 230,
		sanity = 100,
		vest = "guard",
		price = 0,
		max = 1,
		skin = 2,
	} )

	RegisterClass( "guardmedic", "mtf", GUARD_MODELS, {
		team = TEAM_MTF,
		weapons = { "item_slc_radio", "item_slc_medkitplus", "weapon_taser", "cw_fiveseven" },
		ammo = { cw_fiveseven = 80 },
		chip = "guard",
		omnitool = true,
		health = 130,
		walk_speed = 120,
		run_speed = 260,
		sanity = 100,
		vest = "guard_medic",
		price = 0,
		max = 2,
		skin = 1,
	} )

	RegisterClass( "tech", "mtf", GUARD_MODELS, {
		team = TEAM_MTF,
		weapons = { "item_slc_radio", "item_slc_camera", "cw_ump45", "item_slc_turret" },
		ammo = { cw_ump45 = 150 },
		chip = "guard",
		omnitool = true,
		health = 100,
		walk_speed = 100,
		run_speed = 230,
		sanity = 100,
		vest = "guard",
		price = 0,
		max = 1,
		skin = 3,
	} )

	RegisterClass( "cispy", "mtf", GUARD_MODELS, {
		team = TEAM_CI,
		weapons = { "item_slc_radio", "item_slc_camera", "cw_mp5" },
		ammo = { cw_mp5 = 180 },
		chip = "guard",
		omnitool = true,
		health = 110,
		walk_speed = 100,
		run_speed = 230,
		sanity = 100,
		vest = "guard",
		price = 0,
		max = 2,
		persona = { team = TEAM_MTF, class = "guard" },
		skin = 4,
	} )
	
	RegisterClass( "chadrysiaczek", "mtf", CHADRYSIACZEK_MODELS, {
		team = TEAM_MTF,
		weapons = { "item_slc_radio", "item_slc_camera", "weapon_ai_flamethrower" },
		ammo = { weapon_ai_flamethrower = 10000 },
		chip = "guard",
		omnitool = true,
		health = 110,
		walk_speed = 100,
		run_speed = 230,
		sanity = 100,
		vest = "fire",
		price = 0,
		max = 1,
		persona = { team = TEAM_MTF, class = "guard" },
		skin = 4,
	} )

	--[[-------------------------------------------------------------------------
	SUPPORT
	---------------------------------------------------------------------------]]
	--NTF
	RegisterSupportClass( "ntf_1", "mtf_ntf", MTF_MODELS, {
		team = TEAM_MTF,
		weapons = { "item_slc_radio", "item_slc_camera", "cw_ump45" },
		ammo = { cw_ump45 = 150 },
		chip = "mtf",
		omnitool = true,
		health = 115,
		walk_speed = 115,
		run_speed = 250,
		sanity = 125,
		vest = "ntf",
		price = 0,
		max = 0,
	} )

	RegisterSupportClass( "price", "mtf_ntf", PRICE_MODELS, {
		team = TEAM_MTF,
		weapons = { "item_slc_radio", "item_slc_camera", { "item_slc_nvg", "item_slc_gasmask" }, "cw_mp7_official" },
		ammo = { cw_mp7_official = 180 },
		chip = "mtf",
		omnitool = true,
		health = 150,
		walk_speed = 115,
		run_speed = 250,
		sanity = 125,
		vest = nil,
		price = 0,
		max = 1,
	} )
	
	RegisterSupportClass( "ntfmedic", "mtf_ntf", MTF_MODELS, {
		team = TEAM_MTF,
		weapons = { "item_slc_radio", "item_slc_medkit", "item_slc_medkitplus", "cw_fiveseven" },
		ammo = { cw_fiveseven = 120 },
		chip = "mtf",
		omnitool = true,
		health = 125,
		walk_speed = 115,
		run_speed = 250,
		sanity = 150,
		vest = "mtf_medic",
		price = 0,
		max = 1,
	} )

	RegisterSupportClass( "shepard", "mtf_ntf", SHEPARD_MODELS, {
		team = TEAM_MTF,
		weapons = { "item_slc_radio", "item_slc_camera", "item_slc_nvg", "cw_scarh" },
		ammo = { cw_scarh = 120 },
		chip = "com",
		omnitool = true,
		health = 160,
		walk_speed = 120,
		run_speed = 255,
		sanity = 150,
		vest = nil,
		price = 0,
		max = 1,
	} )

	RegisterSupportClass( "ntfsniper", "mtf_ntf", MTF_MODELS, {
		team = TEAM_MTF,
		weapons = { "item_slc_radio", "cw_l115" },
		ammo = { cw_l115 = 30 },
		chip = "mtf",
		omnitool = true,
		health = 100,
		walk_speed = 100,
		run_speed = 230,
		sanity = 100,
		vest = "ntf",
		price = 0,
		max = 1,
	} )

	--Alpha-1
	RegisterSupportClass( "alpha1", "mtf_alpha", MTF_MODELS, {
		team = TEAM_MTF,
		weapons = { "item_slc_radio", "item_slc_camera", { "item_slc_nvg", "item_slc_gasmask" }, "cw_scarh" },
		ammo = { cw_scarh = 120 },
		chip = "o5",
		omnitool = true,
		health = 225,
		walk_speed = 125,
		run_speed = 260,
		sanity = 175,
		vest = "alpha1",
		price = 0,
		max = 0,
	} )
	
	RegisterSupportClass( "raiden", "mtf_alpha", RAIDEN_MODELS, {
		team = TEAM_MTF,
		weapons = { "item_slc_radio", "weapon_dmc4rebellion" },
		ammo = {},
		chip = "o5",
		omnitool = true,
		health = 5000,
		walk_speed = 200,
		run_speed = 320,
		sanity = 175,
		vest = nil,
		price = 0,
		max = 1,
	} )
	
	RegisterSupportClass( "sam", "mtf_alpha", SAM_MODELS, {
		team = TEAM_CI,
		weapons = { "item_slc_radio", "weapon_dmc4rebellion" },
		ammo = {},
		chip = "o5",
		omnitool = true,
		health = 5000,
		walk_speed = 200,
		run_speed = 320,
		sanity = 175,
		vest = nil,
		price = 0,
		max = 1,
	} )

	RegisterSupportClass( "alpha1sniper", "mtf_alpha", MTF_MODELS, {
		team = TEAM_MTF,
		weapons = { "item_slc_radio", "item_slc_camera", { "item_slc_nvg", "item_slc_gasmask" }, "cw_m14" },
		ammo = { cw_m14 = 120 },
		chip = "o5",
		omnitool = true,
		health = 175,
		walk_speed = 120,
		run_speed = 255,
		sanity = 175,
		vest = "alpha1",
		price = 0,
		max = 2,
	} )

	--CI
	RegisterSupportClass( "ci", "ci", CI_MODELS, {
		team = TEAM_CI,
		weapons = { "item_slc_radio", "cw_l85a2" },
		ammo = { cw_l85a2 = 240 },
		chip = "hacked3",
		omnitool = true,
		health = 145,
		walk_speed = 110,
		run_speed = 245,
		sanity = 125,
		vest = "ci",
		price = 0,
		max = 0,
	} )

	RegisterSupportClass( "cicom", "ci", CI_MODELS, {
		team = TEAM_CI,
		weapons = { "item_slc_radio", "cw_ak74" },
		ammo = { cw_ak74 = 240 },
		chip = "hacked4",
		omnitool = true,
		health = 180,
		walk_speed = 115,
		run_speed = 250,
		sanity = 125,
		vest = "ci",
		price = 0,
		max = 1,
	} )
	
	RegisterSupportClass( "reznov", "ci", REZNOV_MODELS, {
		team = TEAM_CI,
		weapons = { "climb_swep2", "item_slc_radio", "item_slc_medkit", "juju_ppsh" },
		ammo = { juju_ppsh = 500 },
		chip = "hacked4",
		omnitool = true,
		health = 200,
		walk_speed = 125,
		run_speed = 250,
		sanity = 125,
		vest = nil,
		price = 0,
		max = 1,
	} )
	
	RegisterSupportClass( "bandit", "bandits", BANDITS_MODELS, {
		team = TEAM_BANDITS,
		weapons = { "item_slc_radio", "cw_ak74", "hobo_bandit" },
		ammo = { cw_ak74 = 240 },
		chip = "hacked3",
		omnitool = true,
		health = 180,
		walk_speed = 115,
		run_speed = 250,
		sanity = 125,
		vest = nil,
		price = 0,
		max = 0,
	} )
	
	RegisterSupportClass( "banditasval", "bandits", BANDITS_MODELS, {
		team = TEAM_BANDITS,
		weapons = { "item_slc_radio", "cw_vss", "hobo_bandit" },
		ammo = { cw_vss = 240 },
		chip = "hacked3",
		omnitool = true,
		health = 180,
		walk_speed = 115,
		run_speed = 250,
		sanity = 125,
		vest = nil,
		price = 0,
		max = 1,
	} )
	
	RegisterSupportClass( "postaldude", "pdudes", DUDE_MODELS, {
		team = TEAM_PDUDES,
		weapons = { "item_slc_radio", "cw_ar15" },
		ammo = { cw_ar15 = 240 },
		chip = "hacked3",
		omnitool = true,
		health = 180,
		walk_speed = 115,
		run_speed = 250,
		sanity = 125,
		vest = nil,
		price = 0,
		max = 0,
	} )
	
end )

if CLIENT then
	timer.Simple( 0, function()
		ClassViewerOverride( "guard", { skin = 4 } )
		ClassViewerOverride( "lightguard", { skin = 4 } )
		ClassViewerOverride( "heavyguard", { skin = 4 } )
		ClassViewerOverride( "specguard", { skin = 3, nvg = 1 } )
		ClassViewerOverride( "chief", { skin = 2 } )
		ClassViewerOverride( "guardmedic", { skin = 1 } )
		ClassViewerOverride( "tech", { skin = 3 } )
		ClassViewerOverride( "cispy", { skin = 4 } )
	end )
end