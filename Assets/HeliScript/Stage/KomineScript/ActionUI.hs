component ActionUI
{
    //UI�摜���ue
    Item myActionUIArrowU;

    //UI�摜���
    Item myActionUIArrowL;

    //UI�摜���E
    Item myActionUIArrowR;

    //UI�摜�Ŕ�
    Item myActionUISign;

    //�A�ŃA�N�V��������
    bool isActionTime;

    //Player�N���X
    Player  myPlayer;

    //���g
    Item myItemSelf;

    //�A�ŃA�N�V�����̃t���[��
    int actionFrame;

    //�A�ŃA�N�V�����J�n����Z���W
    float actionZ;

    //�Ŕ��o�Ă���̂ɂ����鎞��
    int SIGN_APPEARTIME;

    //�Ŕ̏o�Ă���^�C�~���O�̃Y��
    int SIGN_OFFSET;

    //�Ŕ̏o�Ă���Z���W�I�t�Z�b�g
    float SIGN_Z_OFFSET;

    //�Ŕ̏o�Ă���Z���W�Ԋu
    float SIGN_Z_INTERVAL;

    //�Ŕ�X���W�i���j
    float SIGN_LEFT_X;

    //�Ŕ�X���W�i�E�j
    float SIGN_RIGHT_X;

    //�Ŕ�Y���W
    float SIGN_Y;

    //�Ŕ��o�Ă���Ƃ��ɓ��������i���j
    float SIGN_LEFT_MOVELENGTH;

    //�Ŕ��o�Ă���Ƃ��ɓ��������i�E�j
    float SIGN_RIGHT_MOVELENGTH;

    //�Ŕ̖���
    int SIGN_NUMMAX;

    public ActionUI()
    {
        hsSystemOutput("Script:ActionUI\n");
        hsSystemOutput("Date:20241019\n");
        hsSystemOutput("Version:2.0.2\n");
        hsSystemOutput("Update Content:Remove button functions\n");

        myActionUIArrowU = hsItemGet("ActionUIArrowU");
        myActionUIArrowL = hsItemGet("ActionUIArrowL");
        myActionUIArrowR = hsItemGet("ActionUIArrowR");

        isActionTime = false;

        myPlayer = new Player();
        myPlayer = hsPlayerGet();

        myItemSelf = hsItemGetSelf();

        actionFrame = 0;

        SIGN_APPEARTIME = myItemSelf.GetProperty("SIGN_APPEARTIME").ToInt();
        SIGN_OFFSET = myItemSelf.GetProperty("SIGN_OFFSET").ToInt();
        SIGN_Z_OFFSET = myItemSelf.GetProperty("SIGN_Z_OFFSET").ToFloat();
        SIGN_Z_INTERVAL = myItemSelf.GetProperty("SIGN_Z_INTERVAL").ToFloat();
        SIGN_LEFT_X = myItemSelf.GetProperty("SIGN_LEFT_X").ToFloat();
        SIGN_RIGHT_X = myItemSelf.GetProperty("SIGN_RIGHT_X").ToFloat();
        SIGN_Y = myItemSelf.GetProperty("SIGN_Y").ToFloat();
        SIGN_LEFT_MOVELENGTH = myItemSelf.GetProperty("SIGN_LEFT_MOVELENGTH").ToFloat();
        SIGN_RIGHT_MOVELENGTH = myItemSelf.GetProperty("SIGN_RIGHT_MOVELENGTH").ToFloat();
        SIGN_NUMMAX = myItemSelf.GetProperty("SIGN_NUMMAX").ToInt();
    }

    public void Update()
    {
        if(isActionTime)
        {
            for(int i = 0; i < SIGN_NUMMAX; i++)
            {
                myActionUISign = hsItemGet("ActionUISign" + string(i));
                setSignPos(myActionUISign,i);
            }

            actionFrame++;
        }
    }

    public void setSignPos(Item sign, int num)
    {
        
        if(actionFrame < SIGN_OFFSET * num)
        {
            Vector3 pos = new Vector3();

            if(num % 2 == 0)
            {
                pos.x = -SIGN_LEFT_MOVELENGTH + SIGN_LEFT_X;    
            }
            else
            {
                pos.x = -SIGN_RIGHT_MOVELENGTH + SIGN_RIGHT_X;    
            }

            pos.y = SIGN_Y;

            pos.z = actionZ + float(num / 2) * SIGN_Z_INTERVAL + SIGN_Z_OFFSET;

            sign.SetPos(pos);
        }
        else if(actionFrame < SIGN_OFFSET * num + SIGN_APPEARTIME)
        {
            Vector3 pos = new Vector3();

            if(num % 2 == 0)
            {
                pos.x = -SIGN_LEFT_MOVELENGTH + SIGN_LEFT_X + SIGN_LEFT_MOVELENGTH * (actionFrame - SIGN_OFFSET * num) / SIGN_APPEARTIME;
            }
            else
            {
                pos.x = -SIGN_RIGHT_MOVELENGTH + SIGN_RIGHT_X + SIGN_RIGHT_MOVELENGTH * (actionFrame - SIGN_OFFSET * num) / SIGN_APPEARTIME;
            }

            pos.y = SIGN_Y;

            pos.z = actionZ + float(num / 2) * SIGN_Z_INTERVAL + SIGN_Z_OFFSET;

            sign.SetPos(pos);
        }
        else if(actionFrame == SIGN_OFFSET * num + SIGN_APPEARTIME)
        {
            Vector3 pos = new Vector3();

            if(num % 2 == 0)
            {
                pos.x = SIGN_LEFT_X;
            }
            else
            {
                pos.x = SIGN_RIGHT_X;
            }

            pos.y = SIGN_Y;

            pos.z = actionZ + float(num / 2) * SIGN_Z_INTERVAL + SIGN_Z_OFFSET;

            hsSystemOutput(string(num) + "=" +string(pos.z));

            sign.SetPos(pos);
        }
    }

    public void startActionTime(string actionZCoor){
        if(!isActionTime){
            isActionTime = true;
            actionFrame = 0;
            hsSystemOutput("Button starts Action Time!\n");
            actionZ = actionZCoor.ToFloat();
            hsSystemOutput(actionZCoor +  " & " + string(actionZ)+"\n");
        }
    }

    public void endActionTime(){
        if(isActionTime){
            isActionTime = false;
            actionFrame = 0;
            for(int i = 0; i < SIGN_NUMMAX; i++)
            {
                myActionUISign = hsItemGet("ActionUISign" + string(i));
                myActionUISign.SetShow(false);
                Vector3 pos = new Vector3();
                pos.x = 0;
                pos.y = -1;
                pos.z = -10;
                myActionUISign.SetPos(pos);
            }
            hsSystemOutput("Button ends Action Time!\n");
        }
    }
}
