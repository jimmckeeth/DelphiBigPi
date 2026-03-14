{===============================================

 Delphi Big Pi — Computing Pi in Delphi
 https://github.com/jimmckeeth/DelphiPi

 Licensed under GNU General Public License v3.0 (GPLv3)
 Copyright © 2023-2026 by James McKeeth

 Uses Rudy's Big Numbers Library (BSD 2-Clause)
 https://github.com/TurboPack/RudysBigNumbers

================================================}
unit BigPiHashTestCaseProvider;

interface

uses
  System.SysUtils,
  System.Generics.Collections,
  DUnitX.Types,
  DUnitX.InternalDataProvider,
  DUnitX.TestDataProvider,
  DUnitX.TestFramework;

type
  TPiHash = record
    Digits: UInt64;
    Hash: string;
  end;

  TPiHashProvider = Class(TTestDataProvider)
  private
    fHashes: TList<TPiHash>;
  public
    constructor Create; override;
    //Get the amount of cases we are creating
    function GetCaseCount(const methodName: string): Integer; override;
    //Get the name of the cases, depending on the Test-Function
    function GetCaseName(const methodName: string; const caseNumber: Integer): string; override;
    //Get the Params for calling the Test-Function;Be aware of the order !
    function GetCaseParams(const methodName: string; const caseNumber: Integer): TValuearray; override;
    //Cleanup the instance
    Destructor Destroy; override;
  end;

implementation

{ TPiHashProvider }

const
  CPiHashes: array[0..18] of TPiHash = (
    (Digits: 100;   Hash: '656c1ee50d1fa9de3b77d72b22641ceb'),
    (Digits: 200;   Hash: '5b47d4ae95e6b89f2fbaf581dc8d83ee'),
    (Digits: 300;   Hash: '80e07948a64ca612ffa291929523d95c'),
    (Digits: 400;   Hash: '9f4707f438d862ebf6cfbea492d5ccae'),
    (Digits: 500;   Hash: '8ee121e867aa81bf5c71bd1787c82e25'),
    (Digits: 600;   Hash: '12e9de29b35a4498ad57972f96ed4c2c'),
    (Digits: 700;   Hash: '881cb72991bdaa9fb9cc46aa8746e021'),
    (Digits: 800;   Hash: '52aeaedaa2100355daa554249252f074'),
    (Digits: 900;   Hash: '172e1c3653fe98db500604846085314d'),
    (Digits: 1000;  Hash: 'f2ec976ae2ff84cbda86ded841c8edfa'),
    (Digits: 2000;  Hash: '01581df247f9f4782a042fba44bef514'),
    (Digits: 3000;  Hash: '27fcccc6df1cd3b500d36f9990c822cc'),
    (Digits: 4000;  Hash: '9d68c2f031bcdbcc6bafbcf6a9017b83'),
    (Digits: 5000;  Hash: '83368903d4f836fa39450208f1ea8179'),
    (Digits: 6000;  Hash: '9c61b02bde8e907dfe0bbb6c2e2439c7'),
    (Digits: 7000;  Hash: 'af03629d1ff1a0aae773a5ecb490c3a1'),
    (Digits: 8000;  Hash: '3d0efaf1c2118a8fab40bcf60883c7b4'),
    (Digits: 9000;  Hash: 'de2483c64a995b9a29a6608e19e85c9a'),
    (Digits: 10000; Hash: 'fceb6f18bfb443fd5bcaa1dd97041ca8')
  );

constructor TPiHashProvider.Create;
begin
  inherited;
  fHashes := TList<TPiHash>.Create;
  // This will only run the quicker tests
  for var i := 0 to Pred(Length(CPiHashes) div 2) do
    fHashes.Add(CPiHashes[i]);
end;

destructor TPiHashProvider.Destroy;
begin
  fHashes.Free;
  inherited;
end;

function TPiHashProvider.GetCaseCount(const methodName: string): Integer;
begin
  Result := fHashes.Count;
end;

function TPiHashProvider.GetCaseName(const methodName: string;
  const caseNumber: Integer): string;
begin
  Result := Format('Calculate %d digits', [fHashes[caseNumber].Digits]);
end;

function TPiHashProvider.GetCaseParams(const methodName: string;
  const caseNumber: Integer): TValuearray;
begin
  SetLength(Result, 2);

  Result[0] := fHashes[caseNumber].Digits;
  Result[1] := fHashes[caseNumber].Hash;
end;

initialization
  TestDataProviderManager.RegisterProvider('PiHashProvider',TPiHashProvider);

end.
