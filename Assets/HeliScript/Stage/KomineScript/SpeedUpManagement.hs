component SpeedUpManagement
{
    //このアイテム
    Item myItem;

    //コインアイテム
    Item mySpeedUp;

    //最大数
    int SPEEDUPMAX;

    //リセットフラグ
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

            hsSystemOutput("リセット中です\n");
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
