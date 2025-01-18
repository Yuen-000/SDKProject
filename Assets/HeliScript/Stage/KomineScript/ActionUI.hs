component ActionUI
{
    //UI画像矢印ue
    Item myActionUIArrowU;

    //UI画像矢印左
    Item myActionUIArrowL;

    //UI画像矢印右
    Item myActionUIArrowR;

    //UI画像看板
    Item myActionUISign;

    //連打アクション中か
    bool isActionTime;

    //Playerクラス
    Player  myPlayer;

    //自身
    Item myItemSelf;

    //連打アクションのフレーム
    int actionFrame;

    //連打アクション開始時のZ座標
    float actionZ;

    //看板が出てくるのにかかる時間
    int SIGN_APPEARTIME;

    //看板の出てくるタイミングのズレ
    int SIGN_OFFSET;

    //看板の出てくるZ座標オフセット
    float SIGN_Z_OFFSET;

    //看板の出てくるZ座標間隔
    float SIGN_Z_INTERVAL;

    //看板のX座標（左）
    float SIGN_LEFT_X;

    //看板のX座標（右）
    float SIGN_RIGHT_X;

    //看板のY座標
    float SIGN_Y;

    //看板が出てくるときに動く距離（左）
    float SIGN_LEFT_MOVELENGTH;

    //看板が出てくるときに動く距離（右）
    float SIGN_RIGHT_MOVELENGTH;

    //看板の枚数
    int SIGN_NUMMAX;

    public ActionUI()
    {
        hsSystemOutput("Script:ActionUI\n");
        hsSystemOutput("Date:20241019\n");
        hsSystemOutput("Version:2.0.2\n");
        hsSystemOutput("Update Content:Remove button functions\n");

        myActionUIArrowU = hsItemGet("ActionUIArrowU");
        myActionUIArrowL = hsItemGet("ActionUIArrowL");
        myActionUIArrowR = hsItemGet("ActionUIArrowR");

        isActionTime = false;

        myPlayer = new Player();
        myPlayer = hsPlayerGet();

        myItemSelf = hsItemGetSelf();

        actionFrame = 0;

        SIGN_APPEARTIME = myItemSelf.GetProperty("SIGN_APPEARTIME").ToInt();
        SIGN_OFFSET = myItemSelf.GetProperty("SIGN_OFFSET").ToInt();
        SIGN_Z_OFFSET = myItemSelf.GetProperty("SIGN_Z_OFFSET").ToFloat();
        SIGN_Z_INTERVAL = myItemSelf.GetProperty("SIGN_Z_INTERVAL").ToFloat();
        SIGN_LEFT_X = myItemSelf.GetProperty("SIGN_LEFT_X").ToFloat();
        SIGN_RIGHT_X = myItemSelf.GetProperty("SIGN_RIGHT_X").ToFloat();
        SIGN_Y = myItemSelf.GetProperty("SIGN_Y").ToFloat();
        SIGN_LEFT_MOVELENGTH = myItemSelf.GetProperty("SIGN_LEFT_MOVELENGTH").ToFloat();
        SIGN_RIGHT_MOVELENGTH = myItemSelf.GetProperty("SIGN_RIGHT_MOVELENGTH").ToFloat();
        SIGN_NUMMAX = myItemSelf.GetProperty("SIGN_NUMMAX").ToInt();
    }

    public void Update()
    {
        if(isActionTime)
        {
            for(int i = 0; i < SIGN_NUMMAX; i++)
            {
                myActionUISign = hsItemGet("ActionUISign" + string(i));
                setSignPos(myActionUISign,i);
            }

            actionFrame++;
        }
    }

    public void setSignPos(Item sign, int num)
    {
        
        if(actionFrame < SIGN_OFFSET * num)
        {
            Vector3 pos = new Vector3();

            if(num % 2 == 0)
            {
                pos.x = -SIGN_LEFT_MOVELENGTH + SIGN_LEFT_X;    
            }
            else
            {
                pos.x = -SIGN_RIGHT_MOVELENGTH + SIGN_RIGHT_X;    
            }

            pos.y = SIGN_Y;

            pos.z = actionZ + float(num / 2) * SIGN_Z_INTERVAL + SIGN_Z_OFFSET;

            sign.SetPos(pos);
        }
        else if(actionFrame < SIGN_OFFSET * num + SIGN_APPEARTIME)
        {
            Vector3 pos = new Vector3();

            if(num % 2 == 0)
            {
                pos.x = -SIGN_LEFT_MOVELENGTH + SIGN_LEFT_X + SIGN_LEFT_MOVELENGTH * (actionFrame - SIGN_OFFSET * num) / SIGN_APPEARTIME;
            }
            else
            {
                pos.x = -SIGN_RIGHT_MOVELENGTH + SIGN_RIGHT_X + SIGN_RIGHT_MOVELENGTH * (actionFrame - SIGN_OFFSET * num) / SIGN_APPEARTIME;
            }

            pos.y = SIGN_Y;

            pos.z = actionZ + float(num / 2) * SIGN_Z_INTERVAL + SIGN_Z_OFFSET;

            sign.SetPos(pos);
        }
        else if(actionFrame == SIGN_OFFSET * num + SIGN_APPEARTIME)
        {
            Vector3 pos = new Vector3();

            if(num % 2 == 0)
            {
                pos.x = SIGN_LEFT_X;
            }
            else
            {
                pos.x = SIGN_RIGHT_X;
            }

            pos.y = SIGN_Y;

            pos.z = actionZ + float(num / 2) * SIGN_Z_INTERVAL + SIGN_Z_OFFSET;

            hsSystemOutput(string(num) + "=" +string(pos.z));

            sign.SetPos(pos);
        }
    }

    public void startActionTime(string actionZCoor){
        if(!isActionTime){
            isActionTime = true;
            actionFrame = 0;
            hsSystemOutput("Button starts Action Time!\n");
            actionZ = actionZCoor.ToFloat();
            hsSystemOutput(actionZCoor +  " & " + string(actionZ)+"\n");
        }
    }

    public void endActionTime(){
        if(isActionTime){
            isActionTime = false;
            actionFrame = 0;
            for(int i = 0; i < SIGN_NUMMAX; i++)
            {
                myActionUISign = hsItemGet("ActionUISign" + string(i));
                myActionUISign.SetShow(false);
                Vector3 pos = new Vector3();
                pos.x = 0;
                pos.y = -1;
                pos.z = -10;
                myActionUISign.SetPos(pos);
            }
            hsSystemOutput("Button ends Action Time!\n");
        }
    }
}
