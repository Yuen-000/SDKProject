component Gate3Animation
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

    public Gate3Animation()
    {
        hsSystemOutput("Script:Gate3Animation\n");
        hsSystemOutput("Date:20241207\n");
        hsSystemOutput("Version:1.0.0\n");
        hsSystemOutput("Update Content:Create\n");

        myButton = hsItemGet("ActionButtonScript");

        CLEAR_PRESS_COUNT = (myButton.GetProperty("CLEAR_PRESS_COUNT")).ToInt();
        TIME_LIMIT = int(myButton.GetProperty("TIME_LIMIT").ToFloat() * 60.0f);

        myItem = hsItemGetSelf;
        isClosed = false;
        actionCount = 0;
        timer = 0;

        angle = 0.0f;

        calcPos();
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
        angle = 0.0f;

        calcPos();
    }

    public void calcPos()
    {
            float length = 30.0f;
            float width = 4.0f;

            float woodX = ((-length / 2) * hsMathSin((angle) * PI / 180)) + ((-width / 2) * hsMathCos((angle) * PI / 180));
            float woodY = ((length / 2) * hsMathCos((angle) * PI / 180)) + ((-width / 2) * hsMathSin((angle) * PI / 180));
            Quaternion woodQuaternion = makeQuaternionZRotation(angle * PI / 180);

            myItem.SetPos(makeVector3(woodX + -length / 2, woodY, 80.0f));
            myItem.SetQuaternion(woodQuaternion);
    }
}