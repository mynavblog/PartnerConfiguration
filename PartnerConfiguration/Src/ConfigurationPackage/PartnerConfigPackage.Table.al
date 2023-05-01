table 86210 "MNB Partner Config. Package"
{
    Caption = 'Partner Configuration Package';
    DataClassification = SystemMetadata;
    LookupPageId = "MNB Partner Config. Packages";
    DrillDownPageId = "MNB Partner Config. Packages";
    fields
    {
        field(1; "Package Code"; Code[20])
        {
            Caption = 'Package Code';
            DataClassification = SystemMetadata;
        }
        field(2; "Package Name"; Text[100])
        {
            Caption = 'Package Name';
            DataClassification = SystemMetadata;
        }
        field(3; "Package Description"; Text[250])
        {
            Caption = 'Package Description';
            DataClassification = SystemMetadata;
        }
        field(4; "Package Language"; Code[10])
        {
            Caption = 'Package Language';
            DataClassification = SystemMetadata;
            TableRelation = "Language";
        }
    }
    keys
    {
        key(Key1; "Package Code")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown; "Package Code", "Package Description", "Package Language") { }
    }
}

