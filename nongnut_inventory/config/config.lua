Config = {}
Function = {}

Config.Button = {
    Inventory = 'T',
    Hotbar = 'TAB'
}

Config.Delay = {
    ItemUse = 500,
    CloseHotbar = 3000
}

Config.Categories = {
    {
        icon = '../images/ui/menu.svg', name = 'all', items = { 
            ['item_vehiclekey'],
            ['bearxblack_poolcue'],
            ['bearxwhite_poolcue'],
            ['bearxblack_bottle'],
            ['bearxwhite_bottle'],
            ['starter_poolcue'],
            ['candy_poolcue'],
            ['candy_bottle'],
            ['electron_poolcue'],
            ['electron_knife'],
            ['nj_poolcue'],
            ['nj_bottle'],
            ['pipesilver_poolcue'],
            ['pipeblue_poolcue'],
            ['redsyringe_knife'],
            ['greensyringe_knife'],
            ['bearxblack_revolver_agn'],
            ['bearxwhite_revolver_agn'],
            ['valentine_poolcue'],
            ['carbon_poolcue'],
            ['minilove_poolcue'],
            ['minilove_knife'],
            ['winterblack_knife'],
            ['winterwhite_knife'],
            ['winterblack_poolcue'],
            ['winterwhite_poolcue'],
            ['monkeyking_poolcue'],
            ['sweet_bottle'],
            ['sweet_poolcue'],
            ['sheep_bottle'],
            ['sheep_poolcue'],
            ['sheep_revolver'],
            ['sheep_knuckle'],
            ['sheep_machete'],
         }
    },
    {
        icon = '../images/ui/favorite.svg', name = 'favorite'
    },
    {
        icon = '../images/ui/fashion.svg', name = 'fashion', items = { }
    },
    {
        icon = '../images/ui/key.svg', name = 'keys', items = { 
            ['item_vehiclekey'] 
        }
    },
    {
        icon = '../images/ui/clothes.svg', name = 'clothes', items = { 
            ['item_mask'],
            ['item_ears'],
            ['item_glasses'],
            ['item_helmet'],
        }
    },
    {
        icon = '../images/ui/food.svg', name = 'food', items = { 
            ['food_1'],['food_a'],['food_b'],['food_c'],['food_d'],['food_e'],['food_sauce'],
            ['drink_1'],['drink_a'],['drink_b'],['drink_c'],['drink_dust'],
        }
    },
    {
        icon = '../images/ui/weapon.svg', name = 'weapon', items = { 
            ['item_weapon'] 
        }
    },
    {
        icon = '../images/ui/skin.svg', name = 'weaponskin', items = { 
            ['bearxblack_poolcue'],
            ['bearxwhite_poolcue'],
            ['bearxblack_bottle'],
            ['bearxwhite_bottle'],
            ['starter_poolcue'],
            ['candy_poolcue'],
            ['candy_bottle'],
            ['electron_poolcue'],
            ['electron_knife'],
            ['nj_poolcue'],
            ['nj_bottle'],
            ['pipesilver_poolcue'],
            ['pipeblue_poolcue'],
            ['redsyringe_knife'],
            ['greensyringe_knife'],
            ['bearxblack_revolver_agn'],
            ['bearxwhite_revolver_agn'],
            ['valentine_poolcue'],
            ['carbon_poolcue'],
            ['minilove_poolcue'],
            ['minilove_knife'],
            ['winterblack_knife'],
            ['winterwhite_knife'],
            ['winterblack_poolcue'],
            ['winterwhite_poolcue'],
            ['monkeyking_poolcue'],
            ['sweet_bottle'],
            ['sweet_poolcue'],
            ['sheep_bottle'],
            ['sheep_poolcue'],
            ['sheep_revolver'],
            ['sheep_knuckle'],
            ['sheep_machete'],
        }
    }
}

Config.FastSlot = {
    Tab = 2,
    Slot = 7
}

--- GLOBAL VARIABLES ---
itemCount = {} --- USAGE : itemCount[itemName] = count
itemLimit = {} --- USAGE : itemLimit[itemName] = limit
itemLabel = {} --- USAGE : itemLabel[itemName] = label
playerLoadout = {} --- USAGE : playerLoadout[weaponName] = ammo