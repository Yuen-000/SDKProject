component CoinMain
{
    //Player�N���X
    Player  myPlayer;

    //���ꂽ��
    bool hasCaught;

    //���g�̃��[��
    int myLane;

    //�v���C���[�i�Ăяo���p�j
    Item myPlayerComponent;

    //�v���C���[�̍��W
    Vector3 playerPos;

    //�v���C���[�̃��[��
    int playerLane;

    //���Ώ�Ԃ�
    bool isMagnet;

    //���g�iproperty�擾�p�j
    Item myItemSelf;

    //���̍��W�i���Z�b�g�p�j
    Vector3 originalPos;

    //���̍��W
    Vector3 currentPos;

    //�A�j���[�V������̍��W�i�ʏ�p�j
    Vector3 afterPos;

    //��]
    float angle;

    //����
    float distance;
    
    //�A�j���J�E���g
    int count;

    //�R�C���Ǘ��X�N���v�g
    Item coinManagement;

    //���[���̋���
    float LANEDISTANCE;

    //���ʉ�
    Item coinSE;

    //�����̃R�C���ԍ�
    int coinNum;

    //�R�C�����擾�ł��鋗��
    float DISTANCE_NORMAL;

    //�R�C�����擾�ł��鋗���i���΁j
    float DISTANCE_MAGNET;

    public CoinMain()
    {
        hsSystemOutput("Script:CoinMain\n");
        hsSystemOutput("Date:20241202\n");
        hsSystemOutput("Version:1.2.0\n");
        hsSystemOutput("Update Content:Update Magnet\n");

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

        angle = originalPos.z / 5 * -10.0f;

        count = 0;

        coinManagement = hsItemGet("CoinManagement");

        coinNum = ((myItemSelf.GetName()).SubString(4,1)).ToInt();

        coinSE = hsItemGet("CoinSE" + string(coinNum % 10));

        hsSystemOutput(coinSE.GetName() + "\n");

        DISTANCE_NORMAL = (myPlayerComponent.GetProperty("DISTANCE_NORMAL")).ToFloat();

        DISTANCE_MAGNET = (myPlayerComponent.GetProperty("LANEDISTANCE")).ToFloat();
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
                coinManagement.CallComponentMethod("CoinManagement", "addCount", "");
                caughtAnimation();
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
                coinSE.Play();
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

        //�f�o�b�O�p
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
    }

    public void caughtAnimation()
    {
        if(isMagnet == false)
        {
            myItemSelf.SetPos(afterPos);
            coinSE.Play();
        }
        else
        {
            count++;
        }
    }
}