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

unit GameVision.Shader;

{$I GameVision.Defines.inc}

interface

uses
  System.SysUtils,
  GameVision.Allegro,
  GameVision.Math,
  GameVision.Base,
  GameVision.Archive,
  GameVision.Texture;

type
  { TGVShaderType }
  TGVShaderType = (stVertex=1, stFragment=2);

  { TGVShader }
  TGVShader = class(TGVObject)
  protected
    FHandle: PALLEGRO_SHADER;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Clear;
    function Load(aType: TGVShaderType; const aSource: string): Boolean; overload;
    function Load(aArchive: TGVArchive; aType: TGVShaderType; const aFilename: string): Boolean; overload;
    function Build: Boolean;
    function Enable(aEnable: Boolean): Boolean;
    function Log: string;
    function SetIntUniform(const aName: string; aValue: Integer): Boolean; overload;
    function SetIntUniform(const aName: string; aNumComponents: Integer; aValue: PInteger; aNumElements: Integer): Boolean; overload;
    function SetFloatUniform(const aName: string; aValue: Single): Boolean; overload;
    function SetFloatUniform(const aName: string; aNumComponents: Integer; aValue: System.PSingle; aNumElements: Integer): Boolean; overload;
    function SetBoolUniform(const aName: string; aValue: Boolean): Boolean;
    function SetTextureUniform(const aName: string; aTexture: TGVTexture): Boolean;
    function SetVec2Uniform(const aName: string; aValue: TGVVector): Boolean; overload;
    function SetVec2Uniform(const aName: string; aX: Single; aY: Single): Boolean; overload;
  end;

implementation

uses
  System.IOUtils,
  WinApi.Windows,
  GameVision.Core;

{ TGVShader }
constructor TGVShader.Create;
begin
  inherited;
  FHandle := al_create_shader(ALLEGRO_SHADER_GLSL);
  Clear;
end;

destructor TGVShader.Destroy;
begin
  if FHandle <> nil then al_destroy_shader(FHandle);
  inherited;
end;

procedure TGVShader.Clear;
begin
  if FHandle = nil then Exit;
  al_use_shader(nil);
  al_attach_shader_source(FHandle, ALLEGRO_VERTEX_SHADER, nil);
  al_attach_shader_source(FHandle, ALLEGRO_PIXEL_SHADER, nil);

  al_attach_shader_source(FHandle, ALLEGRO_VERTEX_SHADER,
    al_get_default_shader_source(ALLEGRO_SHADER_GLSL, ALLEGRO_VERTEX_SHADER));

  al_attach_shader_source(FHandle, ALLEGRO_PIXEL_SHADER,
    al_get_default_shader_source(ALLEGRO_SHADER_GLSL, ALLEGRO_PIXEL_SHADER));
end;

function TGVShader.Load(aType: TGVShaderType; const aSource: string): Boolean;
var
  LMarshaller: TMarshaller;
begin
  Result := False;
  if FHandle = nil then Exit;
  if aSource.IsEmpty then Exit;
  al_attach_shader_source(FHandle, Ord(aType), nil);
  Result := al_attach_shader_source(FHandle, Ord(aType), LMarshaller.AsUtf8(aSource).ToPointer);
end;

function TGVShader.Load(aArchive: TGVArchive; aType: TGVShaderType; const aFilename: string): Boolean;
var
  LMarshaller: TMarshaller;
begin
  Result := False;
  if FHandle = nil then Exit;
  if aFilename.IsEmpty then Exit;

  if aArchive <> nil then
    begin
      if not aArchive.IsOpen then Exit;
      if not aArchive.FileExist(aFilename) then Exit;
      al_attach_shader_source(FHandle, Ord(aType), nil);
      if not al_attach_shader_source_file(FHandle, Ord(aType), aArchive.GetPasswordFilename(aFilename)) then Exit;
    end
  else
    begin   //ALLEGRO_PIXEL_SHADER
      if not TFile.Exists(aFilename) then Exit;
      if aArchive = nil then GV.SetFileSandBoxed(False);
      if not al_attach_shader_source_file(FHandle, Ord(aType), LMarshaller.AsUtf8(aFilename).ToPointer) then Exit;
      if aArchive = nil then GV.SetFileSandBoxed(True);
    end;

  Result := True;
end;

function TGVShader.Build: Boolean;
begin
  Result := False;
  if FHandle = nil then Exit;
  Result := al_build_shader(FHandle);
end;

function TGVShader.Enable(aEnable: Boolean): Boolean;
begin
  Result := False;
  if FHandle = nil then Exit;
  if aEnable then
    Result := al_use_shader(FHandle)
  else
    Result := al_use_shader(nil);
end;

function TGVShader.Log: string;
begin
  Result := '';
  if FHandle = nil then Exit;
  Result := string(al_get_shader_log(FHandle));
end;

function TGVShader.SetIntUniform(const aName: string; aValue: Integer): Boolean;
var
  LMarshaller: TMarshaller;
begin
  Result := False;
  if aName = '' then Exit;
  if FHandle = nil then Exit;
  Result := al_set_shader_int(LMarshaller.AsAnsi(aName).ToPointer, aValue);
end;

function TGVShader.SetIntUniform(const aName: string; aNumComponents: Integer; aValue: PInteger; aNumElements: Integer): Boolean;
var
  LMarshaller: TMarshaller;
begin
  Result := False;
  if aName = '' then Exit;
  if FHandle = nil then Exit;
  Result := al_set_shader_int_vector(LMarshaller.AsAnsi(aName).ToPointer, aNumComponents, aValue, aNumElements);
end;

function TGVShader.SetFloatUniform(const aName: string; aValue: Single): Boolean;
var
  LMarshaller: TMarshaller;
begin
  Result := False;
  if aName = '' then Exit;
  if FHandle = nil then Exit;
  Result := al_set_shader_float(LMarshaller.AsAnsi(aName).ToPointer, aValue);
end;

function TGVShader.SetFloatUniform(const aName: string; aNumComponents: Integer; aValue: System.PSingle; aNumElements: Integer): Boolean;
var
  LMarshaller: TMarshaller;
begin
  Result := False;
  if aName = '' then Exit;
  if FHandle = nil then Exit;
  Result := al_set_shader_float_vector(LMarshaller.AsAnsi(aName).ToPointer, aNumComponents, aValue, aNumElements);
end;

function TGVShader.SetBoolUniform(const aName: string; aValue: Boolean): Boolean;
var
  LMarshaller: TMarshaller;
begin
  Result := False;
  if aName = '' then Exit;
  if FHandle = nil then Exit;
  Result := al_set_shader_bool(LMarshaller.AsAnsi(aName).ToPointer, aValue);
end;

function TGVShader.SetTextureUniform(const aName: string; aTexture: TGVTexture): Boolean;
var
  LMarshaller: TMarshaller;
begin
  Result := False;
  if aName = '' then Exit;
  if FHandle = nil then Exit;
  if aTexture = nil then Exit;
  Result := al_set_shader_sampler(LMarshaller.AsAnsi(aName).ToPointer, aTexture.Handle, 1);
end;

function TGVShader.SetVec2Uniform(const aName: string; aValue: TGVVector): Boolean;
var
  LVec2: array[0..1] of Single;
begin
  LVec2[0] := aValue.X;
  LVec2[1] := aValue.Y;
  Result := SetFloatUniform(aName, 2, @LVec2, 1);
end;

function TGVShader.SetVec2Uniform(const aName: string; aX: Single; aY: Single): Boolean;
var
  LVec2: array[0..1] of Single;
begin
  LVec2[0] := aX;
  LVec2[1] := aY;
  Result := SetFloatUniform(aName, 2, @LVec2, 1);
end;

end.
