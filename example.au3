#NoTrayIcon
#include "wkhtmltopdf.au3"

Global $sDllPath
If @AutoItX64 Then
	$sDllPath = @ScriptDir & "\wkhtmltox-x64.dll"
Else
	$sDllPath = @ScriptDir & "\wkhtmltox-x86.dll"
EndIf

Global $sHTML = FileRead("test.html")

For $i = 1 To 1
	Call(StringFormat("_Example%02d", $i))
Next

; simplest
Func _Example01()
	ConsoleWrite(@CRLF & "-----------" & @CRLF & "Example 01: Simplest" & @CRLF)

	; init
	_HTML2PDF_Init($sDllPath)
	ConsoleWrite("Init done (@error=" & @error & ")" & @CRLF)

	; create settings (all default)
	$pGS = _HTML2PDF_CreateGlobalSettings()
	$pOS = _HTML2PDF_CreateObjectSettings()

	; create converter
	$pConverter = _HTML2PDF_CreateConverter($pGS)

	; optional: add callbacks
	_HTML2PDF_SetCallback($pConverter, "warning", __callback_warning)
	_HTML2PDF_SetCallback($pConverter, "error", __callback_error)
	_HTML2PDF_SetCallback($pConverter, "phase_changed", __callback_phase_changed)
	_HTML2PDF_SetCallback($pConverter, "progress", __callback_progress)
	_HTML2PDF_SetCallback($pConverter, "finished", __callback_finished)

	; add HTML source to convert
	_HTML2PDF_AddObject($pConverter, $pOS, $sHTML)

	; do conversion
	_HTML2PDF_Convert($pConverter)
	$bOutput = _HTML2PDF_GetOutput($pConverter)

	$hF = FileOpen("example01.pdf", 2 + 8 + 128)
	FileWrite($hF, Binary($bOutput))
	FileClose($hF)

	; cleanup
	_HTML2PDF_DestroyConverter($pConverter)
	_HTML2PDF_DestroyObjectSettings($pOS)
	_HTML2PDF_DestroyGlobalSettings($pGS)
	_HTML2PDF_Deinit()
EndFunc

; -------------------------------------------------------------------------------------------------

Func __callback_warning($pConverter, $sText)
	ConsoleWrite("Warning: " & $sText & @CRLF)
EndFunc
Func __callback_error($pConverter, $sText)
	ConsoleWrite("ERROR: " & $sText & @CRLF)
EndFunc
Func __callback_phase_changed($pConverter)
	Local $iPhase = _HTML2PDF_CurrentPhase($pConverter)
	ConsoleWrite("Phase " & ($iPhase + 1) & "/" & _HTML2PDF_PhaseCount($pConverter) & ": " & _HTML2PDF_PhaseDescription($pConverter, $iPhase) & @CRLF)
EndFunc
Func __callback_progress($pConverter, $iData)
	ConsoleWrite("Progress: " & $iData & " (" & _HTML2PDF_ProgressString($pConverter) & ")" & @CRLF)
EndFunc
Func __callback_finished($pConverter, $iData)
	ConsoleWrite("DONE (" & $iData & ")" & @CRLF)
EndFunc

