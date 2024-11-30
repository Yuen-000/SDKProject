component GameOver
{
    //GameOverDecisionクラス
    GameOverDecision gameOver;

    //自分GameoverScript
    Item selfItem;

    //デスポーンのアイテム
    Item despawnHeightItem;

    //カメラアイテム
    Item camera;

    Item timeSystem;

    //小峯追加分、Playerクラス
    Item myPlayer;

    //小峯追加分、コインアイテム
    //Item coin;

    public GameOver()
    {
        //GameOverDecisionのコンストラクタ
        gameOver = new GameOverDecision();

        selfItem = hsItemGetSelf();
        despawnHeightItem = hsItemGet("RespownZone");
        camera = hsItemGet("GameoverCamera");
        timeSystem = hsItemGet("TimeSystem");

        //小峯追加分、Playerを入手
        myPlayer = hsItemGet("PlayerSettings");
        
        //小峯追加分、コインを入手
        //coin = hsItemGet("CoinScript");
    }

    public void Update()
    {
        if(!gameOver.GetGameOver())
        {
            //落ちたらゲームオーバー
            if(despawnHeightItem.GetPos().y >= hsPlayerGet().GetPos().y)
            {
                SetGameOver();
            }
        }
    }

    //外部からゲームオーバーを呼ぶ
    public void GetGameOver()
    {
        SetGameOver();
    }

    //ゲームオーバー画面に遷移する関数
    void SetGameOver()
    {
        //ゲームオーバーをtrueに
        gameOver.SetGameOver(true);

        //カメラをゲームオーバー画面のカメラに移す
        camera.SetCamera();

        //タイマを止める
        StopTimer();

        //プレイヤーポジションを戻る
        SetPlayerRetry();

        //小峯追加分、カメラが動いているフラグをオン
        myPlayer.CallComponentMethod("PlayerAutoRun", "setMoveCameraTrue", "");

        //小峯追加分、諸々をリセット
        Item gateL = hsItemGet("Gate1LeftDoor");
        Item gateR = hsItemGet("Gate1RightDoor");

        gateL.CallComponentMethod("Gate1LeftAnimation", "reset", "");
        gateR.CallComponentMethod("Gate1RightAnimation", "reset", "");

        Item button = hsItemGet("ActionButtonScript");

        button.CallComponentMethod("ActionButton", "SetActionFlagFalse", "");

        Item area1 = hsItemGet("ActionArea1");

        area1.CallComponentMethod("ActionStartArea", "endActionTime", "");
    }

    //ボックスをクリックしたらリトライ
    public void OnClickNode()
    {
        SetPlayerRetry();
        ResetTimer();
        SetRetry();
    }

    //プレイヤー初期位置に戻す
    public void SetPlayerRetry()
    {
        hsPlayerGet().SetPos(hsItemGet("SpawnPoint").GetPos());
    }

    //リトライ処理
    void SetRetry()
    {
        //ゲームオーバーをfalseに
        gameOver.SetGameOver(false);

        //カメラをプレイヤーに戻す
        camera.ResetCamera();

        //小峯追加分、カメラが動いているフラグをオフ
        myPlayer.CallComponentMethod("PlayerAutoRun", "setMoveCameraFalse", "");
        
        //小峯追加分、コインをリセット
        //coin.CallComponentMethod("CoinManagement", "reset", "");
    }

    //タイマを止める
    void StopTimer()
    {
        timeSystem.CallComponentMethod("TimeSystem", "StopCountTimer", "");
    }

    //タイマをリスタート
    void ResetTimer()
    {
        timeSystem.CallComponentMethod("TimeSystem", "ResetTimmer", "");
    }
}
