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

    public ActionStartArea()
    {
        hsSystemOutput("Script:HitBoxActionArea\n");
        hsSystemOutput("Date:20241028\n");
        hsSystemOutput("Version:3.5.0\n");
        hsSystemOutput("Update Content:Update Flag\n");

        myActionUI = hsItemGet("ActionUIScript");
        myActionButton = hsItemGet("ActionButtonScript");

        myArea = hsItemGetSelf();

        areaCoordinate = myArea.GetPos();

        areaZCoor = areaCoordinate.z;

        areaName = myArea.GetName();

        myPlayer = new Player();

        isActionTime = false;

        myPlayerComponent = hsItemGet("PlayerSettings");
    }

    public void Update()
    {
        playerCoordinate = myPlayer.GetPos();
        playerZCoor = playerCoordinate.z;

        if(playerZCoor - areaZCoor < 1.0f && playerZCoor - areaZCoor >= 0.0f && !isActionTime){
            isActionTime = true;
            hsSystemOutput("Action time for Z Coordinate " + string(areaZCoor) + " has begun!\n");

            hsSystemOutput("Passing area!\n");
            myPlayerComponent.CallComponentMethod("ActionTimeManagement", "recieveActionStart", areaName);
            myActionUI.CallComponentMethod("ActionUI", "startActionTime", "");
            myActionButton.CallComponentMethod("ActionButton", "SetActionFlagTrue", "");

            if(areaName == "ActionArea1"){
                Item gateL = hsItemGet("Gate1DoorLeft");
                //Item gateR = hsItemGet("Gate1RightAxis");

                gateL.CallComponentMethod("Gate1LeftAnimation", "setClose", "");
                //gateR.CallComponentMethod("Gate1RightAnimation", "setClose", "");
            }
            else if(areaName == "hogehoge"){
            }
            else if(areaName == "fugafuga"){
            }
        }
    }

    public void endActionTime()
    {
        if(isActionTime){
            isActionTime = false;
            hsSystemOutput("Action time for Z Coordinate " + string(areaZCoor) + " has ended!\n");
        }
    }
}
