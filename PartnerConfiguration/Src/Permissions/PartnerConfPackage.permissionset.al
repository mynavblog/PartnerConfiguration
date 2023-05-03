permissionset 86210 MNBPartnerConfWizard
{
    Caption = 'Partner Configuration Wizard';
    Assignable = true;
    Permissions = tabledata "MNB Partner Config. Package" = RIMD,
        tabledata "MNB Partner Config. Setup" = RIMD,
        table "MNB Partner Config. Package" = X,
        table "MNB Partner Config. Setup" = X,
        codeunit "MNB Config Pack. Import" = X,
        page "MNB Partner Config. Packages" = X,
        page "MNB Partner Config Setup" = X,
        page "MNB Partner Configuration" = X,
        page "MNB Container Content" = X;
}