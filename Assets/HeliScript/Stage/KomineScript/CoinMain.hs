component CoinMain
{
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

    //�A�j���[�V������̍��W�i�ʏ�p�j
    Vector3 afterPos;

    public CoinMain()
    {
        hsSystemOutput("Script:CoinMain\n");
        hsSystemOutput("Date:20241130\n");
        hsSystemOutput("Version:1.0.0\n");
        hsSystemOutput("Update Content:Create\n");

        hasCaught = false;

        myPlayerComponent = hsItemGet("PlayerSettings");
        playerPos = myPlayerComponent.GetPos();
        playerLane = 0;
        isMagnet = false;

        myItemSelf = hsItemGetSelf();
        originalPos = myItemSelf.GetPos();

        afterPos = originalPos;
        afterPos.y -= 5.0f;
    }

    public void Update()
    {
        if(hasCaught == false)
        {
            if(measureDistance())
            {
                hasCaught = true;
                caughtAnimation();
            }
        }
    }

    public bool measureDistance()
    {
        playerPos = myPlayerComponent.GetPos();

        playerLane = (myPlayerComponent.GetProperty("playerLane")).ToInt();

        string isMagnetStr = myPlayerComponent.GetProperty("isManget");

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
            
        }
        else
        {
        
        }
    }

    public void reset()
    {
        hasCaught = false;
        myItemSelf.SetPos(originalPos);
    }

    public void caughtAnimation()
    {
        myItemSelf.SetPos(afterPos);
    }
}
