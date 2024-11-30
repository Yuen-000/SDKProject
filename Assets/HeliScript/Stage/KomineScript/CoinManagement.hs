component CoinManagement
{
    Item myCoin;
    Vector3 coinPos;
    int count;
    const int COINMAX = 2;

    public CoinManagement()
    {
        count = 0;
    }

    public void Update()
    {
        
    }

    public void addCount(string Num)
    {
        count++;
        hsSystemOutput("add\n");
        myCoin = hsItemGet("CoinPlane" + Num);
        hsSystemOutput(myCoin.GetName() +"\n");
        coinPos = myCoin.GetPos();
        coinPos.y = -5.0f;
        myCoin.SetPos(coinPos);
    }

    public void reset()
    {
        count = 0;

        for(int j = 0; j < COINMAX; j++){
            myCoin = hsItemGet("CoinPlane" + j.ToString());
            hsSystemOutput(myCoin.GetName() +"\n");
            coinPos = myCoin.GetPos();
            coinPos.y = 1.0f;
            myCoin.SetPos(coinPos);
        }
    }
}
