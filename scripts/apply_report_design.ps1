param(
    [string]$PbixPath = "powerbi/personal_finance_dashboard.pbix",
    [string]$ThemePath = "powerbi/personal_finance_theme.json"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function ConvertTo-CompressedJson {
    param([object]$Value)
    return ($Value | ConvertTo-Json -Depth 100 -Compress)
}

function New-VisualName {
    $bytes = New-Object byte[] 10
    [System.Security.Cryptography.RandomNumberGenerator]::Create().GetBytes($bytes)
    return (($bytes | ForEach-Object { $_.ToString("x2") }) -join "")
}

function New-Literal {
    param([string]$Value)
    return @{ expr = @{ Literal = @{ Value = $Value } } }
}

function New-TextBox {
    param(
        [double]$X,
        [double]$Y,
        [double]$Width,
        [double]$Height,
        [int]$Z,
        [string[]]$Lines,
        [string]$FontSize = "12pt",
        [string]$Color = "#112D4E",
        [switch]$Bold
    )

    $paragraphs = @()
    foreach ($line in $Lines) {
        $style = [ordered]@{
            fontSize = $FontSize
            color = $Color
        }
        if ($Bold) {
            $style.fontWeight = "bold"
        }

        $paragraphs += [ordered]@{
            textRuns = @(
                [ordered]@{
                    value = $line
                    textStyle = $style
                }
            )
        }
    }

    $name = New-VisualName
    $config = [ordered]@{
        name = $name
        layouts = @(
            [ordered]@{
                id = 0
                position = [ordered]@{
                    x = $X
                    y = $Y
                    z = $Z
                    width = $Width
                    height = $Height
                    tabOrder = $Z
                }
            }
        )
        singleVisual = [ordered]@{
            visualType = "textbox"
            drillFilterOtherVisuals = $true
            objects = [ordered]@{
                general = @(
                    [ordered]@{
                        properties = [ordered]@{
                            paragraphs = $paragraphs
                        }
                    }
                )
            }
        }
    }

    return [ordered]@{
        x = $X
        y = $Y
        z = $Z
        width = $Width
        height = $Height
        config = ConvertTo-CompressedJson $config
        filters = "[]"
        tabOrder = $Z
    }
}

function New-Rectangle {
    param(
        [double]$X,
        [double]$Y,
        [double]$Width,
        [double]$Height,
        [int]$Z,
        [string]$FillColor
    )

    $name = New-VisualName
    $config = [ordered]@{
        name = $name
        layouts = @(
            [ordered]@{
                id = 0
                position = [ordered]@{
                    x = $X
                    y = $Y
                    z = $Z
                    width = $Width
                    height = $Height
                    tabOrder = $Z
                }
            }
        )
        singleVisual = [ordered]@{
            visualType = "shape"
            drillFilterOtherVisuals = $true
            objects = [ordered]@{
                shape = @(
                    [ordered]@{
                        properties = [ordered]@{
                            tileShape = New-Literal "'rectangle'"
                        }
                    }
                )
                rotation = @(
                    [ordered]@{
                        properties = [ordered]@{
                            shapeAngle = New-Literal "0L"
                        }
                    }
                )
                fill = @(
                    [ordered]@{
                        properties = [ordered]@{
                            show = New-Literal "true"
                            fillColor = @{ solid = @{ color = $FillColor } }
                            transparency = New-Literal "0L"
                        }
                    }
                )
                outline = @(
                    [ordered]@{
                        properties = [ordered]@{
                            show = New-Literal "false"
                        }
                    }
                )
            }
        }
    }

    return [ordered]@{
        x = $X
        y = $Y
        z = $Z
        width = $Width
        height = $Height
        config = ConvertTo-CompressedJson $config
        filters = "[]"
        tabOrder = $Z
    }
}

function New-PageNavigator {
    param(
        [double]$X,
        [double]$Y,
        [double]$Width,
        [double]$Height,
        [int]$Z
    )

    $name = New-VisualName
    $config = [ordered]@{
        name = $name
        layouts = @(
            [ordered]@{
                id = 0
                position = [ordered]@{
                    x = $X
                    y = $Y
                    z = $Z
                    width = $Width
                    height = $Height
                    tabOrder = $Z
                }
            }
        )
        singleVisual = [ordered]@{
            visualType = "pageNavigator"
            drillFilterOtherVisuals = $true
            objects = [ordered]@{
                grid = @(
                    [ordered]@{
                        properties = [ordered]@{
                            orientation = New-Literal "'Vertical'"
                            padding = New-Literal "8L"
                        }
                    }
                )
                fill = @(
                    [ordered]@{
                        properties = [ordered]@{
                            fillColor = @{ solid = @{ color = "#112D4E" } }
                            transparency = New-Literal "0L"
                        }
                    }
                )
                text = @(
                    [ordered]@{
                        properties = [ordered]@{
                            fontColor = @{ solid = @{ color = "#F9F7F7" } }
                            textSize = New-Literal "11D"
                        }
                    }
                )
                selectedState = @(
                    [ordered]@{
                        properties = [ordered]@{
                            fillColor = @{ solid = @{ color = "#3F72AF" } }
                            fontColor = @{ solid = @{ color = "#F9F7F7" } }
                        }
                    }
                )
            }
        }
    }

    return [ordered]@{
        x = $X
        y = $Y
        z = $Z
        width = $Width
        height = $Height
        config = ConvertTo-CompressedJson $config
        filters = "[]"
        tabOrder = $Z
    }
}

function Set-VisualPosition {
    param(
        [object]$Visual,
        [double]$X,
        [double]$Y,
        [double]$Width,
        [double]$Height,
        [int]$Z
    )

    $Visual.x = $X
    $Visual.y = $Y
    $Visual.width = $Width
    $Visual.height = $Height
    $Visual.z = $Z
    if ($Visual.PSObject.Properties.Name -contains "tabOrder") {
        $Visual.tabOrder = $Z
    } else {
        $Visual | Add-Member -MemberType NoteProperty -Name tabOrder -Value $Z
    }

    $config = $Visual.config | ConvertFrom-Json
    $config.layouts[0].position.x = $X
    $config.layouts[0].position.y = $Y
    $config.layouts[0].position.width = $Width
    $config.layouts[0].position.height = $Height
    $config.layouts[0].position.z = $Z
    $config.layouts[0].position.tabOrder = $Z
    $Visual.config = ConvertTo-CompressedJson $config
}

function Set-TextBoxLines {
    param(
        [object]$Visual,
        [string[]]$Lines,
        [string]$FontSize = "12pt",
        [string]$Color = "#112D4E"
    )

    $config = $Visual.config | ConvertFrom-Json
    $paragraphs = @()
    foreach ($line in $Lines) {
        $paragraphs += [ordered]@{
            textRuns = @(
                [ordered]@{
                    value = $line
                    textStyle = [ordered]@{
                        fontWeight = "bold"
                        fontSize = $FontSize
                        color = $Color
                    }
                }
            )
        }
    }
    $config.singleVisual.objects.general[0].properties.paragraphs = $paragraphs
    $Visual.config = ConvertTo-CompressedJson $config
}

function Copy-Visual {
    param([object]$Visual)
    return (($Visual | ConvertTo-Json -Depth 100) | ConvertFrom-Json)
}

function Replace-MeasureReference {
    param(
        [object]$Visual,
        [string]$OldMeasure,
        [string]$NewMeasure
    )

    $config = $Visual.config | ConvertFrom-Json
    $json = ConvertTo-CompressedJson $config
    $json = $json.Replace("_Measures.$OldMeasure", "_Measures.$NewMeasure")
    $json = $json.Replace("`"$OldMeasure`"", "`"$NewMeasure`"")
    $json = $json.Replace("\`"$OldMeasure\`"", "\`"$NewMeasure\`"")
    $Visual.config = $json
    if ($Visual.PSObject.Properties.Name -contains "query") {
        $Visual.query = $Visual.query.Replace("_Measures.$OldMeasure", "_Measures.$NewMeasure")
        $Visual.query = $Visual.query.Replace("`"$OldMeasure`"", "`"$NewMeasure`"")
    }
}

function Add-DesignShell {
    param(
        [object]$Section,
        [string]$Title,
        [string]$Subtitle
    )

    $shell = @(
        New-Rectangle 0 0 220 720 0 "#112D4E"
        New-TextBox 24 28 172 68 1 @("Personal", "Finance") "18pt" "#F9F7F7" -Bold
        New-TextBox 24 105 172 24 2 @("DASHBOARD") "9pt" "#DBE2EF"
        New-PageNavigator 18 158 184 120 3
        New-TextBox 24 650 172 42 4 @("Portfolio Power BI", "CV project") "9pt" "#DBE2EF"
    )

    $Section.visualContainers = @($shell + $Section.visualContainers)
}

function Read-ZipEntryBytes {
    param(
        [System.IO.Compression.ZipArchive]$Zip,
        [string]$EntryName
    )
    $entry = $Zip.GetEntry($EntryName)
    if ($null -eq $entry) {
        throw "Entry not found: $EntryName"
    }
    $stream = $entry.Open()
    try {
        $memory = New-Object System.IO.MemoryStream
        $stream.CopyTo($memory)
        return $memory.ToArray()
    }
    finally {
        $stream.Dispose()
    }
}

$resolvedPbix = Resolve-Path $PbixPath
$resolvedTheme = Resolve-Path $ThemePath
$themeJson = Get-Content -Path $resolvedTheme -Raw

Add-Type -AssemblyName System.IO.Compression.FileSystem

$zip = [System.IO.Compression.ZipFile]::OpenRead($resolvedPbix)
try {
    $entries = @()
    foreach ($entry in $zip.Entries) {
        if ($entry.FullName -eq "SecurityBindings") {
            continue
        }

        $bytes = Read-ZipEntryBytes $zip $entry.FullName
        $entries += [ordered]@{
            Name = $entry.FullName
            Bytes = $bytes
        }
    }

    $layoutBytes = Read-ZipEntryBytes $zip "Report/Layout"
    $layoutText = [System.Text.Encoding]::Unicode.GetString($layoutBytes).Trim([char]0xFEFF)
    $layout = $layoutText | ConvertFrom-Json
}
finally {
    $zip.Dispose()
}

$executive = $layout.sections | Where-Object { $_.displayName -like "Executive*" } | Select-Object -First 1
if ($null -eq $executive) {
    throw "Executive page not found."
}

$executive.displayName = "Executive Overview"
$executive.ordinal = 0
$executive.config = '{"objects":{"outspacePane":[{"properties":{"width":{"expr":{"Literal":{"Value":"220L"}}}}}]}}'

$validation = $layout.sections | Where-Object { $_.displayName -eq "Validation" } | Select-Object -First 1
if ($null -ne $validation) {
    $validation.ordinal = 2
    if ($validation.PSObject.Properties.Name -contains "visibility") {
        $validation.visibility = 1
    } else {
        $validation | Add-Member -MemberType NoteProperty -Name visibility -Value 1
    }
}

$existingExpense = $layout.sections | Where-Object { $_.displayName -eq "Expense Analysis" } | Select-Object -First 1
if ($null -ne $existingExpense) {
    $layout.sections = @($layout.sections | Where-Object { $_.displayName -ne "Expense Analysis" })
}

$originalExecutiveVisuals = @($executive.visualContainers)
$executive.visualContainers = @($originalExecutiveVisuals)

Set-TextBoxLines $executive.visualContainers[0] @("Executive Overview", "Income, expenses, budget usage and savings analysis") "18pt" "#112D4E"
Set-VisualPosition $executive.visualContainers[0] 250 28 990 58 10
Set-VisualPosition $executive.visualContainers[1] 250 108 230 96 11
Set-VisualPosition $executive.visualContainers[2] 500 108 230 96 12
Set-VisualPosition $executive.visualContainers[3] 750 108 230 96 13
Set-VisualPosition $executive.visualContainers[4] 1000 108 240 96 14
Set-VisualPosition $executive.visualContainers[5] 810 235 430 210 15
Set-VisualPosition $executive.visualContainers[6] 250 235 315 210 16
Set-VisualPosition $executive.visualContainers[7] 250 465 990 220 17
Set-VisualPosition $executive.visualContainers[8] 590 235 195 95 18
Set-VisualPosition $executive.visualContainers[9] 590 350 195 95 19
Add-DesignShell $executive "Executive Overview" "Income, expenses, budget usage and savings analysis"

$expense = Copy-Visual $executive
$expense.name = "ExpenseAnalysis"
$expense.displayName = "Expense Analysis"
$expense.ordinal = 1
$expense.visualContainers = @()

$expenseVisuals = @()
foreach ($visual in $originalExecutiveVisuals) {
    $expenseVisuals += Copy-Visual $visual
}

Set-TextBoxLines $expenseVisuals[0] @("Expense Analysis", "Expense structure, budget usage and optimization priorities") "18pt" "#112D4E"
Replace-MeasureReference $expenseVisuals[1] "Total Income" "Total Expenses"
Replace-MeasureReference $expenseVisuals[2] "Consumption Expenses" "Fixed Expenses"
Replace-MeasureReference $expenseVisuals[3] "Total Saved" "Variable Expenses"
Replace-MeasureReference $expenseVisuals[4] "True Savings Rate" "Wants Expenses %"
Replace-MeasureReference $expenseVisuals[5] "Total Income" "Total Expenses"
Replace-MeasureReference $expenseVisuals[5] "Consumption Expenses" "Fixed Expenses"
Replace-MeasureReference $expenseVisuals[5] "Total Saved" "Variable Expenses"
Replace-MeasureReference $expenseVisuals[6] "Consumption Expenses" "Total Expenses"
Replace-MeasureReference $expenseVisuals[7] "Consumption Expenses" "Total Expenses"

Set-VisualPosition $expenseVisuals[0] 250 28 990 58 10
Set-VisualPosition $expenseVisuals[1] 250 108 230 96 11
Set-VisualPosition $expenseVisuals[2] 500 108 230 96 12
Set-VisualPosition $expenseVisuals[3] 750 108 230 96 13
Set-VisualPosition $expenseVisuals[4] 1000 108 240 96 14
Set-VisualPosition $expenseVisuals[5] 810 235 430 210 15
Set-VisualPosition $expenseVisuals[6] 250 235 315 210 16
Set-VisualPosition $expenseVisuals[7] 250 465 990 220 17
Set-VisualPosition $expenseVisuals[8] 590 235 195 95 18
Set-VisualPosition $expenseVisuals[9] 590 350 195 95 19

$expense.visualContainers = @($expenseVisuals)
Add-DesignShell $expense "Expense Analysis" "Expense structure, budget usage and optimization priorities"

$layout.sections = @(
    $executive
    $expense
    @($layout.sections | Where-Object { $_.displayName -notin @("Executive Overview", "Expense Analysis") })
) | Where-Object { $null -ne $_ }

$layout.config = ($layout.config | ConvertFrom-Json | ConvertTo-Json -Depth 100 -Compress)
$newLayoutText = ConvertTo-CompressedJson $layout
$newLayoutBytes = [System.Text.Encoding]::Unicode.GetBytes($newLayoutText)
$newThemeBytes = [System.Text.Encoding]::UTF8.GetBytes($themeJson)

$tempPath = "$resolvedPbix.tmp"
if (Test-Path $tempPath) {
    Remove-Item -LiteralPath $tempPath -Force
}

$outZip = [System.IO.Compression.ZipFile]::Open($tempPath, [System.IO.Compression.ZipArchiveMode]::Create)
try {
    foreach ($entryInfo in $entries) {
        $entry = $outZip.CreateEntry($entryInfo.Name, [System.IO.Compression.CompressionLevel]::Optimal)
        $stream = $entry.Open()
        try {
            if ($entryInfo.Name -eq "Report/Layout") {
                $stream.Write($newLayoutBytes, 0, $newLayoutBytes.Length)
            } elseif ($entryInfo.Name -eq "Report/StaticResources/SharedResources/BaseThemes/CY25SU11.json") {
                $stream.Write($newThemeBytes, 0, $newThemeBytes.Length)
            } else {
                $bytes = $entryInfo.Bytes
                $stream.Write($bytes, 0, $bytes.Length)
            }
        }
        finally {
            $stream.Dispose()
        }
    }
}
finally {
    $outZip.Dispose()
}

Copy-Item -LiteralPath $tempPath -Destination $resolvedPbix -Force
Remove-Item -LiteralPath $tempPath -Force
Write-Host "Updated $PbixPath"
