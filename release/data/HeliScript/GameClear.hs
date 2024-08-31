component GameClear
{
    Item gameClearCream;

    public GameClear()
    {
        gameClearCream = hsItemGet("GameClearCamera");
    }

    public void Update()
    {
        
    }

    public void EnterClearArea(string clearArea)
    {
        IsGameClear();
    }

    public void IsGameClear()
    {
        
    }

}
