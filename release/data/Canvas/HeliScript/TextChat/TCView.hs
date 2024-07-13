class TCView
{
    string m_textchat_HTMLElementID;
    string m_textchat_Text_HTMLElementID;
    
    string m_textchat_long_HTMLElementID;
    string m_textchat_long_Text_HTMLElementID;

    public TCView()
    {
        m_textchat_HTMLElementID = "textchat";
        m_textchat_Text_HTMLElementID = "textchat-text";
        
        m_textchat_long_HTMLElementID = "textchat_long";
        m_textchat_long_Text_HTMLElementID = "textchat_long-text";

        ShowInputField(false);
        ShowInputFieldLong(false);

        _LoadMessageListLayer(false, TAB_TYPE_TEXT_CHAT);
        _LoadMessageListLayer(true, TAB_TYPE_TEXT_CHAT);
        _LoadMessageListLayer(false, TAB_TYPE_SYSTEM_MESSAGE);
        _LoadMessageListLayer(true, TAB_TYPE_SYSTEM_MESSAGE);
    }

    void _LoadMessageListLayer(bool IsPortrait, string TabType)
    {
        bool IsTextChatTab = (TabType == TAB_TYPE_TEXT_CHAT);
        bool IsLong = false;

        string layerName = (IsTextChatTab)? "textchat_message_chat" : "textchat_message_system";

        hsCanvasSetLayerShow(layerName, true);

        // Layerの生成
        system.Canvas_AddLayer(layerName, IsPortrait, true, 18);

        if(IsPortrait)
        {
            if(IsTextChatTab)
            {
                if(IsLong)
                {
                    system.Canvas_SetLayerMask(layerName, IsPortrait, "gui/NoButton.png", -32,-120, 1250,1400, 0.5, 0.5, "CM", 0, 0.0, 0.0, 0.0, 0.0, false, true, false, 80);
                }
                else
                {
                    system.Canvas_SetLayerMask(layerName, IsPortrait, "gui/NoButton.png", -32,-565, 1250,535, 0.5, 0.5, "CM", 0, 0.0, 0.0, 0.0, 0.0, false, true, false, 80);
                }
            }
            else
            {
                if(IsLong)
                {
                    system.Canvas_SetLayerMask(layerName, IsPortrait, "gui/NoButton.png", -32,-60, 1250,1480, 0.5, 0.5, "CM", 0, 0.0, 0.0, 0.0, 0.0, false, true, false, 80);
                }
                else
                {
                    system.Canvas_SetLayerMask(layerName, IsPortrait, "gui/NoButton.png", -32,-500, 1250,650, 0.5, 0.5, "CM", 0, 0.0, 0.0, 0.0, 0.0, false, true, false, 80);
                }
            }
        }
        else
        {
            if(IsTextChatTab)
            {
                system.Canvas_SetLayerMask(layerName, IsPortrait, "gui/NoButton.png", -275,-25, 275,340, 0.5, 0.5, "RM", 0, 0.0, 0.0, 0.0, 0.0, false, true, false, 50);
            }
            else
            {
                system.Canvas_SetLayerMask(layerName, IsPortrait, "gui/NoButton.png", -275,15, 275,420, 0.5, 0.5, "RM", 0, 0.0, 0.0, 0.0, 0.0, false, true, false, 50);
            }
        }
        
        system.Canvas_SetLayerSeekBarVertical(layerName,IsPortrait,"gui/clear.png","gui/clear.png","gui2023/chat/chat_scroll_slider.png","gui2023/chat/chat_scroll_slider.png",16,16,64,16,64);

        system.Canvas_SetLayerComponentNameList(layerName, IsPortrait, "TCController");
        
        system.Canvas_SetLayerSeekBarRate(layerName, IsPortrait, 0.0, 1.0);

        hsCanvasSetLayerShow(layerName, false);
    }

    public void ShowClickableTextChatHUD()
    {
        hsCanvasResetToggleDefault("Toggle_OpenClose_TextChat");
    }

    public void ResizeCallback()
    {
        _ResizeInputField();
        _ResizeInputFieldLong();
    }

    void _ResizeInputField()
    {
        hel_setText(ETextParamType_OperateCanvas, "ResizeInputFieldGeneric" + "," + "textchat_common" + "," 
            + "chat_text_inputfield" + "," + m_textchat_HTMLElementID + "," + m_textchat_Text_HTMLElementID);
    }

    void _ResizeInputFieldLong()
    {
        hel_setText(ETextParamType_OperateCanvas, "ResizeInputFieldGeneric" + "," + "textchat_common_long" + "," 
            + "chat_text_inputfield_long" + "," + m_textchat_long_HTMLElementID + "," + m_textchat_long_Text_HTMLElementID);
    }

    public void ShowTextChat(bool show, string TabType)
    {
        hsCanvasSetLayerShow("textchat_common", show);
        hsCanvasSetLayerShow("Dynamic_textchat_message_chat", show);
        ShowInputField(show && (TabType == TAB_TYPE_TEXT_CHAT));
    }

    public void ShowLongTextChat(bool show, string TabType)
    {
        hsCanvasSetLayerShow("textchat_common_long", show);
        ShowInputFieldLong(show && (TabType == TAB_TYPE_TEXT_CHAT));
    }

    public void ShowInputField(bool show)
    {
        ClearInputFieldText(false);

        hel_set_HTMLElement_visibility(m_textchat_HTMLElementID, show);
        hel_set_HTMLElement_visibility(m_textchat_Text_HTMLElementID, show);
        
        if(show)
        {
            _ResizeInputField();
        }
    }
    
    public void ShowInputFieldLong(bool show)
    {
        ClearInputFieldText(true);

        hel_set_HTMLElement_visibility(m_textchat_long_HTMLElementID, show);
        hel_set_HTMLElement_visibility(m_textchat_long_Text_HTMLElementID, show);
        
        if(show)
        {
            _ResizeInputFieldLong();
        }
    }

    public string GetInputFieldText(bool IsLong)
    {
        string result = "";

        if(IsLong)
        {
            result = hel_get_HTMLElement_value(m_textchat_long_Text_HTMLElementID);
        }
        else
        {
            result = hel_get_HTMLElement_value(m_textchat_Text_HTMLElementID);
        }

        return result;
    }

    public void ClearInputFieldText(bool IsLong)
    {
        if(IsLong)
        {
            hel_set_HTMLElement_value(m_textchat_long_Text_HTMLElementID, "");
        }
        else
        {
            hel_set_HTMLElement_value(m_textchat_Text_HTMLElementID, "");
        }
    }

    public void SwitchTextChatTab(string TabType)
    {
        if(TabType == TAB_TYPE_TEXT_CHAT)
        {
            hsCanvasResetToggleDefault("Toggle_TextChat_Tab");
        }
        else if(TabType == TAB_TYPE_SYSTEM_MESSAGE)
        {
            hsCanvasResetToggleDefault("Toggle_TextChat_Tab");
            hsCanvasToggleChange("Toggle_TextChat_Tab");
        }
    }

    public void DrawMessageList(string TabType, bool IsLong)
    {
        bool IsTextChatTab = (TabType == TAB_TYPE_TEXT_CHAT);

        CloseMessageList();

        string layerName = (IsTextChatTab)? "textchat_message_chat" : "textchat_message_system";
        hsCanvasSetLayerShow(layerName, true);
    }
    
    public void CloseMessageList()
    {
        hsCanvasSetLayerShow("textchat_message_chat", false);
        hsCanvasSetLayerShow("textchat_message_system", false);
    }
}
