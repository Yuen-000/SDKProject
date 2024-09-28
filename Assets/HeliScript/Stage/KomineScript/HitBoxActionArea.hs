component HitBoxActionArea
{
    //PlayerƒNƒ‰ƒX
    Item  myPlayer;

    //ActionButton
    Item myActionButton;

    public HitBoxActionArea()
    {
        hsSystemOutput("Script:HitBoxActionArea\n");
        hsSystemOutput("Date:20240928\n");
        hsSystemOutput("Version:2.0.0\n");
        hsSystemOutput("Update Content:Implement communication with other scripts\n");

        myPlayer = hsItemGet("PlayerSettings");
        myPlayer = hsItemGet("ActionButtonPlane");
    }

    public void Update()
    {

    }

    public void passingArea()
    {
        hsSystemOutput("Passing area!\n");
        myPlayer.CallComponentMethod("PlayerAutoRun", "startActionTime", "");
        myPlayer.CallComponentMethod("ActionButton", "startActionTime", "");
    }
}
