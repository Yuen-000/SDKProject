// class Vector2{
//     public float x;
//     public float y;
//     public Vector2(){
//         x=0;
//         y=0;
//     }
//     public void Copy(Vector2 v){
//         x=v.x;
//         y=v.y;
//     }
//     public void Add(Vector2 v){
//         x+=v.x;
//         y+=v.y;
//     }
// }

// const int g_ConstActionPaletteLimitSize=6;//アクションパレットのサイズ

class EmoteData{
    int id;
    string name;
    string name_en;
    string motionURL;
    string iconURL;
    int order;
    bool isBlackList;
}

//アクションパレットコンポーネント
component ActionPaletteWithServer
{
    //アクションリストとのやり取りに使う用
    list<int> emoteIndicesToActionPalette_;//=new list<int>(0);
    list<string> emoteIconPathTable_;

    public list<int> GetEmoteIndicesToActionPalette(){
        return emoteIndicesToActionPalette_;
    }
    
    public list<string> GetEmoteIconPathTable(){
        return emoteIconPathTable_;
    }
    public void OnWindowActivate(bool IsActivate){
        //hsSystemOutput("ActionPalette::OnWindowActivate\n");
    }


    //コンストラクタ→ログイン処理コールバック
    void _OnLoggedInCallBack(bool isLoggedIn){
        
        if(isLoggedIn){
            InitLoggedInUser();
        }else{
            //ゲストユーザの時だけuuidが必要なのでもうワンクッション入る
            api.channelSessionApi.fetchMyProfile(_fetchGuestUserCodeCallback);
            
        }
    }

    //ゲストユーザコード取得コールバック(自分のプロフィール取得コールバック)
    void _fetchGuestUserCodeCallback(string param)
    {
        Json ProfileJson = hsLoadJson(param);
        if(ProfileJson === null) return;

        Json data = ProfileJson.Find(EJSONDataType_Block, "data");
        if(data === null) return;

        Json user = data.Find(EJSONDataType_Block, "user");
        if(user === null) return;

        string uuid;
        user.FindValueString("uid", uuid);
        InitGuestUser(uuid);
    }

    //ログインユーザのエモートパレットのコールバック
    void _GetUserEmotePaletteCallback(string emoteData){
        Json emoteJson = hsLoadJson(emoteData);
        if(emoteJson === null) return;
        Json emoteArray=emoteJson.Find(EJSONDataType_Array,"emotes");
        if(emoteArray===null)return;
        list<Json> emoteJsonList=emoteArray.GetArrayList();
        int num =  emoteJsonList.Count();
        for(int i=0;i<num; ++i){
            string name;
            emoteJsonList[i].FindValueString("name",name);
            hsSystemOutput("emoteJs %s \n" % name);
        }

        //list<string>=new list<string>(g_ConstActionPaletteLimitSize);
    }
    //非ログインユーザのエモートパレットコールバック
    void _GetGuestEmotePaletteCallback(string emoteData){
        hsSystemOutput("%s\n" % emoteData);
        hsSystemOutput("_GetGuestEmotePaletteCallback\n");
    }

    //ログインユーザ時のパレット初期化(データ読み込み)
    private void InitLoggedInUser(){
        // hsSystemOutput("ActionPaletteController::LoggedIn\n");
        string worldId = hsGetCurrentWorldId();
        // api.emotes.getUserEmotePallets(_GetUserEmotePaletteCallback, hsNetGetSpatiumCode(), worldId, g_avatarType);
    }

    //非ログインユーザ時のパレット初期化(データ読み込み)
    private void InitGuestUser(string uuid){
        hsSystemOutput("ActionPaletteController::Guest\n");
        string worldId = hsGetCurrentWorldId();
        // api.emotes.getGuestEmotePallets(_GetGuestEmotePaletteCallback,uuid, hsNetGetSpatiumCode(), worldId, g_avatarType);
    }
    //コンストラクタ
    public ActionPaletteWithServer()
    {
        //パレット情報をサーバから取得する
        api.auths.isLoggedIn(_OnLoggedInCallBack);

        // //hsSystemOutput("ActionPalette::ActionPalette\n");
        // emoteIndicesToActionPalette_=new list<int>(g_ConstActionPaletteLimitSize);
        // //デフォルト設定
        // emoteIndicesToActionPalette_[0]=0;//指さし
        // emoteIndicesToActionPalette_[1]=1;//サムズアップ
        // emoteIndicesToActionPalette_[2]=2;//てふり
        // emoteIndicesToActionPalette_[3]=3;//合掌
        // emoteIndicesToActionPalette_[4]=4;//ダンス
        // emoteIndicesToActionPalette_[5]=5;//OK

        // emoteIconPathTable_=new list<string>(10);
        // emoteIconPathTable_[0]="gui2023/action/action_item_point.png";//指さし
        // emoteIconPathTable_[1]="gui2023/action/action_item_thumbsup.png";//サムズアップ
        // emoteIconPathTable_[2]="gui2023/action/action_item_wave.png";//手をフル
        // emoteIconPathTable_[3]="gui2023/action/action_item_pray.png";//合掌
        // emoteIconPathTable_[4]="gui2023/action/action_item_dance.png";//ダンス
        // emoteIconPathTable_[5]="gui2023/action/action_item_ok.png";//OK
        // emoteIconPathTable_[6]="gui2023/action/action_item_ng.png";//NG
        // emoteIconPathTable_[7]="gui2023/action/action_item_no1.png";//ガッツポーズ
        // emoteIconPathTable_[8]="gui2023/action/action_item_no2.png";//両手をフル
        // emoteIconPathTable_[9]="gui2023/action/action_item_no3.png";//オタ芸

        // AnalyzeActionPaletteCookie();
    }
    //アクションパレット用のクッキーからインデックスを解析する
    private void AnalyzeActionPaletteCookie(){
        string savedEmoteIndices=hel_get_cookie_onEmptyStr(SAVED_EMOTE_INDICES);
        if(savedEmoteIndices==""){
            return;
        }
        string subStr=savedEmoteIndices;
        // int idx=subStr.IndexOf(",");
        // int len = subStr.Length();
        // emoteIndicesToActionPalette_.Clear();
        // while(idx>0){
        //     emoteIndicesToActionPalette_.Add(subStr.SubString(0,idx).ToInt());
        //     subStr = subStr.SubString(idx+1,len-idx-1);
        //     idx=subStr.IndexOf(",");
        // }
        list<string> splits=subStr.Split(",");
        emoteIndicesToActionPalette_.Clear();
        for( int i=0 ; i<splits.Count(); ++i){
            emoteIndicesToActionPalette_.Add(splits[i].ToInt());
        }
        //emoteIndicesToActionPalette_.Add(subStr.SubString(0,idx).ToInt());
    }
    public void OnLoaded(){
        // string savedEmoteIndices=hel_get_cookie_onEmptyStr(SAVED_EMOTE_INDICES);
        //AnalyzeActionPaletteCookie();
        //hsSystemOutput("ActionPalette::OnLoad\n");
        
    }
    public void OnShowActionPalette(){
        for(int i=0 ; i<emoteIndicesToActionPalette_.Count();++i){
            int idx= emoteIndicesToActionPalette_[i];
            string btnName="action_palette_button%d" % (i+1);
            hsCanvasSetGUIImage("action_palette",btnName , emoteIconPathTable_[idx]);
        }
    }
    //GUIボタンクリック    
    public void OnClickedButton(string layerName,string btnName){
        if(layerName=="HUD" && btnName=="hud_emote_pal_on"){
            OnShowActionPalette();
        }else if(layerName=="action_palette"){
            for(int i=0 ; i<emoteIndicesToActionPalette_.Count();++i){
                string name="action_palette_button%d" % (i+1);
                
                if(btnName==name){
                    if(i<emoteIndicesToActionPalette_.Count()){
                        int emoteIndex=emoteIndicesToActionPalette_[i];
                        Player player=hsPlayerGet();
                        player.Emote(emoteIndex);
                    }
                }
            }
        }
    }

    public void Update(){
    }
}