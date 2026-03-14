{===============================================

 Delphi Pi — Computing Pi in Delphi
 https://github.com/jimmckeeth/DelphiPi

 Licensed under GNU General Public License v3.0 (GPLv3)
 Copyright © 2025 Jim McKeeth

 Uses Rudy's Big Numbers Library (BSD 2-Clause)
 https://github.com/TurboPack/RudysBigNumbers

================================================}
unit BigPiFMXMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants, FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics,
  FMX.Dialogs, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Edit,
  FMX.Memo.Types, FMX.ScrollBox, FMX.Memo, FMX.EditBox, FMX.SpinBox,
  FMX.Layouts, FMX.Objects, System.Skia, FMX.Skia,
  ThreadedCharacterQueue;

type
  TBigPiGui = class(TForm)
    Label1: TLabel;
    piMemo: TMemo;
    delayTrackBar: TTrackBar;
    ScaledLayout1: TScaledLayout;
    delayLabel: TLabel;
    labelCount: TLabel;
    Label2: TLabel;
    Layout1: TLayout;
    Layout2: TLayout;
    captionLabel: TLabel;
    StyleBook1: TStyleBook;
    labelDigit: TLabel;
    UpdateTimer: TTimer;
    procedure FormShow(Sender: TObject);
    function GetDelay: Double;
    procedure delayTrackBarChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure UpdateTimerTimer(Sender: TObject);
    procedure Label1Click(Sender: TObject);
  private
    { Private declarations }
    background: TThread;
    lastCount: UInt64;
    fQueue: TCharacterQueue;
  public
    { Public declarations }
  end;

var
  BigPiGui: TBigPiGui;

implementation

{$R *.fmx}

uses
  FMX.Text, BigPi;

procedure TBigPiGui.FormCreate(Sender: TObject);
begin
  lastCount := 0;
  labelDigit.Text := '';
  fQueue := TCharacterQueue.Create(10000);
end;

procedure TBigPiGui.FormDestroy(Sender: TObject);
begin
  fQueue.Shutdown;      // unblocks EnqueueBatch if the producer is waiting
  background.Terminate;
  fQueue.Free;
end;

procedure TBigPiGui.FormShow(Sender: TObject);
begin
  captionLabel.Text := Caption;
  captionLabel.Visible := True;

  background := TThread.CreateAnonymousThread(
    procedure begin
      try
        while not TThread.CheckTerminated do
        begin
          var FFirstChunk := True;

          BBPpi(MaxInt-1, procedure(chunk: TDigits)
            begin
              if TThread.CheckTerminated then
                Exit;

              var Digits := DigitsToString(Chunk);

              if FFirstChunk then
              begin
                Digits := Digits.Insert(1, '.');
                FFirstChunk := False;
              end;

              fQueue.EnqueueBatch(Digits);
            end
          );
        end;
      except
        on EQueueShutdown do
          ; // shutdown requested; thread exits normally
      end;
    end);
  background.Start;
  UpdateTimer.Enabled := True;
end;

function TBigPiGui.GetDelay: Double;
begin
  Result := 1;
  if Application.Terminated then Exit;
  Result := delayTrackBar.Value;
end;

procedure TBigPiGui.Label1Click(Sender: TObject);
begin
  UpdateTimer.Enabled := True;
end;

procedure TBigPiGui.UpdateTimerTimer(Sender: TObject);
var
  digit: Char;
begin
  if FQueue.Count > 0 then
  begin
    UpdateTimer.Enabled := False;
    try
      digit := FQueue.DequeueChar;
    except
      on EQueueShutdown do
        Exit; // leave timer disabled; queue is shutting down
    end;

    if Application.Terminated then
      Exit;

    if not Assigned(Application.MainForm) then
      Exit;

    Inc(lastCount);

    labelCount.Text := Format('%.0n', [lastCount + 0.0]);
    labelDigit.Text := digit;
    piMemo.GoToTextEnd;
    piMemo.InsertAfter(piMemo.CaretPosition, digit, [TInsertOption.MoveCaret]);
    piMemo.Repaint;
    UpdateTimer.Enabled := True;
  end;
end;

procedure TBigPiGui.delayTrackBarChange(Sender: TObject);
begin
  if delayTrackBar.Value < delayTrackBar.Max / 2 then
    delayLabel.Align := TAlignLayout.Right
  else
    delayLabel.Align := TAlignLayout.Left;
  UpdateTimer.Enabled := False;
  UpdateTimer.Interval := Trunc(delayTrackBar.Value * 10);
  UpdateTimer.Enabled := True;
end;

end.
