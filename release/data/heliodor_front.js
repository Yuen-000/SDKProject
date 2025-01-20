
//
const g_Status = document.getElementById('status');
const g_Log = document.getElementById('log');
const g_GUIdebugTab = document.getElementById('GUIdebugTab');
const g_GUIdebug = document.getElementById('GUIdebug');

var g_WorldID = "vketmp01";
var g_MultiPlay = true;
var g_Spot = "";
var g_ShowWorldSelect = true;

ParamsInit();

function ParamsInit()
{
	var params = (new URL(document.location)).searchParams;

	var ParamWorldID = params.get('worldid');
	var ParamRoomID = params.get('roomid');
	var ParamMulti = params.get('multi');
	var ParamSpaceIndex = params.get('spaceindex');
	var ParamShowWorldSelect = params.get('showworldselect');

	if (ParamWorldID != null) {
		g_WorldID = transSafetyWorldID(ParamWorldID);
	}

	if (ParamMulti != null) {
		g_MultiPlay = (parseInt(ParamMulti, 10) != 0);
	}

	if (ParamRoomID != null) {
		g_Skyway_RoomID = ParamRoomID;
//		g_MultiPlay = true;
	}

	if (ParamSpaceIndex != null) {
		g_Spot = "Spot" + ParamSpaceIndex;
	}

	if (ParamShowWorldSelect != null) {
		g_ShowWorldSelect = (parseInt(ParamShowWorldSelect, 10) != 0);
	}
}

function hel_skyway_start()
{
	// CDNを指定
	var UseCDN = true;
    hel_setText(ETextParamType_SetCDNFolderName, "https://heliodor.vketcdn.com/heliodor/common/latest/v1/");

	// Sceneファイル名の決定
	var sceneFileName = getSceneFileNameFromWorldID(g_WorldID);
	
	// パックファイルの追加
	hel_addPackFile("Pack/Canvas.hpk", HSAddPackPriority_Top, HSAddPackContidion_All, UseCDN);

	// Canvasファイルリストの設定
	hel_setCanvasFileName("Canvas/CanvasList.json");
	
	// 圧縮画像リストの設定
	hel_setCompImageListFileName("CompImageList/CompImageList.json", UseCDN);

	// 圧縮画像パックファイルの追加
	hel_addPackFile("Pack/CompImageAstc.hpk", HSAddPackPriority_Default, HSAddPackContidion_UseAstc, UseCDN);
	hel_addPackFile("Pack/CompImageEtc.hpk", HSAddPackPriority_Default, HSAddPackContidion_UseEtc2, UseCDN);
	hel_addPackFile("Pack/gui2023.hpk", HSAddPackPriority_Default, HSAddPackContidion_UnuseTexComp, UseCDN);
	hel_addPackFile("Pack/gui2024.hpk", HSAddPackPriority_Default, HSAddPackContidion_UnuseTexComp, UseCDN);
	
	// Cookieからアバター番号を取得して設定する
	hel_skyway_set_avatar_from_cookie();

	// Sceneファイルの読み込み開始
	hel_startScene(g_Skyway_MyAvatar, g_MultiPlay, sceneFileName);

	// アバターアイコンを分離して設定出来る場合のテストコード
/*	var avatarIcon = hel_get_cookie('AvatarIcon');

	if (avatarIcon) {
		var avatarIconID = avatarIcon.toString(10);

		hel_setText(ETextParamType_ReplaceMyAvatarIcon, avatarIconID);
	}
*/
}

function getSceneFileNameFromWorldID(worldID)
{
	return "Scene/" + worldID + ".json";
}

function getWorldIndexFromWorldID(worldID)
{
	return 0;
}

function transSafetyWorldID(worldID)
{
	return worldID;
}

function hel_openTweet(circleID)
{
}

function hel_openCatalog(circleID)
{
}

function hel_onbeginloading()
{
  console.log("hel_onbeginloading");
	hel_canvas_SetLayoutShow("loading_guid", true);
}

function hel_onloaded()
{
	console.log("hel_onloaded");
	hel_canvas_SetLayoutShow("loading_guid", false);
}

//---------------------------------------------------------------------
// チャットログのバッジ表示（オーバーライド）
//
//  ※hel_skyway_add_text_chat()で標準のバッジ表示を行ってる
//  ※hel_if_displayChatBadge()は、基本はコメント状態でOK。
//  ※もし特別なバッジ表示したい場合は、コメントを外してコードを記述する。
//---------------------------------------------------------------------
//function hel_if_displayChatBadge()
//{
//}

