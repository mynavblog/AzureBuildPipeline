codeunit 50010 "MNB Test Install"
{
    Subtype = Install;


    trigger OnInstallAppPerCompany()
    var
        ALTestSuite: Record "AL Test Suite";
        TestMethodLine: Record "Test Method Line";
        AllObjWithCaption: Record AllObjWithCaption;
        TestSuiteMgt: Codeunit "Test Suite Mgt.";
        TestSuiteName: Code[10];
    begin
        TestSuiteName := 'DEFAULT';
        if not ALTestSuite.Get(TestSuiteName) then begin
            TestSuiteMgt.CreateTestSuite(TestSuiteName);
            ALTestSuite.Get(TestSuiteName);
        end else
            TestSuiteMgt.DeleteAllMethods(ALTestSuite);

        AllObjWithCaption.SetRange("Object Type", AllObjWithCaption."Object Type"::Codeunit);
        AllObjWithCaption.SetFilter("Object ID", '50000..60000'); //Put the proper range for test codeunits

        AllObjWithCaption.SetRange("Object Subtype", 'Test');
        if AllObjWithCaption.FindSet() then
            repeat
                TestSuiteMgt.GetTestMethods(ALTestSuite, AllObjWithCaption);
            until AllObjWithCaption.Next() = 0;

        // Run Tests from the test suite
        TestMethodLine.SetRange("Test Suite", TestSuiteName);
        TestSuiteMgt.RunSelectedTests(TestMethodLine);

    end;
}