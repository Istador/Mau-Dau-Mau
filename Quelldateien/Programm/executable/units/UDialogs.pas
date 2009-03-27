unit UDialogs;
{
  author:     Robin Christopher Ladiges
  website:    http://blackpinguin.de/
  project:    Mau Dau Mau
  binary:     MauDauMau.exe
  unit:       UDialogs
  file:       UDialogs.pas
  filepath:   .\executable\units\
  year:       2008/2009
  desc:       This file offers 2 methods that work like the showmessage and
              InputQuery methods from borland. only different is that these get
              positioned in the middle of the mainform and not from the monitor.

  license:    creative commons by-nc-sa 3.0 germany
   look out license.txt in root folder
   human-readable summary : http://creativecommons.org/licenses/by-nc-sa/3.0/de/
}

interface
uses ExtCtrls, SysUtils, Classes, Dialogs, Forms, StdCtrls, Windows, Graphics,
     Consts, Controls, math;

procedure ShowMessage(Msg:string; AOwner:TComponent);
function InputQuery(const ACaption, APrompt: string; var Value: string;
                    AOwner:TComponent): Boolean;

function GetAveCharSize(Canvas: TCanvas): TPoint;
function CreateMessageDialog(const Msg: string; DlgType: TMsgDlgType;
  Buttons: TMsgDlgButtons; AOwner: TComponent): TForm;

type TMessageForm = class(TForm)
  private
   Message: TLabel;
   procedure HelpButtonClick(Sender: TObject);
  protected
   procedure CustomKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
   procedure WriteToClipBoard(Text: String);
   function GetFormText: String;
  public
   constructor CreateNew(AOwner: TComponent); reintroduce;
  end;

var
 Captions: array[TMsgDlgType] of Pointer = (@SMsgDlgWarning,@SMsgDlgError,
                                            @SMsgDlgInformation,@SMsgDlgConfirm,
                                            nil);
 IconIDs: array[TMsgDlgType] of PChar = (IDI_EXCLAMATION,IDI_HAND,
                                         IDI_ASTERISK,IDI_QUESTION,nil);
 ButtonNames: array[TMsgDlgBtn] of string = ('Yes','No','OK','Cancel','Abort',
                                             'Retry','Ignore','All','NoToAll',
                                             'YesToAll','Help');
 ButtonCaptions: array[TMsgDlgBtn] of Pointer = (@SMsgDlgYes,@SMsgDlgNo,
                                                 @SMsgDlgOK,@SMsgDlgCancel,
                                                 @SMsgDlgAbort,@SMsgDlgRetry,
                                                 @SMsgDlgIgnore,@SMsgDlgAll,
                                                 @SMsgDlgNoToAll,
                                                 @SMsgDlgYesToAll,@SMsgDlgHelp);
 ModalResults: array[TMsgDlgBtn] of Integer = (mrYes,mrNo,mrOk,mrCancel,mrAbort,
                                               mrRetry,mrIgnore,mrAll,mrNoToAll,
                                               mrYesToAll,0);
 ButtonWidths : array[TMsgDlgBtn] of integer;  // initialized to zero


implementation



//Abwandlung von der Funktion DoMessageDlgPosHelp (die durch ShowMessage
//letzendlich aufgerufen wird), damit die message in der mitte der Form
//und nicht in der Mitte des Bildschirms angezeigt wird.
procedure ShowMessage(Msg:string; AOwner:TComponent);
var
 MessageDialog:TForm;
begin
 MessageDialog:=CreateMessageDialog(Msg, mtCustom, [mbOK], AOwner); //<-änderung
 with MessageDialog do
  try
   HelpContext := 0;
   HelpFile := '';
   Position := poOwnerFormCenter; //<- änderung
   ShowModal;
  finally
   Free;
  end;
end;


//kopie von InputQuery in der Unit Dialogs von Borland, einziger unterschied:
//   Position := poOwnerFormCenter;
function InputQuery(const ACaption, APrompt: string; var Value: string;
                    AOwner:TComponent): Boolean;
var
 Form: TForm;
 Prompt: TLabel;
 Edit: TEdit;
 DialogUnits: TPoint;
 ButtonTop, ButtonWidth, ButtonHeight: Integer;
begin
 Result := False;
 Form := TForm.Create(AOwner);  //<- änderung
 with Form do
  try
   Canvas.Font := Font;
   DialogUnits := GetAveCharSize(Canvas);
   BorderStyle := bsDialog;
   Caption := ACaption;
   ClientWidth := MulDiv(180, DialogUnits.X, 4);
   Position := poOwnerFormCenter; //<-änderung
   Prompt := TLabel.Create(Form);
   with Prompt do
    begin
     Parent := Form;
     Caption := APrompt;
     Left := MulDiv(8, DialogUnits.X, 4);
     Top := MulDiv(8, DialogUnits.Y, 8);
     Constraints.MaxWidth := MulDiv(164, DialogUnits.X, 4);
     WordWrap := True;
    end;
   Edit := TEdit.Create(Form);
   with Edit do
    begin
     Parent := Form;
     Left := Prompt.Left;
     Top := Prompt.Top + Prompt.Height + 5;
     Width := MulDiv(164, DialogUnits.X, 4);
     MaxLength := 255;
     Text := Value;
     SelectAll;
    end;
   ButtonTop := Edit.Top + Edit.Height + 15;
   ButtonWidth := MulDiv(50, DialogUnits.X, 4);
   ButtonHeight := MulDiv(14, DialogUnits.Y, 8);
   with TButton.Create(Form) do
    begin
     Parent := Form;
     Caption := SMsgDlgOK;
     ModalResult := mrOk;
     Default := True;
     SetBounds(MulDiv(38, DialogUnits.X, 4), ButtonTop, ButtonWidth,
               ButtonHeight);
    end;
   with TButton.Create(Form) do
    begin
     Parent := Form;
     Caption := SMsgDlgCancel;
     ModalResult := mrCancel;
     Cancel := True;
     SetBounds(MulDiv(92, DialogUnits.X, 4), Edit.Top + Edit.Height + 15,
               ButtonWidth, ButtonHeight);
     Form.ClientHeight := Top + Height + 13;
    end;
   if ShowModal = mrOk then
    begin
     Value := Edit.Text;
     Result := True;
    end;
  finally
   Form.Free;
  end;
end;


//alle folgende methoden sind aus der Unit Dialogs von Borland und werden für
//die beiden Methoden ShowMessage und InputQuery benötigt, sind in der Unit
//Dialogs jedoch nur lokal deklariert
function GetAveCharSize(Canvas: TCanvas): TPoint;
var
 i: Integer;
 Buffer: array[0..51] of Char;
begin
  for i := 0 to 25 do Buffer[i] := Chr(i + Ord('A'));
  for i := 0 to 25 do Buffer[i + 26] := Chr(i + Ord('a'));
  GetTextExtentPoint(Canvas.Handle, Buffer, 52, TSize(Result));
  Result.X := Result.X div 52;
end;


//abgeänderte funktion für AOwner übergabe
function CreateMessageDialog(const Msg: string; DlgType: TMsgDlgType;
  Buttons: TMsgDlgButtons; AOwner: TComponent): TForm;
const
 mcHorzMargin = 8;
 mcVertMargin = 8;
 mcHorzSpacing = 10;
 mcVertSpacing = 10;
 mcButtonWidth = 50;
 mcButtonHeight = 14;
 mcButtonSpacing = 4;
var
 DialogUnits: TPoint;
 HorzMargin,VertMargin,HorzSpacing,VertSpacing,ButtonWidth,ButtonHeight,
  ButtonSpacing,ButtonCount,ButtonGroupWidth,IconTextWidth,IconTextHeight,X,
  ALeft: Integer;
 B, CancelButton: TMsgDlgBtn;
 IconID: PChar;
 TextRect: TRect;
 LButton: TButton;
 DefaultButton: TMsgDlgBtn;
begin
 if mbOk in Buttons then
  DefaultButton := mbOk
 else if mbYes in Buttons then
  DefaultButton := mbYes
 else
  DefaultButton := mbRetry;
 Result := TMessageForm.CreateNew(AOwner); //<- geändert
 with Result do
  begin
   BiDiMode := Application.BiDiMode;
   BorderStyle := bsDialog;
   Canvas.Font := Font;
   KeyPreview := True;
   Position := poDesigned;
   OnKeyDown := TMessageForm(Result).CustomKeyDown;
   DialogUnits := GetAveCharSize(Canvas);
   HorzMargin := MulDiv(mcHorzMargin, DialogUnits.X, 4);
   VertMargin := MulDiv(mcVertMargin, DialogUnits.Y, 8);
   HorzSpacing := MulDiv(mcHorzSpacing, DialogUnits.X, 4);
   VertSpacing := MulDiv(mcVertSpacing, DialogUnits.Y, 8);
   ButtonWidth := MulDiv(mcButtonWidth, DialogUnits.X, 4);
   for B := Low(TMsgDlgBtn) to High(TMsgDlgBtn) do
    if B in Buttons then
     begin
      if ButtonWidths[B] = 0 then
       begin
        TextRect := Rect(0,0,0,0);
        Windows.DrawText(canvas.handle,PChar(LoadResString(ButtonCaptions[B])),
                         -1,TextRect,DT_CALCRECT or DT_LEFT or DT_SINGLELINE
                         or DrawTextBiDiModeFlagsReadingOnly);
        with TextRect do ButtonWidths[B] := Right - Left + 8;
       end;
      if ButtonWidths[B] > ButtonWidth then ButtonWidth := ButtonWidths[B];
     end;
   ButtonHeight := MulDiv(mcButtonHeight, DialogUnits.Y, 8);
   ButtonSpacing := MulDiv(mcButtonSpacing, DialogUnits.X, 4);
   SetRect(TextRect, 0, 0, Screen.Width div 2, 0);
   DrawText(Canvas.Handle,PChar(Msg),Length(Msg)+1,TextRect,DT_EXPANDTABS or
            DT_CALCRECT or DT_WORDBREAK or DrawTextBiDiModeFlagsReadingOnly);
   IconID := IconIDs[DlgType];
   IconTextWidth := TextRect.Right;
   IconTextHeight := TextRect.Bottom;
   if IconID <> nil then
    begin
     Inc(IconTextWidth, 32 + HorzSpacing);
     if IconTextHeight < 32 then IconTextHeight := 32;
    end;
   ButtonCount := 0;
   for B := Low(TMsgDlgBtn) to High(TMsgDlgBtn) do
    if B in Buttons then Inc(ButtonCount);
   ButtonGroupWidth := 0;
   if ButtonCount <> 0 then
    ButtonGroupWidth:=ButtonWidth*ButtonCount + ButtonSpacing*(ButtonCount-1);
   ClientWidth := Max(IconTextWidth, ButtonGroupWidth) + HorzMargin * 2;
   ClientHeight := IconTextHeight + ButtonHeight + VertSpacing + VertMargin * 2;
   Left := (Screen.Width div 2) - (Width div 2);
   Top := (Screen.Height div 2) - (Height div 2);
   if DlgType <> mtCustom then
    Caption := LoadResString(Captions[DlgType])
   else
    Caption := Application.Title;
   if IconID <> nil then
    with TImage.Create(Result) do
     begin
      Name := 'Image';
      Parent := Result;
      Picture.Icon.Handle := LoadIcon(0, IconID);
      SetBounds(HorzMargin, VertMargin, 32, 32);
     end;
   TMessageForm(Result).Message := TLabel.Create(Result);
   with TMessageForm(Result).Message do
    begin
     Name := 'Message';
     Parent := Result;
     WordWrap := True;
     Caption := Msg;
     BoundsRect := TextRect;
     BiDiMode := Result.BiDiMode;
     ALeft := IconTextWidth - TextRect.Right + HorzMargin;
     if UseRightToLeftAlignment then ALeft:= Result.ClientWidth - ALeft - Width;
     SetBounds(ALeft, VertMargin, TextRect.Right, TextRect.Bottom);
    end;
   if mbCancel in Buttons then CancelButton := mbCancel
   else if mbNo in Buttons then CancelButton := mbNo
   else CancelButton := mbOk;
   X := (ClientWidth - ButtonGroupWidth) div 2;
   for B := Low(TMsgDlgBtn) to High(TMsgDlgBtn) do
    if B in Buttons then
     begin
      LButton := TButton.Create(Result);
      with LButton do
       begin
        Name := ButtonNames[B];
        Parent := Result;
        Caption := LoadResString(ButtonCaptions[B]);
        ModalResult := ModalResults[B];
        if B = DefaultButton then
         begin
          Default := True;
          ActiveControl := LButton;
         end;
        if B = CancelButton then Cancel := True;
        SetBounds(X,IconTextHeight+VertMargin+VertSpacing,ButtonWidth,
                  ButtonHeight);
        Inc(X, ButtonWidth + ButtonSpacing);
        if B = mbHelp then OnClick := TMessageForm(Result).HelpButtonClick;
       end;
     end;
  end;
end;


procedure TMessageForm.HelpButtonClick(Sender: TObject);
begin
 Application.HelpContext(HelpContext);
end;


//ein "Beep;" rausgenommen
procedure TMessageForm.CustomKeyDown(Sender: TObject; var Key: Word;
                                     Shift: TShiftState);
begin
 if (Shift = [ssCtrl]) and (Key = Word('C')) then WriteToClipBoard(GetFormText);
end;


procedure TMessageForm.WriteToClipBoard(Text: String);
var
 Data: THandle;
 DataPtr: Pointer;
begin
 if OpenClipBoard(0) then
  begin
   try
    Data := GlobalAlloc(GMEM_MOVEABLE+GMEM_DDESHARE, Length(Text) + 1);
    try
     DataPtr := GlobalLock(Data);
     try
      Move(PChar(Text)^, DataPtr^, Length(Text) + 1);
      EmptyClipBoard;
      SetClipboardData(CF_TEXT, Data);
     finally
      GlobalUnlock(Data);
     end;
    except
     GlobalFree(Data);
     raise;
    end;
   finally
    CloseClipBoard;
   end;
  end
 else
  raise Exception.CreateRes(@SCannotOpenClipboard);
end;


function TMessageForm.GetFormText: String;
var
 DividerLine, ButtonCaptions: string;
 i: integer;
begin
 DividerLine := StringOfChar('-', 27) + sLineBreak;
 for i := 0 to ComponentCount - 1 do
  if Components[i] is TButton then
   ButtonCaptions := ButtonCaptions + TButton(Components[i]).Caption
                     + StringOfChar(' ', 3);
 ButtonCaptions := StringReplace(ButtonCaptions,'&','', [rfReplaceAll]);
 Result:=Format('%s%s%s%s%s%s%s%s%s%s',[DividerLine,Caption,sLineBreak,
                DividerLine,Message.Caption,sLineBreak,DividerLine,
                ButtonCaptions,sLineBreak,DividerLine]);
end;


constructor TMessageForm.CreateNew(AOwner: TComponent);
var
 NonClientMetrics: TNonClientMetrics;
begin
 inherited CreateNew(AOwner);
 NonClientMetrics.cbSize := sizeof(NonClientMetrics);
 if SystemParametersInfo(SPI_GETNONCLIENTMETRICS, 0, @NonClientMetrics, 0) then
  Font.Handle := CreateFontIndirect(NonClientMetrics.lfMessageFont);
end;



end.
