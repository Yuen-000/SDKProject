component BGMStart
{
    //このアイテム
    Item myItem;

    //待つ時間
    int WAIT_TIME;

    //待つカウント
    int waitCount;

    //カウントを進めるか
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
