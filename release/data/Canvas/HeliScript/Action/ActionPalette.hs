class Vector2{
    public float x;
    public float y;
    public Vector2(){
        x=0;
        y=0;
    }
    public void Copy(Vector2 v){
        x=v.x;
        y=v.y;
    }
    public void Add(Vector2 v){
        x+=v.x;
        y+=v.y;
    }
}

const int g_ConstActionPaletteLimitSize=6;//アクションパレットのサイズ

//アクションパレットコンポーネント
component ActionPalette
{
    const string send_type_emote_stamp="action_emote_stamp";
    const string send_type_facial="action_facial";
    //アクションリストとのやり取りに使う用
    list<int> emoteIndicesToActionPalette_;
    list<string> emoteIconPathTable_;

    //表情名
    list<string> faceNames_;
    list<int> faceIndices_;

    public list<int> GetEmoteIndicesToActionPalette(){
        return emoteIndicesToActionPalette_;
    }
    
    public list<string> GetEmoteIconPathTable(){
        return emoteIconPathTable_;
    }

    //表情名の初期化
    private void InitFaceNames(){
        faceNames_=new list<string>(5);
        faceNames_[0]="neutral";//無
        faceNames_[1]="joy";//喜
        faceNames_[2]="angry";//怒
        faceNames_[3]="sorrow";//哀
        faceNames_[4]="fun";//楽

        faceIndices_=new list<int>(5);
        faceIndices_[0]=FACIALEMOTETYPE_NEUTRAL;
        faceIndices_[1]=FACIALEMOTETYPE_JOY;
        faceIndices_[2]=FACIALEMOTETYPE_ANGRY;
        faceIndices_[3]=FACIALEMOTETYPE_SORROW;
        faceIndices_[4]=FACIALEMOTETYPE_FUN;

    }
    //表情ボタン名を返す
    private string GetFaceButtonName(int index){
        string preStr="action_palette_";
        return preStr+faceNames_[index];
    }
    //表情を作る
    private void MakeFace(int index){
        Player player=hsPlayerGet();
        player.FacialEmote(faceIndices_[index]);
        string data;
        data="%d" % index;
        hsNetSendCustomData(send_type_facial,data);
    }

    public ActionPalette()
    {
        emoteIndicesToActionPalette_=new list<int>(g_ConstActionPaletteLimitSize);
        //デフォルト設定
        emoteIndicesToActionPalette_[0]=0;//指さし
        emoteIndicesToActionPalette_[1]=1;//サムズアップ
        emoteIndicesToActionPalette_[2]=2;//てふり
        emoteIndicesToActionPalette_[3]=3;//合掌
        emoteIndicesToActionPalette_[4]=4;//ダンス
        emoteIndicesToActionPalette_[5]=5;//OK

        emoteIconPathTable_=new list<string>(10);
        emoteIconPathTable_[0]="gui2023/action/action_item_point.png";//指さし
        emoteIconPathTable_[1]="gui2023/action/action_item_thumbsup.png";//サムズアップ
        emoteIconPathTable_[2]="gui2023/action/action_item_wave.png";//手をフル
        emoteIconPathTable_[3]="gui2023/action/action_item_pray.png";//合掌
        emoteIconPathTable_[4]="gui2023/action/action_item_dance.png";//ダンス
        emoteIconPathTable_[5]="gui2023/action/action_item_ok.png";//OK
        emoteIconPathTable_[6]="gui2023/action/action_item_ng.png";//NG
        emoteIconPathTable_[7]="gui2023/action/action_item_no1.png";//ガッツポーズ
        emoteIconPathTable_[8]="gui2023/action/action_item_no2.png";//両手をフル
        emoteIconPathTable_[9]="gui2023/action/action_item_no3.png";//オタ芸

        AnalyzeActionPaletteCookie();

        InitFaceNames();
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

    }

    //エモートスタンプ・表情が飛んでくる
    public void OnReceiveCustomData(string id, string type, string data)
    {
        if(type==send_type_emote_stamp){
            int idx = data.ToInt();
            Player player = hsPlayerGetByID(id);
            player.EmotePopup(emoteIconPathTable_[idx]);

        }else if(type==send_type_facial){
            int idx = data.ToInt();
            Player player = hsPlayerGetByID(id);
            player.FacialEmote(faceIndices_[idx]);
        }
    }

    public void OnShowActionPalette(){
        for(int i=0 ; i<emoteIndicesToActionPalette_.Count();++i){
            int idx= emoteIndicesToActionPalette_[i];
            string btnName="action_palette_button%d" % (i+1);
            hsCanvasSetGUIImage("action_palette",btnName , emoteIconPathTable_[idx]);
        }
    }

    //タブをエモートボタンモードに切り替える
    private void ChangePaletteEmoteMode(){
        hsCanvasResetToggleDefault("Emote_Tab_On_Toggle");
        hsCanvasResetToggleDefault("Face_Tab_On_Toggle");
    }

    //タブを表情ボタンモードに切り替える
    private void ChangePaletteFaceMode(){
        hsCanvasResetToggleDefault("Emote_Tab_On_Toggle");
        hsCanvasResetToggleDefault("Face_Tab_On_Toggle");
        hsCanvasToggleChange("Emote_Tab_On_Toggle");
        hsCanvasToggleChange("Face_Tab_On_Toggle");
    }

    //現在のパレットインデックスから、エモートを再生
    //有効なインデックスでなければなにもしない
    private void PlayEmote(int idx){
        if(idx<emoteIndicesToActionPalette_.Count()){
            int emoteIndex=emoteIndicesToActionPalette_[idx];
            Player player=hsPlayerGet();
            player.Emote(emoteIndex);
            player.EmotePopup(emoteIconPathTable_[emoteIndex]);
            string data;
            data="%d" % emoteIndex;
            hsNetSendCustomData(send_type_emote_stamp,data);
        }
    }
    //エモートボタンクリックチェック
    //有効なエモートボタンなら再生まで行う
    private bool CheckEmoteButtonClicked(string btnName){
        //各種エモートボタン
        for(int i=0 ; i<emoteIndicesToActionPalette_.Count();++i){
            string name="action_palette_button%d" % (i+1);
            if(btnName==name){
                PlayEmote(i);
                return true;//どれかが押されてたらリターンする
            }
        }
        return false;
    }

    //表情ボタンクリックチェック
    private bool CheckFaceButtonClicked(string btnName){
        for(int i=0;i<faceIndices_.Count();++i){
            string strBtnName = GetFaceButtonName(i);
            if(btnName==strBtnName){
                MakeFace(i);
                return true;
            }
        }
        return false;
    }

    //GUIボタンクリック    
    public void OnClickedButton(string layerName,string btnName){
        if(layerName=="HUD" && btnName=="hud_emote_pal_on"){
            OnShowActionPalette();
        }else if(layerName=="action_palette"){
            if(btnName=="action_emote_off_tab"){
                ChangePaletteEmoteMode();
                return;
            }else if(btnName=="action_face_off_tab"){
                ChangePaletteFaceMode();
                return;
            }else if(CheckEmoteButtonClicked(btnName)){//エモートボタンのどれかが押されたか
                return;//おされてたらここでリターン
            }else if(btnName=="action_add_item_btn"){
                LayerBundle layer = hsLayerGet("action_list");
                if(layer === null) return;
                layer.CallComponentMethod("EmoteActionList", "OnAddItemOpen", "");
            }else{
                if(CheckFaceButtonClicked(btnName)){
                    return;
                }
            }

        }
    }

    public void Update(){
    }
}