component ActionTimeManagement
{
    //�A�ŃA�N�V��������
    bool isActionTime;

    //�A�ŃA�N�V�����𔭐��������G���A�̖��O
    string areaName;

    //�A�ŃA�N�V�����𔭐��������G���A
    Item areaOfOrigin;

    //UI�A�C�e��
    Item actionUI;

    //�ǂ��܂ŃN���A������
    float clearDistance;

    public ActionTimeManagement()
    {
        hsSystemOutput("Script:ActionTimeManagement\n");
        hsSystemOutput("Date:20241028\n");
        hsSystemOutput("Version:1.1.0\n");
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
}
