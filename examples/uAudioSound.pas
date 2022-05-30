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

unit uAudioSound;

interface

uses
  System.SysUtils,
  GameVision.Game,
  uCommon;

type
  { TAudioSound }
  TAudioSound = class(TBaseExample)
  protected
    FSamples: array[ 0..8 ] of Integer;
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
  GameVision.Audio,
  GameVision.Core;

{ TExampleTemplate }
procedure TAudioSound.OnSetSettings(var aSettings: TGVGameSettings);
begin
  inherited;
  aSettings.WindowTitle := 'GameVision - Sound Audio';
end;

procedure TAudioSound.OnStartup;
var
  I: Integer;
begin
  inherited;
  GV.Audio.SetChannelReserved(0, True);

  for I := 0 to 5 do
    FSamples[I] := GV.Audio.LoadSound(Archive, Format('arc/sfx/samp%d.ogg', [I]));

  FSamples[6] := GV.Audio.LoadSound(Archive, 'arc/sfx/weapon_player.ogg');
  FSamples[7] := GV.Audio.LoadSound(Archive, 'arc/sfx/thunder.ogg');
  FSamples[8] := GV.Audio.LoadSound(Archive, 'arc/sfx/digthis.ogg');
end;

procedure TAudioSound.OnShutdown;
var
  I: Integer;
begin
  GV.Audio.StopAllChannels;

  for I := 0 to 8 do
    GV.Audio.UnloadSound(FSamples[I]);

  inherited;
end;

procedure TAudioSound.OnUpdateFrame(aDeltaTime: Double);
begin
  inherited;

  if GV.Input.KeyPressed(KEY_1) then
    GV.Audio.PlaySound(AUDIO_DYNAMIC_CHANNEL, FSamples[1], 1, False);

  if GV.Input.KeyPressed(KEY_2) then
    GV.Audio.PlaySound(AUDIO_DYNAMIC_CHANNEL, FSamples[2], 1, False);

  if GV.Input.KeyPressed(KEY_3) then
    GV.Audio.PlaySound(AUDIO_DYNAMIC_CHANNEL, FSamples[3], 1, False);

  if GV.Input.KeyPressed(KEY_4) then
    GV.Audio.PlaySound(0, FSamples[0], 1, True);

  if GV.Input.KeyPressed(KEY_5) then
    GV.Audio.PlaySound(AUDIO_DYNAMIC_CHANNEL, FSamples[4], 1, False);

  if GV.Input.KeyPressed(KEY_6) then
    GV.Audio.PlaySound(AUDIO_DYNAMIC_CHANNEL, FSamples[5], 1, False);

  if GV.Input.KeyPressed(KEY_7) then
    GV.Audio.PlaySound(AUDIO_DYNAMIC_CHANNEL, FSamples[6], 1, False);

  if GV.Input.KeyPressed(KEY_8) then
    GV.Audio.PlaySound(AUDIO_DYNAMIC_CHANNEL, FSamples[7], 1, False);

  if GV.Input.KeyPressed(KEY_9) then
    GV.Audio.PlaySound(AUDIO_DYNAMIC_CHANNEL, FSamples[8], 1, False);

  if GV.Input.KeyPressed(KEY_0) then
    GV.Audio.StopChannel(0);
end;

procedure TAudioSound.OnRenderFrame;
begin
  inherited;
end;

procedure TAudioSound.OnRenderHUD;
begin
  inherited;
  HudText(Font, GREEN, haLeft, HudTextItem('1-9', 'Play sample'), []);
  HudText(Font, GREEN, haLeft, HudTextItem('0', 'Stop looping sample'), []);

end;

end.
