component ActionButton
{
    //連打アクション中か
    bool isActionTime;

    //連打アクション押した回数
    int pressCount;

    //連打アクションタイマー
    int timer;

    //連打アクションクリアになる回数
    int CLEAR_PRESS_COUNT;

    //連打アクション制限時間（フレーム単位）
    int TIME_LIMIT;

    //リトライボタン用スクリプト
    Item retryItem;

    //プレイヤー（呼び出し用）
    Item myPlayerComponent;

    //自身（property取得用）
    Item myItemSelf;

    //効果音
    Item actionSE;

    public ActionButton()
    {
        hsSystemOutput("Script:ActionButton\n");
        hsSystemOutput("Date:20241102\n");
        hsSystemOutput("Version:3.0.1\n");
        hsSystemOutput("Update Content:Change the number of times to be cleared\n");

        isActionTime = false;
        pressCount = 0;
        timer = 0;

        myItemSelf = hsItemGetSelf();

        CLEAR_PRESS_COUNT = (myItemSelf.GetProperty("CLEAR_PRESS_COUNT")).ToInt();
        TIME_LIMIT = int(myItemSelf.GetProperty("TIME_LIMIT").ToFloat() * 60.0f);

        retryItem = hsItemGet("GameoverScript");

        myPlayerComponent = hsItemGet("PlayerSettings");
    }

    public void Update()
    {
        if(isActionTime){
            timer++;

            if(timer >= TIME_LIMIT){
                if(pressCount < CLEAR_PRESS_COUNT){
                    actionFailed();
                }
                else{
                    actionClear();
                }
            }
        }
    }

    public void OnClickNode(string areaNumStr)
    {

        if(isActionTime){
            pressCount++;
            hsSystemOutput(string(pressCount) + "\n");

            actionSE = hsItemGet("ActionButtonSE" + string(pressCount % 10));

            actionSE.Play();

            int areaNum = areaNumStr.ToInt();

            if(areaNum == 1){
                Item gateL = hsItemGet("Gate1LeftDoor");
                Item gateR = hsItemGet("Gate1RightDoor");

                gateL.CallComponentMethod("Gate1LeftAnimation", "setAction", "");
                gateR.CallComponentMethod("Gate1RightAnimation", "setAction", "");
            }
            else if(areaNum == 2){
                Item gateL = hsItemGet("Gate2LeftDoor");
                Item gateR = hsItemGet("Gate2RightDoor");

                gateL.CallComponentMethod("Gate2LeftAnimation", "setAction", "");
                gateR.CallComponentMethod("Gate2RightAnimation", "setAction", "");
            }
            else if(areaNum == 3){
                Item gateL = hsItemGet("Gate3LeftWall");
                Item gateR = hsItemGet("Gate3RightWall");

                gateL.CallComponentMethod("Gate3LeftAnimation", "setAction", "");
                gateR.CallComponentMethod("Gate3RightAnimation", "setAction", "");
            }
        }
    }

    public void actionClear()
    {
        hsSystemOutput("Action Clear!\n");
        endOfAction();
        myPlayerComponent.CallComponentMethod("ActionTimeManagement", "sendEndOfActionTimeClear", "");
    }

    public void actionFailed()
    {
        hsSystemOutput("Action Failed...\n");
        myPlayerComponent.CallComponentMethod("PlayerAutoRun", "resetCoordinate", "");
        endOfAction();
        myPlayerComponent.CallComponentMethod("ActionTimeManagement", "sendEndOfActionTimeFailed", "");
        retryItem.CallComponentMethod("GameOver", "SetGameOver", "");
    }

    public void endOfAction()
    {
        isActionTime = false;
        pressCount = 0;
        timer = 0;

        myPlayerComponent.CallComponentMethod("ActionTimeManagement", "sendEndOfActionTime", "");
    }

    public void SetActionFlagTrue()
    {
        hsSystemOutput("Now you can press the button\n");
        isActionTime = true;
    }

    public void SetActionFlagFalse()
    {
        isActionTime = false;
        pressCount = 0;
        timer = 0;
    }
}
