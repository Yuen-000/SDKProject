class TCMessageList
{
    public list<TCMessageData> DataList;
    public bool IsTextChatTab;
    public int Count;

    int m_MaxMessgaeCount;
    bool m_IsLong;

    public TCMessageList()
    {
        DataList = new list<TCMessageData>();
        IsTextChatTab = true;
        Count = 0;

        m_MaxMessgaeCount = 20;
        m_IsLong = false;
    }

    public void Clear()
    {
        for(int i = 0; i < DataList.Count; i++)
        {
            DataList[i].Release(IsTextChatTab);
        }

        DataList.Clear();
    }

    public void Add(TCMessageData message)
    {
        if(DataList.Count >= m_MaxMessgaeCount)
        {
            // メッセージが最大数よりも多いので一番古いメッセージをリリースする
            DataList[0].Release(IsTextChatTab);
            DataList.RemoveAt(0);
        }

        // メッセージを追加する
        if(!message.Load(0, DataList, IsTextChatTab, m_IsLong))
        {
            message.Release(IsTextChatTab);

            return;
        }

        DataList.Add(message);

        Count = DataList.Count;

        // 位置を更新
        for(int i = 0; i < DataList.Count; i++)
        {
            int Order = (DataList.Count - 1) - i;
            DataList[i].UpdateGUIPos(Order, DataList, IsTextChatTab, m_IsLong);
        }
    }

    public void RemoveAt(int index)
    {
        if(index < 0 || index >= DataList.Count) return;

        DataList[index].Release(IsTextChatTab);
        DataList.RemoveAt(index);

        Count = DataList.Count;

        // 位置を更新
        for(int i = 0; i < DataList.Count; i++)
        {
            int Order = (DataList.Count - 1) - i;
            DataList[i].UpdateGUIPos(Order, DataList, IsTextChatTab, m_IsLong);
        }
    }

    public void SwitchShortLong(bool IsLong)
    {
        m_IsLong = IsLong;

        // 位置を更新
        for(int i = 0; i < DataList.Count; i++)
        {
            int Order = (DataList.Count - 1) - i;
            DataList[i].UpdateGUIPos(Order, DataList, IsTextChatTab, m_IsLong);
        }

        // Maskサイズを変更
        _ResizeLayerMask(false);
        _ResizeLayerMask(true);
    }

    void _ResizeLayerMask(bool IsPortrait)
    {
        string layerName = (IsTextChatTab)? "textchat_message_chat" : "textchat_message_system";
        
        if(IsPortrait)
        {
            if(IsTextChatTab)
            {
                if(m_IsLong)
                {
                    system.Canvas_SetLayerMaskPos(layerName, IsPortrait, -32,-120);
                    system.Canvas_SetLayerMaskSize(layerName, IsPortrait, 1250,1420);
                }
                else
                {
                    system.Canvas_SetLayerMaskPos(layerName, IsPortrait, -32,-565);
                    system.Canvas_SetLayerMaskSize(layerName, IsPortrait, 1250,535);
                }
            }
            else
            {
                if(m_IsLong)
                {
                    system.Canvas_SetLayerMaskPos(layerName, IsPortrait, -32,-60);
                    system.Canvas_SetLayerMaskSize(layerName, IsPortrait, 1250,1500);
                }
                else
                {
                    system.Canvas_SetLayerMaskPos(layerName, IsPortrait,-32,-500);
                    system.Canvas_SetLayerMaskSize(layerName, IsPortrait, 1250,650);
                }
            }
        }
        else
        {
            if(IsTextChatTab)
            {
                system.Canvas_SetLayerMaskPos(layerName, IsPortrait, -275,-25);
                system.Canvas_SetLayerMaskSize(layerName, IsPortrait, 275,360);
            }
            else
            {
                system.Canvas_SetLayerMaskPos(layerName, IsPortrait, -275,15);
                system.Canvas_SetLayerMaskSize(layerName, IsPortrait, 275,440);
            }
        }
    }
}