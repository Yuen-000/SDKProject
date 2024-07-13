// 座標チャンネルと音声チャンネルが1対1の時のModel

fVoidCallback g_TempSingleVCCConnectCallback;

component ChSModelSingle
{
    ChSBridge m_ChSBridge;
    ChSJoinProcessSingle m_JoinProcess;

    VCCChannelData m_CurrentChannel;

    bool m_IsConnected;

    string m_TempHelConnectChannelId;
    bool m_TempRequiredTickets;

    public ChSModelSingle()
    {
        m_ChSBridge = system.Layer_GetComponentByName<ChSBridge>("vcc_icon_only_base");
        m_JoinProcess = system.Layer_GetComponentByName<ChSJoinProcessSingle>("vcc_icon_only_base");

        m_CurrentChannel = null;

        m_IsConnected = false;
    }

    // 初回入室処理と入室失敗処理を登録
    public void RegistJointProcess()
    {
        // 初回座標チャンネル入室処理
        string FirstPosChannelJoinType = hsNetGetFirstPosJoin();
        if(FirstPosChannelJoinType.IsEmpty())
        {
            FirstPosChannelJoinType = CHANNEL_JOIN_TYPE_USE_URL_ROOMID;
        }

        // 初回座標チャンネル入室処理
        if(FirstPosChannelJoinType == CHANNEL_JOIN_TYPE_USE_URL_ROOMID)
        {
            g_FirstJoinFunc = m_JoinProcess.JoinFromURLRoomID;
            g_IsAvailableFunc = m_JoinProcess.CheckUserCount;
        }
        else if(FirstPosChannelJoinType == CHANNEL_JOIN_TYPE_RANDOM_CHANNEL)
        {
            g_FirstJoinFunc = m_JoinProcess.JoinRandomFreeTalk;
            g_IsAvailableFunc = m_JoinProcess.CheckUserCount;
        }
        else if(FirstPosChannelJoinType == CHANNEL_JOIN_TYPE_SELECT_ANY_CHANNEL)
        {
            g_FirstJoinFunc = m_JoinProcess.JoinSelectedAnyRoom;
            g_IsAvailableFunc = m_JoinProcess.CheckUserCount;
        }
        else if(FirstPosChannelJoinType == CHANNEL_JOIN_TYPE_CREATE_NEW_RANDOM_CHANNEL)
        {
            g_FirstJoinFunc = m_JoinProcess.JoinNewRoom;
            g_IsAvailableFunc = m_JoinProcess.CheckUserCount;
        }
        else if(FirstPosChannelJoinType == CHANNEL_JOIN_TYPE_CUSTOM)
        {
            g_FirstJoinFunc = m_JoinProcess.FirstJoinCustom;
            g_IsAvailableFunc = m_JoinProcess.CheckUserCount;
        }

        // 座標チャンネル入室失敗時の処理
        string FailedPosChannelJoinType = hsNetGetFailedPosJoin();
        if(FailedPosChannelJoinType.IsEmpty())
        {
            FailedPosChannelJoinType = CHANNEL_JOIN_TYPE_RANDOM_CHANNEL;
        }

        if(FailedPosChannelJoinType == CHANNEL_JOIN_TYPE_RANDOM_CHANNEL)
        {
            g_FailedJoinFunc = m_JoinProcess.JoinRandomFreeTalk;
        }
        else if(FailedPosChannelJoinType == CHANNEL_JOIN_TYPE_SELECT_ANY_CHANNEL)
        {
            g_FailedJoinFunc = m_JoinProcess.JoinSelectedAnyRoom;
        }
        else if(FailedPosChannelJoinType == CHANNEL_JOIN_TYPE_CREATE_NEW_RANDOM_CHANNEL)
        {
            g_FailedJoinFunc = m_JoinProcess.JoinNewRoom;
        }
        else if(FailedPosChannelJoinType == CHANNEL_JOIN_TYPE_REDIRECT_TO_OUTGAME)
        {
            g_FailedJoinFunc = m_JoinProcess.RedirectToOutGame;
        }
        else if(FailedPosChannelJoinType == CHANNEL_JOIN_TYPE_CUSTOM)
        {
            g_FirstJoinFunc = m_JoinProcess.FailedJoinCustom;
        }
    }

    // Getter・Setter //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    public bool IsConnected()
    {
        return m_IsConnected;
    }

    public bool IsChannelCreator(string SelfUserCode)
    {
        if(m_CurrentChannel === null) return false;

        string CreateUserCode = m_CurrentChannel.CreateUserCode;
        bool IsCreator = (!CreateUserCode.IsEmpty() && CreateUserCode == SelfUserCode);

        return IsCreator;
    }

    public VCCChannelData GetCurrentChannel()
    {
        return m_CurrentChannel;
    }

    public void UpdateChannelName(string ChannelName)
    {
        m_CurrentChannel.ChannelName = ChannelName;
        
        VCCViewModel viewModel = system.Layer_GetComponentByName<VCCViewModel>("vcc_icon_only_base");
        if(viewModel !== null)
        {
            viewModel.UpdateConnectStatus(m_CurrentChannel, 0, true, false);
        }
    }

    // ChannelListのFetch ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    public void FetchChannelList(int PagerIndex, fJsValCallback callback, bool UseOffset)
    {
        // int offset = 6 * PagerIndex;
        // int limit = 6;

        // JsVal params = hsCommonMakeParams();
        // if(UseOffset)
        // {
        //     hsCommonAddParamNumber(params, "offset", offset);
        //     hsCommonAddParamNumber(params, "limit", limit);
        // }

        // hsCommonAddParamBool(params, "excludeEmptyChannelFlg", hsNetExcludeEmptyChannel());

        // // 座標チャンネルリストを表示
        // hel_net_get_position_channel_list(callback, hsNetGetSpatiumCode(), hsGetCurrentWorldId(), params);

        if(UseOffset)
        {
            hel_net_get_position_channel_list(callback, hsNetGetSpatiumCode(), hsGetCurrentWorldId(), 6 * PagerIndex, 6, hsNetExcludeEmptyChannel());
        }
        else
        {
            hel_net_get_position_channel_list(callback, hsNetGetSpatiumCode(), hsGetCurrentWorldId(), 0, -1, hsNetExcludeEmptyChannel());
        }
    }

    // 座標チャンネル入室処理 /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    public void FirstEnterChannel()
    {
        JsVal val = makeJsObj();
        g_FirstJoinFunc(val);
    }
    
    public void EnterChannel(string ChannelId)
    {
        if(ChannelId.IsEmpty())
        {
            _DoFailedProcess();
        }
        else
        {
            // 入室可能チェック
            hel_net_get_position_channel(_IsAvailableCallback, ChannelId);
        }
    }

    void _IsAvailableCallback(JsVal val)
    {
        // 入室可能チェック
        if(!g_IsAvailableFunc.Empty() && g_IsAvailableFunc(val))
        {
            if(val === null || (val.GetType() != 1 && val.GetType() != 2)) return;

            VCCPositionChannel Channel = new VCCPositionChannel(); 
            if(!Channel.Analyse(val, false)) return;

            // エンジンRTC接続処理
            CallHelConnectProcessIfSuccessed(Channel);
        }
        else
        {
            _DoFailedProcess();
        }
    }

    void _EnterChannelIfSuccessed(JsVal val)
    {
        if(val !== null && val.GetType() == 4 && val.GetBool())
        {
            ConnectProcess(val);
        }
        else
        {
            _DoFailedProcess();
        }
    }

    public void ConnectProcess(JsVal val)
    {
        if(val === null || val.GetType() != 4) return;

        if(!val.GetBool()) return;

        // 入室するチャンネルの詳細情報を取得する
        hel_net_get_current_pos_channel(_GetCurrentPosChannelCallback);
    }

    void _DoFailedProcess()
    {
        // 入室失敗時の処理に移行する
        JsVal val = makeJsObj();
        g_FailedJoinFunc(val);
    }

    void _GetCurrentPosChannelCallback(JsVal val)
    {
        // 入室するチャンネルの詳細情報を取得する
        if(val === null || (val.GetType() != 1 && val.GetType() != 2)) return;

        VCCPositionChannel Channel = new VCCPositionChannel(); 
        if(!Channel.Analyse(val, false)) return;

        // チャンネル情報編集UIの表示切替
        hsCanvasResetToggleDefault("Toggle_VCC_Is_Channel_Creator");
        if(!m_CurrentChannel.CreateUserCode.IsEmpty() && m_ChSBridge.GetSelfUserCode() == m_CurrentChannel.CreateUserCode)
        {
            hsCanvasToggleChange("Toggle_VCC_Is_Channel_Creator");
        }

        // VCCViewのステータスを更新する
        VCCViewModel viewModel = system.Layer_GetComponentByName<VCCViewModel>("vcc_icon_only_base");
        if(viewModel !== null)
        {
            viewModel.UpdateConnectStatus(m_CurrentChannel, 0, true, true);
        }

        // 入室した旨を伝える
        string message;
        if(system.IsLangJA())
        {
            message = "『" + m_CurrentChannel.ChannelName + "』" + "に参加しました";
        }
        else
        {
            message = "Join" + "\"" + m_CurrentChannel.ChannelName + "\"";
        }

        // なぜかログインユーザーがロード時にいるとここのトースト出力でiOSが『Max Stack Size Exceeded』を引き起こしてしまうので、応急処置で直接コンポーネントを取得する
        ToastViewModel toast = system.Layer_GetComponentByName<ToastViewModel>("toast");
        if(toast !== null)
        {
            toast.SetNoticeTime("250,3500,250");
            toast.NotifyMessage(message);
        }

        // LayerBundle layer = hsLayerGet("toast");
        // if(layer !== null)
        // {
        //     layer.CallComponentMethod("ToastViewModel", "SetNoticeTime", "250,3500,250");
        //     layer.CallComponentMethod("ToastViewModel", "NotifyMessage", message);
        // }

        // 接続中
        m_IsConnected = true;

        // テキチャの通知設定
        api.textChat.watchTextChatNotification(hsNetGetSpatiumCode(), hsGetCurrentWorldId(), m_CurrentChannel.ChannelId);
        //KickBan通知設定
        LayerBundle profLayer = hsLayerGet("prof_option_layer");
        if(profLayer !== null) 
        {
            ProfRejector rejector = system.Layer_GetComponentByName<ProfRejector>("prof_option_layer");
            rejector.ActivateKickBanNotification();
        }
    }

    // 音声チャンネル入室処理 /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    public void CallHelVoiceConnectProcess(string ChannelId)
    {
        // 座標チャンネルのCRP接続完了後、音声チャンネル接続を開始する
        // ChSModelSingleなので音声チャンネルは1つだけ
        // list<string> keyList = new list<string>();
        // list<string> valueList = new list<string>();
        // JsVal params = hsCommonMakeStringArrayParams(keyList, valueList);

        // if(m_CurrentChannel === null) return;

        // hel_net_get_voice_channel_list(_fetchVoiceChannelListCallback, ChannelId, params);

        hel_net_get_voice_channel_list(_fetchVoiceChannelListCallback, ChannelId, 0, -1, hsNetExcludeEmptyChannel());
    }

    void _fetchVoiceChannelListCallback(JsVal val)
    {
        if(val === null || (val.GetType() != 1 && val.GetType() != 2)) return;

        list<JsProp> channel_prop_list = val.GetPropertyList();

        if(channel_prop_list.Count > 0)
        {
            // 一つ目の音声チャンネルに入室する
            JsVal VoiceChannel = channel_prop_list[0].GetValue();
            if(VoiceChannel === null || (VoiceChannel.GetType() != 1 && VoiceChannel.GetType() != 2)) return;

            VCCVoiceChannel Channel = new VCCVoiceChannel();

            if(Channel.Analyse(VoiceChannel, true))
            {
                hel_net_join_voice_channel(_ConnectVoiceProcess, Channel.Data.ChannelId);
            }
        }
        else
        {
            // 1つも音声チャンネルがないので1つだけ作成する
            // list<string> keyList = new list<string>();
            // keyList.Add("channelType"); keyList.Add("name"); keyList.Add("description");
            // list<string> valueList = new list<string>();
            // valueList.Add(m_CurrentChannel.ChannelType); valueList.Add(m_CurrentChannel.ChannelName); valueList.Add("");

            // JsVal params = hsCommonMakeStringArrayParams(keyList, valueList);

            // hel_net_create_voice_channel(_CreateVoiceChannelCallback, m_CurrentChannel.ChannelId, params);

            hel_net_create_voice_channel(_CreateVoiceChannelCallback, m_CurrentChannel.ChannelId, m_CurrentChannel.ChannelType, m_CurrentChannel.ChannelName, "");
        }
    }

    void _CreateVoiceChannelCallback(JsVal val)
    {
        // 誰も入室していない部屋はChannelList並ばなくなるのでChannel作成後は即座に入室する
        if(val === null || (val.GetType() != 1 && val.GetType() != 2))  return;
        
        string channel_id = val.GetProperty("channel_id").GetStr();

        hel_net_join_voice_channel(_ConnectVoiceProcess, channel_id);
    }

    void _ConnectVoiceProcess(JsVal val)
    {
        if(val === null || val.GetType() != 4 || !val.GetBool())  return;

        // 入室するチャンネルの詳細情報を取得する
        hel_net_get_current_voice_channel(_GetCurrentVoiceChannelCallback);
    }

    void _GetCurrentVoiceChannelCallback(JsVal val)
    {
        if(val === null || (val.GetType() != 1 && val.GetType() != 2))  return;

        // 入室するチャンネルの詳細情報を取得する
        VCCVoiceChannel Channel = new VCCVoiceChannel(); 
        if(!Channel.Analyse(val, false)) return;
    }

    // 座標チャンネル退室処理 /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    public void ExitChannel()
    {
        hel_net_leave_pos_channel(_LeavePosCallback);
    }

    void _LeavePosCallback()
    {
        // エンジンRTCの切断
        hel_net_disconnect();
        hel_skyway_set_roomid("");

        string message = (system.IsLangJA())? "ボイスチャットグループから退出しました" : "Left the voice chat group";

        LayerBundle layer = hsLayerGet("toast");
        if(layer !== null)
        {
            layer.CallComponentMethod("ToastViewModel", "SetNoticeTime", "250,3500,250");
            layer.CallComponentMethod("ToastViewModel", "NotifyMessage", message);
        }

        m_IsConnected = false;
        m_CurrentChannel = null;

        // ユーザーテーブルをリセットする
        m_ChSBridge.ClearUserTable();
    }

    // チャンネル操作 ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    public void CreateNewChannel(string ChannelName, string SelectedChannelType)
    {
        // list<string> keyList = new list<string>();
        // keyList.Add("channelType"); keyList.Add("name"); keyList.Add("description");
        // list<string> valueList = new list<string>();
        // valueList.Add(SelectedChannelType); valueList.Add(ChannelName); valueList.Add("");

        // JsVal params = hsCommonMakeStringArrayParams(keyList, valueList);

        // hel_net_create_pos_channel(_CreatePosChannelCallback, hsNetGetSpatiumCode(), hsGetCurrentWorldId(), params);

        hel_net_create_pos_channel(_CreatePosChannelCallback, hsNetGetSpatiumCode(), hsGetCurrentWorldId(), SelectedChannelType, ChannelName, "");
    }

    void _CreatePosChannelCallback(JsVal val)
    {
        if(val === null || (val.GetType() != 1 && val.GetType() != 2)) return;

        VCCPositionChannel Channel = new VCCPositionChannel(); 
        if(!Channel.Analyse(val, false)) return;

        // 誰も入室していない部屋はChannelList並ばなくなるのでChannel作成後は即座に入室する
        // エンジンRTC接続処理
        CallHelConnectProcess(Channel);
    }

    public void UpdateChannel(string ChannelName, string SelectedChannelType)
    {
        // list<string> keyList = new list<string>();
        // keyList.Add("channelType"); keyList.Add("name"); keyList.Add("description");
        // list<string> valueList = new list<string>();
        // valueList.Add(SelectedChannelType); valueList.Add(ChannelName); valueList.Add("");

        // JsVal params = hsCommonMakeStringArrayParams(keyList, valueList);

        // hel_net_update_pos_channel(_UpdateChannelCallback, params);

        hel_net_update_pos_channel(_UpdateChannelCallback, SelectedChannelType, ChannelName, "");
    }

    void _UpdateChannelCallback(JsVal val)
    {
        if(val === null || (val.GetType() != 1 && val.GetType() != 2))  return;

        string name = val.GetProperty("name").GetStr();

        m_CurrentChannel.ChannelName = name;

        VCCViewModel viewModel = system.Layer_GetComponentByName<VCCViewModel>("vcc_icon_only_base");
        if(viewModel !== null)
        {
            viewModel.UpdateConnectStatus(m_CurrentChannel, 0, true, true);
        }

        // チャンネル情報が更新されたことを通知する
        hsNetSendCustomData("VCC_Update_Channel", m_CurrentChannel.ChannelName);
    }

    // エンジンRTC入室処理 ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    public void OnNetPosConnected()
    {
        if(m_CurrentChannel === null) return;

        CallHelVoiceConnectProcess(m_CurrentChannel.ChannelId);
    }
    
    public void OnNetVoiceConnected(string VoiceID)
    {
        // 自身のVoiceIDを追加
        m_ChSBridge.AddSelfVoiceID(VoiceID);

        // マイクをオフにする
        hel_net_set_mic_enabled(false);
        hsNetSetMicIconState(false);
        hsCanvasResetToggleDefault("Toggle_Voicechat_Mic_On_Off");
    }
    
    void _PrepareHelConnectProcess(VCCPositionChannel Channel, fVoidCallback callback)
    {
        m_TempHelConnectChannelId = Channel.Data.ChannelId;
        m_TempRequiredTickets = Channel.Data.RequiredTickets;
        g_TempSingleVCCConnectCallback = callback;

        m_CurrentChannel = Channel.Data;

        // ユーザーテーブルを初期化する
        m_ChSBridge.InitUserTable(m_CurrentChannel);
    }

    void _JoinPosAfterLeave()
    {
        // エンジンRTCの切断
        hel_net_disconnect();
        hel_skyway_set_roomid("");

        // skywayはRoomIDが必須
        hel_skyway_set_roomid(m_TempHelConnectChannelId);

        // エンジン側のRoomIDとURLを更新
        hel_net_replace_room_url_with_roomid(m_TempHelConnectChannelId);

        // エンジン接続処理
        hel_net_connect(g_TempSingleVCCConnectCallback);
    }

    public void CallHelConnectProcessIfSuccessed(VCCPositionChannel Channel)
    {
        _PrepareHelConnectProcess(Channel, _NetConnectCallbackIfSuccessed);

        // まず既存のチャンネルから退出する
        hel_net_leave_pos_channel(_JoinPosAfterLeave);
    }

    void _NetConnectCallbackIfSuccessed()
    {
        // 入室処理を実行
        DoHelJoinPosChannel(m_TempHelConnectChannelId, m_TempRequiredTickets, _EnterChannelIfSuccessed);
    }
    
    public void CallHelConnectProcess(VCCPositionChannel Channel)
    {
        _PrepareHelConnectProcess(Channel, _NetConnectCallback);

        // まず既存のチャンネルから退出する
        hel_net_leave_pos_channel(_JoinPosAfterLeave);
    }

    void _NetConnectCallback()
    {
        // 入室処理を実行
        DoHelJoinPosChannel(m_TempHelConnectChannelId, m_TempRequiredTickets, ConnectProcess);
    }

    public void DoHelJoinPosChannel(string ChannelId, bool RequiredTickets, fJsValCallback Callback)
    {
        m_ChSBridge.DoHelJoinPosChannel(ChannelId, RequiredTickets, Callback);

        m_TempHelConnectChannelId = "";
        m_TempRequiredTickets = false;
        g_TempSingleVCCConnectCallback.Clear();
    }
}