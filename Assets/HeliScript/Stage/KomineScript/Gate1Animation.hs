component Gate1LeftAnimation
{
    //���̃A�C�e��
    Item myItem;

    //�܂��Ă���Œ���
    bool isClosed;

    //�A�ŃJ�E���g
    int actionCount;

    //�^�C�}�[
    int timer;

    //�A�ŃA�N�V�����N���A�ɂȂ��
    int CLEAR_PRESS_COUNT;

    //�A�ŃA�N�V�����������ԁi�t���[���P�ʁj
    int TIME_LIMIT;

    //�~����
    const float PI = 3.14159265358979;

    //�p�x
    float angle;

    //�{�^���A�C�e���iproperty�擾�p�j
    Item myButton;

    //X���W
    float POS_X;

    //Y���W
    float POS_Y;

    //Z���W
    float POS_Z;

    public Gate1LeftAnimation()
    {
        hsSystemOutput("Script:Gate1LeftAnimation\n");
        hsSystemOutput("Date:20241230\n");
        hsSystemOutput("Version:2.1.0\n");
        hsSystemOutput("Update Content:Rename\n");

        myButton = hsItemGet("ActionButtonScript");

        CLEAR_PRESS_COUNT = (myButton.GetProperty("CLEAR_PRESS_COUNT")).ToInt();
        TIME_LIMIT = int(myButton.GetProperty("TIME_LIMIT").ToFloat() * 60.0f);

        myItem = hsItemGetSelf;

        POS_X = myItem.GetProperty("POS_X").ToFloat();
        POS_Y = myItem.GetProperty("POS_Y").ToFloat();
        POS_Z = myItem.GetProperty("POS_Z").ToFloat();

        reset();
    }

    public void Update()
    {

        if(isClosed){
            timer++;
            if(timer >= TIME_LIMIT) reset();

            if(actionCount < CLEAR_PRESS_COUNT){
                angle -= 90.0f / TIME_LIMIT;
            }

            calcPos();
        }
    }

    public void setClose()
    {
        isClosed = true;
    }

    public void setAction()
    {

        if(actionCount <= CLEAR_PRESS_COUNT){
            actionCount++;
            angle += 90.0f / CLEAR_PRESS_COUNT;

            if(angle >= 90.0f) angle = 90.0f;

            if(actionCount == CLEAR_PRESS_COUNT){
                angle = 90.0f;
            }
        }
    }

    public void reset()
    {
        isClosed = false;
        actionCount = 0;
        timer = 0;
        angle = 90.0f;

        calcPos();
    }

    public void calcPos()
    {

            float doorX = ((-1.8f) * hsMathSin((angle - 180) * PI / 180)) + ((-1.8f) * hsMathSin((angle - 90) * PI / 180)) - 1.8f - 0.27f;
            float doorZ = ((-1.8f) * hsMathCos((angle - 180) * PI / 180)) + ((-1.8f) * hsMathCos((angle - 90) * PI / 180)) - 1.8f;
            Quaternion doorQuaternion = makeQuaternionYRotation(angle * PI / 180);

            myItem.SetPos(makeVector3(doorX + POS_X, POS_Y,doorZ + POS_Z));
            myItem.SetQuaternion(doorQuaternion);
    }
}

component Gate1RightAnimation
{
    //���̃A�C�e��
    Item myItem;

    //�܂��Ă���Œ���
    bool isClosed;

    //�A�ŃJ�E���g
    int actionCount;

    //�^�C�}�[
    int timer;

    //�A�ŃA�N�V�����N���A�ɂȂ��
    int CLEAR_PRESS_COUNT;

    //�A�ŃA�N�V�����������ԁi�t���[���P�ʁj
    int TIME_LIMIT;

    //�~����
    const float PI = PI;

    //�p�x
    float angle;

    //�{�^���A�C�e���iproperty�擾�p�j
    Item myButton;

    //X���W
    float POS_X;

    //Y���W
    float POS_Y;

    //Z���W
    float POS_Z;

    public Gate1RightAnimation()
    {
        hsSystemOutput("Script:Gate1RightAnimation\n");
        hsSystemOutput("Date:20241123\n");
        hsSystemOutput("Version:2.0.0\n");
        hsSystemOutput("Update Content:Completed\n");

        myButton = hsItemGet("ActionButtonScript");

        CLEAR_PRESS_COUNT = (myButton.GetProperty("CLEAR_PRESS_COUNT")).ToInt();
        TIME_LIMIT = int(myButton.GetProperty("TIME_LIMIT").ToFloat() * 60.0f);

        myItem = hsItemGetSelf;

        POS_X = myItem.GetProperty("POS_X").ToFloat();
        POS_Y = myItem.GetProperty("POS_Y").ToFloat();
        POS_Z = myItem.GetProperty("POS_Z").ToFloat();
        
        reset();
    }

    public void Update()
    {

        if(isClosed){
            timer++;
            if(timer >= TIME_LIMIT) reset();

            if(actionCount < CLEAR_PRESS_COUNT){
                angle += 90.0f / TIME_LIMIT;
            }

            calcPos();
        }
    }

    public void setClose()
    {
        isClosed = true;
    }

    public void setAction()
    {

        if(actionCount <= CLEAR_PRESS_COUNT){
            actionCount++;
            angle -= 90.0f / CLEAR_PRESS_COUNT;

            if(angle <= -90.0f) angle = -90.0f;

            if(actionCount == CLEAR_PRESS_COUNT){
                angle = -90.0f;
            }
        }
    }

    public void reset()
    {
        isClosed = false;
        actionCount = 0;
        timer = 0;
        angle = -90.0f;

        calcPos();
    }

    public void calcPos()
    {

            float doorX = ((-1.8f) * hsMathSin((angle - 180) * PI / 180)) + ((1.8f) * hsMathSin((angle - 90) * PI / 180)) + 1.8f - 0.27f;
            float doorZ = ((-1.8f) * hsMathCos((angle - 180) * PI / 180)) + ((1.8f) * hsMathCos((angle - 90) * PI / 180)) - 1.8f;
            Quaternion doorQuaternion = makeQuaternionYRotation(angle * PI / 180);

            myItem.SetPos(makeVector3(doorX + POS_X, POS_Y,doorZ + POS_Z));
            myItem.SetQuaternion(doorQuaternion);
    }
}