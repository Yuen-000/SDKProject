component MagnetParticle
{
    //このアイテム
    Item myItem;

    //元の座標
    Vector3 originalPos;

    //プレイヤー
    Player myPlayer;

    //プレイヤーの座標
    Vector3 playerPos;

    //追従するか
    bool isActionTime;

    //Y補正値
    float POS_Y;

    //Z補正値
    float POS_Z;

    public MagnetParticle()
    {
        myItem = hsItemGetSelf();
        originalPos = myItem.GetPos();
        myPlayer = new Player();
        myPlayer = hsPlayerGet();
        isActionTime = false;

        POS_Y = myItem.GetProperty("POS_Y").ToFloat();
        POS_Z = myItem.GetProperty("POS_Z").ToFloat();
    }

    public void Update()
    {
        if(isActionTime)
        {
            playerPos = myPlayer.GetPos();
            playerPos.y += POS_Y;
            playerPos.z += POS_Z;

            myItem.SetPos(playerPos);
        }
    }

    public void setActionTrue()
    {
        isActionTime = true;
        myItem.SetShow(true);
    }

    public void setActionFalse()
    {
        isActionTime = false;
        myItem.SetPos(originalPos);
        myItem.SetShow(false);
    }
}
