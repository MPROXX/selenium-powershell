function Get-SeInput {
    [CmdletBinding()]
    param(
        [ArgumentCompleter( { @('button', 'checkbox', 'color', 'date', 'datetime-local', 'email', 'file', 'hidden', 'image', 'month', 'number', 'password', 'radio', 'range', 'reset', 'search', 'submit', 'tel', 'text', 'time', 'url', 'week') })]
        [String]$Type,
        [Switch]$Single,
        [String]$Text,
        [Double]$Timeout,
        [Switch]$All,
        [String[]]$Attributes,
        [String]$Value

    
    )
    Begin {
        $Driver = Init-SeDriver -ErrorAction Stop
    }
    Process {
        $MyAttributes = @{}
        $SelectedAttribute = ""
        Filter ConditionFilter($Type, $Text, $Value, $Attribute) {
            if ("" -ne $Type) { if ($_.Attributes.type -ne $type) { return } }
            if ("" -ne $Text) { if ($_.Text -ne $Text ) { return } }
            if ("" -ne $Value -and "" -ne $Attribute) { if ($_.Attributes.$Attribute -ne $Value ) { return } }
            $_
        }

        if ($PSBoundParameters.Remove('Attributes')) {
            $MyAttributes = @{Attributes = [System.Collections.Generic.List[String]]$Attributes }
            if ($Attributes[0] -ne '*') { $SelectedAttribute = $MyAttributes.Attributes[0] }
        }
        if ($PSBoundParameters.Remove('Type')) {
            if ($null -eq $Attributes) {
                $MyAttributes = @{Attributes = 'type' }
            }
            else {
                if (-not $Attributes.contains('type') -and -not $Attributes.contains('*')) {
                    $MyAttributes.Attributes.add('type') 
                }
            }

            
        }
        [void]($PSBoundParameters.Remove('Value'))
        Get-SeElement -By TagName -Value input @PSBoundParameters @MyAttributes | ConditionFilter -Type $Type -Text $Text -Value $Value -Attribute $SelectedAttribute
    }
}

