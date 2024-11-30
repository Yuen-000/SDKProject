class GameOverDecision
{
    bool isGameOver;

    //コンストラクタ
    public GameOverDecision()
    {
        isGameOver = false;
    }

    //ゲームオーバーをゲット
    public bool GetGameOver()
    {
        return isGameOver;
    }

    //ゲームオーバーをセット
    public void SetGameOver(bool judgment)
    {
        isGameOver = judgment;
    }
}
