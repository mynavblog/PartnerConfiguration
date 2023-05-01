page 86211 "MNB Partner Config. Packages"
{
    ApplicationArea = All;
    Caption = 'Partner Configuration Packages';
    PageType = List;
    SourceTable = "MNB Partner Config. Package";
    UsageCategory = None;
    Editable = false;
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Package Code"; Rec."Package Code")
                {
                    ToolTip = 'Specifies the value of the Package Code field.';
                }
                field("Package Description"; Rec."Package Description")
                {
                    ToolTip = 'Specifies the value of the Package Description field.';
                }
                field("Package Name"; Rec."Package Name")
                {
                    ToolTip = 'Specifies the value of the Package Name field.';
                }
                field("Package Language"; Rec."Package Language")
                {
                    ToolTip = 'Specifies the value of the Package Language field.';
                }
            }
        }
    }
}
