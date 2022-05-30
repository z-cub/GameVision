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

unit uTextureParallax;

interface

uses
  System.SysUtils,
  GameVision.Math,
  GameVision.Texture,
  GameVision.Game,
  uCommon;

type
  { TParallax }
  TTextureParallax = class(TBaseExample)
  protected
    FTexture: array[0..3] of TGVTexture;
    FSpeed: array[0..3] of Single;
    FPos: array[0..3] of TGVVector;
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
  GameVision.Color,
  GameVision.Window,
  GameVision.Core;

{ TParallax }
procedure TTextureParallax.OnSetSettings(var aSettings: TGVGameSettings);
begin
  inherited;
  aSettings.WindowTitle := 'GameVision - Parallex Texture';
end;

procedure TTextureParallax.OnStartup;
begin
  inherited;

   FTexture[0] := TGVTexture.Create;
   FTexture[1] := TGVTexture.Create;
   FTexture[2] := TGVTexture.Create;
   FTexture[3] := TGVTexture.Create;

  // Load bitmap images
  FTexture[0].Load(Archive, 'arc/images/space.png', nil);
  FTexture[1].Load(Archive, 'arc/images/nebula.png', @BLACK);
  FTexture[2].Load(Archive, 'arc/images/spacelayer1.png', @BLACK);
  FTexture[3].Load(Archive, 'arc/images/spacelayer2.png', @BLACK);

  // Set bitmap speeds
  FSpeed[0] := 0.3 * 30;
  FSpeed[1] := 0.5 * 30;
  FSpeed[2] := 1.0 * 30;
  FSpeed[3] := 2.0 * 30;

  // Clear pos
  FPos[0].Clear;
  FPos[1].Clear;
  FPos[2].Clear;
  FPos[3].Clear;

end;

procedure TTextureParallax.OnShutdown;
begin
  FreeAndNil(FTexture[3]);
  FreeAndNil(FTexture[2]);
  FreeAndNil(FTexture[1]);
  FreeAndNil(FTexture[0]);
  inherited;
end;

procedure TTextureParallax.OnUpdateFrame(aDeltaTime: Double);
var
  I: Integer;
begin
  inherited;

  for I := 0 to 3 do
    FPos[I].Y := FPos[I].Y + (FSpeed[I] * aDeltaTime);
end;

procedure TTextureParallax.OnRenderFrame;
var
  I: Integer;
begin
  inherited;

  for I := 0 to 3 do
  begin
    if I = 1 then
      GV.Window.SetBlendMode(bmAdditiveAlpha);
    FTexture[I].DrawTiled(FPos[I].X, FPos[I].Y);
    if I = 1 then
      GV.Window.RestoreDefaultBlendMode;
  end;
end;

procedure TTextureParallax.OnRenderHUD;
begin
  inherited;
end;

end.
