component CoinUI
{
    //ItemのObject
    Item selfItem;
    Item coinManagement;
    Item coinTitleUIItem;
    Item resultCoinUIItem;

    //PlayerのObject
    Player playerItem;

    //Playerのポジション
    Vector3 playerPos;

    //selfItemのポジション
    Vector3 itemUIPos;
    Vector3 itemPos;

    //coinTitleUIItemのポジション
    Vector3 titleUIItemPos;
    Vector3 titleItemPos;

    //Coinの数と最大数
    string coinNum;
    string maxCoinNum;

    //ItemPosの設定
    float itemWeight;
    float itemHigh;
    float titleItemXPos;
    float titleItemYPos;

    //CoinManagementItemの名前
    string coinManagementItemName;

    public CoinUI()
    {
        selfItem = hsItemGetSelf();
        coinTitleUIItem = hsItemGet("CoinUITitle");
        resultCoinUIItem = hsItemGet("ResultCoin");
        playerItem = new Player();

        itemUIPos = new Vector3();
        itemPos = new Vector3();

        itemWeight = selfItem.GetProperty("XPos").ToFloat();
        itemHigh = selfItem.GetProperty("YPos").ToFloat();

        titleItemXPos = coinTitleUIItem.GetProperty("XPos").ToFloat();
        titleItemYPos = coinTitleUIItem.GetProperty("YPos").ToFloat();

        //coinManagementのItemの名前をゲットするため
        coinManagementItemName = selfItem.GetProperty("CoinManagementItemName");
        coinManagement = hsItemGet(coinManagementItemName);

        maxCoinNum = coinManagement.GetProperty("COINMAX");
    }

    public void Update()
    {
        playerPos = playerItem.GetPos();
        
        CoinUIFollow();
        CoinTitleUIFollow();
        WriteCoinUI();
        WriteResultCoinUI();
    }

    //CoinUIがプレイヤーを追跡する
    void CoinUIFollow()
    {
        itemPos = playerPos;
        itemUIPos = playerPos;
        itemUIPos.x = itemPos.x + itemWeight;
        itemUIPos.y = itemPos.y + itemHigh;
        
        selfItem.SetPos(itemUIPos);
    }

    //CoinTitleUIがプレイヤーを追跡する
    void CoinTitleUIFollow()
    {
        titleItemPos = itemUIPos;
        titleUIItemPos = itemUIPos;
        titleUIItemPos.x = titleItemPos.x + titleItemXPos;
        titleUIItemPos.y = titleItemPos.y + titleItemYPos;

        coinTitleUIItem.SetPos(titleUIItemPos);
    }

    //Coin数字とMaxCoin数字を出す
    void WriteCoinUI()
    {
        coinNum = coinManagement.GetProperty("Count");
        selfItem.WriteTextPlane(coinNum + " / " + maxCoinNum);
    }

    void WriteResultCoinUI()
    {
        resultCoinUIItem.WriteTextPlane(coinNum + "/" + maxCoinNum);
    }
}
