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

    //パーティクルアイテム
    Item actionParticle;

    //どこまでクリアしたか
    float clearDistance;

    public ActionTimeManagement()
    {
        hsSystemOutput("Script:ActionTimeManagement\n");
        hsSystemOutput("Date:20241209\n");
        hsSystemOutput("Version:2.0.0\n");
        hsSystemOutput("Update Content:Update particle\n");

        isActionTime = false;
        areaName = "";
        actionUI = hsItemGet("ActionUIScript");

        actionParticle = hsItemGet("particle_action");

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
        actionParticle.CallComponentMethod("ActionParticle", "setActionFalse", "");
    }
}
