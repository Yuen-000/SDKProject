// helCommon
// Canvas_HeliScript開発全体において使いまわしできそうな便利クラス・関数を記述する場所
// 依存関係が生まれないようにするためにこのファイルの機能を使用するときは必ず使用クラスが所属するCanvasファイルのScriptsにこのファイルを登録すること
// "Canvas/HeliScript/helCommon.hs"

JsVal hsCommonMakeParams()
{
    JsVal params = makeJsArray();

    return params;
}

JsVal hsCommonMakeStringArrayParams(list<string> keyList, list<string> valueList)
{
    JsVal params = makeJsArray();

    if(keyList.Count != valueList.Count) return params;

    for(int i = 0; i < keyList.Count; i++)
    {
        list<JsProp> propList = new list<JsProp>();

        for(int k = 0; k < 2; k++)
        {
            string propName = (k == 0)? "key" : "value";
            string propVal  = (k == 0)? keyList[i] : valueList[i];

            JsVal val = makeJsStr();
            val.SetStr(propVal);

            JsProp prop = makeJsProp(propName);
            prop.SetValue(val);

            propList.Add(prop);
        }

        JsVal param = makeJsObj();
        param.SetPropertyList(propList);

        params.AddElementByVal(param);
    }

    return params;
}

void hsCommonAddParamStr(ref JsVal params, string key, string value)
{
    list<JsProp> propList = new list<JsProp>();

    for(int k = 0; k < 2; k++)
    {
        string propName = (k == 0)? "key" : "value";

        JsVal val = null;

        if(k == 0)
        {
            // Key
            val = makeJsStr();
            val.SetStr(key);
        }
        else
        {
            // Value
            val = makeJsStr();
            val.SetStr(value);
        }

        JsProp prop = makeJsProp(propName);
        prop.SetValue(val);

        propList.Add(prop);
    }

    JsVal param = makeJsObj();
    param.SetPropertyList(propList);

    params.AddElementByVal(param);
}

void hsCommonAddParamNumber(ref JsVal params, string key, float value)
{
    list<JsProp> propList = new list<JsProp>();

    for(int k = 0; k < 2; k++)
    {
        string propName = (k == 0)? "key" : "value";

        JsVal val = null;

        if(k == 0)
        {
            // Key
            val = makeJsStr();
            val.SetStr(key);
        }
        else
        {
            // Value
            val = makeJsNum();
            val.SetNum(value);
        }

        JsProp prop = makeJsProp(propName);
        prop.SetValue(val);

        propList.Add(prop);
    }

    JsVal param = makeJsObj();
    param.SetPropertyList(propList);

    params.AddElementByVal(param);
}

void hsCommonAddParamBool(ref JsVal params, string key, bool value)
{
    list<JsProp> propList = new list<JsProp>();

    for(int k = 0; k < 2; k++)
    {
        string propName = (k == 0)? "key" : "value";

        JsVal val = null;

        if(k == 0)
        {
            // Key
            val = makeJsStr();
            val.SetStr(key);
        }
        else
        {
            // Value
            val = makeJsBool();
            val.SetBool(value);
        }

        JsProp prop = makeJsProp(propName);
        prop.SetValue(val);

        propList.Add(prop);
    }

    JsVal param = makeJsObj();
    param.SetPropertyList(propList);

    params.AddElementByVal(param);
}