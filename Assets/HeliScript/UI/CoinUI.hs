component CoinUI
{
    Item selfItem;
    Player player;

    public CoinUI()
    {
        selfItem = hsItemGetSelf();
        player = hsPlayerGet();
    }

    public void Update()
    {
        // Set the coin's position to match the player's position
        Vector3 playerPos = player.GetPos();
        hsItemSetPosition(selfItem, playerPos);
    }

    void hsItemSetPosition(Item self, Vector3 position)
    {
        item.SetPos(position);
    }
}
