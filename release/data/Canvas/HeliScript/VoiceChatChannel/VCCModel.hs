component VCCModel
{
    ChSBridge m_ChSBridge;
    
    VCCJoinUserTable m_JoinUserTable;
    VCCUserData m_SelfUserData;

    list<VCCChannelData> m_SpaceChannelList;
    list<VCCChannelData> m_ChannelList;
    
    int m_MaxSpacePage;
    int m_SpacePagerIndex;

    int m_MaxChannelPage;
    int m_ChannelPagerIndex;
    
    public VCCModel()
    {
        m_ChSBridge = system.Layer_GetComponentByName<ChSBridge>("vcc_icon_only_base");
        m_JoinUserTable = new VCCJoinUserTable();
        m_SelfUserData = new VCCUserData();

        m_SpaceChannelList = new list<VCCChannelData>();
        m_ChannelList = new list<VCCChannelData>();

        m_MaxSpacePage = 0;
        m_SpacePagerIndex = 0;

        m_MaxChannelPage = 0;
        m_ChannelPagerIndex = 0;

        // テスト用に仮で5にする
        m_MaxChannelPage = 5;
        m_MaxSpacePage = 5;
    }

    public void UpdateSelfUserData(string UserName, string IconURL, string UserCode, string UserType)
    {
        m_SelfUserData.UserName = UserName;
        m_SelfUserData.IconURL = IconURL;
        m_SelfUserData.UserCode = UserCode;
        m_SelfUserData.UserType = UserType;

        m_JoinUserTable.UpdateSelfUserData(m_SelfUserData);

        string current_channel_id;
        VCCChannelData CurrentChannel = m_ChSBridge.GetCurrentChannel();
        if(CurrentChannel !== null)
        {
            current_channel_id = CurrentChannel.ChannelId;
        }

        // 送信するデータを設定
        string SendData =
            "{" +
                "\"" + "current_channel_id"   + "\"" + ":" + "\"" + current_channel_id                          + "\"" + "," + 
                "\"" + "channel_session_code" + "\"" + ":" + "\"" + m_SelfUserData.ChannelSessionCode           + "\"" + "," + 
                "\"" + "user_code"            + "\"" + ":" + "\"" + m_SelfUserData.UserCode                     + "\"" + "," + 
                "\"" + "user_type"            + "\"" + ":" + "\"" + m_SelfUserData.UserType                     + "\"" + "," + 
                "\"" + "user_name"            + "\"" + ":" + "\"" + m_SelfUserData.UserName                     + "\"" + "," + 
                "\"" + "icon_url"             + "\"" + ":" + "\"" + m_SelfUserData.IconURL                      + "\"" + 
            "}"
        ;

        // UpdateDataを送信
        hsNetSendCustomData("VCC_Update_UserData", SendData);

        // チャンネル作成者か確認する
        hsCanvasResetToggleDefault("Toggle_VCC_Is_Channel_Creator");
        if(m_ChSBridge.IsChannelCreator(m_SelfUserData.UserCode))
        {
            hsCanvasToggleChange("Toggle_VCC_Is_Channel_Creator");
        }
    }

    // SpaceListとChannelListのFetch ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    public void OpenSpaceList()
    {
        m_SpacePagerIndex = 0;
        m_MaxSpacePage = 1;

        m_ChSBridge.FetchPosChannelList(-1, _OpenSpaceListCallback, false);
    }

    void _OpenSpaceListCallback(JsVal val)
    {
        // 最大ページ数を計算
        if(val === null || (val.GetType() != 1 && val.GetType() != 2))  return;

        list<JsProp> channel_prop_list = val.GetPropertyList();

        if(channel_prop_list.Count <= 0)
        {
            m_MaxSpacePage = 1;
        }
        else
        {
            m_MaxSpacePage = (channel_prop_list.Count - 1) / 6 + 1;
        }

        FetchSpaceList(0);
    }

    public void FetchSpaceList(int PagerIndex)
    {
        m_SpaceChannelList.Clear();

        m_SpacePagerIndex = PagerIndex;

        m_ChSBridge.FetchPosChannelList(PagerIndex, _fetchSpaceListCallback, true);
    }

    void _fetchSpaceListCallback(JsVal val)
    {
        if(val === null || (val.GetType() != 1 && val.GetType() != 2)) return;

        list<JsProp> channel_prop_list = val.GetPropertyList();

        for(int i = 0; i < channel_prop_list.Count; i++)
        {
            JsVal PositionChannel = channel_prop_list[i].GetValue();
            if(PositionChannel === null || (PositionChannel.GetType() != 1 && PositionChannel.GetType() != 2)) continue;

            VCCPositionChannel Channel = new VCCPositionChannel();

            if(Channel.Analyse(PositionChannel, false))
            {
                m_SpaceChannelList.Add(Channel.Data);
            }
        }

        VCCViewModel viewModel = system.Layer_GetComponentByName<VCCViewModel>("vcc_icon_only_base");
        if(viewModel !== null)
        {
            viewModel.ShowSpaceList(m_SpaceChannelList, m_SpacePagerIndex);
        }
    }

    public void UpdateSpacePager(int val)
    {
        m_SpacePagerIndex += val;

        if(m_SpacePagerIndex < 0) 
        {
            m_SpacePagerIndex = 0;
            
            return;
        }
        else if(m_SpacePagerIndex >= m_MaxSpacePage)
        {
            m_SpacePagerIndex = (m_MaxSpacePage - 1);

            return;
        }

        FetchSpaceList(m_SpacePagerIndex);
    }

    public void OpenChannelList()
    {
        m_ChannelPagerIndex = 0;
        m_MaxChannelPage = 1;

        m_ChSBridge.FetchChannelList(-1, _OpenChannelListCallback, false);
    }

    void _OpenChannelListCallback(JsVal val)
    {
        // 最大ページ数を計算
        if(val === null || (val.GetType() != 1 && val.GetType() != 2))  return;

        list<JsProp> channel_prop_list = val.GetPropertyList();

        if(channel_prop_list.Count <= 0)
        {
            m_MaxChannelPage = 1;
        }
        else
        {
            m_MaxChannelPage = (channel_prop_list.Count - 1) / 6 + 1;
        }

        FetchChannelList(0);
    }

    public void FetchChannelList(int PagerIndex)
    {
        m_ChannelList.Clear();

        m_ChannelPagerIndex = PagerIndex;

        m_ChSBridge.FetchChannelList(PagerIndex, _fetchChannelListCallback, true);
    }

    void _fetchChannelListCallback(JsVal val)
    {
        if(val === null || (val.GetType() != 1 && val.GetType() != 2))  return;

        list<JsProp> channel_prop_list = val.GetPropertyList();

        for(int i = 0; i < channel_prop_list.Count; i++)
        {
            if(m_ChSBridge.IsAllowMultiVoiceChannel())
            {
                JsVal VoiceChannel = channel_prop_list[i].GetValue();
                    if(VoiceChannel === null || (VoiceChannel.GetType() != 1 && VoiceChannel.GetType() != 2)) continue;

                    VCCVoiceChannel Channel = new VCCVoiceChannel();

                    if(Channel.Analyse(VoiceChannel, true))
                    {
                        m_ChannelList.Add(Channel.Data);
                    }
            }
            else
            {
                JsVal PositionChannel = channel_prop_list[i].GetValue();
                if(PositionChannel === null || (PositionChannel.GetType() != 1 && PositionChannel.GetType() != 2)) continue;

                VCCPositionChannel Channel = new VCCPositionChannel();

                if(Channel.Analyse(PositionChannel, true))
                {
                    m_ChannelList.Add(Channel.Data);
                }
            }
        }

        VCCViewModel viewModel = system.Layer_GetComponentByName<VCCViewModel>("vcc_icon_only_base");
        if(viewModel !== null)
        {
            viewModel.ShowChannelList(m_ChannelList, m_ChannelPagerIndex);
        }
    }

    public void UpdateChannelPager(int val)
    {
        m_ChannelPagerIndex += val;

        if(m_ChannelPagerIndex < 0) 
        {
            m_ChannelPagerIndex = 0;
            
            return;
        }
        else if(m_ChannelPagerIndex >= m_MaxChannelPage)
        {
            m_ChannelPagerIndex = (m_MaxChannelPage - 1);

            return;
        }

        FetchChannelList(m_ChannelPagerIndex);
    }
    
    // 入室 /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    public void EnterSpace(int SelectedSpaceIndex)
    {
        if(SelectedSpaceIndex >= 0 && SelectedSpaceIndex < m_SpaceChannelList.Count)
        {
            VCCChannelData Channel = m_SpaceChannelList[SelectedSpaceIndex];

            m_ChSBridge.EnterSpace(Channel.ChannelId);
        }
    }

    public void EnterChannel(string ChannelId)
    {
        m_ChSBridge.EnterChannel(ChannelId);
    }

    // 切断 /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    public void ExitSpace()
    {
        m_ChSBridge.ExitSpace();
    }
    
    public void ExitChannel()
    {
        m_ChSBridge.ExitChannel();
    }

    // チャンネル操作 ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    public void CreateNewChannel(string ChannelName, string SelectedChannelType)
    {
        m_ChSBridge.CreateNewChannel(ChannelName, SelectedChannelType);
    }

    public void UpdateChannel(string ChannelName, string SelectedChannelType)
    {
        m_ChSBridge.UpdateChannel(ChannelName, SelectedChannelType);
    }

    // Getter, Setter ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    public VCCUserData GetSelfUserData()
    {
        return m_SelfUserData;
    }

    public bool IsChannelCreator()
    {
        return m_ChSBridge.IsChannelCreator(m_SelfUserData.UserCode);
    }

    public list<VCCUserData> GetCurrentUserTable()
    {
        return m_JoinUserTable.Data;
    }
    
    public void InitUserTable(VCCChannelData Channel)
    {
        // UserTableをリセットする
        ClearUserTable();

        // チャンネル作成者のUserCodeを設定
        UpdateCreateUserCode(Channel.CreateUserCode);

        // 自身をユーザーテーブルに追加する
        Player SelfPlayer = hsPlayerGet();
        string peerid = SelfPlayer.GetID();

        m_SelfUserData.PlayerID = peerid;
        m_JoinUserTable.Add(m_SelfUserData);
    }

    public void AddSelfVoiceID(string VoiceID)
    {
        m_SelfUserData.VoiceID = VoiceID;

        string current_channel_id;
        VCCChannelData CurrentChannel = m_ChSBridge.GetCurrentChannel();
        if(CurrentChannel !== null)
        {
            current_channel_id = CurrentChannel.ChannelId;
        }

        // 送信するデータを設定
        string SendData =
            "{" +
                "\"" + "current_channel_id"   + "\"" + ":" + "\"" + current_channel_id                          + "\"" + "," + 
                "\"" + "voice_id"             + "\"" + ":" + "\"" + m_SelfUserData.VoiceID                      + "\"" + 
            "}"
        ;

        // UpdateDataを送信
        hsNetSendCustomData("VCC_Update_VoiceID", SendData);
    }

    public VCCChannelData GetCurrentChannel()
    {
        return m_ChSBridge.GetCurrentChannel();
    }

    public VCCChannelData GetSelectedChannel(int ChannelIndex)
    {
        if(ChannelIndex < 0 || ChannelIndex >= m_ChannelList.Count) return null;

        VCCChannelData Data = m_ChannelList[ChannelIndex];

        return Data;
    }

    public bool IsConnected()
    {
        return m_ChSBridge.IsConnected();
    }

    public string GetVCNumber()
    {
        return "";
    }

    public void ClearUserTable()
    {
        m_JoinUserTable.Clear();
    }

    public void UpdateCreateUserCode(string UserCode)
    {
        m_JoinUserTable.CreateUserCode = UserCode;
    }

    public string GetSelfUserCode()
    {
        return m_SelfUserData.UserCode;
    }

    // ネットワーク同期周り/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    public void ReConnectIfJoining(fVoidCallback callback)
    {
        m_ChSBridge.ReConnectIfJoining(callback);
    }

    public void ReConnectVoiceChannel()
    {
        m_ChSBridge.ReConnectVoiceChannel();
    }
    
    public void BroadcastVCData(string ID, string Data)
    {
        // 新規ユーザーが音声チャンネルに入室したので自身のデータをブロードキャストする
        VCCChannelData CurrentChannel = m_ChSBridge.GetCurrentChannel();

        // 音声チャンネルに入室していないなら何もしない
        if(CurrentChannel === null) return;

        string current_channel_id = CurrentChannel.ChannelId;

        if(current_channel_id.IsEmpty()) return;

        // 送信するデータを設定
        string SendData =
            "{" +
                "\"" + "current_channel_id"   + "\"" + ":" + "\"" + current_channel_id                          + "\"" + "," + 
                "\"" + "channel_session_code" + "\"" + ":" + "\"" + m_SelfUserData.ChannelSessionCode           + "\"" + "," + 
                "\"" + "user_code"            + "\"" + ":" + "\"" + m_SelfUserData.UserCode                     + "\"" + "," + 
                "\"" + "user_type"            + "\"" + ":" + "\"" + m_SelfUserData.UserType                     + "\"" + "," + 
                "\"" + "user_name"            + "\"" + ":" + "\"" + m_SelfUserData.UserName                     + "\"" + "," + 
                "\"" + "icon_url"             + "\"" + ":" + "\"" + m_SelfUserData.IconURL                      + "\"" + "," + 
                "\"" + "voice_id"             + "\"" + ":" + "\"" + m_SelfUserData.VoiceID                      + "\"" + 
            "}"
        ;

        // CreateDataを送信
        hsNetSendCustomData("VCC_Create_UserData", SendData);
    }

    public void ReceiveLeaveVC(string ID, string Data)
    {
        // ユーザーテーブルから該当プレイヤーを削除する
        for(int i = 0; i < m_JoinUserTable.Count; i++)
        {
            // PlayerIDかVoiceIDが同じなら削除する
            // CarnelianAgoraの時はIDがカーネリアン(座標)とアゴラ(音声)で分かれており、CarnelianAgoraはAgoraのLeaveの時にReceiveLeaveVCを呼ぶので場合分けする必要がある
            if(!ID.IsEmpty() && (ID == m_JoinUserTable.Data[i].PlayerID || ID == m_JoinUserTable.Data[i].VoiceID))
            {
                m_JoinUserTable.RemoveAt(i);
                m_JoinUserTable.DropUserDataStash(ID);

                break;
            }
        }
    }

    public void OnReceiveCustomState(string id, string type, string data)
    {
    }

    public void OnReceiveCustomData(string id, string type, string data)
    {
        // カーネリアンから初回入室時自身のCustomDataが『id: undefined』として送られてくるのでそれは無視する
        if(id == "undefined") return;

        if(type == "VCC_Create_UserData")
        {
            Json UserJson = hsLoadJson(data);
            if(UserJson === null) return;

            // 送られてきたdataが現在入室中の音声チャンネルのものかチェックする
            string current_channel_id;
            UserJson.FindValueString("current_channel_id", current_channel_id);

            VCCChannelData CurrentChannel = m_ChSBridge.GetCurrentChannel();
            if(CurrentChannel !== null)
            {
                // 一致しない場合は処理を抜ける
                if(CurrentChannel.ChannelId != current_channel_id)
                {
                    return;
                }
            }

            // ユーザーリストに含まれていなければ追加する
            for(int i = 0; i < m_JoinUserTable.Count; i++)
            {
                // ユーザーが既にテーブルに存在するので処理を抜ける
                if(m_JoinUserTable.Data[i].PlayerID == id)
                {
                    return;
                }
            }

            // Stashユーザーリストにも含まれていないかチェックする
            // Stashユーザーリストは一時非表示中のユーザーリスト
            // 新規ユーザーが入ってくると既存のユーザーにもユーザー情報が一斉送信されるのでここでチェックする必要がある
            for(int i = 0; i < m_JoinUserTable.StashData.Count; i++)
            {
                if(m_JoinUserTable.StashData[i].PlayerID == id)
                {
                    return;
                }
            }

            // dataを解析してユーザーを作成
            string channel_session_code;
            UserJson.FindValueString("channel_session_code", channel_session_code);

            string user_code;
            UserJson.FindValueString("user_code", user_code);

            string user_type;
            UserJson.FindValueString("user_type", user_type);

            string user_name;
            UserJson.FindValueString("user_name", user_name);

            string icon_url;
            UserJson.FindValueString("icon_url", icon_url);

            string voice_id;
            UserJson.FindValueString("voice_id", voice_id);

            VCCUserData User = new VCCUserData();
            User.PlayerID = id;
            User.VoiceID = voice_id;
            User.ChannelSessionCode = channel_session_code;
            User.UserCode = user_code;
            User.UserType = user_type;
            User.UserName = user_name;
            User.IconURL = icon_url;

            m_JoinUserTable.Add(User);
        }
        else if(type == "VCC_Update_UserData")
        {
            Json UserJson = hsLoadJson(data);
            if(UserJson === null) return;

           // 送られてきたdataが現在入室中の音声チャンネルのものかチェックする
            string current_channel_id;
            UserJson.FindValueString("current_channel_id", current_channel_id);

            VCCChannelData CurrentChannel = m_ChSBridge.GetCurrentChannel();
            if(CurrentChannel !== null)
            {
                // 一致しない場合は処理を抜ける
                if(CurrentChannel.ChannelId != current_channel_id)
                {
                    return;
                }
            }

            // ユーザーリストに含まれていればテーブル上のそのユーザーデータを更新する
            int UserIndex = -1;
            for(int i = 0; i < m_JoinUserTable.Count; i++)
            {
                if(m_JoinUserTable.Data[i].PlayerID == id)
                {
                    UserIndex = i;

                    break;
                }
            }

            // ユーザーが見つからなかったので処理を抜ける
            if(UserIndex == -1) return;

            // dataを解析してユーザーデータを更新
            string channel_session_code;
            UserJson.FindValueString("channel_session_code", channel_session_code);

            string user_code;
            UserJson.FindValueString("user_code", user_code);

            string user_type;
            UserJson.FindValueString("user_type", user_type);

            string user_name;
            UserJson.FindValueString("user_name", user_name);

            string icon_url;
            UserJson.FindValueString("icon_url", icon_url);

            m_JoinUserTable.UpdateUserData(UserIndex, channel_session_code, user_code, user_type, user_name, icon_url);
        }
        else if(type == "VCC_Update_VoiceID")
        {
            Json UserJson = hsLoadJson(data);
            if(UserJson === null) return;

           // 送られてきたdataが現在入室中の音声チャンネルのものかチェックする
            string current_channel_id;
            UserJson.FindValueString("current_channel_id", current_channel_id);

            VCCChannelData CurrentChannel = m_ChSBridge.GetCurrentChannel();
            if(CurrentChannel !== null)
            {
                // 一致しない場合は処理を抜ける
                if(CurrentChannel.ChannelId != current_channel_id)
                {
                    return;
                }
            }

            // ユーザーリストに含まれていればテーブル上のそのユーザーデータを更新する
            int UserIndex = -1;
            for(int i = 0; i < m_JoinUserTable.Count; i++)
            {
                if(m_JoinUserTable.Data[i].PlayerID == id)
                {
                    UserIndex = i;

                    break;
                }
            }

            // ユーザーが見つからなかったので処理を抜ける
            if(UserIndex == -1) return;

            // dataを解析してユーザーデータを更新
            string voice_id;
            UserJson.FindValueString("voice_id", voice_id);

            m_JoinUserTable.Data[UserIndex].VoiceID = voice_id;
        }
        else if(type == "VCC_Update_Space")
        {
            string SpaceName = data;

            if(SpaceName.IsEmpty()) return;

            m_ChSBridge.UpdateSpaceName(SpaceName);
        }
        else if(type == "VCC_Update_Channel")
        {
            string ChannelName = data;

            if(ChannelName.IsEmpty()) return;

            m_ChSBridge.UpdateChannelName(ChannelName);
        }
        else if(type == "VCC_RemovePlayer")
        {
            // キック対象のUserCodeが自身のものと一致していれば強制的に退出処理を実行する
            if(!data.IsEmpty() && m_SelfUserData.UserCode == data)
            {
                LayerBundle layer = hsLayerGet("vcc_icon_only_base");
                if(layer !== null)
                {
                    layer.CallComponentMethod("VCCViewModel", "ExitChannel", "");
                }
            }
        }
        else if(type == "VCC_Push_UserData_Stash")
        {
            // 指定のUserCodeのユーザーをボイスチャンネルユーザーリストから除外しStashDataに入れる
            if(!data.IsEmpty() && m_SelfUserData.UserCode == data)
            {
                m_JoinUserTable.PushUserDataStash(id);
            }
        }
        else if(type == "VCC_Apply_UserData_Stash")
        {
            // 指定のUserCodeのユーザーをStashDataからボイスチャンネルユーザーリストに戻す
            if(!data.IsEmpty() && m_SelfUserData.UserCode == data)
            {
                m_JoinUserTable.ApplyUserDataStash(id);
            }
        }
    }

    // プレイヤーのMicStateの更新を受信
    public void OnUpdatedPlayerMicState(string ID, int MicState)
    {
        Player SelfPlayer = hsPlayerGet();
        string SelfPeerid = SelfPlayer.GetID();

        for(int i = 0; i < m_JoinUserTable.Count; i++)
        {
            if(m_JoinUserTable.Data[i].PlayerID == ID)
            {
                m_JoinUserTable.Data[i].SetMicState(MicState);

                return;
            }

            if(ID == SelfPeerid)
            {
                m_JoinUserTable.Data[i].SetMicState(MicState);

                return;
            }
        }
    }

    // 指定されたユーザーをキックしインゲーム(RTC)から強制退出させる
    public void RemovePlayer(string UserCode)
    {
        hsNetSendCustomData("VCC_RemovePlayer", UserCode);
    }

    // 指定されたユーザーをブロックする. ボイスチャンネルユーザーリストから除外しStashDataに入れる
    public void Block(string UserCode)
    {
        for(int i = 0; i < m_JoinUserTable.Count; i++)
        {
            if(m_JoinUserTable.Data[i].UserCode == UserCode)
            {
                m_JoinUserTable.PushUserDataStash(m_JoinUserTable.Data[i].PlayerID);

                hsNetSendCustomData("VCC_Push_UserData_Stash", UserCode);

                break;
            }
        }
    }

    // 指定されたユーザーをアンブロックする. StashDataからボイスチャンネルユーザーリストに復帰する
    public void UnBlock(string UserCode)
    {
        for(int i = 0; i < m_JoinUserTable.StashData.Count; i++)
        {
            if(m_JoinUserTable.StashData[i].UserCode == UserCode)
            {
                m_JoinUserTable.ApplyUserDataStash(m_JoinUserTable.StashData[i].PlayerID);

                hsNetSendCustomData("VCC_Apply_UserData_Stash", UserCode);

                break;
            }
        }
    }

    // 指定されたユーザーを一時的にブロックする(名前とアイコン表示をグレーアウトする)
    public void BlockTemporary(string UserCode)
    {
        for(int i = 0; i < m_JoinUserTable.Count; i++)
        {
            if(m_JoinUserTable.Data[i].UserCode == UserCode)
            {
                m_JoinUserTable.Data[i].ShowTempBlockUI(true);

                hsNetSendCustomData("VCC_Push_UserData_Stash", UserCode);

                break;
            }
        }
    }

    // 一時ブロックの解除
    public void UnBlockTemporary(string UserCode)
    {
        for(int i = 0; i < m_JoinUserTable.Count; i++)
        {
            if(m_JoinUserTable.Data[i].UserCode == UserCode)
            {
                m_JoinUserTable.Data[i].ShowTempBlockUI(false);

                hsNetSendCustomData("VCC_Apply_UserData_Stash", UserCode);

                break;
            }
        }
    }
}