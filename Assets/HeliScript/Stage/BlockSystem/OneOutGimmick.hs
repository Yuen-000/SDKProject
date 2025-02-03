component OneOutGimmick
{
    //GameOverDecisionクラス
    GameOverDecision gameOver;

    //プレイヤーアイテム
    Player playerItem;

    //アイテム
    Item blockItem;
    Item gameOverItem;

    //SE
    Item damageSE;

    //アイテムのVector3
    Vector3 blockItemPos;
    Vector3 playerPos;
    
    Vector3 leftPointPos;
    Vector3 midPointPos;
    Vector3 rightPointPos;

    //何レーンの判定
    string linePoint;

    //判定ポイント
    float judgmentFrontDistance;
    float blockItemYPoint;
    float blockLeftXPoint;
    float blockMidXPoint;
    float blockRightXPoint;
    
    public OneOutGimmick()
    {
        //GameOverDecisionのコンストラクタ
        gameOver = new GameOverDecision();

        //プレイヤー
        playerItem = new Player();
        playerItem = hsPlayerGet();

        //gameoverアイテム
        gameOverItem = hsItemGet("GameoverScript");

        //DamageのSE
        damageSE = hsItemGet("DamageSE");

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

        //ぶつかるポジション
        SettingPoint(linePoint);
    }

    public void Update()
    {
        //Playerポジションをゲット
        playerPos = playerItem.GetPos();

        if(!gameOver.GetGameOver())
        {
            SettingJudgment(linePoint);
        }
    }

    //ゲームオーバーを呼ぶ
    void PlayerGameOver()
    {
        if(gameOverItem !== null)
        {
            gameOverItem.CallComponentMethod("GameOver", "GetGameOver", "");
            gameOverItem.CallComponentMethod("GameOver", "SetPlayerRetry", "");
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
                PlaySE();
                PlayerGameOver();
            }
                break;
            case "MidPoint":
            if(playerPos.Distance(midPointPos) < judgmentFrontDistance)
            {
                PlaySE();
                PlayerGameOver();
            }
                break;
            case "RightPoint":
            if(playerPos.Distance(rightPointPos) < judgmentFrontDistance)
            {
                PlaySE();
                PlayerGameOver();
            }
                break;
            case "LeftMidPoint":
            if(playerPos.Distance(leftPointPos) < judgmentFrontDistance || 
                playerPos.Distance(midPointPos) < judgmentFrontDistance)
            {
                PlaySE();
                PlayerGameOver();
            }
                break;
            case "RightMidPoint":
            if(playerPos.Distance(rightPointPos) < judgmentFrontDistance || 
                playerPos.Distance(midPointPos) < judgmentFrontDistance)
            {
                PlaySE();
                PlayerGameOver();
            }
                break;
            case "AllPoint":
            if(playerPos.Distance(leftPointPos) < judgmentFrontDistance || 
                playerPos.Distance(midPointPos) < judgmentFrontDistance || 
                playerPos.Distance(rightPointPos) < judgmentFrontDistance)
            {
                PlaySE();
                PlayerGameOver();
            }
                break;
        }
    }

    //SEを流す
    void PlaySE()
    {
        damageSE.Play();
    }
}
