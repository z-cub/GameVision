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

unit GameVision.Mail;

{$I GameVision.Defines.inc}

interface

uses
  System.SysUtils,
  GameVision.Base,
  IdGlobal,
  IdSMTP,
  IdMessage,
  IdReplySMTP,
  IdSSLOpenSSL,
  IdText,
  IdAttachment,
  IdAttachmentFile,
  IdAttachmentMemory,
  IdExplicitTLSClientServerBase,
  IdHTTP;

type
  { TGVMailSendEvent }
  TGVMailSendEvent = procedure(const aFromEmail, aFromName, aSubject, aTo, aCC, aBC, aReplyTo, aBody, aError: string) of object;

  { TGVMail }
  TGVMail = class(TGVObject)
  protected
    FSmtp: TIdSMTP;
    FSSLHandler: TIdSSLIOHandlerSocketOpenSSL;
    FLastError: string;
    FBusy: Boolean;
    FOnSend: TGVMailSendEvent;
    procedure DoSend(const aFromEmail, aFromName, aSubject, aTo, aCC, aBC, aReplyTo, aBody: string);
    procedure DoSendEvent(const aFromEmail, aFromName, aSubject, aTo, aCC, aBC, aReplyTo, aBody, aError: string);
  public
    property Busy: Boolean read FBusy;
    property LastError: string read FLastError;
    constructor Create; override;
    destructor Destroy; override;
    procedure Setup(const aHost: string; aPort: Word; const aUsername: string; const aPassword: string; aHandler: TGVMailSendEvent);
    procedure Send(const aFromEmail, aFromName, aSubject, aTo, aCC, aBC, aReplyTo, aBody: string);
  end;

implementation

uses
  GameVision.Core;

{ TGVMail }
procedure TGVMail.DoSend(const aFromEmail, aFromName, aSubject, aTo, aCC, aBC, aReplyTo, aBody: string);
var
  LEmail: string;
  LMsg : TIdMessage;
  LBody : TIdText;
begin
  LMsg := TIdMessage.Create;
  try
    LMsg.From.Address := aFromEmail;
    LMsg.From.Name := aFromName;
    LMsg.Subject := aSubject;
    for LEmail in aTo.Split([',',';']) do LMsg.Recipients.Add.Address := LEmail;
    for LEmail in aCC.Split([',',';']) do LMsg.CCList.Add.Address := LEmail;
    for LEmail in aBC.Split([',',';']) do LMsg.BCCList.Add.Address := LEmail;
    for LEmail in aReplyTo.Split([',',';']) do LMsg.ReplyTo.Add.Address := LEmail;
    LBody := TIdText.Create(LMsg.MessageParts);
    try
      LBody.ContentType := 'text/html';
      LBody.CharSet:= 'utf-8';
      LBody.Body.Text := aBody;

      try
        FSmtp.Connect;
        if FSmtp.Connected then
        begin
          FSmtp.Send(LMsg);
          FSmtp.Disconnect(False);
        end;
      except
        //on E : Exception do raise Exception.Create(Format('[%s] : %s',[Self.ClassName,e.Message]));
        on E: Exception do
          FLastError := E.Message;
      end;

    finally
      FreeAndNil(LBody);
    end;
  finally
    FreeAndNil(LMsg);
  end;
end;

procedure TGVMail.DoSendEvent(const aFromEmail, aFromName, aSubject, aTo, aCC, aBC, aReplyTo, aBody, aError: string);
begin
  if not Assigned(FOnSend) then Exit;
  FOnSend(aFromEmail, aFromName, aSubject, aTo, aCC, aBC, aReplyTo, aBody, aError);
end;

constructor TGVMail.Create;
begin
  inherited;
  FSmtp := TIdSMTP.Create;
  FSSLHandler := TIdSSLIOHandlerSocketOpenSSL.Create;
  FSmtp.IOHandler := FSSLHandler;
  FSmtp.Port := 465;
  FSSLHandler.MaxLineAction := maException;
  FSSLHandler.SSLOptions.Method := sslvTLSv1_2;
  FSSLHandler.SSLOptions.Mode := sslmUnassigned;
  FSSLHandler.SSLOptions.VerifyMode := [];
  FSSLHandler.SSLOptions.VerifyDepth := 0;
  FSmtp.UseTLS := utUseImplicitTLS;
  FSmtp.AuthType := TIdSMTPAuthenticationType.satDefault;
end;

destructor TGVMail.Destroy;
begin
  FreeAndNil(FSSLHandler);
  FreeAndNil(FSmtp);
  inherited;
end;

procedure TGVMail.Setup(const aHost: string; aPort: Word; const aUsername: string; const aPassword: string; aHandler: TGVMailSendEvent);
begin
  FSmtp.Host := aHost;
  FSmtp.Port := aPort;
  FSmtp.Username := aUsername;
  FSmtp.Password := aPassword;
  if FSmtp.Port = 465 then
    FSmtp.UseTLS := utUseImplicitTLS
  else
    FSmtp.UseTLS := utUseExplicitTLS;
  FOnSend := aHandler;
end;

procedure TGVMail.Send(const aFromEmail, aFromName, aSubject, aTo, aCC, aBC, aReplyTo, aBody: string);
begin
  if FBusy then Exit;

  FLastError := '';

  GV.Async.Run(
    'TGVMail',
    procedure
    begin
      FBusy := True;
      DoSend(aFromEmail, aFromName, aSubject, aTo, aCC, aBC, aReplyTo, aBody);
    end,
    procedure
    begin
      DoSendEvent(aFromEmail, aFromName, aSubject, aTo, aCC, aBC, aReplyTo, aBody, FLastError);
      FBusy := False;
    end
  );
end;

end.
