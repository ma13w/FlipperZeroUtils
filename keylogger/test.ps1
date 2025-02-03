# URL del Webhook (sostituisci con il tuo URL di Webhook.site)
$webhookUrl = "https://webhook.site/fbea19fd-c6a4-4fe7-b371-c0066a01848e?keys=test"

# Crea una nuova richiesta HTTP GET
$uri = New-Object System.Uri($webhookUrl)
$request = [System.Net.HttpWebRequest]::Create($uri)
$request.Method = "GET"  # Imposta il metodo come GET

# Ottieni la risposta
$response = $request.GetResponse()

# Leggi la risposta (opzionale, per debug)
$reader = New-Object System.IO.StreamReader($response.GetResponseStream())
$responseContent = $reader.ReadToEnd()

# Stampa la risposta per verificare che funzioni
Write-Host "Risposta del Webhook: $responseContent"

# Chiudi la risposta
$response.Close()
