component MagnetParticlePlanes
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

    //回転速度
    float ROTATE_SPEED;

    //回転する方向（-1か1）
    float ROTATE_DIRECTION;

    //現在の回転角度
    float currentAngle;

    //初期の回転角度
    float INITIAL_ANGLE;

    //Zの傾き
    float X_INICLINATION;

    public MagnetParticlePlanes()
    {
        myItem = hsItemGetSelf();
        originalPos = myItem.GetPos();
        myPlayer = new Player();
        myPlayer = hsPlayerGet();
        isActionTime = false;

        POS_Y = myItem.GetProperty("POS_Y").ToFloat();
        POS_Z = myItem.GetProperty("POS_Z").ToFloat();
        ROTATE_SPEED = myItem.GetProperty("ROTATE_SPEED").ToFloat();
        ROTATE_DIRECTION = myItem.GetProperty("ROTATE_DIRECTION").ToFloat();
        currentAngle = 0;
        INITIAL_ANGLE = myItem.GetProperty("INITIAL_ANGLE").ToFloat();
        X_INICLINATION = myItem.GetProperty("X_INICLINATION").ToFloat();
    }

    public void Update()
    {
        if(isActionTime)
        {
            playerPos = myPlayer.GetPos();
            playerPos.y += POS_Y;
            playerPos.z += POS_Z;
            
            Quaternion xRotation = makeQuaternionXRotation(X_INICLINATION * PI / 180);
            Quaternion zRotation = makeQuaternionZRotation(currentAngle * PI / 180);
            Quaternion rotation = makeQuaternionMul(xRotation, zRotation);
            //Quaternion rotation = makeQuaternionEuler(X_INICLINATION * PI / 180, 0 ,currentAngle * PI / 180);

            myItem.SetQuaternion(rotation);

            myItem.SetPos(playerPos);

            currentAngle += ROTATE_SPEED * ROTATE_DIRECTION;
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
