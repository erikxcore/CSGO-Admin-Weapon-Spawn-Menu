#include <sdktools>
#pragma semicolon 1
#define PLUGIN_VERSION "1.0.1"
#define MAXINDEX 20

// Last index must be 0 because the menu loops until it finds the first 0
new const String:gstrWeaponName[][][] =
{
    { "M4A4", "M4A4-S",        "AK-47",             "FAMAS",         "Galil AR",   "AUG",           "SG 553",        "SCAR-20",           "G3 SG1",   "SSG 08",   "AWP" ,"0" }, 
    { "P90",          "MP7",               "MP9",           "MAC-10",     "UMP-45",        "PP-Bizon",      "0",                  "0",       "0",        "0",       "0",  "0" }, 
    { "Nova",         "XM1014",            "Sawed-Off",     "MAG-7",      "M249",          "Negev",         "0",                  "0",       "0",        "0",       "0",  "0" }, 
    { "Desert Eagle", "Glock-18",          "P250", "CZ75-A",         "Five-SeveN", "Dual Berettas", "Tec-9",         "P2000",              "USP-S",        "Revolver",       "0",  "0" }, 
    { "Kevlar",       "Kevlar and Helmet", "Decoy Grenade", "Flashbang",  "HE Grenade",    "Smoke Grenade", "Incendiary Grenade", "Molotov", "Zeus x27", "Defuser", "C4", "0" }  
};

new const String:gstrWeaponAlias[][][] =
{
    // M4A1,            AK-47,              FAMAS,             Galil AR,           AUG,                SG 553,                SCAR-20,             G3 SG1,           SSG 08,         AWP             -
    {  "weapon_m4a1","weapon_m4a1_silencer",   "weapon_ak47",      "weapon_famas",    "weapon_galilar",   "weapon_aug",       "weapon_sg556",        "weapon_scar20",     "weapon_g3sg1",   "weapon_ssg08", "weapon_awp"         },
    
    // P90,             MP7,                MP9,               MAC-10,             UMP-45,             PP-Bizon               -                    -                 -               -               -
    {  "weapon_p90",    "weapon_mp7",       "weapon_mp9",      "weapon_mac10",     "weapon_ump45",     "weapon_bizon",        "0",                 "0",              "0",            "0",            "0"           },
    
    // Nova,            XM1014,             Sawed-Off,         MAG-7,              M249,               Negev                  -                    -                 -               -               -
    {  "weapon_nova",   "weapon_xm1014",    "weapon_sawedoff", "weapon_mag7",      "weapon_m249",      "weapon_negev",        "0",                 "0",              "0",            "0",            "0"           },
    
    // Desert Eagle,    Glock-18,           P250,     	CZ75-A,         Five-SeveN,         Dual Berettas,      Tec-9,                 P2000                USP-S,               REVOLVER               -
    {  "weapon_deagle", "weapon_glock",     "weapon_p250", "weapon_cz75a",     "weapon_fiveseven", "weapon_elite",     "weapon_tec9",         "weapon_hkp2000",    "weapon_usp_silencer",              "weapon_revolver",            "0"           },
    
    // Kevlar,          Kevlar and Helmet,  Decoy Grenade,     Flashbang,          HE Grenade,         Smoke Grenade,         Incendiary Grenade,  Molotov,          Zeus x27,       Defusal Kit,    C4
    {  "item_kevlar",   "item_assaultsuit", "weapon_decoy",    "weapon_flashbang", "weapon_hegrenade", "weapon_smokegrenade", "weapon_incgrenade", "weapon_molotov", "weapon_taser", "item_defuser", "weapon_c4" }
};

// Set any of these to false to remove that weapon from the menu 
new const bool:gbWeaponEnabled[][] =
{
    // M4A1,         AK-47,             FAMAS,         Galil AR,   AUG,           SG 553,        SCAR-20,            G3 SG1,  SSG 08,   AWP          -    
    {  true, true,        true,              true,          true,       true,          true,          true,               true,    true,     true },
    
    // P90,          MP7,               MP9,           MAC-10,     UMP-45,        PP-Bizon       -                   -        -         -            -      
    {  true,         true,              true,          true,       true,          true,          false,              false,   false,    false,       false },

    // Nova,         XM1014,            Sawed-Off,     MAG-7,      M249,          Negev          -                   -        -         -            -      
    {  true,         true,              true,          true,       true,          true,          false,              false,   false,    false,       false },
    
    // Desert Eagle, Glock-18,          P250,    CZ75-A      Five-SeveN, Dual Berettas, Tec-9,         P2000               USP-S,               REVOLVER         -            -   
    {  true,         true,              true,     true,     true,       true,          true,          true,   true, true,    false,       false },
    
    // Kevlar,       Kevlar and Helmet, Decoy Grenade, Flashbang,  HE Grenade,    Smoke Grenade, Incendiary Grenade, Molotov, Zeus x27, Defusal Kit, C4
    {  true,         true,              true,          true,       true,          true,          true,               true,    true,     true,        true  }
};

// Set any of these to false to remove that entire section of weapons
new const bool:gbMenuEnabled[] =
{
    true, // Rifle
    true, // SMG
    true, // Heavy
    true, // Pistol
    true  // Gear
};

new const String:gstrMenuTitle[] = "Weapon Menu";

// Last index must be 0 because the menu loops until it finds the first 0
new const String:gstrMenuOptions[][] = 
{
    "Rifle",
    "SMG",
    "Heavy",
    "Pistol",
    "Gear",
    "0"
};

new giClientCurrentType[MAXPLAYERS + 1];

public Plugin:myinfo = 
{
    name = "CSGO Admin Weapon Menu",
    author = "Glefs/erikxcore", //Modified by erikxcore for latest CSGO version, newer weapons, improved handling
    description = "Easy to use and modify weapon menu for server admins",
    version = PLUGIN_VERSION,
    url = "https://forums.alliedmods.net/showthread.php?p=1820521" //Original post deleted
};

public OnPluginStart()
{
    CreateConVar("csgoweaponmenu_version", PLUGIN_VERSION, "Version of CSGO Admin Weapon Menu", FCVAR_PLUGIN|FCVAR_SPONLY|FCVAR_REPLICATED|FCVAR_NOTIFY);
    RegAdminCmd("sm_weaponmenu", MenuMain, ADMFLAG_CUSTOM5);
}
    
public Action:MenuMain(iClient, iArgs)
{
    new Handle:hMenu = CreateMenu(MenuMainHandler);
    
    SetMenuTitle(hMenu, gstrMenuTitle);
    
    for(new iIndex = 0; iIndex < MAXINDEX; iIndex++)
    {
        if(gstrMenuOptions[iIndex][0] == '0')
            break;
        
        if(gbMenuEnabled[iIndex])
            AddMenuItem(hMenu, gstrMenuOptions[iIndex], gstrMenuOptions[iIndex]);
    }
    
    SetMenuExitButton(hMenu, true);
    DisplayMenu(hMenu, iClient, MENU_TIME_FOREVER);
    
    return Plugin_Handled;
}

public MenuMainHandler(Handle:hMenu, MenuAction:mAction, iClient, iItem)
{
    if(mAction == MenuAction_Select)
    {
        new String:strInfo[32];
        new bool:bFound = GetMenuItem(hMenu, iItem, strInfo, sizeof(strInfo));
       
        if(bFound)
        {
            giClientCurrentType[iClient] = iItem;
            MenuWeapon(iClient);
        }
    }
    
    else if(mAction == MenuAction_End)
        CloseHandle(hMenu);
}


MenuWeapon(iClient, iPos = 0)
{
    new Handle:hMenu = CreateMenu(MenuWeaponHandler);
    new String:strTitle[32];
    Format(strTitle, sizeof(strTitle), "%s: %s", gstrMenuTitle, gstrMenuOptions[giClientCurrentType[iClient]]);
    SetMenuTitle(hMenu, strTitle);
    
    for(new iIndex = 0; iIndex < MAXINDEX; iIndex++)
    {
        if(gstrWeaponName[giClientCurrentType[iClient]][iIndex][0] == '0')
            break;
        
        if(gbWeaponEnabled[giClientCurrentType[iClient]][iIndex])
            AddMenuItem(hMenu, gstrWeaponAlias[giClientCurrentType[iClient]][iIndex], gstrWeaponName[giClientCurrentType[iClient]][iIndex]);
    }
    
    SetMenuExitButton(hMenu, true);
    SetMenuExitBackButton(hMenu, true);
    DisplayMenuAtItem(hMenu, iClient, iPos, MENU_TIME_FOREVER);
}

public MenuWeaponHandler(Handle:hMenu, MenuAction:mAction, iClient, iItem)
{
    if(mAction == MenuAction_Select && IsPlayerAlive(iClient))
    {
        new String:strInfo[32];
        new bool:bFound = GetMenuItem(hMenu, iItem, strInfo, sizeof(strInfo));
       
        if(bFound)
        {
            GivePlayerItem(iClient, strInfo);
            MenuWeapon(iClient, GetMenuSelectionPosition());
        }
    }
    
    else if(mAction == MenuAction_Cancel && iItem == MenuCancel_ExitBack)
        MenuMain(iClient, 0);
    
    else if(mAction == MenuAction_End)
        CloseHandle(hMenu);
}
