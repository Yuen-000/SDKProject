component UIFollowPlayer
{
    //自分
    Item selfItem;
    Item decreaseUIItem;

    //プレイヤーアイテム
    Player playerItem;

    //プレイヤーポジション
    Vector3 playerPos;

    //タイムUIのポジション
    Vector3 itemPos;
    Vector3 itemYPos;
    
    //-3UIのポジション
    Vector3 startDecreaseUI;
    Vector3 startDecreasePos;
    Vector3 moveDecreasePos;
    Vector3 moveVector;

    float itemHigh;
    float decreaseUIWeight;
    float decreaseUIHigh;
    float decreaseUIMoveTime;

    //表示タイム
    int showTime;
    int time;

    bool setMoveDecrease;

    public UIFollowPlayer()
    {
        selfItem = hsItemGetSelf();

        //プレイヤー
        playerItem = new Player();
        playerItem = hsPlayerGet();

        decreaseUIItem = hsItemGet("DecreaseTimeUI");

        //タイマのUIポジション
        itemPos = new Vector3();
        itemYPos = new Vector3();

        //ポジションのコンストラクタ
        startDecreaseUI = new Vector3();
        startDecreasePos = new Vector3();
        moveDecreasePos = new Vector3();
        moveVector = new Vector3();

        //タイマUI高さ設定
        itemHigh = selfItem.GetProperty("YPos").ToFloat();

        //-3UIのポジション設定
        decreaseUIWeight = decreaseUIItem.GetProperty("XPos").ToFloat();
        decreaseUIHigh = decreaseUIItem.GetProperty("YPos").ToFloat();
        decreaseUIMoveTime = decreaseUIItem.GetProperty("MoveTime").ToFloat();

        //表示タイム
        showTime = decreaseUIItem.GetProperty("ShowTime").ToInt();
        time = 0;

        //moveVector設定
        moveVector = makeVector3(0, decreaseUIMoveTime, 0);

        setMoveDecrease = false;

        HideDecreaseTime();
    }

    public void Update()
    {
        playerPos = playerItem.GetPos();
        FollowTimer();
        FollowDecreaseTime();
        if(decreaseUIItem.IsShow())
        {
            MoveDecreaseTime();
        }
    }

    //タイマがプレイヤーを追跡する
    void FollowTimer()
    {
        itemYPos = playerPos;
        itemPos = playerPos;
        itemPos.y = itemYPos.y + itemHigh;
        
        selfItem.SetPos(itemPos);
    }

    //-3UIを追跡させる
    void FollowDecreaseTime()
    {        
        //-3UIのスタートポジション
        startDecreasePos = itemPos;
        startDecreaseUI = itemPos;
        startDecreaseUI.x = startDecreasePos.x + decreaseUIWeight;
        startDecreaseUI.y = startDecreasePos.y - decreaseUIHigh;
    }

    //-3UIを移動させて、消える
    void MoveDecreaseTime()
    {
        if(setMoveDecrease)
        {
            moveDecreasePos = startDecreaseUI;
            setMoveDecrease = false;
        }
        
        if(time == showTime)
        {
            HideDecreaseTime();
        }
        else
        {
            time = time + 1;

            //xとz軸だけ追跡させる
            moveDecreasePos.x = startDecreaseUI.x;
            moveDecreasePos.z = startDecreaseUI.z;

            //下に移動
            moveDecreasePos.Sub(moveVector);
            decreaseUIItem.SetPos(moveDecreasePos);
        }
    }

    //-3UIの表示を外部からコントロール
    public void ShowDecreaseTime()
    {
        decreaseUIItem.SetShow(true);
        setMoveDecrease = true;
    }

    //-3UIの非表示を外部からコントロール
    public void HideDecreaseTime()
    {
        decreaseUIItem.SetShow(false);
        time = 0;
    }
}
