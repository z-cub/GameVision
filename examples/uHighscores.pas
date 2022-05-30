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

unit uHighscores;

interface

uses
  System.SysUtils,
  GameVision.Starfield,
  GameVision.Database,
  GameVision.Highscores,
  GameVision.Game,
  uCommon;

type
  { THighscores }
  THighscores = class(TBaseExample)
  const
    // remotemysql.com
    cDbServer   = 'remotemysql.com';
    cDbPort     = GV_DEFAULT_MYSQL_PORT;
    cDbName     = 'DMDScOu0Zq';
    cDbUser     = 'DMDScOu0Zq';
    cDbPassword = 'rt2W4Ts5XC';

    // names & locations
    cName: array[0..19] of string = ('Jarrod', 'Sam', 'Jimmy', 'Frank',
      'Susan', 'Annie', 'Beth', 'Tony', 'Tommy', 'Perl', 'Charlie', 'Nicole',
      'Jackie', 'Bob', 'Chris', 'Eddie', 'Bob', 'Drex', 'Toni', 'Sammy');
    cLoc : array[0..19] of string = ('Old Town', 'Cross City', 'Chiefland',
     'Bronsan', 'Gainsville', 'Tamarac', 'Boston', 'Thomasville',
     'Jacksonville', 'Delaware', 'Miami', 'Fort Launderdale', 'Del Ray',
     'San Diego', 'Fort Worth', 'Charlotte', 'Portland', 'Las Vegas',
     'Memphis', 'Tucson');
  protected
    FStarfield: TGVStarfield;
    FHighscores: TGVHighscores;
    FScores: array of TGVHighscore;
    FNewScore: TGVHighscore;
  public
    procedure OnSetSettings(var aSettings: TGVGameSettings); override;
    procedure OnStartup; override;
    procedure OnShutdown; override;
    procedure OnUpdateFrame(aDeltaTime: Double); override;
    procedure OnRenderFrame; override;
    procedure OnRenderHUD; override;
    procedure OnHighscoreAction(aHighscores: TGVHighscores; aAction: TGVHighscoreAction); override;
    procedure PostScores;
    procedure ListScores;
    procedure ClearScores;
  end;

implementation

uses
  GameVision.Common,
  GameVision.Color,
  GameVision.Math,
  GameVision.Input,
  GameVision.Core;

{ THighscores }
procedure THighscores.OnSetSettings(var aSettings: TGVGameSettings);
begin
  inherited;
  aSettings.WindowTitle := 'GameVision - Highscores';
  aSettings.WindowClearColor := BLACK;
end;

procedure THighscores.OnStartup;
begin
  inherited;

  FStarfield := TGVStarfield.Create;

  FHighscores := TGVHighscores.Create;
  FHighscores.Setup(10, cDbServer, cDbName, cDbUser, cDbPassword, 'publicdemo');
end;

procedure THighscores.OnShutdown;
begin
  FreeAndNil(FHighscores);
  FreeAndNil(FStarfield);
  inherited;
end;

procedure THighscores.OnUpdateFrame(aDeltaTime: Double);
begin
  inherited;

  if GV.Input.KeyPressed(KEY_1) then  PostScores;
  if GV.Input.KeyPressed(KEY_2) then  ListScores;
  if GV.Input.KeyPressed(KEY_3) then  ClearScores;

  FStarfield.Update(aDeltaTime);
end;

procedure THighscores.OnRenderFrame;
begin
  inherited;

  FStarfield.Render;
end;

procedure THighscores.OnRenderHUD;
var
  LScore: TGVHighscore;
  LPos: TGVVector;
  LLine: string;
  LColor: TGVColor;
  LOffset: Integer;
begin
  inherited;
  HudText(FFont, GREEN, haLeft, HudTextItem('1', 'Post scores'), []);
  HudText(FFont, GREEN, haLeft, HudTextItem('2', 'List scores'), []);
  HudText(FFont, GREEN, haLeft, HudTextItem('3', 'Clear scores'), []);


  if FScores = nil then Exit;

  LOffset := 60;
  LLine := 'NAME'.PadRight(20) + 'LEVEL'.PadRight(7) + 'SKILL'.PadRight(7) + 'SCORE'.PadRight(10) + 'LOCATION';
  Font.PrintText(100, (84-16) + LOffset, WHITE, haLeft, LLine, []);


  LLine := '';
  Font.PrintText(100, 84 + LOffset, GREEN, haLeft, LLine.PadRight(80, '-'), []);

  LPos.Assign(100, 100 + LOffset);
  for LScore in FScores do
  begin
    LLine := LScore.Name.PadRight(20) + LScore.Level.ToString.PadRight(7) + LScore.Skill.ToString.PadRight(7) + LScore.Score.ToString.PadRight(10) + LScore.Location;
    if LScore = FNewScore then
      LColor := WHITE
    else
      LColor := GREEN;

    Font.PrintText(LPos.X, LPos.Y, 0, LColor, haLeft, LLine, []);
  end;


  LLine := '';
  Font.PrintText(100, 262 + LOffset, GREEN, haLeft, LLine.PadRight(80, '-'), []);

  LLine := 'Posted ' + FNewScore.Name.PadRight(20) + FNewScore.Level.ToString.PadRight(7) + FNewScore.Skill.ToString.PadRight(7) + FNewScore.Score.ToString.PadRight(10) + FNewScore.Location;
  Font.PrintText(50, 278 + LOffset, ORANGE, haLeft, LLine, []);
end;

procedure THighscores.OnHighscoreAction(aHighscores: TGVHighscores; aAction: TGVHighscoreAction);
var
  I: Integer;
begin
  FScores := nil;
  SetLength(FScores, aHighscores.GetResultCount);
  for I := 0 to aHighscores.GetResultCount-1 do
  begin
    aHighscores.GetResult(I, FScores[I]);
  end;
end;

procedure THighscores.PostScores;
var
  I: Integer;
  LScore: Cardinal;
  LSkill: Integer;
begin
  LScore := GV.Math.RandomRange(1, 10000);
  I := GV.Math.RandomRange(0, 19);
  LSkill := 1;
  FNewScore.Name := cName[I];
  FNewScore.Level := 1;
  FNewScore.Score := LScore;
  FNewScore.Skill := LSkill;
  FNewScore.Duration := 0;
  FNewScore.Location := cLoc[I];
  FHighscores.Post(FNewScore);
end;

procedure THighscores.ListScores;
begin
  FHighscores.List(1, 1);
end;

procedure THighscores.ClearScores;
begin
  FHighscores.Clear;
end;

end.
