unit Utils;

interface

uses
  Vcl.StdCtrls, Vcl.Dialogs, System.SysUtils, Vcl.Controls, Vcl.Graphics, System.Math;

function ValidarCampoEdit(Edit: TEdit; const NomeCampo: string): Boolean;
function ValidarValorUnitario(Edit: TEdit; const NomeCampo: string; out Valor: Currency): Boolean;
procedure AtualizarCorLabel(Control: TControl; const ValorTexto: string);

implementation

function ValidarCampoEdit(Edit: TEdit; const NomeCampo: string): Boolean;
begin
  Result := True;

  if Trim(Edit.Text) = '' then
  begin
    ShowMessage('Por favor, insira um valor para ' + NomeCampo);
    Edit.SetFocus;
    Result := False;
  end;
end;

function ValidarValorUnitario(Edit: TEdit; const NomeCampo: string; out Valor: Currency): Boolean;
var
  ValorTexto: string;
  FormatSettings: TFormatSettings;
begin
  FormatSettings := TFormatSettings.Create;
  FormatSettings.DecimalSeparator := '.';
  FormatSettings.ThousandSeparator := ',';

  ValorTexto := StringReplace(Edit.Text, '.', '', [rfReplaceAll]);
  ValorTexto := StringReplace(ValorTexto, ',', '.', []);

  Valor := StrToCurrDef(ValorTexto, 0, FormatSettings);

  Result := Valor > 0;

  if not Result then
  begin
    ShowMessage('O ' + NomeCampo + ' deve ser maior que zero.');
    Edit.SetFocus;
  end;
end;

procedure AtualizarCorLabel(Control: TControl; const ValorTexto: string);
begin
  if Control is TLabel then
  begin
    TLabel(Control).Font.Color := IfThen(ValorTexto = '', clRed, clWindowText);
  end
  else
  begin
    ShowMessage('O controle fornecido não é um TLabel.');
  end;
end;

end.
