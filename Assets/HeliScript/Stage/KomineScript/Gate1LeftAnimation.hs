component Gate1LeftAnimation
{
    //���̃A�C�e��
    Item myItem;

    //�܂��Ă���Œ���
    bool isClosed;

    //�A�ŃJ�E���g
    bool actionCount;

    //�^�C�}�[
    int timer;

    //�A�ŃA�N�V�����N���A�ɂȂ��
    const int CLEAR_PRESS_COUNT = 25;

    //�A�ŃA�N�V�����������ԁi�t���[���P�ʁj
    const int TIME_LIMIT = 420;

    public Gate1LeftAnimation()
    {
        myItem = hsItemGetSelf;
        isClosed = false;
        actionCount = 0;
        timer = 0;
    }

    public void Update()
    {
        if(isClosed){
            timer++;
            if(timer >= TIME_LIMIT) reset();

            float doorX = -1.25 + 1.25 * hsMathCos(90.0f * timer / TIME_LIMIT * 3.14159265358979 / 180);
            float doorZ = 1.25 * hsMathSin(90.0f * timer / TIME_LIMIT * 3.14159265358979 / 180);
            Quaternion doorQuaternion = makeQuaternionYRotation(-90.0f * timer / TIME_LIMIT);

            myItem.SetPos(makeVector3(doorX - 2.50f,2.75f,doorZ + 50.0f));
            myItem.SetQuaternion(doorQuaternion);
        }
    }

    public void setClose()
    {
        isClosed = true;
    }

    public void setAction()
    {
    }

    public void reset()
    {
        isClosed = false;
        actionCount = 0;
        timer = 0;
    }
}
