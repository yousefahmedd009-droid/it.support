@echo off
set "APPDIR=C:\ProgramData\IT-Support"
set "SCRIPT=%APPDIR%\IT-Support.ps1"
set "SHORTCUT=%USERPROFILE%\Desktop\IT-Support.lnk"
set "REMOTE_SCRIPT=https://raw.githubusercontent.com/yousefahmedd009-droid/it.support/refs/heads/main/IT-Support.ps1"
set "REMOTE_VER=https://raw.githubusercontent.com/yousefahmedd009-droid/it.support/refs/heads/main/version.txt"

if not exist "%APPDIR%" mkdir "%APPDIR%"

powershell -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -Command ^
"Invoke-WebRequest '%REMOTE_SCRIPT%' -OutFile '%SCRIPT%' -UseBasicParsing; ^
Invoke-WebRequest '%REMOTE_VER%' -OutFile '%APPDIR%\version.txt' -UseBasicParsing; ^
$WS = New-Object -ComObject WScript.Shell; ^
$SC = $WS.CreateShortcut('%SHORTCUT%'); ^
$SC.TargetPath = 'powershell.exe'; ^
$SC.Arguments = '-NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File ""%SCRIPT%""'; ^
$SC.IconLocation = 'shell32.dll,21'; ^
$SC.Save(); ^
Start-Process powershell -ArgumentList '-NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File ""%SCRIPT%""' -WindowStyle Hidden"

del "%~f0"
exit
# ==========================
 Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$form = New-Object Windows.Forms.Form
$form.Text = "IT Assistant"
$form.Size = New-Object Drawing.Size(470,600)
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = "FixedSingle"
$form.MaximizeBox = $false
$form.BackColor = [Drawing.Color]::FromArgb(24,24,24)

# ---------- Logo ----------
$logoPath="C:\IT-Support\CRC-Logo.png"
if(Test-Path $logoPath){
    $logo=New-Object Windows.Forms.PictureBox
    $logo.Image=[Drawing.Image]::FromFile($logoPath)
    $logo.SizeMode="Zoom"
    $logo.Size=New-Object Drawing.Size(170,90)
    $logo.Location=New-Object Drawing.Point(150,10)
    $form.Controls.Add($logo)
}

# ---------- Rounded ----------
function Set-Rounded($control,$radius=18){
    $path = New-Object Drawing.Drawing2D.GraphicsPath
    $path.AddArc(0,0,$radius,$radius,180,90)
    $path.AddArc($control.Width-$radius,0,$radius,$radius,270,90)
    $path.AddArc($control.Width-$radius,$control.Height-$radius,$radius,$radius,0,90)
    $path.AddArc(0,$control.Height-$radius,$radius,$radius,90,90)
    $path.CloseAllFigures()
    $control.Region = New-Object Drawing.Region($path)
}

# ---------- Bubble ----------
$itBubble = New-Object Windows.Forms.Panel
$itBubble.BackColor = [Drawing.Color]::FromArgb(45,45,48)
$itBubble.Size = New-Object Drawing.Size(360,60)
$itBubble.Location = New-Object Drawing.Point(50,120)
$form.Controls.Add($itBubble)
Set-Rounded $itBubble 25

$itText = New-Object Windows.Forms.Label
$itText.Text = "Please select the problem | برجاء تحديد المشكلة"
$itText.Font = New-Object Drawing.Font("Segoe UI",10,[Drawing.FontStyle]::Bold)
$itText.ForeColor="White"
$itText.Dock="Fill"
$itText.TextAlign="MiddleCenter"
$itBubble.Controls.Add($itText)

# ---------- Combo ----------
$combo = New-Object Windows.Forms.ComboBox
$combo.Location = New-Object Drawing.Point(55,210)
$combo.Size = New-Object Drawing.Size(350,35)
$combo.Font = New-Object Drawing.Font("Segoe UI",10)
$combo.BackColor = [Drawing.Color]::FromArgb(37,37,38)
$combo.ForeColor = "White"
$combo.FlatStyle="Flat"
$combo.DropDownStyle="DropDownList"
$combo.Items.AddRange(@(
    "Internet Problem | مشكلة الإنترنت",
    "Printer Problem | مشكلة الطابعة",
    "PC Slow | بطء الجهاز",
    "Software Issue | مشكلة برنامج",
    "Cannot Login | عدم القدرة على تسجيل الدخول",
    "C Partition Full | إمتلاء قرص C",
    "Outlook Issue | مشكلة فى الايميل",
    "Other | أخرى"
))
$form.Controls.Add($combo)
Set-Rounded $combo 12

# ---------- CC Option ----------
$ccCheck = New-Object Windows.Forms.CheckBox
$ccCheck.Text = "CC someone | إضافة نسخة لشخص آخر"
$ccCheck.ForeColor = [Drawing.Color]::FromArgb(0,150,255)
$ccCheck.Font = New-Object Drawing.Font("Segoe UI",9)
$ccCheck.AutoSize = $true
$ccCheck.Location = New-Object Drawing.Point(55,228)
$ccCheck.Cursor = [System.Windows.Forms.Cursors]::Hand
$form.Controls.Add($ccCheck)

# خانة الإيميل (تم تصغير العرض لترك مساحة لزر البحث)
$ccText = New-Object Windows.Forms.TextBox
$ccText.Location = New-Object Drawing.Point(55,250)
$ccText.Size = New-Object Drawing.Size(310,28) 
$ccText.Font = New-Object Drawing.Font("Segoe UI",9)
$ccText.BackColor = [Drawing.Color]::FromArgb(37,37,38)
$ccText.ForeColor = [Drawing.Color]::Gray
$ccText.BorderStyle = "None"
$ccText.Text = "example@dorra.com"
$ccText.Visible = $false
$form.Controls.Add($ccText)

$ccPanel = New-Object Windows.Forms.Panel
$ccPanel.Location = $ccText.Location
$ccPanel.Size = $ccText.Size
$ccPanel.BackColor = [Drawing.Color]::FromArgb(37,37,38)
$ccPanel.Visible = $false
$form.Controls.Add($ccPanel)
$ccPanel.SendToBack()
Set-Rounded $ccPanel 10

# زر البحث 🔍 (أيقونة البحث الأوفلاين)
$searchBtn = New-Object Windows.Forms.Button
$searchBtn.Text = "🔍"
$searchBtn.Size = New-Object Drawing.Size(35,28)
$searchBtn.Location = New-Object Drawing.Point(370,250)
$searchBtn.BackColor = [Drawing.Color]::FromArgb(60,70,85)
$searchBtn.ForeColor = [Drawing.Color]::White
$searchBtn.FlatStyle = "Flat"
$searchBtn.FlatAppearance.BorderSize = 0
$searchBtn.Cursor = [System.Windows.Forms.Cursors]::Hand
$searchBtn.Visible = $false
$form.Controls.Add($searchBtn)
Set-Rounded $searchBtn 8

# --- دالة استخراج الإيميلات من ملفات الكاش والـ OAB على القرص C ---
function Get-OfflineContacts {
    $emails = New-Object System.Collections.Generic.List[string]
    $paths = @("$env:LOCALAPPDATA\Microsoft\Outlook\Offline Address Books", "$env:APPDATA\Microsoft\Outlook")
    
    foreach ($p in $paths) {
        if (Test-Path $p) {
            Get-ChildItem -Path "$p\*" -Include "*.oab", "Stream_Autocomplete*.dat" -Recurse -ErrorAction SilentlyContinue | ForEach-Object {
                try {
                    $bytes = [System.IO.File]::ReadAllBytes($_.FullName)
                    $text = [System.Text.Encoding]::ASCII.GetString($bytes)
                    $matches = [regex]::Matches($text, '[a-zA-Z0-9._%+\-]+@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,}')
                    foreach ($m in $matches) { 
                        if ($m.Value -like "*@dorra.com" -and -not $emails.Contains($m.Value)) { 
                            $emails.Add($m.Value) 
                        } 
                    }
                } catch {}
            }
        }
    }
    return $emails | Sort-Object -Unique
}

# --- حدث الضغط على زر البحث ---
$searchBtn.Add_Click({
    $searchForm = New-Object Windows.Forms.Form
    $searchForm.Size = New-Object Drawing.Size(350, 400)
    $searchForm.Text = "Offline Address Book"
    $searchForm.BackColor = [Drawing.Color]::FromArgb(30,30,30)
    $searchForm.StartPosition = "CenterParent"
    $searchForm.FormBorderStyle = "FixedToolWindow"
    
    $sBox = New-Object Windows.Forms.TextBox
    $sBox.Location = New-Object Drawing.Point(10,10); $sBox.Size = New-Object Drawing.Size(315,25)
    $sBox.BackColor = [Drawing.Color]::FromArgb(45,45,48); $sBox.ForeColor = [Drawing.Color]::White
    
    $lBox = New-Object Windows.Forms.ListBox
    $lBox.Location = New-Object Drawing.Point(10,40); $lBox.Size = New-Object Drawing.Size(315,300)
    $lBox.BackColor = [Drawing.Color]::FromArgb(30,30,30); $lBox.ForeColor = [Drawing.Color]::White; $lBox.BorderStyle = "None"
    
    $contacts = Get-OfflineContacts
    if ($null -ne $contacts) { $lBox.Items.AddRange($contacts) }
    
    $sBox.Add_TextChanged({
        $lBox.Items.Clear()
        foreach($c in $contacts){ if($c -like "*$($sBox.Text)*"){ [void]$lBox.Items.Add($c) } }
    })
    
    $lBox.Add_MouseDoubleClick({
        if($lBox.SelectedItem){
            $ccText.Text = $lBox.SelectedItem.ToString()
            $ccText.ForeColor = [Drawing.Color]::White
            $searchForm.Close()
        }
    })
    
    $searchForm.Controls.AddRange(@($sBox, $lBox))
    $searchForm.ShowDialog()
})

# --- الأحداث الأصلية (Focus & Check) ---
$ccText.Add_GotFocus({
    if($ccText.Text -eq "example@dorra.com"){
        $ccText.Text = ""
        $ccText.ForeColor = [Drawing.Color]::White
    }
})

$ccText.Add_LostFocus({
    if([string]::IsNullOrWhiteSpace($ccText.Text)){
        $ccText.Text = "example@dorra.com"
        $ccText.ForeColor = [Drawing.Color]::Gray
    }
})

$ccCheck.Add_CheckedChanged({
    $isVisible = $ccCheck.Checked
    $ccText.Visible = $isVisible
    $ccPanel.Visible = $isVisible
    $searchBtn.Visible = $isVisible
    if (-not $isVisible) {
        $ccText.Text = "example@dorra.com"
        $ccText.ForeColor = [Drawing.Color]::Gray
    }
})
# ---------- Description ----------
$descText = New-Object Windows.Forms.TextBox
$descText.Multiline=$true
$descText.Location = New-Object Drawing.Point(55,270)
$descText.Size = New-Object Drawing.Size(350,70)
$descText.Font = New-Object Drawing.Font("Segoe UI",10)
$descText.BackColor = [Drawing.Color]::FromArgb(37,37,38)
$descText.ForeColor = [Drawing.Color]::Gray
$descText.BorderStyle="None"
$placeholder = "Please describe the problem | برجاء وصف المشكلة"
$descText.Text = $placeholder

$descText.Add_GotFocus({
    if($descText.Text -eq $placeholder){
        $descText.Text=""
        $descText.ForeColor = [Drawing.Color]::White
    }
})
$descText.Add_LostFocus({
    if([string]::IsNullOrWhiteSpace($descText.Text)){
        $descText.Text=$placeholder
        $descText.ForeColor=[Drawing.Color]::Gray
    }
})
$form.Controls.Add($descText)

$descPanel = New-Object Windows.Forms.Panel
$descPanel.Location = $descText.Location
$descPanel.Size = $descText.Size
$descPanel.BackColor=[Drawing.Color]::FromArgb(37,37,38)
$form.Controls.Add($descPanel)
$descPanel.SendToBack()
Set-Rounded $descPanel 12

# ---------- File Upload ----------
$uploadedFilePath = $null

$uploadBtn = New-Object Windows.Forms.Button
$uploadBtn.Text = "Attach File | إرفاق ملف"
$uploadBtn.Location = New-Object Drawing.Point(55,390)
$uploadBtn.Size = New-Object Drawing.Size(170,30)
$uploadBtn.BackColor = [Drawing.Color]::FromArgb(0,100,160)
$uploadBtn.FlatStyle = "Flat"
$uploadBtn.ForeColor = "White"
$uploadBtn.Font = New-Object Drawing.Font("Segoe UI",9)
$form.Controls.Add($uploadBtn)
Set-Rounded $uploadBtn 14

$uploadLabel = New-Object Windows.Forms.Label
$uploadLabel.Location = New-Object Drawing.Point(235,395)
$uploadLabel.Size = New-Object Drawing.Size(170,20)
$uploadLabel.ForeColor = [Drawing.Color]::Gray
$uploadLabel.Font = New-Object Drawing.Font("Segoe UI",8,[Drawing.FontStyle]::Italic)
$uploadLabel.Text = "No file | لا يوجد ملف"
$uploadLabel.TextAlign = "MiddleLeft"
$form.Controls.Add($uploadLabel)

$uploadBtn.Add_Click({
    $openDialog = New-Object System.Windows.Forms.OpenFileDialog
    $openDialog.Title = "Select a file | اختار ملف"
    $openDialog.Filter = "All Files (*.*)|*.*"
    $openDialog.Multiselect = $false
    if($openDialog.ShowDialog() -eq "OK"){
        $fileInfo = [System.IO.FileInfo]$openDialog.FileName
        if ($fileInfo.Length -gt 5MB) {
            [System.Windows.Forms.MessageBox]::Show(
                "File exceeds 5MB limit.`nالملف أكبر من 5 ميجا، اختار ملف أصغر.",
                "File Too Large | الملف كبير",
                [System.Windows.Forms.MessageBoxButtons]::OK,
                [System.Windows.Forms.MessageBoxIcon]::Warning
            )
        } else {
            $script:uploadedFilePath = $openDialog.FileName
            $fileName = [System.IO.Path]::GetFileName($script:uploadedFilePath)
            if($fileName.Length -gt 20){ $fileName = $fileName.Substring(0,17) + "..." }
            $uploadLabel.Text = $fileName
            $uploadLabel.ForeColor = [Drawing.Color]::LightGreen
        }
       }
})
# ---------- Mode Selection ----------
$modeLabel = New-Object Windows.Forms.Label
$modeLabel.Text = "Select attachment mode | اختر طريقة الإرفاق"
$modeLabel.ForeColor = "White"
$modeLabel.Size = New-Object Drawing.Size(350,20)
$modeLabel.Location = New-Object Drawing.Point(55,430)
$form.Controls.Add($modeLabel)

$radioFile = New-Object Windows.Forms.RadioButton
$radioFile.Text = "Attach File | إرفاق ملف"
$radioFile.ForeColor = "White"
$radioFile.AutoSize = $true
$radioFile.Location = New-Object Drawing.Point(55,465)
$form.Controls.Add($radioFile)

$radioScreen = New-Object Windows.Forms.RadioButton
$radioScreen.Text = "Screenshot | لقطة شاشة"
$radioScreen.ForeColor = "White"
$radioScreen.AutoSize = $true
$radioScreen.Location = New-Object Drawing.Point(200,465)
$form.Controls.Add($radioScreen)
# ---------- Progress ----------
$progressBack=New-Object Windows.Forms.Panel
$progressBack.Size=New-Object Drawing.Size(350,14)
$progressBack.Location = New-Object Drawing.Point(55,370)
$progressBack.BackColor=[Drawing.Color]::FromArgb(60,60,60)
$form.Controls.Add($progressBack)

$progressBar=New-Object Windows.Forms.Panel
$progressBar.Size=New-Object Drawing.Size(0,14)
$progressBar.BackColor=[Drawing.Color]::FromArgb(0,120,212)
$progressBack.Controls.Add($progressBar)

$progressLabel = New-Object Windows.Forms.Label
$progressLabel.Size = New-Object Drawing.Size(350,18)
$progressLabel.Location = New-Object Drawing.Point(55,350)
$progressLabel.ForeColor="White"
$progressLabel.Font = New-Object Drawing.Font("Segoe UI",9,[Drawing.FontStyle]::Italic)
$progressLabel.TextAlign = "MiddleCenter"
$form.Controls.Add($progressLabel)

function Animate-Progress($bar,$target){
    $progressLabel.Text="Preparing data... | جارى تحضير البيانات..."
    while($bar.Width -lt $target){
        $bar.Width+=5
        Start-Sleep -Milliseconds 15
        $form.Refresh()
    }
}

# ---------- Buttons ----------
$send=New-Object Windows.Forms.Button
$send.Text="Send | إرسال"
$send.Location=New-Object Drawing.Point(110,510)
$send.Size=New-Object Drawing.Size(100,35)
$send.BackColor=[Drawing.Color]::FromArgb(0,176,80)
$send.FlatStyle="Flat"
$send.ForeColor="White"
$form.Controls.Add($send)
Set-Rounded $send 18

$cancel=New-Object Windows.Forms.Button
$cancel.Text="Cancel | إلغاء"
$cancel.Location=New-Object Drawing.Point(230,510)
$cancel.Size = New-Object Drawing.Size(100,35)
$cancel.BackColor=[Drawing.Color]::FromArgb(192,0,0)
$cancel.FlatStyle="Flat"
$cancel.ForeColor="White"
$form.Controls.Add($cancel)
Set-Rounded $cancel 18
$cancel.Add_Click({$form.Close()})

# ---------- Send ----------
$send.Add_Click({

    if([string]::IsNullOrWhiteSpace($combo.Text)){
        [System.Windows.Forms.MessageBox]::Show("Please select a problem | من فضلك اختار المشكلة")
        return
    }

    $progressBar.Width=0
    $pc=$env:COMPUTERNAME
    $user=$env:USERNAME
    $date=Get-Date -Format "yyyy-MM-dd_HH-mm"
    $temp="$env:TEMP\IT-$date"
    New-Item -ItemType Directory -Path $temp -Force | Out-Null

    Animate-Progress $progressBar 80

    $problem=$combo.Text
    $extraData=""

    switch ($problem) {

        "Internet Problem | مشكلة الإنترنت" {
            ipconfig /all > "$temp\network.txt"
            getmac > "$temp\mac.txt"
            netsh wlan show interfaces > "$temp\wifi.txt"

            $extraData = "`n--- Network Info ---`n" +
            (ipconfig | Select-String "IPv4" | Out-String) +
            (getmac | Out-String) +
            (netsh wlan show interfaces | Select-String "SSID" | Out-String)
        }

        "Printer Problem | مشكلة الطابعة" {
            Get-Printer > "$temp\printers.txt"
            $extraData = "`n--- Printers ---`n" + (Get-Printer | Out-String)
        }
"PC Slow | بطء الجهاز" {

    # Top Processes
    Get-Process | Sort CPU -Descending | Select -First 5 > "$temp\cpu.txt"

    # RAM Info 
    $ram = Get-CimInstance Win32_OperatingSystem
    $totalRAM = [math]::Round($ram.TotalVisibleMemorySize / 1MB,2)
    $freeRAM  = [math]::Round($ram.FreePhysicalMemory / 1MB,2)

    # Disk Info 
    $disk = Get-PSDrive -PSProvider FileSystem | Select Name,
        @{Name="Used(GB)";Expression={[math]::Round($_.Used / 1GB,2)}},
        @{Name="Free(GB)";Expression={[math]::Round($_.Free / 1GB,2)}}

    $disk | Out-File "$temp\disk.txt"

    "Total RAM: $totalRAM GB`nFree RAM: $freeRAM GB" | Out-File "$temp\ram.txt"

    $extraData = ""
}


        "Software Issue | مشكلة برنامج" {
            Get-EventLog -LogName Application -Newest 10 > "$temp\app_logs.txt"
            $extraData = "`n--- App Logs ---`n" + (Get-EventLog -LogName Application -Newest 5 | Out-String)
        }

        "Cannot Login | عدم القدرة على تسجيل الدخول" {
            Get-EventLog -LogName Security -Newest 10 > "$temp\login_logs.txt"
            $extraData = "`n--- Login Logs ---`n" + (Get-EventLog -LogName Security -Newest 5 | Out-String)
        }

        "C Partition Full | إمتلاء قرص C" {
            Get-PSDrive C > "$temp\disk.txt"
            $extraData = "`n--- Disk Info ---`n" + (Get-PSDrive C | Out-String)
        }

        "Outlook Issue | مشكلة فى الايميل" {
            # بدون تعديل
        }
    }

$reportContent="User: $user`nComputer: $pc`nDate: $date`n`nProblem: $problem`nDescription: $($descText.Text)"

    Animate-Progress $progressBar $progressBack.Width

# ---------- Screenshot OR File ----------
if ($radioScreen.Checked) {

    $s=[System.Windows.Forms.Screen]::PrimaryScreen.Bounds
    $bmp=[Drawing.Bitmap]::new($s.Width,$s.Height)
    $g=[Drawing.Graphics]::FromImage($bmp)
    $g.CopyFromScreen($s.Location,[Drawing.Point]::Empty,$s.Size)
    $bmp.Save("$temp\screenshot.png")
    $g.Dispose()
    $bmp.Dispose()
}
elseif ($radioFile.Checked -and $script:uploadedFilePath -and (Test-Path $script:uploadedFilePath)) {

    $fileName = [System.IO.Path]::GetFileName($script:uploadedFilePath)
    Copy-Item $script:uploadedFilePath "$temp\$fileName" -Force
}

    $zip="$env:TEMP\IT-$date.zip"
    Compress-Archive -Path "$temp\*" -DestinationPath $zip -Force
    # ---- CC Value ----
    $ccAddress = ""
    if ($ccCheck.Checked -and $ccText.Text -ne "example@dorra.com" -and $ccText.Text.Trim() -ne "") {
        $ccAddress = $ccText.Text.Trim()
    }
    # ---------- Email  ----------
    if($problem -eq "Outlook Issue | مشكلة فى الايميل"){

        $smtpServer = "imap.worldposta.com"
        $port = 465
        $from = "CRC.Support@dorra.com"
        $to = "it.support@dorra.com"

        $securePass = ConvertTo-SecureString "Begob^80" -AsPlainText -Force
        $cred = New-Object System.Management.Automation.PSCredential ($from, $securePass)

$params = @{
    To = $to
    From = $from
    Subject = "IT - $problem - $pc"
    Body = $reportContent
    Encoding = [System.Text.Encoding]::UTF8
    Attachments = $zip
    SmtpServer = $smtpServer
    Port = $port
    UseSsl = $true
    Credential = $cred
}

if($ccAddress){
    $params.Cc = $ccAddress
}

Send-MailMessage @params
    } else {
        $o=New-Object -ComObject Outlook.Application
       $m=$o.CreateItem(0)
$m.To="it.support@dorra.com"

if($ccAddress){
    $m.CC = $ccAddress
}
$m.Subject="IT - $problem - $pc"
$m.Body=$reportContent
$m.Attachments.Add($zip) | Out-Null
        $m.Send()
    }
    Remove-Item $zip -Force
    Remove-Item $temp -Recurse -Force

    # ---------- Message ----------
    $msgForm = New-Object Windows.Forms.Form
    $msgForm.Size = New-Object Drawing.Size(350,80)
    $msgForm.StartPosition = "CenterParent"
    $msgForm.FormBorderStyle = "None"
    $msgForm.BackColor = [Drawing.Color]::FromArgb(45,45,48)
    $msgLabel = New-Object Windows.Forms.Label
    $msgLabel.Text = "تم توجيه الطلب | Request sent"
    $msgLabel.ForeColor = "White"
    $msgLabel.Font = New-Object Drawing.Font("Segoe UI",10,[Drawing.FontStyle]::Bold)
    $msgLabel.Dock = "Fill"
    $msgLabel.TextAlign = "MiddleCenter"
    $msgForm.Controls.Add($msgLabel)
    Set-Rounded $msgForm 25
    $msgForm.TopMost = $true
    $msgForm.Add_Shown({Start-Sleep -Seconds 2; $msgForm.Close()})
    $msgForm.ShowDialog()

    $form.Close()
})

$form.ShowDialog()
