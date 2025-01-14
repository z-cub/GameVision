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

unit GameVision.Core;

{$I GameVision.Defines.inc}

interface

uses
  System.SysUtils,
  GameVision.Allegro,
  GameVision.Base,
  GameVision.Math,
  GameVision.Util,
  GameVision.Console,
  GameVision.Logger,
  GameVision.CmdLine,
  GameVision.Window,
  GameVision.Primitive,
  GameVision.Input,
  GameVision.Audio,
  GameVision.Speech,
  GameVision.Async,
  GameVision.Video,
  GameVision.Screenshot,
  GameVision.Screenshake,
  GameVision.Collision,
  GameVision.GUI,
  GameVision.CmdConsole,
  GameVision.Lua,
  GameVision.CustomGame,
  GameVision.Game;

const
  // Custom events
  EVENT_CMDCON_ACTIVE   = 10000;
  EVENT_CMDCON_INACTIVE = 10001;

type
  { TGV }
  TGV = class(TGVObject)
  protected
    FCodePage: Cardinal;
    FEvent: ALLEGRO_EVENT;
    FQueue: PALLEGRO_EVENT_QUEUE;
    FVoice: PALLEGRO_VOICE;
    FMixer: PALLEGRO_MIXER;
    FFileState: array[False..True] of ALLEGRO_STATE;
    FUserEventSrc: ALLEGRO_EVENT_SOURCE;
    FCmdConActive: ALLEGRO_EVENT;
    FCmdConInactive: ALLEGRO_EVENT;
    FMasterObjectList: TGVObjectList;
    FUtil: TGVUtil;
    FMath: TGVMath;
    FConsole: TGVConsole;
    FLogger: TGVLogger;
    FCmdLine: TGVCmdLine;
    FWindow: TGVWindow;
    FPrimitive: TGVPrimitive;
    FInput: TGVInput;
    FAudio: TGVAudio;
    FAsync: TGVAsync;
    FSpeech: TGVSpeech;
    FVideo: TGVVideo;
    FScreenshot: TGVScreenshot;
    FScreenshake: TGVScreenshake;
    FCollision: TGVCollision;
    FGUI: TGVGUI;
    FCmdConsole: TGVCmdConsole;
    FLua: TGVLua;
    FGame: TGVGame;
    function GetEvent: PALLEGRO_EVENT;
    procedure StartupAllegro;
    procedure ShutdownAllegro;
  public
    property Queue: PALLEGRO_EVENT_QUEUE read FQueue;
    property Voice: PALLEGRO_VOICE read FVoice;
    property Mixer: PALLEGRO_MIXER read FMixer;
    property Event: PALLEGRO_EVENT read GetEvent;
    property MasterObjectList: TGVObjectList read FMasterObjectList;
    property Util: TGVUtil read FUtil;
    property Math: TGVMath read FMath;
    property Console: TGVConsole read FConsole;
    property Logger: TGVLogger read FLogger;
    property CmdLine: TGVCmdLine read FCmdLine;
    property Window: TGVWindow read FWindow;
    property Primitive: TGVPrimitive read FPrimitive;
    property Input: TGVInput read FInput;
    property Audio: TGVAudio read FAudio;
    property Async: TGVAsync read FAsync;
    property Speech: TGVSpeech read FSpeech;
    property Video: TGVVideo read FVideo;
    property Screenshot: TGVScreenshot read FScreenshot;
    property Screenshake: TGVScreenshake read FScreenshake;
    property Collision: TGVCollision read FCollision;
    property GUI: TGVGUI read FGUI;
    property CmdConsole: TGVCmdConsole read FCmdConsole;
    property Lua: TGVLua read FLua;
    property Game: TGVGame read FGame write FGame;
    constructor Create; override;
    destructor Destroy; override;
    procedure EmitCmdConInactiveEvent;
    procedure EmitCmdConActiveEvent;
    procedure SetFileSandBoxed(aEnable: Boolean);
    function  GetFileSandBoxed: Boolean;
    procedure SetFileSandboxWriteDir(aPath: string);
    function  GetFileSandboxWriteDir: string;
    procedure Run(aGame: TGVCustomGameClass); overload;
    procedure Run(aGame: TGVGameClass); overload;
  end;

var
  GV: TGV = nil;

implementation

uses
  WinApi.Windows,
  GameVision.Common,
  GameVision.Deps;

{ TGV }
function TGV.GetEvent: PALLEGRO_EVENT;
begin
  Result := @FEvent;
end;

procedure TGV.StartupAllegro;
var
  LOk: Boolean;
begin
  if al_is_system_installed then Exit;

  // init allegro
  LOk := al_install_system(ALLEGRO_VERSION_INT, nil);
  if LOk then FLogger.Log('Initialized Allegro v%s', [ALLEGRO_VERSION_STR]) else FLogger.Log('Failed to initialize Allegro', []);

  // init devices
  LOk := al_install_joystick;
  if LOk then FLogger.Log('Initialized Allegro joystick support', []) else FLogger.Log('Failed to initialize Allegro joystick support', []);

  LOk := al_install_keyboard;
  if LOk then FLogger.Log('Initialized Allegro keyboard support', []) else FLogger.Log('Failed to initialize Allegro keyboard', []);

  LOk := al_install_mouse;
  if LOk then FLogger.Log('Initialized Allegro mouse support', []) else FLogger.Log('Failed to initialize Allegro mouse support', []);

  LOk := al_install_touch_input;
  if LOk then FLogger.Log('Initialized Allegro touch input', []) else FLogger.Log('Failed to initialize Allegro touch input support', []);

  LOk := al_install_audio;
  if LOk then FLogger.Log('Initialized Allegro audio support', []) else FLogger.Log('Failed to initialize Allegro audio support', []);

  //if LOk then FLogger.Log('Successfully initialized xxx', []) else FLogger.Log('Failed to initialize xxx', []);


  // init addons
  LOk := al_init_acodec_addon;
  if LOk then FLogger.Log('Initialized Allegro audio codecs', []) else FLogger.Log('Failed to initialize Allegro audio codecs', []);

  LOk := al_init_font_addon;
  if LOk then FLogger.Log('Initialized Allegro font support', []) else FLogger.Log('Failed to initialize Allegro font support', []);

  LOk := al_init_image_addon;
  if LOk then FLogger.Log('Initialized Allegro image support', []) else FLogger.Log('Failed to initialize Allegro image support', []);

  LOk := al_init_native_dialog_addon;
  if LOk then FLogger.Log('Initialized Allegro native dialog support', []) else FLogger.Log('Failed to initialize Allegro native dialog support', []);

  LOk := al_init_primitives_addon;
  if LOk then FLogger.Log('Initialized Allegro primitives', []) else FLogger.Log('Failed to initialize Allegro primitives', []);

  LOk := al_init_ttf_addon;
  if LOk then FLogger.Log('Initialized Allegro ttf support', []) else FLogger.Log('Failed to initialize Allegro ttf support', []);

  LOk := al_init_video_addon;
  if LOk then FLogger.Log('Initialized Allegro video support', []) else FLogger.Log('Failed to initialize Allegro video support', []);

  // int user event source
  al_init_user_event_source(@FUserEventSrc);

  // init event queues
  FQueue := al_create_event_queue;
  al_register_event_source(FQueue, al_get_joystick_event_source);
  al_register_event_source(FQueue, al_get_keyboard_event_source);
  al_register_event_source(FQueue, al_get_mouse_event_source);
  al_register_event_source(FQueue, al_get_touch_input_event_source);
  al_register_event_source(FQueue, al_get_touch_input_mouse_emulation_event_source);
  al_register_event_source(Queue , @FUserEventSrc);
  FLogger.Log('Initialized Allegro event queues', []);

  FCmdConActive.type_ := EVENT_CMDCON_ACTIVE;
  FCmdConInactive.type_ := EVENT_CMDCON_INACTIVE;

  // init audio
  if al_is_audio_installed then
  begin
    FVoice := al_create_voice(44100, ALLEGRO_AUDIO_DEPTH_INT16,  ALLEGRO_CHANNEL_CONF_2);
    FMixer := al_create_mixer(44100, ALLEGRO_AUDIO_DEPTH_FLOAT32,  ALLEGRO_CHANNEL_CONF_2);
    al_set_default_mixer(FMixer);
    al_attach_mixer_to_voice(FMixer, FVoice);
    al_reserve_samples(ALLEGRO_MAX_CHANNELS);
    FLogger.Log('Successfully setup Allegro audio', []);
  end;

  // init physfs
  al_store_state(@FFileState[False], ALLEGRO_STATE_NEW_FILE_INTERFACE);
  LOK := Boolean(PHYSFS_init(nil) <> 0);
  if LOk then FLogger.Log('Successfully initialized Allegro PHYSFS support', []) else FLogger.Log('Failed to initialize Allegro PHYSFS support', []);
  al_set_physfs_file_interface;
  al_store_state(@FFileState[True], ALLEGRO_STATE_NEW_FILE_INTERFACE);
end;

procedure TGV.ShutdownAllegro;
var
  LOk: Boolean;
begin
  if not al_is_system_installed then Exit;

  // shutdown physfs
  al_set_standard_file_interface;
  LOk := Boolean(PHYSFS_deinit <> 0);
  if LOk then FLogger.Log('Shutdown Allegro PHYSFS support', []) else FLogger.Log('Failed to shutdown Allegro PHYSFS support', []);

  // shutdown audio
  if al_is_audio_installed then
  begin
    al_stop_samples;
    al_detach_mixer(FMixer);
    al_destroy_mixer(FMixer);
    al_destroy_voice(FVoice);
    al_uninstall_audio;
    if LOk then FLogger.Log('Shutdown Allegro audio support', []) else FLogger.Log('Failed to shutdown Allegro audio support', []);
  end;

  // shutdown event queues
  if al_is_event_source_registered(FQueue, al_get_touch_input_mouse_emulation_event_source) then
    al_unregister_event_source(FQueue, al_get_touch_input_mouse_emulation_event_source);

  if al_is_event_source_registered(FQueue, al_get_touch_input_event_source) then
    al_unregister_event_source(FQueue, al_get_touch_input_event_source);

  if al_is_event_source_registered(FQueue, al_get_keyboard_event_source) then
    al_unregister_event_source(FQueue, al_get_keyboard_event_source);

  if al_is_event_source_registered(FQueue, al_get_mouse_event_source) then
    al_unregister_event_source(FQueue, al_get_mouse_event_source);

  if al_is_event_source_registered(FQueue, al_get_joystick_event_source) then
    al_unregister_event_source(FQueue, al_get_joystick_event_source);
  FLogger.Log('Shutdown Allegro event queues', []);

  // shutdown devices
  if al_is_touch_input_installed then
  begin
    al_uninstall_touch_input;
  end;

  if al_is_mouse_installed then
  begin
    al_uninstall_mouse;
  end;

  if al_is_keyboard_installed then
  begin
    al_uninstall_keyboard;
  end;

  if al_is_joystick_installed then
  begin
    al_uninstall_joystick;
  end;

  if al_is_system_installed then
  begin
    al_uninstall_system;
  end;
end;

constructor TGV.Create;
begin
  inherited;
  FLogger := TGVLogger.Create;
  FMasterObjectList := TGVObjectList.Create;
  GV := Self;
  FLogger.Log('Starting up GameVision Toolkit v%s', [GV_VERSION]);
  TGVDeps.Load;
  FCodePage := GetConsoleOutputCP;
  SetConsoleOutputCP(WinApi.Windows.CP_UTF8);
  StartupAllegro;
  FMath := TGVMath.Create;
  FConsole := TGVConsole.Create;
  FCmdLine := TGVCmdLine.Create;
  FWindow := TGVWindow.Create;
  FPrimitive := TGVPrimitive.Create;
  FInput := TGVInput.Create;
  FAudio := TGVAudio.Create;
  FAsync := TGVAsync.Create;
  FSpeech := TGVSpeech.Create;
  FVideo := TGVVideo.Create;
  FScreenshot := TGVScreenshot.Create;
  FScreenshake := TGVScreenshake.Create;
  FCollision := TGVCollision.Create;
  FGUI := TGVGUI.Create;
  FCmdConsole := TGVCmdConsole.Create;
  FLua := TGVLua.Create;
end;

destructor TGV.Destroy;
begin
  FreeAndNil(FCmdConsole);
  FreeAndNil(FGUI);
  FreeAndNil(FCollision);
  FreeAndNil(FScreenshake);
  FreeAndNil(FScreenshot);
  FreeAndNil(FVideo);
  FreeAndNil(FSpeech);
  FreeAndNil(FAsync);
  FreeAndNil(FAudio);
  FreeAndNil(FInput);
  FreeAndNil(FPrimitive);
  FreeAndNil(FWindow);
  FreeAndNil(FCmdLine);
  FreeAndNil(FConsole);
  FreeAndNil(FMath);
  FreeAndNil(FLua);
  FMasterObjectList.Clean;
  ShutdownAllegro;
  FLogger.Log('Shutdown GameVision Toolkit', []);
  FreeAndNil(FMasterObjectList);
  FreeAndNil(FLogger);
  GV := nil;
  inherited;
end;

procedure TGV.EmitCmdConInactiveEvent;
begin
  al_emit_user_event(@FUserEventSrc , @FCmdConInactive , nil);
end;

procedure TGV.EmitCmdConActiveEvent;
begin
  al_emit_user_event(@FUserEventSrc , @FCmdConActive , nil);
end;

procedure TGV.SetFileSandBoxed(aEnable: Boolean);
begin
  al_restore_state(@FFileState[aEnable]);
end;

function  TGV.GetFileSandBoxed: Boolean;
begin
  Result := Boolean(al_get_new_file_interface = @FFileState[True]);
end;

procedure TGV.SetFileSandboxWriteDir(aPath: string);
var
  LMarshaller: TMarshaller;
begin
  PHYSFS_setWriteDir(LMarshaller.AsUtf8(aPath).ToPointer);
end;

function  TGV.GetFileSandboxWriteDir: string;
begin
  Result := string(PHYSFS_getWriteDir);
end;

procedure TGV.Run(aGame: TGVCustomGameClass);
var
  LGame: TGVCustomGame;
begin
  {$IFDEF DEBUG}
  LGame := aGame.Create;
  try
    LGame.OnProcessCmdLine;
    LGame.OnStartup;
    try
      LGame.OnRun;
    finally
      LGame.OnShutdown;
    end;
  finally
    FreeAndNil(LGame);
  end;
  {$ELSE}
  LGame := aGame.Create;
  LGame.OnProcessCmdLine;
  LGame.OnStartup;
  LGame.OnRun;
  LGame.OnShutdown;
  FreeAndNil(LGame);
  {$ENDIF}
end;

procedure TGV.Run(aGame: TGVGameClass);
var
  LGame: TGVGame;
  LSettings: TGVGameSettings;
begin
  {$IFDEF DEBUG}
  LGame := aGame.Create;
  try
    LGame.OnProcessCmdLine;
    LGame.OnPreStartup;
    try
      LGame.OnSetSettings(LSettings);
      LGame.Settings := LSettings;
      LGame.OpenArchive;
      try
        LGame.OnLoadConfig;
        try
          if not LGame.OnStartupDialog then
            LGame.OnRun
          else
            while LGame.ProcessStartupDialog do
              LGame.OnRun;
        finally
          LGame.OnSaveConfig;
        end;
      finally
        LGame.CloseArchive;
      end;
    finally
      LGame.OnPostStartup;
    end;
  finally
    FreeAndNil(LGame);
  end;
  {$ELSE}
  LGame := aGame.Create;
  LGame.OnProcessCmdLine;
  LGame.OnPreStartup;
  LGame.OnSetSettings(LSettings);
  LGame.Settings := LSettings;
  LGame.OpenArchive;
  LGame.OnLoadConfig;
  if not LGame.OnStartupDialog then
    LGame.OnRun
  else
    while LGame.ProcessStartupDialog do
      LGame.OnRun;
  LGame.OnSaveConfig;
  LGame.CloseArchive;
  LGame.OnPostStartup;
  FreeAndNil(LGame);
  {$ENDIF}
end;

end.
