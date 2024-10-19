component ActionStartArea
{
    //ActionUI
    Item myActionUI;

    //ActionButton
    Item myActionButton;

    public ActionStartArea()
    {
        hsSystemOutput("Script:HitBoxActionArea\n");
        hsSystemOutput("Date:20241019\n");
        hsSystemOutput("Version:3.1.0\n");
        hsSystemOutput("Update Content:Change to button UI\n");

        myActionUI = hsItemGet("ActionUIScript");
        myActionButton = hsItemGet("ActionButtonScript");
    }

    public void Update()
    {

    }

    public void passingArea()
    {
        hsSystemOutput("Passing area!\n");
        myActionUI.CallComponentMethod("ActionUI", "startActionTime", "");
        myActionButton.CallComponentMethod("ActionButton", "SetActionFlagTrue", "");
    }
}
