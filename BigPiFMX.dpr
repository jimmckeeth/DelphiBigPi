program BigPiFMX;

uses
  System.StartUpCopy,
  FMX.Forms,
  BigPiFMXMain in 'BigPiFMXMain.pas' {BigPiGui},
  BigPi in 'BigPi.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TBigPiGui, BigPiGui);
  Application.Run;
end.
