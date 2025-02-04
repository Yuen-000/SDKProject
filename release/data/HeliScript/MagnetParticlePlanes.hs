component MagnetParticlePlanes
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

    //��]���x
    float ROTATE_SPEED;

    //��]��������i-1��1�j
    float ROTATE_DIRECTION;

    //���݂̉�]�p�x
    float currentAngle;

    //�����̉�]�p�x
    float INITIAL_ANGLE;

    //Z�̌X��
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
