class TCTextMessageGUI
{
    string MessageID;

    string chat_avatar_icon;
    string chat_balloon;
    string chat_name_text;
    string chat_time_text;
    string chat_message_text;

    public bool Load(TCMessageData Data, int Order, list<TCMessageData> DataList, bool IsTextChatTab, bool IsLong)
    {
        // UserCode・フレーム経過時間・Timestampの組み合わせをキーとして一意のMessageIDを決定する
        MessageID = Data.UserCode + "_" + "%d" % hsSystemGetTime() + "_" + Data.Timestamp;

        chat_avatar_icon = "chat_avatar_icon" + "_"  + MessageID;
        chat_balloon = "chat_balloon" + "_"  + MessageID;
        chat_name_text = "chat_name_text" + "_" + MessageID;
        chat_time_text = "chat_time_text" + "_" + MessageID;
        chat_message_text = "chat_message_text" + "_"  + MessageID;

        if(!_Load(Data, Order, DataList, false, -90, IsTextChatTab, IsLong)) return false;
        if(!_Load(Data, Order, DataList, true, -220, IsTextChatTab, IsLong)) return false;

        return true;
    }

    public void Release(bool IsTextChatTab)
    {
        _Release(false, IsTextChatTab);
        _Release(true, IsTextChatTab);
    }

    void _Release(bool IsPortrait, bool IsTextChatTab)
    {
        string layerName = (IsTextChatTab)? "textchat_message_chat" : "textchat_message_system";

        system.Canvas_ReleaseGUI(layerName, IsPortrait, chat_avatar_icon);
        system.Canvas_ReleaseGUI(layerName, IsPortrait, chat_balloon);
        system.Canvas_ReleaseGUI(layerName, IsPortrait, chat_name_text);
        system.Canvas_ReleaseGUI(layerName, IsPortrait, chat_time_text);
        system.Canvas_ReleaseGUI(layerName, IsPortrait, chat_message_text);
    }

    public void UpdateGUIPos(int Order, list<TCMessageData> DataList, bool IsTextChatTab, bool IsLong)
    {
        _UpdateGUIPos(Order, DataList, false, -90, IsTextChatTab, IsLong);
        _UpdateGUIPos(Order, DataList, true, -220, IsTextChatTab, IsLong);
    }

    public int GetOffset()
    {
        int val = 0;

        return val;
    }

    bool _Load(TCMessageData Data, int Order, list<TCMessageData> DataList, bool IsPortrait, int YOffset, bool IsTextChatTab, bool IsLong)
    {
        string layerName = (IsTextChatTab)? "textchat_message_chat" : "textchat_message_system";

        if(IsPortrait)
        {
            // if(Data.IsMine)
            // {
                
            // }
            // else
            {
                // 後ほど位置をChatBalloからの相対座標で書き換える

                if(IsTextChatTab)
                {
                    hsAddGUIButton(
                        layerName, IsPortrait, 
                        chat_avatar_icon, "", "", "", true, 1, -555, ((IsLong)? 450 : -450) + Order * YOffset, 120, 120, 0.5, 0.5, "CM", true, 0.0,
                        Data.IconURL, "", "", "", 0, 0, 300, 32, 0, 0, 0, 0, 0, 0, 0, 0
                    );

                    hsAddGUIButton(
                        layerName, IsPortrait, 
                        chat_balloon, "", "", "", true, 1, 30, ((IsLong)? 500 : -400) + Order * YOffset, 1200, 250, 0.5, 0.5, "CM", true, 0.0,
                        "gui2023/chat/chat_balloon.png", "", "", "", 0, 0, 300, 32, 0, 0, 0, 0, 0, 0, 0, 0
                    );

                    hsAddGUIText(
                        layerName, IsPortrait, 
                        chat_name_text, true, 1, -160, ((IsLong)? 400 : -500) + Order * YOffset, 560, 64, 0.5, 0.5, "CM", true, 0.0,
                        Data.Name, "", 35, 1.0, 1.0, 1.0, 1.0, "LM", 0, 0, false, false, 1.0, 1.0, 1.0, 1.0
                    );

                    hsAddGUIText(
                        layerName, IsPortrait, 
                        chat_time_text, true, 1, 480, ((IsLong)? 400 : -500) + Order * YOffset, 150, 72, 0.5, 0.5, "CM", true, 0.0,
                        _ClampTimestamp(Data.Timestamp), "", 40, 1.0, 1.0, 1.0, 1.0, "LM", 0, 0, false, false, 1.0, 1.0, 1.0, 1.0
                    );
                    
                    hsAddGUIText(
                        layerName, IsPortrait, 
                        chat_message_text, true, 2, 55, ((IsLong)? 500 : -400) + Order * YOffset, 975, 85, 0.5, 0.5, "CM", true, 0.0,
                        Data.Message, "", 30, 0.0, 0.0, 0.0, 1.0, "LT", 0, 0, true, true, 0.14, 0.38, 0.82, 1.0
                    );
                }
                else
                {
                    hsAddGUIButton(
                        layerName, IsPortrait, 
                        chat_balloon, "", "", "", true, 1, -20, ((IsLong)? 600 : -300) + Order * YOffset, 2200, 275, 0.5, 0.5, "CM", true, 0.0,
                        "gui2023/chat/chat_system_base.png", "", "", "", 0, 0, 300, 32, 0, 0, 0, 0, 0, 0, 0, 0
                    );

                    hsAddGUIText(
                        layerName, IsPortrait, 
                        chat_time_text, true, 1, -540, ((IsLong)? 500 : -400) + Order * YOffset, 150, 72, 0.5, 0.5, "CM", true, 0.0,
                        _ClampTimestamp(Data.Timestamp), "", 40, 1.0, 1.0, 1.0, 1.0, "LM", 0, 0, false, false, 1.0, 1.0, 1.0, 1.0
                    );

                    hsAddGUIText(
                        layerName, IsPortrait, 
                        chat_message_text, true, 2, -20, ((IsLong)? 610 : -290) + Order * YOffset, 1100, 120, 0.5, 0.5, "CM", true, 0.0,
                        Data.Message, "", 30, 0.0, 0.0, 0.0, 1.0, "LT", 0, 0, true, false, 0.14, 0.38, 0.82, 1.0
                    );
                }
            }
        }
        else
        {
            // if(Data.IsMine)
            // {
                
            // }
            // else
            {
                if(IsTextChatTab)
                {
                    hsAddGUIButton(
                        layerName, IsPortrait, 
                        chat_avatar_icon, "", "", "", true, 2, -370, 95 + Order * YOffset, 50, 50, 0.5, 0.5, "RM", true, 0.0,
                        Data.IconURL, "", "", "", 0, 0, 300, 32, 0, 0, 0, 0, 0, 0, 0, 0
                    );

                    hsAddGUIButton(
                        layerName, IsPortrait, 
                        chat_balloon, "", "", "", true, 2, -245, 125 + Order * YOffset, 220, 110, 0.5, 0.5, "RM", true, 0.0,
                        "gui2023/chat/chat_balloon.png", "", "", "", 0, 0, 300, 32, 0, 0, 0, 0, 0, 0, 0, 0
                    );

                    hsAddGUIText(
                        layerName, IsPortrait, 
                        chat_name_text, true, 2, -260, 87 + Order * YOffset, 140, 16, 0.5, 0.5, "RM", true, 0.0,
                        Data.Name, "", 10, 1.0, 1.0, 1.0, 1.0, "LM", 0, 0, false, false, 1.0, 1.0, 1.0, 1.0
                    );

                    hsAddGUIText(
                        layerName, IsPortrait, 
                        chat_time_text, true, 2, -170, 87 + Order * YOffset, 38, 18, 0.5, 0.5, "RM", true, 0.0,
                        _ClampTimestamp(Data.Timestamp), "", 10, 1.0, 1.0, 1.0, 1.0, "LM", 0, 0, false, false, 1.0, 1.0, 1.0, 1.0
                    );
                    
                    hsAddGUIText(
                        layerName, IsPortrait, 
                        chat_message_text, true, 5, -242, 125 + Order * YOffset, 175, 50, 0.5, 0.5, "RM", true, 0.0,
                        Data.Message, "", 10, 0.0, 0.0, 0.0, 1.0, "LT", 0, 0, true, true, 0.14, 0.38, 0.82, 1.0
                    );
                }
                else
                {
                    hsAddGUIButton(
                        layerName, IsPortrait, 
                        chat_balloon, "", "", "", true, 2, -270, 200 + Order * YOffset, 480, 100, 0.5, 0.5, "RM", true, 0.0,
                        "gui2023/chat/chat_system_base.png", "", "", "", 0, 0, 300, 32, 0, 0, 0, 0, 0, 0, 0, 0
                    );

                    hsAddGUIText(
                        layerName, IsPortrait, 
                        chat_time_text, true, 2, -375, 165 + Order * YOffset, 38, 18, 0.5, 0.5, "RM", true, 0.0,
                        _ClampTimestamp(Data.Timestamp), "", 10, 1.0, 1.0, 1.0, 1.0, "LM", 0, 0, false, false, 1.0, 1.0, 1.0, 1.0
                    );

                    hsAddGUIText(
                        layerName, IsPortrait, 
                        chat_message_text, true, 5, -270, 205 + Order * YOffset, 240, 50, 0.5, 0.5, "RM", true, 0.0,
                        Data.Message, "", 10, 0.0, 0.0, 0.0, 1.0, "LT", 0, 0, true, true, 0.14, 0.38, 0.82, 1.0
                    );
                }
            }
        }

        return true;
    }

    void _UpdateGUIPos(int Order, list<TCMessageData> DataList, bool IsPortrait, int YOffset, bool IsTextChatTab, bool IsLong)
    {
        string layerName = (IsTextChatTab)? "textchat_message_chat" : "textchat_message_system";

        if(IsPortrait)
        {
            // if(Data.IsMine)
            // {
                
            // }
            // else
            {
                // 後ほど位置をChatBalloからの相対座標で書き換える

                if(IsTextChatTab)
                {
                    hsCanvasSetGUIPos(layerName, IsPortrait, chat_avatar_icon, -555, ((IsLong)? 450 : -450) + Order * YOffset);
                    hsCanvasSetGUIPos(layerName, IsPortrait, chat_balloon, 30, ((IsLong)? 500 : -400) + Order * YOffset);
                    hsCanvasSetGUIPos(layerName, IsPortrait, chat_name_text, -160, ((IsLong)? 400 : -500) + Order * YOffset);
                    hsCanvasSetGUIPos(layerName, IsPortrait, chat_time_text, 480, ((IsLong)? 400 : -500) + Order * YOffset);
                    hsCanvasSetGUIPos(layerName, IsPortrait, chat_message_text, 55, ((IsLong)? 500 : -400) + Order * YOffset);
                }
                else
                {
                    hsCanvasSetGUIPos(layerName, IsPortrait, chat_balloon, -20, ((IsLong)? 600 : -300) + Order * YOffset);
                    hsCanvasSetGUIPos(layerName, IsPortrait, chat_time_text, -540, ((IsLong)? 500 : -400) + Order * YOffset);
                    hsCanvasSetGUIPos(layerName, IsPortrait, chat_message_text, -20, ((IsLong)? 610 : -290) + Order * YOffset);
                }
            }
        }
        else
        {
            // if(Data.IsMine)
            // {
                
            // }
            // else
            {
                if(IsTextChatTab)
                {
                    hsCanvasSetGUIPos(layerName, IsPortrait, chat_avatar_icon, -370, 95 + Order * YOffset);
                    hsCanvasSetGUIPos(layerName, IsPortrait, chat_balloon, -245, 125 + Order * YOffset);
                    hsCanvasSetGUIPos(layerName, IsPortrait, chat_name_text, -260, 87 + Order * YOffset);
                    hsCanvasSetGUIPos(layerName, IsPortrait, chat_time_text, -170, 87 + Order * YOffset);
                    hsCanvasSetGUIPos(layerName, IsPortrait, chat_message_text, -242, 125 + Order * YOffset);
                }
                else
                {
                    hsCanvasSetGUIPos(layerName, IsPortrait, chat_balloon, -270, 200 + Order * YOffset);
                    hsCanvasSetGUIPos(layerName, IsPortrait, chat_time_text, -375, 165 + Order * YOffset);
                    hsCanvasSetGUIPos(layerName, IsPortrait, chat_message_text, -270, 205 + Order * YOffset);
                }
            }
        }
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