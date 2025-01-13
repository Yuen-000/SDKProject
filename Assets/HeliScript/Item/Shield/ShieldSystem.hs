component ShieldSystem
{
    ItemDecision itemDecision;

    Item shieldItem;
    Player playerItem;

    Vector3 playerPos;
    Vector3 itemPos;

    float judgmentDistance;

    public ShieldSystem()
    {
        itemDecision = new itemDecision();

        shieldItem = hsItemGetSelf();
        playerItem = new Player();

        itemPos = shieldItem.GetPos();

        shieldItem.SetShow(true);

        judgmentDistance = shieldItem.GetProperty("Distance").ToFloat();
    }

    public void Update()
    {
        RangeDecision();
    }

    //アイテムとプレイヤーの距離判定
    void RangeDecision()
    {
        playerPos = playerItem.GetPos();

        if(playerPos.Distance(itemPos) < judgmentDistance)
        {
            itemDecision.SetItemUse(true);
            shieldItem.SetShow(false);
        }
    }

    //リセット
    public void ResetShieldItem()
    {
        shieldItem.SetShow(ture);
    }
}
