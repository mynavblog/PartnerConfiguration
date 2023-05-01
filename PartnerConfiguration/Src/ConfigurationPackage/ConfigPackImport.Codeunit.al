codeunit 86210 "MNB Config Pack. Import"
{
    internal procedure SetConfigurationFilePath(): Text
    var
        ABSContainerContent: Record "ABS Container Content";
        PartnerConfigSetup: Record "MNB Partner Config. Setup";
        ABSBlobClient: Codeunit "ABS Blob Client";
        StorageServiceAuthorization: Codeunit "Storage Service Authorization";
        Authorization: Interface "Storage Service Authorization";
    begin
        GetAndTestSetup(PartnerConfigSetup);
        Authorization := StorageServiceAuthorization.CreateSharedKey(PartnerConfigSetup."Storage Key");
        ABSBlobClient.Initialize(PartnerConfigSetup."Azure Account Name", PartnerConfigSetup."Container Name", Authorization);
        ABSBlobClient.ListBlobs(ABSContainerContent);
        if Page.RunModal(Page::"MNB Container Content", ABSContainerContent) = Action::LookupOK then
            exit(ABSContainerContent."Full Name")
        else
            Error('');
    end;

    internal procedure ImportConfigurationFile()
    var
        JSONConfigList: Record "JSON Buffer" temporary;
        JSONConfigurationFile: Record "JSON Buffer" temporary;
        PartnerConfigPackage: Record "MNB Partner Config. Package";
        PartnerConfigSetup: Record "MNB Partner Config. Setup";
        ABSBlobClient: Codeunit "ABS Blob Client";
        StorageServiceAuthorization: Codeunit "Storage Service Authorization";
        Authorization: Interface "Storage Service Authorization";
        ConfigurationFileContent: Text;
        JsonPropertyTxt: Text;
    begin
        GetAndTestSetup(PartnerConfigSetup);
        Authorization := StorageServiceAuthorization.CreateSharedKey(PartnerConfigSetup."Storage Key");
        ABSBlobClient.Initialize(PartnerConfigSetup."Azure Account Name", PartnerConfigSetup."Container Name", Authorization);
        ABSBlobClient.GetBlobAsText(PartnerConfigSetup."Setup List File", ConfigurationFileContent);
        JSONConfigurationFile.ReadFromText(ConfigurationFileContent);
        JSONConfigurationFile.FindArray(JSONConfigList, 'config');
        PartnerConfigPackage.DeleteAll();
        if JSONConfigList.FindSet() then
            repeat
                PartnerConfigPackage.Init();
                JSONConfigList.GetPropertyValue(JsonPropertyTxt, 'Code');
                PartnerConfigPackage."Package Code" := JsonPropertyTxt;
                JSONConfigList.GetPropertyValue(JsonPropertyTxt, 'Name');
                PartnerConfigPackage."Package Name" := JsonPropertyTxt;
                JSONConfigList.GetPropertyValue(PartnerConfigPackage."Package Description", 'Description');
                JSONConfigList.GetPropertyValue(JsonPropertyTxt, 'Language');
                PartnerConfigPackage."Package Language" := JsonPropertyTxt;
                PartnerConfigPackage.Insert(true);
            until JSONConfigList.Next() = 0;
    end;

    internal procedure ImportPackage(ConfigurationPackageCode: Code[20])
    var
        PartnerConfigPackage: Record "MNB Partner Config. Package";
        PartnerConfigSetup: Record "MNB Partner Config. Setup";
        ABSBlobClient: Codeunit "ABS Blob Client";
        ConfigPackageImport: Codeunit "Config. Package - Import";
        StorageServiceAuthorization: Codeunit "Storage Service Authorization";
        TempBlob: Codeunit "Temp Blob";
        PackageInStream: InStream;
        Authorization: Interface "Storage Service Authorization";
        ConfigurationHasBeenImportedAndApplyMsg: Label 'Configuration %1 has been imported and applied.', Comment = '%1 - package code';
        PackageCodeMustHaveValueErr: Label 'Package Code must have value.';
        OutStream: OutStream;
    begin
        if ConfigurationPackageCode = '' then
            Error(PackageCodeMustHaveValueErr);
        GetAndTestSetup(PartnerConfigSetup);
        PartnerConfigPackage.Get(ConfigurationPackageCode);
        Authorization := StorageServiceAuthorization.CreateSharedKey(PartnerConfigSetup."Storage Key");
        ABSBlobClient.Initialize(PartnerConfigSetup."Azure Account Name", PartnerConfigSetup."Container Name", Authorization);
        ABSBlobClient.GetBlobAsStream(StrSubstNo('%1.rapidstart', PartnerConfigPackage."Package Name"), PackageInStream);
        TempBlob.CreateOutStream(OutStream);
        CopyStream(OutStream, PackageInStream);
        ConfigPackageImport.ImportAndApplyRapidStartPackageStream(TempBlob);
        Message(ConfigurationHasBeenImportedAndApplyMsg, ConfigurationPackageCode);
    end;

    local procedure GetAndTestSetup(var ConfigurationSetup: Record "MNB Partner Config. Setup")
    begin
        ConfigurationSetup.Get();
        ConfigurationSetup.TestField("Azure Account Name");
        ConfigurationSetup.TestField("Container Name");
        ConfigurationSetup.TestField("Storage Key");
    end;
}