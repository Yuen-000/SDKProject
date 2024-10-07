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

    public GameOver()
    {
        selfItem = hsItemGetSelf();
        despawnHeightItem = hsItemGet("RespownZone");
        camera = hsItemGet("GameoverCamera");
        isGameOver = false;
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
    }
}
