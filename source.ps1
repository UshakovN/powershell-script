# А-05-19 Ушаков Н.А. ЛР-2
# Вариант 24. Перевод из 2-8 в 2-10 сс 

# Входная строка с числом
param ([string]$Global:number = "")
Write-Host "Convert bin-oct to bin-dec."
if ($number -eq "") {
    $number = Read-Host 'Number in bin-oct notation'
}

# Алгоритм перевода из 2-8 в 10 сс
function Convert-BOD {
    param (
        [string]$num
    )
    [int]$Local:sep = $num.IndexOf('.')
    [string]$Local:whole = $num
    [string]$Local:frac = ''

    if ($sep -ne -1) {
        $whole = $num.Substring(0, $sep)
        $frac = $num.Substring($sep + 1)
    }
    [int]$Local:wh = 0
    [double]$Local:pow = 1
    for ($i = $whole.Length -1; $i -ge 0; $i--) {
        if ($whole[$i] -eq '1')  {
            $wh += $pow
        }
        $pow *= 2
    }
    [double]$Local:fr = 0
    $pow = 0.5
    for ($i = 0; $i -lt $frac.Length; $i++) {
        if ($frac[$i] -eq '1') {
            $fr += $pow
        }
        $pow /= 2     
    }
    [double]$Local:out = $wh + $fr
    return $out
}

# Перевод произвольных чисел из 2-8 в 10 сс
function Convert-BinoctDec {
    param (
        [string]$num
    )
    [string]$Local:out = $num
    [bool]$Local:sign = $false

    if ($num.Contains('-')) {
        $sign = $true
        $out = $num.Replace('-', '')
    }
    $out = Convert-BOD($out)

    if ($sign) {
        $out = $out.Insert(0, '-')
    }
    return $out
}

# Перевод произвольных чисел из 10 в 2-10 сс
function Convert-DecBindec {
    param (
        [string]$num
    )
    [string]$Local:out = ''
    for ($i = 0; $i -lt $num.Length; $i++) {
        switch ($num[$i]) {
            '0' { $out += '0000 '; break }
            '1' { $out += '0001 '; break }
            '2' { $out += '0010 '; break }
            '3' { $out += '0011 '; break }
            '4' { $out += '0100 '; break }
            '5' { $out += '0101 '; break }
            '6' { $out += '0110 '; break }
            '7' { $out += '0111 '; break }
            '8' { $out += '1000 '; break }
            '9' { $out += '1001 '; break }
            '.' { $out += '. '; break }
            '-' { $out += '-'; break }
            default { 
                throw "unexpected value"
            } 
        }
    }
    return $out
}

# Проверяет число на валидность
function Approve-Number {
    param (
        [string]$num
    )
    [string]$Local:buffer = $num
    if ($num[0] -eq '-') {
        if ($num[1] -eq ' ') {
            $buffer = $num.Substring(2)
        }
        else {
            $buffer = $num.Substring(1)
        }
    }
    if ($buffer.Contains('-')) {
        throw "repeating number sign" 
    }
    $buffer = $buffer.Replace(' ', '')
    [int]$Local:dotpos = $buffer.IndexOf('.')

    [string]$Local:whole = $buffer
    [string]$Local:frac = ''

    if ($dotpos -ne -1) {
        $whole = $buffer.Substring(0, $dotpos)
        $frac = $buffer.Substring($dotpos + 1)

        $buffer = $buffer.Remove($dotpos, 1)
    }
    if ($buffer.Contains('.')) {
        throw "repeating number separator"
    }
    if ($whole.Length % 3 -ne 0 -or $frac.Length % 3 -ne 0) {
        throw "non-triad representation"
    }

    for ($i = 0; $i -lt $buffer.Length; $i++) {
        switch ($buffer[$i]) {
            '0' { break }
            '1' { break }
            Default { throw "non-binary notation" }
        }     
    }
}

# Перевод числа из 2-8 в 2-10 сс
function Convert-BinoctBindec {
    param (
        [string]$num
    )
    try {
        [string]$Local:out = $num
        Approve-Number($out)
        $out = Convert-BinoctDec($num)
        Write-Host 'Number in decimal notation:' $out
        $out = Convert-DecBindec($out)
        Write-Host 'Number in bin-dec notation:' $out 
        Write-Host 'Convertation complete.'
    }
    catch {
        Write-Output 'Error:' $PSItem.Exception.Message
    }
}

# Точка старта скрипта
Convert-BinoctBindec($number)

