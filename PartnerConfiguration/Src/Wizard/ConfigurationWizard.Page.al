page 86213 "MNB Partner Configuration"
{
    Caption = 'Partner Configuration';
    PageType = NavigatePage;
    SourceTable = "MNB Partner Config. Setup";
    UsageCategory = Administration;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(StandardBanner)
            {
                ShowCaption = false;
                Editable = false;
                Visible = TopBannerVisible and not FinishActionEnabled;
                field(MediaResourcesStandard; MediaResourcesStandard."Media Reference")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ShowCaption = false;
                }
            }
            group(FinishedBanner)
            {
                ShowCaption = false;
                Editable = false;
                Visible = TopBannerVisible and FinishActionEnabled;
                field(MediaResourcesDone; MediaResourcesDone."Media Reference")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ShowCaption = false;
                }
            }

            group(Step1)
            {
                Visible = Step1Visible;
                group("Welcome to PageName")
                {
                    Caption = 'Welcome to Partner''s Standard Configuration Setup';
                    group(Group18)
                    {
                        ShowCaption = false;
                        InstructionalText = 'Choose the configuration you want to import and apply.';
                    }
                    field(ConfigurationPackageField; ConfigurationPackageCode)
                    {
                        ApplicationArea = All;
                        Caption = 'Configuration Package';
                        ToolTip = 'Choose the configuration you want to import and apply.';
                        TableRelation = "MNB Partner Config. Package"."Package Code";
                    }
                }

            }
        }
    }
    actions
    {
        area(processing)
        {
            action(ImportCloseConfPack)
            {
                ApplicationArea = All;
                Caption = 'Import & Close';
                Image = Import;
                InFooterBar = true;
                trigger OnAction();
                begin
                    ImportConfigurationPackage();
                    FinishAction();
                end;
            }
            action(ImportConfPack)
            {
                ApplicationArea = All;
                Caption = 'Import';
                Image = Import;
                InFooterBar = true;
                trigger OnAction();
                begin
                    ImportConfigurationPackage();
                end;
            }

        }
    }

    trigger OnInit();
    begin
        LoadTopBanners();
    end;

    trigger OnOpenPage();
    begin
        Step := Step::Start;
        EnableControls();
        GetConfigurationSetupList();
    end;

    var
        MediaRepositoryDone: Record "Media Repository";
        MediaRepositoryStandard: Record "Media Repository";
        MediaResourcesDone: Record "Media Resources";
        MediaResourcesStandard: Record "Media Resources";
        BackActionEnabled: Boolean;
        FinishActionEnabled: Boolean;
        NextActionEnabled: Boolean;
        Step1Visible: Boolean;
        TopBannerVisible: Boolean;
        ConfigurationPackageCode: Code[20];
        Step: Option Start,Step2,Finish;

    local procedure EnableControls();
    begin
        ResetControls();

        case Step of
            Step::Start:
                ShowStep1();
        end;
    end;




    local procedure FinishAction();
    begin
        CurrPage.Close();
    end;

    local procedure ShowStep1();
    begin
        Step1Visible := true;

        FinishActionEnabled := false;
        BackActionEnabled := false;
    end;

    local procedure ResetControls();
    begin
        FinishActionEnabled := false;
        BackActionEnabled := true;
        NextActionEnabled := true;

        Step1Visible := false;
    end;

    local procedure LoadTopBanners();
    begin
        if MediaRepositoryStandard.Get('AssistedSetup-NoText-400px.png', Format(CurrentClientType())) and
            MediaRepositoryDone.Get('AssistedSetupDone-NoText-400px.png', Format(CurrentClientType()))
        then
            if MediaResourcesStandard.Get(MediaRepositoryStandard."Media Resources Ref") and
                MediaResourcesDone.Get(MediaRepositoryDone."Media Resources Ref")
        then
                TopBannerVisible := MediaResourcesDone."Media Reference".HasValue();
    end;

    local procedure GetConfigurationSetupList()
    var
        MNBConfigPackImport: Codeunit "MNB Config Pack. Import";
    begin
        MNBConfigPackImport.ImportConfigurationFile();
    end;

    local procedure ImportConfigurationPackage()
    var
        MNBConfigPackImport: Codeunit "MNB Config Pack. Import";
    begin
        MNBConfigPackImport.ImportPackage(ConfigurationPackageCode);
    end;

}