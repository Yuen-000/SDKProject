component SkyDomeAnimation
{
    //���̃A�C�e��
    Item myItem;

    //Player�N���X
    Player  myPlayer;

    //�␳��̍��W
    Vector3 newPos;

    //Y�␳�l
    float POS_Y;

    //��]���x
    float ROTATE_SPEED;

    //���݂̉�]
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
