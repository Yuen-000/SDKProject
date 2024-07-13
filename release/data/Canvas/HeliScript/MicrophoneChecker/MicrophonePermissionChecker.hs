//マイク許可チェッククラス
component MicrophonePermissionChecker
{
	bool m_IsFirstCheck;

    public MicrophonePermissionChecker()
    {
		m_IsFirstCheck = true;
    }
	private void CheckMicrophone(int state){
		hsCanvasResetToggleDefault("mic_disabled");
		if(state==HSMicPermissionState_Prompt){
			hsCanvasSetLayerShow("mic_permission_click_layer",true);
		}else if(state==HSMicPermissionState_Granted){
			hsCanvasToggleChange("mic_disabled");
			hsCanvasSetLayerShow("mic_permission_click_layer",false);
			hsCanvasSetLayerShow("mic_block_info_layer",false);

			// 初回Check時は再入室しない
			if(!m_IsFirstCheck)
			{
				// hsNetFirstEnterRoomは座標・音声関係なく再接続してしまい、1対NのRTCの時に座標チャンネルだけ入っていて音声チャンネルからは抜けている状態に戻ってしまうので
				// VCCクラスの音声チャンネル再接続関数を呼ぶ
				LayerBundle layer = hsLayerGet("vcc_icon_only_base");
				if(layer !== null)
				{
					layer.CallComponentMethod("VCCViewModel", "ReConnectVoiceChannel", "");
				}
			}
			
		}else if(state==HSMicPermissionState_Denied){
			hsCanvasSetLayerShow("mic_permission_click_layer",false); 
			hsCanvasSetLayerShow("mic_block_info_layer",true);
		}

		if(m_IsFirstCheck)
		{
			m_IsFirstCheck = false;
		}
	}
    public void OnLoaded()
    {
    }
	public void OnChangedMicPermissionState(int state)
	{
		//hsSystemOutput("change permissionstate = %d\n" % state);
        CheckMicrophone(state);
	}
	public void OnClickedButton(string layerName,string buttonName){
		//左上のマイク不可ボタンを押したときに「確認が必要」状態ならダイアログを出す
		if(layerName=="HUD" && buttonName=="hud_usermic_disabled"){
			int state = hsNetGetMicPermissionState();
			if(state==HSMicPermissionState_Prompt){
				hsCanvasSetLayerShow("mic_permission_click_layer",true);
			}else if(state==HSMicPermissionState_Denied){
				hsCanvasSetLayerShow("mic_block_info_layer",true);

				// Stateはマイクの許可状態を変更したとしても内部的にはIHeliNetworkのcheckMicPermissionStateを呼ばない限り変更されないのでここで再チェックする
				hel_net_check_mic_permission_state();
			}
		}
	}
}