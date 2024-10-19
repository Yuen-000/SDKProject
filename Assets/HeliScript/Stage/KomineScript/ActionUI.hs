component ActionUI
{
    //UI�摜
    Item myActionUI;

    //�A�ŃA�N�V��������
    bool isActionTime;

    //Player�N���X
    Player  myPlayer;

    //UI�̈ʒu
    Vector3 UIPos;

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
    }

    public void Update()
    {
        if(isActionTime){
            UIPos = myPlayer.GetPos();
            UIPos.y += 3.0f;
            UIPos.z += -2.0f;
            myActionUI.SetPos(UIPos);
        }
    }

    public void startActionTime(){
        if(!isActionTime){
            isActionTime = true;
            hsSystemOutput("Button starts Action Time!\n");
        }
    }
}
