Function Format-AkamaiRule {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory)]
        [PSCustomObject]
        $Rule,

        [Parameter(Mandatory)]
        [String[]]
        $AllowedBehaviors,

        [Parameter(Mandatory)]
        [String[]]
        $AllowedCriteria
    )

    if ($Rule.criteria) {
        $Rule.criteria = @($Rule.criteria | Where-Object name -in $AllowedCriteria)
    }
    if ($Rule.behaviors) {
        $Rule.behaviors = @($Rule.behaviors | Where-Object name -in $AllowedBehaviors)
    }
    foreach ($Child in $Rule.children) {
        $Child = Format-AkamaiRule -Rule $Child -AllowedBehaviors $AllowedBehaviors -AllowedCriteria $AllowedCriteria
    }

    return $Rule
}