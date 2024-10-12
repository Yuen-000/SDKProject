component GameClear
{
    //自分GameoverScript
    Item selfItem;

    Item gameClearCream;

    Item clearArea;

    bool isGameClear;

    public GameClear()
    {
        selfItem = hsItemGetSelf();
        clearArea = hsItemGet("GameClearCollider");
        gameClearCream = hsItemGet("GameClearCamera");
        isGameClear = false;
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
    }
}
