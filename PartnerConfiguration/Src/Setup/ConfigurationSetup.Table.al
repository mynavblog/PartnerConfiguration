table 86211 "MNB Partner Config. Setup"
{
    DataClassification = SystemMetadata;
    Caption = 'Partner Configuration Setup';

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            DataClassification = SystemMetadata;
            Caption = 'Primary Key';
        }
        field(3; "Container Name"; Text[250])
        {
            Caption = 'Container Name';
            DataClassification = SystemMetadata;
        }
        field(4; "Azure Account Name"; Text[250])
        {
            Caption = 'Azure Account Name';
            DataClassification = SystemMetadata;
        }
        field(5; "Storage Key"; Text[1024])
        {
            Caption = 'Storage Key';
            DataClassification = SystemMetadata;
            ExtendedDatatype = Masked;
        }
        field(6; "Setup List File"; Text[250])
        {
            Caption = 'Setup List File';
            DataClassification = SystemMetadata;
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }
}