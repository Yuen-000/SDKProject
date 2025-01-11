component MagnetManagement
{
    //���̃A�C�e��
    Item myItem;

    //�R�C���A�C�e��
    Item myMagnet;

    //�ő吔
    int MAGNETMAX;

    //���Z�b�g�t���O
    bool resetFlag;

    public MagnetManagement()
    {
        hsSystemOutput("Script:MagnetMagement\n");
        hsSystemOutput("Date:20241230\n");
        hsSystemOutput("Version:1.0.0\n");
        hsSystemOutput("Update Content:Create\n");

        myItem = hsItemGetSelf;

        MAGNETMAX = (myItem.GetProperty("MAGNETMAX")).ToInt();

        resetFlag = false;
    }

    public void Update()
    {
        if(resetFlag)
        {

            hsSystemOutput("���Z�b�g���ł�\n");
            for(int i = 0; i < MAGNETMAX; i++){
                myMagnet = hsItemGet("Magnet" + string(i));
                myMagnet.CallComponentMethod("MagnetMain", "reset", "");
            }
            resetFlag = false;
        }
    }

    public void reset()
    {
        resetFlag = true;
    }
}
