component Gate3LeftAnimation
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

    //����
    float LENGTH;

    //��
    float WIDTH;

    //X���W�␳�l
    float POS_X;

    //Y���W�␳�l
    float POS_Y;

    //Z���W�␳�l
    float POS_Z;

    public Gate3LeftAnimation()
    {
        hsSystemOutput("Script:Gate3LeftAnimation\n");
        hsSystemOutput("Date:20250111\n");
        hsSystemOutput("Version:2.0.0\n");
        hsSystemOutput("Update Content:Separated by left and right\n");

        myButton = hsItemGet("ActionButtonScript");

        CLEAR_PRESS_COUNT = (myButton.GetProperty("CLEAR_PRESS_COUNT")).ToInt();
        TIME_LIMIT = int(myButton.GetProperty("TIME_LIMIT").ToFloat() * 60.0f);

        myItem = hsItemGetSelf;

        LENGTH = myItem.GetProperty("LENGTH").ToFloat();
        WIDTH = myItem.GetProperty("WIDTH").ToFloat();
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

            if(angle >= 0.0f) angle = 0.0f;

            if(actionCount == CLEAR_PRESS_COUNT){
                angle = 0.0f;
            }
        }
    }

    public void reset()
    {
        isClosed = false;
        actionCount = 0;
        timer = 0;
        angle = 0.0f;

        calcPos();
    }

    public void calcPos()
    {
            float woodX = ((-LENGTH / 2) * hsMathSin((angle) * PI / 180)) + ((-WIDTH / 2) * hsMathCos((angle) * PI / 180));
            float woodY = ((LENGTH / 2) * hsMathCos((angle) * PI / 180)) + ((-WIDTH / 2) * hsMathSin((angle) * PI / 180));
            Quaternion woodQuaternion = makeQuaternionZRotation(angle * PI / 180);

            myItem.SetPos(makeVector3(woodX + POS_X, woodY + POS_Y, POS_Z));
            myItem.SetQuaternion(woodQuaternion);
    }
}

component Gate3RightAnimation
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

    //����
    float LENGTH;

    //��
    float WIDTH;

    //X���W�␳�l
    float POS_X;

    //Y���W�␳�l
    float POS_Y;

    //Z���W�␳�l
    float POS_Z;

    public Gate3RightAnimation()
    {
        hsSystemOutput("Script:Gate3RightAnimation\n");
        hsSystemOutput("Date:202501117\n");
        hsSystemOutput("Version:2.0.0\n");
        hsSystemOutput("Update Content:Separated by left and right\n");

        myButton = hsItemGet("ActionButtonScript");

        CLEAR_PRESS_COUNT = (myButton.GetProperty("CLEAR_PRESS_COUNT")).ToInt();
        TIME_LIMIT = int(myButton.GetProperty("TIME_LIMIT").ToFloat() * 60.0f);

        myItem = hsItemGetSelf;

        LENGTH = myItem.GetProperty("LENGTH").ToFloat();
        WIDTH = myItem.GetProperty("WIDTH").ToFloat();
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

            if(angle <= 0.0f) angle = 0.0f;

            if(actionCount == CLEAR_PRESS_COUNT){
                angle = 0.0f;
            }
        }
    }

    public void reset()
    {
        isClosed = false;
        actionCount = 0;
        timer = 0;
        angle = 0.0f;

        calcPos();
    }

    public void calcPos()
    {
            float woodX = ((-LENGTH / 2) * hsMathSin((angle) * PI / 180)) + ((WIDTH / 2) * hsMathCos((angle) * PI / 180));
            float woodY = ((LENGTH / 2) * hsMathCos((angle) * PI / 180)) + ((WIDTH / 2) * hsMathSin((angle) * PI / 180));
            Quaternion woodQuaternion = makeQuaternionZRotation(angle * PI / 180);

            myItem.SetPos(makeVector3(woodX + POS_X, woodY + POS_Y, POS_Z));
            myItem.SetQuaternion(woodQuaternion);
    }
}