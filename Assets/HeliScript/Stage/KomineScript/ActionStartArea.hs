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

    //�N���A�t���O
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
