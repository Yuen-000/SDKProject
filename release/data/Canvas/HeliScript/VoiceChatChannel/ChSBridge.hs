// 定数 /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 座標チャンネル入室パターン
const string CHANNEL_JOIN_TYPE_USE_URL_ROOMID = "roomid";
const string CHANNEL_JOIN_TYPE_RANDOM_CHANNEL = "random";
const string CHANNEL_JOIN_TYPE_SELECT_ANY_CHANNEL = "select";
const string CHANNEL_JOIN_TYPE_CREATE_NEW_RANDOM_CHANNEL = "createrandom";
const string CHANNEL_JOIN_TYPE_REDIRECT_TO_OUTGAME = "redirect";
const string CHANNEL_JOIN_TYPE_CUSTOM = "custom";
const string CHANNEL_JOIN_TYPE_NONE = "none";

// どのauthorityJwtをチェックするか
// どこからこの切り替えを取得するかの仕様が定まっていないので暫定処置でhel_Configで静的に決める
const string AUTHORITY_JWT_TYPE_SPATIUM = "AUTHORITY_JWT_TYPE_SPATIUM";
const string AUTHORITY_JWT_TYPE_WORLD = "AUTHORITY_JWT_TYPE_WORLD";
const string AUTHORITY_JWT_TYPE_POSITION_CHANNEL = "AUTHORITY_JWT_TYPE_POSITION_CHANNEL";
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// どのauthorityJwtをチェックするか
const string g_UseAuthorityJwtType = AUTHORITY_JWT_TYPE_WORLD;

delegate void JoinChannelDelegate(JsVal);
delegate bool CheckAvailableDelegate(JsVal);

JoinChannelDelegate g_FirstJoinFunc;
JoinChannelDelegate g_FailedJoinFunc;
CheckAvailableDelegate g_IsAvailableFunc;

string g_authorityJwt;
string g_ticketJwt;

string g_AfterJwtChannelId;
bool g_RequiredTickets;
fJsValCallback g_AfterJwtCallback;

fVoidCallback g_ReConnectCallback;

class ChSBridge
{
    bool m_AllowMultiVoiceChannel;

    ChSModelSingle m_SubSingleModel;
    ChSModelMultiple m_SubMultipleModel;

    VCCModel m_VCCModel;

    string m_ReConnectChannelId;

    public ChSBridge()
    {
        m_AllowMultiVoiceChannel = false;

        m_SubSingleModel = system.Layer_GetComponentByName<ChSModelSingle>("vcc_icon_only_base");
        m_SubMultipleModel = system.Layer_GetComponentByName<ChSModelMultiple>("vcc_icon_only_base");

        m_VCCModel = system.Layer_GetComponentByName<VCCModel>("vcc_icon_only_base");

        // ChS-APIの初期化
        api.channelSessionApi.initChannelSession(_initChannelSessionCallback);

        // 初回入室処理
        hel_net_add_EnterDialog_func(_EnterDialogCallback);
    }

    public bool IsAllowMultiVoiceChannel()
    {
        return m_AllowMultiVoiceChannel;
    }

    void _initChannelSessionCallback(string param)
    {
        api.channelSessionApi.fetchWolrdDetail(_fetchWolrdDetailCallback, hsNetGetSpatiumCode(), hsGetCurrentWorldId());
    }

    // ChannelSessionを初期化し再接続する
    public void ReConnectIfJoining(fVoidCallback callback)
    {
        VCCChannelData CurrentChannel = null;
        if(m_AllowMultiVoiceChannel)
        {
            CurrentChannel = m_SubMultipleModel.GetCurrentPosChannel();
        }
        else
        {
            CurrentChannel = m_SubSingleModel.GetCurrentChannel();
        }
        
        if(CurrentChannel === null)
        {
            callback();
            return;
        }

        m_ReConnectChannelId = CurrentChannel.ChannelId;

        // 一度退出する
        if(m_AllowMultiVoiceChannel)
        {
            ExitSpace();
        }
        else
        {
            ExitChannel();
        }

        // ChannelSessionを初期化する
        g_ReConnectCallback = callback;
        api.channelSessionApi.initChannelSession(_initChannelSession4ReConnect);
    }

    void _initChannelSession4ReConnect(string param)
    {
        if(!m_ReConnectChannelId.IsEmpty())
        {
            string ChannelId = m_ReConnectChannelId;

            if(!ChannelId.IsEmpty())
            {
                // 再入室する
                if(m_AllowMultiVoiceChannel)
                {
                    m_SubMultipleModel.EnterPosChannel(ChannelId);
                }
                else
                {
                    m_SubSingleModel.EnterChannel(ChannelId);
                }
            }

            m_ReConnectChannelId = "";
        }

        if(!g_ReConnectCallback.Empty())
        {
            g_ReConnectCallback();
            g_ReConnectCallback.Clear();
        }
    }

    // 音声チャンネルに再接続する
    public void ReConnectVoiceChannel()
    {
        if(m_AllowMultiVoiceChannel)
        {
            VCCChannelData CurrentVoiceChannel = m_SubMultipleModel.GetCurrentVoiceChannel();

            if(CurrentVoiceChannel !== null)
            {
                string ChannelId = CurrentVoiceChannel.ChannelId;

                m_SubMultipleModel.EnterVoiceChannel(ChannelId);
            }
        }
        else
        {
            VCCChannelData CurrentChannel = m_SubSingleModel.GetCurrentChannel();

            if(CurrentChannel !== null)
            {
                string ChannelId = CurrentChannel.ChannelId;

                m_SubSingleModel.EnterChannel(ChannelId);
            }
        }
    }

    void _fetchWolrdDetailCallback(string param)
    {
        if(param.IsEmpty()) return;
        Json WorldDetail = hsLoadJson(param);
        if(WorldDetail === null) return;

        // カーネリアンのような複数音声チャンネルを許可するか
        string allow_multi_voice_channel = WorldDetail.Find(EJSONDataType_Block, "data").Find(EJSONDataType_Block, "world").GetData("allow_multi_voice_channel").GetValue();
        m_AllowMultiVoiceChannel = (allow_multi_voice_channel == "true");

        if(m_AllowMultiVoiceChannel)
        {
            // 複数ボイスチャンネルようのGUIをオンにする
            hsCanvasResetToggleDefault("Toggle_VCC_VCh_Single_Multiple");
            hsCanvasToggleChange("Toggle_VCC_VCh_Single_Multiple");
        }

        // 入退出処理の登録
        if(m_AllowMultiVoiceChannel)
        {
            m_SubMultipleModel.RegistJointProcess();
        }
        else
        {
            m_SubSingleModel.RegistJointProcess();
        }
    }

    // 初回入室処理
    void _EnterDialogCallback()
    {
        if(m_AllowMultiVoiceChannel)
        {
            m_SubMultipleModel.FirstEnterPosChannel();
        }
        else
        {
            m_SubSingleModel.FirstEnterChannel();
        }
    }

    // 座標チャンネル入室処理
    public void DoHelJoinPosChannel(string ChannelId, bool RequiredTickets, fJsValCallback Callback)
    {
        g_AfterJwtChannelId = ChannelId;
        g_RequiredTickets = RequiredTickets;
        g_AfterJwtCallback = Callback;

        // authorityJwtのチェック
        _CheckAuthorityJwt(ChannelId);
    }

    void _HelJoinPosChannel()
    {
        // チケット必須ワールドでTicketJwtが無効な時はアウトゲームに飛ばす
        if(g_RequiredTickets && g_ticketJwt.IsEmpty())
        {
            hel_transitionToPage(hsNetGetPosChannelRedirectURL("ticketfail"));

            ResetJwt();

            return;
        }

        hel_net_join_pos_channel(g_AfterJwtCallback, g_AfterJwtChannelId, g_authorityJwt, g_ticketJwt);

        ResetJwt();
    }

    void ResetJwt()
    {
        // Jwt情報をリセットする
        g_authorityJwt = "";
        g_ticketJwt = "";
        g_AfterJwtCallback.Clear();
        g_AfterJwtChannelId = "";
        g_RequiredTickets = false;
    }
    
    void _CheckAuthorityJwt(string ChannelId)
    {
        if(g_UseAuthorityJwtType == AUTHORITY_JWT_TYPE_SPATIUM)
        {
            api.conferenceManagerApi.fetchSpatiumAuthorityJwtString(_CheckAuthorityJwtCallback, hsNetGetSpatiumCode());
        }
        else if(g_UseAuthorityJwtType == AUTHORITY_JWT_TYPE_WORLD)
        {
            api.conferenceManagerApi.fetchWorldAuthorityJwtString(_CheckAuthorityJwtCallback, hsNetGetSpatiumCode(), hsGetCurrentWorldId());
        }
        else if(g_UseAuthorityJwtType == AUTHORITY_JWT_TYPE_POSITION_CHANNEL)
        {
            if(!ChannelId.IsEmpty())
            {
                api.conferenceManagerApi.fetchPositionChannelAuthorityJwtString(_CheckAuthorityJwtCallback, hsNetGetSpatiumCode(), hsGetCurrentWorldId(), ChannelId);
            }
        }
    }
    
    void _CheckAuthorityJwtCallback(JsVal val)
    {
        if(val.IsNull())
        {
            g_authorityJwt = "";
        }
        else
        {
            if(val.GetType() == 5)
            {
                g_authorityJwt = val.GetStr();
            }
            else
            {
                g_authorityJwt = "";
            }
        }

        // ticketJwtのチェック
        _CheckTicketJwt();
    }

    void _CheckTicketJwt()
    {
        if(g_RequiredTickets)
        {
            api.conferenceManagerApi.fetchTicketJwt(_FetchTicketJwtCallback, hsNetGetSpatiumCode(), hsGetCurrentWorldId(), g_AfterJwtChannelId);
        }
        else
        {
            // TicketJwtのチェックは不要なのですぐにIHeliNetworkのJoinを実行する
            g_ticketJwt = "";

            _HelJoinPosChannel();
        }
    }

    void _FetchTicketJwtCallback(JsVal val)
    {
        if(val === null || val.IsNull())
        {
            // TicketJwtの取得に失敗したのでJwtは空として入室処理を実行する
            g_ticketJwt = "";

            _HelJoinPosChannel();
        }
        else
        {
            if(val.GetType() == 5)
            {
                // 取得したTicketJwtを元に入室処理を行う
                Json json = hsLoadJson(val.GetStr());
                
                string jwt;
                json.FindValueString("jwt", jwt);

                g_ticketJwt = jwt;

                _HelJoinPosChannel();
            }
            else if(val.HasPropertyType())
            {
                // 将来的にJSON StringではなくReturn型のオブジェクトが返ってくるようになる
                string jwt = val.GetProperty("jwt").GetStr();

                g_ticketJwt = jwt;

                _HelJoinPosChannel();
            }
            else
            {
                // 無効なJsVal Type
                return;
            }
        }
    }

    public void FetchPosChannelList(int PagerIndex, fJsValCallback callback, bool UseOffset)
    {
        if(m_AllowMultiVoiceChannel)
        {
            m_SubMultipleModel.FetchPosChannelList(PagerIndex, callback, UseOffset);
        }
    }

    public void FetchChannelList(int PagerIndex, fJsValCallback callback, bool UseOffset)
    {
        if(m_AllowMultiVoiceChannel)
        {
            m_SubMultipleModel.FetchVoiceChannelList(PagerIndex, callback, UseOffset);
        }
        else
        {
            m_SubSingleModel.FetchChannelList(PagerIndex, callback, UseOffset);
        }
    }

    public void FetchSpaceDetail(fJsValCallback callback)
    {
        if(m_AllowMultiVoiceChannel)
        {
            VCCChannelData CurrentChannel = m_SubMultipleModel.GetCurrentPosChannel();
        }
    }
    
    public void FetchChannelDetail(fJsValCallback callback)
    {
        if(m_AllowMultiVoiceChannel)
        {
            VCCChannelData CurrentChannel = m_SubMultipleModel.GetCurrentVoiceChannel();

            if(CurrentChannel !== null)
            {
                string ChannelId = CurrentChannel.ChannelId;

                if(!ChannelId.IsEmpty())
                {
                    hel_net_get_voice_channel(callback, ChannelId);
                }
            }
        }
        else
        {
            VCCChannelData CurrentChannel = m_SubSingleModel.GetCurrentChannel();

            if(CurrentChannel !== null)
            {
                string ChannelId = CurrentChannel.ChannelId;

                if(!ChannelId.IsEmpty())
                {
                    hel_net_get_position_channel(callback, ChannelId);
                }
            }
        }
    }

    public void EnterSpace(string ChannelId)
    {
        if(m_AllowMultiVoiceChannel)
        {
            m_SubMultipleModel.EnterPosChannel(ChannelId);
        }
    }

    public void EnterChannel(string ChannelId)
    {
        if(m_AllowMultiVoiceChannel)
        {
            m_SubMultipleModel.EnterVoiceChannel(ChannelId);
        }
        else
        {
            m_SubSingleModel.EnterChannel(ChannelId);
        }
    }

    public void ExitSpace()
    {
        if(m_AllowMultiVoiceChannel)
        {
            m_SubMultipleModel.ExitPosChannel();
        }
    }

    public void ExitChannel()
    {
        if(m_AllowMultiVoiceChannel)
        {
            m_SubMultipleModel.ExitVoiceChannel();
        }
        else
        {
            m_SubSingleModel.ExitChannel();
        }
    }

    public void CreateNewChannel(string ChannelName, string SelectedChannelType)
    {
        if(m_AllowMultiVoiceChannel)
        {
            m_SubMultipleModel.CreateVoiceNewChannel(ChannelName, SelectedChannelType);
        }
        else
        {
            m_SubSingleModel.CreateNewChannel(ChannelName, SelectedChannelType);
        }
    }

    public void UpdateChannel(string ChannelName, string SelectedChannelType)
    {
        if(m_AllowMultiVoiceChannel)
        {
            m_SubMultipleModel.UpdateVoiceChannel(ChannelName, SelectedChannelType);
        }
        else
        {
            m_SubSingleModel.UpdateChannel(ChannelName, SelectedChannelType);
        }
    }

    public bool IsChannelCreator(string UserCode)
    {
        return (m_AllowMultiVoiceChannel)? m_SubMultipleModel.IsChannelCreator(UserCode) : m_SubSingleModel.IsChannelCreator(UserCode);
    }

    public VCCChannelData GetCurrentChannel()
    {
        VCCChannelData CurrentChannel = null;

        if(m_AllowMultiVoiceChannel)
        {
            CurrentChannel = m_SubMultipleModel.GetCurrentVoiceChannel();
        }
        else
        {
            CurrentChannel = m_SubSingleModel.GetCurrentChannel();
        }

        return CurrentChannel;
    }

    public bool IsConnected()
    {
        bool val = false;

        if(m_AllowMultiVoiceChannel)
        {
            val = m_SubMultipleModel.IsConnected();
        }
        else
        {
            val = m_SubSingleModel.IsConnected();
        }

        return val;
    }

    public void UpdateSpaceName(string SpaceName)
    {
        if(m_AllowMultiVoiceChannel)
        {
            m_SubMultipleModel.UpdateSpaceName(SpaceName);
        }
    }

    public void UpdateChannelName(string ChannelName)
    {
        if(m_AllowMultiVoiceChannel)
        {
            m_SubMultipleModel.UpdateChannelName(ChannelName);
        }
        else
        {
            m_SubSingleModel.UpdateChannelName(ChannelName);
        }
    }

    public void ClearUserTable()
    {
        m_VCCModel.ClearUserTable();
    }

    public string GetSelfUserCode()
    {
        return m_VCCModel.GetSelfUserCode();
    }

    public void UpdateCreateUserCode(string UserCode)
    {
        m_VCCModel.UpdateCreateUserCode(UserCode);
    }

    public void InitUserTable(VCCChannelData Channel)
    {
        m_VCCModel.InitUserTable(Channel);
    }

    public void AddSelfVoiceID(string VoiceID)
    {
        m_VCCModel.AddSelfVoiceID(VoiceID);
    }
}