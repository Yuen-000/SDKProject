component Gate1LeftAnimation
{
    //このアイテム
    Item myItem;

    //閉まっている最中か
    bool isClosed;

    //連打カウント
    int actionCount;

    //タイマー
    int timer;

    //連打アクションクリアになる回数
    const int CLEAR_PRESS_COUNT = 20;

    //連打アクション制限時間（フレーム単位）
    const int TIME_LIMIT = 420;

    //角度
    float angle;

    public Gate1LeftAnimation()
    {
        hsSystemOutput("Script:Gate1LeftAnimation\n");
        hsSystemOutput("Date:20241102\n");
        hsSystemOutput("Version:1.0.1\n");
        hsSystemOutput("Update Content:Change the number of times to be cleared\n");

        myItem = hsItemGetSelf;
        isClosed = false;
        actionCount = 0;
        timer = 0;

        angle = 90.0f;

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
        angle = 90.0f;

        calcPos();
    }

    public void calcPos()
    {
            angle = 0.0f;

            float doorX = (-0.27f + 0.9f) * hsMathCos(angle * 3.14159265358979 / 180) - (0.0f) * hsMathSin(angle * 3.14159265358979 / 180) - 0.9f;
            float doorZ = (0.27f + 0.9f) * hsMathSin(angle * 3.14159265358979 / 180) + (0.0f) * hsMathSin(angle * 3.14159265358979 / 180);
            Quaternion doorQuaternion = makeQuaternionYRotation(angle * 3.14159265358979 / 180);

            myItem.SetPos(makeVector3(doorX + 0.00f,-0.40f,doorZ + 270.95f));
            myItem.SetQuaternion(doorQuaternion);
    }
}

component Gate1RightAnimation
{
    //このアイテム
    Item myItem;

    //閉まっている最中か
    bool isClosed;

    //連打カウント
    int actionCount;

    //タイマー
    int timer;

    //連打アクションクリアになる回数
    const int CLEAR_PRESS_COUNT = 20;

    //連打アクション制限時間（フレーム単位）
    const int TIME_LIMIT = 420;

    //角度
    float angle;

    public Gate1RightAnimation()
    {
        hsSystemOutput("Script:Gate1RightAnimation\n");
        hsSystemOutput("Date:20241102\n");
        hsSystemOutput("Version:1.0.1\n");
        hsSystemOutput("Update Content:Change the number of times to be cleared\n");

        myItem = hsItemGetSelf;
        isClosed = false;
        actionCount = 0;
        timer = 0;

        angle = 90.0f;
    }

    public void Update()
    {
        if(isClosed){
            timer++;
            if(timer >= TIME_LIMIT) reset();

            if(actionCount < CLEAR_PRESS_COUNT){
                angle -= 90.0f / TIME_LIMIT;
            }

            float doorX = 1.25 * hsMathCos(angle * 3.14159265358979 / 180);
            float doorZ = -1.25 * hsMathSin(angle * 3.14159265358979 / 180);
            Quaternion doorQuaternion = makeQuaternionYRotation(-angle * 3.14159265358979 / 180);

            myItem.SetPos(makeVector3(-doorX + 2.50f,2.75f,doorZ + 50.00f));
            myItem.SetQuaternion(doorQuaternion);
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

        float doorX = 1.25 * hsMathCos(angle * 3.14159265358979 / 180);
        float doorZ = -1.25 * hsMathSin(angle * 3.14159265358979 / 180);
        Quaternion doorQuaternion = makeQuaternionYRotation(-angle * 3.14159265358979 / 180);

        myItem.SetPos(makeVector3(-doorX + 2.50f,2.75f,doorZ + 50.00f));
        myItem.SetQuaternion(doorQuaternion);
    }
}
