class AvatarTargetInfo{
    public bool isShownTarget;
    public AvatarTargetInfo(){
        isShownTarget=false;
    }
}

component AvatarTargetModel
{
    const float target_offset_y=0.9;//90cmくらいをターゲット位置に
    const float target_offset_yrate=0.67;//身長の2/3くらいをターゲット位置に
    Vector2 currentPos_;
    Vector3 currentPlayerPos_;
    AvatarTargetInfo AvatarTargetInfo_;
    bool isHideTarget_;
    int count_;
    public AvatarTargetModel(){
        AvatarTargetInfo_=new AvatarTargetInfo();
        currentPos_=new Vector2();
        currentPlayerPos_=new Vector3();
        isHideTarget_=false;
        count_=0;
    }
    public AvatarTargetInfo GetAvatarTargetInfo(){
        return AvatarTargetInfo_;
    }

    //他のノードオブジェクトがクリックされた→(選択解除)
    public void OnClickNode(int nodeIndex){
        DeactivateTarget();
    }
    //何もクリックされなかった→選択解除
    public void OnClickEmpty(){
        DeactivateTarget();
    }

    public void OnClickedButton(string layerName,string btnName){
        if(layerName!="other_profile"){//プロフィール表示中はアバター選択を解除しない
            if(layerName=="avatar_target"){
                if(btnName=="avatar_target_base_btn"){
                    //選択解除
                    DeactivateTarget();
                }else if(btnName == "profile_btn"){
                    ProfController profCtrl=GetProfController();
                    profCtrl.LoginCheckForProfile();
                }
            }else{
                //選択解除
                DeactivateTarget();
            }
        }
    }
        //アバタークリック
    public void OnClickedAvatar(string playerID)
    {
        Player player=hsPlayerGetByID(playerID);
        if(player!==null){
            if(IsSelectableAvatar(player)){
                ProfController profCtrl=GetProfController();
                //同じプレイヤーがクリックされたら解除のまま
                if(playerID==profCtrl.GetLockingPlayerID()){
                    DeactivateTarget();
                    return;
                }
                profCtrl.LockPlayer(playerID);
                //currentLockingPlayer_=player;
                UpdateCurrentPlayerPos();

                hsCanvasSetLayerShow("avatar_target", true);
                
                float px,py;
                hsCanvasWorldToScreenPos(currentPlayerPos_,px,py);
                currentPos_.x=px;
                currentPos_.y=py;
                
                //一旦デフォルトに戻す
                DeactivateTarget();
                profCtrl.LockPlayer(playerID);//DeactivateでCurrentPlayerID_がリセットされるためここに記述
                ActivateTarget();
                
                DrawTargetGUI(px,py,true);
            }
        }else{
            DeactivateLockedPlayer();
        }
        
    }
    public void DeactivateLockedPlayer(){
        ProfController profCtrl=GetProfController();
        profCtrl.UnlockPlayer();
        DeactivateTarget();
    }
    
    private ProfController GetProfController(){
        LayerBundle layerVCC=hsLayerGet("other_profile");
        if(layerVCC===null){
            hsSystemOutput("other_profileレイヤーがNULL\n");
            return null;
        }else{
            ProfController profCtrl=system.Layer_GetComponentByName<ProfController>("other_profile");
            if(profCtrl===null){
                hsSystemOutput("ProfControllerコンポーネントがNULL\n");
                return null;
            }else{
                return profCtrl;
            }
        }
        return null;
    }
    private void HideTargetCircle(){
        hsCanvasResetToggleDefault("avatar_target_image_1_toggle");
        hsCanvasResetToggleDefault("avatar_target_image_2_toggle");
        hsCanvasResetToggleDefault("avatar_profile_toggle");
        hsCanvasResetToggleDefault("avatar_target_show_toggle");
        isHideTarget_=true;
    }

    //ターゲッティングを無効にする
    private void DeactivateTarget(){
        AvatarTargetInfo_.isShownTarget=false;
        HideTargetCircle();
        ProfController profCtrl=GetProfController();
        profCtrl.UnlockPlayer();
    }
    //ターゲッティングを有効にする
    private void ActivateTarget(){
        hsCanvasToggleChange("avatar_target_image_1_toggle");
        hsCanvasToggleChange("avatar_profile_toggle");
        hsCanvasToggleChange("avatar_target_show_toggle");
        AvatarTargetInfo_.isShownTarget=true;
        isHideTarget_=false;
    }
    private bool IsSelectableAvatar(Player player){
        if(player===null){
            return false;
        }
        Player myPlayer=hsPlayerGet();
        //20m以内ならtrue
        Vector3 playerPos = player.GetPos();
        Vector3 myPlayerPos = myPlayer.GetPos();
        return playerPos.Distance(myPlayerPos)<=20.0f;
    }
    private void UpdateCurrentPlayerPos(){

        ProfController profCtrl=GetProfController();
        Player player = profCtrl.GetCurrentLockingPlayer();

        Vector3 playerPos=player.GetPos();
        currentPlayerPos_=playerPos;

        float height=player.GetHeadHeight();
        if(height==0.0){
            currentPlayerPos_.y+=target_offset_y;//デフォだと足元なので補正(headボーンがない場合に規定値に)
        }else{
            currentPlayerPos_.y+=player.GetHeadHeight()*target_offset_yrate;//デフォだと足元なので補正(目線の2/3に)
        }
    }
    public void OnLoaded()
    {
        DeactivateTarget();
    }

    public void DrawTargetGUI(float x, float y,bool changeFlg){
        if(changeFlg){
            hsCanvasToggleChange("avatar_target_image_1_toggle");
            hsCanvasToggleChange("avatar_target_image_2_toggle");
        }
        hsCanvasSetGUIPos("avatar_target",hsCanvasIsPortrait(),"avatar_target_image_1",x,y);
        hsCanvasSetGUIPos("avatar_target",hsCanvasIsPortrait(),"avatar_target_image_2",x,y);
        hsCanvasSetGUIPos("avatar_target",hsCanvasIsPortrait(),"avatar_target_base_btn",x,y);
        hsCanvasSetGUIPos("avatar_target",hsCanvasIsPortrait(),"profile_btn",x,y);
        
    }

    void Update(){
        if(!AvatarTargetInfo_.isShownTarget){
            return;
        }
        count_ = (count_+1)%60;
        if(count_%5==0){
            ProfController profCtrl=GetProfController();
            if(IsSelectableAvatar(profCtrl.GetCurrentLockingPlayer())){
                UpdateCurrentPlayerPos();
                float px,py;
                hsCanvasWorldToScreenPos(currentPlayerPos_,px,py);
                 //変換した結果px=0.0,py=0.0ならば無効と言う事で、一時的にターゲットを非表示とする
                if(px==0.0 && py==0.0){
                    HideTargetCircle();    
                } else{
                    //もし一度隠されて再表示一回目ならActivateしなおす
                    if(isHideTarget_){
                        ActivateTarget();
                    }
                    currentPos_.x=px;
                    currentPos_.y=py;
                    DrawTargetGUI(currentPos_.x,currentPos_.y,count_==0);
                }
            }else{
                DeactivateTarget();
            }
            
        }
    }
}