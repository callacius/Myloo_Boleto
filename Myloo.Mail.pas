unit Myloo.Mail;


interface

uses
  System.Classes,
  syncobjs,
  SysUtils,
  contnrs,
  SSL_OpenSSL,
  SMTPSend,
  MimePart,
  MimeMess,
  SynaChar,
  SynaUtil;

type

  TMailStatus = (pmsStartProcess, pmsConfigHeaders, pmsAddingMimeParts,
                 pmsLoginSMTP, pmsStartSends, pmsSendTo, pmsSendCC, pmsSendBCC,
                 pmsSendReplyTo, pmsSendData, pmsLogoutSMTP, pmsDone, pmsError);

  TMailCharset = TMimeChar;

  TMailAttachmentDisposition = (adAttachment, adInline);

  { TMailAttachment }

  TMailAttachment = class
  private
    FFileName: String;
    FDescription: String;
    FStream: TMemoryStream;
    FDisposition: TMailAttachmentDisposition;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Clear;
    procedure Assign(Source: TMailAttachment);

    property FileName: String read FFileName write FFileName;
    property Stream: TMemoryStream read FStream;
    property Description: String read FDescription write FDescription;

    property Disposition: TMailAttachmentDisposition read FDisposition
      write FDisposition;
  end;

  { TMailAttachments }

  TMailAttachments = class( TObjectList )
  protected
    procedure SetObject (Index: Integer; Item: TMailAttachment);
    Function GetObject (Index: Integer): TMailAttachment;
    procedure Insert (Index: Integer; Obj: TMailAttachment);
  public
    Function New: TMailAttachment;
    Function Add (Obj: TMailAttachment): Integer;
    property Objects [Index: Integer]: TMailAttachment read GetObject write SetObject; default;
  end;

  TMail = class;

  TOnMailProcess = procedure(const AMail: TMail; const aStatus: TMailStatus) of object;
  TOnMailException = procedure(const AMail: TMail; const E: Exception; var ThrowIt: Boolean) of object;

  { TMailThread }

  TMailThread = class(TThread)
  private
    FMail : TMail;
    FException: Exception;
    FThrowIt: Boolean;
    FStatus: TMailStatus;
    FOnMailProcess: TOnMailProcess;
    FOnMailException: TOnMailException;
    FOnBeforeMailProcess: TNotifyEvent;
    FOnAfterMailProcess: TNotifyEvent;

    procedure MailException(const AMail: TMail; const E: Exception; var ThrowIt: Boolean);
    procedure DoMailException;
    procedure MailProcess(const AMail: TMail; const aStatus: TMailStatus);
    procedure DoMailProcess;
    procedure BeforeMailProcess(Sender: TObject);
    procedure DoBeforeMailProcess;
    procedure AfterMailProcess(Sender: TObject);
    procedure DoAfterMailProcess;

  protected
    procedure Execute; override;

  public
    constructor Create(AOwner : TMail);
  end;

  { TMail }
  TMail = class
  private
    FSMTP                : TSMTPSend;
    FMIMEMess            : TMimeMess;
    FArqMIMe             : TMemoryStream;

    FReadingConfirmation : boolean;
    FDeliveryConfirmation: boolean;
    FOnMailProcess       : TOnMailProcess;
    FOnMailException     : TOnMailException;

    FIsHTML              : boolean;
    FAttempts            : Byte;
    FFrom                : string;
    FFromName            : string;
    FSubject             : string;
    FBody                : TStringList;
    FAltBody             : TStringList;
    FAttachments         : TMailAttachments;
    FReplyTo             : TStringList;
    FBCC                 : TStringList;
    FTimeOut             : Integer;
    FUseThread           : boolean;

    FDefaultCharsetCode  : TMimeChar;
    FIDECharsetCode      : TMimeChar;

    FOnAfterMailProcess  : TNotifyEvent;
    FOnBeforeMailProcess : TNotifyEvent;

    FGetLastSmtpError    : String;

    Function GetHost: string;
    Function GetPort: string;
    Function GetUsername: string;
    Function GetPassword: string;
    Function GetFullSSL: Boolean;
    Function GetAutoTLS: Boolean;
    Function GetPriority: TMessPriority;

    procedure SetHost(aValue: string);
    procedure SetPort(aValue: string);
    procedure SetUsername(aValue: string);
    procedure SetPassword(aValue: string);
    procedure SetFullSSL(aValue: Boolean);
    procedure SetAutoTLS(aValue: Boolean);
    procedure SetPriority(aValue: TMessPriority);
    procedure SetAttempts(AValue: Byte);

    procedure SmtpError(const pMsgError: string);

    procedure DoException(E: Exception);
    procedure AddEmailWithDelimitersToList( aEmail: String; aList: TStrings);

  protected
    procedure SendMail;

  public
    constructor Create;
    destructor Destroy; override;
    procedure Assign(Source: TMail);

    procedure MailProcess(const aStatus: TMailStatus);
    procedure Send(UseThreadNow: Boolean); overload;
    procedure Send; overload;
    procedure BuildMimeMess;
    procedure Clear;
    procedure SaveToFile(const AFileName: String);
    Function SaveToStream(AStream: TStream): Boolean;

    procedure AddAttachment(aFileName: string; aDescription: string;
      const aDisposition: TMailAttachmentDisposition = adInline); overload;
    procedure AddAttachment(aFileName: string); overload;
    procedure AddAttachment(aStream: TStream; aDescription: string;
      const aDisposition: TMailAttachmentDisposition = adInline); overload;
    procedure AddAttachment(aStream: TStream); overload;
    procedure ClearAttachments;

    procedure AddAddress(aEmail: string; aName: string = '');
    procedure AddReplyTo(aEmail: string; aName: string = '');
    procedure AddCC(aEmail: string; aName: string = '');
    procedure AddBCC(aEmail: string);

    property SMTP: TSMTPSend read FSMTP;
    property MIMEMess: TMimeMess read FMIMEMess;
    property Attachments: TMailAttachments read FAttachments;
    property BCC: TStringList read FBCC;
    property ReplyTo: TStringList read FReplyTo;

    property AltBody: TStringList read FAltBody;
    property Body: TStringList read FBody;

    property GetLastSmtpError: string read FGetLastSmtpError;

    property Host: string read GetHost write SetHost;
    property Port: string read GetPort write SetPort;
    property Username: string read GetUsername write SetUsername;
    property Password: string read GetPassword write SetPassword;
    property SetSSL: boolean read GetFullSSL write SetFullSSL;
    property SetTLS: boolean read GetAutoTLS write SetAutoTLS;
    property Priority: TMessPriority read GetPriority write SetPriority default MP_normal;
    property ReadingConfirmation: boolean read FReadingConfirmation write FReadingConfirmation default False;
    property DeliveryConfirmation: boolean read FDeliveryConfirmation write FDeliveryConfirmation default False;
    property IsHTML: boolean read FIsHTML write FIsHTML default False;
    property UseThread: boolean read FUseThread write FUseThread default False;
    property TimeOut: Integer read FTimeOut write FTimeOut default 0;
    property Attempts: Byte read FAttempts write SetAttempts;
    property From: string read FFrom write FFrom;
    property FromName: string read FFromName write FFromName;
    property Subject: string read FSubject write FSubject;
    property DefaultCharset: TMailCharset read FDefaultCharsetCode write FDefaultCharsetCode;
    property IDECharset: TMailCharset read FIDECharsetCode write FIDECharsetCode;
    property OnBeforeMailProcess: TNotifyEvent read FOnBeforeMailProcess write FOnBeforeMailProcess;
    property OnMailProcess: TOnMailProcess read FOnMailProcess write FOnMailProcess;
    property OnAfterMailProcess: TNotifyEvent read FOnAfterMailProcess write FOnAfterMailProcess;
    property OnMailException: TOnMailException read FOnMailException write FOnMailException;
  end;

procedure SendEmailByThread( MailToClone: TMail);

var
  MailCriticalSection : TCriticalSection;

implementation

Uses
  strutils,
  math,
  Myloo.Boleto.Utils;

procedure SendEmailByThread(MailToClone: TMail);
var
  AMail: TMail;
begin
  if not Assigned(MailToClone) then
    raise Exception.Create( 'MailToClone not specified' );

  AMail := TMail.Create;
  AMail.Assign( MailToClone );

  // Thread is FreeOnTerminate, and also will destroy "AMail"
  TMailThread.Create(AMail);
end;

{ TMailAttachment }

constructor TMailAttachment.Create;
begin
  inherited Create;
  FStream := TMemoryStream.Create;
  FDisposition := adInline;
  Clear;
end;

destructor TMailAttachment.Destroy;
begin
  FStream.Free;
  inherited Destroy;
end;

procedure TMailAttachment.Clear;
begin
  FFileName := '';
  FDescription  := '';
  FStream.Clear;
end;

procedure TMailAttachment.Assign(Source: TMailAttachment);
begin
  Clear;
  FFileName := Source.FileName;
  FDescription  := Source.Description;
  Source.Stream.Position := 0;
  FStream.CopyFrom(Source.Stream, Stream.Size);
end;

{ TMailAttachments }

procedure TMailAttachments.SetObject(Index: Integer; Item: TMailAttachment);
begin
  inherited SetItem (Index, Item) ;
end;

function TMailAttachments.GetObject(Index: Integer): TMailAttachment;
begin
  Result := inherited GetItem(Index) as TMailAttachment ;
end;

procedure TMailAttachments.Insert(Index: Integer; Obj: TMailAttachment);
begin
  inherited Insert(Index, Obj);
end;

function TMailAttachments.New: TMailAttachment;
begin
  Result := TMailAttachment.Create;
  Add(Result);
end;

function TMailAttachments.Add(Obj: TMailAttachment): Integer;
begin
  Result := inherited Add(Obj) ;
end;

{ TMail }

function TMail.GetHost: string;
begin
  Result := FSMTP.TargetHost;
end;

function TMail.GetPort: string;
begin
  Result := FSMTP.TargetPort;
end;

function TMail.GetUsername: string;
begin
  Result := FSMTP.UserName;
end;

function TMail.GetPassword: string;
begin
  Result := FSMTP.Password;
end;

function TMail.GetFullSSL: Boolean;
begin
  Result := FSMTP.FullSSL;
end;

function TMail.GetAutoTLS: Boolean;
begin
  Result := FSMTP.AutoTLS;
end;

procedure TMail.SetHost(aValue: string);
begin
  FSMTP.TargetHost := aValue;
end;

procedure TMail.SetPort(aValue: string);
begin
  FSMTP.TargetPort := aValue;
end;

procedure TMail.SetUsername(aValue: string);
begin
  FSMTP.UserName := aValue;
end;

procedure TMail.SetPassword(aValue: string);
begin
  FSMTP.Password := aValue;
end;

procedure TMail.SetFullSSL(aValue: Boolean);
begin
  FSMTP.FullSSL := aValue;
end;

procedure TMail.SetAutoTLS(aValue: Boolean);
begin
  FSMTP.AutoTLS := aValue;
end;

function TMail.GetPriority: TMessPriority;
begin
  Result := FMIMEMess.Header.Priority;
end;

procedure TMail.SetPriority(aValue: TMessPriority);
begin
  FMIMEMess.Header.Priority := aValue;
end;

procedure TMail.SetAttempts(AValue: Byte);
begin
  if FAttempts = AValue then Exit;
  FAttempts := Max(AValue, 1);
end;

procedure TMail.SmtpError(const pMsgError: string);
begin
  try
    FGetLastSmtpError := pMsgError;
    MailProcess(pmsError);
    DoException( Exception.Create(pMsgError) );
  Finally
    Clear;
  end;
end;

procedure TMail.DoException(E: Exception);
Var
  ThrowIt: Boolean;
begin
  if Assigned(fOnMailException) then
  begin
    ThrowIt := True;
    FOnMailException( Self, E, ThrowIt );

    if ThrowIt then
      raise E
    else
    begin
      E.Free;
      Abort;
    end;
  end
  else
    raise E;
end;

procedure TMail.AddEmailWithDelimitersToList(aEmail: String; aList: TStrings
  );
var
  sDelimiter: Char;
begin
  aEmail := Trim(aEmail);
  sDelimiter := FindDelimiterInText(aEmail);

  if (sDelimiter = ' ') then
    aList.Add(aEmail)
  else
    AddDelimitedTextToList(aEmail, sDelimiter, aList);
end;

procedure TMail.Clear;
begin
  ClearAttachments;
  FMIMEMess.Header.Clear;
  FMIMEMess.Clear;
  FReplyTo.Clear;
  FBCC.Clear;
  FSubject := '';
  FBody.Clear;
  FAltBody.Clear;
end;

procedure TMail.SaveToFile(const AFileName: String);
begin
  BuildMimeMess;

  if AFileName <> '' then
    FArqMIMe.SaveToFile(AFileName);

  Clear;
end;

procedure TMail.MailProcess(const aStatus: TMailStatus);
begin
  if Assigned(fOnMailProcess) then
    FOnMailProcess(Self, aStatus);
end;

constructor TMail.Create;
begin
  inherited Create;

  FSMTP := TSMTPSend.Create;
  FMIMEMess := TMimeMess.Create;
  FAltBody := TStringList.Create;
  FBody := TStringList.Create;
  FArqMIMe := TMemoryStream.Create;
  FAttachments := TMailAttachments.Create(True); // FreeObjects
  FTimeOut := 0;

  FOnBeforeMailProcess := nil;
  FOnAfterMailProcess := nil;

  FAttachments.Clear;
  SetPriority(MP_normal);
  FDefaultCharsetCode := UTF_8;
  FIDECharsetCode := CP1252;
  FReadingConfirmation := False;
  FDeliveryConfirmation := False;
  FIsHTML := False;
  FUseThread := False;
  FAttempts := 3;
  FFrom := '';
  FFromName := '';
  FSubject := '';

  FReplyTo := TStringList.Create;
  {$IfDef HAS_STRICTDELIMITER}
  FReplyTo.StrictDelimiter := True;
  {$EndIf}
  FReplyTo.Delimiter := ';';

  FBCC := TStringList.Create;
  {$IfDef HAS_STRICTDELIMITER}
  FBCC.StrictDelimiter := True;
  {$EndIf}
  FBCC.Delimiter := ';';
end;

destructor TMail.Destroy;
begin
  ClearAttachments;
  FAltBody.Free;
  FBody.Free;
  FBCC.Free;
  FReplyTo.Free;
  FMIMEMess.Free;
  FSMTP.Free;
  FArqMIMe.Free;
  FAttachments.Free;

  inherited Destroy;
end;

procedure TMail.Assign(Source: TMail);
var
  i: Integer;
  AAttachment: TMailAttachment;
begin
  if not (Source is TMail) then
    raise Exception.Create('Source must be TMail');

  with TMail(Source) do
  begin
    Self.Host := Host;
    Self.Port := Port;
    Self.Username := Username;
    Self.Password := Password;
    Self.SetSSL := SetSSL;
    Self.SetTLS := SetTLS;
    Self.Priority := Priority;
    Self.ReadingConfirmation := ReadingConfirmation;
    Self.IsHTML := IsHTML;
    Self.UseThread := UseThread;
    Self.Attempts := Attempts;
    Self.From := From;
    Self.FromName := FromName;
    Self.Subject := Subject;
    Self.DefaultCharset := DefaultCharset;
    Self.IDECharset := IDECharset;
    Self.OnBeforeMailProcess := OnBeforeMailProcess;
    Self.OnMailProcess := OnMailProcess;
    Self.OnAfterMailProcess := OnAfterMailProcess;
    Self.OnMailException := OnMailException;

    For i := 0 to Attachments.Count-1 do
    begin
      AAttachment := Self.Attachments.New;
      AAttachment.Assign(Attachments[I]);
    end;

    Self.AltBody.Assign(AltBody);
    Self.Body.Assign(Body);
    Self.ReplyTo.Assign(ReplyTo);
    Self.BCC.Assign(BCC);

    Self.MIMEMess.Header.ToList.Assign( MIMEMess.Header.ToList );
    Self.MIMEMess.Header.CCList.Assign( MIMEMess.Header.CCList );
    Self.MIMEMess.Header.Organization := MIMEMess.Header.Organization;
    Self.MIMEMess.Header.CustomHeaders.Assign( MIMEMess.Header.CustomHeaders );
    Self.MIMEMess.Header.Date := MIMEMess.Header.Date;
    Self.MIMEMess.Header.XMailer := MIMEMess.Header.XMailer;
  end;
end;

procedure TMail.Send(UseThreadNow: Boolean);
begin
  if UseThreadNow then
    SendEmailByThread(Self)
  else
    SendMail;
end;

procedure TMail.Send;
begin
  Send( UseThread );
end;

procedure TMail.BuildMimeMess;
var
  i: Integer;
  MultiPartParent, MimePartAttach : TMimePart;
  NeedMultiPartRelated, BodyHasImage: Boolean;
  AAttachment: TMailAttachment;

  Function InternalCharsetConversion(const Value: String; CharFrom: TMimeChar;
    CharTo: TMimeChar): String;
  begin
    Result := string( CharsetConversion( AnsiString( Value), CharFrom, CharTo ));
  end;

begin
  if Assigned(OnBeforeMailProcess) then
    OnBeforeMailProcess( self );

  MailProcess(pmsStartProcess);

  // Encoding according to IDE and Mail Charset //
  if FDefaultCharsetCode <> FIDECharsetCode then
  begin
    if FBody.Count > 0 then
      FBody.Text := InternalCharsetConversion(fBody.Text, FIDECharsetCode, FDefaultCharsetCode);

    if FAltBody.Count > 0 then
      FAltBody.Text := InternalCharsetConversion(fAltBody.Text, FIDECharsetCode, FDefaultCharsetCode);
  end;

  // Configuring the Headers //
  MailProcess(pmsConfigHeaders);

  FMIMEMess.Header.CharsetCode := FDefaultCharsetCode;

  if FDefaultCharsetCode <> FIDECharsetCode then
    FMIMEMess.Header.Subject := InternalCharsetConversion(fSubject, FIDECharsetCode, FDefaultCharsetCode)
  else
    FMIMEMess.Header.Subject := FSubject;

  if Trim(fFromName) <> '' then
    FMIMEMess.Header.From := '"' + FFromName + '" <' + From + '>'
  else
    FMIMEMess.Header.From := FFrom;

  if FReplyTo.Count > 0 then
    FMIMEMess.Header.ReplyTo := FReplyTo.DelimitedText;

  if FReadingConfirmation then
    FMIMEMess.Header.CustomHeaders.Insert(0, 'Disposition-Notification-To: ' + FMIMEMess.Header.From);

  if FDeliveryConfirmation then
    FMIMEMess.Header.CustomHeaders.Insert(0, 'Return-Receipt-To: ' + FMIMEMess.Header.From);

  FMIMEMess.Header.XMailer := 'Synapse - Mail';

  // Adding MimeParts //
  // Inspiration: http://www.ararat.cz/synapse/doku.php/public:howto:mimeparts
  MailProcess(pmsAddingMimeParts);

  NeedMultiPartRelated := (fIsHTML and (fBody.Count > 0)) and (fAltBody.Count > 0);

  // The Root //
  MultiPartParent := FMIMEMess.AddPartMultipart( IfThen(NeedMultiPartRelated, 'alternative', 'mixed'), nil );
  MultiPartParent.CharsetCode := FDefaultCharsetCode;

  // Text part //
  if FAltBody.Count > 0 then
  begin
    with FMIMEMess.AddPart( MultiPartParent ) do
    begin
      FAltBody.SaveToStream(DecodedLines);
      Primary := 'text';
      Secondary := 'plain';
      Description := 'Message text';
      Disposition := 'inline';
      CharsetCode := FDefaultCharsetCode;
      TargetCharset := FDefaultCharsetCode;
      EncodingCode := ME_QUOTED_PRINTABLE;
      EncodePart;
      EncodePartHeader;
    end;
  end;

  // Need New branch ? //
  if NeedMultiPartRelated then
  begin
    MultiPartParent := FMIMEMess.AddPartMultipart( 'related', MultiPartParent );
    MultiPartParent.CharsetCode := FDefaultCharsetCode;
  end;

  if FIsHTML and (fBody.Count > 0) then
  begin
    // Adding HTML Part //
    with FMIMEMess.AddPart( MultiPartParent ) do
    begin
      FBody.SaveToStream(DecodedLines);
      Primary := 'text';
      Secondary := 'html';
      Description := 'HTML text';
      Disposition := 'inline';
      CharsetCode := FDefaultCharsetCode;
      TargetCharset := FDefaultCharsetCode;
      EncodingCode := ME_QUOTED_PRINTABLE;
      EncodePart;
      EncodePartHeader;
    end;
  end;

  // Adding the Attachments //
  For i := 0 to FAttachments.Count-1 do
  begin
    AAttachment := FAttachments[i];

    BodyHasImage := pos(':'+LowerCase(AAttachment.Description),
                        LowerCase(fBody.Text)) > 0;

    AAttachment.Stream.Position := 0;

    MimePartAttach := FMIMEMess.AddPart(MultiPartParent);
    MimePartAttach.DecodedLines.LoadFromStream(AAttachment.Stream);
    MimePartAttach.MimeTypeFromExt(AAttachment.FileName);
    MimePartAttach.Description := AAttachment.Description;
    case AAttachment.Disposition of
      adAttachment: MimePartAttach.Disposition := 'attachment';
      adInline: MimePartAttach.Disposition := 'inline';
    else
      MimePartAttach.Disposition := 'attachment';
    end;
    if FIsHTML and BodyHasImage then
      MimePartAttach.ContentID := '<' + AAttachment.Description + '>';

    MimePartAttach.FileName    := AAttachment.FileName;
    MimePartAttach.EncodingCode:= ME_BASE64;
    MimePartAttach.PrimaryCode := MP_BINARY;  // To avoid MP_TEXT internal conversion ;
    MimePartAttach.CharsetCode := FDefaultCharsetCode;

    MimePartAttach.EncodePart;
    MimePartAttach.EncodePartHeader;
  end;

  FMIMEMess.EncodeMessage;

  FArqMIMe.Clear;
  FMIMEMess.Lines.SaveToStream(fArqMIMe);
end;

procedure TMail.SendMail;
var
  vAttempts: Byte;
  c, i: Integer;
begin
  BuildMimeMess;

  if FTimeOut > 0 then
  begin
    FSMTP.Timeout := FTimeOut;
    FSMTP.Sock.ConnectionTimeout := FTimeOut;
  end;

  // DEBUG //
  // SaveToFile('c:\app\Mail.eml'); {Para debug, comentar o Clear; da linha 367}

  // Login in SMTP //
  MailProcess(pmsLoginSMTP);
  if (fSMTP.TargetHost = '') then
    SmtpError('SMTP Error: Server not informed');

  For vAttempts := 1 to FAttempts do
  begin
    if FSMTP.Login then
      Break;

    if vAttempts >= FAttempts then
      SmtpError('SMTP Error: Unable to Login.' + sLineBreak + SMTP.ResultString);
  end;

  if FDeliveryConfirmation then
  begin
    if (fSMTP.FindCap('DSN') = '') then
      SmtpError('SMTP Error: The SMTP Server does not support Delivery Status Notification');

    //FSMTP.DeliveryStatusNotification := [dsnSucecess, dsnFailure];
  end;

  // Sending Mail Form //
  MailProcess(pmsStartSends);

  For vAttempts := 1 to FAttempts do
  begin
    if FSMTP.MailFrom(fFrom, Length(fFrom)) then
      Break;

    if vAttempts >= FAttempts then
      SmtpError('SMTP Error: Unable to send MailFrom.' + sLineBreak + SMTP.ResultString);
  end;

  // Sending MailTo //
  MailProcess(pmsSendTo);

  For i := 0 to FMIMEMess.Header.ToList.Count - 1 do
  begin
    For vAttempts := 1 to FAttempts do
    begin
      if FSMTP.MailTo(GetEmailAddr(fMIMEMess.Header.ToList.Strings[i]))then
        Break;

      if vAttempts >= FAttempts then
        SmtpError('SMTP Error: Unable to send MailTo.' + sLineBreak + SMTP.ResultString);
    end;
  end;

  // Sending Carbon Copies //
  c := FMIMEMess.Header.CCList.Count;
  if c > 0 then
    MailProcess(pmsSendCC);

  For i := 0 to c - 1 do
  begin
    For vAttempts := 1 to FAttempts do
    begin
      if FSMTP.MailTo(GetEmailAddr(fMIMEMess.Header.CCList.Strings[i])) then
        Break;

      if vAttempts >= FAttempts then
        SmtpError('SMTP Error: Unable to send CC list.' + sLineBreak + SMTP.ResultString);
    end;
  end;

  // Sending Blind Carbon Copies //
  c := FBCC.Count;
  if c > 0 then
    MailProcess(pmsSendBCC);

  For i := 0 to c - 1 do
  begin
    For vAttempts := 1 to FAttempts do
    begin
      if FSMTP.MailTo(GetEmailAddr(fBCC.Strings[I])) then
        Break;

      if vAttempts >= FAttempts then
        SmtpError('SMTP Error: Unable to send BCC list.' + sLineBreak + SMTP.ResultString);
    end;
  end;

  // Sending MIMEMess Data //
  MailProcess(pmsSendData);

  For vAttempts := 1 to FAttempts do
  begin
    if FSMTP.MailData(fMIMEMess.Lines) then
      Break;

    if vAttempts >= FAttempts then
      SmtpError('SMTP Error: Unable to send Mail data.' + sLineBreak + SMTP.ResultString);
  end;

  // Login out From SMTP //
  MailProcess(pmsLogoutSMTP);

  For vAttempts := 1 to FAttempts do
  begin
    if FSMTP.Logout then
      Break;

    if vAttempts >= FAttempts then
      SmtpError('SMTP Error: Unable to Logout.' + sLineBreak + SMTP.ResultString);
  end;

  // Done //
  try
    MailProcess(pmsDone);

    if Assigned(OnAfterMailProcess) then
      OnAfterMailProcess( self );
  Finally
    Clear;
  end;
end;

procedure TMail.ClearAttachments;
begin
  FAttachments.Clear;
end;

procedure TMail.AddAttachment(aFileName: string; aDescription: string;
  const aDisposition: TMailAttachmentDisposition = adInline);
var
  AAttachment: TMailAttachment;
begin
  if not FileExists(aFileName) then
    DoException( Exception.Create('Add Attachment: File not Exists.') );

  if (aDescription = '') then
    aDescription := ExtractFileName(aFileName);

  AAttachment := FAttachments.New;
  AAttachment.FileName := ExtractFileName(aFileName);
  if (aDescription = '') then
    AAttachment.Description := AAttachment.FileName
  else
    AAttachment.Description := aDescription;
  AAttachment.Disposition := aDisposition;

  AAttachment.Stream.LoadFromFile(aFileName)
end;

procedure TMail.AddAttachment(aFileName: string);
begin
  AddAttachment(aFileName, '');
end;

procedure TMail.AddAttachment(aStream: TStream; aDescription: string;
  const aDisposition: TMailAttachmentDisposition = adInline);
var
  AAttachment: TMailAttachment;
begin
  if not Assigned(aStream) then
    DoException( Exception.Create('Add Attachment: Access Violation.') );

  if (Trim(aDescription) = '') then
    aDescription := 'file_' + FormatDateTime('hhnnsszzz',Now);

  aStream.Position := 0;
  AAttachment := FAttachments.New;
  AAttachment.FileName    := aDescription;
  AAttachment.Description := aDescription;
  AAttachment.Disposition := aDisposition;
  AAttachment.Stream.CopyFrom(aStream, aStream.Size);
end;

procedure TMail.AddAttachment(aStream: TStream);
begin
  AddAttachment(aStream, '');
end;

procedure TMail.AddAddress(aEmail: string; aName: string);
begin
  if Trim(aName) <> '' then
    FMIMEMess.Header.ToList.Add('"' + aName + '" <' + aEmail + '>')
  else
    AddEmailWithDelimitersToList(aEmail, FMIMEMess.Header.ToList);
end;

procedure TMail.AddReplyTo(aEmail: string; aName: string);
begin
  if Trim(aName) <> '' then
    FReplyTo.Add('"' + aName + '" <' + aEmail + '>')
  else
    AddEmailWithDelimitersToList(aEmail, FReplyTo);
end;

procedure TMail.AddCC(aEmail: string; aName: string);
begin
  if Trim(aName) <> '' then
    FMIMEMess.Header.CCList.Add('"' + aName + '" <' + aEmail + '>')
  else
    AddEmailWithDelimitersToList(aEmail, FMIMEMess.Header.CCList);
end;

procedure TMail.AddBCC(aEmail: string);
begin
  AddEmailWithDelimitersToList(aEmail, FBCC);
end;

function TMail.SaveToStream(AStream: TStream): Boolean;
begin
  Result := True;
  try
    FArqMIMe.SaveToStream(AStream);
  except
    Result := False;
  end;
end;

{ TMailThread }

constructor TMailThread.Create(AOwner : TMail);
begin
  FreeOnTerminate  := True;
  FMail        := AOwner;

  inherited Create(False);
end;

procedure TMailThread.Execute;
begin
  FStatus := pmsStartProcess;

  // Save events pointers
  FOnMailProcess   := FMail.OnMailProcess ;
  FOnMailException := FMail.OnMailException;
  FOnBeforeMailProcess := FMail.OnBeforeMailProcess;
  FOnAfterMailProcess := FMail.OnAfterMailProcess;
  MailCriticalSection.Acquire;
  try
    // Redirect events to Internal methods, to use Synchronize
    FMail.OnMailException := MailException;
    FMail.OnMailProcess := MailProcess;
    FMail.OnBeforeMailProcess := BeforeMailProcess;
    FMail.OnAfterMailProcess := AfterMailProcess;
    FMail.UseThread := False;

    if (not Self.Terminated) then
      FMail.SendMail;
  Finally
    FMail.Free;
    Terminate;
    MailCriticalSection.Release;
  end;
end;

procedure TMailThread.MailProcess(const AMail: TMail;
  const aStatus: TMailStatus);
begin
  FStatus := aStatus;
  Synchronize(DoMailProcess);
end;

procedure TMailThread.DoMailProcess;
begin
  if Assigned(FOnMailProcess) then
    FOnMailProcess(FMail, FStatus) ;
end;

procedure TMailThread.BeforeMailProcess(Sender: TObject);
begin
  Synchronize(DoBeforeMailProcess);
end;

procedure TMailThread.DoBeforeMailProcess;
begin
  if Assigned(FOnBeforeMailProcess) then
    FOnBeforeMailProcess( FMail );
end;

procedure TMailThread.AfterMailProcess(Sender: TObject);
begin
  Synchronize(DoAfterMailProcess);
end;

procedure TMailThread.DoAfterMailProcess;
begin
  if Assigned(FOnAfterMailProcess) then
    FOnAfterMailProcess( FMail );
end;

procedure TMailThread.MailException(const AMail: TMail;
  const E: Exception; var ThrowIt: Boolean);
begin
  FException := E;
  Synchronize(DoMailException);
  ThrowIt := False;
end;

procedure TMailThread.DoMailException;
begin
  FThrowIt := False;
  if Assigned(FOnMailException) then
    FOnMailException(FMail, FException, FThrowIt);
end;

initialization
  MailCriticalSection := TCriticalSection.Create;

finalization;
  MailCriticalSection.Free;

end.

