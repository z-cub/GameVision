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

unit uEntityBlendMode;

interface

uses
  System.SysUtils,
  GameVision.Entity,
  GameVision.Game,
  uCommon;

type
  { TEntityBlendMode }
  TEntityBlendMode = class(TBaseExample)
  protected
    FBlendMode: Boolean;
    FExplosion: TGVEntity;
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
  GameVision.Color,
  GameVision.Input,
  GameVision.Window,
  GameVision.Core;

const
  cTrueFalseStr: array[False..True] of string = ('False', 'True');

{ TEntityBlendMode }
procedure TEntityBlendMode.OnSetSettings(var aSettings: TGVGameSettings);
begin
  inherited;
  aSettings.WindowTitle := 'GameVision - Entity Blend Mode';
  aSettings.WindowClearColor := BLACK;
end;

procedure TEntityBlendMode.OnStartup;
begin
  inherited;

  // init explosion sprite
  Sprite.LoadPage(Archive, 'arc/images/explosion.png', nil);
  Sprite.AddGroup;
  Sprite.AddImageFromGrid(0, 0, 0, 0, 64, 64);
  Sprite.AddImageFromGrid(0, 0, 1, 0, 64, 64);
  Sprite.AddImageFromGrid(0, 0, 2, 0, 64, 64);
  Sprite.AddImageFromGrid(0, 0, 3, 0, 64, 64);

  Sprite.AddImageFromGrid(0, 0, 0, 1, 64, 64);
  Sprite.AddImageFromGrid(0, 0, 1, 1, 64, 64);
  Sprite.AddImageFromGrid(0, 0, 2, 1, 64, 64);
  Sprite.AddImageFromGrid(0, 0, 3, 1, 64, 64);

  Sprite.AddImageFromGrid(0, 0, 0, 2, 64, 64);
  Sprite.AddImageFromGrid(0, 0, 1, 2, 64, 64);
  Sprite.AddImageFromGrid(0, 0, 2, 2, 64, 64);
  Sprite.AddImageFromGrid(0, 0, 3, 2, 64, 64);

  Sprite.AddImageFromGrid(0, 0, 0, 3, 64, 64);
  Sprite.AddImageFromGrid(0, 0, 1, 3, 64, 64);
  Sprite.AddImageFromGrid(0, 0, 2, 3, 64, 64);
  Sprite.AddImageFromGrid(0, 0, 3, 3, 64, 64);

  // init explosion entity
  FExplosion := TGVEntity.Create;
  FExplosion.Init(Sprite, 0);
  FExplosion.SetFrameFPS(14);
  FExplosion.SetScaleAbs(1);
  FExplosion.SetPosAbs(Settings.WindowWidth/2, Settings.WindowHeight/2);

  FBlendMode := False;
end;

procedure TEntityBlendMode.OnShutdown;
begin
  FreeAndNil(FExplosion);
  inherited;
end;

procedure TEntityBlendMode.OnUpdateFrame(aDeltaTime: Double);
begin
  inherited;

  if GV.Input.KeyPressed(KEY_B) then
    FBlendMode := not FBlendMode;

  FExplosion.NextFrame;
end;

procedure TEntityBlendMode.OnRenderFrame;
begin
  inherited;

  if FBlendMode then
    GV.Window.SetBlendMode(bmAdditiveAlpha);
  FExplosion.SetPosAbs(Settings.WindowWidth/2, Settings.WindowHeight/2);
  FExplosion.Render(0,0);

  FExplosion.SetPosAbs((Settings.WindowWidth/2)+16, (Settings.WindowHeight/2)+16);
  FExplosion.Render(0,0);

  GV.Window.RestoreDefaultBlendMode;
end;

procedure TEntityBlendMode.OnRenderHUD;
begin
  inherited;
  HudText(Font, GREEN,  haLeft, HudTextItem('B', 'Toggle blending'), []);
  HudText(Font, YELLOW, haLeft, HudTextItem('Blend:', ' %s', ''), [cTrueFalseStr[FBlendMode]]);
end;

end.
