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
