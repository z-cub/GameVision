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

unit GameVision.HTTP;

{$I GameVision.Defines.inc}

interface

uses
  System.SysUtils,
  System.Classes,
  System.Net.HttpClient,
  System.Net.URLClient,
  System.Net.Mime,
  GameVision.Base;

type
  { TGVHttpOperation }
  TGVHttpOperation = (hoGet, hoPost);

  { TGVHttpEvent }
  TGVHttpOperationEvent = procedure(aOperation: TGVHttpOperation; const aResult: string) of object;

  { TGVHttp }
  TGVHttp = class(TGVObject)
  protected
    FHttpClient: THTTPClient;
    FFormData: TMultipartFormData;
    FOnOperation: TGVHttpOperationEvent;
    FBusy: Boolean;
    function DoGet(const aURL: string): string;
    function DoPost(const aURL: string; aSource: TStream=nil): string;
    procedure DoOperationEvent(aOperation: TGVHttpOperation; const aResult: string);
  public
    property Busy: Boolean read FBusy;
    property FormData: TMultipartFormData read FFormData;
    property OnOperation: TGVHttpOperationEvent read FOnOperation write FOnOperation;
    constructor Create; override;
    destructor Destroy; override;
    procedure ClearCustomHeaders;
    procedure SetCustomHeader(const aKey: string; const aValue: string);
    procedure ClearFormData;
    procedure SetContentType(const aType: string);
    procedure Get(const aURL: string);
    procedure Post(const aURL: string; aSource: TStream=nil);
  end;

implementation

uses
  System.NetConsts,
  GameVision.Core;

{ TGVHttp }
function TGVHttp.DoGet(const aURL: string): string;
begin
  try
    Result := FHttpClient.Get(aURL).ContentAsString;
  except
    on E: Exception do
      Result := E.Message;
  end;
end;

function TGVHttp.DoPost(const aURL: string; aSource: TStream=nil): string;
begin
  try
  if aSource = nil then
    Result := FHttpClient.Post(aURL, FFormData).ContentAsString
  else
    Result := FHttpClient.Post(aURL, aSource).ContentAsString;
  except
    on E: Exception do
      Result := E.Message;
  end;
end;

procedure TGVHttp.DoOperationEvent(aOperation: TGVHttpOperation; const aResult: string);
begin
  if not Assigned(FOnOperation) then Exit;
  FOnOperation(aOperation, aResult);
end;

constructor TGVHttp.Create;
begin
  inherited;
  FHttpClient := THTTPClient.Create;
  FFormData := TMultipartFormData.Create;
end;

destructor TGVHttp.Destroy;
begin
  FreeAndNil(FFormData);
  FreeAndNil(FHttpClient);
  inherited;
end;

procedure TGVHttp.ClearCustomHeaders;
begin
  FHttpClient.CustHeaders.Clear;
end;

procedure TGVHttp.SetCustomHeader(const aKey: string; const aValue: string);
begin
  FHttpClient.CustHeaders[aKey] := aValue;
end;

procedure TGVHttp.ClearFormData;
begin
  FreeAndNil(FFormData);
  FFormData := TMultipartFormData.Create;
end;

procedure TGVHttp.SetContentType(const aType: string);
begin
  FHttpClient.ContentType := aType;
end;

procedure TGVHttp.Get(const aURL: string);
var
  LResult: string;
begin
  if FBusy then Exit;
  if aURL.IsEmpty then Exit;

  GV.Async.Run(
    'TGVHttp',
    procedure
    begin
      FBusy := True;
      LResult := DoGet(aURL);
    end,
    procedure
    begin
      DoOperationEvent(hoGet, LResult);
      FBusy := False;
    end
  );
end;

procedure TGVHttp.Post(const aURL: string; aSource: TStream=nil);
var
  LResult: string;
begin
  if FBusy then Exit;
  if aURL.IsEmpty then Exit;

  GV.Async.Run(
    'TGVHttp',
    procedure
    begin
      FBusy := True;
      LResult := DoPost(aURL, aSource);
    end,
    procedure
    begin
      DoOperationEvent(hoPost, LResult);
      FBusy := False;
    end
  );
end;

end.
