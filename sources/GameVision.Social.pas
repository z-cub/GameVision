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

unit GameVision.Social;

{$I GameVision.Defines.inc}

interface

uses
  System.SysUtils,
  GameVision.Base;

type

  { TGVSocialPostEvent }
  TGVSocialPostEvent = procedure(const aSuccess: Boolean; const aErrorMsg: string; const aMsg: string;
    const aMediaFilename: string) of object;

  { TGVSocial }
  TGVSocial = class(TGVObject)
  protected
    FApiKey: string;
    FMediaFilename: string;
    FOnPost: TGVSocialPostEvent;
    FBusy: Boolean;
    FError: string;
    FSuccess: Boolean;
    procedure DoPost(aAccountId: string; const aMsg: string; const aMediaFilename: string='');
    procedure OnPostEvent(const aSuccess: Boolean; const aErrorMsg: string; const aMsg: string; const aMediaFilename: string);
  public
    property Busy: Boolean read FBusy;
    constructor Create; override;
    destructor Destroy; override;
    procedure Setup(const aApiKey: string; aHandler: TGVSocialPostEvent);
    procedure SaveAccounts(const aFilename: string);
    procedure Post(aAccountId: string; const aMsg: string; const aMediaFilename: string='');
  end;

implementation

uses
  System.Classes,
  System.IOUtils,
  System.Net.HttpClient,
  System.Net.URLClient,
  System.Net.Mime,
  GameVision.Json,
  GameVision.Core;

{ TGVSocial }
procedure TGVSocial.DoPost(aAccountId: string; const aMsg: string; const aMediaFilename: string='');
var
  LFormData: TMultipartFormData;
  LHttpClient: THTTPClient;
  LString: string;
  LJson: TGVJsonObject;
begin
  if FApiKey.IsEmpty then Exit;
  if aAccountId.IsEmpty then Exit;
  if aMsg.IsEmpty then Exit;

  FMediaFilename := '';
  FSuccess := False;
  FError := '';

  if not aMediaFilename.IsEmpty then
  begin
    if TFile.Exists(aMediaFilename) then
      FMediaFilename := aMediaFilename
  end;

  LFormData := TMultipartFormData.Create;
  try
    LHttpClient := THTTPClient.Create;
    try
      LFormData.AddField('key', FApiKey);
      LFormData.AddField('id', aAccountId);
      LFormData.AddField('msg', aMsg);
      if not FMediaFilename.IsEmpty then
        LFormData.AddFile('media', FMediaFilename);
      LString := LHttpClient.Post('https://api.dlvrit.com/1/postToAccount.json', LFormData).ContentAsString;
      LJson := TGVJsonObject.Parse(LString) as TGVJsonObject;
      try
        if LJson.Contains('errors') then
          FError :=  LJson.O['errors'].Items[0].Value
        else
          FSuccess := True;
      finally
        FreeAndNil(LJson);
      end;
    finally
      FreeAndNil(LHttpClient);
    end;
  finally
    FreeAndNil(LFormData);
  end;
end;

procedure TGVSocial.OnPostEvent(const aSuccess: Boolean; const aErrorMsg: string; const aMsg: string; const aMediaFilename: string);
begin
  if not Assigned(FOnPost) then Exit;
  FOnPost(aSuccess, aErrorMsg, aMsg, aMediaFilename);
end;

constructor TGVSocial.Create;
begin
  inherited;
  FApiKey := '';
  FMediaFilename := '';
  FOnPost := nil;
end;

destructor TGVSocial.Destroy;
begin
  inherited;
end;

procedure TGVSocial.Setup(const aApiKey: string; aHandler: TGVSocialPostEvent);
begin
  FApiKey := aApiKey;
  FOnPost := aHandler;
  FBusy := False;
end;

procedure TGVSocial.SaveAccounts(const aFilename: string);
var
  LFormData: TMultipartFormData;
  LHttpClient: THTTPClient;
  LString: string;
  LJson: TGVJsonObject;
  LIndex,LCount: Integer;
  LFile: TStringList;
begin
  if FApiKey.IsEmpty then Exit;
  if aFilename.IsEmpty then Exit;

  LFile := TStringList.Create;
  try
    LFormData := TMultipartFormData.Create;
    try
      LHttpClient := THTTPClient.Create;
      try
        LFormData.AddField('key', FApiKey);
        LString := LHttpClient.Post('https://api.dlvrit.com/1/accounts.json', LFormData).ContentAsString;
        LJson := TGVJsonObject.Parse(LString) as TGVJsonObject;
        try
          if LJson.Contains('errors') then Exit;
          LCount := LJson.A['accounts'].Count;
          for LIndex := 0 to LCount-1 do
          begin
            LString := Format(
              'account id="%s", name="%s", service="%s", url="%s"',
              [
              LJson.A['accounts'].Values[LIndex].S['id'],
              LJson.A['accounts'].Values[LIndex].S['name'],
              LJson.A['accounts'].Values[LIndex].S['service'],
              LJson.A['accounts'].Values[LIndex].S['url']
              ]
            );
            LFile.Add(LString);
          end;
          LFile.SaveToFile(aFilename);

        finally
          FreeAndNil(LJson);
        end;
      finally
        FreeAndNil(LHttpClient);
      end;
    finally
      FreeAndNil(LFormData);
    end;
  finally
    FreeAndNil(LFile);
  end;
end;

procedure TGVSocial.Post(aAccountId: string; const aMsg: string; const aMediaFilename: string='');
begin
  if FBusy then Exit;
  if FApiKey.IsEmpty then Exit;
  if aAccountId.IsEmpty then Exit;
  if aMsg.IsEmpty then Exit;

  GV.Async.Run(
    'TGVSocial',
    procedure
    begin
      FBusy := True;
      FError := '';
      FSuccess := False;
      DoPost(aAccountId, aMsg, aMediaFilename);
    end,
    procedure
    begin
      OnPostEvent(FSuccess, FError, aMsg, aMediaFilename);
      FBusy := False;
    end
  )
end;

end.
