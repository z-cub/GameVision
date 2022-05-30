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

unit uChainAction;

interface

uses
  System.SysUtils,
  GameVision.Color,
  GameVision.Math,
  GameVision.Starfield,
  GameVision.EntityActor,
  GameVision.Actor,
  GameVision.Game,

  uCommon;

const
  // scene
  SCN_COUNT  = 2;
  SCN_CIRCLE = 0;
  SCN_EXPLO  = 1;

  // circle
  SHRINK_FACTOR = 0.65;

  CIRCLE_SCALE = 0.125;
  CIRCLE_SCALE_SPEED   = 0.95;

  CIRCLE_EXP_SCALE_MIN = 0.05;
  CIRCLE_EXP_SCALE_MAX = 0.49;

  CIRCLE_MIN_COLOR = 64;
  CIRCLE_MAX_COLOR = 255;

  CIRCLE_COUNT = 80;

type
  { TCommonEntity }
  TCommonEntity = class(TGVEntityActor)
  public
    constructor Create; override;
    procedure OnCollide(aActor: TGVActor; aHitPos: TGVVector); override;
    function  Collide(aActor: TGVActor; var aHitPos: TGVVector): Boolean; override;
  end;

  { TCircle }
  TCircle = class(TCommonEntity)
  protected
    FColor: TGVColor;
    FSpeed: Single;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure OnUpdate(aDeltaTime: Double); override;
    procedure OnRender; override;
    procedure OnCollide(aActor: TGVActor; aHitPos: TGVVector); override;
    property Speed: Single read FSpeed;
  end;

  { TCircleExplosion }
  TCircleExplosion = class(TCommonEntity)
  protected
    FColor: array[0..1] of TGVColor;
    FState: Integer;
    FFade: Single;
    FSpeed: Single;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Setup(aX, aY: Single; aColor: TGVColor); overload;
    procedure Setup(aCircle: TCircle); overload;
    procedure OnUpdate(aDeltaTime: Double); override;
    procedure OnRender; override;
    procedure OnCollide(aActor: TGVActor; aHitPos: TGVVector); override;
  end;


  { TChainAction }
  TChainAction = class(TBaseExample)
  protected
    FExplosions: Integer;
    FChainActive: Boolean;
    FMusic: Integer;
    FStarfield: TGVStarfield;
  public
    property Explosions: Integer read FExplosions write FExplosions;
    procedure OnSetSettings(var aSettings: TGVGameSettings); override;
    procedure OnStartup; override;
    procedure OnShutdown; override;
    procedure OnUpdateFrame(aDeltaTime: Double); override;
    procedure OnRenderFrame; override;
    procedure OnRenderHUD; override;
    procedure OnBeforeRenderScene(aSceneNum: Integer); override;
    procedure OnAfterRenderScene(aSceneNum: Integer); override;
    procedure SpawnCircle(aNum: Integer); overload;
    procedure SpawnCircle; overload;
    procedure SpawnExplosion(aX, aY: Single; aColor: TGVColor); overload;
    procedure SpawnExplosion(aCircle: TCircle); overload;
    procedure CheckCollision(aEntity: TGVEntityActor);
    procedure StartChain;
    procedure PlayLevel;
    function  ChainEnded: Boolean;
    function  LevelClear: Boolean;
  end;

implementation

uses
  GameVision.Common,
  GameVision.Input,
  GameVision.Window,
  GameVision.Core;

var
  Game: TChainAction = nil;


{ TCommonEntity }
constructor TCommonEntity.Create;
begin
  inherited;

  CanCollide := True;
end;

procedure TCommonEntity.OnCollide(aActor: TGVActor; aHitPos: TGVVector);
begin
  inherited;

end;

function  TCommonEntity.Collide(aActor: TGVActor; var aHitPos: TGVVector): Boolean;
begin
  Result := False;

  if Overlap(aActor) then
  begin
    aHitPos := Entity.GetPos;
    Result := True;
  end;
end;


{ TCircle }
constructor TCircle.Create;
var
  LOK: Boolean;
  LVP: TGVRectangle;
  LA: Single;
begin
  inherited;

  GV.Window.GetViewportSize(LVP);

  Init(Game.Sprite, 0);
  Entity.SetShrinkFactor(SHRINK_FACTOR);
  Entity.SetScaleAbs(CIRCLE_SCALE);
  Entity.SetPosAbs(GV.Math.RandomRange(32, (LVP.Width-1)-32), GV.Math.RandomRange(32, (LVP.Width-1)-32));

  LOK := False;
  repeat
    Sleep(1);
    FColor.FromByte(
      Byte(GV.Math.RandomRange(CIRCLE_MIN_COLOR, CIRCLE_MAX_COLOR)),
      Byte(GV.Math.RandomRange(CIRCLE_MIN_COLOR, CIRCLE_MAX_COLOR)),
      Byte(GV.Math.RandomRange(CIRCLE_MIN_COLOR, CIRCLE_MAX_COLOR)),
      Byte(GV.Math.RandomRange(CIRCLE_MIN_COLOR, CIRCLE_MAX_COLOR))
    );

    if FColor.Equal(BLACK) or
       FColor.Equal(WHITE) then
      continue;

    LOK := True;
  until LOK;

  LOK := False;
  repeat
    Sleep(1);
    LA := GV.Math.RandomRange(0, 359);
    if (Abs(LA) >=90-10) and (Abs(LA) <= 90+10) then continue;
    if (Abs(LA) >=270-10) and (Abs(LA) <= 270+10) then continue;

    LOK := True;
  until LOK;

  Entity.RotateAbs(LA);
  Entity.SetColor(FColor);
  FSpeed := GV.Math.RandomRange(3*35, 7*35);
end;

destructor TCircle.Destroy;
begin

  inherited;
end;

procedure TCircle.OnUpdate(aDeltaTime: Double);
var
  LV: TGVVector;
  LVP: TGVRectangle;
  LR: Single;
begin
  GV.Window.GetViewportSize(LVP);

  Entity.Thrust(FSpeed * aDeltaTime);

  LV := Entity.GetPos;

  LR := Entity.GetRadius / 2;

  if LV.x < -LR then
    LV.x := LVP.Width-1
  else if LV.x > (LVP.Width-1)+LR then
    LV.x := -LR;

  if LV.y < -LR then
    LV.y := (LVP.Height-1)
  else if LV.y > (LVP.Height-1)+LR then
    LV.y := -LR;

  Entity.SetPosAbs(LV.X, LV.Y);
end;

procedure TCircle.OnRender;
begin
  inherited;

end;

procedure TCircle.OnCollide(aActor: TGVActor; aHitPos: TGVVector);
var
  LPos: TGVVector;
begin
  Terminated := True;
  LPos := Entity.GetPos;

  Game.SpawnExplosion(LPos.X, LPos.Y, FColor);
  Game.Explosions := Game.Explosions + 1;
end;


{ TCircleExplosion }
constructor TCircleExplosion.Create;
begin
  inherited;

  Init(Game.Sprite, 0);

  Entity.SetShrinkFactor(SHRINK_FACTOR);
  Entity.SetScaleAbs(CIRCLE_SCALE);

  FState := 0;
  FFade := 0;
  FSpeed := 0;
end;

destructor TCircleExplosion.Destroy;
begin

  inherited;
end;

procedure TCircleExplosion.Setup(aX, aY: Single; aColor: TGVColor);
begin
  FColor[0] := aColor;
  FColor[1] := aColor;
  Entity.SetPosAbs(aX, aY);
end;

procedure TCircleExplosion.Setup(aCircle: TCircle);
var
  LPos: TGVVector;
begin
  LPos := aCircle.Entity.GetPos;
  Setup(LPos.X, LPos.Y, aCircle.Entity.GetColor);
  Entity.RotateAbs(aCircle.Entity.GetAngle);
  FSpeed := aCircle.Speed;
end;

procedure TCircleExplosion.OnUpdate(aDeltaTime: Double);
begin
  Entity.Thrust(FSpeed*aDeltaTime);

  case FState of
    0: // expand
    begin
      Entity.SetScaleRel(CIRCLE_SCALE_SPEED*aDeltaTime);
      if Entity.GetScale > CIRCLE_EXP_SCALE_MAX then
      begin
        FState := 1;
      end;
      Entity.SetColor(FColor[0]);
    end;

    1: // contract
    begin
      Entity.SetScaleRel(-CIRCLE_SCALE_SPEED*aDeltaTime);
      FFade := CIRCLE_SCALE_SPEED*aDeltaTime / Entity.GetScale;
      if Entity.GetScale < CIRCLE_EXP_SCALE_MIN then
      begin
        FState := 2;
        FFade := 1.0;
        Terminated := True;
      end;
      //C := Engine.Color.Fade(FColor[0], FColor[1], FFade);
      //Entity.SetColor(C);
    end;

    2: // kill
    begin
      Terminated := True;
    end;

  end;

  Game.CheckCollision(Self);
end;

procedure TCircleExplosion.OnRender;
begin
  inherited;

end;

procedure TCircleExplosion.OnCollide(aActor: TGVActor; aHitPos: TGVVector);
begin
end;

{ TChainAction }
procedure TChainAction.OnSetSettings(var aSettings: TGVGameSettings);
begin
  inherited;
  aSettings.WindowTitle := 'GameVision - ChainAction Demo';
  aSettings.WindowClearColor := BLACK;
  aSettings.SceneCount := SCN_COUNT;
end;

procedure TChainAction.OnStartup;
var
  LPage: Integer;
  LGroup: Integer;
begin
  inherited;
  Game := Self;

  // init circle sprite
  LPage := Sprite.LoadPage(Archive, 'arc/images/light.png', @COLORKEY);
  LGroup := Sprite.AddGroup;
  Sprite.AddImageFromGrid(LPage, LGroup, 0, 0, 256, 256);

  // init music
  FMusic := GV.Audio.LoadMusic(Archive, 'arc/music/song06.ogg');
  GV.Audio.PlayMusic(FMusic, 1.0, True);

  // init starfield
  FStarfield := TGVStarfield.Create;

  PlayLevel;
end;

procedure TChainAction.OnShutdown;
begin
  GV.Audio.UnloadMusic(FMusic);
  FreeAndNil(FStarfield);
  Game := nil;
  inherited;
end;

procedure TChainAction.OnUpdateFrame(aDeltaTime: Double);
begin
  inherited;

  // start  new level
  if GV.Input.KeyPressed(KEY_SPACE) then
  begin
    if LevelClear then
      PlayLevel;
  end;

  // start chain reaction
  if GV.Input.MousePressed(MOUSE_BUTTON_LEFT) then
  begin
    if ChainEnded then
      StartChain;
  end;

  FStarfield.Update(aDeltaTime);
end;

procedure TChainAction.OnRenderFrame;
begin
  inherited;
  FStarfield.Render;
end;

procedure TChainAction.OnRenderHUD;
var
  LVP: TGVRectangle;
  LX: Single;
  LC: TGVColor;
begin
  inherited;

  HudText(Font, YELLOW, haLeft, HudTextItem('Circles:', ' %d', ''), [Scene[SCN_CIRCLE].Count]);

  GV.Window.GetViewportSize(LVP);
  LX := LVP.Width / 2;

  if ChainEnded and (not LevelClear) then
    LC := WHITE
  else
    LC := DIMWHITE;

  Font.PrintText(LX, 120, LC, haCenter, 'Click mouse to start chain reaction', []);

  if LevelClear then
  begin
    Font.PrintText(LX, (120+21), ORANGE, haCenter, 'Press SPACE to start new level', []);
  end;
end;

procedure TChainAction.OnBeforeRenderScene(aSceneNum: Integer);
begin
  case aSceneNum of
    SCN_CIRCLE, SCN_EXPLO:
    begin
      GV.Window.SetBlendMode(bmAdditiveAlpha);
    end;
  end;
end;

procedure TChainAction.OnAfterRenderScene(aSceneNum: Integer);
begin
  case aSceneNum of
    SCN_CIRCLE, SCN_EXPLO:
    begin
      GV.Window.RestoreDefaultBlendMode;
    end;
  end;
end;

procedure TChainAction.SpawnCircle(aNum: Integer);
var
  I: Integer;
begin
  for I := 0 to aNum - 1 do
    Scene[SCN_CIRCLE].Add(TCircle.Create);
end;

procedure TChainAction.SpawnCircle;
begin
  SpawnCircle(GV.Math.RandomRange(10, 40));
end;

procedure TChainAction.SpawnExplosion(aX, aY: Single; aColor: TGVColor);
var
  obj: TCircleExplosion;
begin
  obj := TCircleExplosion.Create;
  obj.Setup(aX, aY, aColor);
  Scene[SCN_EXPLO].Add(obj);
end;

procedure TChainAction.SpawnExplosion(aCircle: TCircle);
var
  obj: TCircleExplosion;
begin
  obj := TCircleExplosion.Create;
  obj.Setup(aCircle);
  Scene[SCN_EXPLO].Add(obj);
end;

procedure TChainAction.CheckCollision(aEntity: TGVEntityActor);
begin
  Scene[SCN_CIRCLE].CheckCollision([], aEntity);
end;

procedure TChainAction.StartChain;
begin
  if not FChainActive then
  begin
    SpawnExplosion(MousePos.X, MousePos.Y, WHITE);
    FChainActive := True;
  end;
end;

procedure TChainAction.PlayLevel;
begin
  Scene.ClearAll;
  SpawnCircle(CIRCLE_COUNT);
  FChainActive := False;
  FExplosions := 0;
end;

function  TChainAction.ChainEnded: Boolean;
begin
  Result := True;

  if FChainActive then
  begin
    Result := Boolean(Scene[SCN_EXPLO].Count = 0);
    if Result  then
      FChainActive := False;
  end;
end;

function  TChainAction.LevelClear: Boolean;
begin
  Result := Boolean(Scene[SCN_CIRCLE].Count = 0);
end;

end.
