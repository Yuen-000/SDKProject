component PlayerAutoRun
{
    Player  myPlayer;

    Vector3 previousPlayerPos;
    Vector3 currentPlayerPos;
    Vector3 newPlayerPos;
    int movementFrame;
    int playerLane;
    int direction;
    const int movementCoolTime = 30;
    const int movementAnimeTime = 10;
    const int laneNumMax = 1;
    const float laneDistance = 1.5f;

    public PlayerAutoRun()
    {
        hsSystemOutput("testversion4!\n");
        myPlayer = new Player();
        myPlayer = hsPlayerGet();
        myPlayer.SetMoveSpeed(0.0f);

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
        myPlayer.SetRotate(0.0f);
        currentPlayerPos = myPlayer.GetPos();
        newPlayerPos = currentPlayerPos;

        if(movementFrame == 0){
            if((currentPlayerPos.x - previousPlayerPos.x) < -0.01 && playerLane > -laneNumMax){
                playerLane--;
                direction = -1;
                movementFrame++;
            }else if((currentPlayerPos.x - previousPlayerPos.x) > 0.01 && playerLane < laneNumMax){
                playerLane++;
                direction = 1;
                movementFrame++;
            }else{
                newPlayerPos.x = playerLane * laneDistance;
            }
        }else if(movementFrame > 0){
            movementFrame++;
            if(movementFrame <= movementAnimeTime){
                newPlayerPos.x = previousPlayerPos.x + laneDistance / movementAnimeTime * direction;
            }else{
                newPlayerPos.x = playerLane * laneDistance;
            }
            if(movementFrame >= movementCoolTime){
                movementFrame = 0;
                direction = 0;
            }
        }

        if (currentPlayerPos.y > 1){
            newPlayerPos.z = previousPlayerPos.z;
        }

        Vector3 autoRunDistance = makeVector3(0.0f,0.0f,0.1f);
        newPlayerPos.Add(autoRunDistance);
        myPlayer.SetPos(newPlayerPos);
        previousPlayerPos = newPlayerPos;
    }
}
