unit FMXColors.Main;

interface

uses
  System.SysUtils, Winapi.Windows, System.Types, System.UITypes, System.Classes, System.Variants, FMX.Types,
  FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls, FMX.Colors, FMX.Controls.Presentation, FMX.Layouts,
  FMX.ListBox, FMX.Objects, FMX.Effects, FMX.TabControl, FMX.Edit, System.ImageList, FMX.ImgList;

type
  TMagnify = array[0..256, 0..256] of TAlphaColor;

  TFormMain = class(TForm)
    LayoutLeftSide: TLayout;
    Rectangle5: TRectangle;
    LayoutHead: TLayout;
    Rectangle6: TRectangle;
    LayoutRightSide: TLayout;
    Rectangle7: TRectangle;
    LayoutTabs: TLayout;
    StyleBook1: TStyleBook;
    ListBoxPins: TListBox;
    ListBoxItem1: TListBoxItem;
    Rectangle8: TRectangle;
    LayoutClient: TLayout;
    Rectangle9: TRectangle;
    ListBoxItem2: TListBoxItem;
    Rectangle10: TRectangle;
    Path1: TPath;
    TabControl1: TTabControl;
    TabItem1: TTabItem;
    TabItem2: TTabItem;
    Layout5: TLayout;
    ShadowEffect1: TShadowEffect;
    ColorQuad: TColorQuad;
    Layout6: TLayout;
    HueTrackBar: THueTrackBar;
    AlphaTrackBar: TAlphaTrackBar;
    GradientEdit1: TGradientEdit;
    Layout1: TLayout;
    Layout2: TLayout;
    ColorBox: TColorBox;
    Layout3: TLayout;
    Layout4: TLayout;
    Layout7: TLayout;
    Line1: TLine;
    Label1: TLabel;
    EditResHEX: TEdit;
    Layout8: TLayout;
    Rectangle1: TRectangle;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButtonQuit: TSpeedButton;
    Line2: TLine;
    SpeedButton5: TSpeedButton;
    SpeedButton6: TSpeedButton;
    SpeedButton7: TSpeedButton;
    Label2: TLabel;
    EditRGB_R: TEdit;
    EditRGB_G: TEdit;
    EditRGB_B: TEdit;
    SpinEditButton1: TSpinEditButton;
    SpinEditButton2: TSpinEditButton;
    SpinEditButton3: TSpinEditButton;
    SpinEditButton4: TSpinEditButton;
    Label3: TLabel;
    EditCMYK_C: TEdit;
    SpinEditButton5: TSpinEditButton;
    EditCMYK_M: TEdit;
    SpinEditButton6: TSpinEditButton;
    EditCMYK_Y: TEdit;
    SpinEditButton7: TSpinEditButton;
    EditCMYK_K: TEdit;
    SpinEditButton8: TSpinEditButton;
    SpeedButtonMenu: TSpeedButton;
    SpeedButton9: TSpeedButton;
    Label4: TLabel;
    EditRGB: TEdit;
    SpinEditButton9: TSpinEditButton;
    Label5: TLabel;
    EditResTColor: TEdit;
    SpinEditButton10: TSpinEditButton;
    Label6: TLabel;
    EditHSV_H: TEdit;
    SpinEditButton11: TSpinEditButton;
    EditHSV_S: TEdit;
    SpinEditButton12: TSpinEditButton;
    EditHSV_V: TEdit;
    SpinEditButton13: TSpinEditButton;
    Label7: TLabel;
    EditResTAlphaColor: TEdit;
    SpinEditButton14: TSpinEditButton;
    ListBoxItem3: TListBoxItem;
    Rectangle2: TRectangle;
    ListBoxItem4: TListBoxItem;
    Rectangle3: TRectangle;
    ListBoxItem5: TListBoxItem;
    Rectangle4: TRectangle;
    ListBoxItem6: TListBoxItem;
    Rectangle11: TRectangle;
    ListBoxItem7: TListBoxItem;
    Rectangle12: TRectangle;
    ListBoxItem8: TListBoxItem;
    Rectangle13: TRectangle;
    TimerPXUC: TTimer;
    PaintBoxMagnify: TPaintBox;
    Layout9: TLayout;
    procedure Rectangle6MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
    procedure HueTrackBarChange(Sender: TObject);
    procedure AlphaTrackBarChange(Sender: TObject);
    procedure SpeedButtonQuitClick(Sender: TObject);
    procedure EditCMYK_KValidating(Sender: TObject; var Text: string);
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpeedButton6Click(Sender: TObject);
    procedure ColorQuadChange(Sender: TObject);
    procedure EditRGBValidating(Sender: TObject; var Text: string);
    procedure TimerPXUCTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure EditHSV_HValidating(Sender: TObject; var Text: string);
    procedure PaintBoxMagnifyPaint(Sender: TObject; Canvas: TCanvas);
    procedure ListBoxPinsViewportPositionChange(Sender: TObject; const OldViewportPosition, NewViewportPosition: TPointF;
      const ContentSizeChanged: Boolean);
    procedure FormDestroy(Sender: TObject);
  private
    FDataColor: TAlphaColor;
    FMagnifyPoint: TPointF;
    FMagnifySize: TSize;
    FKeepColor: Boolean;
    FMgEmpty: Boolean;
    FMagnify: TBitmap;
    FSettingColor: Boolean;
    procedure SetDataColor(const Value: TAlphaColor);
    function GetPixelUnderCursor: TColor;
  public
    { Public declarations }
  end;

var
  FormMain: TFormMain;

implementation

uses
  System.Math, HGM.Utils.Color, FMXColors.Screenshot, System.UIConsts;

{$R *.fmx}

function CtrlDown: Boolean;
begin
  Result := GetKeyState(VK_CONTROL) < 0;
end;

function ShiftDown: Boolean;
begin
  Result := GetKeyState(VK_SHIFT) < 0;
end;

function TFormMain.GetPixelUnderCursor: TColor;
var
  DC: HDC;
  Cur: TPoint;
begin
  DC := GetDC(0);
  GetCursorPos(Cur);
  FMagnifyPoint := Cur;
  Result := GetPixel(DC, Cur.X, Cur.Y);
  TakeScreenshot(FMagnify);
  FMgEmpty := False;
  PaintBoxMagnify.Repaint;
end;

procedure TFormMain.AlphaTrackBarChange(Sender: TObject);
begin
  ColorQuad.Alpha := AlphaTrackBar.Value;
end;

procedure TFormMain.ColorQuadChange(Sender: TObject);
begin
  SetDataColor(ColorBox.Color);
end;

procedure TFormMain.EditCMYK_KValidating(Sender: TObject; var Text: string);
var
  I: Integer;
begin
  if not TryStrToInt(Text, I) then
    Text := (Sender as TEdit).Text
  else
    Text := Max(0, Min(I, 255)).ToString;
end;

procedure TFormMain.EditHSV_HValidating(Sender: TObject; var Text: string);
var
  I: Integer;
begin
  if not TryStrToInt(Text, I) then
    Text := (Sender as TEdit).Text
  else
    Text := Max(0, Min(I, 360)).ToString;
end;

procedure TFormMain.EditRGBValidating(Sender: TObject; var Text: string);
var
  I: Integer;
begin
  if not TryStrToInt(Text, I) then
    Text := (Sender as TEdit).Text
  else
    Text := Max(0, Min(I, MaxLongInt)).ToString;
end;

procedure TFormMain.FormCreate(Sender: TObject);
begin
  FMagnify := TBitmap.Create;
  FMagnifySize := TSize.Create(5, 5);
  FKeepColor := False;
  FMgEmpty := True;
end;

procedure TFormMain.FormDestroy(Sender: TObject);
begin
  FMagnify.Free;
end;

procedure TFormMain.HueTrackBarChange(Sender: TObject);
begin
  ColorQuad.Hue := HueTrackBar.Value;
end;

procedure TFormMain.ListBoxPinsViewportPositionChange(Sender: TObject; const OldViewportPosition, NewViewportPosition:
  TPointF; const ContentSizeChanged: Boolean);
var
  i: Integer;
begin
  if ListBoxPins.ContentBounds.Bottom - (NewViewportPosition.Y + ListBoxPins.Height) <= 0 then
  begin
    for i := 1 to 20 do
      ListBoxPins.Items.Add('');
  end;
end;

procedure TFormMain.PaintBoxMagnifyPaint(Sender: TObject; Canvas: TCanvas);
var
  PixW: Single;
  R: TRectF;
  S: string;
  x, y: Integer;
begin
  Canvas.BeginScene;
  if FMgEmpty then
  begin
    R := PaintBoxMagnify.ClipRect;
    S := 'Ctrl+Shift';
    Canvas.FillText(R, S, False, 1, [], TTextAlign.Center, TTextAlign.Center);
  end
  else
  begin
    Canvas.DrawBitmap(FMagnify,
      TRectF.Create(TPointF.Create(FMagnifyPoint.X - FMagnifySize.Width div 2,
      FMagnifyPoint.Y - FMagnifySize.Height div 2),
      FMagnifySize.Width, FMagnifySize.Height),
      TRectF.Create(0, 0, PaintBoxMagnify.Width, PaintBoxMagnify.Height),
      1, True);
    PixW := PaintBoxMagnify.Width / FMagnifySize.Width;
    R.Width := Ceil(PixW);
    R.Height := Ceil(PixW);
    R.Location := Point(Round((PixW * FMagnifySize.Width / 2) - (PixW / 2)), Round((PixW * FMagnifySize.Width / 2) - (PixW / 2)));
    Canvas.Stroke.Kind := TBrushKind.Solid;
    Canvas.Stroke.Color := TAlphaColorRec.Black;
    Canvas.DrawRect(R, 0, 0, [], 1);
  end;
  Canvas.EndScene;
end;

procedure TFormMain.Rectangle6MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  StartWindowDrag;
end;

procedure TFormMain.SpeedButton5Click(Sender: TObject);
begin
  TabControl1.ActiveTab := TabItem1;
end;

procedure TFormMain.SpeedButton6Click(Sender: TObject);
begin
  TabControl1.ActiveTab := TabItem2;
end;

procedure TFormMain.SpeedButtonQuitClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TFormMain.TimerPXUCTimer(Sender: TObject);
var
  AC: TAlphaColorF;
begin
  if (CtrlDown and ShiftDown) or FKeepColor then
  begin
    AC := TAlphaColorF.Create(RGBtoBGR(GetPixelUnderCursor));
    AC.A := 1;
    SetDataColor(AC.ToAlphaColor);
  end;
end;

procedure TFormMain.SetDataColor(const Value: TAlphaColor);
var
  C, M, Y, K, R, G, B: Byte;
  H, V, S: Double;
  nH, nL, nS: Single;
  FColor: TColor;
begin
  if FSettingColor then
    Exit;
  FSettingColor := True;

  FDataColor := Value;
  FColor := AlphaColorToColor(Value);

  R := ColorToRGB(FColor).R;
  G := ColorToRGB(FColor).G;
  B := ColorToRGB(FColor).B;

  //TrackBarL.Position := 100;

  EditRGB_R.Text := R.ToString;
  EditRGB_G.Text := G.ToString;
  EditRGB_B.Text := B.ToString;
  EditRGB.Text := ColorToRGB(RGBToColor(R, G, B));
  //
  EditResHEX.Text := ColorToHtml(FColor);
  EditResTColor.Text := ColorToString(FColor);
  EditResTAlphaColor.Text := AlphaColorToString(FDataColor);

  RGBToCMYK(R, G, B, C, M, Y, K);
  EditCMYK_C.Text := C.ToString;
  EditCMYK_M.Text := M.ToString;
  EditCMYK_Y.Text := Y.ToString;
  EditCMYK_K.Text := K.ToString;

  RGBToHSV(R, G, B, H, S, V);
  EditHSV_H.Text := Round(H).ToString;
  EditHSV_S.Text := Round(S).ToString;
  EditHSV_V.Text := Round(V).ToString;

  RGBtoHSL(FDataColor, nH, nS, nL);

  HueTrackBar.Value := nH;
  ColorQuad.Sat := nS;
  ColorQuad.Lum := nL;

  ColorBox.Color := FDataColor;

  //HexaColorPicker1.SelectedColor := FDataColor;
  //HSColorPicker1.SelectedColor := FDataColor;
  //HSVColorPicker1.SelectedColor := FDataColor;
  //if Assigned(FActiveShape) then
  //  FActiveShape.Brush.Color := FDataColor;


  FSettingColor := False;
end;

end.

