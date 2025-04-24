function Get-NetworkInfo {
    param (
        [Parameter(Mandatory)]
        [string]$CIDR
    )

    if ($CIDR -notmatch "^(\d{1,3}\.){3}\d{1,3}/\d{1,2}$") {
        Write-Error "Anna IP CIDR-muodossa, esim. 172.10.10.73/29"
        return
    }

    $split = $CIDR -split "/"
    $ip = [System.Net.IPAddress]::Parse($split[0])
    $prefix = [int]$split[1]
    $maskBits = "1" * $prefix + "0" * (32 - $prefix)
    $maskBytes = ($maskBits -split "(.{8})" | Where-Object { $_ }) | ForEach-Object { [Convert]::ToByte($_, 2) }
    $netmask = [System.Net.IPAddress]::new($maskBytes)

    $ipBytes = $ip.GetAddressBytes()
    $networkBytes = @()
    $broadcastBytes = @()

    for ($i = 0; $i -lt 4; $i++) {
        $networkBytes += ($ipBytes[$i] -band $maskBytes[$i])
        $broadcastBytes += (($ipBytes[$i] -band $maskBytes[$i]) -bor (255 - $maskBytes[$i]))
    }

    $network = [System.Net.IPAddress]::new($networkBytes)
    $broadcast = [System.Net.IPAddress]::new($broadcastBytes)

    $hosts = [math]::Pow(2, 32 - $prefix) - 2

    Write-Host ""
    Write-Host "IP-verkko:           $CIDR"
    Write-Host "Aliverkon maski:     $($netmask)"
    Write-Host "Verkko-osoite:       $($network)"
    Write-Host "Broadcast-osoite:    $($broadcast)"

    if ($hosts -gt 0) {
        $networkInt = [BitConverter]::ToUInt32($network.GetAddressBytes(), 0)
        $broadcastInt = [BitConverter]::ToUInt32($broadcast.GetAddressBytes(), 0)

        $firstHost = $networkInt + 1
        $lastHost = $broadcastInt - 1

        $firstHostIp = [System.Net.IPAddress]::new([BitConverter]::GetBytes($firstHost))
        $lastHostIp = [System.Net.IPAddress]::new([BitConverter]::GetBytes($lastHost))

        Write-Host "Oletusreititin:      $firstHostIp"
        Write-Host "Laitteiden IP:t:     $firstHostIp - $lastHostIp"
    } else {
        Write-Host "Ei käytettäviä laiteosoitteita tässä verkossa."
    }
}

# Käyttö:
$cidr = Read-Host "Anna IP CIDR-muodossa (esim. 172.10.10.73/29)"
Get-NetworkInfo -CIDR $cidr
