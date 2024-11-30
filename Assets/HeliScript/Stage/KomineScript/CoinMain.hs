component CoinMain
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
    float angle;

    //距離
    float distance;
    
    //アニメカウント
    int count;

    public CoinMain()
    {
        hsSystemOutput("Script:CoinMain\n");
        hsSystemOutput("Date:20241130\n");
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

        myLane = originalPos.x / 1.4f;
        hsSystemOutput(string(myLane) + "\n");

        afterPos = originalPos;
        afterPos.y -= 5.0f;

        angle = originalPos.z / 5 * -10.0f;

        count = 0;
    }

    public void Update()
    {
        angle -= 1.0f;
        Quaternion rotation = makeQuaternionYRotation(angle * PI / 180);
        myItemSelf.SetQuaternion(rotation);

        if(hasCaught == false)
        {
            if(measureDistance())
            {
                hasCaught = true;
                caughtAnimation();
            }
        }
        else if(count > 0)
        {
            currentPos = myItemSelf.GetPos();

            if(count <= 10)
            {
                count = 0;
                caughtAnimation();
            }
            else
            {
                playerPos.x += (playerPos.x - currentPos.x) / 10;
                playerPos.y += (playerPos.y - currentPos.y) / 10;
                playerPos.z += (playerPos.z - currentPos.z) / 10;
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

        if(isMagnet == false)
        {
            if(playerLane == myLane)
            {
                distance = hsMathSqrt((playerPos.z - originalPos.z) * (playerPos.z - originalPos.z) + (playerPos.y - originalPos.y) * (playerPos.y - originalPos.y));

                hsSystemOutput(string(distance) + "\n");

                if(distance <= 0.25f)
                {
                    return true;
                }
            }
        }
        else
        {
            distance = hsMathSqrt((playerPos.z - originalPos.z) * (playerPos.z - originalPos.z) + (playerPos.y - originalPos.y) * (playerPos.y - originalPos.y) + (playerPos.x - originalPos.x) * (playerPos.x - originalPos.x));

            if(distance <= 3.0f)
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
    }

    public void caughtAnimation()
    {
        if(isMagnet == false)
        {
            myItemSelf.SetPos(afterPos);
        }
        else
        {
            count++;
        }
    }
}
