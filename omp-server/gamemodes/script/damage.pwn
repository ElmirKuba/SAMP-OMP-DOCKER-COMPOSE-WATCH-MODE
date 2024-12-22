/* Оружие и урон */

stock damage_OnPlayerGiveDamage(playerid, damagedid, Float:amount, WEAPON:weaponid, bodypart)
{
    if(IsShootWeapon(weaponid) || IsSprayWeapon(weaponid))
	{
		switch(amount)
		{
			case 3.63000011444091796875,
				5.940000057220458984375,
				5.610000133514404296875,
				6.270000457763671875,
				6.93000030517578125,
				7.2600002288818359375,
				7.9200000762939453125,
				8.5799999237060546875,
				9.24000072479248046875: amount = 2.6400001049041748046875;
			case 3.30000019073486328125: if(weaponid != WEAPON_SHOTGUN && weaponid != WEAPON_SAWEDOFF) amount = 2.6400001049041748046875;
			case 4.950000286102294921875: if(IsSprayWeapon(weaponid)) amount = 2.6400001049041748046875;
		}
		if(amount == 2.6400001049041748046875) weaponid = 55;
	}

    ProcessDamage(damagedid, playerid, amount, weaponid, bodypart);
    return 1;
}

stock damage_OnPlayerTakeDamage(playerid, issuerid, Float:amount, WEAPON:weaponid, bodypart)
{
	if(Weapons[weaponid][E_WEAPON_TYPE] == WEAPON_TYPE_DAMAGE || weaponid == 37) ProcessDamage(playerid, issuerid, amount, weaponid, bodypart);
	return 1;
}

stock ProcessDamage(playerid, issuerid = INVALID_PLAYER_ID, Float:amount, WEAPON:weaponid, bodypart)
{
    static Float:health;
	if(weaponid == 54) health = TI[playerid][tHP]-amount;
	else if(Weapons[weaponid][E_WEAPON_TYPE] == WEAPON_TYPE_DAMAGE || weaponid == 37)
	{
		health = TI[playerid][tHP]-amount*WeaponDamages[weaponid][bodypart];
	}
    else health = TI[playerid][tHP]-WeaponDamages[weaponid][bodypart];
    if(health < 0.0) health = 0.0;

    return SetPlayerHealthAC(playerid, health);
}

stock damage_OnPlayerUpdate(playerid)
{
	if(TI[playerid][tSpec] || GetTickCount() < tAC_TPTime[playerid]) FallDeathVelo[playerid] = 0.0;
	else
	{
		static Float:z;
		GetPlayerVelocity(playerid, z, z, z);
		if(floatcmp(z, 0.0) == 0 && FallDeathVelo[playerid] < -0.200)
		{
			ProcessDamage(playerid, _, 54, WeaponDamages[54][0] * (floatabs(FallDeathVelo[playerid])-0.200), 3);
		}
		FallDeathVelo[playerid] = z;
	}
	return 1;
}