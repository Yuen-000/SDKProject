// 座標チャンネルと音声チャンネルが1対Nの時のModel

fVoidCallback g_TempMultipleVCCConnectCallback;

component ChSModelMultiple
{
    ChSBridge m_ChSBridge;
    ChSJoinProcessMultiple m_JoinProcess;

    VCCChannelData m_CurrentPosChannel;
    VCCChannelData m_CurrentVoiceChannel;

    bool m_IsConnected;

    string m_TempHelConnectChannelId;
    bool m_TempRequiredTickets;
    string m_TempVoiceChannelId;

    public ChSModelMultiple()
    {
        m_ChSBridge = system.Layer_GetComponentByName<ChSBridge>("vcc_icon_only_base");
        m_JoinProcess = system.Layer_GetComponentByName<ChSJoinProcessMultiple>("vcc_icon_only_base");

        m_CurrentPosChannel = null;
        m_CurrentVoiceChannel = null;

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

        if(FirstPosChannelJoinType == CHANNEL_JOIN_TYPE_USE_URL_ROOMID)
        {
            g_FirstJoinFunc = m_JoinProcess.JoinFromURLRoomID;
            g_IsAvailableFunc = m_JoinProcess.CheckUserCount;
        }
        else if(FirstPosChannelJoinType == CHANNEL_JOIN_TYPE_RANDOM_CHANNEL)
        {
            g_FirstJoinFunc = m_JoinProcess.JoinRandomFreeSpace;
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
            g_FailedJoinFunc = m_JoinProcess.JoinRandomFreeSpace;
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
        if(m_CurrentVoiceChannel === null) return false;

        string CreateUserCode = m_CurrentVoiceChannel.CreateUserCode;
        bool IsCreator = (!CreateUserCode.IsEmpty() && CreateUserCode == SelfUserCode);

        return IsCreator;
    }

    public VCCChannelData GetCurrentPosChannel()
    {
        return m_CurrentPosChannel;
    }

    public VCCChannelData GetCurrentVoiceChannel()
    {
        return m_CurrentVoiceChannel;
    }

    public void UpdateSpaceName(string SpaceName)
    {
        if(m_CurrentPosChannel === null) return;

        m_CurrentPosChannel.ChannelName = SpaceName;

        // ひとまずViewModelにはまだ通知しない
    }

    public void UpdateChannelName(string ChannelName)
    {
        if(m_CurrentVoiceChannel === null) return;

        m_CurrentVoiceChannel.ChannelName = ChannelName;
        
        VCCViewModel viewModel = system.Layer_GetComponentByName<VCCViewModel>("vcc_icon_only_base");
        if(viewModel !== null)
        {
            viewModel.UpdateConnectStatus(m_CurrentVoiceChannel, 0, true, false);
        }
    }

    // 座標チャンネルリストの取得/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    public void FetchPosChannelList(int PagerIndex, fJsValCallback callback, bool UseOffset)
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

        // // 座標チャンネルリストを取得
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

    // 座標チャンネル入室処理 ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    public void FirstEnterPosChannel()
    {
        JsVal val = makeJsObj();
        g_FirstJoinFunc(val);
    }

    public void EnterPosChannel(string ChannelId)
    {
        ExitVoiceChannel();
        ExitPosChannel();

        if(ChannelId.IsEmpty())
        {
            _DoFailedPosProcess();
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
            CallHelPosConnectProcessIfSuccessed(Channel);
        }
        else
        {
            _DoFailedPosProcess();
        }
    }

    void _EnterPosChannelIfSuccessed(JsVal val)
    {
        if(val !== null && val.GetType() == 4 && val.GetBool())
        {
            ConnectPosProcess(val);
        }
        else
        {
            _DoFailedPosProcess();
        }
    }

    public void ConnectPosProcess(JsVal val)
    {
        if(val === null || val.GetType() != 4) return;

        if(!val.GetBool()) return;

        // 入室するチャンネルの詳細情報を取得する
        hel_net_get_current_pos_channel(_GetCurrentPosChannelCallback);
    }

    void _DoFailedPosProcess()
    {
        // 入室失敗時の処理に移行する
        JsVal val = makeJsObj();
        g_FailedJoinFunc(val);
    }

    void _GetCurrentPosChannelCallback(JsVal val)
    {
        if(val === null || (val.GetType() != 1 && val.GetType() != 2)) return;

        // 入室するチャンネルの詳細情報を取得する
        VCCPositionChannel Channel = new VCCPositionChannel(); 
        if(!Channel.Analyse(val, false)) return;

        m_CurrentPosChannel = Channel.Data;

        // まだVoiceChannelには入室していないので空のチャンネル情報を渡す
        VCCViewModel viewModel = system.Layer_GetComponentByName<VCCViewModel>("vcc_icon_only_base");
        if(viewModel !== null)
        {
            VCCChannelData Channel = new VCCChannelData();
            viewModel.UpdateConnectStatus(Channel, -1, false, true);
        }

        // 入室した旨を伝える
        string message;
        if(system.IsLangJA())
        {
            message = "『" + m_CurrentPosChannel.ChannelName + "』" + "に参加しました";
        }
        else
        {
            message = "Join" + "\"" + m_CurrentPosChannel.ChannelName + "\"";
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

        // テキチャの通知設定
        // テキチャは座標チャンネル単位でやりとりを行う
        api.textChat.watchTextChatNotification(hsNetGetSpatiumCode(), hsGetCurrentWorldId(), m_CurrentPosChannel.ChannelId);
        //KickBan通知設定
        LayerBundle profLayer = hsLayerGet("prof_option_layer");
        if(profLayer !== null) 
        {
            ProfRejector rejector = system.Layer_GetComponentByName<ProfRejector>("prof_option_layer");
            rejector.ActivateKickBanNotification();
        }
    }

    // 座標チャンネル退出処理 /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    public void ExitPosChannel()
    {
        hel_net_leave_pos_channel(_LeavePosCallback);

        m_CurrentPosChannel = null;
    }

    void _LeavePosCallback()
    {
    }

    // 座標チャンネル操作 /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    public void CreateNewPosChannel(string ChannelName, string SelectedChannelType)
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
        CallHelPosConnectProcess(Channel);
    }

    public void UpdatePosChannel(string ChannelName, string SelectedChannelType)
    {
        // list<string> keyList = new list<string>();
        // keyList.Add("channelType"); keyList.Add("name"); keyList.Add("description");
        // list<string> valueList = new list<string>();
        // valueList.Add(SelectedChannelType); valueList.Add(ChannelName); valueList.Add("");

        // JsVal params = hsCommonMakeStringArrayParams(keyList, valueList);

        // hel_net_update_pos_channel(_UpdatePosChannelCallback, params);

        hel_net_update_pos_channel(_UpdatePosChannelCallback, SelectedChannelType, ChannelName, "");
    }

    void _UpdatePosChannelCallback(JsVal val)
    {
        if(val === null || (val.GetType() != 1 && val.GetType() != 2))  return;

        string name = val.GetProperty("name").GetStr();

        m_CurrentPosChannel.ChannelName = name;

        VCCViewModel viewModel = system.Layer_GetComponentByName<VCCViewModel>("vcc_icon_only_base");
        if(viewModel !== null)
        {
            viewModel.UpdateConnectStatus(m_CurrentPosChannel, 0, true, true);
        }

        // チャンネル情報が更新されたことを通知する
        hsNetSendCustomData("VCC_Update_Space", m_CurrentPosChannel.ChannelName);
    }

    // 音声チャンネルリスト取得 //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    public void FetchVoiceChannelList(int PagerIndex, fJsValCallback callback, bool UseOffset)
    {
        string PosChannelID;
        if(m_CurrentPosChannel !== null) PosChannelID = m_CurrentPosChannel.ChannelId;

        if(PosChannelID.IsEmpty()) return;

        // int offset = 6 * PagerIndex;
        // int limit = 6;

        // JsVal params = hsCommonMakeParams();
        // if(UseOffset)
        // {
        //     hsCommonAddParamNumber(params, "offset", offset);
        //     hsCommonAddParamNumber(params, "limit", limit);
        // }

        // hel_net_get_voice_channel_list(callback, PosChannelID, params);

        if(UseOffset)
        {
            hel_net_get_voice_channel_list(callback, PosChannelID, 6 * PagerIndex, 6, hsNetExcludeEmptyChannel());
        }
        else
        {
            hel_net_get_voice_channel_list(callback, PosChannelID, 0, -1, hsNetExcludeEmptyChannel());
        }
    }

    // 音声チャンネル入室処理 ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    public void EnterVoiceChannel(string ChannelId)
    {
        // エンジンRTC接続処理
        CallHelVoiceConnectProcess(ChannelId);
    }

    void _ConnectVoiceProcess(JsVal val)
    {
        if(val === null || val.GetType() != 4) return;

        if(!val.GetBool()) return;

        // 入室するチャンネルの詳細情報を取得する
        hel_net_get_current_voice_channel(_GetCurrentVoiceChannelCallback);
    }

    void _GetCurrentVoiceChannelCallback(JsVal val)
    {
        if(val === null || (val.GetType() != 1 && val.GetType() != 2)) return;

        // 入室するチャンネルの詳細情報を取得する
        VCCVoiceChannel Channel = new VCCVoiceChannel(); 
        if(!Channel.Analyse(val, false)) return;

        // チャンネル情報編集UIの表示切替
        hsCanvasResetToggleDefault("Toggle_VCC_Is_Channel_Creator");
        if(!m_CurrentVoiceChannel.CreateUserCode.IsEmpty() && m_ChSBridge.GetSelfUserCode() == m_CurrentVoiceChannel.CreateUserCode)
        {
            hsCanvasToggleChange("Toggle_VCC_Is_Channel_Creator");
        }

        // VCCViewのステータスを更新する
        VCCViewModel viewModel = system.Layer_GetComponentByName<VCCViewModel>("vcc_icon_only_base");
        if(viewModel !== null)
        {
            viewModel.UpdateConnectStatus(m_CurrentVoiceChannel, 0, true, true);
        }

        // 入室した旨を伝える
        string message;
        if(system.IsLangJA())
        {
            message = "『" + m_CurrentVoiceChannel.ChannelName + "』" + "に参加しました";
        }
        else
        {
            message = "Join" + "\"" + m_CurrentVoiceChannel.ChannelName + "\"";
        }

        LayerBundle layer = hsLayerGet("toast");
        if(layer !== null)
        {
            layer.CallComponentMethod("ToastViewModel", "SetNoticeTime", "250,3500,250");
            layer.CallComponentMethod("ToastViewModel", "NotifyMessage", message);
        }

        // 接続中
        m_IsConnected = true;
    }

    // 音声チャンネル退出処理 //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  
    public void ExitVoiceChannel()
    {
        hel_net_leave_voice_channel(_LeaveVoiceCallback);

        string message = (system.IsLangJA())? "ボイスチャットグループから退出しました" : "Left the voice chat group";

        LayerBundle layer = hsLayerGet("toast");
        if(layer !== null)
        {
            layer.CallComponentMethod("ToastViewModel", "SetNoticeTime", "250,3500,250");
            layer.CallComponentMethod("ToastViewModel", "NotifyMessage", message);
        }

        m_IsConnected = false;
        m_CurrentVoiceChannel = null;

        // ユーザーテーブルをリセットする
        m_ChSBridge.ClearUserTable();
    }

    void _LeaveVoiceCallback()
    {
    }

    // 音声チャンネル操作 /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    public void CreateVoiceNewChannel(string ChannelName, string SelectedChannelType)
    {
        string PosChannelID;
        if(m_CurrentPosChannel !== null) PosChannelID = m_CurrentPosChannel.ChannelId;

        if(PosChannelID.IsEmpty()) return;

        // list<string> keyList = new list<string>();
        // keyList.Add("channelType"); keyList.Add("name"); keyList.Add("description");
        // list<string> valueList = new list<string>();
        // valueList.Add(SelectedChannelType); valueList.Add(ChannelName); valueList.Add("");

        // JsVal params = hsCommonMakeStringArrayParams(keyList, valueList);

        // hel_net_create_voice_channel(_CreateVoiceChannelCallback, PosChannelID, params);

        hel_net_create_voice_channel(_CreateVoiceChannelCallback, PosChannelID, SelectedChannelType, ChannelName, "");
    }

    void _CreateVoiceChannelCallback(JsVal val)
    {
        // 誰も入室していない部屋はChannelList並ばなくなるのでChannel作成後は即座に入室する
        if(val === null || (val.GetType() != 1 && val.GetType() != 2))  return;
        
        string channel_id = val.GetProperty("channel_id").GetStr();

        CallHelVoiceConnectProcess(channel_id);
    }

    public void UpdateVoiceChannel(string ChannelName, string SelectedChannelType)
    {
        // list<string> keyList = new list<string>();
        // keyList.Add("channelType"); keyList.Add("name"); keyList.Add("description");
        // list<string> valueList = new list<string>();
        // valueList.Add(SelectedChannelType); valueList.Add(ChannelName); valueList.Add("");

        // JsVal params = hsCommonMakeStringArrayParams(keyList, valueList);

        // hel_net_update_voice_channel(_UpdateVoiceChannelCallback, params);

        hel_net_update_voice_channel(_UpdateVoiceChannelCallback, SelectedChannelType, ChannelName, "");
    }

    void _UpdateVoiceChannelCallback(JsVal val)
    {
        if(val === null || (val.GetType() != 1 && val.GetType() != 2))  return;

        string name = val.GetProperty("name").GetStr();

        m_CurrentVoiceChannel.ChannelName = name;

        VCCViewModel viewModel = system.Layer_GetComponentByName<VCCViewModel>("vcc_icon_only_base");
        if(viewModel !== null)
        {
            viewModel.UpdateConnectStatus(m_CurrentVoiceChannel, 0, true, true);
        }

        // チャンネル情報が更新されたことを通知する
        hsNetSendCustomData("VCC_Update_Channel", m_CurrentVoiceChannel.ChannelName);
    }

    // エンジンRTC入室処理 ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    public void OnNetPosConnected()
    {
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
        
    void _PrepareHelConnectProcess(string ChannelId, bool RequiredTickets, fVoidCallback callback)
    {
        m_TempHelConnectChannelId = ChannelId;
        m_TempRequiredTickets = RequiredTickets;
        g_TempMultipleVCCConnectCallback = callback;
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
        hel_net_connect(g_TempMultipleVCCConnectCallback);
    }

    public void CallHelPosConnectProcessIfSuccessed(VCCPositionChannel Channel)
    {
        _PrepareHelConnectProcess(Channel.Data.ChannelId, Channel.Data.RequiredTickets, _NetConnectCallbackIfSuccessed);

        // まず既存のチャンネルから退出する
        hel_net_leave_pos_channel(_JoinPosAfterLeave);
    }

    void _NetConnectCallbackIfSuccessed()
    {
        // 入室処理を実行
        DoHelJoinPosChannel(m_TempHelConnectChannelId, m_TempRequiredTickets, _EnterPosChannelIfSuccessed);
    }
    
    public void CallHelPosConnectProcess(VCCPositionChannel Channel)
    {
        _PrepareHelConnectProcess(Channel.Data.ChannelId, Channel.Data.RequiredTickets, _NetConnectCallback);

        // まず既存のチャンネルから退出する
        hel_net_leave_pos_channel(_JoinPosAfterLeave);
    }

    void _NetConnectCallback()
    {
        // 入室処理を実行
        DoHelJoinPosChannel(m_TempHelConnectChannelId, m_TempRequiredTickets, ConnectPosProcess);
    }

    public void CallHelVoiceConnectProcess(string ChannelId)
    {
        m_TempVoiceChannelId = ChannelId;

        // エンジンRTCの切断
        hel_net_leave_voice_channel(_JoinVoiceAfterLeave);
    }

    void _JoinVoiceAfterLeave()
    {
        hel_net_get_voice_channel(_GetVoiceChannelCallback, m_TempVoiceChannelId);
    }

    void _GetVoiceChannelCallback(JsVal val)
    {
        if(val === null || (val.GetType() != 1 && val.GetType() != 2)) return;

        // 入室するチャンネルの詳細情報を取得する
        VCCVoiceChannel Channel = new VCCVoiceChannel(); 
        if(!Channel.Analyse(val, false)) return;

        m_CurrentVoiceChannel = Channel.Data;

        // ユーザーテーブルを初期化する
        m_ChSBridge.InitUserTable(m_CurrentVoiceChannel);

        // 入室処理を実行
        hel_net_join_voice_channel(_ConnectVoiceProcess, m_TempVoiceChannelId);

        m_TempVoiceChannelId = "";
    }

    public void DoHelJoinPosChannel(string ChannelId, bool RequiredTickets, fJsValCallback Callback)
    {
        m_ChSBridge.DoHelJoinPosChannel(ChannelId, RequiredTickets, Callback);

        m_TempHelConnectChannelId = "";
        m_TempRequiredTickets = false;
        g_TempMultipleVCCConnectCallback.Clear();
    }
}