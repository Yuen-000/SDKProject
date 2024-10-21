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
        hsSystemOutput("Date:20241021\n");
        hsSystemOutput("Version:2.0.0\n");
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

            if(timer >= TIME_LIMIT && pressCount < CLEAR_PRESS_COUNT){
                actionFailed();
            }
        }
    }

    public void OnClickNode()
    {
        if(isActionTime){
            pressCount++;
            hsSystemOutput(string(pressCount) + "\n");

            if(pressCount >= CLEAR_PRESS_COUNT){
                actionClear();
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
