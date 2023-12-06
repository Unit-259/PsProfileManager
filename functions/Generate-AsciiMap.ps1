function Generate-AsciiMap {
    param (
        [int]$Start = 32,
        [int]$End = 127
    )

    for ($i = $Start; $i -le $End; $i++) {
        $char = [char]$i
        $asciiValue = [int]$char
        Write-Output "$char : $asciiValue"
    }
}
