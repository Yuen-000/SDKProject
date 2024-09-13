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

    public PlayerAutoRun()
    {
        hsSystemOutput("Date:20240913\n");
        hsSystemOutput("Version:5.1.5\n");
        hsSystemOutput("Update Content:Compatible with the latest version\n");
        myPlayer = new Player();
        myPlayer = hsPlayerGet();
        myPlayer.SetMoveSpeed(0.5f);

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

    public void Update()
    {
        //������O��
        myPlayer.SetRotate(0.0f);

        currentPlayerPos = myPlayer.GetPos();
        newPlayerPos = currentPlayerPos;

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
}
