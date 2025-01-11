component SkyDomeAnimation
{
    //このアイテム
    Item myItem;

    //Playerクラス
    Player  myPlayer;

    //補正後の座標
    Vector3 newPos;

    //Y補正値
    float POS_Y;

    //回転速度
    float ROTATE_SPEED;

    //現在の回転
    float rotation;

    public SkyDomeAnimation()
    {
        hsSystemOutput("Script:SkyDomeAnimation\n");
        hsSystemOutput("Date:20250111\n");
        hsSystemOutput("Version:1.0.0\n");
        hsSystemOutput("Update Content:Create\n");

        myItem = hsItemGetSelf;
        
        myPlayer = new Player();
        myPlayer = hsPlayerGet();

        POS_Y = myItem.GetProperty("POS_Y").ToFloat();
        ROTATE_SPEED = myItem.GetProperty("ROTATE_SPEED").ToFloat();

        rotation = 0.0f;
    }

    public void Update()
    {
        newPos = myPlayer.GetPos();
        newPos.x = 0.0f;
        newPos.y = POS_Y;

        myItem.SetPos(newPos);

        rotation += ROTATE_SPEED;

        Quaternion quaternion = makeQuaternionXRotation(rotation * PI / 180);

        myItem.SetQuaternion(quaternion);
    }
}
