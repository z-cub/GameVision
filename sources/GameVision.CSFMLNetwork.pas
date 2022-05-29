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

unit GameVision.CSFMLNetwork;

{$I GameVision.Defines.inc}

{$MINENUMSIZE 4}
{$WARN SYMBOL_PLATFORM OFF}

interface

const
  CSFML_NETWORK_DLL = 'csfml-network-2.dll';

type
  sfFtpTransferMode = Integer;
  PsfFtpTransferMode = ^sfFtpTransferMode;

const
  sfFtpBinary = 0;
  sfFtpAscii = 1;
  sfFtpEbcdic = 2;

type
  sfFtpStatus = Integer;
  PsfFtpStatus = ^sfFtpStatus;

const
  sfFtpRestartMarkerReply = 110;
  sfFtpServiceReadySoon = 120;
  sfFtpDataConnectionAlreadyOpened = 125;
  sfFtpOpeningDataConnection = 150;
  sfFtpOk = 200;
  sfFtpPointlessCommand = 202;
  sfFtpSystemStatus = 211;
  sfFtpDirectoryStatus = 212;
  sfFtpFileStatus = 213;
  sfFtpHelpMessage = 214;
  sfFtpSystemType = 215;
  sfFtpServiceReady = 220;
  sfFtpClosingConnection = 221;
  sfFtpDataConnectionOpened = 225;
  sfFtpClosingDataConnection = 226;
  sfFtpEnteringPassiveMode = 227;
  sfFtpLoggedIn = 230;
  sfFtpFileActionOk = 250;
  sfFtpDirectoryOk = 257;
  sfFtpNeedPassword = 331;
  sfFtpNeedAccountToLogIn = 332;
  sfFtpNeedInformation = 350;
  sfFtpServiceUnavailable = 421;
  sfFtpDataConnectionUnavailable = 425;
  sfFtpTransferAborted = 426;
  sfFtpFileActionAborted = 450;
  sfFtpLocalError = 451;
  sfFtpInsufficientStorageSpace = 452;
  sfFtpCommandUnknown = 500;
  sfFtpParametersUnknown = 501;
  sfFtpCommandNotImplemented = 502;
  sfFtpBadCommandSequence = 503;
  sfFtpParameterNotImplemented = 504;
  sfFtpNotLoggedIn = 530;
  sfFtpNeedAccountToStore = 532;
  sfFtpFileUnavailable = 550;
  sfFtpPageTypeUnknown = 551;
  sfFtpNotEnoughMemory = 552;
  sfFtpFilenameNotAllowed = 553;
  sfFtpInvalidResponse = 1000;
  sfFtpConnectionFailed = 1001;
  sfFtpConnectionClosed = 1002;
  sfFtpInvalidFile = 1003;

type
  sfHttpMethod = Integer;
  PsfHttpMethod = ^sfHttpMethod;

const
  sfHttpGet = 0;
  sfHttpPost = 1;
  sfHttpHead = 2;
  sfHttpPut = 3;
  sfHttpDelete = 4;

type
  sfHttpStatus = Integer;
  PsfHttpStatus = ^sfHttpStatus;

const
  sfHttpOk = 200;
  sfHttpCreated = 201;
  sfHttpAccepted = 202;
  sfHttpNoContent = 204;
  sfHttpResetContent = 205;
  sfHttpPartialContent = 206;
  sfHttpMultipleChoices = 300;
  sfHttpMovedPermanently = 301;
  sfHttpMovedTemporarily = 302;
  sfHttpNotModified = 304;
  sfHttpBadRequest = 400;
  sfHttpUnauthorized = 401;
  sfHttpForbidden = 403;
  sfHttpNotFound = 404;
  sfHttpRangeNotSatisfiable = 407;
  sfHttpInternalServerError = 500;
  sfHttpNotImplemented = 501;
  sfHttpBadGateway = 502;
  sfHttpServiceNotAvailable = 503;
  sfHttpGatewayTimeout = 504;
  sfHttpVersionNotSupported = 505;
  sfHttpInvalidResponse = 1000;
  sfHttpConnectionFailed = 1001;

type
  sfSocketStatus = Integer;
  PsfSocketStatus = ^sfSocketStatus;

const
  sfSocketDone = 0;
  sfSocketNotReady = 1;
  sfSocketPartial = 2;
  sfSocketDisconnected = 3;
  sfSocketError = 4;

type
  PsfTime = ^sfTime;
  PsfIpAddress = ^sfIpAddress;

  sfBool = Integer;
  sfInt8 = UTF8Char;
  sfUint8 = Byte;
  sfInt16 = Smallint;
  sfUint16 = Word;
  sfInt32 = Integer;
  sfUint32 = Cardinal;
  sfInt64 = Int64;
  sfUint64 = UInt64;

  sfTime = record
    microseconds: sfInt64;
  end;

  sfIpAddress = record
    address: array [0..15] of UTF8Char;
  end;

  PsfFtpDirectoryResponse = Pointer;
  PPsfFtpDirectoryResponse = ^PsfFtpDirectoryResponse;
  PsfFtpListingResponse = Pointer;
  PPsfFtpListingResponse = ^PsfFtpListingResponse;
  PsfFtpResponse = Pointer;
  PPsfFtpResponse = ^PsfFtpResponse;
  PsfFtp = Pointer;
  PPsfFtp = ^PsfFtp;
  PsfHttpRequest = Pointer;
  PPsfHttpRequest = ^PsfHttpRequest;
  PsfHttpResponse = Pointer;
  PPsfHttpResponse = ^PsfHttpResponse;
  PsfHttp = Pointer;
  PPsfHttp = ^PsfHttp;
  PsfPacket = Pointer;
  PPsfPacket = ^PsfPacket;
  PsfSocketSelector = Pointer;
  PPsfSocketSelector = ^PsfSocketSelector;
  PsfTcpListener = Pointer;
  PPsfTcpListener = ^PsfTcpListener;
  PsfTcpSocket = Pointer;
  PPsfTcpSocket = ^PsfTcpSocket;
  PsfUdpSocket = Pointer;
  PPsfUdpSocket = ^PsfUdpSocket;

function  sfIpAddress_fromString(const address: PUTF8Char): sfIpAddress; cdecl; external CSFML_NETWORK_DLL delayed;
function  sfIpAddress_fromBytes(byte0: sfUint8; byte1: sfUint8; byte2: sfUint8; byte3: sfUint8): sfIpAddress; cdecl; external CSFML_NETWORK_DLL delayed;
function  sfIpAddress_fromInteger(address: sfUint32): sfIpAddress; cdecl; external CSFML_NETWORK_DLL delayed;
procedure sfIpAddress_toString(address: sfIpAddress; string_: PUTF8Char); cdecl; external CSFML_NETWORK_DLL delayed;
function  sfIpAddress_toInteger(address: sfIpAddress): sfUint32; cdecl; external CSFML_NETWORK_DLL delayed;
function  sfIpAddress_getLocalAddress(): sfIpAddress; cdecl; external CSFML_NETWORK_DLL delayed;
function  sfIpAddress_getPublicAddress(timeout: sfTime): sfIpAddress; cdecl; external CSFML_NETWORK_DLL delayed;
procedure sfFtpListingResponse_destroy(ftpListingResponse: PsfFtpListingResponse); cdecl; external CSFML_NETWORK_DLL delayed;
function  sfFtpListingResponse_isOk(const ftpListingResponse: PsfFtpListingResponse): sfBool; cdecl; external CSFML_NETWORK_DLL delayed;
function  sfFtpListingResponse_getStatus(const ftpListingResponse: PsfFtpListingResponse): sfFtpStatus; cdecl; external CSFML_NETWORK_DLL delayed;
function  sfFtpListingResponse_getMessage(const ftpListingResponse: PsfFtpListingResponse): PUTF8Char; cdecl; external CSFML_NETWORK_DLL delayed;
function  sfFtpListingResponse_getCount(const ftpListingResponse: PsfFtpListingResponse): NativeUInt; cdecl; external CSFML_NETWORK_DLL delayed;
function  sfFtpListingResponse_getName(const ftpListingResponse: PsfFtpListingResponse; index: NativeUInt): PUTF8Char; cdecl; external CSFML_NETWORK_DLL delayed;
procedure sfFtpDirectoryResponse_destroy(ftpDirectoryResponse: PsfFtpDirectoryResponse); cdecl; external CSFML_NETWORK_DLL delayed;
function  sfFtpDirectoryResponse_isOk(const ftpDirectoryResponse: PsfFtpDirectoryResponse): sfBool; cdecl; external CSFML_NETWORK_DLL delayed;
function  sfFtpDirectoryResponse_getStatus(const ftpDirectoryResponse: PsfFtpDirectoryResponse): sfFtpStatus; cdecl; external CSFML_NETWORK_DLL delayed;
function  sfFtpDirectoryResponse_getMessage(const ftpDirectoryResponse: PsfFtpDirectoryResponse): PUTF8Char; cdecl; external CSFML_NETWORK_DLL delayed;
function  sfFtpDirectoryResponse_getDirectory(const ftpDirectoryResponse: PsfFtpDirectoryResponse): PUTF8Char; cdecl; external CSFML_NETWORK_DLL delayed;
procedure sfFtpResponse_destroy(ftpResponse: PsfFtpResponse); cdecl; external CSFML_NETWORK_DLL delayed;
function  sfFtpResponse_isOk(const ftpResponse: PsfFtpResponse): sfBool; cdecl; external CSFML_NETWORK_DLL delayed;
function  sfFtpResponse_getStatus(const ftpResponse: PsfFtpResponse): sfFtpStatus; cdecl; external CSFML_NETWORK_DLL delayed;
function  sfFtpResponse_getMessage(const ftpResponse: PsfFtpResponse): PUTF8Char; cdecl; external CSFML_NETWORK_DLL delayed;
function  sfFtp_create(): PsfFtp; cdecl; external CSFML_NETWORK_DLL delayed;
procedure sfFtp_destroy(ftp: PsfFtp); cdecl; external CSFML_NETWORK_DLL delayed;
function  sfFtp_connect(ftp: PsfFtp; server: sfIpAddress; port: Word; timeout: sfTime): PsfFtpResponse; cdecl; external CSFML_NETWORK_DLL delayed;
function  sfFtp_loginAnonymous(ftp: PsfFtp): PsfFtpResponse; cdecl; external CSFML_NETWORK_DLL delayed;
function  sfFtp_login(ftp: PsfFtp; const name: PUTF8Char; const password: PUTF8Char): PsfFtpResponse; cdecl; external CSFML_NETWORK_DLL delayed;
function  sfFtp_disconnect(ftp: PsfFtp): PsfFtpResponse; cdecl; external CSFML_NETWORK_DLL delayed;
function  sfFtp_keepAlive(ftp: PsfFtp): PsfFtpResponse; cdecl; external CSFML_NETWORK_DLL delayed;
function  sfFtp_getWorkingDirectory(ftp: PsfFtp): PsfFtpDirectoryResponse; cdecl; external CSFML_NETWORK_DLL delayed;
function  sfFtp_getDirectoryListing(ftp: PsfFtp; const directory: PUTF8Char): PsfFtpListingResponse; cdecl; external CSFML_NETWORK_DLL delayed;
function  sfFtp_changeDirectory(ftp: PsfFtp; const directory: PUTF8Char): PsfFtpResponse; cdecl; external CSFML_NETWORK_DLL delayed;
function  sfFtp_parentDirectory(ftp: PsfFtp): PsfFtpResponse; cdecl; external CSFML_NETWORK_DLL delayed;
function  sfFtp_createDirectory(ftp: PsfFtp; const name: PUTF8Char): PsfFtpResponse; cdecl; external CSFML_NETWORK_DLL delayed;
function  sfFtp_deleteDirectory(ftp: PsfFtp; const name: PUTF8Char): PsfFtpResponse; cdecl; external CSFML_NETWORK_DLL delayed;
function  sfFtp_renameFile(ftp: PsfFtp; const file_: PUTF8Char; const newName: PUTF8Char): PsfFtpResponse; cdecl; external CSFML_NETWORK_DLL delayed;
function  sfFtp_deleteFile(ftp: PsfFtp; const name: PUTF8Char): PsfFtpResponse; cdecl; external CSFML_NETWORK_DLL delayed;
function  sfFtp_download(ftp: PsfFtp; const remoteFile: PUTF8Char; const localPath: PUTF8Char; mode: sfFtpTransferMode): PsfFtpResponse; cdecl; external CSFML_NETWORK_DLL delayed;
function  sfFtp_upload(ftp: PsfFtp; const localFile: PUTF8Char; const remotePath: PUTF8Char; mode: sfFtpTransferMode; append: sfBool): PsfFtpResponse; cdecl; external CSFML_NETWORK_DLL delayed;
function  sfFtp_sendCommand(ftp: PsfFtp; const command: PUTF8Char; const parameter: PUTF8Char): PsfFtpResponse; cdecl; external CSFML_NETWORK_DLL delayed;
function  sfHttpRequest_create(): PsfHttpRequest; cdecl; external CSFML_NETWORK_DLL delayed;
procedure sfHttpRequest_destroy(httpRequest: PsfHttpRequest); cdecl; external CSFML_NETWORK_DLL delayed;
procedure sfHttpRequest_setField(httpRequest: PsfHttpRequest; const field: PUTF8Char; const value: PUTF8Char); cdecl; external CSFML_NETWORK_DLL delayed;
procedure sfHttpRequest_setMethod(httpRequest: PsfHttpRequest; method: sfHttpMethod); cdecl; external CSFML_NETWORK_DLL delayed;
procedure sfHttpRequest_setUri(httpRequest: PsfHttpRequest; const uri: PUTF8Char); cdecl; external CSFML_NETWORK_DLL delayed;
procedure sfHttpRequest_setHttpVersion(httpRequest: PsfHttpRequest; major: Cardinal; minor: Cardinal); cdecl; external CSFML_NETWORK_DLL delayed;
procedure sfHttpRequest_setBody(httpRequest: PsfHttpRequest; const body: PUTF8Char); cdecl; external CSFML_NETWORK_DLL delayed;
procedure sfHttpResponse_destroy(httpResponse: PsfHttpResponse); cdecl; external CSFML_NETWORK_DLL delayed;
function  sfHttpResponse_getField(const httpResponse: PsfHttpResponse; const field: PUTF8Char): PUTF8Char; cdecl; external CSFML_NETWORK_DLL delayed;
function  sfHttpResponse_getStatus(const httpResponse: PsfHttpResponse): sfHttpStatus; cdecl; external CSFML_NETWORK_DLL delayed;
function  sfHttpResponse_getMajorVersion(const httpResponse: PsfHttpResponse): Cardinal; cdecl; external CSFML_NETWORK_DLL delayed;
function  sfHttpResponse_getMinorVersion(const httpResponse: PsfHttpResponse): Cardinal; cdecl; external CSFML_NETWORK_DLL delayed;
function  sfHttpResponse_getBody(const httpResponse: PsfHttpResponse): PUTF8Char; cdecl; external CSFML_NETWORK_DLL delayed;
function  sfHttp_create(): PsfHttp; cdecl; external CSFML_NETWORK_DLL delayed;
procedure sfHttp_destroy(http: PsfHttp); cdecl; external CSFML_NETWORK_DLL delayed;
procedure sfHttp_setHost(http: PsfHttp; const host: PUTF8Char; port: Word); cdecl; external CSFML_NETWORK_DLL delayed;
function  sfHttp_sendRequest(http: PsfHttp; const request: PsfHttpRequest; timeout: sfTime): PsfHttpResponse; cdecl; external CSFML_NETWORK_DLL delayed;
function  sfPacket_create(): PsfPacket; cdecl; external CSFML_NETWORK_DLL delayed;
function  sfPacket_copy(const packet: PsfPacket): PsfPacket; cdecl; external CSFML_NETWORK_DLL delayed;
procedure sfPacket_destroy(packet: PsfPacket); cdecl; external CSFML_NETWORK_DLL delayed;
procedure sfPacket_append(packet: PsfPacket; const data: Pointer; sizeInBytes: NativeUInt); cdecl; external CSFML_NETWORK_DLL delayed;
procedure sfPacket_clear(packet: PsfPacket); cdecl; external CSFML_NETWORK_DLL delayed;
function  sfPacket_getData(const packet: PsfPacket): Pointer; cdecl; external CSFML_NETWORK_DLL delayed;
function  sfPacket_getDataSize(const packet: PsfPacket): NativeUInt; cdecl; external CSFML_NETWORK_DLL delayed;
function  sfPacket_endOfPacket(const packet: PsfPacket): sfBool; cdecl; external CSFML_NETWORK_DLL delayed;
function  sfPacket_canRead(const packet: PsfPacket): sfBool; cdecl; external CSFML_NETWORK_DLL delayed;
function  sfPacket_readBool(packet: PsfPacket): sfBool; cdecl; external CSFML_NETWORK_DLL delayed;
function  sfPacket_readInt8(packet: PsfPacket): sfInt8; cdecl; external CSFML_NETWORK_DLL delayed;
function  sfPacket_readUint8(packet: PsfPacket): sfUint8; cdecl; external CSFML_NETWORK_DLL delayed;
function  sfPacket_readInt16(packet: PsfPacket): sfInt16; cdecl; external CSFML_NETWORK_DLL delayed;
function  sfPacket_readUint16(packet: PsfPacket): sfUint16; cdecl; external CSFML_NETWORK_DLL delayed;
function  sfPacket_readInt32(packet: PsfPacket): sfInt32; cdecl; external CSFML_NETWORK_DLL delayed;
function  sfPacket_readUint32(packet: PsfPacket): sfUint32; cdecl; external CSFML_NETWORK_DLL delayed;
function  sfPacket_readFloat(packet: PsfPacket): Single; cdecl; external CSFML_NETWORK_DLL delayed;
function  sfPacket_readDouble(packet: PsfPacket): Double; cdecl; external CSFML_NETWORK_DLL delayed;
procedure sfPacket_readString(packet: PsfPacket; string_: PUTF8Char); cdecl; external CSFML_NETWORK_DLL delayed;
procedure sfPacket_readWideString(packet: PsfPacket; string_: PWideChar); cdecl; external CSFML_NETWORK_DLL delayed;
procedure sfPacket_writeBool(packet: PsfPacket; p2: sfBool); cdecl; external CSFML_NETWORK_DLL delayed;
procedure sfPacket_writeInt8(packet: PsfPacket; p2: sfInt8); cdecl; external CSFML_NETWORK_DLL delayed;
procedure sfPacket_writeUint8(packet: PsfPacket; p2: sfUint8); cdecl; external CSFML_NETWORK_DLL delayed;
procedure sfPacket_writeInt16(packet: PsfPacket; p2: sfInt16); cdecl; external CSFML_NETWORK_DLL delayed;
procedure sfPacket_writeUint16(packet: PsfPacket; p2: sfUint16); cdecl; external CSFML_NETWORK_DLL delayed;
procedure sfPacket_writeInt32(packet: PsfPacket; p2: sfInt32); cdecl; external CSFML_NETWORK_DLL delayed;
procedure sfPacket_writeUint32(packet: PsfPacket; p2: sfUint32); cdecl; external CSFML_NETWORK_DLL delayed;
procedure sfPacket_writeFloat(packet: PsfPacket; p2: Single); cdecl; external CSFML_NETWORK_DLL delayed;
procedure sfPacket_writeDouble(packet: PsfPacket; p2: Double); cdecl; external CSFML_NETWORK_DLL delayed;
procedure sfPacket_writeString(packet: PsfPacket; const string_: PUTF8Char); cdecl; external CSFML_NETWORK_DLL delayed;
procedure sfPacket_writeWideString(packet: PsfPacket; const string_: PWideChar); cdecl; external CSFML_NETWORK_DLL delayed;
function  sfSocketSelector_create(): PsfSocketSelector; cdecl; external CSFML_NETWORK_DLL delayed;
function  sfSocketSelector_copy(const selector: PsfSocketSelector): PsfSocketSelector; cdecl; external CSFML_NETWORK_DLL delayed;
procedure sfSocketSelector_destroy(selector: PsfSocketSelector); cdecl; external CSFML_NETWORK_DLL delayed;
procedure sfSocketSelector_addTcpListener(selector: PsfSocketSelector; socket: PsfTcpListener); cdecl; external CSFML_NETWORK_DLL delayed;
procedure sfSocketSelector_addTcpSocket(selector: PsfSocketSelector; socket: PsfTcpSocket); cdecl; external CSFML_NETWORK_DLL delayed;
procedure sfSocketSelector_addUdpSocket(selector: PsfSocketSelector; socket: PsfUdpSocket); cdecl; external CSFML_NETWORK_DLL delayed;
procedure sfSocketSelector_removeTcpListener(selector: PsfSocketSelector; socket: PsfTcpListener); cdecl; external CSFML_NETWORK_DLL delayed;
procedure sfSocketSelector_removeTcpSocket(selector: PsfSocketSelector; socket: PsfTcpSocket); cdecl; external CSFML_NETWORK_DLL delayed;
procedure sfSocketSelector_removeUdpSocket(selector: PsfSocketSelector; socket: PsfUdpSocket); cdecl; external CSFML_NETWORK_DLL delayed;
procedure sfSocketSelector_clear(selector: PsfSocketSelector); cdecl; external CSFML_NETWORK_DLL delayed;
function  sfSocketSelector_wait(selector: PsfSocketSelector; timeout: sfTime): sfBool; cdecl; external CSFML_NETWORK_DLL delayed;
function  sfSocketSelector_isTcpListenerReady(const selector: PsfSocketSelector; socket: PsfTcpListener): sfBool; cdecl; external CSFML_NETWORK_DLL delayed;
function  sfSocketSelector_isTcpSocketReady(const selector: PsfSocketSelector; socket: PsfTcpSocket): sfBool; cdecl; external CSFML_NETWORK_DLL delayed;
function  sfSocketSelector_isUdpSocketReady(const selector: PsfSocketSelector; socket: PsfUdpSocket): sfBool; cdecl; external CSFML_NETWORK_DLL delayed;
function  sfTcpListener_create(): PsfTcpListener; cdecl; external CSFML_NETWORK_DLL delayed;
procedure sfTcpListener_destroy(listener: PsfTcpListener); cdecl; external CSFML_NETWORK_DLL delayed;
procedure sfTcpListener_setBlocking(listener: PsfTcpListener; blocking: sfBool); cdecl; external CSFML_NETWORK_DLL delayed;
function  sfTcpListener_isBlocking(const listener: PsfTcpListener): sfBool; cdecl; external CSFML_NETWORK_DLL delayed;
function  sfTcpListener_getLocalPort(const listener: PsfTcpListener): Word; cdecl; external CSFML_NETWORK_DLL delayed;
function  sfTcpListener_listen(listener: PsfTcpListener; port: Word; address: sfIpAddress): sfSocketStatus; cdecl; external CSFML_NETWORK_DLL delayed;
function  sfTcpListener_accept(listener: PsfTcpListener; connected: PPsfTcpSocket): sfSocketStatus; cdecl; external CSFML_NETWORK_DLL delayed;
function  sfTcpSocket_create(): PsfTcpSocket; cdecl; external CSFML_NETWORK_DLL delayed;
procedure sfTcpSocket_destroy(socket: PsfTcpSocket); cdecl; external CSFML_NETWORK_DLL delayed;
procedure sfTcpSocket_setBlocking(socket: PsfTcpSocket; blocking: sfBool); cdecl; external CSFML_NETWORK_DLL delayed;
function  sfTcpSocket_isBlocking(const socket: PsfTcpSocket): sfBool; cdecl; external CSFML_NETWORK_DLL delayed;
function  sfTcpSocket_getLocalPort(const socket: PsfTcpSocket): Word; cdecl; external CSFML_NETWORK_DLL delayed;
function  sfTcpSocket_getRemoteAddress(const socket: PsfTcpSocket): sfIpAddress; cdecl; external CSFML_NETWORK_DLL delayed;
function  sfTcpSocket_getRemotePort(const socket: PsfTcpSocket): Word; cdecl; external CSFML_NETWORK_DLL delayed;
function  sfTcpSocket_connect(socket: PsfTcpSocket; remoteAddress: sfIpAddress; remotePort: Word; timeout: sfTime): sfSocketStatus; cdecl; external CSFML_NETWORK_DLL delayed;
procedure sfTcpSocket_disconnect(socket: PsfTcpSocket); cdecl; external CSFML_NETWORK_DLL delayed;
function  sfTcpSocket_send(socket: PsfTcpSocket; const data: Pointer; size: NativeUInt): sfSocketStatus; cdecl; external CSFML_NETWORK_DLL delayed;
function  sfTcpSocket_sendPartial(socket: PsfTcpSocket; const data: Pointer; size: NativeUInt; sent: PNativeUInt): sfSocketStatus; cdecl; external CSFML_NETWORK_DLL delayed;
function  sfTcpSocket_receive(socket: PsfTcpSocket; data: Pointer; size: NativeUInt; received: PNativeUInt): sfSocketStatus; cdecl; external CSFML_NETWORK_DLL delayed;
function  sfTcpSocket_sendPacket(socket: PsfTcpSocket; packet: PsfPacket): sfSocketStatus; cdecl; external CSFML_NETWORK_DLL delayed;
function  sfTcpSocket_receivePacket(socket: PsfTcpSocket; packet: PsfPacket): sfSocketStatus; cdecl; external CSFML_NETWORK_DLL delayed;
function  sfUdpSocket_create(): PsfUdpSocket; cdecl; external CSFML_NETWORK_DLL delayed;
procedure sfUdpSocket_destroy(socket: PsfUdpSocket); cdecl; external CSFML_NETWORK_DLL delayed;
procedure sfUdpSocket_setBlocking(socket: PsfUdpSocket; blocking: sfBool); cdecl; external CSFML_NETWORK_DLL delayed;
function  sfUdpSocket_isBlocking(const socket: PsfUdpSocket): sfBool; cdecl; external CSFML_NETWORK_DLL delayed;
function  sfUdpSocket_getLocalPort(const socket: PsfUdpSocket): Word; cdecl; external CSFML_NETWORK_DLL delayed;
function  sfUdpSocket_bind(socket: PsfUdpSocket; port: Word; address: sfIpAddress): sfSocketStatus; cdecl; external CSFML_NETWORK_DLL delayed;
procedure sfUdpSocket_unbind(socket: PsfUdpSocket); cdecl; external CSFML_NETWORK_DLL delayed;
function  sfUdpSocket_send(socket: PsfUdpSocket; const data: Pointer; size: NativeUInt; remoteAddress: sfIpAddress; remotePort: Word): sfSocketStatus; cdecl; external CSFML_NETWORK_DLL delayed;
function  sfUdpSocket_receive(socket: PsfUdpSocket; data: Pointer; size: NativeUInt; received: PNativeUInt; remoteAddress: PsfIpAddress; remotePort: PWord): sfSocketStatus; cdecl; external CSFML_NETWORK_DLL delayed;
function  sfUdpSocket_sendPacket(socket: PsfUdpSocket; packet: PsfPacket; remoteAddress: sfIpAddress; remotePort: Word): sfSocketStatus; cdecl; external CSFML_NETWORK_DLL delayed;
function  sfUdpSocket_receivePacket(socket: PsfUdpSocket; packet: PsfPacket; remoteAddress: PsfIpAddress; remotePort: PWord): sfSocketStatus; cdecl; external CSFML_NETWORK_DLL delayed;
function  sfUdpSocket_maxDatagramSize(): Cardinal; cdecl; external CSFML_NETWORK_DLL delayed;

implementation

end.
