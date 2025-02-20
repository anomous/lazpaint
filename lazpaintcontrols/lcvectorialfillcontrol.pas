unit LCVectorialFillControl;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Controls, LCVectorialFillInterface,
  LCVectorialFill, BGRABitmap, BGRABitmapTypes, BGRAGradientScanner,
  LCVectorOriginal;

type
  TLCFillTarget = LCVectorialFillInterface.TLCFillTarget;

const
  ftPen = LCVectorialFillInterface.ftPen;
  ftBack = LCVectorialFillInterface.ftBack;
  ftOutline = LCVectorialFillInterface.ftOutline;

type
  { TLCVectorialFillControl }

  TLCVectorialFillControl = class(TWinControl)
  private
    function GetCanAdjustToShape: boolean;
    function GetFillType: TVectorialFillType;
    function GetGradEndColor: TBGRAPixel;
    function GetGradInterp: TBGRAColorInterpolation;
    function GetGradRepetition: TBGRAGradientRepetition;
    function GetGradStartColor: TBGRAPixel;
    function GetGradType: TGradientType;
    function GetSolidColor: TBGRAPixel;
    function GetTexOpacity: byte;
    function GetTexRepetition: TTextureRepetition;
    function GetTexture: TBGRABitmap;
    function GetToolIconSize: integer;
    procedure SetCanAdjustToShape(AValue: boolean);
    procedure SetFillType(AValue: TVectorialFillType);
    procedure SetGradEndColor(AValue: TBGRAPixel);
    procedure SetGradientType(AValue: TGradientType);
    procedure SetGradInterpolation(AValue: TBGRAColorInterpolation);
    procedure SetGradRepetition(AValue: TBGRAGradientRepetition);
    procedure SetGradStartColor(AValue: TBGRAPixel);
    procedure SetSolidColor(AValue: TBGRAPixel);
    procedure SetTexture(AValue: TBGRABitmap);
    procedure SetTextureOpacity(AValue: byte);
    procedure SetTextureRepetition(AValue: TTextureRepetition);
    procedure SetToolIconSize(AValue: integer);
  protected
    FInterface: TVectorialFillInterface;
    FOnAdjustToShape: TNotifyEvent;
    FOnFillChange: TNotifyEvent;
    FOnFillTypeChange: TNotifyEvent;
    FOnTextureChange: TNotifyEvent;
    procedure CalculatePreferredSize(var PreferredWidth, PreferredHeight: integer;
      {%H-}WithThemeSpace: Boolean); override;
    procedure DoOnAdjustToShape(Sender: TObject);
    procedure DoOnFillChange(Sender: TObject);
    procedure DoOnFillTypeChange(Sender: TObject);
    procedure DoOnTextureChange(Sender: TObject);
    procedure DoOnResize; override;
  public
    constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;
    procedure AssignFill(AFill: TVectorialFill);
    function CreateShapeFill(AShape: TVectorShape): TVectorialFill;
    procedure UpdateShapeFill(AShape: TVectorShape; ATarget: TLCFillTarget);
    property FillType: TVectorialFillType read GetFillType write SetFillType;
    property SolidColor: TBGRAPixel read GetSolidColor write SetSolidColor;
    property GradientType: TGradientType read GetGradType write SetGradientType;
    property GradStartColor: TBGRAPixel read GetGradStartColor write SetGradStartColor;
    property GradEndColor: TBGRAPixel read GetGradEndColor write SetGradEndColor;
    property GradRepetition: TBGRAGradientRepetition read GetGradRepetition write SetGradRepetition;
    property GradInterpolation: TBGRAColorInterpolation read GetGradInterp write SetGradInterpolation;
    property Texture: TBGRABitmap read GetTexture write SetTexture;
    property TextureRepetition: TTextureRepetition read GetTexRepetition write SetTextureRepetition;
    property TextureOpacity: byte read GetTexOpacity write SetTextureOpacity;
    property CanAdjustToShape: boolean read GetCanAdjustToShape write SetCanAdjustToShape;
    property OnFillChange: TNotifyEvent read FOnFillChange write FOnFillChange;
    property OnTextureChange: TNotifyEvent read FOnTextureChange write FOnTextureChange;
    property OnAdjustToShape: TNotifyEvent read FOnAdjustToShape write FOnAdjustToShape;
    property OnFillTypeChange: TNotifyEvent read FOnFillTypeChange write FOnFillTypeChange;
  published
    property AutoSize;
    property Align;
    property Enabled;
    property Visible;
    property ToolIconSize: integer read GetToolIconSize write SetToolIconSize;
  end;

procedure Register;

implementation

uses Types;

procedure Register;
begin
  RegisterComponents('Lazpaint Controls', [TLCVectorialFillControl]);
end;

{ TLCVectorialFillControl }

function TLCVectorialFillControl.GetCanAdjustToShape: boolean;
begin
  result := FInterface.CanAdjustToShape;
end;

function TLCVectorialFillControl.GetFillType: TVectorialFillType;
begin
  result := FInterface.FillType;
end;

function TLCVectorialFillControl.GetGradEndColor: TBGRAPixel;
begin
  result := FInterface.GradEndColor;
end;

function TLCVectorialFillControl.GetGradInterp: TBGRAColorInterpolation;
begin
  result := FInterface.GradInterpolation;
end;

function TLCVectorialFillControl.GetGradRepetition: TBGRAGradientRepetition;
begin
  result := FInterface.GradRepetition;
end;

function TLCVectorialFillControl.GetGradStartColor: TBGRAPixel;
begin
  result := FInterface.GradStartColor;
end;

function TLCVectorialFillControl.GetGradType: TGradientType;
begin
  result := FInterface.GradientType;
end;

function TLCVectorialFillControl.GetSolidColor: TBGRAPixel;
begin
  result := FInterface.SolidColor;
end;

function TLCVectorialFillControl.GetTexOpacity: byte;
begin
  result := FInterface.TextureOpacity;
end;

function TLCVectorialFillControl.GetTexRepetition: TTextureRepetition;
begin
  result := FInterface.TextureRepetition;
end;

function TLCVectorialFillControl.GetTexture: TBGRABitmap;
begin
  result := FInterface.Texture;
end;

function TLCVectorialFillControl.GetToolIconSize: integer;
begin
  result := FInterface.ImageListSize.cy;
end;

procedure TLCVectorialFillControl.SetCanAdjustToShape(AValue: boolean);
begin
  FInterface.CanAdjustToShape := AValue;
end;

procedure TLCVectorialFillControl.SetFillType(AValue: TVectorialFillType);
begin
  FInterface.FillType := AValue;
end;

procedure TLCVectorialFillControl.SetGradEndColor(AValue: TBGRAPixel);
begin
  FInterface.GradEndColor := AValue;
end;

procedure TLCVectorialFillControl.SetGradientType(AValue: TGradientType);
begin
  FInterface.GradientType := AValue;
end;

procedure TLCVectorialFillControl.SetGradInterpolation(
  AValue: TBGRAColorInterpolation);
begin
  FInterface.GradInterpolation := AValue;
end;

procedure TLCVectorialFillControl.SetGradRepetition(
  AValue: TBGRAGradientRepetition);
begin
  FInterface.GradRepetition := AValue;
end;

procedure TLCVectorialFillControl.SetGradStartColor(AValue: TBGRAPixel);
begin
  FInterface.GradStartColor := AValue;
end;

procedure TLCVectorialFillControl.SetSolidColor(AValue: TBGRAPixel);
begin
  FInterface.SolidColor := AValue;
end;

procedure TLCVectorialFillControl.SetTexture(AValue: TBGRABitmap);
begin
  FInterface.Texture := AValue;
end;

procedure TLCVectorialFillControl.SetTextureOpacity(AValue: byte);
begin
  FInterface.TextureOpacity := AValue;
end;

procedure TLCVectorialFillControl.SetTextureRepetition(
  AValue: TTextureRepetition);
begin
  FInterface.TextureRepetition := AValue;
end;

procedure TLCVectorialFillControl.SetToolIconSize(AValue: integer);
begin
  FInterface.ImageListSize := Size(AValue,AValue);
end;

procedure TLCVectorialFillControl.CalculatePreferredSize(var PreferredWidth,
  PreferredHeight: integer; WithThemeSpace: Boolean);
begin
  with FInterface.PreferredSize do
  begin
    PreferredWidth := cx;
    PreferredHeight := cy;
  end;
end;

procedure TLCVectorialFillControl.DoOnAdjustToShape(Sender: TObject);
begin
  if Assigned(FOnAdjustToShape) then FOnAdjustToShape(self);
end;

procedure TLCVectorialFillControl.DoOnFillChange(Sender: TObject);
begin
  if Assigned(FOnFillChange) then FOnFillChange(self);
end;

procedure TLCVectorialFillControl.DoOnFillTypeChange(Sender: TObject);
begin
  InvalidatePreferredSize;
  AdjustSize;
  if Assigned(FOnFillTypeChange) then FOnFillTypeChange(self);
end;

procedure TLCVectorialFillControl.DoOnTextureChange(Sender: TObject);
begin
  if Assigned(FOnTextureChange) then FOnTextureChange(self);
end;

procedure TLCVectorialFillControl.DoOnResize;
begin
  inherited DoOnResize;
  FInterface.LoadImageList;
  FInterface.ContainerSizeChanged;
end;

constructor TLCVectorialFillControl.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  FInterface := TVectorialFillInterface.Create(nil, 16,16);
  FInterface.OnFillChange:=@DoOnFillChange;
  FInterface.OnTextureChange:=@DoOnTextureChange;
  FInterface.OnAdjustToShape:=@DoOnAdjustToShape;
  FInterface.OnFillTypeChange:=@DoOnFillTypeChange;
  FInterface.Container := self;
end;

destructor TLCVectorialFillControl.Destroy;
begin
  FreeAndNil(FInterface);
  inherited Destroy;
end;

procedure TLCVectorialFillControl.AssignFill(AFill: TVectorialFill);
begin
  FInterface.AssignFill(AFill);
end;

function TLCVectorialFillControl.CreateShapeFill(AShape: TVectorShape): TVectorialFill;
begin
  result := FInterface.CreateShapeFill(AShape);
end;

procedure TLCVectorialFillControl.UpdateShapeFill(AShape: TVectorShape;
  ATarget: TLCFillTarget);
begin
  FInterface.UpdateShapeFill(AShape, ATarget);
end;

end.

