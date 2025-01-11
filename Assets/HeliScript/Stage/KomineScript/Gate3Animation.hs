component Gate3LeftAnimation
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
    int CLEAR_PRESS_COUNT;

    //連打アクション制限時間（フレーム単位）
    int TIME_LIMIT;

    //円周率
    const float PI = 3.14159265358979;

    //角度
    float angle;

    //ボタンアイテム（property取得用）
    Item myButton;

    //長さ
    float LENGTH;

    //幅
    float WIDTH;

    //X座標補正値
    float POS_X;

    //Y座標補正値
    float POS_Y;

    //Z座標補正値
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
    //このアイテム
    Item myItem;

    //閉まっている最中か
    bool isClosed;

    //連打カウント
    int actionCount;

    //タイマー
    int timer;

    //連打アクションクリアになる回数
    int CLEAR_PRESS_COUNT;

    //連打アクション制限時間（フレーム単位）
    int TIME_LIMIT;

    //円周率
    const float PI = 3.14159265358979;

    //角度
    float angle;

    //ボタンアイテム（property取得用）
    Item myButton;

    //長さ
    float LENGTH;

    //幅
    float WIDTH;

    //X座標補正値
    float POS_X;

    //Y座標補正値
    float POS_Y;

    //Z座標補正値
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