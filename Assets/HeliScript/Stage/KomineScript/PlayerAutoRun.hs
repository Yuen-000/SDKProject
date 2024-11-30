component PlayerAutoRun
{
    //Player�N���X
    Player  myPlayer;

    //�v���C���[�i�Ăяo���p�j
    Item myPlayerComponent;

    //1F�O�̃v���C���[�̈ʒu
    Vector3 previousPlayerPos;

    //���݂̃v���C���[�̈ʒu�i�J�[�\���ړ���t�ς݁j
    Vector3 currentPlayerPos;

    //�␳��̉�ʂɉf��v���C���[�̈ʒu
    Vector3 newPlayerPos;

    //���[�� -1 0 1
    int playerLane;

    //�ړ��N�[���^�C������p�̃t���[���J�E���g
    int movementFrame;

    //���݈ړ����̌��� -1 0 1
    int direction;

    //�ړ��N�[���^�C��
    const int movementCoolTime = 30;

    //���[���ړ��ɂ�����t���[��
    const int movementAnimeTime = 10;

    //���E�̍L���� 3���[���Ȃ̂�1
    const int laneNumMax = 1;

    //���[���̊Ԃ̋����@�v����
    const float laneDistance = 1.4f;

    //�f�o�b�O���[�h
    bool dAutoRun;

    //�O�̃t���[���ɃJ�������ړ����Ă�����
    bool previousMoveCamera;

    //���J�������ړ����Ă�����
    bool moveCamera;

    //�����ʒu
    Vector3 initialPosition;

    //�f�o�b�O�A�C�e��
    Item debug;

    //�f�o�b�O�A�C�e���̍��W
    Vector3 debugPos;

    public PlayerAutoRun()
    {
        hsSystemOutput("Script:PlayerAutoRun\n");
        hsSystemOutput("Date:20241130\n");
        hsSystemOutput("Version:10.0.0\n");
        hsSystemOutput("Update Content:Supports Attribute Property\n");
        myPlayer = new Player();
        myPlayer = hsPlayerGet();

        myPlayerComponent = hsItemGet("PlayerSettings");

        debug = hsItemGet("Debugger");
        debugPos = debug.GetPos();
        
        if(debugPos.y > 0){
            dAutoRun = true;
        }
        else dAutoRun = false;

        if(!dAutoRun){
            previousPlayerPos = new Vector3();
            previousPlayerPos = myPlayer.GetPos();

            currentPlayerPos = new Vector3();
            currentPlayerPos = previousPlayerPos;

            newPlayerPos = new Vector3();
            newPlayerPos = previousPlayerPos;

            direction = 0;

            movementFrame = 0;
            playerLane = 0;
            myPlayerComponent.SetProperty("playerLane", string(playerLane));
        }
        else{
            hsSystemOutput("Debug Mode : Autorun is now off\n");
        }

        previousMoveCamera = false;

        moveCamera = false;

        initialPosition = new Vector3();
        initialPosition = myPlayer.GetPos();
    }

    public void Update()
    {
        currentPlayerPos = myPlayer.GetPos();
        newPlayerPos = currentPlayerPos;

        if(!dAutoRun && !moveCamera){

            if(previousMoveCamera){
                previousPlayerPos = currentPlayerPos;
                previousMoveCamera = false;
                playerLane = 0;
                myPlayerComponent.SetProperty("playerLane", string(playerLane));
            }

            //������O��
            myPlayer.SetRotate(0.0f);

            if(movementFrame == 0){ //���[���ړ����Ă��Ȃ��Ƃ��̋���
                if((currentPlayerPos.x - previousPlayerPos.x) < -0.01 && playerLane > -laneNumMax){ //��
                    playerLane--;
                    myPlayerComponent.SetProperty("playerLane", string(playerLane));
                    direction = -1;
                    movementFrame++;
                }else if((currentPlayerPos.x - previousPlayerPos.x) > 0.01 && playerLane < laneNumMax){ //�E
                    playerLane++;
                    myPlayerComponent.SetProperty("playerLane", string(playerLane));
                    direction = 1;
                    movementFrame++;
                }else{ //���̂܂�
                    newPlayerPos.x = playerLane * laneDistance;
                }
            }else if(movementFrame > 0){    //�ړ��N�[���^�C�����̋���
                movementFrame++;
                if(movementFrame <= movementAnimeTime){ //���[���ړ���
                    newPlayerPos.x = previousPlayerPos.x + laneDistance / movementAnimeTime * direction;
                }else{  //�N�[���^�C����
                    newPlayerPos.x = playerLane * laneDistance;
                }
                if(movementFrame >= movementCoolTime){  //�N�[���^�C���I��
                    movementFrame = 0;
                    direction = 0;
                }
            }

            //�J�[�\���ł̈ړ��𑊎E
            newPlayerPos.z = previousPlayerPos.z;

            //�O�ɐi�ރx�N�g��
            Vector3 autoRunDistance = makeVector3(0.0f,0.0f,0.1f);
            newPlayerPos.Add(autoRunDistance);

            //�����ňʒu���Z�b�g
            myPlayer.SetPos(newPlayerPos);

            //���̈ʒu�����g���O�̈ʒu��
            previousPlayerPos = newPlayerPos;

            //�O�̂��߂�����x������O�Ɂi���ʂȂ������j
            myPlayer.SetRotate(0.0f);
        }
        else if(!dAutoRun && moveCamera){
            previousMoveCamera = true;
        }
    }

    public void setMoveCameraTrue(){
        moveCamera = true;
    }

    public void setMoveCameraFalse(){
        moveCamera = false;
    }

    public void resetCoordinate(){
        myPlayer.SetPos(initialPosition);
    }
}
