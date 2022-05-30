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

unit uVideo;

interface

uses
  System.SysUtils,
  GameVision.Game,
  uCommon;

type
  { TVideo }
  TVideo = class(TBaseExample)
  protected
    FFilename: array[0..1] of string;
    FNum: Integer;
    procedure Play(aNum: Integer; aVolume: Single);
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
  GameVision.Input,
  GameVision.Core;

{ TVideo }
procedure TVideo.Play(aNum: Integer; aVolume: Single);
begin
  if (aNum < 0) or (aNum > 3) then Exit;
  if  (aNum = FNum) then Exit;
  FNum := aNum;
  GV.Video.Play(Archive, 'arc/videos/'+FFilename[FNum], True, aVolume);
end;
procedure TVideo.OnSetSettings(var aSettings: TGVGameSettings);
begin
  inherited;
  aSettings.WindowTitle := 'GameVision - Video';
end;

procedure TVideo.OnStartup;
begin
  inherited;
  FFilename[0] := 'GameVision.ogv';
  FFilename[1] := 'tinyBigGAMES.ogv';
  FNum := -1;
  Play(0, 1);
end;

procedure TVideo.OnShutdown;
begin
  GV.Video.Unload;
  inherited;
end;

procedure TVideo.OnUpdateFrame(aDeltaTime: Double);
begin
  inherited;

  if GV.Input.KeyPressed(KEY_1) then
    Play(0, 0.5);

  if GV.Input.KeyPressed(KEY_2) then
    Play(1, 0.5);
end;

procedure TVideo.OnRenderFrame;
begin
  inherited;
  GV.Video.Draw(0, 0, 0.50);
end;

procedure TVideo.OnRenderHUD;
begin
  inherited;
  HudText(Font, GREEN, haLeft, HudTextItem('1-2', 'Video (%s)'), [FFilename[FNum]]);
end;

end.
