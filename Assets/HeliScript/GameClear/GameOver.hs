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

    //小峯追加分、コイン管理アイテム
    Item coinManagement;

    //小峯追加分、ゲームオーバーBGMアイテム
    Item overBGM;

    //小峯追加分、通常BGMアイテム
    Item normalBGM;

    //小峯追加分、スピードアップ管理アイテム
    Item speedUpManagement;

    //小峯追加分、磁石管理アイテム
    Item magnetManagement;

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
        coinManagement = hsItemGet("CoinManagement");

        //小峯追加分、ゲームオーバーBGMを入手
        overBGM = hsItemGet("BGM_GameOver");

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

        //小峯追加分、Autorunのカメラが動いているフラグをオン
        SetAutorunCamera();

        //小峯追加分、諸々をリセット
        Item gate1L = hsItemGet("Gate1LeftDoor");
        Item gate1R = hsItemGet("Gate1RightDoor");

        gate1L.CallComponentMethod("Gate1LeftAnimation", "reset", "");
        gate1R.CallComponentMethod("Gate1RightAnimation", "reset", "");

        Item gate2L = hsItemGet("Gate2LeftDoor");
        Item gate2R = hsItemGet("Gate2RightDoor");

        gate2L.CallComponentMethod("Gate2LeftAnimation", "setClose", "");
        gate2R.CallComponentMethod("Gate2RightAnimation", "setClose", "");
        
        Item gate3L = hsItemGet("Gate3LeftWall");
        Item gate3R = hsItemGet("Gate3RightWall");

        gate3L.CallComponentMethod("Gate3LeftAnimation", "setClose", "");
        gate3R.CallComponentMethod("Gate3RightAnimation", "setClose", "");

        Item button = hsItemGet("ActionButtonScript");

        button.CallComponentMethod("ActionButton", "recieveForceGameOver", "");
        button.CallComponentMethod("ActionButton", "SetActionFlagFalse", "");

        Item area1 = hsItemGet("ActionArea1");

        area1.CallComponentMethod("ActionStartArea", "endActionTime", "");

        Item area2 = hsItemGet("ActionArea2");

        area2.CallComponentMethod("ActionStartArea", "endActionTime", "");

        Item area3 = hsItemGet("ActionArea3");

        area3.CallComponentMethod("ActionStartArea", "endActionTime", "");

        //小峯追加分、通常BGMの再生を止め、ゲームオーバーのBGMを流す
        SetOverBGM();

        //小峯追加分、スピードアップをフラグオフする
        FlagOffSpeedUp();

        //小峯追加分、磁石をフラグオフする
        FlagOffMagnet();
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
        timeSystem.CallComponentMethod("TimeSystemKomine", "StopCountTimer", "");
    }

    //タイマをリスタート
    void ResetTimer()
    {
        timeSystem.CallComponentMethod("TimeSystemKomine", "ResetTimer", "");
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
    void SetOverBGM()
    {
        normalBGM.Stop();
        overBGM.Play();
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
