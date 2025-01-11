component ActionStartArea
{
    //ActionUI
    Item myActionUI;

    //ActionButton
    Item myActionButton;

    //ActionParticle
    Item myActionParticle;

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

    //�v���C���[��Z���Wpassing
    float playerZCoor;

    //�A�ŃA�N�V�����˓�����
    bool isActionTime;

    //Player�i�֐��Ăяo���p�j
    Item myPlayerComponent;

    //�X�s�[�h�A�b�v�G�t�F�N�g
    Item speedUpParticle;

    public ActionStartArea()
    {
        hsSystemOutput("Script:HitBoxActionArea\n");
        hsSystemOutput("Date:20241209\n");
        hsSystemOutput("Version:4.0.0\n");
        hsSystemOutput("Update Content:Update Particle\n");

        myActionUI = hsItemGet("ActionUIScript");
        myActionButton = hsItemGet("ActionButtonScript");
        myActionParticle = hsItemGet("particle_action");

        myArea = hsItemGetSelf();

        areaCoordinate = myArea.GetPos();

        areaZCoor = areaCoordinate.z;

        areaName = myArea.GetName();

        myPlayer = new Player();

        isActionTime = false;

        myPlayerComponent = hsItemGet("PlayerSettings");

        speedUpParticle = hsItemGet("SpeedUpParticle");
    }

    public void Update()
    {
        playerCoordinate = myPlayer.GetPos();
        playerZCoor = playerCoordinate.z;

        if(playerZCoor - areaZCoor < 1.0f && playerZCoor - areaZCoor >= 0.0f && !isActionTime){
            isActionTime = true;
            hsSystemOutput("Action time for Z Coordinate " + string(areaZCoor) + " has begun!\n");

            hsSystemOutput("Passing area! " + areaName + "\n");
            myPlayerComponent.CallComponentMethod("ActionTimeManagement", "recieveActionStart", areaName);
            myActionUI.CallComponentMethod("ActionUI", "startActionTime", "");
            myActionParticle.CallComponentMethod("ActionParticle", "setActionTrue", "");
            myActionButton.CallComponentMethod("ActionButton", "SetActionFlagTrue", "");

            myPlayerComponent.CallComponentMethod("PlayerAutoRun", "setSpeedUpEnd", "");
            speedUpParticle.CallComponentMethod("SpeedUpParticle","setActionFalse","");

            if(areaName == "ActionArea1"){
                Item gateL = hsItemGet("Gate1LeftDoor");
                Item gateR = hsItemGet("Gate1RightDoor");

                gateL.CallComponentMethod("Gate1LeftAnimation", "setClose", "");
                gateR.CallComponentMethod("Gate1RightAnimation", "setClose", "");
            }
            else if(areaName == "hogehoge"){
            }
            else if(areaName == "ActionArea3"){
                Item gateL = hsItemGet("Gate3LeftWall");
                Item gateR = hsItemGet("Gate3RightWall");

                gateL.CallComponentMethod("Gate3LeftAnimation", "setClose", "");
                gateR.CallComponentMethod("Gate3RightAnimation", "setClose", "");
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
