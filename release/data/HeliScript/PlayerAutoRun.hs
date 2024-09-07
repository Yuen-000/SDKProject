component PlayerAutoRun
{
    Player  myPlayer;

    Vector3 previousPlayerPos;
    Vector3 currentPlayerPos;
    Vector3 newPlayerPos;
    int movementFrame;
    int playerLane;
    const int movementCoolTime = 30;
    const int laneNumMax = 1;
    const float laneDistance = 1.5f;

    public PlayerAutoRun()
    {
        hsSystemOutput("testversion3!\n");
        myPlayer = new Player();
        myPlayer = hsPlayerGet();
        myPlayer.SetMoveSpeed(0.0f);

        previousPlayerPos = new Vector3();
        previousPlayerPos = myPlayer.GetPos();

        currentPlayerPos = new Vector3();
        currentPlayerPos = previousPlayerPos;

        newPlayerPos = new Vector3();
        newPlayerPos = previousPlayerPos;

        movementFrame = 0;
        playerLane = 0;
    }

    public void Update()
    {
        myPlayer.SetRotate(0.0f);
        currentPlayerPos = myPlayer.GetPos();
        newPlayerPos = currentPlayerPos;

        if(movementFrame == 0){
            if((currentPlayerPos.x - previousPlayerPos.x) < -0.01 && playerLane > -laneNumMax){
                playerLane--;
                movementFrame++;
            }else if((currentPlayerPos.x - previousPlayerPos.x) > 0.01 && playerLane < laneNumMax){
                playerLane++;
                movementFrame++;
            }
        }else if(movementFrame > 0){
            movementFrame++;
            if(movementFrame >= movementCoolTime){
                movementFrame = 0;
            }
        }

        newPlayerPos.x = playerLane * laneDistance;

        if (currentPlayerPos.y > 1){
            newPlayerPos.z = previousPlayerPos.z;
        }

        Vector3 autoRunDistance = makeVector3(0.0f,0.0f,0.1f);
        newPlayerPos.Add(autoRunDistance);
        myPlayer.SetPos(newPlayerPos);
        previousPlayerPos = newPlayerPos;
    }
}
