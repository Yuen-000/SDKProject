component PlayerAutoRun
{
    //Playerクラス
    Player  myPlayer;

    //1F前のプレイヤーの位置
    Vector3 previousPlayerPos;

    //現在のプレイヤーの位置（カーソル移動受付済み）
    Vector3 currentPlayerPos;

    //補正後の画面に映るプレイヤーの位置
    Vector3 newPlayerPos;

    //レーン -1 0 1
    int playerLane;

    //移動クールタイム判定用のフレームカウント
    int movementFrame;

    //現在移動中の向き -1 0 1
    int direction;

    //移動クールタイム
    const int movementCoolTime = 30;

    //レーン移動にかかるフレーム
    const int movementAnimeTime = 10;

    //左右の広がり 3レーンなので1
    const int laneNumMax = 1;

    //レーンの間の距離　要調整
    const float laneDistance = 1.4f;

    //連打エリアに突入するZ座標のリスト
    list<float> hitBoxAreaList;

    //連打アクション中か
    bool isActionTime;

    //デバッグモード
    bool dAutoRun;

    //ActionButton
    Item myActionButton;
    
    //GameoverScript
    Item GameOver;

    //GameClearScript
    Item GameClear;

    //前のフレームにカメラが移動していたか
    bool previousMoveCamera;

    //今カメラが移動していたか
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

            //向きを前に
            myPlayer.SetRotate(0.0f);

            if(isActionTime){
                //hsSystemOutput("True");
            }

            if(movementFrame == 0){ //レーン移動していないときの挙動
                if((currentPlayerPos.x - previousPlayerPos.x) < -0.01 && playerLane > -laneNumMax){ //左
                    playerLane--;
                    direction = -1;
                    movementFrame++;
                }else if((currentPlayerPos.x - previousPlayerPos.x) > 0.01 && playerLane < laneNumMax){ //右
                    playerLane++;
                    direction = 1;
                    movementFrame++;
                }else{ //そのまま
                    newPlayerPos.x = playerLane * laneDistance;
                }
            }else if(movementFrame > 0){    //移動クールタイム中の挙動
                movementFrame++;
                if(movementFrame <= movementAnimeTime){ //レーン移動中
                    newPlayerPos.x = previousPlayerPos.x + laneDistance / movementAnimeTime * direction;
                }else{  //クールタイム中
                    newPlayerPos.x = playerLane * laneDistance;
                }
                if(movementFrame >= movementCoolTime){  //クールタイム終了
                    movementFrame = 0;
                    direction = 0;
                }
            }

            //カーソルでの移動を相殺
            newPlayerPos.z = previousPlayerPos.z;

            //前に進むベクトル
            Vector3 autoRunDistance = makeVector3(0.0f,0.0f,0.1f);
            newPlayerPos.Add(autoRunDistance);

            //ここで位置をセット
            myPlayer.SetPos(newPlayerPos);

            //今の位置を次使う前の位置に
            previousPlayerPos = newPlayerPos;

            //念のためもう一度向きを前に（効果ないかも）
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
