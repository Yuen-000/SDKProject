class MyAvatarUserData
{
    public string PlayerID;
    public string UUID;
}

class MyAvatarData
{
    string m_UUID;
    string m_ThumbnailURI;
    string m_Name;

    string m_PlayerID;
    string m_DownloadToken;

    public MyAvatarData()
    {
        SetVal("", "", "");
    }

    public void SetVal(string uuid, string ThumbnailURI, string name)
    {
        m_UUID = uuid;
        m_ThumbnailURI = ThumbnailURI;
        m_Name = name;
    }

    public string GetUUID()
    {
        return m_UUID;
    }
    
    public void SetUUID(string UUID)
    {
        m_UUID = UUID;
    }

    public string GetThumbnailURI()
    {
        return m_ThumbnailURI;
    }

    public string GetName()
    {
        return m_Name;
    }

    public string GetPlayerID()
    {
        return m_PlayerID;
    }

    public void SetPlayerID(string PlayerID)
    {
        m_PlayerID = PlayerID;
    }

    public string GetDownloadToken()
    {
        return m_DownloadToken;
    }

    public void SetDownloadToken(string DownloadToken)
    {
        m_DownloadToken = DownloadToken;
    }
}