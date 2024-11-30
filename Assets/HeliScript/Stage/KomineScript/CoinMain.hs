component CoinMain
{
    //取られたか
    bool hasCaught;

    //自身のレーン
    int myLane;

    //プレイヤー（呼び出し用）
    Item myPlayerComponent;

    //プレイヤーの座標
    Vector3 playerPos;

    //プレイヤーのレーン
    int playerLane;

    //磁石状態か
    bool isMagnet;

    //自身（property取得用）
    Item myItemSelf;

    //元の座標（リセット用）
    Vector3 originalPos;

    //アニメーション後の座標（通常用）
    Vector3 afterPos;

    public CoinMain()
    {
        hsSystemOutput("Script:CoinMain\n");
        hsSystemOutput("Date:20241130\n");
        hsSystemOutput("Version:1.0.0\n");
        hsSystemOutput("Update Content:Create\n");

        hasCaught = false;

        myPlayerComponent = hsItemGet("PlayerSettings");
        playerPos = myPlayerComponent.GetPos();
        playerLane = 0;
        isMagnet = false;

        myItemSelf = hsItemGetSelf();
        originalPos = myItemSelf.GetPos();

        afterPos = originalPos;
        afterPos.y -= 5.0f;
    }

    public void Update()
    {
        if(hasCaught == false)
        {
            if(measureDistance())
            {
                hasCaught = true;
                caughtAnimation();
            }
        }
    }

    public bool measureDistance()
    {
        playerPos = myPlayerComponent.GetPos();

        playerLane = (myPlayerComponent.GetProperty("playerLane")).ToInt();

        string isMagnetStr = myPlayerComponent.GetProperty("isManget");

        if(isMagnetStr == "false")
        {
            isMagnet = false;
        }
        else if(isMagnetStr == "true")
        {
            isMagnet = true;
        }

        if(isMagnet == false)
        {
            
        }
        else
        {
        
        }
    }

    public void reset()
    {
        hasCaught = false;
        myItemSelf.SetPos(originalPos);
    }

    public void caughtAnimation()
    {
        myItemSelf.SetPos(afterPos);
    }
}
