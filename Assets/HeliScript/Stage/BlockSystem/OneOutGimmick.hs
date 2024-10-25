component OneOutGimmick
{
    Player playerItem;
    Item blockItem;
    Item gameOverItem;

    Vector3 playerPos;
    Vector3 blockPos;
    Vector3 blockXPos;
    Vector3 blockYPos;
    
    int time;
    int coolTime;

    bool isGameover;
    bool inView;
    
    public OneOutGimmick()
    {
        //プレイヤー
        playerItem = new Player();
        playerItem = hsPlayerGet();

        //OneOutブロック
        blockItem = hsItemGetSelf();
        gameOverItem = hsItemGet("GameoverScript");
        
        
        //ブロックポジション
        blockPos = blockItem.GetPos();
        blockXPos = makeVector3(blockPos.x + 1f, blockPos.y, blockPos.z);
        blockYPos = makeVector3(blockPos.x, blockPos.y, blockPos.z);
        isGameover = false;
        
        inView = true;

        //debug用
        time = 0;
        coolTime = 150;
    }

    public void Update()
    {
        //Playerポジションをゲット
        playerPos = playerItem.GetPos();

        if(!isGameover)
        {
            if(inView)
            {
                //ブロックとプレイヤーの距離を判定
                if(playerPos.Distance(blockXPos) < 1 || playerPos.Distance(blockYPos) < 1)
                {
                    PlayerGameOver();
                    return;
                }
            }
        }

        //*debug用*判定のクールタイム
        DebugCoolTime();
    }

    //ゲームオーバーを呼ぶ
    void PlayerGameOver()
    {
        isGameover = true;
        gameOverItem.CallComponentMethod("GameOver", "GetGameOver", "");
        isGameover = false;
        return;
    }

    //*debug用*判定のクールタイム
    void DebugCoolTime()
    {
        if(time == coolTime)
        {
            hsSystemOutput(playerPos.Distance(blockPos).ToString() + "/");
            time = 0;
        }
        else
        {
            time = time + 1;
        }
    }

    //視界に入ってるの判断
    public void OnEnterViewCollider()
    {
        inView = true;
    }
    
    //視界に入っていないの判断
    public void OnLeaveViewCollider()
    {
        inView = false;
    }
}
