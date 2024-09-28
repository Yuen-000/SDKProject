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

    //ボックスのどこかをクリックしたらリトライを行うための関数
    public void OnClickNode()
    {
        SetRetry();
    }

    //リトライ処理
    void SetRetry()
    {
        isGameOver = false;

        //カメラをプレイヤーに戻す
        camera.ResetCamera(); 
    }
}
