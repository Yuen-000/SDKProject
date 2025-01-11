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

    //小峯追加分、ゲームクリアBGMアイテム
    Item clearBGM;

    //小峯追加分、通常BGMアイテム
    Item normalBGM;

    //小峯追加分、スピードアップ管理アイテム
    Item speedUpManagement;

    //小峯追加分、磁石管理アイテム
    Item magnetManagement;

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

        //小峯追加分、ゲームクリアBGMを入手
        clearBGM = hsItemGet("BGM_GameClear");

        //小峯追加分、通常BGMを入手
        normalBGM = hsItemGet("BGM_Main");

        //小峯追加分、スピードアップを入手
        speedUpManagement = hsItemGet("SpeedUpManagement");

        //小峯追加分、磁石を入手
        magnetManagement = hsItemGet("MagnetManagement");
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

        //小峯追加分、通常BGMの再生を止め、ゲームクリアのBGMを流す
        SetClearBGM();

        //小峯追加分、スピードアップをフラグオフする
        FlagOffSpeedUp();

        //小峯追加分、磁石をフラグオフする
        FlagOffMagnet();
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

        //小峯追加分、通常のBGMを流す
        SetNormalBGM();

        //小峯追加分、スピードアップをリセットする
        ResetSpeedUp();

        //小峯追加分、磁石をリセットする
        ResetMagnet();
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

    //小峯追加分、通常BGMの再生を止め、ゲームクリアのBGMを流す
    void SetClearBGM()
    {
        normalBGM.Stop();
        clearBGM.Play();
    }

    //小峯追加分、通常のBGMを流す
    void SetNormalBGM()
    {
        normalBGM.Play();
    }

    //小峯追加分、スピードアップをリセットする
    void ResetSpeedUp()
    {
        speedUpManagement.CallComponentMethod("SpeedUpManagement", "reset", "");      
    }

    //小峯追加分、磁石をリセットする
    void ResetMagnet()
    {
        magnetManagement.CallComponentMethod("MagnetManagement", "reset", "");      
    }

    //小峯追加分、スピードをフラグオフする
    void FlagOffSpeedUp()
    {
        myPlayer.CallComponentMethod("PlayerAutoRun", "setSpeedUpEnd", "");      
    }

    //小峯追加分、磁石をフラグオフする
    void FlagOffMagnet()
    {
        myPlayer.CallComponentMethod("PlayerAutoRun", "setMagnetEnd", "");      
    }
}
