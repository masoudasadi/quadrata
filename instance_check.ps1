  param(
    [string]$horcm
  )

$horcm = $horcm.Trim()


$hcmStArg = "horcmstart.exe "  # Uncommnet this line when inserted inside the maintenance machine
$hcmStArg = $hcmStArg.replace('\n','')   # Uncommnet this line when inserted inside the maintenance machine
$hcmStArg = $hcmStArg+$horcm
$hcmStArg

$finalCode = (iex $hcmStArg 2>&1)

############################################################

$zbxServer = "192.168.217.67"
$zbxKey = "hds_instance"
$zbxKey += $horcm
$zbxKey = $zbxKey.replace('\n','')
$zbxHost = "192.168.217.59"


$zbxSend = "zabbix_sender.exe"  # Uncommnet this line when inserted inside the maintenance machine
$zbxSendArg += " -z "   # Uncommnet this line when inserted inside the maintenance machine
$zbxSendArg += $zbxServer   # Uncommnet this line when inserted inside the maintenance machine
$zbxSendArg += " -k "  # Uncommnet this line when inserted inside the maintenance machine
$zbxSendArg = $zbxKey   # Uncommnet this line when inserted inside the maintenance machine
$zbxSendArg = $zbxSend+$zbxSendArg
$zbxSendArg

# horcmstart.exe <instance number> --> return code: 0, 1, 2 .....
# zabbix_sender.exe -z 192.168.217.67 -k hds_instance_<INST> -s 192.168.217.59 -o $finalCode