
string g_avatarType="common";//今の所commonのみ

//アクションパレットコントローラコンポーネント
component ActionPaletteController
{

    
    public void OnWindowActivate(bool IsActivate){
        //hsSystemOutput("ActionPaletteController::OnWindowActivate\n");
    }
    //OnLoadは何故か呼ばれない事があるため信頼しない事にする
    public void OnLoad(){

    }
    //GUIボタンクリック    
    public void OnClickedButton(string layerName,string btnName){
        if(layerName=="HUD" && btnName=="hud_emote_pal_on"){
            LayerBundle layer = hsLayerGet("action_palette");
            if(layer !== null) 
            {
                ActionPalette pal=system.Layer_GetComponentByName<ActionPalette>("action_palette");
                pal.OnShowActionPalette();
            }else{
                hsSystemOutput("action_palette is null \n");
            }
        }
    }
}