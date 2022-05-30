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

unit uRenderTargetRotate;

interface

uses
  System.SysUtils,
  GameVision.Texture,
  GameVision.RenderTarget,
  GameVision.Game,
  uCommon;

type
  { TRenderTargetRotate }
  TRenderTargetRotate = class(TBaseExample)
  protected
    FRenderTarget: TGVRenderTarget;
    FBackground: TGVTexture;
    FSpeed: Single;
    FAngle: Single;
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

{ TExampleTemplate }
procedure TRenderTargetRotate.OnSetSettings(var aSettings: TGVGameSettings);
begin
  inherited;
  aSettings.WindowTitle := 'GameVision - RenderTarget Rotate';
end;

procedure TRenderTargetRotate.OnStartup;
begin
  inherited;

  FRenderTarget := TGVRenderTarget.Create;
  FRenderTarget.Init(380, 280);
  FRenderTarget.SetPosition((Settings.WindowWidth - 380) div 2, (Settings.WindowHeight - 280) div 2);

  FBackground := TGVTexture.Create;
  FBackground.Load(Archive, 'arc/images/bluestone.png', nil);
end;

procedure TRenderTargetRotate.OnShutdown;
begin
  FreeAndNil(FBackground);
  FreeAndNil(FRenderTarget);
  inherited;
end;

procedure TRenderTargetRotate.OnUpdateFrame(aDeltaTime: Double);
begin
  inherited;
  FSpeed := FSpeed + (60 * aDeltaTime);
  FAngle := FAngle + (7 * aDeltaTime);
  GV.Math.ClipValue(FAngle, 0, 359, True);
  FRenderTarget.SetAngle(FAngle);
end;

procedure TRenderTargetRotate.OnRenderFrame;
var
  LSize: TGVRectangle;
begin
  inherited;

  FRenderTarget.GetSize(LSize);
  FRenderTarget.SetActive(True);
  FBackground.DrawTiled(0, FSpeed);
  Font.PrintTExt(LSize.Width/2, 3, WHITE, haCenter, 'RenderTarget', []);
  FRenderTarget.SetActive(False);
  FRenderTarget.Show;
end;

procedure TRenderTargetRotate.OnRenderHUD;
begin
  inherited;
end;

end.
