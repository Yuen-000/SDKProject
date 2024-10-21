component ActionStartArea
{
    //ActionUI
    Item myActionUI;

    //ActionButton
    Item myActionButton;

    //このアイテム
    Item myArea;

    //このアイテムの座標（Vector3）
    Vector3 areaCoordinate;

    //このアイテムのZ座標
    float areaZCoor;

    //このアイテムの名前
    string areaName;

    //Player
    Player myPlayer;

    //プレイヤーの座標（Vector3）
    Vector3 playerCoordinate;

    //プレイヤーのZ座標
    float playerZCoor;

    //連打アクション突入判定
    bool isActionTime;

    //Player（関数呼び出し用）
    Item myPlayerComponent;

    //クリアフラグ
    //bool isCleared;

    public ActionStartArea()
    {
        hsSystemOutput("Script:HitBoxActionArea\n");
        hsSystemOutput("Date:20241021\n");
        hsSystemOutput("Version:3.3.0\n");
        hsSystemOutput("Update Content:Changed the way area determination is taken\n");

        myActionUI = hsItemGet("ActionUIScript");
        myActionButton = hsItemGet("ActionButtonScript");

        myArea = hsItemGetSelf();

        areaCoordinate = myArea.GetPos();

        areaZCoor = areaCoordinate.z;

        areaName = myArea.GetName();

        myPlayer = new Player();

        isActionTime = false;

        myPlayerComponent = hsItemGet("PlayerSettings");

        //isCleared = false;
    }

    public void Update()
    {
        playerCoordinate = myPlayer.GetPos();
        playerZCoor = playerCoordinate.z;

        if(playerZCoor >= areaZCoor){
            myPlayerComponent.CallComponentMethod("ActionTimeManagement", "compareDistance", string(areaZCoor));
        }
    }

    public void passingArea()
    {
        
        isActionTime = true;
        hsSystemOutput("Action time for Z Coordinate " + string(areaZCoor) + " has begun!\n");

        hsSystemOutput("Passing area!\n");
        myPlayerComponent.CallComponentMethod("ActionTimeManagement", "recieveActionStart", areaName);
        myActionUI.CallComponentMethod("ActionUI", "startActionTime", "");
        myActionButton.CallComponentMethod("ActionButton", "SetActionFlagTrue", "");
    }

    public void endActionTime()
    {
        if(isActionTime){
            isActionTime = false;
            hsSystemOutput("Action time for Z Coordinate " + string(areaZCoor) + " has ended!\n");
        }
    }

    public void recieveCleared()
    {
        //isCleared = true;

        myPlayerComponent.CallComponentMethod("ActionTimeManagement", "setClearDistance", string(areaZCoor));
    }
}
