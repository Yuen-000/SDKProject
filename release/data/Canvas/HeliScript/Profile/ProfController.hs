

const string other_profile_layer="other_profile";

component ProfController
{
    string currentPlayerID_;
    bool isLoggedIn_;
    bool isHideTarget_;

    ProfileModel profileModel_;

    Player currentLockingPlayer_;

    public ProfController()
    {
        isLoggedIn_=false;
        currentLockingPlayer_=null;
        profileModel_=null;
    }

    public bool IsLoggedIn(){
        return isLoggedIn_;
    }



    void _LoggedInCallbackForFindUserData(bool loginValid){
        isLoggedIn_=loginValid;
        LayerBundle layer=hsLayerGet(other_profile_layer);
        if(layer===null){
            profileModel_=null;
        }else{
            profileModel_=system.Layer_GetComponentByName<ProfileModel>(other_profile_layer);
            profileModel_.FindUserDataAndShowProfile(currentPlayerID_,loginValid);
        }
    }


    public void LoginCheckForProfile(){
        api.auths.isLoggedIn(_LoggedInCallbackForFindUserData);
    }


    //現在選択中のプレイヤー情報を返す
    public Player GetCurrentLockingPlayer(){
        return currentLockingPlayer_;
    }
    public string GetLockingPlayerID(){
        return currentPlayerID_;
    }
    public void UnlockPlayer(){
        currentLockingPlayer_=null;
        currentPlayerID_="";
    }
    public void LockPlayer(string playerID){
        currentPlayerID_=playerID;
        currentLockingPlayer_=hsPlayerGetByID(playerID);
    }

    private AvatarTargetModel GetAvatarTargetModel(){
        LayerBundle layerVCC=hsLayerGet("avatar_target");
        if(layerVCC===null){
            hsSystemOutput("avatar_targetレイヤーがNULL\n");
            return null;
        }else{
            AvatarTargetModel avatarTarget=system.Layer_GetComponentByName<AvatarTargetModel>("avatar_target");
            if(avatarTarget===null){
                hsSystemOutput("avatarTargetコンポーネントがNULL\n");
                return null;
            }else{
                return avatarTarget;
            }
        }
        return null;
    }
    
    public void DeactivateLockedPlayer(){
        AvatarTargetModel avatarTarget=GetAvatarTargetModel();
        avatarTarget.DeactivateLockedPlayer();
    }
}