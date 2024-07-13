const string TC_MESSAGE_TYPE_TEXT = "TC_MESSAGE_TYPE_TEXT";
const string TC_MESSAGE_TYPE_IMAGE = "TC_MESSAGE_TYPE_IMAGE";

class TCMessageData
{
    public string MessageType;

    public string Name;
    public string IconURL;
    public string Message;
    public string Timestamp;
    public bool   IsMine; // 今後自分のメッセージを反対側に表示する仕様が出てきたときに対応するための変数(ひとまず今はfalseしか入っていない)
    
    public string ChannelSessionCode;
    public string UserCode; // uid, vket_id といった名称でJSONに書かれている英数字
    public string UserType; // login or guest

    TCTextMessageGUI TextGUI;
    TCImageMessageGUI ImageGUI;
    
    public TCMessageData()
    {
        IsMine = false;
        MessageType = TC_MESSAGE_TYPE_TEXT;

        TextGUI = new TCTextMessageGUI();
        ImageGUI = new TCImageMessageGUI();
    }

    public bool Load(int Order, list<TCMessageData> DataList, bool IsTextChatTab, bool IsLong)
    {
        if(MessageType == TC_MESSAGE_TYPE_TEXT)
        {
            if(!TextGUI.Load(this, Order, DataList, IsTextChatTab, IsLong)) return false;
        }
        else if(MessageType == TC_MESSAGE_TYPE_IMAGE)
        {
            if(!ImageGUI.Load(this, Order, DataList, IsTextChatTab, IsLong)) return false;
        }

        return true;
    }

    public void Release(bool IsTextChatTab)
    {
        if(MessageType == TC_MESSAGE_TYPE_TEXT)
        {
            TextGUI.Release(IsTextChatTab);
        }
        else if(MessageType == TC_MESSAGE_TYPE_IMAGE)
        {
            ImageGUI.Release(IsTextChatTab);
        }
    }

    public void UpdateGUIPos(int Order, list<TCMessageData> DataList, bool IsTextChatTab, bool IsLong)
    {
        if(MessageType == TC_MESSAGE_TYPE_TEXT)
        {
            TextGUI.UpdateGUIPos(Order, DataList, IsTextChatTab, IsLong);
        }
        else if(MessageType == TC_MESSAGE_TYPE_IMAGE)
        {
            ImageGUI.UpdateGUIPos(Order, DataList, IsTextChatTab, IsLong);
        }
    }

    public int GetOffset()
    {
        int val = 0;

        if(MessageType == TC_MESSAGE_TYPE_TEXT)
        {
            val = TextGUI.GetOffset();
        }
        else if(MessageType == TC_MESSAGE_TYPE_IMAGE)
        {
            val = ImageGUI.GetOffset();
        }

        return val;
    }
}