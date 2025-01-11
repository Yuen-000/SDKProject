component MagnetMain
{
    //Playerクラス
    Player  myPlayer;

    //取られたか
    bool hasCaught;

    //自身のレーン
    int myLane;

    //プレイヤー（呼び出し用）
    Item myPlayerComponent;

    //プレイヤーの座標
    Vector3 playerPos;

    //プレイヤーのレーン
    int playerLane;

    //磁石状態か
    bool isMagnet;

    //自身（property取得用）
    Item myItemSelf;

    //元の座標（リセット用）
    Vector3 originalPos;

    //今の座標
    Vector3 currentPos;

    //アニメーション後の座標（通常用）
    Vector3 afterPos;

    //回転
    //float angle;

    //距離
    float distance;
    
    //アニメカウント
    int count;

    //アイテム管理スクリプト
    //Item itemManagement;

    //レーンの距離
    float LANEDISTANCE;

    //アイテムゲット効果音
    Item itemGetSE;

    //スピードアップ効果音
    Item magnetSE;

    //自分のアイテム番号
    int magnetNum;

    //取得できる距離
    float DISTANCE_NORMAL;

    //取得できる距離（磁石）
    float DISTANCE_MAGNET;

    //磁石エフェクト
    Item magnetParticle;

    public MagnetMain()
    {
        hsSystemOutput("Script:MagnetMain\n");
        hsSystemOutput("Date:20241230\n");
        hsSystemOutput("Version:1.0.0\n");
        hsSystemOutput("Update Content:Create\n");

        hasCaught = false;

        myPlayer = new Player();
        myPlayer = hsPlayerGet();
        playerPos = myPlayer.GetPos();

        myPlayerComponent = hsItemGet("PlayerSettings");
        playerLane = 0;
        isMagnet = false;

        myItemSelf = hsItemGetSelf();
        originalPos = myItemSelf.GetPos();

        currentPos = originalPos;

        LANEDISTANCE = (myPlayerComponent.GetProperty("LANEDISTANCE")).ToFloat();

        myLane = originalPos.x / LANEDISTANCE;

        afterPos = new Vector3();

        afterPos.x = originalPos.x;
        afterPos.y = originalPos.y - 5.0f;
        afterPos.z = originalPos.z;

        //angle = originalPos.z / 5 * -10.0f;

        count = 0;

        //itemManagement = hsItemGet("CoinManagement");

        magnetNum = ((myItemSelf.GetName()).SubString(7,1)).ToInt();

        itemGetSE = hsItemGet("ItemGetSE");
        magnetSE = hsItemGet("MagnetSE");

        DISTANCE_NORMAL = (myPlayerComponent.GetProperty("DISTANCE_NORMAL")).ToFloat();

        DISTANCE_MAGNET = (myPlayerComponent.GetProperty("LANEDISTANCE")).ToFloat();

        magnetParticle = hsItemGet("MagnetParticle");
    }

    public void Update()
    {
        if(hasCaught == false)
        {
            if(measureDistance())
            {
                hasCaught = true;
                //coinManagement.CallComponentMethod("CoinManagement", "addCount", "");
                caughtAnimation();
                myPlayerComponent.CallComponentMethod("PlayerAutoRun","setMagnetStart","");
                magnetParticle.CallComponentMethod("MagnetParticle","setActionTrue","");
                magnetSE.Play();
            }
        }
        else if(count > 0)
        {
            currentPos = myItemSelf.GetPos();

            if(count >= 10)
            {
                count = 0;
                isMagnet = false;
                caughtAnimation();
                itemGetSE.Play();
            }
            else
            {
                count++;
                currentPos.x += (playerPos.x - currentPos.x) / 10;
                currentPos.y += (playerPos.y - (currentPos.y + 0.5)) / 10;
                currentPos.z += (playerPos.z - currentPos.z) / 10;
                myItemSelf.SetPos(currentPos);
            }
        }
    }

    public bool measureDistance()
    {
        playerPos = myPlayer.GetPos();

        playerLane = (myPlayerComponent.GetProperty("playerLane")).ToInt();

        string isMagnetStr = myPlayerComponent.GetProperty("isMagnet");

        if(isMagnetStr == "false")
        {
            isMagnet = false;
        }
        else if(isMagnetStr == "true")
        {
            isMagnet = true;
        }

        //デバッグ用
        //isMagnet = true;

        if(isMagnet == false)
        {
            if(playerLane == myLane)
            {
                distance = hsMathSqrt((playerPos.z - originalPos.z) * (playerPos.z - originalPos.z) + (playerPos.y - originalPos.y) * (playerPos.y - originalPos.y));

                if(distance <= DISTANCE_NORMAL)
                {
                    return true;
                }
            }
        }
        else
        {
            distance = hsMathSqrt((playerPos.z - originalPos.z) * (playerPos.z - originalPos.z) + (playerPos.y - originalPos.y) * (playerPos.y - originalPos.y) + (playerPos.x - originalPos.x) * (playerPos.x - originalPos.x));

            if(distance <= DISTANCE_MAGNET)
            {
                return true;
            }
        }

        return false;
    }

    public void reset()
    {

        hasCaught = false;
        myItemSelf.SetPos(originalPos);
        isMagnet = false;
        count = 0;
        currentPos = originalPos;
        hsSystemOutput("リセットされました\n");
    }

    public void caughtAnimation()
    {
        if(isMagnet == false)
        {
            myItemSelf.SetPos(afterPos);
            itemGetSE.Play();
        }
        else
        {
            count++;
        }
    }
}
