component StageMove
{
    Item stageItem;
    float speed;

    public StageMove()
    {
        stageItem = hsItemGetSelf();
        speed = stageItem.GetProperty("StageSpeed").ToFloat();
    }

    public void Update()
    {   
        Move();
    }

    //ステージ移動
    void Move()
    {
        Vector3 movePos = stageItem.GetPos();
        movePos.Add(MoveDirection());
        stageItem.SetPos(movePos);
    }

    //移動速度調整
    Vector3 MoveDirection()
    {
        Vector3 resule;
        resule = makeVector3(0, 0, -1 * speed * hsSystemGetDeltaTime());
        return resule;
    }

    //外部からの変更を感知
    public void OnChangedProperty(string key, string value)
    {
        if(key == "StageSpeed")
        {
            speed = stageItem.GetProperty("StageSpeed").ToFloat();
        }
    }
}
