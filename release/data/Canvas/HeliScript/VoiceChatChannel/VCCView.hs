const string g_vcc_icon_only_cloneIcon = "Dynamic_" + "vcc_icon_only_cloneIcon";
const string g_vcc_user_list_cloneList = "Dynamic_" + "vcc_user_list_cloneList";

class VCCView
{
    string m_ChannelName_HTMLElementID;
    string m_LocalInputText_ChannelName_HTMLElementID;
    bool   m_IsOpenChannelSettings;

    public VCCView()
    {
        m_ChannelName_HTMLElementID = "channelname";
        m_LocalInputText_ChannelName_HTMLElementID = "channelname-text";
        hel_set_HTMLElement_value(m_LocalInputText_ChannelName_HTMLElementID, "");

        m_IsOpenChannelSettings = false;

        if(hsNetUseChannelState())
        {
            hsCanvasResetToggleDefault("Toggle_Voicechat_Use_HUD_UI");
        }
        else
        {
            hsCanvasResetToggleDefault("Toggle_Voicechat_Use_HUD_UI");
            hsCanvasToggleChange("Toggle_Voicechat_Use_HUD_UI");
        }

        _LoadIconOnlyUserListLayer(false);
        _LoadIconOnlyUserListLayer(true);
        _LoadNameUserList(false);
        _LoadNameUserList(true);
    }

    void _LoadIconOnlyUserListLayer(bool IsPortrait)
    {
        // Layerの生成
        system.Canvas_AddLayer(g_vcc_icon_only_cloneIcon, IsPortrait, true, 12);

        if(IsPortrait)
        {
            system.Canvas_SetLayerMask(g_vcc_icon_only_cloneIcon, IsPortrait, "gui/clear.png", 367, 453, 480, 309, 0.5, 0.5, "LT", 1, 0.0, 0.0, 0.0, 0.0, false, true, false, 80);
        }
        else
        {   
            system.Canvas_SetLayerMask(g_vcc_icon_only_cloneIcon, IsPortrait, "gui/clear.png", 119, 154, 173, 120, 0.5, 0.5, "LT", 1, 0.0, 0.0, 0.0, 0.0, false, true, false, 50);
        }

        system.Canvas_SetLayerComponentNameList(g_vcc_icon_only_cloneIcon, IsPortrait, "VCCController");

        hsCanvasSetLayerShow(g_vcc_icon_only_cloneIcon, false);
    }

    void _LoadNameUserList(bool IsPortrait)
    {
        // Layerの生成
        system.Canvas_AddLayer(g_vcc_user_list_cloneList, IsPortrait, true, 12);

        if(IsPortrait)
        {
            system.Canvas_SetLayerMask(g_vcc_user_list_cloneList, IsPortrait, "gui/clear.png", 357, 641, 608, 685, 0.5, 0.5, "LT", 1, 0.0, 0.0, 0.0, 0.0, false, true, false, 80);
        }
        else
        {   
            system.Canvas_SetLayerMask(g_vcc_user_list_cloneList, IsPortrait, "gui/clear.png", 119, 252, 197, 306, 0.5, 0.5, "LT", 1, 0.0, 0.0, 0.0, 0.0, false, true, false,50);
        }

        system.Canvas_SetLayerComponentNameList(g_vcc_user_list_cloneList, IsPortrait, "VCCController");

        hsCanvasSetLayerShow(g_vcc_user_list_cloneList, false);
    }

    public string GetLocalInputText_ChannelName()
    {
        return m_LocalInputText_ChannelName_HTMLElementID;
    }

    public void ResizeCallback()
    {
        if(m_IsOpenChannelSettings)
        {
            hel_setText(ETextParamType_OperateCanvas, "ResizeInputFieldGeneric" + "," + "vcc_setting_channel_window" + "," + "vcc_channel_name_inputtext" + ","
                + m_ChannelName_HTMLElementID + "," + m_LocalInputText_ChannelName_HTMLElementID);
        }
    }

    public void ShowUserListArrowUp(bool show)
    {
        if(show)
        {
            hsCanvasResetToggleDefault("Toggle_voicechat_arrow_down");
        
            hsCanvasResetToggleDefault("Toggle_voicechat_arrow_up");
            hsCanvasToggleChange("Toggle_voicechat_arrow_up");

            hsCanvasResetToggleDefault("Toggle_voicechat_bg_s");
            hsCanvasToggleChange("Toggle_voicechat_bg_s");
        }
        else
        {
            hsCanvasResetToggleDefault("Toggle_voicechat_arrow_down");
            hsCanvasToggleChange("Toggle_voicechat_arrow_down");
            
            hsCanvasResetToggleDefault("Toggle_voicechat_arrow_up");

            hsCanvasResetToggleDefault("Toggle_voicechat_bg_s");
        }
    }

    public void OpenIconOnlyUserList(VCCChannelData Channel, list<VCCUserData> JoinUsersData)
    {
        hsCanvasSetLayerShow("vcc_icon_only_base", true);
        hsCanvasSetLayerShow(g_vcc_icon_only_cloneIcon, true);
    }

    public void CloseIconOnlyUserList()
    {
        hsCanvasSetLayerShow("vcc_icon_only_base", false);
        hsCanvasSetLayerShow("vcc_user_list_base", false);
        hsCanvasSetLayerShow(g_vcc_icon_only_cloneIcon, false);
    }

    public void ShowChannelList(list<VCCChannelData> ChannelList, int PagerIndex)
    {
        hsCanvasSetLayerShow("vcc_channel_list", true);
        hsCanvasSetGUIText("vcc_channel_list", "channel_page_text", "%d" % (PagerIndex + 1));

        string LayerName = "vcc_channel_item";

        hsCanvasSetLayerShow(LayerName, true);

        for(int i = 0; i < 6; i++)
        {
            _ReleaseJoinUserIcon(false, i);
            _ReleaseJoinUserIcon(true, i);

            if(i < ChannelList.Count)
            {
                hsCanvasResetToggleDefault("Toggle_VCC_Channel_%d" % i);
                hsCanvasToggleChange("Toggle_VCC_Channel_%d" % i);

                VCCChannelData Channel = ChannelList[i];
                list<VCCUserData> JoinUsersData = Channel.JoinUsersData;

                string SharedName = "_%d" % i;
                string vcc_channel_title_text = "vcc_channel_title_text" + SharedName;

                string ChannelName = Channel.ChannelName;
                
                hsCanvasSetGUIText(LayerName, vcc_channel_title_text, ((ChannelName.IsEmpty())? "Name not defined" : ChannelName));

                // 最大5人まで現在入室しているユーザーのアイコンを表示する
                _CreateJoinUserIcon(JoinUsersData, false, 70, i);
                _CreateJoinUserIcon(JoinUsersData, true, 230, i);

                // 5人目以降は数字で表示する
                string vcc_user_remaindernum_text = "vcc_user_remaindernum_text" + SharedName;
                int remaindernum = JoinUsersData.Count - 5;
                string dst_remaindernum_text = (JoinUsersData.Count > 5)? ("+%d" % remaindernum) : "";

                hsCanvasSetGUIText(LayerName, vcc_user_remaindernum_text, dst_remaindernum_text);

                // 現在の入室人数と最大入室人数
                string vcc_numof_user_text = "vcc_numof_user_text" + SharedName;
                int CurrentPlayerCount = JoinUsersData.Count;
                int MaxPlayerCount = Channel.MaxVoicePlayerCount;

                hsCanvasSetGUIText(LayerName, vcc_numof_user_text, "%d/%d" % CurrentPlayerCount % MaxPlayerCount);

                if(CurrentPlayerCount >= MaxPlayerCount)
                {
                    system.Canvas_SetGUIImageColor(LayerName, vcc_numof_user_text, 1.0, 0.0, 0.0, 1.0);
                }
                else
                {
                    system.Canvas_SetGUIImageColor(LayerName, vcc_numof_user_text, 1.0, 1.0, 1.0, 1.0);
                }
            }
            else
            {
                hsCanvasResetToggleDefault("Toggle_VCC_Channel_%d" % i);
            }
        }
    }

    void _ReleaseJoinUserIcon(bool IsPortrait, int ChannelOrder)
    {
        string LayerName = "vcc_channel_item";

        for(int UserIndex = 0; UserIndex < 5; UserIndex++)
        {
            string vcc_user_icon_n = "vcc_user_icon_%d_%d" % ChannelOrder % UserIndex;

            system.Canvas_ReleaseGUI(LayerName, IsPortrait, vcc_user_icon_n);
        }
    }

    void _CreateJoinUserIcon(list<VCCUserData> JoinUsersData, bool IsPortrait, int YOffset, int ChannelOrder)
    {
        string LayerName = "vcc_channel_item";
        bool po = IsPortrait;

        for(int UserIndex = 0; UserIndex < 5; UserIndex++)
        {
            string vcc_user_icon_n = "vcc_user_icon_%d_%d" % ChannelOrder % UserIndex;

            // アイコン用のGUIを生成する
            if(UserIndex < JoinUsersData.Count)
            {
                VCCUserData UserData = JoinUsersData[UserIndex];
                string iconURL = (UserData.IconURL.IsEmpty())? "gui2023/voicechat/hud_voicechat_user_icon.png" : UserData.IconURL; 

                int XOffset = (po? 69 : 20);

                hsAddGUIImage(
                    LayerName, IsPortrait, 
                    vcc_user_icon_n, "", "", "", true, 4, (po? -493 : 53) + XOffset * UserIndex, (po? -454 : 236) + ChannelOrder * YOffset, (po? 90 : 30), (po? 90 : 30), 0.5, 0.5, (po? "CM" :"LT"), true, 0.0,
                    iconURL, 0, 0, 0, 0, 0, 0, 0, 0
                );
            }
        }
    }

    public void CloseChannelList()
    {
        hsCanvasSetLayerShow("vcc_channel_list", false);
        hsCanvasSetLayerShow("vcc_channel_item", false);
    }

    public void OpenUserList(VCCChannelData Channel, string VCNumber, list<VCCUserData> JoinUsersData)
    {
        int CurrentPlayerCount = JoinUsersData.Count;
        int MaxPlayerCount = Channel.MaxVoicePlayerCount;

        hsCanvasSetLayerShow("vcc_icon_only_base", false);
        hsCanvasSetLayerShow("vcc_user_list_base", true);
        hsCanvasSetGUIText("vcc_user_list_base", "hud_text_user_count", ("%d/%d" % CurrentPlayerCount % MaxPlayerCount));
        hsCanvasSetGUIText("vcc_user_list_base", "hud_text_channel_number", VCNumber);

        hsCanvasSetLayerShow(g_vcc_user_list_cloneList, true);
    }

    public void CloseUserList()
    {
        hsCanvasSetLayerShow("vcc_user_list_base", false);
        hsCanvasSetLayerShow(g_vcc_user_list_cloneList, false);
    }
    
    public void OpenEnterDialog(string ChannelName, bool IsSpace)
    {
        hsCanvasSetLayerShow("vcc_join_dialog", true);
        hsCanvasSetGUIText("vcc_join_dialog", "vcc_channel_name_text", ChannelName);

        hsCanvasResetToggleDefault("Toggle_VCC_Channel_Space");
        if(IsSpace)
        {
            hsCanvasToggleChange("Toggle_VCC_Channel_Space");
        }

        hsCanvasSetConfigClosedFlag(true);
    }

    public void CloseEnterDialog()
    {
        hsCanvasSetLayerShow("vcc_join_dialog", false);

        hsCanvasSetConfigClosedFlag(false);
    }

    public void UpdateConnectStatus(string ChannelName, int VoiceChannelIndex, bool IsConnected, bool IsUpdateArrow)
    {
        hsCanvasResetToggleDefault("Toggle_ConnectingRoom");
        if(IsConnected)
        {
            hsCanvasToggleChange("Toggle_ConnectingRoom");
        }

        string LayerName = "HUD";

        hsCanvasSetGUIShow(LayerName, "hud_voicechat_joining", IsConnected);

        hsCanvasSetGUIShow(LayerName, "hud_voicechat_channelname", IsConnected);
        hsCanvasSetGUIText(LayerName, "hud_voicechat_channelname", ((ChannelName.IsEmpty())? "Name not defined" : ChannelName));
        
        hsCanvasSetGUIShow(LayerName, "hud_voicechat_groupname", IsConnected);
        string VoiceChannelName = (VoiceChannelIndex >= 0)? ("VoiceGroup %d" % VoiceChannelIndex) : "";
        hsCanvasSetGUIText(LayerName, "hud_voicechat_groupname", VoiceChannelName);

        hsCanvasSetGUIText(LayerName, "hud_voicechat_notjonining", ((system.IsLangJA())? "ボイスチャットチャンネルに参加していません" : "Not joining voice chat channel"));

        if(IsUpdateArrow)
        {
            if(IsConnected)
            {
                hsCanvasResetToggleDefault("Toggle_voicechat_arrow_right");
                hsCanvasToggleChange("Toggle_voicechat_arrow_right");

                hsCanvasResetToggleDefault("Toggle_voicechat_arrow_down");
                hsCanvasToggleChange("Toggle_voicechat_arrow_down");
            }
            else
            {
                hsCanvasResetToggleDefault("Toggle_voicechat_arrow_right");
                
                hsCanvasResetToggleDefault("Toggle_voicechat_arrow_down");
            }

            hsCanvasResetToggleDefault("Toggle_voicechat_bg_s");
        }
    }

    public void UpdateCurrentPlayerCount(VCCChannelData Channel, list<VCCUserData> JoinUsersData)
    {
        if(Channel === null) return;

        hsCanvasSetGUIText("vcc_user_list_base", "hud_text_user_count", ("%d/%d" % JoinUsersData.Count % Channel.MaxVoicePlayerCount));
    }

    public void OpenChannelSettings(bool IsChange)
    {
        hsCanvasResetToggleDefault("Toggle_VCC_Create_Update");
        if(IsChange)
        {
            hsCanvasToggleChange("Toggle_VCC_Create_Update");
        }

        hsCanvasSetLayerShow("vcc_setting_channel_window", true);
        _SetShowChannelNameInput(true);

        m_IsOpenChannelSettings = true;
        hel_set_HTMLElement_value(m_LocalInputText_ChannelName_HTMLElementID, "");
    }
    
    public void CloseChannelSettings()
    {
        hsCanvasResetToggleDefault("Toggle_VCC_Create_Update");

        hsCanvasSetLayerShow("vcc_setting_channel_window", false);
        _SetShowChannelNameInput(false);

        m_IsOpenChannelSettings = false;
        hel_set_HTMLElement_value(m_LocalInputText_ChannelName_HTMLElementID, "");
    }

    public void OpenChannelNumInput()
    {
        hsCanvasSetLayerShow("vcc_input_channel_number", true);
    }

    public void CloseChannelNumInput()
    {
        hsCanvasSetLayerShow("vcc_input_channel_number", false);
    }

    void _SetShowChannelNameInput(bool show)
    {
        hel_set_HTMLElement_visibility(m_ChannelName_HTMLElementID, show);
        hel_set_HTMLElement_visibility(m_LocalInputText_ChannelName_HTMLElementID, show);
        
        if(show)
        {
            hel_setText(ETextParamType_OperateCanvas, "ResizeInputFieldGeneric" + "," + "vcc_setting_channel_window" + "," + "vcc_channel_name_inputtext" + ","
                + m_ChannelName_HTMLElementID + "," + m_LocalInputText_ChannelName_HTMLElementID);
        }
    }

    public void UpdateSelectedNewChannelType(bool IsOpen)
    {
        if(IsOpen)
        {
            hsCanvasResetToggleDefault("Toggle_VCC_Open_Private");
        }
        else
        {
            hsCanvasResetToggleDefault("Toggle_VCC_Open_Private");
            hsCanvasToggleChange("Toggle_VCC_Open_Private");
        }
    }

    public void ShowSpaceList(list<VCCChannelData> SpaceList, int PagerIndex)
    {
        hsCanvasSetLayerShow("vcc_space_list_base", true);
        hsCanvasSetGUIText("vcc_space_list_base", "channel_page_text", "%d" % (PagerIndex + 1));

        hsCanvasSetLayerShow("vcc_space_list_item", true);

        for(int i = 0; i < 6; i++)
        {
            string LayerName = "vcc_space_list_item";

            string voicechat_ch_join_btn = "voicechat_ch_join_btn_%d" % i;
            string voicechat_ch_list_item_bg = "voicechat_ch_list_item_bg_%d" % i;
            string vcc_channel_title_text = "vcc_channel_title_text_%d" % i;
            string vcc_numof_user_text = "vcc_numof_user_text_%d" % i;

            hsCanvasResetToggleDefault("Toggle_VCC_Space_%d" % i);

            if(i < SpaceList.Count)
            {
                hsCanvasToggleChange("Toggle_VCC_Space_%d" % i);

                hsCanvasSetGUIText(LayerName, vcc_channel_title_text, SpaceList[i].ChannelName);
                hsCanvasSetGUIText(LayerName, vcc_numof_user_text, "%d/%d" % SpaceList[i].CurrentPlayerCount % SpaceList[i].MaxPosPlayerCount);
            }
        }
    }

    public void CloseSpaceList()
    {
        hsCanvasSetLayerShow("vcc_space_list_base", false);
        hsCanvasSetLayerShow("vcc_space_list_item", false);
    }

    public void CloseWorldInfo()
    {
        hsCanvasSetLayerShow("worldinfo_descript_text_dialog", false);
        hsCanvasSetLayerShow("world_info_dialog", false);
    }
}