class colliderList{
	public list<string> colliders;
}

component LoadManager {
	Item	m_Item;

	list<Item>	m_ItemList;
	list<bool>	m_LoadingFlagList;

	list<colliderList>	m_LoadColliderList;
	list<colliderList>	m_UnLoadColliderList;
	
	public LoadManager()
	{
		m_Item = new Item();
		m_Item = hsItemGetSelf();
		
		m_ItemList = new list<Item>();

		m_ItemList.Alloc(1);
		//LoadObjectNo_Setting
		m_ItemList[0] = hsItemGet("GameoverScript");
		//LoadObject_Setting

		m_LoadColliderList = new list<colliderList>();
		m_LoadColliderList.Alloc(m_ItemList.Numof());
		
		m_UnLoadColliderList = new list<colliderList>();
		m_UnLoadColliderList.Alloc(m_ItemList.Numof());

      m_LoadColliderList[0].colliders = new list<string>();
      m_LoadColliderList[0].colliders.Alloc(1);
		m_LoadColliderList[0].colliders[0] = "";
		//LoadCollider_Setting

      m_UnLoadColliderList[0].colliders = new list<string>();
      m_UnLoadColliderList[0].colliders.Alloc(0);
        //UnLoadCollider_Setting
		
		m_LoadingFlagList = new list<bool>();
		m_LoadingFlagList.Alloc(m_ItemList.Numof());
		
		hsCanvasSetGUIText("debug", "debug_text", "Loading");
		hsCanvasSetGUIText("debug_po", "debug_text", "Loading");
	}
	
	public void OnLoad(string AreaName)
	{
        int i; int j;
        for(i = 0;i < m_LoadColliderList.Numof();i++)
		{
    		for(j = 0;j < m_LoadColliderList[i].colliders.Numof();j++)
			{
				if (AreaName == m_LoadColliderList[i].colliders[j]) 
				{
		    		//if (!m_LoadingFlagList[i]) 
					{
			    		
						m_ItemList[i].Load();
				    	m_LoadingFlagList[i] = true;
						break;
			    	}
				}
            }
		}
	}

	public void OnUnLoad(string AreaName)
	{
        int i; int j;
        for(i = 0;i < m_UnLoadColliderList.Numof();i++)
		{
    		for(j = 0;j < m_UnLoadColliderList[i].colliders.Numof();j++)
			{
				if (AreaName == m_UnLoadColliderList[i].colliders[j]) 
				{
					//if (m_LoadingFlagList[i]) 
					{
			    		
						m_ItemList[i].Unload();
				    	m_LoadingFlagList[i] = false;
						break;
			    	}
				}
            }
		}
	}

	public void Update()
	{
		
	}
}


//
component DLAreaCollider {
	Item	m_Item;
	
	LoadManager		m_LoadManager;

	public DLAreaCollider()
	{
		m_Item = new Item();
		m_Item = hsItemGetSelf();
	}
	
	public void OnEnterAreaCollider()
	{
		Item Loading1Item = hsItemGet("GameoverScript");
		//LoadingManager_Setting

		m_LoadManager = system.Item_GetComponent<LoadManager>(Loading1Item._GetItemIndex());
		m_LoadManager.OnLoad(m_Item.GetName());
	}
}

component ULAreaCollider {
	Item	m_Item;
	
	LoadManager		m_LoadManager;

	public ULAreaCollider()
	{
		m_Item = new Item();
		m_Item = hsItemGetSelf();
	}
	
	public void OnEnterAreaCollider()
	{
		
		Item Loading1Item = hsItemGet("GameoverScript");
		//UnLoadingManager_Setting

		m_LoadManager = system.Item_GetComponent<LoadManager>(Loading1Item._GetItemIndex());
		m_LoadManager.OnUnLoad(m_Item.GetName());
	}
}





