component BGMStart
{
    //���̃A�C�e��
    Item myItem;

    //�҂���
    int WAIT_TIME;

    //�҂J�E���g
    int waitCount;

    //�J�E���g��i�߂邩
    bool isCount;

    public BGMStart()
    {
        myItem = hsItemGetSelf();

        waitCount = 0;

        WAIT_TIME = int(myItem.GetProperty("WAIT_TIME").ToFloat() * 60.0f);

        isCount = true;
    }

    public void Update()
    {
        if(waitCount >= WAIT_TIME && isCount)
        {
           myItem.Play();
           isCount = false;
        }

        if(isCount){
            waitCount++;
        }
    }
}
