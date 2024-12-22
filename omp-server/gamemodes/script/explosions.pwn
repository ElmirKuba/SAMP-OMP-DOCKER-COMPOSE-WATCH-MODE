stock CreateDynamicExplosion(Float:x, Float:y, Float:z, type, Float:radius, worldid = -1, float:damage = 50.0)
{
    #pragma unused damage
    foreach(new i:Player)
    {
        if(worldid != -1 && TI[i][tWorld] != worldid) continue;
        CreateExplosionForPlayer(i, x, y, z, type, 0.0);
        if(!IsPlayerInRangeOfPoint(i, radius, x, y, z)) continue;
    }
    return 1;
}