#include-once
#include <WinAPI.au3>

Global $__gHTML2PDF_hDLL = -1

; -------------------------------------------------------------------------------------------------

;~ CAPI(int) wkhtmltopdf_init(int use_graphics);
Func _HTML2PDF_Init($sDllPath, $bUseGraphics = False)
	If $__gHTML2PDF_hDLL = -1 Then
		$__gHTML2PDF_hDLL = DllOpen($sDllPath)
		If $__gHTML2PDF_hDLL = -1 Then Return SetError(-1, 0, False)

		DllCall($__gHTML2PDF_hDLL, "int", "wkhtmltopdf_init", "int", $bUseGraphics)
		If @error Then Return SetError(@error, 0, False)
	EndIf
	Return True
EndFunc

;~ CAPI(int) wkhtmltopdf_deinit();
Func _HTML2PDF_Deinit()
	If $__gHTML2PDF_hDLL <> -1 Then
		DllCall($__gHTML2PDF_hDLL, "int", "wkhtmltopdf_deinit")
		If @error Then Return SetError(@error, 0, False)

		DllClose($__gHTML2PDF_hDLL)
		$__gHTML2PDF_hDLL = -1
	EndIf
	Return True
EndFunc

;~ CAPI(int) wkhtmltopdf_extended_qt();
Func _HTML2PDF_ExtendedQT()
	Local $aRet = DllCall($__gHTML2PDF_hDLL, "int", "wkhtmltopdf_extended_qt")
	If @error Then Return SetError(@error, 0, 0)
	Return $aRet[0]
EndFunc

;~ CAPI(const char *) wkhtmltopdf_version();
Func _HTML2PDF_Version()
	Local $aRet = DllCall($__gHTML2PDF_hDLL, "str", "wkhtmltopdf_version")
	If @error Then Return SetError(@error, 0, "")
	Return $aRet[0]
EndFunc

; -------------------------------------------------------------------------------------------------

;~ CAPI(wkhtmltopdf_global_settings *) wkhtmltopdf_create_global_settings();
;~ CAPI(void) wkhtmltopdf_destroy_global_settings(wkhtmltopdf_global_settings *);
Func _HTML2PDF_CreateGlobalSettings()
	Local $aRet = DllCall($__gHTML2PDF_hDLL, "ptr", "wkhtmltopdf_create_global_settings")
	If @error Then Return SetError(@error, 0, Null)
	Return $aRet[0]
EndFunc

Func _HTML2PDF_DestroyGlobalSettings($pGlobalSettings)
	DllCall($__gHTML2PDF_hDLL, "none", "wkhtmltopdf_destroy_global_settings", "ptr", $pGlobalSettings)
EndFunc

;~ CAPI(wkhtmltopdf_object_settings *) wkhtmltopdf_create_object_settings();
;~ CAPI(void) wkhtmltopdf_destroy_object_settings(wkhtmltopdf_object_settings *);
Func _HTML2PDF_CreateObjectSettings()
	Local $aRet = DllCall($__gHTML2PDF_hDLL, "ptr", "wkhtmltopdf_create_object_settings")
	If @error Then Return SetError(@error, 0, Null)
	Return $aRet[0]
EndFunc

Func _HTML2PDF_DestroyObjectSettings($pObjectSettings)
	DllCall($__gHTML2PDF_hDLL, "none", "wkhtmltopdf_destroy_object_settings", "ptr", $pObjectSettings)
EndFunc

;~ CAPI(int) wkhtmltopdf_set_global_setting(wkhtmltopdf_global_settings * settings, const char * name, const char * value);
;~ CAPI(int) wkhtmltopdf_get_global_setting(wkhtmltopdf_global_settings * settings, const char * name, char * value, int vs);
Func _HTML2PDF_SetGlobalSetting($pGlobalSettings, $sKey, $sValue)
	Local $aRet = DllCall($__gHTML2PDF_hDLL, "int", "wkhtmltopdf_set_global_setting", "ptr", $pGlobalSettings, "str", $sKey, "struct*", __html2pdf_str2UTF8struct($sValue))
	If @error Then Return SetError(@error, 0, Null)
	Return $aRet[0]
EndFunc

Func _HTML2PDF_GetGlobalSetting($pGlobalSettings, $sKey, $iBuffSize = 1024)
	Local $tBuff = DllStructCreate("byte[" & $iBuffSize & "]")
	Local $aRet = DllCall($__gHTML2PDF_hDLL, "int", "wkhtmltopdf_get_global_setting", "ptr", $pGlobalSettings, "str", $sKey, "struct*", $tBuff, "int", $iBuffSize)
	If @error Then Return SetError(@error, 0, "")
	Return BinaryToString(BinaryMid(DllStructGetData($tBuff, 1), 1, _WinAPI_StrLen(DllStructGetPtr($tBuff, 1), False)), 4)
EndFunc

;~ CAPI(int) wkhtmltopdf_set_object_setting(wkhtmltopdf_object_settings * settings, const char * name, const char * value);
;~ CAPI(int) wkhtmltopdf_get_object_setting(wkhtmltopdf_object_settings * settings, const char * name, char * value, int vs);
Func _HTML2PDF_SetObjectSetting($pObjectSettings, $sKey, $sValue)
	Local $aRet = DllCall($__gHTML2PDF_hDLL, "int", "wkhtmltopdf_set_object_setting", "ptr", $pObjectSettings, "str", $sKey, "struct*", __html2pdf_str2UTF8struct($sValue))
	If @error Then Return SetError(@error, 0, Null)
	Return $aRet[0]
EndFunc

Func _HTML2PDF_GetObjectSetting($pObjectSettings, $sKey, $iBuffSize = 1024)
	Local $tBuff = DllStructCreate("byte[" & $iBuffSize & "]")
	Local $aRet = DllCall($__gHTML2PDF_hDLL, "int", "wkhtmltopdf_get_object_setting", "ptr", $pObjectSettings, "str", $sKey, "struct*", $tBuff, "int", $iBuffSize)
	If @error Then Return SetError(@error, 0, "")
	Return BinaryToString(BinaryMid(DllStructGetData($tBuff, 1), 1, _WinAPI_StrLen(DllStructGetPtr($tBuff, 1), False)), 4)
EndFunc

; -------------------------------------------------------------------------------------------------

;~ CAPI(wkhtmltopdf_converter *) wkhtmltopdf_create_converter(wkhtmltopdf_global_settings * settings);
;~ CAPI(void) wkhtmltopdf_destroy_converter(wkhtmltopdf_converter * converter);
Func _HTML2PDF_CreateConverter($pGlobalSettings)
	Local $aRet = DllCall($__gHTML2PDF_hDLL, "ptr", "wkhtmltopdf_create_converter", "ptr", $pGlobalSettings)
	If @error Then Return SetError(@error, 0, Null)
	Return $aRet[0]
EndFunc

Func _HTML2PDF_DestroyConverter($pConverter)
	DllCall($__gHTML2PDF_hDLL, "none", "wkhtmltopdf_destroy_converter", "ptr", $pConverter)
EndFunc

;~ CAPI(void) wkhtmltopdf_set_warning_callback(wkhtmltopdf_converter * converter, wkhtmltopdf_str_callback cb);
;~ CAPI(void) wkhtmltopdf_set_error_callback(wkhtmltopdf_converter * converter, wkhtmltopdf_str_callback cb);
;~ CAPI(void) wkhtmltopdf_set_phase_changed_callback(wkhtmltopdf_converter * converter, wkhtmltopdf_void_callback cb);
;~ CAPI(void) wkhtmltopdf_set_progress_changed_callback(wkhtmltopdf_converter * converter, wkhtmltopdf_int_callback cb);
;~ CAPI(void) wkhtmltopdf_set_finished_callback(wkhtmltopdf_converter * converter, wkhtmltopdf_int_callback cb);
Func _HTML2PDF_SetCallback($pConverter, $sCallback, $pfnCallback) ; $sCallback = warning|error|phase_changed|progress|finished
	Switch $sCallback
		Case "warning", "error"
			$pfnCallback = DllCallbackRegister($pfnCallback, "none", "ptr;str") ; typedef void (*wkhtmltopdf_str_callback)(wkhtmltopdf_converter * converter, const char * str);
		Case "progress", "finished"
			$pfnCallback = DllCallbackRegister($pfnCallback, "none", "ptr;int") ; typedef void (*wkhtmltopdf_int_callback)(wkhtmltopdf_converter * converter, const int val);
		Case Else
			$pfnCallback = DllCallbackRegister($pfnCallback, "none", "ptr") ; typedef void (*wkhtmltopdf_void_callback)(wkhtmltopdf_converter * converter);
	EndSwitch
	DllCall($__gHTML2PDF_hDLL, "none", "wkhtmltopdf_set_" & $sCallback & "_callback", "ptr", $pConverter, "ptr", DllCallbackGetPtr($pfnCallback))
	If @error Then Return SetError(@error, 0, False)
	Return True
EndFunc

;~ CAPI(int) wkhtmltopdf_convert(wkhtmltopdf_converter * converter);
Func _HTML2PDF_Convert($pConverter)
	Local $aRet = DllCall($__gHTML2PDF_hDLL, "int", "wkhtmltopdf_convert", "ptr", $pConverter)
	If @error Then Return SetError(@error, 0, False)
	Return $aRet[0]
EndFunc

;~ CAPI(void) wkhtmltopdf_add_object(wkhtmltopdf_converter * converter, wkhtmltopdf_object_settings * setting, const char * data);
Func _HTML2PDF_AddObject($pConverter, $pObjectSettings, $sData = Null)
	Local $tData = Null
	If $sData Then
		$sData = StringToBinary($sData, 4)
		$tData = DllStructCreate("byte[" & (BinaryLen($sData) + 1) & "]")
		DllStructSetData($tData, 1, $sData)
	EndIf
	DllCall($__gHTML2PDF_hDLL, "none", "wkhtmltopdf_add_object", "ptr", $pConverter, "ptr", $pObjectSettings, "struct*", $tData)
	If @error Then Return SetError(@error, 0, False)
	Return True
EndFunc

; -------------------------------------------------------------------------------------------------

;~ CAPI(int) wkhtmltopdf_current_phase(wkhtmltopdf_converter * converter);
Func _HTML2PDF_CurrentPhase($pConverter)
	Local $aRet = DllCall($__gHTML2PDF_hDLL, "int", "wkhtmltopdf_current_phase", "ptr", $pConverter)
	If @error Then Return SetError(@error, 0, 0)
	Return $aRet[0]
EndFunc

;~ CAPI(int) wkhtmltopdf_phase_count(wkhtmltopdf_converter * converter);
Func _HTML2PDF_PhaseCount($pConverter)
	Local $aRet = DllCall($__gHTML2PDF_hDLL, "int", "wkhtmltopdf_phase_count", "ptr", $pConverter)
	If @error Then Return SetError(@error, 0, 0)
	Return $aRet[0]
EndFunc

;~ CAPI(const char *) wkhtmltopdf_phase_description(wkhtmltopdf_converter * converter, int phase);
Func _HTML2PDF_PhaseDescription($pConverter, $iPhase)
	Local $aRet = DllCall($__gHTML2PDF_hDLL, "str", "wkhtmltopdf_phase_description", "ptr", $pConverter, "int", $iPhase)
	If @error Then Return SetError(@error, 0, "")
	Return $aRet[0]
EndFunc

;~ CAPI(const char *) wkhtmltopdf_progress_string(wkhtmltopdf_converter * converter);
Func _HTML2PDF_ProgressString($pConverter)
	Local $aRet = DllCall($__gHTML2PDF_hDLL, "str", "wkhtmltopdf_progress_string", "ptr", $pConverter)
	If @error Then Return SetError(@error, 0, "")
	Return $aRet[0]
EndFunc

;~ CAPI(int) wkhtmltopdf_http_error_code(wkhtmltopdf_converter * converter);
Func _HTML2PDF_HTTPErrorCode($pConverter)
	Local $aRet = DllCall($__gHTML2PDF_hDLL, "int", "wkhtmltopdf_http_error_code", "ptr", $pConverter)
	If @error Then Return SetError(@error, 0, 0)
	Return $aRet[0]
EndFunc

;~ CAPI(long) wkhtmltopdf_get_output(wkhtmltopdf_converter * converter, const unsigned char **);
Func _HTML2PDF_GetOutput($pConverter)
	Local $aRet = DllCall($__gHTML2PDF_hDLL, "long", "wkhtmltopdf_get_output", "ptr", $pConverter, "ptr*", 0)
	If @error Then Return SetError(@error, 0, Binary(""))
	Return DllStructGetData(DllStructCreate("byte[" & $aRet[0] & "]", $aRet[2]), 1)
EndFunc

; -------------------------------------------------------------------------------------------------
; internals

Func __html2pdf_str2UTF8struct($sText)
	$sText = StringToBinary($sText, 4)
	Local $struct = DllStructCreate("byte[" & (BinaryLen($sText) + 1) & "]")
	DllStructSetData($struct, 1, $sText)
	Return $struct
EndFunc
