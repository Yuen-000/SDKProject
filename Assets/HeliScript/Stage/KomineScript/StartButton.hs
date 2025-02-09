component StartButton
{
    bool isShow;
    Item mySelf;
    Item title;
    Item startButton;
    Item player;
    Item timerScript;
    Item timerText;

    public StartButton()
    {
        isShow = true;
        mySelf = hsItemGetSelf();
        title = hsItemGet("Title");
        startButton = hsItemGet("StartButtonPlane");
        player = hsItemGet("PlayerSettings");
        timerScript = hsItemGet("TimeSystem");
        timerText = hsItemGet("Timer");
    }

    public void Update()
    {
    }

    public void OnClickNode()
    {
        mySelf.SetShow(false);
        title.SetShow(false);
        startButton.SetShow(false);
        timerText.SetShow(true);
        player.CallComponentMethod("PlayerAutoRun", "setStopFalse", "");
        timerScript.CallComponentMethod("TimeSystemKomine", "StartCountTimer", "");
    }
}
