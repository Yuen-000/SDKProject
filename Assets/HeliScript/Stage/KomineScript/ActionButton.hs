component ActionButton
{
    //�{�^��
    Item mButton;

    //�A�ŃA�N�V��������
    bool isActionTime;

    //�A�ŃA�N�V������������
    int pressCount;

    //Player�N���X
    Player  myPlayer;

    //�{�^���̈ʒu
    Vector3 buttonPos;

    public ActionButton()
    {
        hsSystemOutput("Script:ActionButton\n");
        hsSystemOutput("Date:20240928\n");
        hsSystemOutput("Version:1.0.2\n");
        hsSystemOutput("Update Content:Create\n");

        mButton = hsItemGetSelf();

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
            buttonPos.z -= 5.0f;
            mButton.SetPos(buttonPos);
        }
    }

    public void startActionTime(){
        isActionTime = true;
    }

    public void OnClick(){
        pressCount++;
        hsSystemOutput("Click!");
    }
}
