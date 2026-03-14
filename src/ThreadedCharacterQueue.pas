{===============================================

 Delphi Pi — Computing Pi in Delphi
 https://github.com/jimmckeeth/DelphiPi

 Licensed under GNU General Public License v3.0 (GPLv3)
 Copyright © 2025 Jim McKeeth

 Uses Rudy's Big Numbers Library (BSD 2-Clause)
 https://github.com/TurboPack/RudysBigNumbers

================================================}
unit ThreadedCharacterQueue;

interface

uses
  System.SysUtils, System.Classes, System.Generics.Collections, System.SyncObjs;

const
  /// <summary>
  /// Milliseconds each blocking wait will hold before raising EQueueShutdown.
  /// Normal operation should never reach this limit; it exists as a safety net
  /// so that a dead producer or consumer does not hang the application forever.
  /// </summary>
  CQueueWaitTimeout = 5000;

type
  EQueueShutdown = class(Exception);

  TCharacterQueue = class
  private
    FQueue: TQueue<Char>;
    FLock: TCriticalSection;
    FNotEmptyEvent: TEvent;
    FNotFullEvent: TEvent;
    FThreshold: Integer;
    FShutdown: Boolean;
  public
    constructor Create(AThreshold: Integer);
    destructor Destroy; override;

    /// <summary>
    /// Signals the queue to shut down, immediately unblocking any waiting threads.
    /// </summary>
    /// <remarks>
    /// After Shutdown is called, EnqueueBatch and DequeueChar raise EQueueShutdown
    /// whether they are currently blocking or are called again afterwards.
    /// </remarks>
    procedure Shutdown;

    /// <summary>
    /// Adds a batch of characters to the queue.
    /// </summary>
    /// <param name="ABatch">The batch of characters to add to the queue.</param>
    /// <remarks>
    /// Blocks if the queue is at or above the threshold. Raises EQueueShutdown
    /// if Shutdown has been called or CQueueWaitTimeout ms elapses while waiting.
    /// If ABatch contains more characters than FThreshold - FQueue.Count, the queue
    /// may briefly exceed FThreshold by up to Length(ABatch) - 1; this is an accepted
    /// trade-off for bulk-enqueue.
    /// </remarks>
    procedure EnqueueBatch(const ABatch: string);

    /// <summary>
    /// Retrieves the next character from the queue.
    /// </summary>
    /// <returns>The character retrieved from the queue.</returns>
    /// <remarks>
    /// Blocks if the queue is empty. Raises EQueueShutdown if Shutdown has been
    /// called or CQueueWaitTimeout ms elapses while waiting.
    /// </remarks>
    function DequeueChar: Char;

    /// <summary>
    /// Gets the current size of the queue without blocking.
    /// </summary>
    /// <returns>Returns the number of characters currently in the queue.</returns>
    function Count: Integer;
  end;

implementation

constructor TCharacterQueue.Create(AThreshold: Integer);
begin
  inherited Create;
  FQueue := TQueue<Char>.Create;
  FLock := TCriticalSection.Create;
  FNotEmptyEvent := TEvent.Create(nil, True, False, '');  // Manual reset
  FNotFullEvent := TEvent.Create(nil, True, True, '');    // Initially signaled
  FThreshold := AThreshold;
  FShutdown := False;
end;

destructor TCharacterQueue.Destroy;
begin
  FNotFullEvent.Free;
  FNotEmptyEvent.Free;
  FLock.Free;
  FQueue.Free;
  inherited;
end;

procedure TCharacterQueue.Shutdown;
begin
  FShutdown := True;
  // Signal both events so any thread blocked in WaitFor wakes immediately,
  // loops back, sees FShutdown = True, and raises EQueueShutdown.
  FNotEmptyEvent.SetEvent;
  FNotFullEvent.SetEvent;
end;

procedure TCharacterQueue.EnqueueBatch(const ABatch: string);
var
  C: Char;
begin
  while True do
  begin
    FLock.Acquire;
    try
      if FShutdown then
        raise EQueueShutdown.Create('Queue is shutting down');
      if FQueue.Count < FThreshold then
      begin
        for C in ABatch do
          FQueue.Enqueue(C);
        FNotEmptyEvent.SetEvent;
        if FQueue.Count >= FThreshold then
          FNotFullEvent.ResetEvent;
        Exit;
      end;
    finally
      FLock.Release;
    end;
    if FNotFullEvent.WaitFor(CQueueWaitTimeout) <> wrSignaled then
      raise EQueueShutdown.Create('Timed out waiting for queue space');
  end;
end;

function TCharacterQueue.DequeueChar: Char;
begin
  while True do
  begin
    FLock.Acquire;
    try
      if FShutdown then
        raise EQueueShutdown.Create('Queue is shutting down');
      if FQueue.Count > 0 then
      begin
        Result := FQueue.Dequeue;
        if FQueue.Count = 0 then
          FNotEmptyEvent.ResetEvent;
        if FQueue.Count = FThreshold - 1 then
          FNotFullEvent.SetEvent;
        Exit;
      end;
    finally
      FLock.Release;
    end;
    if FNotEmptyEvent.WaitFor(CQueueWaitTimeout) <> wrSignaled then
      raise EQueueShutdown.Create('Timed out waiting for queue data');
  end;
end;

function TCharacterQueue.Count: Integer;
begin
  FLock.Acquire;
  try
    Result := FQueue.Count;
  finally
    FLock.Release;
  end;
end;

end.
