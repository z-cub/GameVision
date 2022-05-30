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

unit uTextureAlign;

interface

uses
  System.SysUtils,
  GameVision.Texture,
  GameVision.Game,
  uCommon;

type
  { TTextureAlign }
  TTextureAlign = class(TBaseExample)
  protected
    FTexture: TGVTexture;
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
  GameVision.Math,
  GameVision.Core;

{ TTextureAlign }
procedure TTextureAlign.OnSetSettings(var aSettings: TGVGameSettings);
begin
  inherited;
  aSettings.WindowTitle := 'GameVision - Texture Align';
end;

procedure TTextureAlign.OnStartup;
begin
  inherited;
  FTexture := TGVTexture.Create;
  FTexture.Load(Archive, 'arc/images/square00.png', @COLORKEY);
end;

procedure TTextureAlign.OnShutdown;
begin
  FreeAndNil(FTexture);
  inherited;
end;

procedure TTextureAlign.OnUpdateFrame(aDeltaTime: Double);
begin
  inherited;
end;

procedure TTextureAlign.OnRenderFrame;
var
  LCenterPos: TGVVector;
begin
  inherited;

  LCenterPos.Assign(Settings.WindowWidth/2, Settings.WindowHeight/2);

  GV.Primitive.Line(LCenterPos.X, 0, LCenterPos.X, Settings.WindowHeight, YELLOW, 1);
  GV.Primitive.Line(0, LCenterPos.Y, Settings.WindowWidth,  LCenterPos.Y, YELLOW, 1);

  FTexture.Draw(LCenterPos.X, LCenterPos.Y, 1, 0, WHITE, haCenter, vaCenter);
  Font.PrintText(LCenterPos.X, LCenterPos.Y+25, DARKGREEN, haCenter, 'center-center', []);

  GV.Primitive.Line(0, LCenterPos.Y-128, Settings.WindowWidth,  LCenterPos.Y-128, YELLOW, 1);

  FTexture.Draw(LCenterPos.X, LCenterPos.Y-128, 1, 0, WHITE, haLeft, vaTop);
  Font.PrintText(LCenterPos.X+34, LCenterPos.Y-(128-6), DARKGREEN, haLeft, 'left-top', []);

  FTexture.Draw(LCenterPos.X, LCenterPos.Y-128, 1, 0, WHITE, haLeft, vaBottom);
  Font.PrintText(LCenterPos.X+34, LCenterPos.Y-(128+25), DARKGREEN, haLeft, 'left-bottom', []);

  GV.Primitive.Line(0, LCenterPos.Y+128, Settings.WindowWidth,  LCenterPos.Y+128, YELLOW, 1);
  FTexture.Draw(LCenterPos.X, LCenterPos.Y+128, 1, 0, WHITE, haRight, vaTop);
  Font.PrintText(LCenterPos.X+4, LCenterPos.Y+(128+6), DARKGREEN, haLeft, 'right-top', []);

  FTexture.Draw(LCenterPos.X, LCenterPos.Y+128, 1, 0, WHITE, haRight, vaBottom);
  Font.PrintText(LCenterPos.X+4, LCenterPos.Y+(128-27), DARKGREEN, haLeft, 'right-bottom', []);
end;

procedure TTextureAlign.OnRenderHUD;
begin
  inherited;
end;

end.
