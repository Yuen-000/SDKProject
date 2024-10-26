component OneOutGimmick
{
    Utility utility;
    Player playerItem;
    Item blockItem;
    Item gameOverItem;

    Vector3 playerPos;

    //左の方レーンから右のレーンへ
    Vector3 blockLeftPos;
    Vector3 blockMidPos;
    Vector3 blockLeftUpPos;
    Vector3 blockMidUpPos;
    
    int time;
    int coolTime;

    int judgmentFrontDistance;
    int judgmentTopDistance;

    bool isGameover;
    bool inView;
    
    public OneOutGimmick()
    {
        //basic setting
        utility = new Utility();

        //プレイヤー
        playerItem = new Player();
        playerItem = hsPlayerGet();

        //OneOutブロック
        blockItem = hsItemGetSelf();

        //gameoverアイテム
        gameOverItem = hsItemGet("GameoverScript");
        
        
        //ぶつかるポジション
        blockLeftPos = utility.StrToVector3(blockItem.GetProperty("LeftPosition"));
        blockMidPos = utility.StrToVector3(blockItem.GetProperty("MidPosition"));
        blockLeftUpPos = utility.StrToVector3(blockItem.GetProperty("LeftUpPosition"));
        blockMidUpPos = utility.StrToVector3(blockItem.GetProperty("MidUpPosition"));

        //距離の判定
        judgmentFrontDistance = blockItem.GetProperty("FrontDistance").ToFloat();
        judgmentTopDistance = blockItem.GetProperty("TopDistance").ToFloat();

        //ゲームオーバー判断
        isGameover = false;

        //視界に入るの判断
        inView = false;

        //debug用
        time = 0;
        coolTime = 100;
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
                if(playerPos.Distance(blockLeftPos) < judgmentFrontDistance || 
                playerPos.Distance(blockMidPos) < judgmentFrontDistance || 
                playerPos.Distance(blockLeftUpPos) < judgmentTopDistance || 
                playerPos.Distance(blockMidUpPos) < judgmentTopDistance)
                {             
                    PlayerGameOver();
                }

            }
        }
        else
        {
            //ゲームオーバーのリセット
            ResetCoolTime();
        }
    }

    //ゲームオーバーを呼ぶ
    void PlayerGameOver()
    {
        isGameover = true;
        if(gameOverItem !== null)
        {
            gameOverItem.CallComponentMethod("GameOver", "GetGameOver", "");
        }
    }

    //リセットクールタイム
    void ResetCoolTime()
    {
        if(time == coolTime)
        {
            //isGameOverをリセット
            isGameover = false;
            hsSystemOutput("isGameover reset");

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
        hsSystemOutput("見つけた");
        inView = true;
    }
    
    //視界に入っていないの判断
    public void OnLeaveViewCollider()
    {
        inView = false;
    }
}
