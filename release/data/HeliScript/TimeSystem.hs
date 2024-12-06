component TimeSystem
{
    //タイマのアイテム
    Item timer;
    Item resultTimer;
    Item gameOverItem;

    //タイムの上限
    int limitTime;
    int countTime;
    int decreaseTime;

    //カウントのトリガー
    bool isCount;

    public TimeSystem()
    {
        timer = hsItemGet("Timer");
        limitTime = timer.GetProperty("Time(12345)").ToInt();

        decreaseTime = timer.GetProperty("ReduceTime(123)").ToInt();

        resultTimer = hsItemGet("ResultTimer");

        gameOverItem = hsItemGet("GameoverScript");

        countTime = limitTime;

        StartCountTimer();
    }

    public void Update()
    {
        if(isCount)
        {
            CountTime();
        }
    }

    //タイムをカウント
    void CountTime()
    {
        if(countTime >= 0)
        {
            countTime = countTime - 1 * hsSystemGetDeltaTime();
            TimeUI();
        }
        else if(countTime < 0)
        {
            countTime = 0;
            StopCountTimer();
            PlayerGameOver();
        }
    }

    //カウントをスタート
    void StartCountTimer()
    {
        isCount = true;
    }

    //カウントを停止
    public void StopCountTimer()
    {
        isCount = false;
    }

    //タイマのリセット
    public void ResetTimmer()
    {
        countTime = limitTime;
        StartCountTimer();
    }

    //ゲームオーバーを呼ぶ
    void PlayerGameOver()
    {
        gameOverItem.CallComponentMethod("GameOver", "GetGameOver", "");
    }

    //時間をマイナスdecreaseTimeにする
    public void ReduceTime()
    {
        countTime = countTime - decreaseTime;
    }

///////////////////////////////////////////////
//タイムの表示関係
//////////////////////////////////////////////

    //タイムのUI
    void TimeUI()
    {
        timer.WriteTextPlane(FormatMilliseconds(countTime));
    }

    //リザルトUIのタイマ
    public void ResultTimeUI()
    {
        resultTimer.WriteTextPlane(FormatMilliseconds(countTime));
    }

    //時間の計算
    string FormatMilliseconds(int timeSeconds)
    {
        string result;

        // ミリ秒から分を計算
        int minutes = (timeSeconds / 6000);
        // 残りのミリ秒から秒を計算
        int seconds = (timeSeconds / 100) % 60;

        //mm:ss の形式でフォーマット
        result = ZeroPadding(minutes, 1) + ":" + ZeroPadding(seconds, 2);

        return result;
    }

    //指定した文字数分0で埋める関数
    string ZeroPadding(int time, int length)
    {
        string result = time.ToString();

        //timeとして渡した0で埋めたい数字と、0埋めする長さを比較して、
        //0埋めする長さの方が大きければその分0を文字列に追加する
        if(result.Length() < length)
        {
            string seriesOfZeros = "";

            for(int i = 0; i < length - result.Length(); i++)
            {
                seriesOfZeros += "0";
            }
            result = seriesOfZeros + result;
        }
        return result;
    }
}
