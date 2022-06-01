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

unit uShader;

interface

uses
  System.SysUtils,
  GameVision.Shader,
  GameVision.Game,
  uCommon;

type
  { TShader }
  TShader = class(TBaseExample)
  const
    CName: array[0..2] of string = ('swirl', 'vortex', 'fire');
  protected
    FShader: array[0..2] of TGVShader;
    FIndex: Integer;
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
  GameVision.Core;

{ TShader }
procedure TShader.OnSetSettings(var aSettings: TGVGameSettings);
begin
  inherited;
  aSettings.WindowTitle := 'GameVision - Shader';
  aSettings.WindowClearColor := BLACK;
end;

procedure TShader.OnStartup;
var
  I: Integer;
begin
  inherited;

  for I := 0 to 2 do
  begin
    FShader[I] := TGVShader.Create;
    FShader[I].Load(Archive, stFragment, Format('arc/shaders/%s.frag', [CName[I]]));
    FShader[I].Build;

    FShader[I].Enable(True);
    FShader[I].SetVec2Uniform('u_resolution', GV.Window.Width * GV.Window.Scale, GV.Window.Height * GV.Window.Scale);
    FShader[I].Enable(False);
  end;

  FIndex := 0;
end;

procedure TShader.OnShutdown;
var
  I: Integer;
begin
  for I := 2 downto 0 do
    FreeAndNil(FShader[I]);
  inherited;
end;

procedure TShader.OnUpdateFrame(aDeltaTime: Double);
begin
  inherited;

  if GV.Input.KeyPressed(KEY_1) then
    FIndex := 0
  else
  if GV.Input.KeyPressed(KEY_2) then
    FIndex := 1
  else
  if GV.Input.KeyPressed(KEY_3) then
    FIndex := 2;

  FShader[FIndex].Enable(True);
  FShader[FIndex].SetFloatUniform('u_time', GetTime);
  FShader[FIndex].Enable(False);
end;

procedure TShader.OnRenderFrame;
begin
  inherited;

  FShader[FIndex].Enable(True);
  GV.Primitive.FilledRectangle(0, 0, GV.Window.Width, GV.Window.Height, WHITE);
  FShader[FIndex].Enable(False);
end;

procedure TShader.OnRenderHUD;
begin
  inherited;
  HudText(FFont, GREEN, haLeft, HudTextItem('1-3', 'Shader (%s)'), [CName[FIndex]]);
end;

end.
