component SpeedUpManagement
{
    //���̃A�C�e��
    Item myItem;

    //�R�C���A�C�e��
    Item mySpeedUp;

    //�ő吔
    int SPEEDUPMAX;

    //���Z�b�g�t���O
    bool resetFlag;

    public SpeedUpManagement()
    {
        hsSystemOutput("Script:SpeedUpMagement\n");
        hsSystemOutput("Date:20241228\n");
        hsSystemOutput("Version:1.0.0\n");
        hsSystemOutput("Update Content:Create\n");

        myItem = hsItemGetSelf;

        SPEEDUPMAX = (myItem.GetProperty("SPEEDUPMAX")).ToInt();

        resetFlag = false;
    }

    public void Update()
    {
        if(resetFlag)
        {

            hsSystemOutput("���Z�b�g���ł�\n");
            for(int i = 0; i < SPEEDUPMAX; i++){
                mySpeedUp = hsItemGet("SpeedUp" + string(i));
                mySpeedUp.CallComponentMethod("SpeedUpMain", "reset", "");
            }
            resetFlag = false;
        }
    }

    public void reset()
    {
        resetFlag = true;
    }
}
