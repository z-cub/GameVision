﻿{==============================================================================
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

unit uGVExamples;

interface

uses
  System.SysUtils,
  GameVision.TreeMenu,
  GameVision.CustomGame;

type
  { TGVExamples }
  TGVExamples = class(TGVCustomGame)
  type
    { TMenuItem }
    TMenuItem = (
      // demos
      miAstroBlaster,
      miRenderTargets,
      // texture
      miTexture,
      miTextureRegion,
      miTextureScaled,
      // audio
      miAudioPositional,
      // entity
      miEntity,
      miEntityPolyPointCollision,
      // misc
      miScreenshake,
      miScreenshot,
      miGUI
    );
  public
    procedure OnStartup; override;
    procedure OnShutdown; override;
    procedure OnRun; override;
    procedure StartupDialogMore;
    procedure StartupDialogRun;
  end;

implementation

uses
  GameVision.Common,
  GameVision.ConfigFile,
  GameVision.Archive,
  GameVision.StartupDialog,
  GameVision.Core,
  uCommon,
  uAstroBlaster,
  uRenderTargets,
  uAudioPositional,
  uEntity,
  uEntityPolyPointCollision,
  uScreenshake,
  uScreenshot,
  uTexture,
  uTextureRegion,
  uTextureScaled,
  uTextureTiled,
  uGUI;

{ TGVExamples }
procedure TGVExamples.OnStartup;
begin
  inherited;
end;

procedure TGVExamples.OnShutdown;
begin
  inherited;
end;

procedure TGVExamples.OnRun;
var
  LDialog: TGVStartupDialog;
  LState: TGVStartupDialogState;
  LDone: Boolean;
  LArchive: TGVArchive;
begin

  LDialog := TGVStartupDialog.Create;
  try
    LArchive := TGVArchive.Create;
    try
      LArchive.Open(cArchivePassword, cArchiveFilename);
      LDialog.SetCaption('GameVision - Examples');
      LDialog.SetLogo(LArchive, 'arc/startupdialog/banner.png');
      LDialog.SetLogoClickUrl('https://gamevisiontoolkit.com');
      LDialog.SetReadme(LArchive, 'arc/startupdialog/README.rtf');
      LDialog.SetLicense(LArchive, 'arc/startupdialog/LICENSE.rtf');
      LDialog.SetReleaseInfo('Version '+GV_VERSION);
    finally
      FreeAndNil(LArchive);
    end;

    LDone := False;
    repeat
      LState := LDialog.Show;
      case LState of
        sdsMore: StartupDialogMore;
        sdsRun : StartupDialogRun;
        sdsQuit: LDone := True;
      end;
    until LDone;
  finally
    FreeAndNil(LDialog);
  end;
end;

procedure TGVExamples.StartupDialogMore;
begin
end;

procedure TGVExamples.StartupDialogRun;
var
  LConfigFile: TGVConfigFile;
  LMenu: TGVTreeMenu;
  LMenuItem: Integer;
  LDemoMenu: Integer;
  LAudioMenu: Integer;
  LTextureMenu: Integer;
  LEntity: Integer;
  LMiscMenu: Integer;
begin
  LMenu := TGVTreeMenu.Create;
  LMenu.SetTitle('GameVision - Examples');

  LAudioMenu := LMenu.AddItem(0, 'Audio', GV_TREEMENU_NONE, True);
  LMenu.AddItem(LAudioMenu, 'Positional', Ord(miAudioPositional), True);
  LMenu.Sort(LAudioMenu);

  LTextureMenu := LMenu.AddItem(0, 'Texture', GV_TREEMENU_NONE, True);
  LMenu.AddItem(LTextureMenu, 'Texture', Ord(miTexture), True);
  LMenu.AddItem(LTextureMenu, 'Region', Ord(miTextureRegion), True);
  LMenu.AddItem(LTextureMenu, 'Scaled', Ord(miTextureScaled), True);
  LMenu.Sort(LTextureMenu);

  LEntity := LMenu.AddItem(0, 'Entity', GV_TREEMENU_NONE, True);
  LMenu.AddItem(LEntity, 'Entity', Ord(miEntity), True);
  LMenu.AddItem(LEntity, 'PolyPoint Collision', Ord(miEntityPolyPointCollision), True);
  LMenu.Sort(LEntity);

  LMenu.Sort(0);

  LMiscMenu := LMenu.AddItem(0, 'Misc', GV_TREEMENU_NONE, True);
  LMenu.AddItem(LMiscMenu, 'Screenshake', Ord(miScreenshake), True);
  LMenu.AddItem(LMiscMenu, 'Screensave', Ord(miScreenshot), True);
  LMenu.AddItem(LMiscMenu, 'GUI', Ord(miGUI), True);
  LMenu.Sort(LMiscMenu);

  LDemoMenu := LMenu.AddItem(0, 'Demos', GV_TREEMENU_NONE, True);
  LMenu.AddItem(LDemoMenu, 'AstroBlaster', Ord(miAstroBlaster), True);
  LMenu.AddItem(LDemoMenu, 'RenderTargets', Ord(miRenderTargets), True);
  LMenu.Sort(LDemoMenu);

  LConfigFile := TGVConfigFile.Create;
  LConfigFile.Open;
  LMenuItem := LConfigFile.GetValue('ExamplesMenu', 'MenuItem', 0);
  LConfigFile.Close;

  repeat
    LMenuItem := LMenu.Show(LMenuItem);

    case TMenuItem(LMenuItem) of
      // demos
      miAstroBlaster           : GV.Run(TAstroBlaster);
      miRenderTargets          : GV.Run(TRenderTargets);
      // texture
      miTexture                : GV.Run(TTexture);
      miTextureRegion          : GV.Run(TTextureRegion);
      miTextureScaled          : GV.Run(TTextureScaled);
      // audio
      miAudioPositional        : GV.Run(TAudioPositional);
      // entity
      miEntity                 : GV.Run(TEntity);
      miEntityPolyPointCollision: GV.Run(TEntityPolyPointCollision);
      // misc
      miScreenshake            : GV.Run(TScreenshake);
      miScreenshot             : GV.Run(TScreenshot);
      miGUI                    : GV.Run(TGUI);
    end;
  until LMenuItem = GV_TREEMENU_QUIT;

  LConfigFile.Open;
  LConfigFile.SetValue('ExamplesMenu', 'MenuItem', LMenu.GetLastSelectedId);
  FreeAndNil(LConfigFile);

  FreeAndNil(LMenu);
end;

end.