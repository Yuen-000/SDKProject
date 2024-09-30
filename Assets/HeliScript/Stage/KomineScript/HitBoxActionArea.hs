component HitBoxActionArea
{
    //PlayerƒNƒ‰ƒX
    Item  myPlayer;

    //ActionButton
    Item myActionButton;

    public HitBoxActionArea()
    {
        hsSystemOutput("Script:HitBoxActionArea\n");
        hsSystemOutput("Date:20240930\n");
        hsSystemOutput("Version:2.0.1\n");
        hsSystemOutput("Update Content:Adjust instructions to buttons\n");

        myPlayer = hsItemGet("PlayerSettings");
        myActionButton = hsItemGet("ActionButtonCore");
    }

    public void Update()
    {

    }

    public void passingArea()
    {
        hsSystemOutput("Passing area!\n");
        myPlayer.CallComponentMethod("PlayerAutoRun", "startActionTime", "");
        myActionButton.CallComponentMethod("ActionButton", "startActionTime", "");
    }
}
