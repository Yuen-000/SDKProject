int ETextParamType_RoomID = 1;
int ETextParamType_OperateCanvas = 9;
int ETextParamType_ReplaceMyAvatar = 10;
int ETextParamType_OperateFunctionFlag = 19;
int ETextParamType_ReplaceMyAvatarCustom = 29;
int ETextParamType_ReplaceMyAvatarIcon = 35;
int ETextParamType_StopVideo = 44;
int ETextParamType_ReplaceMyAvatarIconCustom = 46;
int ETextParamType_CheckRestriction = 52;
int ETextParamType_ReplaceFilteredAvatar = 53;
int ETextParamType_ClearMyAvatarCustomMotion = 54;
int ETextParamType_CreateMyAvatarCustomMotion = 55;
int ETextParamType_CreateMyAvatarCustomEmotion = 56;
int ETextParamType_CreateMyAvatarCustomObject = 57;
int ETextParamType_SetVideoRecording = 65;
int ETextParamType_SetGenericWindowState = 71;

extern
{
    void hel_transitionToPage(string);

    void hel_onloaded_add(fVoidCallback);

    // Setter
    int hel_setText(int, string);
    void hel_set_cookie(string, string);

    // Getter
    string hel_get_cookie_onEmptyStr(string);

    // Canvas
    string hel_get_HTMLElement_value(string);
    void hel_update_TextField_UserName();
    void hel_post_TextField_UserName(bool);
    void hel_set_TextField_UserName(string);
    void hel_set_HTMLElement_value(string, string);
    void hel_set_HTMLElement_visibility(string, bool);
    
    // VideoRecorder
    void hel_release_RecordedVideo();
    void hel_start_VideoRecording();
    void hel_stop_VideoRecording();
    void hel_open_recorded_video_preview();
    void hel_convert_webm_to_mp4(async fStringCallback);
    void hel_save_recorded_video(string);  

    // Network
     // JsValを引数にHeliScriptからJS関数を呼ぶとMax Stack Size Errorになってしまうので一時的な対処として通常の型を取り、JSでparamsの連想配列を作り直している
    void hel_net_create(string);
    void hel_net_set_mic_enabled(bool);
    void hel_net_check_mic_permission_state();

    void hel_net_get_current_pos_channel(fJsValCallback);
    void hel_net_get_position_channel(async fJsValCallback, string);
    // void hel_net_get_position_channel_list(async fJsValCallback, string, string, JsVal);
    void hel_net_get_position_channel_list(async fJsValCallback, string, string, int, int, bool);
    
    void hel_net_join_pos_channel(async fJsValCallback, string, string, string);

    void hel_net_leave_pos_channel(async fVoidCallback);
    // void hel_net_create_pos_channel(async fJsValCallback, string, string, JsVal);
    void hel_net_create_pos_channel(async fJsValCallback, string, string, string, string, string);
    // void hel_net_update_pos_channel(async fJsValCallback, JsVal);
    void hel_net_update_pos_channel(async fJsValCallback, string, string, string);
    
    void hel_net_get_current_voice_channel(fJsValCallback);
    void hel_net_get_voice_channel(async fJsValCallback, string);
    // void hel_net_get_voice_channel_list(async fJsValCallback, string, JsVal);
    void hel_net_get_voice_channel_list(async fJsValCallback, string, int, int, bool);
    void hel_net_join_voice_channel(async fJsValCallback, string);
    void hel_net_leave_voice_channel(async fVoidCallback);
    // void hel_net_create_voice_channel(async fJsValCallback, string, JsVal);
    void hel_net_create_voice_channel(async fJsValCallback, string, string, string, string);
    // void hel_net_update_voice_channel(async fJsValCallback, JsVal);
    void hel_net_update_voice_channel(async fJsValCallback, string, string, string);

    void hel_net_connect(async fVoidCallback);
    void hel_net_disconnect();
    void hel_net_add_EnterDialog_func(fVoidCallback);
    void hel_net_replace_room_url_with_roomid(string);
    void hel_skyway_set_roomid(string);

    // Skyway
    int hel_skyway_get_avatar();
    string hel_get_skyway_username();
    void hel_skyway_receive_data(string, string, string);
    void hel_skyway_send_data(string);
    string hel_skyway_get_roomid();
}