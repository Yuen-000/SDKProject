component MagnetManagement
{
    //このアイテム
    Item myItem;

    //コインアイテム
    Item myMagnet;

    //最大数
    int MAGNETMAX;

    //リセットフラグ
    bool resetFlag;

    public MagnetManagement()
    {
        hsSystemOutput("Script:MagnetMagement\n");
        hsSystemOutput("Date:20241230\n");
        hsSystemOutput("Version:1.0.0\n");
        hsSystemOutput("Update Content:Create\n");

        myItem = hsItemGetSelf;

        MAGNETMAX = (myItem.GetProperty("MAGNETMAX")).ToInt();

        resetFlag = false;
    }

    public void Update()
    {
        if(resetFlag)
        {

            hsSystemOutput("リセット中です\n");
            for(int i = 0; i < MAGNETMAX; i++){
                myMagnet = hsItemGet("Magnet" + string(i));
                myMagnet.CallComponentMethod("MagnetMain", "reset", "");
            }
            resetFlag = false;
        }
    }

    public void reset()
    {
        resetFlag = true;
    }
}
