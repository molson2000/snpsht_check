Add-PSSnapin VMware.VimAutomation.core
#Email Config
$SMTPserver = "0.0.0.0"
$from = "me@mail.com"
$to = "me@mail.com"
#
#Connect to Old vCenter check for snaps
#
    connect-viserver -server 0.0.0.0 -User username -Password password
    $oldvcenter = foreach($vmview1 in get-view -viewtype virtualmachine){ $vmview1.Config.Hardware.Device | ? {$_ -is [VMware.Vim.VirtualDisk]} | %{$_.Backing | select @{N="VMname";E={$vmview1.name}},Filename |?{$_.FileName.Split('/')[-1] -match ".*\-[0-9]{6}\.vmdk"} } | out-string }; 
	#foreach virtual machine get-view get only devices from its config that are hard disks, then select those that name matches pattern *-000000.vmdk 
#
#Email
#
$subject = "All Snapshots on All Datastores"
$emailbody = "Old vCenter ______________________$oldvcenter New vCenter1 ________________________ $vcenter1  VFvCenter1 ________________________ $rdvcenter1 "
$mailer = New-Object System.Net.Mail.SMTPclient($SMTPserver)
$msg = New-Object System.Net.Mail.MailMessage($from, $to, $subject, $emailbody)
$Mailer.send($msg)
