codeunit 50140 "Install Codeunit"
{
    Subtype = Install;

    trigger OnInstallAppPerCompany()
    var
        CALTestSuite: Record "CAL Test Suite";
        AllObjWithCaption: Record AllObjWithCaption;
    begin
        if not CALTestSuite.Get('DEFAULT') then
            CreateNewSuite('DEFAULT');

        AllObjWithCaption.SetRange("Object Type", AllObjWithCaption."Object Type"::Codeunit);
        AllObjWithCaption.SetFilter("Object ID", '50100..50140');
        AllObjWithCaption.SetRange("Object Subtype", 'Test');
        if AllObjWithCaption.FindSet() then
            repeat
                CreateCodeunit(AllObjWithCaption."Object ID", 'DEFAULT');
            until AllObjWithCaption.Next() = 0;

    end;

    local procedure CreateNewSuite(NewSuiteName: Code[10])
    var
        CALTestSuite: Record "CAL Test Suite";
    begin
        CALTestSuite.Init();
        CALTestSuite.Validate(Name, NewSuiteName);
        CALTestSuite.Validate(Description, NewSuiteName);
        CALTestSuite.Validate(Export, false);
        CALTestSuite.Insert(true);
    end;

    local procedure CreateCodeunit(CodeunitId: Integer; SuiteName: Code[10])
    var
        CALTestLine: Record "CAL Test Line";
        LineNo: Integer;
    begin
        CALTestLine.SetRange("Test Suite", SuiteName);
        if CALTestLine.FindLast() then
            LineNo := CALTestLine."Line No." + 10000
        else
            LineNo := 10000;

        CALTestLine.Init();
        CALTestLine.Validate("Test Suite", SuiteName);
        CALTestLine.Validate("Line No.", LineNo);
        CALTestLine.Validate("Line Type", CALTestLine."Line Type"::Codeunit);
        CALTestLine.Validate("Test Codeunit", CodeunitId);
        CALTestLine.Validate(Run, true);
        CALTestLine.Insert(true);
        Codeunit.Run(Codeunit::"CAL Test Runner", CALTestLine);

    end;
}