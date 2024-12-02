component PlayerAutoRun
{
    //Playerクラス
    Player  myPlayer;

    //プレイヤー（呼び出し用）
    Item myPlayerComponent;

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
    int MOVEMENTCOOLTIME;

    //レーン移動にかかるフレーム
    int MOVEMENTANIMETIME;

    //左右の広がり 3レーンなので1
    const int laneNumMax = 1;

    //レーンの間の距離　要調整
    float LANEDISTANCE;

    //デバッグモード
    bool dAutoRun;

    //前のフレームにカメラが移動していたか
    bool previousMoveCamera;

    //今カメラが移動していたか
    bool moveCamera;

    //初期位置
    Vector3 initialPosition;

    //デバッグアイテム
    Item debug;

    //デバッグアイテムの座標
    Vector3 debugPos;

    public PlayerAutoRun()
    {
        hsSystemOutput("Script:PlayerAutoRun\n");
        hsSystemOutput("Date:20241202\n");
        hsSystemOutput("Version:10.1.0\n");
        hsSystemOutput("Update Content:Supports Attribute Property\n");
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

            //向きを前に
            myPlayer.SetRotate(0.0f);

            if(movementFrame == 0){ //レーン移動していないときの挙動
                if((currentPlayerPos.x - previousPlayerPos.x) < -0.01 && playerLane > -laneNumMax){ //左
                    playerLane--;
                    myPlayerComponent.SetProperty("playerLane", string(playerLane));
                    direction = -1;
                    movementFrame++;
                }else if((currentPlayerPos.x - previousPlayerPos.x) > 0.01 && playerLane < laneNumMax){ //右
                    playerLane++;
                    myPlayerComponent.SetProperty("playerLane", string(playerLane));
                    direction = 1;
                    movementFrame++;
                }else{ //そのまま
                    newPlayerPos.x = playerLane * LANEDISTANCE;
                }
            }else if(movementFrame > 0){    //移動クールタイム中の挙動
                movementFrame++;
                if(movementFrame <= MOVEMENTANIMETIME){ //レーン移動中
                    newPlayerPos.x = previousPlayerPos.x + LANEDISTANCE / MOVEMENTANIMETIME * direction;
                }else{  //クールタイム中
                    newPlayerPos.x = playerLane * LANEDISTANCE;
                }
                if(movementFrame >= MOVEMENTCOOLTIME){  //クールタイム終了
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
