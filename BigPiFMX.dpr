{===============================================

 Delphi Pi — Computing Pi in Delphi
 https://github.com/jimmckeeth/DelphiPi

 Licensed under GNU General Public License v3.0 (GPLv3)
 Copyright © 2025 Jim McKeeth

 Uses Rudy's Big Numbers Library (BSD 2-Clause)
 https://github.com/TurboPack/RudysBigNumbers

================================================}
program BigPiFMX;

uses
  System.StartUpCopy,
  FMX.Forms,
  FMX.Skia,
  BigPiFMXMain in 'BigPiFMXMain.pas' {BigPiGui},
  BigPi in 'BigPi.pas',
  ThreadedCharacterQueue in 'ThreadedCharacterQueue.pas';

{$R *.res}

begin
  GlobalUseSkia := True;
  Application.Initialize;
  Application.CreateForm(TBigPiGui, BigPiGui);
  Application.Run;
end.
