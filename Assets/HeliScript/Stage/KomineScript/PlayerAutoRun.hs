component PlayerAutoRun
{
    //Player�N���X
    Player  myPlayer;

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

    //�A�ŃG���A�ɓ˓�����Z���W�̃��X�g
    list<float> hitBoxAreaList;

    //�A�ŃA�N�V��������
    bool isActionTime;

    //�f�o�b�O���[�h
    bool dAutoRun;

    //ActionButton
    Item myActionButton;
    
    //GameoverScript
    Item GameOver;

    //GameClearScript
    Item GameClear;

    //�O�̃t���[���ɃJ�������ړ����Ă�����
    bool previousMoveCamera;

    //���J�������ړ����Ă�����
    bool moveCamera;

    public PlayerAutoRun()
    {
        hsSystemOutput("Script:PlayerAutoRun\n");
        hsSystemOutput("Date:20241012\n");
        hsSystemOutput("Version:8.2.1\n");
        hsSystemOutput("Update Content:Adjusted to not conflict with game clear/game over\n");
        myPlayer = new Player();
        myPlayer = hsPlayerGet();

        myActionButton = hsItemGet("ActionButtonCore");

        dAutoRun = false;

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
        }
        else{
            hsSystemOutput("Debug Mode : Autorun is now off\n");
        }

        isActionTime = false;

        hitBoxAreaList = new list<float>(1);
        hitBoxAreaList[0] = 30.0f;

        GameOver = hsItemGet("GameoverScript");

        GameClear = hsItemGet("GameClearScript");

        previousMoveCamera = false;

        moveCamera = false;
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
            }

            //������O��
            myPlayer.SetRotate(0.0f);

            if(isActionTime){
                //hsSystemOutput("True");
            }

            if(movementFrame == 0){ //���[���ړ����Ă��Ȃ��Ƃ��̋���
                if((currentPlayerPos.x - previousPlayerPos.x) < -0.01 && playerLane > -laneNumMax){ //��
                    playerLane--;
                    direction = -1;
                    movementFrame++;
                }else if((currentPlayerPos.x - previousPlayerPos.x) > 0.01 && playerLane < laneNumMax){ //�E
                    playerLane++;
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

    public void OnClickNode(){
        hsSystemOutput("Player Click!\n");
        myActionButton.CallComponentMethod("ActionButton", "playerClick", "");
    }

    public void setMoveCameraTrue(){
        moveCamera = true;
    }

    public void setMoveCameraFalse(){
        moveCamera = false;
    }

    //public void hitBoxAreaCoordinate(float zCoor){
    //    hitBoxAreaList.Add(zCoor);
    //    hsSystemOutput(string(zCoor));
    //}
}
