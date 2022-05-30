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

unit uCamera;

interface

uses
  System.SysUtils,
  GameVision.Math,
  GameVision.Color,
  GameVision.Camera,
  GameVision.Game,
  uCommon;

type
  { TCamera }
  TCamera = class(TBaseExample)
  const
     MAX_BUILDINGS = 100;
     SPEED = 60*3;
  protected
    FPlayer: TGVRectangle;
    FBuildings: array[0..MAX_BUILDINGS-1] of TGVRectangle;
    FBuildingColors: array[0..MAX_BUILDINGS-1] of TGVColor;
    FSpacing: Integer;
    FCamera: TGVCamera;
    LMouseWheel: Single;
    LLastMouseWheel: Single;
    FValue: TGVVector;
  public
    procedure OnSetSettings(var aSettings: TGVGameSettings); override;
    procedure OnStartup; override;
    procedure OnShutdown; override;
    procedure OnUpdateFrame(aDeltaTime: Double); override;
    procedure OnRenderFrame; override;
    procedure OnRenderHUD; override;
  end;

implementation

uses
  GameVision.Common,
  GameVision.Input,
  GameVision.Core;

{ TCamera }
procedure TCamera.OnSetSettings(var aSettings: TGVGameSettings);
begin
  inherited;
  aSettings.WindowTitle := 'GameVision - Camera';
  aSettings.WindowWidth := 800;
  aSettings.WindowHeight := 450;
  aSettings.WindowClearColor := WHITE2;
end;

procedure TCamera.OnStartup;
var
  I: Integer;
begin
  inherited;

  FPlayer.Assign(400, 280, 40, 40);

  FCamera := TGVCamera.Create;
  FCamera.Init(FPlayer.x, FPlayer.y, GV.Window.Width, GV.Window.Height);

  FSpacing := 0;

  for I := 0 to MAX_BUILDINGS-1 do
  begin
    FBuildings[i].width := GV.Math.RandomRange(50, 200);
    FBuildings[i].height := GV.Math.RandomRange(100, 800);
    FBuildings[i].y := GV.Window.Height - 150.0 - FBuildings[i].height;
    FBuildings[i].x := -6000.0 + FSpacing;
    FSpacing := FSpacing + Round(FBuildings[i].width);
    FBuildingColors[i].FromByte(GV.Math.RandomRange(200, 240), GV.Math.RandomRange(200, 240), GV.Math.RandomRange(200, 250), 255 );
  end;
end;

procedure TCamera.OnShutdown;
begin
  FreeAndNil(FCamera);
  inherited;
end;

procedure TCamera.OnUpdateFrame(aDeltaTime: Double);
begin
  inherited;

  if MousePos.Z <> LLastMouseWheel then
    begin
      if MousePos.Z > LLastMouseWheel then
        LMouseWheel := 1
      else
      if MousePos.Z < LLastMouseWheel then
        LMouseWheel := -1;
      LLastMouseWheel := MousePos.Z;
    end
  else
    LMouseWheel := 0;

  if GV.Input.KeyDown(KEY_RIGHT) then
    FPlayer.X := FPlayer.X + (SPEED * aDeltaTime)
  else
  if GV.Input.KeyDown(KEY_LEFT) then
    FPlayer.X := FPlayer.X - (SPEED * aDeltaTime);
  FCamera.X := FPlayer.X;
  FCamera.Y := FPlayer.Y;

  // rotate
  if GV.Input.KeyDown(KEY_A) then
    FCamera.Rotation := FCamera.Rotation + (30 * aDeltaTime)
  else
  if GV.Input.KeyDown(KEY_D) then
    FCamera.Rotation := FCamera.Rotation - (30 * aDeltaTime);

  if FCamera.Rotation > 40 then
    FCamera.Rotation := 40
  else
  if FCamera.Rotation < -40 then
    FCamera.Rotation := -40;


  // scale
  if GV.Input.KeyDown(KEY_W) then
    begin
    FCamera.Scale := FCamera.Scale + (1 * aDeltaTime);
    end
  else
  if GV.Input.KeyDown(KEY_S) then
  begin
    FCamera.Scale := FCamera.Scale - (1 * aDeltaTime);
  end;

  if (FCamera.Scale > 4.0) then
    FCamera.Scale := 4.0
  else
  if (FCamera.Scale < 1) then
    FCamera.Scale := 1;

end;

procedure TCamera.OnRenderFrame;
var
  I: Integer;
begin
  inherited;

  FCamera.Activate(True);

  GV.Primitive.FilledRectangle(-6000, 300, 13000, 8000, DARKGRAY);

  for I := 0 to MAX_BUILDINGS-1 do
    GV.Primitive.FilledRectangle(FBuildings[I].X, FBuildings[I].Y, FBuildings[I].Width, FBuildings[I].Height, FBuildingColors[I]);

  GV.Primitive.FilledRectangle(FPlayer.X-(FPlayer.Width/2), FPlayer.Y-(FPlayer.Height/2), FPlayer.Width, FPlayer.Height, RED);
  GV.Primitive.Line(FPlayer.X, FPlayer.y-(GV.Window.Height*10), FPlayer.X, FPlayer.y+(GV.Window.Height*10), GREEN, 2);
  GV.Primitive.Line(FPlayer.X-(GV.Window.Height*10), FPlayer.y, FPlayer.X+(GV.Window.Height*10), FPlayer.y, GREEN, 2);

  FCamera.Activate(False);

  GV.Primitive.Rectangle(0, 0, GV.Window.Width+1, GV.Window.Height+1, 4, RED);
end;

procedure TCamera.OnRenderHUD;
begin
  HudResetPos;
  HudText(FFont, BLACK, haLeft, 'fps %d', [GetFrameRate]);
  HudText(FFont, BLACK, haLeft, HudTextItem('ESC', 'Quit'), []);

  HudText(Font, BLACK, haLeft, HudTextItem('Left/Right', 'Move'), [FPlayer.X]);
  HudText(Font, BLACK, haLeft, HudTextItem('A/D', 'Rotate'), [FPlayer.X]);
  HudText(Font, BLACK, haLeft, HudTextItem('W/S', 'Scale'), [FPlayer.X]);

  HudText(Font, BLACK, haLeft, HudTextItem('Pos', '%.2f'), [FPlayer.X]);
  HudText(Font, BLACK, haLeft, HudTextItem('Scale', '%.2f'), [FCamera.Scale]);
  HudText(Font, BLACK, haLeft, HudTextItem('Rotation', '%.2f'), [FCamera.Rotation]);

  HudText(Font, BLACK, haLeft, HudTextItem('Value', '%.2f:%.2f'), [FValue.X, FValue.Y]);
end;

end.
