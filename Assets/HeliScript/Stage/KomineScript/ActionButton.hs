component ActionButton
{
    //�A�ŃA�N�V��������
    bool isActionTime;

    //�A�ŃA�N�V������������
    int pressCount;

    //�A�ŃA�N�V�����^�C�}�[
    int timer;

    //�A�ŃA�N�V�����N���A�ɂȂ��
    const int CLEAR_PRESS_COUNT = 25;

    //�A�ŃA�N�V�����������ԁi�t���[���P�ʁj
    const int TIME_LIMIT = 60 * 7;

    //���g���C�{�^���p�X�N���v�g
    Item retryItem;

    //�v���C���[�i�Ăяo���p�j
    Item myPlayerComponent;

    public ActionButton()
    {
        hsSystemOutput("Script:ActionButton\n");
        hsSystemOutput("Date:20241028\n");
        hsSystemOutput("Version:3.0.0\n");
        hsSystemOutput("Update Content:Create functions\n");

        isActionTime = false;
        pressCount = 0;
        timer = 0;

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

            int areaNum = areaNumStr.ToInt();

            if(areaNum == 1){
                Item gateL = hsItemGet("Gate1DoorLeft");
                //Item gateR = hsItemGet("Gate1RightAxis");

                gateL.CallComponentMethod("Gate1LeftAnimation", "setAction", "");
                //gateR.CallComponentMethod("Gate1RightAnimation", "setAction", "");
            }
            else if(areaNum == 2){
            }
            else if(areaNum == 3){
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
    }
}
