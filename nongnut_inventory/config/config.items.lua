Config.ItemOrders = {
    ['item_account'] = 1,
    ['card_id'] = 2,
    ['item_standard'] = 3,
    ['item_weapon'] = 4,
    ['item_vehiclekey'] = 5,
    ['item_mask'] = 6,
    ['item_ears'] = 6,
    ['item_glasses'] = 6,
    ['item_helmet'] = 6,
}

Config.ItemActions = {
    use = { -- ไอเทมที่สามารถใช้ได้
        'item_weapon',
        'seed_cherry',
        'water_can',
        'fertilizer_basic',
        'tamagotchi',
        'fixkit',
        'random_color',
        'car_polmav',
        'speaker_a',
        'wing',
        'condom_plus',
        'pub_bean',
        'pub_beer',

         -- E Sport --
        'bag_body',
        'aed_agn',
        'aed',
        'bandage',
        'armor_agn',
        'armor',
        'painkiller_agn',
        'painkiller',
        'painkiller_citizen',
        'painkiller_pack',
        'box_painkiller_citizen',
        'aed_pack',
        'painkiller_untrade_pack',
        'aed_untrade_pack',
        'armor_untrade_pack',
        'armor_pack',
        'cutoff',
        'plant_lock',
        'hat_open',

        'box_car_part_a',
        'box_car_part_b',
        'box_newplayer',
        'box_key_3d',
        'box_fashion_starterpack',
        'box_promote_plus',
        'box_booster_ss1',
        -- WEAPON --
        'box_poolcue_ex_1d',
        'box_poolcue_elite',
        'poolcue_agn_1d',

        -- valentine --
        'tk_valentine',
        -- BOX WEAPON SKIN --
        'box_pluspig_poolcue_skin','box_starter_poolcue_skin',
        'twitter_vip','twitter_booter','twitter_valentine',
        'box_candy_bottle_skin','box_candy_poolcue_skin',
        'box_electron_poolcue_skin','box_electron_knife_skin',
        'nj_poolcue_box','nj_bottle_box','box_nj_skin',
        'box_pipeblue_poolcue','box_pipesilver_poolcue',
        'box_monkeyking_poolcue_skin',
        'box_sweet_poolcue_skin','box_sweet_bottle_skin',
        'box_sheep_bottle_skin','box_sheep_poolcue_skin','box_sheep_revolver_skin','box_sheep_knuckle_skin','box_sheep_machete_skin','box_sheep_skin',

        'box_bearxblack_poolcue_skin','box_bearxblack_bottle_skin','box_bearxwhite_poolcue_skin','box_bearxwhite_bottle_skin',
        'box_bearxwhite_knife','box_bearxblack_knife','box_bearxwhite_poolcue','box_bearxblack_poolcue','box_pipe_poolcue',
        'box_redsyringe_knife_skin','box_greensyringe_knife_skin',
        'box_carbon_poolcue_skin',

        'bearxblack_revolver_agn','box_bearxwhite_revolver_skin_agn',
        'box_valentine_poolcue_skin',
        'box_minilove_poolcue_skin','box_minilove_knife_skin',
        'box_winterblack_knife_skin','box_winterwhite_knife_skin','box_winterblack_poolcue_skin','box_winterwhite_poolcue_skin','winterblack_pack','winterwhite_pack',

        -- FOOD --
        'gacha_food','gacha_drink','food_a','food_b','food_c','food_d','food_e','drink_a','drink_b','drink_c','mre',
        'f_meat_pack','f_milk_pack','f_mixed_berries_pack','f_papaya_pack','f_salad_pack','f_wheat_pack','food_1','drink_1',
        'f_glowing',

        -- GACHA --
        'gacha_support','box_welfare_fam','box_welfare_gang','box_welfare_lady','gacha_promote','gacha_event',
        'gacha_bonus','gacha_fashion_sheep','box_fashion_sheep',
        
        'gacha_valentine',
        'gacha_valentine_pack_c',
        'gacha_valentine_pack_b',
        'gacha_valentine_pack_a',
        'gacha_valentine_main',
        'gacha_valentine_cupid',
        'gacha_valentine_money',
        'gacha_valentine_blackjob',
        'gacha_valentine_food',
        'gacha_valentine_job',


        'box_nitro_pack',
        'box_nj_poolcue_pack',
        'box_nj_knife_pack',
        'box_pipeblue_poolcue_pack',
        'box_pipesilver_poolcue_pack',

        'box_fashion_duckky','box_fashion_bunny',

        -- CAR --
        'car_sugoi','car_shabushorttruck','car_i8mlb','car_hoverboard','car_dubsta3','car_brioso3','car_sp_elegy','car_escooter',
        'car_shabuminigt3','car_at_evo9ov','car_hoverboard','car_cloud',
        'car_shabu964lovecar','car_shabulovebike','car_shabucupidcar',
        'car_sup_turismogt','car_pgt322',

        -- FASHION --
        'bbg_ui69_1','bbg_ui69_2','bbg_ui69_3','bbg_ui69_4','bbg_ui69_5','bbg_ui69_6','bbg_ui70_1','bbg_ui70_2','bbg_ui70_3','bbg_ui70_4',
        'bbg_baby3_secret_1','bbg_baby3_secret_2','bbg_baby3_secret_3','bbg_baby3_secret_4_left','bbg_baby3_secret_4_right',
        'kw_bunnynarak_head','kw_bunnynarak_arm','kw_bunnynarak_leg','kw_bunnynarak_bag','kw_bunnynarak_cheek',
        'kw_frontnaka_a','kw_frontnaka_b','kw_frontnaka_c','kw_frontnaka_d','kw_frontnaka_e','kw_frontnaka_f','kw_frontnaka_g','kw_frontnaka_h','kw_frontnaka_i','kw_frontnaka_j','kw_fronteng_a','kw_fronteng_b',
        'kw_fronteng_c','kw_fronteng_d','kw_fronteng_e','kw_fronteng_f','kw_fronteng_g','kw_fronteng_h','kw_fronteng_i','kw_fronteng_j','kw_forntcute_a','kw_forntcute_b','kw_forntcute_c',
        'kw_forntcute_d','kw_forntcute_e','kw_forntcute_f','kw_forntcute_g','kw_forntcute_h','kw_forntcute_i','kw_forntcute_j',
        'kw_front_agency_a','kw_front_agency_b','kw_front_agency_d','kw_front_agency_e','kw_front_agency_g','kw_front_agency_h','kw_front_agency_j','kw_front_agencytwo_g','kw_front_agencytwo_j','kw_thaiwordone_h',
        'bbg_ui76_1','bbg_ui76_2','bbg_ui76_3','bbg_ui76_4','bbg_ui76_5','bbg_ui76_6',
        'ohmmiwars_kuromi_cat','ohmmiwars_kuromi_maid','ohmmiwars_kuromi_student','ohmmiwars_kuromi_witch',
        '777_sailor01','777_sailor02','777_sailor03',
        'zindearcat_sho_r_gray','zindearcat_sho_r_brown','zindearcat_sho_r_black','zindearcat_sho_l_gray','zindearcat_sho_l_brown','zindearcat_sho_l_black','zindearcat_run_gray',
        'zindearcat_run_brown','zindearcat_run_black','zindearcat_mou_gray','zindearcat_mou_brown','zindearcat_mou_black','zindearcat_head_gray','zindearcat_head_brown','zindearcat_head_black',
        'zindearcat_arm_gray','zindearcat_arm_brown','zindearcat_arm_black','zindearcat_cloud_gray','zindearcat_cloud_brown','zindearcat_cloud_black','zindearcat_wing_gray','zindearcat_wing_brown','zindearcat_wing_black',
        'plus_tag_police1','plus_tag_police2','plus_tag_police3','plus_tag_police4','plus_tag_police5','plus_tag_police6','plus_tag_medic1','plus_tag_medic2','plus_tag_medic3','plus_tag_medic4','plus_tag_medic5',
        'armband_council_a','armband_council_b','armband_council_c','armband_story','armband_protect','armband_police','armband_medic',
        'plus_tag_council2','plus_tag_council3','plus_tag_council4','plus_tag_council5',
        'pikaboo_chubbymeowmeow_orange','pikaboo_chubbymeowmeow_grey','pikaboo_chubbymeowmeow_calico',
        'pikaboo_diamond_ring_blue','pikaboo_diamond_ring_pink','pikaboo_diamond_ring_red','pikaboo_ring_of_love_blue','pikaboo_ring_of_love_red','pikaboo_ring_of_love_pink','pikaboo_tiny_bunny_mimi','pikaboo_tiny_bunny_momo',
        'pikaboo_tiny_bunny_mumu','pikaboo_unicorn_luma','pikaboo_unicorn_rainbow','pikaboo_unicorn_nova','pikaboo_unicorn_star','pikaboo_unicorn_donie','pikaboo_unicorn_stella','pikaboo_unicorn_twinkle_ring',
        'Pigcute',
        'armband_01_smd','armband_02_smd','armband_03_smd','armband_04_smd',
        'sharkz_rabbit_suit_01','sharkz_rabbit_suit_02','sharkz_rabbit_suit_03','sharkz_rabbit_suit_04','sharkz_rabbit_suit_05','sharkz_rabbit_suit_06',
        'cutecat1','cutecat2','cutecat3','cutecat4',
        'luluplayful1','luluplayful2','luluplayful3','luluplayful4','luluplayful5',
        'galaxyteddy1','galaxyteddy2','galaxyteddy3','galaxyteddy4','galaxyteddy5','galaxyteddy6',
        'ax_babyminnie','ax_mickeyballoon','ax_daisysweet','ax_littlestar','ax_popcornduckling','ax_sleepychipmunk',
        'meow_girlzomebi_halloween2023','meow_bat01_halloween2023',
        'bbg_ui86_1','bbg_ui86_2','bbg_ui86_3','bbg_ui86_4',
        'hz_dmsptravel1','hz_dmsptravel2','hz_dmsptravel3','hz_dmsptravel4',
        'hz_dmsptravel5','hz_dmsptravel6','plus_bunny1','plus_bunny2',
        'plus_bunny3','plus_bunny4','plus_bunny5','plus_bunny6','plus_bunny7',
        'coolkids_dogsnowie','coolkids_dogcute','coolkids_dogbaby','coolkids_dogbox','coolkids_dogscooter',
        'cuddlefriend1','cuddlefriend2','cuddlefriend3','cuddlefriend4','cuddlefriend5','cuddlefriend6',
        'bbg_ui87_1','bbg_ui87_2','bbg_ui87_3','bbg_ui87_4','bbg_ui90_1','bbg_ui90_2','bbg_ui90_3','bbg_ui90_4','bbg_ui90_5','bbg_ui90_6',
        'bbg_ui91_1','bbg_ui91_2','bbg_ui91_3','bbg_ui91_4',
        'plus_bag1','plus_bag2','plus_bag3','plus_bag4',
        'plus_dogbag1','plus_dogbag2','plus_flowerheadwear','plus_moodeng',
        'sharkz_white_wolf_02','sharkz_white_wolf_03','sharkz_white_wolf_01','sharkz_white_wolf_04','sharkz_white_wolf_05',
        'kittyhand','kittyhat','kittyshoel','kittyshoer','kittybag',
        'kaiwhan_chinamon_bag','kaiwhan_chinamon_head','kaiwhan_chinamon_mouth','kaiwhan_chinamon_righthand','kaiwhan_chinamon_shoes_left','kaiwhan_chinamon_shoes_right','kaiwhan_chinamon_lefthand',
        'ws_fashion_anim_sl_water','ws_fashion_anim_sl_fire',
        'sharkz_fashon_8bit_4','sharkz_fashon_8bit_5','sharkz_fashon_8bit_6','sharkz_fashon_8bit_1','sharkz_fashon_8bit_3','sharkz_fashon_8bit_2',
        'plus_ducky_bag','plus_ducky_headwear',
        'coolkids_bbt_bear','coolkids_bbt_elephant','coolkids_bbt_fox','coolkids_bbt_goat','coolkids_bbt_rabbit','coolkids_bbt_panda','coolkids_bbt_pig','MagicCircle_BabyThree',
        'nd_littleboo_three','nd_littleboo_left','nd_littleboo_right','nd_littleboo_pump','nd_littleboo_hallow',
        'sharkz_fashion_sheep_01','sharkz_fashion_sheep_02','sharkz_fashion_sheep_03','sharkz_fashion_sheep_04','sharkz_fashion_sheep_05','sharkz_fashion_sheep_07',
        'sharkz_fashion_greendragon_01','sharkz_fashion_greendragon_02','sharkz_fashion_greendragon_03','sharkz_fashion_greendragon_04','sharkz_fashion_greendragon_05','sharkz_fashion_greendragon_06',
        'ghostreven','ghosthlw',
        'uneed_prop_konmek1','uneed_prop_konmek2','uneed_prop_meowpumpkin','uneed_prop_ghostpumpkin','uneed_prop_catcutehalloween','uneed_prop_cookiehalloween',
        'mmt_hw2023pumpkinweed_a','mmt_hw2023pumpkinweed_b','mmt_hw2023pumpkinweed_c','mmt_hw2023pumpkinweed_d','mmt_hw2023pumpkinweed_e','mmt_hw2023pumpkinweed_f',
        '012bunnydonuts','012bunnyicream','012bunnymelon','012bunnyzushi','012dango', '012wingbutt', '012wingcyber',
        'dds_mxsk_1','dds_mxsk_2','dds_mxsk_3','dds_mxsk_4','dds_mxsk_5','dds_mxsk_6','dds_mxsk_7','dds_mxsk_8','dds_mxsk_9','dds_mxsk_10','dds_mxsk_11','dds_mxsk_12','dds_mxsk_13',
        'reaw_s2_1','reaw_s2_2','reaw_s2_3','reaw_s2_4','reaw_s2_5','reawx_frog','reawx_lizard','reawx_old_school','reawx_sleep','reawx_squirrel',
        'gudetama1','gudetama2','gudetama3','gudetama4','gudetama5','gudetama6','gudetama7','gudetama8','gudetama9','gudetama10',
        'sharkz_fashion_white_tiger_01','sharkz_fashion_white_tiger_02','sharkz_fashion_white_tiger_03','sharkz_fashion_white_tiger_04','sharkz_fashion_white_tiger_05',
        'nks_barebears1','nks_barebears2','nks_barebears3',
        'scepter1','scepter2','scepter3','scepter4',
        'minivecherry_byzindear1','minivecherry_byzindear2','minivecherry_byzindear3','minivecherry_byzindear4',
        'pigcute_zyndear',
        'bbg_qoqocute1','bbg_qoqocute2','bbg_qoqocute3','bbg_qoqocute4','bbg_qoqocute5',
        'ponybag','ponyblue','ponyflower','ponyhand','ponypink','ponypurple','ponyshoes_blue','ponyshoes_pink',
        -- JOB --
        'm_copper_box','m_gold_box','m_steel_box','m_diamond_box', 'fishingrod','rod_reel','ponyyellow',

        -- BLACK JOB --
        'cement_pack',

        -- VIP --
        'box_vip_1d','box_vip_7d','box_vip_15d','vip_draugur_sp_1d','vip_draugur_sp_7d','vip_draugur_sp_15d','box_booter_farm_1d','box_booter_farm_3d','box_booter_farm_7d','box_booter_miner_1d','box_booter_miner_3d','box_booter_miner_7d',
        'box_booter_fishing_1d','box_booter_fishing_3d','box_booter_fishing_7d','booter_farm_used','booter_miner_used','booter_fishing_used','gacha_vip','box_vip_7d_pack','box_vip_15d_pack',
        'box_booter_farm_1d_pack','box_booter_farm_3d_pack','box_booter_farm_7d_pack','box_booter_farm_1d_untrade','box_booter_fishing_1d_untrade','box_booter_miner_1d_untrade',
        'box_booter_fishing_1d_pack','box_booter_fishing_3d_pack','box_booter_fishing_7d_pack',
        'box_booter_miner_1d_pack','box_booter_miner_3d_pack','box_booter_miner_7d_pack'
    },
    give = { -- ไอเทมที่สามารถให้ผู้อื่นได้
        'money',
        'black_money',
        -- E Sport --
        'aed_agn',
        'aed',
        'bandage',
        'armor_agn',
        'armor',
        'painkiller_agn',
        'painkiller',
        'painkiller_citizen',
        'random_color',
        'tamagotchi',
        'painkiller_untrade_pack',
        'box_painkiller_citizen',
        'aed_untrade_pack',
        'armor_untrade_pack',
        'car_polmav',
        'vault_police',
        'hat_open',
        'bag_body',
        'fixkit',

        'condom_plus',
        'pub_card',
        'pub_bean',
        'pub_beer',

        'gacha_vip',
        'gacha_promote',
        'gacha_event',
        'tk_event',
        'gang_create',
        'gang_join',
        'gang_leave',
        'take2',
        'coin_tamagotchi',
        'common_feed',
        'rare_feed',
        'legend_feed',
        'gang_tag_a',
        'gang_tag_b',
        
        'painkiller_pack',
        'aed_pack',
        'armor_pack',
        'upgrade_box_lv1',
        'upgrade_box_lv2',
        'upgrade_box_lv3',
        'upgrade_s',
        'core_a',
        'core_b',
        'core_c',
        'energy_a',
        'energy_b',
        'energy_c',
        'emp_smoke',
        'emp_anticar',

        'f_lobster','f_squid','f_tuna','f_crab',

        -- BOX WEAPON SKIN --
        'box_pluspig_poolcue_skin','box_candy_bottle_skin','box_candy_poolcue_skin',

        'bearxblack_poolcue','bearxwhite_poolcue','bearxblack_bottle','bearxwhite_bottle','starter_poolcue',
        'nj_poolcue','nj_bottle',
        'pipeblue_poolcue','pipesilver_poolcue',
        'redsyringe_knife','greensyringe_knife',
        'carbon_poolcue',
        'minilove_poolcue','minilove_knife',
        'winterblack_knife','winterwhite_knife','winterblack_poolcue','winterwhite_poolcue',
        'monkeyking_poolcue',
        'sheep_bottle','sheep_poolcue','sheep_knuckle','sheep_machete',

        -- COIN --
        'coin_delivery','coin_afk','coin_fashion_bunny','coin_event_poolcue','nitro_power',
        'coin_cupid',

        -- FOOD --
        'food_a','food_b','food_c','food_d','food_e','drink_a','drink_b','drink_c','food_sauce','drink_dust','mre',
        'f_meat_pack','f_milk_pack','f_mixed_berries_pack','f_papaya_pack','f_salad_pack','f_wheat_pack','food_1','drink_1',

        -- CAR --
        'car_sugoi','car_shabushorttruck','car_i8mlb','car_hoverboard','car_sp_elegy','car_escooter',
        'box_car_part_a','part_job_a','part_job_b','part_job_c','part_job_d','part_job_e',
        'box_car_part_b','part_job_s2_a','part_job_s2_b','part_job_s2_c','part_job_s2_d','part_job_s2_e',

        -- JOB --
        'm_copper_box','m_gold_box','m_steel_box','m_diamond_box','n_turtle','turtle_heart','turtle_a','turtle_feed','fishingrod','rod_reel','bait',
        'fertilizer_basic','f_glowing','seed_glowing','shovel_glowing',
        'f_wheat','f_meat','f_milk','f_mixed_berries','f_papaya','f_salad',

        -- VIP --
        'box_booter_farm_1d','box_booter_farm_3d','box_booter_farm_7d','box_booter_miner_1d','box_booter_miner_3d','box_booter_miner_7d',
        'box_booter_fishing_1d','box_booter_fishing_3d','box_booter_fishing_7d',
        'box_booter_farm_1d_pack','box_booter_farm_3d_pack','box_booter_farm_7d_pack',
        'box_booter_fishing_1d_pack','box_booter_fishing_3d_pack','box_booter_fishing_7d_pack',
        'box_booter_miner_1d_pack','box_booter_miner_3d_pack','box_booter_miner_7d_pack',

        -- BLACK JOB --
        'cement',
        'cement_pack',
        'board_a',
        "board_broke_a",
        "board_broke_b",
        "board_broke_c",
        "power_stick",
        'lockpick',
        'cutoff',

        -- JOB --
        'm_copper','m_gold','m_steel','m_diamond','m_diamond_fg','m_auralium_fg','m_eternium_fg','m_vibranium_fg','m_kryptonite_fg','m_auralium','m_eternium','m_vibranium','m_kryptonite',
        'tama_feed','egg_a','egg_b','egg_c',
        'turtle_shell_dust','m_hardened','m_resin','m_fiber','m_polymer',

        -- ONLY GANG --
        'painkiller_untrade','aed_untrade','armor_untrade',
        'car_sugoi','tk_weapon_ex','trade_weapon_elite',

        -- FASHION --
        'bbg_ui69_1','bbg_ui69_2','bbg_ui69_3','bbg_ui69_4','bbg_ui69_5','bbg_ui69_6','bbg_ui70_1','bbg_ui70_2','bbg_ui70_3','bbg_ui70_4',
        'bbg_baby3_secret_1','bbg_baby3_secret_2','bbg_baby3_secret_3','bbg_baby3_secret_4_left','bbg_baby3_secret_4_right',
        'kw_bunnynarak_head','kw_bunnynarak_arm','kw_bunnynarak_leg','kw_bunnynarak_bag','kw_bunnynarak_cheek',
        'kw_frontnaka_a','kw_frontnaka_b','kw_frontnaka_c','kw_frontnaka_d','kw_frontnaka_e','kw_frontnaka_f','kw_frontnaka_g','kw_frontnaka_h','kw_frontnaka_i','kw_frontnaka_j','kw_fronteng_a','kw_fronteng_b',
        'kw_fronteng_c','kw_fronteng_d','kw_fronteng_e','kw_fronteng_f','kw_fronteng_g','kw_fronteng_h','kw_fronteng_i','kw_fronteng_j','kw_forntcute_a','kw_forntcute_b','kw_forntcute_c',
        'kw_forntcute_d','kw_forntcute_e','kw_forntcute_f','kw_forntcute_g','kw_forntcute_h','kw_forntcute_i','kw_forntcute_j',
        'kw_front_agency_a','kw_front_agency_b','kw_front_agency_d','kw_front_agency_e','kw_front_agency_g','kw_front_agency_h','kw_front_agency_j','kw_front_agencytwo_g','kw_front_agencytwo_j','kw_thaiwordone_h',
        'bbg_ui76_1','bbg_ui76_2','bbg_ui76_3','bbg_ui76_4','bbg_ui76_5','bbg_ui76_6',
        'ohmmiwars_kuromi_cat','ohmmiwars_kuromi_maid','ohmmiwars_kuromi_student','ohmmiwars_kuromi_witch',
        '777_sailor01','777_sailor02','777_sailor03',
        'zindearcat_sho_r_gray','zindearcat_sho_r_brown','zindearcat_sho_r_black','zindearcat_sho_l_gray','zindearcat_sho_l_brown','zindearcat_sho_l_black','zindearcat_run_gray',
        'zindearcat_run_brown','zindearcat_run_black','zindearcat_mou_gray','zindearcat_mou_brown','zindearcat_mou_black','zindearcat_head_gray','zindearcat_head_brown','zindearcat_head_black',
        'zindearcat_arm_gray','zindearcat_arm_brown','zindearcat_arm_black','zindearcat_cloud_gray','zindearcat_cloud_brown','zindearcat_cloud_black','zindearcat_wing_gray','zindearcat_wing_brown','zindearcat_wing_black',
        'plus_tag_police1','plus_tag_police2','plus_tag_police3','plus_tag_police4','plus_tag_police5','plus_tag_police6','plus_tag_medic1','plus_tag_medic2','plus_tag_medic3','plus_tag_medic4','plus_tag_medic5',
        'armband_council_a','armband_council_b','armband_council_c','armband_story','armband_protect','armband_police','armband_medic',
        'plus_tag_council2','plus_tag_council3','plus_tag_council4','plus_tag_council5',
        'pikaboo_chubbymeowmeow_orange','pikaboo_chubbymeowmeow_grey','pikaboo_chubbymeowmeow_calico',
        'pikaboo_diamond_ring_blue','pikaboo_diamond_ring_pink','pikaboo_diamond_ring_red','pikaboo_ring_of_love_blue','pikaboo_ring_of_love_red','pikaboo_ring_of_love_pink','pikaboo_tiny_bunny_mimi','pikaboo_tiny_bunny_momo',
        'pikaboo_tiny_bunny_mumu','pikaboo_unicorn_luma','pikaboo_unicorn_rainbow','pikaboo_unicorn_nova','pikaboo_unicorn_star','pikaboo_unicorn_donie','pikaboo_unicorn_stella','pikaboo_unicorn_twinkle_ring',
        'Pigcute',
        'armband_01_smd','armband_02_smd','armband_03_smd',
        'sharkz_rabbit_suit_01','sharkz_rabbit_suit_02','sharkz_rabbit_suit_03','sharkz_rabbit_suit_04','sharkz_rabbit_suit_05','sharkz_rabbit_suit_06',
        'cutecat1','cutecat2','cutecat3','cutecat4',
        'luluplayful1','luluplayful2','luluplayful3','luluplayful4','luluplayful5',
        'galaxyteddy1','galaxyteddy2','galaxyteddy3','galaxyteddy4','galaxyteddy5','galaxyteddy6',
        'ax_babyminnie','ax_mickeyballoon','ax_daisysweet','ax_littlestar','ax_popcornduckling','ax_sleepychipmunk',
        'meow_girlzomebi_halloween2023','meow_bat01_halloween2023',
        'bbg_ui86_1','bbg_ui86_2','bbg_ui86_3','bbg_ui86_4',
        'hz_dmsptravel1','hz_dmsptravel2','hz_dmsptravel3','hz_dmsptravel4',
        'hz_dmsptravel5','hz_dmsptravel6','plus_bunny1','plus_bunny2',
        'plus_bunny3','plus_bunny4','plus_bunny5','plus_bunny6','plus_bunny7',
        'coolkids_dogsnowie','coolkids_dogcute','coolkids_dogbaby','coolkids_dogbox','coolkids_dogscooter',
        'cuddlefriend1','cuddlefriend2','cuddlefriend3','cuddlefriend4','cuddlefriend5','cuddlefriend6',
        'bbg_ui87_1','bbg_ui87_2','bbg_ui87_3','bbg_ui87_4','bbg_ui90_1','bbg_ui90_2','bbg_ui90_3','bbg_ui90_4','bbg_ui90_5','bbg_ui90_6',
        'bbg_ui91_1','bbg_ui91_2','bbg_ui91_3','bbg_ui91_4',
        'plus_bag1','plus_bag2','plus_bag3','plus_bag4',
        'plus_dogbag1','plus_dogbag2','plus_flowerheadwear','plus_moodeng',
        'sharkz_white_wolf_02','sharkz_white_wolf_03','sharkz_white_wolf_01','sharkz_white_wolf_04','sharkz_white_wolf_05',
        'kittyhand','kittyhat','kittyshoel','kittyshoer','kittybag',
        'kaiwhan_chinamon_bag','kaiwhan_chinamon_head','kaiwhan_chinamon_mouth','kaiwhan_chinamon_righthand','kaiwhan_chinamon_shoes_left','kaiwhan_chinamon_shoes_right','kaiwhan_chinamon_lefthand',
        'ws_fashion_anim_sl_water','ws_fashion_anim_sl_fire',
        'sharkz_fashon_8bit_4','sharkz_fashon_8bit_5','sharkz_fashon_8bit_6','sharkz_fashon_8bit_1','sharkz_fashon_8bit_3','sharkz_fashon_8bit_2',
        'plus_ducky_bag','plus_ducky_headwear',
        'coolkids_bbt_bear','coolkids_bbt_elephant','coolkids_bbt_fox','coolkids_bbt_goat','coolkids_bbt_rabbit','coolkids_bbt_panda','coolkids_bbt_pig','MagicCircle_BabyThree',
        'nd_littleboo_three','nd_littleboo_left','nd_littleboo_right','nd_littleboo_pump','nd_littleboo_hallow',
        'sharkz_fashion_sheep_01','sharkz_fashion_sheep_02','sharkz_fashion_sheep_03','sharkz_fashion_sheep_04','sharkz_fashion_sheep_05','sharkz_fashion_sheep_07',
        'sharkz_fashion_greendragon_01','sharkz_fashion_greendragon_02','sharkz_fashion_greendragon_03','sharkz_fashion_greendragon_04','sharkz_fashion_greendragon_05','sharkz_fashion_greendragon_06',
        'ghostreven','ghosthlw',
        'uneed_prop_konmek1','uneed_prop_konmek2','uneed_prop_meowpumpkin','uneed_prop_ghostpumpkin','uneed_prop_catcutehalloween','uneed_prop_cookiehalloween',
        'mmt_hw2023pumpkinweed_a','mmt_hw2023pumpkinweed_b','mmt_hw2023pumpkinweed_c','mmt_hw2023pumpkinweed_d','mmt_hw2023pumpkinweed_e','mmt_hw2023pumpkinweed_f',
        '012bunnydonuts','012bunnyicream','012bunnymelon','012bunnyzushi','012dango', '012wingbutt', '012wingcyber',
        'dds_mxsk_1','dds_mxsk_2','dds_mxsk_3','dds_mxsk_4','dds_mxsk_5','dds_mxsk_6','dds_mxsk_7','dds_mxsk_8','dds_mxsk_9','dds_mxsk_10','dds_mxsk_11','dds_mxsk_12','dds_mxsk_13',
        'reaw_s2_1','reaw_s2_2','reaw_s2_3','reaw_s2_4','reaw_s2_5','reawx_frog','reawx_lizard','reawx_old_school','reawx_sleep','reawx_squirrel',
        'gudetama1','gudetama2','gudetama3','gudetama4','gudetama5','gudetama6','gudetama7','gudetama8','gudetama9','gudetama10',
        'sharkz_fashion_white_tiger_01','sharkz_fashion_white_tiger_02','sharkz_fashion_white_tiger_03','sharkz_fashion_white_tiger_04','sharkz_fashion_white_tiger_05',
        -- 'ducky1','ducky2','ducky3','ducky4','ducky5','ducky6','ducky7',
        'minivecherry_byzindear1','minivecherry_byzindear2','minivecherry_byzindear3','minivecherry_byzindear4',
        'bbg_qoqocute1','bbg_qoqocute2','bbg_qoqocute3','bbg_qoqocute4','bbg_qoqocute5',
        'm_copper_box','m_gold_box','m_steel_box','m_diamond_box', 'fishingrod','rod_reel','ponyyellow',
        'ponybag','ponyblue','ponyflower','ponyhand','ponypink','ponypurple','ponyshoes_blue','ponyshoes_pink',
    },
    drop = { -- ไอเทมที่สามารถทิ้งได้
        -- 'item_account',
        'bag_body',
        'black_money',
        'aed_wz',
        'aed_agn',
        'aed',
        'bandage',
        'armor_wz',
        'armor_agn',
        'armor',
        'painkiller_wz',
        'painkiller_agn',
        'painkiller',
        'painkiller_citizen',

        -- FOOD --
        'food_a','food_b','food_c','food_d','food_e','drink_a','drink_b','drink_c','food_sauce','drink_dust','food_1','drink_1',

        -- JOB --
        -- 'm_copper','m_gold','m_steel','m_diamond','m_diamond_fg','m_auralium_fg','m_eternium_fg','m_vibranium_fg','m_kryptonite_fg','m_auralium','m_eternium','m_vibranium','m_kryptonite',
        'tama_feed','egg_a','egg_b','egg_c',
        -- 'm_copper_box','m_gold_box','m_steel_box','m_diamond_box',
        'fertilizer_basic','f_glowing','seed_glowing','shovel_glowing','power_stick',
    },
}

Config.ItemDefaults = {
    ['card_id'] = {
        label = 'บัตรประชาชน',
        use = true,
        give = false,
        drop = false,
        image = 'card_id.png',
    }
}

Config.ItemAddons = {
    ['item_vehiclekey'] = {
        use = false,
        give = true,
        drop = false,
    },
    ['item_mask'] = {
        use = true,
        give = false,
        drop = true,
    },
    ['item_ears'] = {
        use = true,
        give = false,
        drop = true,
    },
    ['item_glasses'] = {
        use = true,
        give = false,
        drop = true,
    },
    ['item_helmet'] = {
        use = true,
        give = false,
        drop = true,
    },
}

Config.ItemHideCount = {
    'WEAPON_METALDETECTOR',
}

Config.ItemNoShow = {
    'pluspig_poolcue',

    'coin_c',
    'coin_g',
    'coin_f',
}

Config.CloseOnUse = {
    type = 'blacklist', -- whitelist ปิดเฉพาะไอเทมที่อยู่ใน list / blacklist ปิดทุกไอเทมยกเว้นไอเทมที่อยู่ใน list
    items = {
        'f_meat_pack','f_milk_pack','f_mixed_berries_pack','f_papaya_pack','f_salad_pack','f_wheat_pack','m_copper_box','m_gold_box','m_steel_box','m_diamond_box',
    }
}