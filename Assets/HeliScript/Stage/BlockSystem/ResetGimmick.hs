component ResetGimmick
{
    list<Item> oneOutGimmick;

    public ResetGimmick()
    {
        oneOutGimmick = new list<Item>();
    }

    public void AddList(Item self)
    {
        hsSystemOutput(oneOutGimmick.Count().ToString()); 
        //oneOutGimmick.Add(self);
    }

    public void OnClickReset()
    {
        for(int i = 0; i < oneOutGimmick.Count(); i++)
        {
            oneOutGimmick[i].CallComponentMethod("OneOutGimmick", "ResetGameOverTrigger", ""); 
        }
    }
}
