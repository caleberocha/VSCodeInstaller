Set WshShell = WScript.CreateObject("Wscript.Shell")
Set fso = WScript.CreateObject("Scripting.Filesystemobject")

' Uso:
' cscript /nologo CreateShortcut.vbs "Caminho do atalho" "Destino" "Argumentos"
' cscript /nologo CreateShortcut.vbs "Caminho do atalho" "Destino" "Argumentos" -shicon "�cone"
' cscript /nologo CreateShortcut.vbs "Caminho do atalho" "Destino" "Argumentos" -shortcuticon "�cone"
' cscript /nologo CreateShortcut.vbs "Caminho do atalho" "Destino" "Argumentos" -workdir "Pasta" -shicon "�cone"
If WScript.Arguments.Count < 2 Then Usage

On Error Resume Next

strShortcut = WScript.Arguments(0)
strTarget = WScript.Arguments(1)
strIcon = ""
strWorkDir = ""
If WScript.Arguments.Count > 2 Then
	strArguments = ""
	For i = 2 To WScript.Arguments.Count - 1
		If LCase(WScript.Arguments(i)) = "-shicon" Or LCase(WScript.Arguments(i)) = "-shortcuticon" Then
			strIcon = WScript.Arguments(i+1)
			i = i + 1
		ElseIf LCase(WScript.Arguments(i)) = "-workdir" Then
			strWorkDir = WScript.Arguments(i+1)
			i = i + 1
		ElseIf strArguments = "" Then
			strArguments = WScript.Arguments(i)
		Else
			strArguments = strArguments & " " & WScript.Arguments(i)
		End If
	Next
End If

If strWorkDir = "" Then strWorkDir = Replace(strTarget, "\" & Split(strTarget, "\")(UBound(Split(strTarget, "\"))), "")
If strWorkDir = "null" Then strWorkDir = ""
If strIcon = "" Then strIcon = ",0"

Set objShortcut = WshShell.CreateShortcut(strShortcut)
If Not Err.Number = 0 Then Quit(Err)
objShortcut.TargetPath = strTarget
objShortcut.Arguments = strArguments
objShortcut.WorkingDirectory = strWorkDir
objShortcut.IconLocation = strIcon
objShortcut.Save
If Not Err.Number = 0 Then Quit(Err)

Sub Usage
	WScript.Echo "CreateShortcut.vbs" & vbCrLf &_
				 "Script que cria atalhos no Windows." & vbCrLf &_
				 "Uso:" & vbCrLf &_
				 Space(4) & "cscript /nologo CreateShortcut.vbs ""Nome_do_atalho"" ""Destino_do_atalho"" ""Argumentos""" & vbCrLf &_
				 Space(4) & "cscript /nologo CreateShortcut.vbs ""Nome_do_atalho"" ""Destino_do_atalho"" ""Argumentos"" -ShortcutIcon ""�cone""" & vbCrLf &_
				 Space(4) & "cscript /nologo CreateShortcut.vbs ""Nome_do_atalho"" ""Destino_do_atalho"" ""Argumentos"" -ShIcon ""�cone""" & vbCrLf &_
				 Space(4) & "cscript /nologo CreateShortcut.vbs ""Nome_do_atalho"" ""Destino_do_atalho"" ""Argumentos"" -ShIcon ""�cone"" -WorkDir ""Pasta"""
	WScript.Quit
End Sub


Sub Quit(QuitErr)
	If Not QuitErr.Number = 0 Then WScript.Echo "Erro " & QuitErr.Number & " em " & QuitErr.Source & ": " & QuitErr.Description
	WScript.Quit(QuitErr.Number)
End Sub