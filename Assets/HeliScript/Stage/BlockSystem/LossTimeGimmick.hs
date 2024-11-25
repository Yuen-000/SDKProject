component LossTimeGimmick
{
    //GameOverDecisionクラス
    GameOverDecision gameOver;

    //プレイヤーアイテム
    Player playerItem;

    //アイテム
    Item blockItem;
    Item lostTimeItem;

    //アイテムのVector3
    Vector3 blockItemPos;
    Vector3 playerPos;
    
    Vector3 leftPointPos;
    Vector3 midPointPos;
    Vector3 rightPointPos;

    //タイム
    int time;
    int coolTime;

    //何レーンの判定
    string linePoint;

    //判定ポイント
    float judgmentFrontDistance;
    float blockItemYPoint;
    float blockLeftXPoint;
    float blockMidXPoint;
    float blockRightXPoint;

    //ゲームオーバーの判定
    bool isLostTime;

    public LossTimeGimmick()
    {
        //GameOverDecisionのコンストラクタ
        gameOver = new GameOverDecision();
        
        //プレイヤー
        playerItem = new Player();
        playerItem = hsPlayerGet();

        //タイムアイテム
        lostTimeItem = hsItemGet("TimeSystem");

        //ギミックブロック
        blockItem = hsItemGetSelf();
        blockItemPos = blockItem.GetPos();

        //何レーンあるかの設定
        linePoint = blockItem.GetProperty("LinePoint");

        //ブロックアイテムのXポジション
        blockLeftXPoint = blockItem.GetProperty("LeftPoint").ToFloat();
        blockMidXPoint = blockItem.GetProperty("MidPoint").ToFloat();
        blockRightXPoint = blockItem.GetProperty("RightPoint").ToFloat();
        blockItemYPoint = 0f;

        //距離の判定
        judgmentFrontDistance = blockItem.GetProperty("FrontDistance").ToFloat();

        //ゲームオーバー判断
        isLostTime = false;

        //リセットタイム
        time = 0;
        coolTime = 100;

        //ぶつかるポジション
        SettingPoint(linePoint);
    }

    public void Update()
    {
        //Playerポジションをゲット
        playerPos = playerItem.GetPos();

        if(!isLostTime && !gameOver.GetGameOver())
        {
            SettingJudgment(linePoint);
        }
        else
        {
            //ゲームオーバーのリセット
            ResetCoolTime();
        }
    }

    //ロストタイムを呼ぶ
    void PlayerLostTime()
    {
        isLostTime = true;

        if(lostTimeItem !== null)
        {
            hsSystemOutput("LostTime");
        }
    }

    //リセットクールタイム
    void ResetCoolTime()
    {
        if(time == coolTime)
        {
            //isLostTimeをリセット
            isLostTime = false;
            time = 0;
        }
        else
        {
            time = time + 1;
        }
    }

    //ブロックのポインター設定
    void SettingPoint(string point)
    {
        switch(point)
        {
            case "LeftPoint":
            leftPointPos = blockItemPos;
            leftPointPos.x = blockLeftXPoint;
            leftPointPos.y = blockItemYPoint;
                break;
            case "MidPoint":
            midPointPos = blockItemPos;
            midPointPos.x = blockMidXPoint;
            midPointPos.y = blockItemYPoint;
                break;
            case "RightPoint":
            rightPointPos = blockItemPos;
            rightPointPos.x = blockRightXPoint;
            rightPointPos.y = blockItemYPoint;
                break;
            case "LeftMidPoint":
            leftPointPos = blockItemPos;
            leftPointPos.x = blockLeftXPoint;
            leftPointPos.y = blockItemYPoint;

            midPointPos = blockItemPos;
            midPointPos.x = blockMidXPoint;
            midPointPos.y = blockItemYPoint;
                break;
            case "RightMidPoint":
            rightPointPos = blockItemPos;
            rightPointPos.x = blockRightXPoint;
            rightPointPos.y = blockItemYPoint;
            
            midPointPos = blockItemPos;
            midPointPos.x = blockMidXPoint;
            midPointPos.y = blockItemYPoint;
                break;
            case "AllPoint":
            leftPointPos = blockItemPos;
            leftPointPos.x = blockLeftXPoint;
            leftPointPos.y = blockItemYPoint;

            midPointPos = blockItemPos;
            midPointPos.x = blockMidXPoint;
            midPointPos.y = blockItemYPoint;

            rightPointPos = blockItemPos;
            rightPointPos.x = blockRightXPoint;
            rightPointPos.y = blockItemYPoint;
                break;
        }
    }

    //ブロックとプレイヤーの距離を判定
    void SettingJudgment(string point)
    {
        switch(point)
        {
            case "LeftPoint":
            if(playerPos.Distance(leftPointPos) < judgmentFrontDistance)
            {
                PlayerLostTime();
            }
                break;
            case "MidPoint":
            if(playerPos.Distance(midPointPos) < judgmentFrontDistance)
            {
                PlayerLostTime();
            }
                break;
            case "RightPoint":
            if(playerPos.Distance(rightPointPos) < judgmentFrontDistance)
            {
                PlayerLostTime();
            }
                break;
            case "LeftMidPoint":
            if(playerPos.Distance(leftPointPos) < judgmentFrontDistance || 
                playerPos.Distance(midPointPos) < judgmentFrontDistance)
            {
                PlayerLostTime();
            }
                break;
            case "RightMidPoint":
            if(playerPos.Distance(rightPointPos) < judgmentFrontDistance || 
                playerPos.Distance(midPointPos) < judgmentFrontDistance)
            {
                PlayerLostTime();
            }
                break;
            case "AllPoint":
            if(playerPos.Distance(leftPointPos) < judgmentFrontDistance || 
                playerPos.Distance(midPointPos) < judgmentFrontDistance || 
                playerPos.Distance(rightPointPos) < judgmentFrontDistance)
            {
                PlayerLostTime();
            }
                break;
        }
    }
}
