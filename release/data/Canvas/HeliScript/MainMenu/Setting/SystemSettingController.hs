component SystemSettingController
{
    public void OnLoaded()
    {
        if(hsIsMobile())
        {
            // モバイル端末の時はシーンファイルでSSAOがオンになっていても内部的には(重いため)オフになるので、UIも非アクティブ状態に切り替える
            hsCanvasResetToggleDefault("SettingSystem_SSAO_Available");
        }
    }

    public void OnClickedButton(string LayerName, string ButtonName)
    {
    }
}