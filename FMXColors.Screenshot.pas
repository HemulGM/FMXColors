unit FMXColors.Screenshot;

interface
{$IFDEF MSWINDOWS}

uses
  Classes {$IFDEF MSWINDOWS} , Windows {$ENDIF}, System.SysUtils, FMX.Graphics, FMX.Types, VCL.Forms, VCL.Graphics;

procedure TakeScreenshot(Dest: FMX.Graphics.TBitmap);
{$ENDIF MSWINDOWS}

implementation

{$IFDEF MSWINDOWS}

procedure WriteWindowsToStream(AStream: TStream);
var
  dc: HDC;
  lpPal: PLOGPALETTE;
  bm: TBitMap;
begin
{test width and height}
  bm := TBitmap.Create;

  bm.Width := Screen.Width;
  bm.Height := Screen.Height;

  //get the screen dc
  dc := GetDc(0);
  if (dc = 0) then
    exit;
 //do we have a palette device?
  if (GetDeviceCaps(dc, RASTERCAPS) and RC_PALETTE = RC_PALETTE) then
  begin
    //allocate memory for a logical palette
    GetMem(lpPal, sizeof(TLOGPALETTE) + (255 * sizeof(TPALETTEENTRY)));
    //zero it out to be neat
    FillChar(lpPal^, sizeof(TLOGPALETTE) + (255 * sizeof(TPALETTEENTRY)), #0);
    //fill in the palette version
    lpPal^.palVersion := $300;
    //grab the system palette entries
    lpPal^.palNumEntries := GetSystemPaletteEntries(dc, 0, 256, lpPal^.palPalEntry);
    if (lpPal^.PalNumEntries <> 0) then
    begin
      //create the palette
      bm.Palette := CreatePalette(lpPal^);
    end;
    FreeMem(lpPal, sizeof(TLOGPALETTE) + (255 * sizeof(TPALETTEENTRY)));
  end;
  //copy from the screen to the bitmap
  BitBlt(bm.Canvas.Handle, 0, 0, Screen.Width, Screen.Height, dc, 0, 0, SRCCOPY);

  bm.SaveToStream(AStream);

  FreeAndNil(bm);
  //release the screen dc
  ReleaseDc(0, dc);
end;

procedure TakeScreenshot(Dest: FMX.Graphics.TBitmap);
var
  Stream: TMemoryStream;
begin
  try
    Stream := TMemoryStream.Create;
    WriteWindowsToStream(Stream);
    Stream.Position := 0;
    Dest.LoadFromStream(Stream);
  finally
    Stream.Free;
  end;
end;

{$ENDIF MSWINDOWS}
end.

