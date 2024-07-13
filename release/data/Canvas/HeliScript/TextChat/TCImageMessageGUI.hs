class TCImageMessageGUI
{
    string MessageID;

    public bool Load(TCMessageData Data, int Order, list<TCMessageData> DataList, bool IsTextChatTab, bool IsLong)
    {
        // UserCode・フレーム経過時間・Timestampの組み合わせをキーとして一意のMessageIDを決定する
        MessageID = Data.UserCode + "_" + "%d" % hsSystemGetTime() + "_" + Data.Timestamp;

        return true;
    }

     public void Release(bool IsTextChatTab)
    {
        _Release(false, IsTextChatTab);
        _Release(true, IsTextChatTab);
    }

    void _Release(bool IsPortrait, bool IsTextChatTab)
    {

    }

    public void UpdateGUIPos(int Order, list<TCMessageData> DataList, bool IsTextChatTab, bool IsLong)
    {

    }

    public int GetOffset()
    {
        int val = 0;

        return val;
    }

    string _ClampTimestamp(string src)
    {
        if(src.IsEmpty()) return src;

        // 年
        string year = src.SubString(0, 4);

        // 月
        string month = src.SubString(5, 2);

        // 日
        string day = src.SubString(8, 2);

        // 時
        string hour = src.SubString(11, 2);

        // 取得データとの時差が9時間あるようなのでそちらを考慮する
        int hour_integer = hour.ToInt();
        hour_integer += 9;
        hour = "%d" % hour_integer;

        // 分
        string minutes = src.SubString(14, 2);

        // 日時テキストを作成
        // string dst = year + "/" + month + "/" + day + " " + hour + ":" + minutes;
        // レイアウトやデザインが変わるのでひとまず時間だけ表示しておく
        string dst = hour + ":" + minutes;

        return dst;
    }
}