const string VCC_WINDOW_TYPE_ICONONLY = "VCC_WINDOW_TYPE_ICONONLY";
const string VCC_WINDOW_TYPE_NAME = "VCC_WINDOW_TYPE_NAME";
const string VCC_WINDOW_TYPE_NONE = "VCC_WINDOW_TYPE_NONE";

component VCCViewModel
{
    VCCModel m_Model;
    VCCView m_View;
    
    int m_SelectedSpaceIndex;
    
    string m_SelectedChannelId;
    string m_SelectedChannelType;
    
    bool m_IsOpenedChannelList;

    string m_CurrentWindowType;

    public VCCViewModel()
    {
        m_View = new VCCView();
        m_Model = system.Layer_GetComponentByName<VCCModel>("vcc_icon_only_base");

        m_SelectedChannelType = CHANNEL_TYPE_OPEN;
        
        m_CurrentWindowType = VCC_WINDOW_TYPE_NONE;

        m_IsOpenedChannelList = false;

        // 表示を初期化する
        m_View.UpdateConnectStatus("", -1, false, true);
    }

    public void ResizeCallback()
    {
        m_View.ResizeCallback();
    }

    // 強制終了の処理
    // JavaScriptの beforeunload, WindowsのWM_CLOSEに対応
    public void OnBeforeUnload()
    {
        m_Model.ExitChannel();
    }

    // 強制終了の処理
    // JavaScriptの unload, WindowsのWM_DESTROYに対応
    public void OnUnload()
    {
        m_Model.ExitChannel();
    }

    public void OnEnabledVoice()
    {
        // CRPのマイクをオンにする
        hel_net_set_mic_enabled(true);
    }

    public void OnDisabledVoice()
    {
        // CRPのマイクをオフにする
        hel_net_set_mic_enabled(false);
    }

    public void UpdateSelfUserData(string param)
    {
        if(param.IsEmpty()) return;

        Json data = hsLoadJson(param);
        if(data === null) return;

        string UserName;
        data.FindValueString("UserName", UserName);

        string IconURL;
        data.FindValueString("IconURL", IconURL);

        string UserCode;
        data.FindValueString("UserCode", UserCode);

        string UserType;
        data.FindValueString("UserType", UserType);

        m_Model.UpdateSelfUserData(UserName, IconURL, UserCode, UserType);
    }

    public void UpdateCurrentPlayerCount()
    {
        m_View.UpdateCurrentPlayerCount(m_Model.GetCurrentChannel(), m_Model.GetCurrentUserTable());
    }

    public void ClickArrowDown(string param)
    {
        if(!hsNetUseUserTable()) return;

        // 既に開いているウィンドウを閉じる
        m_SelectedChannelType = CHANNEL_TYPE_OPEN;
        m_View.CloseChannelSettings();
        m_View.CloseChannelNumInput();
        
        CloseChannelList("");

        // アイコンユーザーリストを表示する
        m_CurrentWindowType = VCC_WINDOW_TYPE_ICONONLY;
        m_View.OpenIconOnlyUserList(m_Model.GetCurrentChannel(), m_Model.GetCurrentUserTable());
        m_View.ShowUserListArrowUp(true);
    }

    public void ClickArrowUp(string param)
    {
        m_CurrentWindowType = VCC_WINDOW_TYPE_NONE;
        
        m_View.CloseIconOnlyUserList();
        m_View.CloseUserList();
        m_View.ShowUserListArrowUp(false);
    }
    
    public void ClearAllVCCLayer(string param)
    {
        m_CurrentWindowType = VCC_WINDOW_TYPE_NONE;

        if(m_Model.IsConnected())
        {
            m_View.ShowUserListArrowUp(false);
        }
        
        m_View.CloseIconOnlyUserList();
        m_View.CloseUserList();

        CloseChannelList("");
        m_View.CloseEnterDialog();

        m_SelectedChannelType = CHANNEL_TYPE_OPEN;
        m_View.CloseChannelSettings();
    }

    public void OpenChannelList(string param)
    {
        if(!hsNetUseUserTable()) return;

        m_CurrentWindowType = VCC_WINDOW_TYPE_NONE;

        if(!m_IsOpenedChannelList)
        {
            m_Model.OpenChannelList();
            m_IsOpenedChannelList = true;
        }
    }

    public void PageBackChannelPager()
    {
        m_Model.UpdateChannelPager(-1);
    }
    
    public void PageNextChannelPager()
    {
        m_Model.UpdateChannelPager(1);
    }

    public void ShowChannelList(list<VCCChannelData> ChannelList, int PagerIndex)
    {
        m_CurrentWindowType = VCC_WINDOW_TYPE_NONE;

        m_View.ShowChannelList(ChannelList, PagerIndex);
    }
    
    public void CloseChannelList(string param)
    {
        m_CurrentWindowType = VCC_WINDOW_TYPE_NONE;
        m_View.CloseChannelList();
        m_IsOpenedChannelList = false;
    }

    public void OpenUserList(string param)
    {
        m_View.CloseIconOnlyUserList();
        m_CurrentWindowType = VCC_WINDOW_TYPE_NAME;
        m_View.OpenUserList(m_Model.GetCurrentChannel(), m_Model.GetVCNumber(), m_Model.GetCurrentUserTable());
    }

    public void CloseUserList(string param)
    {
        m_View.CloseUserList();
        m_CurrentWindowType = VCC_WINDOW_TYPE_ICONONLY;
        m_View.OpenIconOnlyUserList(m_Model.GetCurrentChannel(), m_Model.GetCurrentUserTable());
    }

    public void ExitChannel(string param)
    {
        m_CurrentWindowType = VCC_WINDOW_TYPE_NONE;
        
        m_View.CloseIconOnlyUserList();
        m_View.CloseUserList();
        m_View.ShowUserListArrowUp(false);

        m_Model.ExitChannel();

        m_SelectedChannelId = "";
        m_View.UpdateConnectStatus("", -1, false, true);

        // マイアバターのユーザーテーブルをクリア
        LayerBundle layer = hsLayerGet("mainmenu_mypage_avatar_base");
        if(layer !== null)
        {
            layer.CallComponentMethod("MyAvatarViewModel", "ClearUserTable", "");
        }
    }

    public void MoveChannel(string param)
    {
        m_View.CloseIconOnlyUserList();
        m_View.CloseUserList();
        m_View.ShowUserListArrowUp(false);

        m_Model.OpenChannelList();
    }
    
    public void SelectChannel(string param)
    {
        int ChannelIndex = param.ToInt();

        VCCChannelData Channel = m_Model.GetSelectedChannel(ChannelIndex);

        if(Channel !== null)
        {
            m_SelectedChannelId = Channel.ChannelId;

            string ChannelName = Channel.ChannelName;

            m_View.OpenEnterDialog(ChannelName, false);
        }
        
    }

    public void ClickEnterButton(string param)
    {
        m_View.CloseEnterDialog();
        CloseChannelList("");

        m_Model.EnterChannel(m_SelectedChannelId);
    }

    public void EnterChannelFromID(string ChannelId)
    {
        m_Model.EnterChannel(ChannelId);
    }

    public void EnterChannelWithDialog(string param)
    {
        if(param.IsEmpty()) return;

        Json data = hsLoadJson(param);
        if(data === null) return;

        string channel_id;
        data.FindValueString("channel_id", channel_id);

        string name;
        data.FindValueString("name", name);

        m_SelectedChannelId = channel_id;

        m_View.OpenEnterDialog(name, false);
    }

    public void ClickEnterFromNumber(string param)
    {
        // ViewからNumberを取得(後日実装)
        // string ChannelNumber = m_View.GetChannelNumberInput();
        // m_Model.EnterFromChannelNumber(ChannelNumber);
    }

    public void UpdateConnectStatus(VCCChannelData CurrentChannel, int VoiceChannelIndex, bool IsConnected, bool IsUpdateArrow)
    {
        m_View.UpdateConnectStatus(CurrentChannel.ChannelName, VoiceChannelIndex , IsConnected, IsUpdateArrow);
    }
    
    public void ClickCancelButton(string param)
    {
        m_View.CloseEnterDialog();
    }

    public void OpenChannelSettings(string param)
    {
        bool IsChange = (param != "false");

        if(IsChange)
        {
            if(!m_Model.IsChannelCreator()) return;

            m_View.CloseIconOnlyUserList();
            m_View.CloseUserList();
            m_View.ShowUserListArrowUp(false);
        }

        CloseChannelList("");
        m_View.UpdateSelectedNewChannelType(true);
        m_View.OpenChannelSettings(IsChange);
    }
    
    public void CloseChannelSettings(string param)
    {
        m_SelectedChannelType = CHANNEL_TYPE_OPEN;
        m_View.CloseChannelSettings();
    }

    public void OpenChannelNumInput(string param)
    {
        CloseChannelList("");
        m_View.OpenChannelNumInput();
    }

    public void CloseChannelNumInput(string param)
    {
        m_View.CloseChannelNumInput();
    }

    public void SelectNewChannelType(string param)
    {
        m_SelectedChannelType = param;
        m_View.UpdateSelectedNewChannelType((param == CHANNEL_TYPE_OPEN));
    }

    public void CreateNewChannel(string param)
    {
        string ChannelName = hel_get_HTMLElement_value(m_View.GetLocalInputText_ChannelName());
        ChannelName = ChannelName.SubString(0, 50);

        // 空文字なら何もしない
        if(ChannelName.IsEmpty() || _IsEmptyWithTrim(ChannelName))
        {
            return;
        }

        m_Model.CreateNewChannel(ChannelName, m_SelectedChannelType);

        m_SelectedChannelType = CHANNEL_TYPE_OPEN;
        m_View.CloseChannelSettings();
    }

    public void UpdateChannel(string param)
    {
        string ChannelName = hel_get_HTMLElement_value(m_View.GetLocalInputText_ChannelName());
        ChannelName = ChannelName.SubString(0, 50);

        // 空文字なら何もしない
        if(ChannelName.IsEmpty() || _IsEmptyWithTrim(ChannelName))
        {
            return;
        }

        m_Model.UpdateChannel(ChannelName, m_SelectedChannelType);

        m_SelectedChannelType = CHANNEL_TYPE_OPEN;
        m_View.CloseChannelSettings();
    }

    bool _IsEmptyWithTrim(string src)
    {
        if(src.IsEmpty()) return true;

        for(int i = 0; i < src.Length(); i++)
        {
            string val = src.SubString(i, 1);
            if(val != "\n" && val != " ")
            {
                return false; // 空白も改行もない完全なEmptyである
            }
        }

        return true;
    }

    public void ShowUserProfile(string PlayerID)
    {
        Player OtherPlayer = hsPlayerGetByID(PlayerID);
        string OtherUserCode = OtherPlayer.GetCustomState("UserCode");
        string OtherUserType = OtherPlayer.GetCustomState("UserType");

        if(!OtherUserCode.IsEmpty() && !OtherUserType.IsEmpty())
        {
            Player SelfPlayer = hsPlayerGet();
            string SelfUserCode = SelfPlayer.GetCustomState("UserCode");
            string SelfUserType = SelfPlayer.GetCustomState("UserType");

            LayerBundle layerProfile=hsLayerGet("other_profile");
            if(layerProfile!==null){
                ProfileModel profileModel=system.Layer_GetComponentByName<ProfileModel>("other_profile");
                profileModel.FindUserDataAndShowProfileFromUserID(OtherUserCode, OtherUserType, (SelfUserType == "login" && SelfUserCode != OtherUserCode));
            }
        }
    }

    public void OpenSpaceList()
    {
        m_Model.OpenSpaceList();
    }

    public void PageBackSpacePager()
    {
        m_Model.UpdateSpacePager(-1);
    }
    
    public void PageNextSpacePager()
    {
        m_Model.UpdateSpacePager(1);
    }

    public void ShowSpaceList(list<VCCChannelData> SpaceList, int PagerIndex)
    {
        m_View.ShowSpaceList(SpaceList, PagerIndex);
    }

    public void CloseSpaceList()
    {
        m_View.CloseSpaceList();
    }

    public void JoinSpace(string param)
    {
        m_SelectedSpaceIndex = param.ToInt();

        m_View.OpenEnterDialog("", true);
    }

    public void ExitSpace()
    {
        m_Model.ExitSpace();
    }

    public void ClickEnterSpaceButton()
    {
        m_View.CloseEnterDialog();
        m_View.CloseWorldInfo();
        CloseSpaceList();

        m_Model.EnterSpace(m_SelectedSpaceIndex);
    }

    //ネットワーク同期周り/////////////////////////////////////////////////////////////////
    public void ReConnectIfJoining()
    {
        m_Model.ReConnectIfJoining(_ResponseInitSession);
    }

    public void ReConnectVoiceChannel()
    {
        m_Model.ReConnectVoiceChannel();
    }

    void _ResponseInitSession()
    {
        LayerBundle layer = hsLayerGet("config_profile");
        if(layer !== null)
        {
            layer.CallComponentMethod("ProfileMenuViewModel", "ResponseInitSession", "");
        }
    }

    public list<VCCUserData> GetCurrentUserTable()
    {
        return m_Model.GetCurrentUserTable();
    } 

    public void OnNetReceivePosJoin(string ID, string Data)
    {
    }

    public void OnNetReceivePosLeave(string ID, string Data)
    {
    }

    public void OnNetReceiveVoiceJoin(string ID, string Data)
    {
        // 既存ユーザーの情報(自身)をブロードキャストする
        m_Model.BroadcastVCData(ID, Data);
    }

    public void OnNetReceiveVoiceLeave(string ID, string Data)
    {
        m_Model.ReceiveLeaveVC(ID, Data);
    }

    public void OnNetCreatedPlayerID(string ID)
    {
        // 新規ユーザーの情報(自身)をブロードキャストする
        m_Model.BroadcastVCData(ID, "");
    }

    // APIから直接呼び出す部分
    public void NotifyRemoved()
    {
        // 座標チャンネルと音声チャンネルから強制退出
        ExitChannel("");
        ExitSpace();
    }

    public void RemovePlayer(string UserCode)
    {
        m_Model.RemovePlayer(UserCode);
    }

    public void Block(string UserCode)
    {
        m_Model.Block(UserCode);
    }
    
    public void UnBlock(string UserCode)
    {
        m_Model.UnBlock(UserCode);
    }

    public void BlockTemporary(string UserCode)
    {
        m_Model.BlockTemporary(UserCode);
    }
    
    public void UnBlockTemporary(string UserCode)
    {
        m_Model.UnBlockTemporary(UserCode);
    }
}