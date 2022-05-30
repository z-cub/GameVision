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

unit uSpeech;

interface

uses
  System.SysUtils,
  GameVision.Game,
  uCommon;

const
  cSpeak = 'GameVision Toolkit is a 2D indie game library that allows you to do game ' +
           'development in Delphi, for desktop PCs running Microsoft Windows, ' +
           'and uses OpenGL for hardware accelerated rendering. ' +
           'Its robust, designed for easy use, and making all types of 2D games ' +
           'and other graphic simulations. You access the features from a ' +
           'simple and intuitive API, to allow you to rapidly and efficiently ' +
           'develop your projects. There is support for textures, shaders, audio samples, ' +
           'streaming music, loading resources directly from a compressed enkripted ' +
           'archive, and much more. GameVision, easy, fast, fun! ';

type
  { TSpeech }
  TSpeech = class(TBaseExample)
  protected
    FWord: string;
  public
    procedure OnSetSettings(var aSettings: TGVGameSettings); override;
    procedure OnStartup; override;
    procedure OnShutdown; override;
    procedure OnUpdateFrame(aDeltaTime: Double); override;
    procedure OnRenderFrame; override;
    procedure OnRenderHUD; override;
    procedure OnSpeechWord(const aWord: string; const aText: string); override;
  end;

implementation

uses
  GameVision.Common,
  GameVision.Color,
  GameVision.Input,
  GameVision.Core;

{ TExampleTemplate }
procedure TSpeech.OnSetSettings(var aSettings: TGVGameSettings);
begin
  inherited;
  aSettings.WindowTitle := 'GameVision - Speech';
  GV.Speech.SubstituteWord('enkripted', 'encrypted');
end;

procedure TSpeech.OnStartup;
begin
  inherited;
end;

procedure TSpeech.OnShutdown;
begin
  inherited;
end;

procedure TSpeech.OnUpdateFrame(aDeltaTime: Double);
begin
  inherited;
  if GV.Input.KeyPressed(KEY_S) then
    GV.Speech.Say(cSpeak, True);
end;

procedure TSpeech.OnRenderFrame;
begin
  inherited;
end;

procedure TSpeech.OnRenderHUD;
begin
  inherited;
  HudText(Font, GREEN,  haLeft, HudTextItem('S', 'Speak'), []);
  HudText(Font, ORANGE, haLeft, HudTextItem('Speak:', '%s', ' '), [FWord]);
end;

procedure TSpeech.OnSpeechWord(const aWord: string; const aText: string);
begin
  inherited;
  FWord := aWord;
end;

end.
