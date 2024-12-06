component CoinManagement
{
    //このアイテム
    Item myItem;

    //コインアイテム
    Item myCoin;

    //カウント
    int count;

    //最大枚数
    int COINMAX;

    //リセットフラグ
    bool resetFlag;

    public CoinManagement()
    {
        hsSystemOutput("Script:CoinMagement\n");
        hsSystemOutput("Date:20241202\n");
        hsSystemOutput("Version:2.0.0\n");
        hsSystemOutput("Update Content:Update System\n");

        myItem = hsItemGetSelf;

        count = 0;

        COINMAX = (myItem.GetProperty("COINMAX")).ToInt();

        resetFlag = false;
    }

    public void Update()
    {
        if(resetFlag)
        {
            for(int i = 0; i < COINMAX; i++){
                myCoin = hsItemGet("Coin" + string(i));
                myCoin.CallComponentMethod("CoinMain", "reset", "");
            }
            resetFlag = false;
        }
    }

    public void addCount()
    {
        count++;
        myItem.SetProperty("Count", string(count));
    }

    public void reset()
    {
        count = 0;
        myItem.SetProperty("Count", string(count));

        resetFlag = true;
    }
}
