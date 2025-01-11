component MagnetMain
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
    //float angle;

    //����
    float distance;
    
    //�A�j���J�E���g
    int count;

    //�A�C�e���Ǘ��X�N���v�g
    //Item itemManagement;

    //���[���̋���
    float LANEDISTANCE;

    //�A�C�e���Q�b�g���ʉ�
    Item itemGetSE;

    //�X�s�[�h�A�b�v���ʉ�
    Item magnetSE;

    //�����̃A�C�e���ԍ�
    int magnetNum;

    //�擾�ł��鋗��
    float DISTANCE_NORMAL;

    //�擾�ł��鋗���i���΁j
    float DISTANCE_MAGNET;

    //���΃G�t�F�N�g
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
        hsSystemOutput("���Z�b�g����܂���\n");
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
