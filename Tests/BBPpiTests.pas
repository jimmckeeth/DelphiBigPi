unit BBPpiTests;

interface

uses
  System.SysUtils,
  BigPiHashTestCaseProvider,
  DUnitX.TestFramework;

type
  [TestFixture]
  BBPpiTest = class
  public
    [Test(True)]
    [TestCaseProvider(TPiHashProvider)]
    procedure HashCheck(const Digits : Integer;const Hash : String);
    [Test]
    procedure Check1000Digits();
  end;

implementation

uses IOUtils, BigPi, Hash, BigPiTestsCommon;

{ BBPpiTest }

procedure BBPpiTest.Check1000Digits;
begin
  var calcPi := DigitsToString(BBPpi(1000));
  var readPi := TFile.ReadAllText(TPath.Combine(TestDataFolder,'pi-100k.txt'));
  for var idx := 1 to Length(calcPi) do
     Assert.AreEqual(readPi[idx], calcPi[idx], Format('Incorrect digit # %d with BBPpi: %s',[idx, calcPi]));
end;

procedure BBPpiTest.HashCheck(const Digits: Integer; const Hash: String);
begin
  if digits > 10000 then exit;

  var pi := DigitsToString(BBPpi(Digits));
  // one more digit for the decimal point
  Assert.AreEqual(Succ(Digits), length(pi));
  var calcHash := THashMD5.GetHashString(pi);
  Assert.AreEqual(hash, calcHash, Format('Incorrect hash for %d digits with BBPpi. ',[digits]))
end;

end.
