component ViewCollider
{
    public ViewCollider()
    {
        
    }

    public void Update()
    {
        
    }
    
    //視界に入ってるの判断
    public void OnEnterViewCollider()
    {
        hsSystemOutput("見つけた");
    }
    
    //視界に入っていないの判断
    public void OnLeaveViewCollider()
    {
        hsSystemOutput("離れた");
    }
}
