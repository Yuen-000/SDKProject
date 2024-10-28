component ActionStartArea
{
    //ActionUI
    Item myActionUI;

    //ActionButton
    Item myActionButton;

    //���̃A�C�e��
    Item myArea;

    //���̃A�C�e���̍��W�iVector3�j
    Vector3 areaCoordinate;

    //���̃A�C�e����Z���W
    float areaZCoor;

    //���̃A�C�e���̖��O
    string areaName;

    //Player
    Player myPlayer;

    //�v���C���[�̍��W�iVector3�j
    Vector3 playerCoordinate;

    //�v���C���[��Z���W
    float playerZCoor;

    //�A�ŃA�N�V�����˓�����
    bool isActionTime;

    //Player�i�֐��Ăяo���p�j
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
