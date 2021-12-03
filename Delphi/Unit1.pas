unit Unit1;

interface

uses

  IdHTTP,
  IdSSLOpenSSL,
  IdGlobal,

  System.JSON,
  System.netEncoding,

  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TForm1 = class(TForm)
    Edit1: TEdit;
    Edit2: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Button1: TButton;
    Button2: TButton;
    Memo1: TMemo;
    Button3: TButton;
    OpenDialog1: TOpenDialog;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
    fHTTPClient: TIdHTTP;

    function FileToBase64(Arquivo : String): String;
    function StreamToBase64(STream : TMemoryStream) : String;
    function Base64Invalids(const ABase64Str: string): string;

    function SomenteNumero(Texto : String): String;

    Function SendMenssage(Number:String; Menssage:String):Longint;
    Function SendPDF(Number:String; mensagem :String; Arquivo:String) : Longint;
    Function SendImage(Number:String; mensagem :String; Arquivo:String) : Longint;

  public
    { Public declarations }
    function CreateHTTPClient: TIdHTTP;
  end;

var
  Form1: TForm1;

implementation

  Const URL = 'https://api.phoenixsistemas.com.br/api/v1/whatsapp/';

{$R *.dfm}

{ TForm1 }

function TForm1.Base64Invalids(const ABase64Str: string): string;
begin

  Result := ABase64Str;
  Result := StringReplace(Result, #13#10, '', [rfReplaceAll]);
  Result := StringReplace(Result, #13, '', [rfReplaceAll]);

end;

procedure TForm1.Button1Click(Sender: TObject);
begin

  if SendMenssage('5531987658732','Teste de envio') = 200 then
    ShowMessage('Mensagem enviada com sucesso!');

end;

procedure TForm1.Button2Click(Sender: TObject);
begin

  if OpenDialog1.Execute then begin

    if SendPDF('5531987658732','PDF',OpenDialog1.FileName) = 200 then
      ShowMessage('PDF enviado com sucesso');

  end;


end;

procedure TForm1.Button3Click(Sender: TObject);
begin

  if OpenDialog1.Execute then begin

    if SendImage('5531987658732','IMAGEM',OpenDialog1.FileName) = 200 then
      ShowMessage('IMAGEM enviado com sucesso');

  end;

end;

function TForm1.CreateHTTPClient: TIdHTTP;
var
  xHandler: TIdSSLIOHandlerSocketOpenSSL;
begin
  LoadOpenSSLLibrary;

  Result := TIdHTTP.Create;

  xHandler := TIdSSLIOHandlerSocketOpenSSL.Create(Result);
  xHandler.SSLOptions.Method := sslvTLSv1_2;
  xHandler.SSLOptions.Mode := sslmClient;
  Result.IOHandler := xHandler;

  Result.HTTPOptions := [hoForceEncodeParams,
                         hoNoProtocolErrorException,
                         hoWantProtocolErrorContent];
  Result.ConnectTimeout := 10000;
  Result.ReadTimeout := 10000;

  Result.Request.Charset := 'utf-8';
  Result.Request.Accept := 'application/json';
  Result.Request.ContentType := 'application/json';
  Result.Request.BasicAuthentication := True;

  Result.Request.Username := Edit1.Text;
  Result.Request.Password := Edit2.Text;

  Result.Request.CustomHeaders.Clear;
end;

function TForm1.FileToBase64(Arquivo: String): String;
Var
  sTream : tMemoryStream;
begin

  if (Trim(Arquivo) <> '') then begin

    sTream := TMemoryStream.Create;

    Try

     sTream.LoadFromFile(Arquivo);
     result := StreamToBase64(sTream);

    Finally

     Stream.Free;
     Stream:=nil;

    End;


  end else
     result := '';
end;



function TForm1.SendImage(Number, mensagem, Arquivo: String): Longint;
var
  xParams: string;
  xRequestBody: TStringStream;

  sTest : Tstringlist;

  xResponse: string;
  xJson: TJSONValue;

  xCode: Integer;
  xMsg, sBase64: string;

  Extensao : String;

begin

  FHTTPClient := CreateHTTPClient;
  xRequestBody := nil;

  Memo1.Clear;


  try

    try

      if not FileExists(Arquivo) then begin

        memo1.Lines.Add('Arquivo inexistente.');
        Exit;

      end;

      Extensao := UpperCase(ExtractFileExt(Arquivo));

      if  (Extensao = 'JPEG') or  ( Extensao = 'PNG') then begin

        memo1.Lines.Add('Extensão do Arquivo não suportada');
        Exit;

      end;
      

      sBase64 := FileToBase64(Arquivo);
      xParams:= Base64Invalids
      (
      '{                                                        '+
      '    "number" : "'+SomenteNumero(number)+'",            '+
      '    "path" : "data:image/'+LowerCase(Extensao)+';base64,'+sBase64+'",  '+
      '    "caption" : "'+mensagem+'"                           '+
      '}                                                        ');

      xRequestBody := TStringStream.Create(xParams, TEncoding.UTF8);
      xResponse := FHTTPClient.Post(URL + 'sendFile64', xRequestBody);

      xCode := FHTTPClient.ResponseCode;

      Result := FHTTPClient.ResponseCode;

      Memo1.Lines.Add(xResponse);

    except

    end;

  finally

    xRequestBody.Free;
    FHTTPClient.Free;

  end;

end;

function TForm1.SendMenssage(Number, Menssage: String): Longint;
var

  xRequestBody: TStringStream;

  xResponse: string;
  xJson: TJSONObject;

begin

  FHTTPClient := CreateHTTPClient;
  xRequestBody := nil;

  try
    try

      xJson := TJSONObject.Create;



      xJson.AddPair('number', Number);
      xJson.AddPair('text', Menssage);

      xRequestBody := TStringStream.Create(xJson.ToString, TEncoding.UTF8);
      xResponse    := FHTTPClient.Post(URL + 'SendText', xRequestBody);
      Result       := FHTTPClient.ResponseCode;

      Memo1.Clear;
      Memo1.Lines.Add(xResponse);

    except

    end;

  finally

    xJSon.Free;
    xRequestBody.Free;
    FHTTPClient.Free;

  end;

end;

function TForm1.SendPDF(Number, mensagem, Arquivo: String): Longint;
var
  xParams: string;
  xRequestBody: TStringStream;

  sTest : Tstringlist;

  xResponse: string;
  xJson: TJSONValue;

  xCode: Integer;
  xMsg, sBase64: string;
begin

  FHTTPClient := CreateHTTPClient;
  xRequestBody := nil;

  Memo1.Clear;

  try

    try

      if not FileExists(Arquivo) then begin
        memo1.Lines.Add('Arquivo inexistente.');
        Exit;
      end;

      sBase64 := FileToBase64(Arquivo);
      xParams:= Base64Invalids
      (
      '{                                                        '+
      '    "number" : "'+SomenteNumero(number)+'",            '+
      '    "path" : "data:application/pdf;base64,'+sBase64+'",  '+
      '    "caption" : "'+mensagem+'"                           '+
      '}                                                        ');

      xRequestBody := TStringStream.Create(xParams, TEncoding.UTF8);
      xResponse := FHTTPClient.Post(URL + 'sendFile64', xRequestBody);

      xCode := FHTTPClient.ResponseCode;

      Result := FHTTPClient.ResponseCode;

      Memo1.Lines.Add(xResponse);

    except

    end;

  finally

    xRequestBody.Free;
    FHTTPClient.Free;

  end;

end;

function TForm1.SomenteNumero(Texto: String): String;
var
  I : Byte;
begin
   Result := '';
   for I := 1 To Length(Texto) do
       if Texto [I] In ['0'..'9'] Then
            Result := Result + Texto [I];
end;

function TForm1.StreamToBase64(STream: TMemoryStream): String;
Var
  Base64 : tBase64Encoding;
begin
  Try
    Stream.Position := 0;
    Base64 := TBase64Encoding.Create;
    Result := Base64.EncodeBytesToString(sTream.Memory, sTream.Size);
  Finally
    Base64.Free;
    Base64:=nil;
  End;
end;

end.
