component GameClear
{
    //GameOverDecisionクラス
    GameOverDecision gameOver;

    //自分GameoverScript
    Item selfItem;

    Item gameClearCream;

    Item clearArea;

    Item timeSystem;

    //小峯追加分、Playerクラス
    Item myPlayer;

    //小峯追加分、コイン管理アイテム
    Item coinManagement;

    public GameClear()
    {
        //GameOverDecisionのコンストラクタ
        gameOver = new GameOverDecision();

        selfItem = hsItemGetSelf();
        clearArea = hsItemGet("GameClearCollider");
        gameClearCream = hsItemGet("GameClearCamera");

        //ゲットできない
        if(timeSystem === null)
        {
            timeSystem = hsItemGet("TimeSystem");
            hsSystemOutput("time");
        }

        //小峯追加分、Playerを入手
        myPlayer = hsItemGet("PlayerSettings");

        //小峯追加分、コインを入手
        coinManagement = hsItemGet("CoinManagement");
    }

    public void Update()
    {
        if(!gameOver.GetGameOver())
        {
            if(clearArea.GetPos().z <= hsPlayerGet().GetPos().z)
            {
                SetGameClear();
            }
        }
    }

    //ゲームオーバー画面に遷移する関数
    void SetGameClear()
    {
        //ゲームオーバーをtrueに
        gameOver.SetGameOver(true);

        //カメラをゲームクリア画面のカメラに移す
        gameClearCream.SetCamera();

        //タイムストップ
        StopTimer();

        //リザルトに表示
        ResultTimeUI();

        //小峯追加分、Autorunのカメラが動いているフラグをオン
        SetAutorunCamera();
    }

    //ボックスをクリックしたらリトライ
    public void OnClickNode()
    {
        ResetTimer();
        Retry();
    }

    //リトライ処理
    void Retry()
    {
        //ゲームオーバーをfalseに
        gameOver.SetGameOver(false);

        //プレイヤー初期位置に戻す
        hsPlayerGet().SetPos(hsItemGet("SpawnPoint").GetPos());
        
        //カメラをプレイヤーに戻す
        gameClearCream.ResetCamera();

        //小峯追加分、Autorunのカメラが動いているフラグをオフ
        ResetAutorunCamera();

        //小峯追加分、コインをリセットする
        ResetCoin();
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

    //タイムをリザルトに反映する
    void ResultTimeUI()
    {
        timeSystem.CallComponentMethod("TimeSystem", "ResultTimeUI", "");        
    }

    //小峯追加分、Autorunのカメラが動いているフラグをオン
    void SetAutorunCamera()
    {
        myPlayer.CallComponentMethod("PlayerAutoRun", "setMoveCameraTrue", "");
    }

    //小峯追加分、Autorunのカメラが動いているフラグをオフ
    void ResetAutorunCamera()
    {
        myPlayer.CallComponentMethod("PlayerAutoRun", "setMoveCameraFalse", "");
    }

    //小峯追加分、コインをリセットする
    void ResetCoin()
    {
        coinManagement.CallComponentMethod("CoinManagement", "reset", "");      
    }
}
