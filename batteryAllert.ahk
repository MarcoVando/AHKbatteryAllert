#SingleInstance force

loop{
  VarSetCapacity(powerstatus, 1+1+1+1+4+4)
  success := DllCall("kernel32.dll\GetSystemPowerStatus", "uint", &powerstatus)

  acLineStatus:=ReadInteger(&powerstatus,0,1,false)
  batteryFlag:=ReadInteger(&powerstatus,1,1,false)
  batteryLifePercent:=ReadInteger(&powerstatus,2,1,false)
  batteryLifeTime:=ReadInteger(&powerstatus,4,4,false)
  batteryFullLifeTime:=ReadInteger(&powerstatus,8,4,false)

  ; defining the output string
  output=AC Status: %acLineStatus%`nBattery Flag: %batteryFlag%`nBattery Life (percent): %batteryLifePercent%`n Battery Life (time): %batteryLifeTime%`nBattery Life (full time): %batteryFullLifeTime%
  ;MsgBox, %output%n
	
  ; definition of allert level
  batteryAllert = 96
  
  ; if PC is connected and battery status is higher than the allert value, spam the message box, it will deactivate only if you unplug the connector
  if (acLineStatus)
  	if (batteryLifePercent >= batteryAllert) 
    		loop
    		{
		acLineStatus:=ReadInteger(&powerstatus,0,1,false)
        	MsgBox, Battery over %batteryAllert% (!!!)`nAC Status: %acLineStatus%
		IfMsgBox Ok
			break
    		}
  Sleep, 300000
}

ReadInteger( p_address, p_offset, p_size, p_hex=true )
{
  value = 0
  old_FormatInteger := a_FormatInteger
  if ( p_hex )
    SetFormat, integer, hex
  else
    SetFormat, integer, dec
  loop, %p_size%
    value := value+( *( ( p_address+p_offset )+( a_Index-1 ) ) << ( 8* ( a_Index-1 ) ) )
  SetFormat, integer, %old_FormatInteger%
  return, value
}
