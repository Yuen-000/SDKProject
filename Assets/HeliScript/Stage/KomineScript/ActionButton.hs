component ActionButton
{
    //連打アクション中か
    bool isActionTime;

    //連打アクション押した回数
    int pressCount;

    public ActionButton()
    {
        hsSystemOutput("Script:ActionButton\n");
        hsSystemOutput("Date:20241019\n");
        hsSystemOutput("Version:1.0.0\n");
        hsSystemOutput("Update Content:Create\n");

        isActionTime = false;
        pressCount = 0;
    }

    public void Update()
    {
        
    }

    public void OnClickNode()
    {
        if(isActionTime){
            pressCount++;
            hsSystemOutput(string(pressCount) + "\n");
        }
    }

    public void SetActionFlagTrue()
    {
        hsSystemOutput("Now you can press the button\n");
        isActionTime = true;
    }

    public void SetActionFlagFalse()
    {
        isActionTime = false;
    }
}
