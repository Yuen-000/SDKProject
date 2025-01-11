class ItemDecision
{
    bool useShieldItem;

    public ItemDecision()
    {
        useShieldItem = false;
    }

    public bool GetItemUse()
    {
        return useShieldItem;
    }

    public void SetItemUse(bool judge)
    {
        useShieldItem = judge;
    }

}
