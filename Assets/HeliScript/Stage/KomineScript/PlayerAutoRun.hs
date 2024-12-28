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
    int MOVEMENTCOOLTIME;

    //���[���ړ��ɂ�����t���[��
    int MOVEMENTANIMETIME;

    //���E�̍L���� 3���[���Ȃ̂�1
    const int laneNumMax = 1;

    //���[���̊Ԃ̋����@�v����
    float LANEDISTANCE;

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

    //�X�s�[�h�A�b�v���Ă��邩
    bool isSpeedUp;

    //�X�s�[�h�A�b�v�c�莞��
    int speedUpTime;

    //�X�s�[�h�A�b�v���
    int SPEEDUP_TIMELIMIT;

    //�ʏ�̈ړ����x
    float SPEED_NORMAL;

    //�A�C�e���g�p���̈ړ����x
    float SPEED_ITEM;

    //���݂̈ړ����x
    float speedCurrent;

    public PlayerAutoRun()
    {
        hsSystemOutput("Script:PlayerAutoRun\n");
        hsSystemOutput("Date:20241282\n");
        hsSystemOutput("Version:11.0.0\n");
        hsSystemOutput("Update Content:Support for speed up\n");
        myPlayer = new Player();
        myPlayer = hsPlayerGet();

        myPlayerComponent = hsItemGet("PlayerSettings");

        LANEDISTANCE = (myPlayerComponent.GetProperty("LANEDISTANCE")).ToFloat();

        MOVEMENTCOOLTIME = (myPlayerComponent.GetProperty("MOVEMENTCOOLTIME")).ToInt();

        MOVEMENTANIMETIME = (myPlayerComponent.GetProperty("MOVEMENTANIMETIME")).ToInt();

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

        isSpeedUp = false;

        speedUpTime = 0;

        SPEEDUP_TIMELIMIT = int((myPlayerComponent.GetProperty("SPEEDUPTIME")).ToFloat() * 60);

        SPEED_NORMAL = (myPlayerComponent.GetProperty("SPEED_NORMAL")).ToFloat() / 60.0;

        SPEED_ITEM = (myPlayerComponent.GetProperty("SPEED_ITEM")).ToFloat() / 60.0;

        speedCurrent = SPEED_NORMAL;
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

            if(isSpeedUp){
                speedCurrent = SPEED_ITEM;
                speedUpTime--;
                if(speedUpTime == 0){
                    setSpeedUpEnd();
                }
            }
            else speedCurrent = SPEED_NORMAL;

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
                    newPlayerPos.x = playerLane * LANEDISTANCE;
                }
            }else if(movementFrame > 0){    //�ړ��N�[���^�C�����̋���
                movementFrame++;
                if(movementFrame <= MOVEMENTANIMETIME){ //���[���ړ���
                    newPlayerPos.x = previousPlayerPos.x + LANEDISTANCE / MOVEMENTANIMETIME * direction;
                }else{  //�N�[���^�C����
                    newPlayerPos.x = playerLane * LANEDISTANCE;
                }
                if(movementFrame >= MOVEMENTCOOLTIME){  //�N�[���^�C���I��
                    movementFrame = 0;
                    direction = 0;
                }
            }

            //�J�[�\���ł̈ړ��𑊎E
            newPlayerPos.z = previousPlayerPos.z;

            //�O�ɐi�ރx�N�g��
            Vector3 autoRunDistance = makeVector3(0.0f,0.0f,speedCurrent);
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

    public void setSpeedUpStart(){
        isSpeedUp = true;
        speedUpTime = SPEEDUP_TIMELIMIT;
        myPlayerComponent.SetProperty("isSpeedUp","true");
    }

    public void setSpeedUpEnd(){
        isSpeedUp = false;
        speedUpTime = 0;
        myPlayerComponent.SetProperty("isSpeedUp","false");
    }
}
