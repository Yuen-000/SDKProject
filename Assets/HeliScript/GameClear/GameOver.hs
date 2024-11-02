component GameOver
{
    //自分GameoverScript
    Item selfItem;

    //デスポーンのアイテム
    Item despawnHeightItem;

    //カメラアイテム
    Item camera; 

    //ゲームオーバーかどうか
    bool isGameOver; 

    //小峯追加分、Playerクラス
    Item  myPlayer;

    public GameOver()
    {
        selfItem = hsItemGetSelf();
        despawnHeightItem = hsItemGet("RespownZone");
        camera = hsItemGet("GameoverCamera");
        isGameOver = false;

        //小峯追加分、Playerを入手
        myPlayer = hsItemGet("PlayerSettings");
    }

    public void Update()
    {
        if(!isGameOver)
        {
            if(despawnHeightItem.GetPos().y >= hsPlayerGet().GetPos().y)
            {
                SetGameOver();
            }
        }
    }

    //ゲームオーバー画面に遷移する関数
    void SetGameOver()
    {
        isGameOver = true;

        //カメラをゲームオーバー画面のカメラに移す
        camera.SetCamera();

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
        SetRetry();
    }

    //リトライ処理
    void SetRetry()
    {
        isGameOver = false;

        //プレイヤー初期位置に戻す
        hsPlayerGet().SetPos(hsItemGet("SpawnPoint").GetPos());

        //カメラをプレイヤーに戻す
        camera.ResetCamera(); 

        //小峯追加分、カメラが動いているフラグをオフ
        myPlayer.CallComponentMethod("PlayerAutoRun", "setMoveCameraFalse", "");
    }
}
