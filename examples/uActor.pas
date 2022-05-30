{==============================================================================
   ___              __   ___    _
  / __|__ _ _ __  __\ \ / (_)__(_)___ _ _
 | (_ / _` | '  \/ -_) V /| (_-< / _ \ ' \
  \___\__,_|_|_|_\___|\_/ |_/__/_\___/_||_|
                  Toolkit™

 Copyright © 2022 tinyBigGAMES™ LLC
 All Rights Reserved.

 Website: https://tinybiggames.com
 Email  : support@tinybiggames.com

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

1. The origin of this software must not be misrepresented; you must not
   claim that you wrote the original software. If you use this software in
   a product, an acknowledgment in the product documentation would be
   appreciated but is not required.

2. Redistributions of source code must retain the above copyright
   notice, this list of conditions and the following disclaimer.

3. Redistributions in binary form must reproduce the above copyright
   notice, this list of conditions and the following disclaimer in
   the documentation and/or other materials provided with the
   distribution.

4. Neither the name of the copyright holder nor the names of its
   contributors may be used to endorse or promote products derived
   from this software without specific prior written permission.

5. All video, audio, graphics and other content accessed through the
   software in this distro is the property of the applicable content owner
   and may be protected by applicable copyright law. This License gives
   Customer no rights to such content, and Company disclaims any liability
   for misuse of content.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
POSSIBILITY OF SUCH DAMAGE.
============================================================================= }

unit uActor;

interface

uses
  System.SysUtils,
  GameVision.Actor,
  GameVision.Color,
  GameVision.Math,
  GameVision.Game,
  uCommon;

type
  { TMyActor }
  TMyActor = class(TGVActor)
  protected
    FPos: TGVVector;
    FRange: TGVRange;
    FSpeed: TGVVector;
    FColor: TGVColor;
    FSize: Integer;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure OnUpdate(aDeltaTime: Double); override;
    procedure OnRender; override;
  end;

  { TActor }
  TActor = class(TBaseExample)
  public
    procedure OnSetSettings(var aSettings: TGVGameSettings); override;
    procedure OnStartup; override;
    procedure OnShutdown; override;
    procedure OnUpdateFrame(aDeltaTime: Double); override;
    procedure OnRenderFrame; override;
    procedure OnRenderHUD; override;
    procedure Spawn;
  end;

implementation

uses
  GameVision.Common,
  GameVision.Input,
  GameVision.Core;

{ TAnActor }
constructor TMyActor.Create;
var
  LR,LG,LB: Byte;
begin
  inherited;

  FPos.Assign( GV.Math.RandomRange(0, GV.Game.Settings.WindowWidth-1), GV.Math.RandomRange(0, GV.Game.Settings.WindowHeight-1));

  FRange.MinX := 0;
  FRange.MinY := 0;

  FSize := GV.Math.RandomRange(25, 100);

  FRange.MaxX := (GV.Game.Settings.WindowWidth-1) - FSize;
  FRange.MaxY := (GV.Game.Settings.WindowHeight-1) - FSize;

  FSpeed.x := GV.Math.RandomRange(120, 120*3);
  FSpeed.y := GV.Math.RandomRange(120, 120*3);

  LR := GV.Math.RandomRange(1, 255);
  LG := GV.Math.RandomRange(1, 255);
  LB := GV.Math.RandomRange(1, 255);
  FColor.FromByte(LR,LG,LB,255);
end;

destructor TMyActor.Destroy;
begin
  inherited;
end;

procedure TMyActor.OnUpdate(aDeltaTime: Double);
begin
  // update horizontal movement
  FPos.x := FPos.x + (FSpeed.x * aDeltaTime);
  if (FPos.x < FRange.MinX) then
    begin
      FPos.x  := FRange.Minx;
      FSpeed.x := -FSpeed.x;
    end
  else if (FPos.x > FRange.Maxx) then
    begin
      FPos.x  := FRange.Maxx;
      FSpeed.x := -FSpeed.x;
    end;

  // update horizontal movement
  FPos.y := FPos.y + (FSpeed.y * aDeltaTime);
  if (FPos.y < FRange.Miny) then
    begin
      FPos.y  := FRange.Miny;
      FSpeed.y := -FSpeed.y;
    end
  else if (FPos.y > FRange.Maxy) then
    begin
      FPos.y  := FRange.Maxy;
      FSpeed.y := -FSpeed.y;
    end;
end;

procedure TMyActor.OnRender;
begin
  GV.Primitive.FilledRectangle(FPos.X, FPos.Y, FSize, FSize, FColor);
end;

{ TActor }
procedure TActor.OnSetSettings(var aSettings: TGVGameSettings);
begin
  inherited;
  aSettings.WindowTitle := 'GameVision - Actor';
  aSettings.WindowClearColor := BLACK;
end;

procedure TActor.OnStartup;
begin
  inherited;
end;

procedure TActor.OnShutdown;
begin
  inherited;
end;

procedure TActor.OnUpdateFrame(aDeltaTime: Double);
begin
  inherited;

  if GV.Input.KeyPressed(KEY_S) then
    Spawn;
end;

procedure TActor.OnRenderFrame;
begin
  inherited;
end;

procedure TActor.OnRenderHUD;
begin
  inherited;

  HudText(Font, GREEN,  haLeft, HudTextItem('S', 'Spawn actors'), []);
  HudText(Font, YELLOW, haLeft, HudTextItem('Count', '%d', ''), [Scene.Lists[0].Count]);
end;

procedure TActor.Spawn;
var
  LI, LCount: Integer;
begin
  Scene.ClearAll;
  LCount := GV.Math.RandomRange(3, 25);
  for LI := 1 to LCount do
    Scene.Lists[0].Add(TMyActor.Create);
end;

end.
