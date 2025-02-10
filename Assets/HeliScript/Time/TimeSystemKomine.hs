component TimeSystemKomine
{
    //タイマのアイテム
    Item timer;
    Item resultTimer;
    Item gameOverItem;

    int counter;
    int TIME_MAX;
    int decreaseTime;

    //カウントのトリガー
    bool isCount;

    public TimeSystemKomine()
    {
        timer = hsItemGet("Timer");
        TIME_MAX = timer.GetProperty("TIME_MAX").ToInt() * 60;
        counter = TIME_MAX;
        decreaseTime = timer.GetProperty("ReduceTime").ToInt();
        resultTimer = hsItemGet("ResultTimer");

        isCount = false;

        //StartCountTimer();
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
        if(counter >= 0)
        {
            counter--;
            TimeUI();
        }
        else if(counter < 0)
        {
            counter = 0;
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
    public void ResetTimer()
    {
        counter = TIME_MAX;
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
        counter = counter - decreaseTime;
    }

///////////////////////////////////////////////
//タイムの表示関係
//////////////////////////////////////////////

    //タイムのUI
    void TimeUI()
    {
        timer.WriteTextPlane(FormatFrame(counter));
    }

    //リザルトUIのタイマ
    public void ResultTimeUI()
    {
        resultTimer.WriteTextPlane(FormatFrame(counter));
    }

    //時間の計算
    string FormatFrame(int frame)
    {
        string result;

        // フレームから分を計算
        int minutes = (frame / (60 * 60));
        // 残りのフレームから秒を計算
        int seconds = (frame / 60) % 60;

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
