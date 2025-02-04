component MagnetParticle
{
    //���̃A�C�e��
    Item myItem;

    //���̍��W
    Vector3 originalPos;

    //�v���C���[
    Player myPlayer;

    //�v���C���[�̍��W
    Vector3 playerPos;

    //�Ǐ]���邩
    bool isActionTime;

    //Y�␳�l
    float POS_Y;

    //Z�␳�l
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
