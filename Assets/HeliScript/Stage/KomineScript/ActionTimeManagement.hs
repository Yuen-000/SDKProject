component ActionTimeManagement
{
    //連打アクション中か
    bool isActionTime;

    //連打アクションを発生させたエリアの名前
    string areaName;

    //連打アクションを発生させたエリア
    Item areaOfOrigin;

    //UIアイテム
    Item actionUI;

    //どこまでクリアしたか
    float clearDistance;

    public ActionTimeManagement()
    {
        hsSystemOutput("Script:ActionTimeManagement\n");
        hsSystemOutput("Date:20241021\n");
        hsSystemOutput("Version:1.0.0\n");
        hsSystemOutput("Update Content:Create\n");

        isActionTime = false;
        areaName = "";
        actionUI = hsItemGet("ActionUIScript");

        clearDistance = 0.0f;
    }

    public void Update()
    {
        
    }

    public void recieveActionStart(string AreaName){
        isActionTime = true;
        areaName = AreaName;
        hsSystemOutput(areaName + " initiated action time\n");
        areaOfOrigin = hsItemGet(areaName);
    }

    public void sendEndOfActionTime(){
        areaOfOrigin.CallComponentMethod("ActionStartArea", "endActionTime", "");
        actionUI.CallComponentMethod("ActionUI", "endActionTime", "");
    }

    public void sendEndOfActionTimeClear(){
        hsSystemOutput("set clear\n");
        areaOfOrigin.CallComponentMethod("ActionStartArea", "recieveCleared", "");
    }

    public void sendEndOfActionTimeFailed(){
        clearDistance = 0.0f;
    }

    public void setClearDistance(string DistanceStr){
        clearDistance = DistanceStr.ToFloat();

        hsSystemOutput("Clear Distance is " + string(clearDistance));
    }

    public void compareDistance(string AreaDistanceStr){
        float areaDistance = AreaDistanceStr.ToFloat();
        
        if(clearDistance < areaDistance){
            areaOfOrigin.CallComponentMethod("ActionStartArea", "passingArea", "");
        }
    }
}
