param (
    [Parameter(Mandatory=$true)]
    [string]$MAC_ADDRESS
)

function Send-WOL {
    param (
        [Parameter(Mandatory=$true)]
        [string]$MAC
    )

    # Remove any separators from the MAC address
    $MAC = $MAC -replace "[-:]", ""

    # Convert the MAC address string to a byte array
    $MACBytes = for ($i = 0; $i -lt $MAC.Length; $i += 2) { [Convert]::ToByte($MAC.Substring($i, 2), 16) }

    # Create the magic packet: 6 bytes of 0xFF followed by 16 repetitions of the MAC address
    $MagicPacket = [byte[]] (0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF) + ($MACBytes * 16)

    # Create a UDP client
    $UDPClient = New-Object System.Net.Sockets.UdpClient
    $UDPClient.Connect([System.Net.IPAddress]::Broadcast, 9)

    # Send the magic packet
    $UDPClient.Send($MagicPacket, $MagicPacket.Length) | Out-Null

    # Close the UDP client
    $UDPClient.Close()
}

# Call the function with the provided MAC address
Send-WOL -MAC $MAC_ADDRESS
