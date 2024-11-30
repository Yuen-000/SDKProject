component UIFollowPlayer
{
    //自分
    Item selfItem;

    //プレイヤーアイテム
    Player playerItem;

    Vector3 playerPos;
    Vector3 itemPos;
    Vector3 itemYPos;

    public UIFollowPlayer()
    {
        selfItem = hsItemGetSelf();

        //プレイヤー
        playerItem = new Player();
        playerItem = hsPlayerGet();

        itemPos = new Vector3();
        itemYPos = new Vector3();
    }

    public void Update()
    {
        playerPos = playerItem.GetPos();

        itemYPos = playerPos;
        itemPos = playerPos;
        itemPos.y = itemYPos.y + 2.5f;
        
        selfItem.SetPos(itemPos);
    }
}
