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

    //プレイヤーの座標
    Vector3 playerPos;

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

    //矢印上のY座標
    float ARROWU_Y;

    //矢印左右のY座標
    float ARROWLR_Y;

    //矢印左のX座標;
    float ARROWL_X;

    //矢印右のX座標;
    float ARROWR_X;

    public ActionUI()
    {
        hsSystemOutput("Script:ActionUI\n");
        hsSystemOutput("Date:20250120\n");
        hsSystemOutput("Version:3.0.1\n");
        hsSystemOutput("Update Content:Support for New UI\n");

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
        ARROWU_Y = myItemSelf.GetProperty("ARROWU_Y").ToInt();
        ARROWLR_Y = myItemSelf.GetProperty("ARROWLR_Y").ToInt();
        ARROWL_X = myItemSelf.GetProperty("ARROWL_X").ToInt();
        ARROWR_X = myItemSelf.GetProperty("ARROWR_X").ToInt();
    }

    public void Update()
    {
        if(isActionTime)
        {

            if(actionFrame == 0)
            {
                myActionUIArrowU.SetShow(true);
                myActionUIArrowL.SetShow(true);
                myActionUIArrowR.SetShow(true);

                for(int i = 0; i < SIGN_NUMMAX; i++)
                {
                    myActionUISign = hsItemGet("ActionUISign" + string(i));
                    myActionUISign.SetShow(true);
                }
            }

            playerPos = myPlayer.GetPos();

            Vector3 UIPos = new Vector3();

            //Up
            UIPos.x = playerPos.x;
            UIPos.y = playerPos.y + ARROWU_Y;
            UIPos.z = playerPos.z;
            myActionUIArrowU.SetPos(UIPos);


            //Left
            UIPos.x = playerPos.x + ARROWL_X;
            UIPos.y = playerPos.y + ARROWLR_Y;
            UIPos.z = playerPos.z;
            myActionUIArrowL.SetPos(UIPos);

            //Right
            UIPos.x = playerPos.x + ARROWR_X;
            UIPos.y = playerPos.y + ARROWLR_Y;
            UIPos.z = playerPos.z;
            myActionUIArrowR.SetPos(UIPos);


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

            sign.SetPos(pos);
        }
    }

    public void startActionTime(string actionZCoor){
        if(!isActionTime){
            isActionTime = true;
            actionFrame = 0;
            hsSystemOutput("Button starts Action Time!\n");
            actionZ = actionZCoor.ToFloat();
        }
    }

    public void endActionTime(){
        if(isActionTime){
            isActionTime = false;
            actionFrame = 0;

            myActionUIArrowU.SetShow(false);
            myActionUIArrowL.SetShow(false);
            myActionUIArrowR.SetShow(false);
            
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
