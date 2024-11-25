component ActionUI
{
    //UI画像
    Item myActionUI;

    //連打アクション中か
    bool isActionTime;

    //Playerクラス
    Player  myPlayer;

    //UIの位置
    Vector3 UIPos;

    //UIの初期位置
    Vector3 UIInitialPosition;

    //自身
    Item myItemSelf;

    //Y補正値
    float POS_Y;

    //Z補正値
    float POS_Z;

    public ActionUI()
    {
        hsSystemOutput("Script:ActionUI\n");
        hsSystemOutput("Date:20241019\n");
        hsSystemOutput("Version:2.0.2\n");
        hsSystemOutput("Update Content:Remove button functions\n");

        myActionUI = hsItemGet("ActionUIPlane");

        isActionTime = false;

        myPlayer = new Player();
        myPlayer = hsPlayerGet();

        UIInitialPosition = myActionUI.GetPos();

        myItemSelf = hsItemGetSelf();

        POS_Y = myItemSelf.GetProperty("POS_Y").ToFloat();
        POS_Z = myItemSelf.GetProperty("POS_Z").ToFloat();
    }

    public void Update()
    {
        if(isActionTime){
            UIPos = myPlayer.GetPos();
            UIPos.y += POS_Y;
            UIPos.z += POS_Z;
            myActionUI.SetPos(UIPos);
        }
    }

    public void startActionTime(){
        if(!isActionTime){
            isActionTime = true;
            hsSystemOutput("Button starts Action Time!\n");
        }
    }

    public void endActionTime(){
        if(isActionTime){
            isActionTime = false;
            myActionUI.SetPos(UIInitialPosition);
            hsSystemOutput("Button ends Action Time!\n");
        }
    }
}
