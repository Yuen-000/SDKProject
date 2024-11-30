component CoinUI
{
    Item selfItem;

    Player player;

    Vector3 playerPos;
    
    public CoinUI()
    {
        selfItem = hsItemGetSelf();
        player = hsPlayerGet();
    }

    public void Update()
    {
        hsItemSetPosition(selfItem, player);
    }

    void hsItemSetPosition(Item self, Player playerItem)
    {
        playerPos = playerItem.GetPos();
        hsSystemOutput(playerPos);
        self.SetPos(playerPos);
    }
}
