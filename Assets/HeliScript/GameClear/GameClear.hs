component GameClear
{
    //自分GameoverScript
    Item selfItem;

    Item gameClearCream;

    Item clearArea;

    bool isGameClear;

    //小峯追加分、Playerクラス
    Item myPlayer;

    //小峯追加分、コインアイテム
    Item coin;

    public GameClear()
    {
        selfItem = hsItemGetSelf();
        clearArea = hsItemGet("GameClearCollider");
        gameClearCream = hsItemGet("GameClearCamera");
        isGameClear = false;

        //小峯追加分、Playerを入手
        myPlayer = hsItemGet("PlayerSettings");

        //小峯追加分、コインを入手
        coin = hsItemGet("CoinScript");
    }

    public void Update()
    {
        if(!isGameClear)
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
        isGameClear = true;

        //カメラをゲームクリア画面のカメラに移す
        gameClearCream.SetCamera();

        //小峯追加分、カメラが動いているフラグをオン
        myPlayer.CallComponentMethod("PlayerAutoRun", "setMoveCameraTrue", "");
    }

    //ボックスをクリックしたらリトライ
    public void OnClickNode()
    {
        Retry();
    }

    //リトライ処理
    void Retry()
    {
        isGameClear = false;

        //プレイヤー初期位置に戻す
        hsPlayerGet().SetPos(hsItemGet("SpawnPoint").GetPos());
        
        //カメラをプレイヤーに戻す
        gameClearCream.ResetCamera();

        //小峯追加分、カメラが動いているフラグをオフ
        myPlayer.CallComponentMethod("PlayerAutoRun", "setMoveCameraFalse", "");

        //小峯追加分、コインをリセット
        coin.CallComponentMethod("CoinManagement", "reset", "");
    }
}
