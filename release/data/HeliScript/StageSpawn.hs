component StageSpawn
{
    Item spawnItem;
    int waitTime;

    public StageSpawn()
    {
        waitTime = spawnItem.GetProperty("SpawnTime").ToInt();
    }

    public void Update()
    {
        Spawn();
    }

    void Spawn()
    {
        
    }
}
