page 86212 "MNB Partner Config Setup"
{
    ApplicationArea = All;
    Caption = 'Partner Configuration Setup';
    PageType = Card;
    SourceTable = "MNB Partner Config. Setup";
    InsertAllowed = false;
    DeleteAllowed = false;
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';

                field("Azure Account Name"; Rec."Azure Account Name")
                {
                    ToolTip = 'Specifies the value of the Azure Account Name field.';
                    trigger OnValidate()
                    begin
                        CurrPage.Update(true);
                    end;
                }
                field("Storage Key"; Rec."Storage Key")
                {
                    ToolTip = 'Specifies the value of the Storage Key field.';
                    trigger OnValidate()
                    begin
                        CurrPage.Update(true);
                    end;
                }
                field("Container Name"; Rec."Container Name")
                {
                    ToolTip = 'Specifies the value of the Container Name field.';
                    trigger OnValidate()
                    begin
                        CurrPage.Update(true);
                    end;
                }
                field("Setup List File"; Rec."Setup List File")
                {
                    ToolTip = 'Specifies the value of the Setup List File field.';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(SetConfigurationFile)
            {
                Caption = 'Set Configuration File';
                Image = Setup;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Update the configuration setup.';

                trigger OnAction()
                var
                    MNBConfigPackImport: Codeunit "MNB Config Pack. Import";
                begin
                    Rec."Setup List File" := MNBConfigPackImport.SetConfigurationFilePath();
                end;
            }
        }
    }
    trigger OnOpenPage()
    begin
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
        end;
    end;
}
