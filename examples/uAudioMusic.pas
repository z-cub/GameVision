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

unit uAudioMusic;

interface

uses
  System.SysUtils,
  GameVision.Game,
  uCommon;

type
  { TAudioMusic }
  TAudioMusic = class(TBaseExample)
  protected
    FFilename: string;
    FNum: Integer;
    FMusic: Integer;
    procedure Play(aNum: Integer; aVol: Single);
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
  System.IOUtils,
  GameVision.Common,
  GameVision.Color,
  GameVision.Input,
  GameVision.Core;

{ TAudioMusic }
procedure TAudioMusic.Play(aNum: Integer; aVol: Single);
begin
  FFilename := Format('arc/music/song%.*d.ogg', [2,aNum]);
  GV.Audio.UnloadMusic(FMusic);
  FMusic := GV.Audio.LoadMusic(Archive, FFilename);
  GV.Audio.PlayMusic(FMusic, aVol, True);
end;

procedure TAudioMusic.OnSetSettings(var aSettings: TGVGameSettings);
begin
  inherited;
  aSettings.WindowTitle := 'GameVision - Music';
end;

procedure TAudioMusic.OnStartup;
begin
  inherited;
  FNum := 1;
  FFilename := '';
  FMusic := -1;
  Play(1, 1.0);
end;

procedure TAudioMusic.OnShutdown;
begin
  GV.Audio.UnloadMusic(FMusic);
  inherited;
end;

procedure TAudioMusic.OnUpdateFrame(aDeltaTime: Double);
begin
  inherited;

  if GV.Input.KeyPressed(KEY_PGUP) then
  begin
    Inc(FNum);
    if FNum > 13 then
      FNum := 1;
    Play(FNum, 1.0);
  end
  else
  if GV.Input.KeyPressed(KEY_PGDN) then
  begin
    Dec(FNum);
    if FNum < 1 then
      FNum := 13;
    Play(FNum, 1.0);
  end
end;

procedure TAudioMusic.OnRenderFrame;
begin
  inherited;
end;

procedure TAudioMusic.OnRenderHUD;
begin
  inherited;

  HudText(Font, GREEN,  haLeft, HudTextItem('PgUp/PgDn', 'Play sample'), []);
  HudText(Font, ORANGE, haLeft, HudTextItem('Song:', '%s', ' '), [TPath.GetFileName(FFilename)]);

end;

end.
