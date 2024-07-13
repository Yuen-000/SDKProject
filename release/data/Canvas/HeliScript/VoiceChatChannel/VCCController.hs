component VCCController
{
    public VCCController()
    {
    }

    public void OnClickedButton(string LayerName, string ButtonName)
    {
        if(LayerName == "vcc_icon_only_base")
        {
            LayerBundle layer = hsLayerGet("vcc_icon_only_base");
            if(layer === null) return;

            if(ButtonName == "hud_voicechat_btn_open")
            {
                layer.CallComponentMethod("VCCViewModel", "OpenUserList", "");
            }
            else if(ButtonName == "hud_voicechat_btn_exit")
            {
                layer.CallComponentMethod("VCCViewModel", "ExitChannel", "");

                // TC
                {
                    LayerBundle vcc_layer = hsLayerGet("textchat_common");
                    if(vcc_layer === null) return;

                    vcc_layer.CallComponentMethod("TCViewModel", "ExitTextChat", "");
                }
            }
            else if(ButtonName == "hud_voicechat_btn_transition_ch")
            {
                layer.CallComponentMethod("VCCViewModel", "MoveChannel", "");
            }
            else if(ButtonName == "hud_voicechat_btn_setting")
            {
                layer.CallComponentMethod("VCCViewModel", "OpenChannelSettings", "true");
            }
        }
        else if(LayerName == "Dynamic_" + "vcc_icon_only_cloneIcon")
        {
            LayerBundle layer = hsLayerGet("vcc_icon_only_base");
            if(layer === null) return;

            int len = string("hud_voicechat_user_icon_").Length();
            string PlayerID = ButtonName.SubString(len, ButtonName.Length() - len);

            if(!PlayerID.IsEmpty())
            {
                layer.CallComponentMethod("VCCViewModel", "ShowUserProfile", PlayerID);
            }
        }
        else if(LayerName == "Dynamic_" + "vcc_user_list_cloneList")
        {
            LayerBundle layer = hsLayerGet("vcc_icon_only_base");
            if(layer === null) return;

            int len = string("hud_voicechat_user_icon_").Length();
            string PlayerID = ButtonName.SubString(len, ButtonName.Length() - len);

            if(!PlayerID.IsEmpty())
            {
                layer.CallComponentMethod("VCCViewModel", "ShowUserProfile", PlayerID);
            }
        }
        else if(LayerName == "vcc_user_list_base")
        {
            LayerBundle layer = hsLayerGet("vcc_icon_only_base");
            if(layer === null) return;

            if(ButtonName == "hud_voicechat_btn_close")
            {
                layer.CallComponentMethod("VCCViewModel", "CloseUserList", "");
            }
            else if(ButtonName == "hud_voicechat_btn_exit")
            {
                layer.CallComponentMethod("VCCViewModel", "ExitChannel", "");

                // TC
                {
                    LayerBundle vcc_layer = hsLayerGet("textchat_common");
                    if(vcc_layer === null) return;

                    vcc_layer.CallComponentMethod("TCViewModel", "ExitTextChat", "");
                }
            }
            else if(ButtonName == "hud_voicechat_btn_transition_ch")
            {
                layer.CallComponentMethod("VCCViewModel", "MoveChannel", "");
            }
            else if(ButtonName == "hud_voicechat_btn_setting")
            {
                layer.CallComponentMethod("VCCViewModel", "OpenChannelSettings", "true");
            }
        }
        else if(LayerName == "vcc_channel_list")
        {
            LayerBundle layer = hsLayerGet("vcc_icon_only_base");
            if(layer === null) return;

            if(ButtonName == "common_btn_close")
            {
                layer.CallComponentMethod("VCCViewModel", "CloseChannelList", "");
            }
            else if(ButtonName == "voicechat_create_ch_btn")
            {
                layer.CallComponentMethod("VCCViewModel", "OpenChannelSettings", "false");
            }
            else if(ButtonName == "voicechat_ch_num_btn")
            {
                layer.CallComponentMethod("VCCViewModel", "OpenChannelNumInput", "");
            }
            else if(ButtonName == "channel_page_back")
            {
                layer.CallComponentMethod("VCCViewModel", "PageBackChannelPager", "");
            }
            else if(ButtonName == "channel_page_next")
            {
                layer.CallComponentMethod("VCCViewModel", "PageNextChannelPager", "");
            }
        }
        else if(LayerName == "vcc_channel_item")
        {
            LayerBundle layer = hsLayerGet("vcc_icon_only_base");
            if(layer === null) return;

            string Index = ButtonName.SubString(ButtonName.Length() - 1, 1);

            if(ButtonName.IndexOf("voicechat_ch_join_btn") != -1)
            {
                layer.CallComponentMethod("VCCViewModel", "SelectChannel", Index);
            }
        }
        else if(LayerName == "vcc_setting_channel_window")
        {
            LayerBundle layer = hsLayerGet("vcc_icon_only_base");
            if(layer === null) return;

            if(ButtonName == "common_btn_close")
            {
                layer.CallComponentMethod("VCCViewModel", "CloseChannelSettings", "");
            }
            else if(ButtonName == "voicechat_btn_open_off")
            {
                layer.CallComponentMethod("VCCViewModel", "SelectNewChannelType", CHANNEL_TYPE_OPEN);
            }
            else if(ButtonName == "voicechat_btn_private_off")
            {
                layer.CallComponentMethod("VCCViewModel", "SelectNewChannelType", CHANNEL_TYPE_PRIVATE);
            }
            else if(ButtonName == "voicechat_new_ch_btn")
            {
                layer.CallComponentMethod("VCCViewModel", "CreateNewChannel", "");
            }
            else if(ButtonName == "voicechat_btn_change_setting")
            {
                layer.CallComponentMethod("VCCViewModel", "UpdateChannel", "");
            }
        }
        else if(LayerName == "vcc_input_channel_number")
        {
            LayerBundle layer = hsLayerGet("vcc_icon_only_base");
            if(layer === null) return;

            if(ButtonName == "common_btn_close")
            {
                layer.CallComponentMethod("VCCViewModel", "CloseChannelNumInput", "");
                layer.CallComponentMethod("VCCViewModel", "OpenChannelList", "");
            }
            else if(ButtonName == "common_btn_cancel")
            {
                layer.CallComponentMethod("VCCViewModel", "CloseChannelNumInput", "");
                layer.CallComponentMethod("VCCViewModel", "OpenChannelList", "");
            }
            else if(ButtonName == "common_btn_join")
            {
                layer.CallComponentMethod("VCCViewModel", "CloseChannelNumInput", "");
                layer.CallComponentMethod("VCCViewModel", "ClickEnterFromNumber", "");
            }
        }
        else if(LayerName == "vcc_join_dialog")
        {
            LayerBundle layer = hsLayerGet("vcc_icon_only_base");
            if(layer === null) return;

            if(ButtonName == "common_btn_close" || ButtonName == "common_btn_cancel")
            {
                layer.CallComponentMethod("VCCViewModel", "ClickCancelButton", "");
            }
            else if(ButtonName == "common_btn_join")
            {
                layer.CallComponentMethod("VCCViewModel", "ClickEnterButton", "");

                // TC
                {
                    LayerBundle vcc_layer = hsLayerGet("textchat_common");
                    if(vcc_layer === null) return;

                    vcc_layer.CallComponentMethod("TCViewModel", "ExitTextChat", "");
                }
            }
            else if(ButtonName == "common_btn_join_space")
            {
                layer.CallComponentMethod("VCCViewModel", "ClickEnterSpaceButton", "");
            }
        }
        else if(LayerName == "vcc_space_list_base")
        {
            LayerBundle layer = hsLayerGet("vcc_icon_only_base");
            if(layer === null) return;

            if(ButtonName == "common_btn_close")
            {
                layer.CallComponentMethod("VCCViewModel", "CloseSpaceList", "");
            }
            else if(ButtonName == "channel_page_back")
            {
                layer.CallComponentMethod("VCCViewModel", "PageBackSpacePager", "");
            }
            else if(ButtonName == "channel_page_next")
            {
                layer.CallComponentMethod("VCCViewModel", "PageNextSpacePager", "");
            }
        }
        else if(LayerName == "vcc_space_list_item")
        {
            LayerBundle layer = hsLayerGet("vcc_icon_only_base");
            if(layer === null) return;

            string Index = ButtonName.SubString(ButtonName.Length() - 1, 1);

            if(ButtonName.IndexOf("voicechat_ch_join_btn") != -1)
            {
                layer.CallComponentMethod("VCCViewModel", "JoinSpace", Index);
            }
        }
    }
}