component ActionButton
{
    //ボタン
    Item myActionButton;

    //連打アクション中か
    bool isActionTime;

    //連打アクション押した回数
    int pressCount;

    //Playerクラス
    Player  myPlayer;

    //ボタンの位置
    Vector3 buttonPos;

    public ActionButton()
    {
        hsSystemOutput("Script:ActionButton\n");
        hsSystemOutput("Date:20240930\n");
        hsSystemOutput("Version:1.0.8\n");
        hsSystemOutput("Update Content:Create\n");

        myActionButton = hsItemGet("ActionButtonPlane");

        isActionTime = false;
        pressCount = 0;

        myPlayer = new Player();
        myPlayer = hsPlayerGet();
    }

    public void Update()
    {
        if(isActionTime){
            buttonPos = myPlayer.GetPos();
            buttonPos.y += 2.0f;
            myActionButton.SetPos(buttonPos);
        }
    }

    public void startActionTime(){
        isActionTime = true;
        hsSystemOutput("Button starts Action Time!\n");
    }

    public void OnClickNode(){
        pressCount++;
        hsSystemOutput("Click!");
    }
}
