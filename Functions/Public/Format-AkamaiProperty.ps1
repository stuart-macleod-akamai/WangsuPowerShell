function Format-AkamaiProperty {
    Param(
        [Parameter(Mandatory)]
        [PSCustomObject]
        $Property,

        [Parameter(Mandatory)]
        [String[]]
        $AllowedBehaviors,

        [Parameter(Mandatory)]
        [String[]]
        $AllowedCriteria
    )

    $ConvertedProperty = Format-AkamaiRule -Rule $Property.rules -AllowedBehaviors $AllowedBehaviors -AllowedCriteria $AllowedCriteria
    return $ConvertedProperty
}