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

    //�p�[�e�B�N���A�C�e��
    Item actionParticle;

    //�ǂ��܂ŃN���A������
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
