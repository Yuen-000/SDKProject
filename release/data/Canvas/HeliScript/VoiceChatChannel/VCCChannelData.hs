const string CHANNEL_TYPE_OPEN = "public";
const string CHANNEL_TYPE_PRIVATE = "private";

class VCCChannelData
{
    public string ChannelType;
    public string CreateUserCode;

    public string ChannelId;
    public string SpatiumCode;
    public string WorldCode;
    public string ChannelName;
    public string Description;
    public string ChannelPassword;

    public int    MaxPosPlayerCount;
    public int    MaxVoicePlayerCount;

    public int    CurrentPlayerCount;

    public list<VCCUserData> JoinUsersData;

    public bool RequiredTickets;

    public VCCChannelData()
    {
        ChannelType = CHANNEL_TYPE_OPEN;
        
        MaxPosPlayerCount = 0;
        MaxVoicePlayerCount = 0;

        CurrentPlayerCount = 0;

        JoinUsersData = new list<VCCUserData>();

        RequiredTickets = false;
    }
}

class VCCPositionChannel
{
    public VCCChannelData Data;

    public VCCPositionChannel()
    {
        Data = new VCCChannelData();
    }

    public bool Analyse(JsVal PositionChannel, bool EnableUserList)
    {
        if(PositionChannel === null || (PositionChannel.GetType() != 1 && PositionChannel.GetType() != 2)) return false;

        // チャンネルデータを取得
        string channel_id = PositionChannel.GetProperty("channel_id").GetStr();
        if(channel_id.IsEmpty()) return false;

        Data.ChannelId = channel_id;
        Data.SpatiumCode = PositionChannel.GetProperty("spatium_code").GetStr();
        Data.WorldCode = PositionChannel.GetProperty("world_code").GetStr();
        Data.ChannelType = PositionChannel.GetProperty("channel_type").GetStr();
        Data.CreateUserCode = _Convert2CorrectCode(PositionChannel.GetProperty("create_user_code").GetStr());
        Data.ChannelName = PositionChannel.GetProperty("name").GetStr();
        Data.Description = PositionChannel.GetProperty("description").GetStr();
        Data.MaxPosPlayerCount = PositionChannel.GetProperty("max_player_count").GetNum();
        Data.MaxVoicePlayerCount = PositionChannel.GetProperty("max_voice_player_count").GetNum();
        if(PositionChannel.GetProperty("required_tickets") !== null) Data.RequiredTickets = PositionChannel.GetProperty("required_tickets").GetBool();

        // ユーザーリストを取得
        JsVal users = PositionChannel.GetProperty("users");
        if(users === null || (users.GetType() != 1 && users.GetType() != 2))
        {
            Data.CurrentPlayerCount = 0;
        }
        else
        {
            list<JsProp> users_array = users.GetPropertyList();
        
            Data.CurrentPlayerCount = users_array.Count;

            if(EnableUserList)
            {
                list<VCCUserData> JoinUsersData = new list<VCCUserData>();

                for(int UserIndex = 0; UserIndex < users_array.Count; UserIndex++)
                {
                    // 最大ボイスチャンネル入室数以上のユーザー情報は無意味なのでそこで処理を抜ける
                    if(UserIndex >= Data.MaxVoicePlayerCount) break;

                    JsVal user = users_array[UserIndex].GetValue();
                    if(user === null || (user.GetType() != 1 && user.GetType() != 2)) continue;

                    string user_name;
                    if(user.GetProperty("name") !== null) user_name = user.GetProperty("name").GetStr();

                    string icon;
                    if(user.GetProperty("icon") !== null) icon = user.GetProperty("icon").GetStr();

                    string uid;
                    if(user.GetProperty("uid") !== null) uid = user.GetProperty("uid").GetStr();

                    VCCUserData UserData = new VCCUserData();
                    UserData.UserName = user_name;
                    UserData.IconURL = icon;
                    UserData.UserCode= uid;

                    JoinUsersData.Add(UserData);
                }

                // 登録
                Data.JoinUsersData = JoinUsersData;
            }
        }

        return true;
    }

    string _Convert2CorrectCode(string UserCode)
    {
        string InvalidStr = ("vketaccount__");
        int Index = UserCode.IndexOf(InvalidStr);

        return (Index != -1)? UserCode.SubString(InvalidStr.Length(), UserCode.Length() - InvalidStr.Length()) : UserCode;
    }
}

class VCCVoiceChannel
{
    public VCCChannelData Data;

    public VCCVoiceChannel()
    {
        Data = new VCCChannelData();
    }

    public bool Analyse(JsVal VoiceChannel, bool EnableUserList)
    {
        if(VoiceChannel === null || (VoiceChannel.GetType() != 1 && VoiceChannel.GetType() != 2)) return false;

        // チャンネルデータを取得
        string channel_id;
        if(VoiceChannel.GetProperty("channel_id") !== null) channel_id = VoiceChannel.GetProperty("channel_id").GetStr();
        if(channel_id.IsEmpty()) return false;

        Data.ChannelId = channel_id;
        if(VoiceChannel.GetProperty("channel_type") !== null) Data.ChannelType = VoiceChannel.GetProperty("channel_type").GetStr();
        if(VoiceChannel.GetProperty("create_user_code") !== null) Data.CreateUserCode = _Convert2CorrectCode(VoiceChannel.GetProperty("create_user_code").GetStr());
        if(VoiceChannel.GetProperty("name") !== null) Data.ChannelName = VoiceChannel.GetProperty("name").GetStr();
        if(VoiceChannel.GetProperty("description") !== null) Data.Description = VoiceChannel.GetProperty("description").GetStr();
        // if(VoiceChannel.GetProperty("max_voice_player_count") !== null) Data.MaxVoicePlayerCount = VoiceChannel.GetProperty("max_voice_player_count").GetNum();
        Data.MaxVoicePlayerCount = 20; // API上にないとのことなのでひとまず20を渡しておく

        // ユーザーリストを取得
        JsVal users = null;
        if(VoiceChannel.GetProperty("users") !== null) users = VoiceChannel.GetProperty("users");

        if(users === null || (users.GetType() != 1 && users.GetType() != 2))
        {
            Data.CurrentPlayerCount = 0;
        }
        else
        {
            list<JsProp> users_array = users.GetPropertyList();
        
            Data.CurrentPlayerCount = users_array.Count;

            if(EnableUserList)
            {
                list<VCCUserData> JoinUsersData = new list<VCCUserData>();

                for(int UserIndex = 0; UserIndex < users_array.Count; UserIndex++)
                {
                    // 最大ボイスチャンネル入室数以上のユーザー情報は無意味なのでそこで処理を抜ける
                    if(UserIndex >= Data.MaxVoicePlayerCount) break;

                    JsVal user = users_array[UserIndex].GetValue();
                    if(user === null || (user.GetType() != 1 && user.GetType() != 2)) continue;

                    string user_name;
                    if(user.GetProperty("name") !== null) user_name = user.GetProperty("name").GetStr();

                    string icon;
                    if(user.GetProperty("icon") !== null) icon = user.GetProperty("icon").GetStr();

                    string uid;
                    if(user.GetProperty("uid") !== null) uid = user.GetProperty("uid").GetStr();

                    VCCUserData UserData = new VCCUserData();
                    UserData.UserName = user_name;
                    UserData.IconURL = icon;
                    UserData.UserCode= uid;

                    JoinUsersData.Add(UserData);
                }

                // 登録
                Data.JoinUsersData = JoinUsersData;
            }
        }

        return true;
    }

    string _Convert2CorrectCode(string UserCode)
    {
        string InvalidStr = ("vketaccount__");
        int Index = UserCode.IndexOf(InvalidStr);

        return (Index != -1)? UserCode.SubString(InvalidStr.Length(), UserCode.Length() - InvalidStr.Length()) : UserCode;
    }
}
