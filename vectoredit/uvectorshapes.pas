unit uvectorshapes;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, uvectororiginal, BGRABitmapTypes, BGRALayerOriginal, BGRABitmap, BGRATransform;

type
  { TCustomRectShape }

  TCustomRectShape = class(TVectorShape)
  protected
    FOrigin, FXAxis, FYAxis: TPointF;
    FOriginBackup,FXUnitBackup,FYUnitBackup,
    FXAxisBackup,FYAxisBackup: TPointF;
    FXSizeBackup,FYSizeBackup: single;
    procedure DoMoveXAxis(ANewCoord: TPointF; AShift: TShiftState; AFactor: single);
    procedure DoMoveYAxis(ANewCoord: TPointF; AShift: TShiftState; AFactor: single);
    procedure DoMoveXYCorner(ANewCoord: TPointF; AShift: TShiftState; AFactorX, AFactorY: single);
    procedure OnMoveOrigin({%H-}ASender: TObject; {%H-}APrevCoord, ANewCoord: TPointF; {%H-}AShift: TShiftState);
    procedure OnMoveXAxis({%H-}ASender: TObject; {%H-}APrevCoord, ANewCoord: TPointF; AShift: TShiftState);
    procedure OnMoveYAxis({%H-}ASender: TObject; {%H-}APrevCoord, ANewCoord: TPointF; AShift: TShiftState);
    procedure OnMoveXAxisNeg({%H-}ASender: TObject; {%H-}APrevCoord, ANewCoord: TPointF; AShift: TShiftState);
    procedure OnMoveYAxisNeg({%H-}ASender: TObject; {%H-}APrevCoord, ANewCoord: TPointF; AShift: TShiftState);
    procedure OnMoveXYCorner({%H-}ASender: TObject; {%H-}APrevCoord, ANewCoord: TPointF; AShift: TShiftState);
    procedure OnMoveXNegYCorner({%H-}ASender: TObject; {%H-}APrevCoord, ANewCoord: TPointF; AShift: TShiftState);
    procedure OnMoveXYNegCorner({%H-}ASender: TObject; {%H-}APrevCoord, ANewCoord: TPointF; AShift: TShiftState);
    procedure OnMoveXNegYNegCorner({%H-}ASender: TObject; {%H-}APrevCoord, ANewCoord: TPointF; AShift: TShiftState);
    procedure OnStartMove({%H-}ASender: TObject; {%H-}APointIndex: integer; {%H-}AShift: TShiftState);
    function GetAffineBox(AMatrix: TAffineMatrix; APixelCentered: boolean): TAffineBox;
    function GetCornerPositition: single; virtual; abstract;
    function GetOrthoRect(AMatrix: TAffineMatrix; out ARect: TRectF): boolean;
  public
    procedure QuickDefine(const APoint1,APoint2: TPointF); override;
    procedure LoadFromStorage(AStorage: TBGRACustomOriginalStorage); override;
    procedure SaveToStorage(AStorage: TBGRACustomOriginalStorage); override;
    function GetRenderBounds({%H-}ADestRect: TRect; AMatrix: TAffineMatrix; {%H-}AOptions: TRenderBoundsOptions = []): TRectF; override;
    procedure ConfigureEditor(AEditor: TBGRAOriginalEditor); override;
  end;

  { TRectShape }

  TRectShape = class(TCustomRectShape)
  protected
    function PenVisible(AAssumePenFill: boolean = false): boolean;
    function BackVisible: boolean;
    function GetCornerPositition: single; override;
  public
    class function Fields: TVectorShapeFields; override;
    procedure Render(ADest: TBGRABitmap; AMatrix: TAffineMatrix; ADraft: boolean); override;
    function GetRenderBounds({%H-}ADestRect: TRect; AMatrix: TAffineMatrix; AOptions: TRenderBoundsOptions = []): TRectF; override;
    function PointInShape(APoint: TPointF): boolean; override;
    function GetIsSlow(AMatrix: TAffineMatrix): boolean; override;
    class function StorageClassName: RawByteString; override;
  end;

  { TEllipseShape }

  TEllipseShape = class(TCustomRectShape)
  protected
    function PenVisible(AAssumePenFill: boolean = false): boolean;
    function BackVisible: boolean;
    function GetCornerPositition: single; override;
  public
    constructor Create(AContainer: TVectorOriginal); override;
    class function Fields: TVectorShapeFields; override;
    procedure Render(ADest: TBGRABitmap; AMatrix: TAffineMatrix; ADraft: boolean); override;
    function GetRenderBounds({%H-}ADestRect: TRect; AMatrix: TAffineMatrix; AOptions: TRenderBoundsOptions = []): TRectF; override;
    function PointInShape(APoint: TPointF): boolean; override;
    function GetIsSlow(AMatrix: TAffineMatrix): boolean; override;
    class function StorageClassName: RawByteString; override;
  end;

  { TCustomPolypointShape }

  TCustomPolypointShape = class(TVectorShape)
  private
    FClosed: boolean;
    function GetPoint(AIndex: integer): TPointF;
    function GetPointCount: integer;
    procedure SetPoint(AIndex: integer; AValue: TPointF);
  protected
    FPoints: array of record
               coord: TPointF;
               editorIndex: integer;
             end;
    FCenterPoint: TPointF;
    FCenterPointEditorIndex: integer;
    FCurPoint: integer;
    FAddingPoint: boolean;
    FMousePos: TPointF;
    FHoverPoint: integer;
    procedure OnMovePoint({%H-}ASender: TObject; {%H-}APrevCoord, ANewCoord: TPointF; {%H-}AShift: TShiftState);
    procedure OnMoveCenterPoint({%H-}ASender: TObject; {%H-}APrevCoord, ANewCoord: TPointF; {%H-}AShift: TShiftState);
    procedure OnStartMove({%H-}ASender: TObject; APointIndex: integer; {%H-}AShift: TShiftState);
    function GetCurve(AMatrix: TAffineMatrix): ArrayOfTPointF; virtual;
    procedure SetUsermode(AValue: TVectorShapeUsermode); override;
    function GetClosed: boolean; virtual;
    procedure SetClosed(AValue: boolean); virtual;
    function PointsEqual(const APoint1, APoint2: TPointF): boolean;
    procedure OnHoverPoint({%H-}ASender: TObject; APointIndex: integer); virtual;
    procedure InsertPointAuto;
  public
    constructor Create(AContainer: TVectorOriginal); override;
    procedure AddPoint(const APoint: TPointF);
    function RemovePoint(AIndex: integer): boolean;
    procedure InsertPoint(AIndex: integer; APoint: TPointF);
    procedure MouseMove({%H-}Shift: TShiftState; X, Y: single; var {%H-}ACursor: TOriginalEditorCursor; var AHandled: boolean); override;
    procedure MouseDown(RightButton: boolean; {%H-}Shift: TShiftState; {%H-}X, {%H-}Y: single; var {%H-}ACursor: TOriginalEditorCursor; var AHandled: boolean); override;
    procedure KeyDown({%H-}Shift: TShiftState; Key: TSpecialKey; var AHandled: boolean); override;
    procedure QuickDefine(const APoint1,APoint2: TPointF); override;
    procedure LoadFromStorage(AStorage: TBGRACustomOriginalStorage); override;
    procedure SaveToStorage(AStorage: TBGRACustomOriginalStorage); override;
    procedure ConfigureEditor(AEditor: TBGRAOriginalEditor); override;
    class function Usermodes: TVectorShapeUsermodes; override;
    property Points[AIndex:integer]: TPointF read GetPoint write SetPoint;
    property PointCount: integer read GetPointCount;
    property Closed: boolean read GetClosed write SetClosed;
    property HoverPoint: integer read FHoverPoint;
  end;

  { TPolylineShape }

  TPolylineShape = class(TCustomPolypointShape)
  protected
    function PenVisible(AAssumePenFill: boolean = false): boolean;
    function BackVisible: boolean;
  public
    class function Fields: TVectorShapeFields; override;
    procedure Render(ADest: TBGRABitmap; AMatrix: TAffineMatrix; ADraft: boolean); override;
    function GetRenderBounds({%H-}ADestRect: TRect; AMatrix: TAffineMatrix; AOptions: TRenderBoundsOptions = []): TRectF; override;
    function PointInShape(APoint: TPointF): boolean; override;
    function GetIsSlow({%H-}AMatrix: TAffineMatrix): boolean; override;
    class function StorageClassName: RawByteString; override;
  end;

  { TCurveShape }

  TCurveShape = class(TPolylineShape)
  private
    FSplineStyle: TSplineStyle;
    procedure SetSplineStyle(AValue: TSplineStyle);
  protected
    function GetCurve(AMatrix: TAffineMatrix): ArrayOfTPointF; override;
  public
    constructor Create(AContainer: TVectorOriginal); override;
    procedure LoadFromStorage(AStorage: TBGRACustomOriginalStorage); override;
    procedure SaveToStorage(AStorage: TBGRACustomOriginalStorage); override;
    class function StorageClassName: RawByteString; override;
    property SplineStyle: TSplineStyle read FSplineStyle write SetSplineStyle;
  end;

implementation

uses BGRAPen, BGRAGraphics, BGRAFillInfo, BGRAPath, math;

function MatrixForPixelCentered(const AMatrix: TAffineMatrix): TAffineMatrix;
begin
  result := AffineMatrixTranslation(-0.5,-0.5) * AMatrix * AffineMatrixTranslation(0.5,0.5);
end;

procedure IncludePointF(var ARectF: TRectF; APointF: TPointF);
begin
  if APointF.x < ARectF.Left then ARectF.Left := APointF.x;
  if APointF.x > ARectF.Right then ARectF.Right := APointF.x;
  if APointF.y < ARectF.Top then ARectF.Top := APointF.y;
  if APointF.y > ARectF.Bottom then ARectF.Bottom := APointF.y;
end;

function GetPointsBoundsF(const APoints: array of TPointF): TRectF;
var
  i: Integer;
  firstPoint: Boolean;
begin
  result:= EmptyRectF;
  firstPoint := true;
  for i:= 0 to high(APoints) do
    if not isEmptyPointF(APoints[i]) then
    begin
      if firstPoint then
      begin
        result.TopLeft := APoints[i];
        result.BottomRight := APoints[i];
        firstPoint := false;
      end else
        IncludePointF(result, APoints[i]);
    end;
end;

{ TCustomRectShape }

procedure TCustomRectShape.DoMoveXAxis(ANewCoord: TPointF; AShift: TShiftState; AFactor: single);
var
  newSize: Single;
begin
  BeginUpdate;
  if (ssAlt in AShift) or (FXUnitBackup = PointF(0,0)) then
  begin
    FXAxis := FOriginBackup + AFactor*(ANewCoord - FOriginBackup);
    FYAxis := FYAxisBackup;
    FOrigin := FOriginBackup;
  end
  else
  begin
    newSize := AFactor*FXUnitBackup*(ANewCoord-FOriginBackup);
    if ssShift in AShift then
    begin
      FXAxis := FOriginBackup+FXUnitBackup*newSize;
      FYAxis := FYAxisBackup;
      FOrigin := FOriginBackup;
    end else
    begin
      FXAxis := FXAxisBackup + ((AFactor+1)*0.5)*(newSize-FXSizeBackup)*FXUnitBackup;
      FYAxis := FYAxisBackup + AFactor*(newSize-FXSizeBackup)*0.5*FXUnitBackup;
      FOrigin := FOriginBackup + AFactor*(newSize-FXSizeBackup)*0.5*FXUnitBackup;
    end;
  end;
  EndUpdate;
end;

procedure TCustomRectShape.DoMoveYAxis(ANewCoord: TPointF; AShift: TShiftState;
  AFactor: single);
var
  newSizeY: Single;
begin
  BeginUpdate;
  if (ssAlt in AShift) or (FYUnitBackup = PointF(0,0)) then
  begin
    FYAxis := FOriginBackup + AFactor*(ANewCoord - FOriginBackup);
    FXAxis := FXAxisBackup;
    FOrigin := FOriginBackup;
  end
  else
  begin
    newSizeY := AFactor*FYUnitBackup*(ANewCoord-FOriginBackup);
    if ssShift in AShift then
    begin
      FYAxis := FOriginBackup+FYUnitBackup*newSizeY;
      FXAxis := FXAxisBackup;
      FOrigin := FOriginBackup;
    end else
    begin
      FYAxis := FYAxisBackup + ((AFactor+1)*0.5)*(newSizeY-FYSizeBackup)*FYUnitBackup;
      FXAxis := FXAxisBackup + AFactor*(newSizeY-FYSizeBackup)*0.5*FYUnitBackup;
      FOrigin := FOriginBackup + AFactor*(newSizeY-FYSizeBackup)*0.5*FYUnitBackup;
    end;
  end;
  EndUpdate;
end;

procedure TCustomRectShape.DoMoveXYCorner(ANewCoord: TPointF;
  AShift: TShiftState; AFactorX, AFactorY: single);
var
  ratio, d: single;
  m: TAffineMatrix;
  newSize, prevCornerVect, newCornerVect: TPointF;
begin
  BeginUpdate;
  if (ssAlt in AShift) and (VectDet(FXUnitBackup,FYUnitBackup)<>0) and (FXSizeBackup<>0) and (FYSizeBackup<>0) then
  begin
    prevCornerVect := AFactorX*(FXAxisBackup - FOriginBackup) + AFactorY*(FYAxisBackup - FOriginBackup);
    newCornerVect := (ANewCoord - FOriginBackup)*(1/GetCornerPositition);
    m := AffineMatrixTranslation(FOriginBackup.x,FOriginBackup.y)*
         AffineMatrixScaledRotation(prevCornerVect, newCornerVect)*
         AffineMatrixTranslation(-FOriginBackup.x,-FOriginBackup.y);
    FOrigin := FOriginBackup;
    FXAxis := m * FXAxisBackup;
    FYAxis := m * FYAxisBackup;
  end else
  begin
    d := GetCornerPositition;
    m := AffineMatrixInverse(AffineMatrix(AFactorX*FXUnitBackup*d,AFactorY*FYUnitBackup*d,FOriginBackup));
    newSize := m*ANewCoord;
    if (ssShift in AShift) and (FXSizeBackup <> 0) and (FYSizeBackup <> 0) then
    begin
      ratio := (newSize.X/FXSizeBackup + newSize.Y/FYSizeBackup)/2;
      newSize.X := ratio*FXSizeBackup;
      newSize.Y := ratio*FYSizeBackup;
    end;
    FXAxis := FXAxisBackup + (AFactorX+1)*0.5*sqrt(d)*(newSize.X-FXSizeBackup)*FXUnitBackup + AFactorY*(newSize.Y-FYSizeBackup)*0.5*sqrt(d)*FYUnitBackup;
    FYAxis := FYAxisBackup + (AFactorY+1)*0.5*sqrt(d)*(newSize.Y-FYSizeBackup)*FYUnitBackup + AFactorX*(newSize.X-FXSizeBackup)*0.5*sqrt(d)*FXUnitBackup;
    FOrigin := FOriginBackup + AFactorX*(newSize.X-FXSizeBackup)*0.5*sqrt(d)*FXUnitBackup
                             + AFactorY*(newSize.Y-FYSizeBackup)*0.5*sqrt(d)*FYUnitBackup;
  end;
  EndUpdate;
end;

procedure TCustomRectShape.OnMoveOrigin(ASender: TObject; APrevCoord,
  ANewCoord: TPointF; AShift: TShiftState);
var
  delta: TPointF;
begin
  BeginUpdate;
  delta := ANewCoord - FOrigin;
  FOrigin := ANewCoord;
  FXAxis += delta;
  FYAxis += delta;
  if vsfBackFill in Fields then
    BackFill.Transform(AffineMatrixTranslation(delta.x, delta.y));
  EndUpdate;
end;

procedure TCustomRectShape.OnMoveXAxis(ASender: TObject; APrevCoord,
  ANewCoord: TPointF; AShift: TShiftState);
begin
  DoMoveXAxis(ANewCoord, AShift, 1);
end;

procedure TCustomRectShape.OnMoveYAxis(ASender: TObject; APrevCoord,
  ANewCoord: TPointF; AShift: TShiftState);
begin
  DoMoveYAxis(ANewCoord, AShift, 1);
end;

procedure TCustomRectShape.OnMoveXAxisNeg(ASender: TObject; APrevCoord,
  ANewCoord: TPointF; AShift: TShiftState);
begin
  DoMoveXAxis(ANewCoord, AShift, -1);
end;

procedure TCustomRectShape.OnMoveYAxisNeg(ASender: TObject; APrevCoord,
  ANewCoord: TPointF; AShift: TShiftState);
begin
  DoMoveYAxis(ANewCoord, AShift, -1);
end;

procedure TCustomRectShape.OnMoveXYCorner(ASender: TObject; APrevCoord,
  ANewCoord: TPointF; AShift: TShiftState);
begin
  DoMoveXYCorner(ANewCoord, AShift, 1, 1);
end;

procedure TCustomRectShape.OnMoveXNegYCorner(ASender: TObject; APrevCoord,
  ANewCoord: TPointF; AShift: TShiftState);
begin
  DoMoveXYCorner(ANewCoord, AShift, -1, 1);
end;

procedure TCustomRectShape.OnMoveXYNegCorner(ASender: TObject; APrevCoord,
  ANewCoord: TPointF; AShift: TShiftState);
begin
  DoMoveXYCorner(ANewCoord, AShift, 1, -1);
end;

procedure TCustomRectShape.OnMoveXNegYNegCorner(ASender: TObject; APrevCoord,
  ANewCoord: TPointF; AShift: TShiftState);
begin
  DoMoveXYCorner(ANewCoord, AShift, -1, -1);
end;

procedure TCustomRectShape.OnStartMove(ASender: TObject; APointIndex: integer;
  AShift: TShiftState);
begin
  FOriginBackup := FOrigin;
  FXAxisBackup := FXAxis;
  FXUnitBackup := FXAxis-FOrigin;
  FXSizeBackup := VectLen(FXUnitBackup);
  if FXSizeBackup <> 0 then FXUnitBackup := (1/FXSizeBackup)*FXUnitBackup;
  FYAxisBackup := FYAxis;
  FYUnitBackup := FYAxis-FOrigin;
  FYSizeBackup := VectLen(FYUnitBackup);
  if FYSizeBackup <> 0 then FYUnitBackup := (1/FYSizeBackup)*FYUnitBackup;
end;

function TCustomRectShape.GetAffineBox(AMatrix: TAffineMatrix; APixelCentered: boolean): TAffineBox;
var
  m: TAffineMatrix;
begin
  if not APixelCentered then
    m := AffineMatrixTranslation(0.5,0.5) * MatrixForPixelCentered(AMatrix)
  else
    m := MatrixForPixelCentered(AMatrix);
  result := m * TAffineBox.AffineBox(FOrigin - (FXAxis - FOrigin) - (FYAxis - FOrigin),
      FXAxis - (FYAxis - FOrigin), FYAxis - (FXAxis - FOrigin));
end;

function TCustomRectShape.GetOrthoRect(AMatrix: TAffineMatrix; out ARect: TRectF): boolean;
var
  sx,sy: single;
  o,ox,oy: TPointF;
  m: TAffineMatrix;
begin
  m := MatrixForPixelCentered(AMatrix);
  o := m*FOrigin;
  ox := m*FXAxis;
  oy := m*FYAxis;
  if (abs(ox.y-o.y)<1e-4) and (abs(oy.x-o.x)<1e-4) then
  begin
    sx := abs(ox.x-o.x);
    sy := abs(oy.y-o.y);
    ARect := RectF(o.x - sx, o.y - sy, o.x + sx, o.y + sy);
    exit(true);
  end else
  begin
    ARect := EmptyRectF;
    exit(false);
  end;
end;

procedure TCustomRectShape.QuickDefine(const APoint1, APoint2: TPointF);
begin
  BeginUpdate;
  FOrigin := (APoint1+APoint2)*0.5;
  FXAxis := PointF(APoint2.X,FOrigin.Y);
  FYAxis := PointF(FOrigin.X,APoint2.Y);
  EndUpdate;
end;

procedure TCustomRectShape.LoadFromStorage(AStorage: TBGRACustomOriginalStorage);
begin
  BeginUpdate;
  inherited LoadFromStorage(AStorage);
  FOrigin := AStorage.PointF['origin'];
  FXAxis := AStorage.PointF['x-axis'];
  FYAxis := AStorage.PointF['y-axis'];
  EndUpdate;
end;

procedure TCustomRectShape.SaveToStorage(AStorage: TBGRACustomOriginalStorage);
begin
  inherited SaveToStorage(AStorage);
  AStorage.PointF['origin'] := FOrigin;
  AStorage.PointF['x-axis'] := FXAxis;
  AStorage.PointF['y-axis'] := FYAxis;
end;

function TCustomRectShape.GetRenderBounds(ADestRect: TRect; AMatrix: TAffineMatrix; AOptions: TRenderBoundsOptions): TRectF;
begin
  result := GetAffineBox(AMatrix, false).RectBoundsF;
end;

procedure TCustomRectShape.ConfigureEditor(AEditor: TBGRAOriginalEditor);
var
  d: Single;
  u, v: TPointF;
begin
  u := FXAxis - FOrigin;
  v := FYAxis - FOrigin;
  AEditor.AddStartMoveHandler(@OnStartMove);
  AEditor.AddArrow(FOrigin, FXAxis, @OnMoveXAxis);
  AEditor.AddArrow(FOrigin, FYAxis, @OnMoveYAxis);
  AEditor.AddArrow(FOrigin, FOrigin - u, @OnMoveXAxisNeg);
  AEditor.AddArrow(FOrigin, FOrigin - v, @OnMoveYAxisNeg);
  d := GetCornerPositition;
  if d <> 0 then
  begin
    AEditor.AddPoint(FOrigin + (u+v)*d, @OnMoveXYCorner, false);
    AEditor.AddPoint(FOrigin + (-u+v)*d, @OnMoveXNegYCorner, false);
    AEditor.AddPoint(FOrigin + (u-v)*d, @OnMoveXYNegCorner, false);
    AEditor.AddPoint(FOrigin + (-u-v)*d, @OnMoveXNegYNegCorner, false);
  end;
  AEditor.AddPoint(FOrigin, @OnMoveOrigin, true);
end;

{ TRectShape }

function TRectShape.PenVisible(AAssumePenFill: boolean): boolean;
begin
  result := (PenWidth>0) and not IsClearPenStyle(PenStyle) and ((PenColor.alpha>0) or AAssumePenFill);
end;

function TRectShape.BackVisible: boolean;
begin
  result := BackFill.IsGradient or BackFill.IsTexture or
            (BackFill.IsSolid and (BackFill.SolidColor.alpha <> 0));
end;

function TRectShape.GetCornerPositition: single;
begin
  result := 1;
end;

function TRectShape.GetIsSlow(AMatrix: TAffineMatrix): boolean;
var
  ab: TAffineBox;
  backSurface, totalSurface, penSurface: Single;
begin
  if not PenVisible and not BackVisible then
    result := false
  else
  begin
    ab := GetAffineBox(AMatrix, true);
    backSurface := ab.Surface;
    if PenVisible then
    begin
      penSurface := (ab.Width+ab.Height)*2*PenWidth;
      if BackVisible then
        totalSurface:= backSurface+penSurface/2
      else
        totalSurface := penSurface;
    end else
      totalSurface := backSurface;
    result := (totalSurface > 800*600) or ((totalSurface > 320*240) and BackFill.IsSlow(AMatrix));
  end;
end;

class function TRectShape.Fields: TVectorShapeFields;
begin
  Result:= [vsfPenColor, vsfPenWidth, vsfPenStyle, vsfJoinStyle, vsfBackFill];
end;

procedure TRectShape.Render(ADest: TBGRABitmap; AMatrix: TAffineMatrix;
  ADraft: boolean);
var
  pts: Array of TPointF;
  orthoRect: TRectF;
  r: TRect;
  backScan: TBGRACustomScanner;
begin
  pts := GetAffineBox(AMatrix, true).AsPolygon;
  If BackVisible then
  begin
    if BackFill.IsSolid then backScan := nil
    else backScan := BackFill.CreateScanner(AMatrix, ADraft);

    if GetOrthoRect(AMatrix, orthoRect) then
    begin
      if ADraft then
      begin
        r:= rect(round(orthoRect.Left),round(orthoRect.Top),round(orthoRect.Right),round(orthoRect.Bottom));
        if Assigned(backScan) then
          ADest.FillRect(r, backScan, dmDrawWithTransparency) else
          ADest.FillRect(r, BackFill.SolidColor, dmDrawWithTransparency)
      end
      else
      begin
        if Assigned(backScan) then
          ADest.FillRectAntialias(orthoRect, backScan) else
          ADest.FillRectAntialias(orthoRect, BackFill.SolidColor);
      end;
    end else
    begin
      if ADraft then
      begin
        if Assigned(backScan) then
          ADest.FillPoly(pts, backScan, dmDrawWithTransparency) else
          ADest.FillPoly(pts, BackFill.SolidColor, dmDrawWithTransparency)
      end
      else
      begin
        if Assigned(backScan) then
          ADest.FillPolyAntialias(pts, backScan) else
          ADest.FillPolyAntialias(pts, BackFill.SolidColor);
      end;
    end;

    backScan.Free;
  end;
  if PenVisible then
  begin
    pts := ComputeStroke(pts,true, AMatrix);
    if ADraft and (PenWidth > 4) then
      ADest.FillPoly(pts, PenColor, dmDrawWithTransparency)
    else
      ADest.FillPolyAntialias(pts, PenColor);
  end;
end;

function TRectShape.GetRenderBounds(ADestRect: TRect; AMatrix: TAffineMatrix; AOptions: TRenderBoundsOptions): TRectF;
var
  i: Integer;
  pts: ArrayOfTPointF;
  xMargin, yMargin: single;
begin
  if not (BackVisible or (rboAssumeBackFill in AOptions)) and not PenVisible(rboAssumePenFill in AOptions) then
    result:= EmptyRectF
  else
  begin
    result := inherited GetRenderBounds(ADestRect, AMatrix, AOptions);
    if PenVisible(rboAssumePenFill in AOptions) then
    begin
      if (JoinStyle <> pjsMiter) or (Stroker.MiterLimit <= 1) then
      begin
        xMargin := (abs(AMatrix[1,1])+abs(AMatrix[1,2]))*PenWidth*0.5;
        yMargin := (abs(AMatrix[2,1])+abs(AMatrix[2,2]))*PenWidth*0.5;
        result.Left -= xMargin;
        result.Top -= yMargin;
        result.Right += xMargin;
        result.Bottom += yMargin;
      end else
      begin
        pts := ComputeStroke(GetAffineBox(AMatrix, false).AsPolygon, true, AMatrix);
        for i := 0 to high(pts) do
        begin
          if pts[i].x < result.Left then result.Left := pts[i].x;
          if pts[i].x > result.Right then result.Right := pts[i].x;
          if pts[i].y < result.Top then result.Top := pts[i].y;
          if pts[i].y > result.Bottom then result.Bottom := pts[i].y;
        end;
      end;
    end;
  end;
end;

function TRectShape.PointInShape(APoint: TPointF): boolean;
var
  pts: ArrayOfTPointF;
  box: TAffineBox;
begin
  box := GetAffineBox(AffineMatrixIdentity, true);
  if BackVisible and box.Contains(APoint) then
    result := true else
  if PenVisible then
  begin
    pts := ComputeStroke(box.AsPolygon, true, AffineMatrixIdentity);
    result:= IsPointInPolygon(pts, APoint, true);
  end else
    result := false;
end;

class function TRectShape.StorageClassName: RawByteString;
begin
  result := 'rect';
end;

{ TEllipseShape }

function TEllipseShape.PenVisible(AAssumePenFill: boolean): boolean;
begin
  result := (PenWidth>0) and not IsClearPenStyle(PenStyle) and ((PenColor.alpha>0) or AAssumePenFill);
end;

function TEllipseShape.BackVisible: boolean;
begin
  result := BackFill.IsGradient or BackFill.IsTexture or
            (BackFill.IsSolid and (BackFill.SolidColor.alpha <> 0));
end;

function TEllipseShape.GetCornerPositition: single;
begin
  result := sqrt(2)/2;
end;

constructor TEllipseShape.Create(AContainer: TVectorOriginal);
begin
  inherited Create(AContainer);
  inherited SetJoinStyle(pjsRound);
end;

class function TEllipseShape.Fields: TVectorShapeFields;
begin
  Result:= [vsfPenColor, vsfPenWidth, vsfPenStyle, vsfBackFill];
end;

procedure TEllipseShape.Render(ADest: TBGRABitmap; AMatrix: TAffineMatrix;
  ADraft: boolean);
var
  pts: Array of TPointF;
  orthoRect: TRectF;
  center, radius: TPointF;
  draftPen, isOrtho: Boolean;
  r: TRect;
  backScan: TBGRACustomScanner;
  penZoom: Single;
  m: TAffineMatrix;
begin
  isOrtho := GetOrthoRect(AMatrix, orthoRect);
  if isOrtho then
  begin
    center := (orthoRect.TopLeft+orthoRect.BottomRight)*0.5;
    radius := (orthoRect.BottomRight-orthoRect.TopLeft)*0.5;
    If BackVisible then
    begin
      if BackFill.IsSolid then backScan := nil
      else backScan := BackFill.CreateScanner(AMatrix, ADraft);

      if ADraft then
      begin
        r := rect(round(orthoRect.Left),round(orthoRect.Top),round(orthoRect.Right),round(orthoRect.Bottom));
        if Assigned(backScan) then
          ADest.FillEllipseInRect(r, backScan, dmDrawWithTransparency) else
          ADest.FillEllipseInRect(r, BackFill.SolidColor, dmDrawWithTransparency)
      end
      else
      begin
        if Assigned(backScan) then
          ADest.FillEllipseAntialias(center.x, center.y, radius.x, radius.y, backScan) else
          ADest.FillEllipseAntialias(center.x, center.y, radius.x, radius.y, BackFill.SolidColor);
       end;

      backScan.Free;
    end;
    if PenVisible then
    begin
      if IsAffineMatrixScaledRotation(AMatrix) then
      begin
        penZoom := VectLen(AMatrix[1,1],AMatrix[2,1]);
        ADest.CustomPenStyle := PenStyle;
        draftPen := ADraft and (PenWidth > 4);
        if draftPen then
          ADest.Ellipse(center.x, center.y, radius.x, radius.y, PenColor, PenWidth*penZoom, dmDrawWithTransparency)
        else
          ADest.EllipseAntialias(center.x, center.y, radius.x, radius.y, PenColor, PenWidth*penZoom);
        ADest.PenStyle := psSolid;
      end else
      begin
        m:= MatrixForPixelCentered(AMatrix);
        pts := ComputeEllipse(m*FOrigin, m*FXAxis, m*FYAxis);
        pts := ComputeStroke(pts,true, AMatrix);
        if ADraft and (PenWidth > 4) then
          ADest.FillPoly(pts, PenColor, dmDrawWithTransparency)
        else
          ADest.FillPolyAntialias(pts, PenColor);
      end;
    end;
  end else
  begin
    m:= MatrixForPixelCentered(AMatrix);
    pts := ComputeEllipse(m*FOrigin, m*FXAxis, m*FYAxis);
    If BackVisible then
    begin
      if BackFill.IsSolid then backScan := nil
      else backScan := BackFill.CreateScanner(AMatrix, ADraft);

      if ADraft then
      begin
        if Assigned(backScan) then
          ADest.FillPoly(pts, backScan, dmDrawWithTransparency) else
          ADest.FillPoly(pts, BackFill.SolidColor, dmDrawWithTransparency)
      end
      else
      begin
        if Assigned(backScan) then
          ADest.FillPolyAntialias(pts, backScan) else
          ADest.FillPolyAntialias(pts, BackFill.SolidColor)
      end;

      backScan.Free;
    end;
    if PenVisible then
    begin
      pts := ComputeStroke(pts,true, AMatrix);
      if ADraft and (PenWidth > 4) then
        ADest.FillPoly(pts, PenColor, dmDrawWithTransparency)
      else
        ADest.FillPolyAntialias(pts, PenColor);
    end;
  end;
end;

function TEllipseShape.GetRenderBounds({%H-}ADestRect: TRect; AMatrix: TAffineMatrix; AOptions: TRenderBoundsOptions): TRectF;
var
  xMargin, yMargin: single;
begin
  if not (BackVisible or (rboAssumeBackFill in AOptions)) and not PenVisible(rboAssumePenFill in AOptions) then
    result:= EmptyRectF
  else
  begin
    result := inherited GetRenderBounds(ADestRect, AMatrix, AOptions);
    if PenVisible(rboAssumePenFill in AOptions) then
    begin
      xMargin := (abs(AMatrix[1,1])+abs(AMatrix[1,2]))*PenWidth*0.5;
      yMargin := (abs(AMatrix[2,1])+abs(AMatrix[2,2]))*PenWidth*0.5;
      result.Left -= xMargin;
      result.Top -= yMargin;
      result.Right += xMargin;
      result.Bottom += yMargin;
    end;
  end;
end;

function TEllipseShape.PointInShape(APoint: TPointF): boolean;
var
  pts: ArrayOfTPointF;
begin
  pts := ComputeEllipse(FOrigin, FXAxis, FYAxis);
  if BackVisible and IsPointInPolygon(pts, APoint, true) then
    result := true else
  if PenVisible then
  begin
    pts := ComputeStroke(pts, true, AffineMatrixIdentity);
    result:= IsPointInPolygon(pts, APoint, true);
  end else
    result := false;
end;

function TEllipseShape.GetIsSlow(AMatrix: TAffineMatrix): boolean;
var
  ab: TAffineBox;
  backSurface, totalSurface, penSurface: Single;
begin
  if not PenVisible and not BackVisible then
    result := false
  else
  begin
    ab := GetAffineBox(AMatrix, true);
    backSurface := ab.Surface*Pi/4;
    if PenVisible then
    begin
      penSurface := (ab.Width+ab.Height)*(Pi/2)*PenWidth;
      if BackVisible then
        totalSurface:= backSurface+penSurface/2
      else
        totalSurface := penSurface;
    end else
      totalSurface := backSurface;
    result := (totalSurface > 640*480) or ((totalSurface > 320*240) and BackFill.IsSlow(AMatrix));
  end;
end;

class function TEllipseShape.StorageClassName: RawByteString;
begin
  result := 'ellipse';
end;

{ TCustomPolypointShape }

function TCustomPolypointShape.GetClosed: boolean;
begin
  result := FClosed;
end;

function TCustomPolypointShape.GetPoint(AIndex: integer): TPointF;
begin
  if (AIndex < 0) or (AIndex >= length(FPoints)) then
    raise ERangeError.Create('Index out of bounds');
  result := FPoints[AIndex].coord;
end;

function TCustomPolypointShape.GetPointCount: integer;
begin
  result:= length(FPoints);
end;

procedure TCustomPolypointShape.SetClosed(AValue: boolean);
begin
  if AValue = FClosed then exit;
  BeginUpdate;
  FClosed := AValue;
  EndUpdate;
end;

procedure TCustomPolypointShape.SetPoint(AIndex: integer; AValue: TPointF);
begin
  if (AIndex < 0) or (AIndex > length(FPoints)) then
    raise ERangeError.Create('Index out of bounds');
  BeginUpdate;
  if AIndex = length(FPoints) then
  begin
    setlength(FPoints, length(FPoints)+1);
    FPoints[high(FPoints)].coord := AValue;
    FPoints[high(FPoints)].editorIndex := -1;
  end
  else
    FPoints[AIndex].coord := AValue;
  EndUpdate;
end;

procedure TCustomPolypointShape.OnMovePoint(ASender: TObject; APrevCoord,
  ANewCoord: TPointF; AShift: TShiftState);
begin
  if FCurPoint = -1 then exit;
  BeginUpdate;
  Points[FCurPoint] := ANewCoord;
  EndUpdate;
end;

procedure TCustomPolypointShape.OnMoveCenterPoint(ASender: TObject; APrevCoord,
  ANewCoord: TPointF; AShift: TShiftState);
var
  i: Integer;
  delta: TPointF;
begin
  BeginUpdate;
  delta := ANewCoord - APrevCoord;
  for i := 0 to PointCount-1 do
    Points[i] := Points[i]+delta;
  if vsfBackFill in Fields then
    BackFill.Transform(AffineMatrixTranslation(delta.x, delta.y));
  EndUpdate;
end;

procedure TCustomPolypointShape.OnStartMove(ASender: TObject; APointIndex: integer;
  AShift: TShiftState);
var
  i: Integer;
begin
  FCurPoint:= -1;
  for i:= 0 to high(FPoints) do
    if FPoints[i].editorIndex = APointIndex then
    begin
      FCurPoint:= i;
      break;
    end;
end;

function TCustomPolypointShape.GetCurve(AMatrix: TAffineMatrix): ArrayOfTPointF;
var
  i: Integer;
  m: TAffineMatrix;
begin
  setlength(result, PointCount);
  m:= MatrixForPixelCentered(AMatrix);
  for i := 0 to PointCount-1 do
    result[i] := m*Points[i];
end;

class function TCustomPolypointShape.Usermodes: TVectorShapeUsermodes;
begin
  Result:= inherited Usermodes + [vsuCreate];
end;

procedure TCustomPolypointShape.SetUsermode(AValue: TVectorShapeUsermode);
var
  add: Boolean;
begin
  add := AValue = vsuCreate;
  if add and (length(FPoints) = 0) then exit;
  if FAddingPoint and not add then
  begin
    if (length(FPoints)>1) and PointsEqual(FPoints[high(FPoints)].coord,FPoints[high(FPoints)-1].coord) then
    begin
      BeginUpdate;
      setlength(FPoints, length(FPoints)-1);
      EndUpdate;
    end;
    FAddingPoint:= add;
  end else
  if not FAddingPoint and add then
  begin
    if not isEmptyPointF(FMousePos) then
      AddPoint(FMousePos)
    else
      AddPoint(Points[PointCount-1]);
    FAddingPoint:= add;
  end;
  inherited SetUsermode(AValue);
end;

function TCustomPolypointShape.PointsEqual(const APoint1, APoint2: TPointF
  ): boolean;
begin
  if isEmptyPointF(APoint1) then
    exit(isEmptyPointF(APoint2))
  else
  if isEmptyPointF(APoint2) then exit(false)
  else
    exit((APoint1.x = APoint2.x) and (APoint1.y = APoint2.y));
end;

procedure TCustomPolypointShape.OnHoverPoint(ASender: TObject;
  APointIndex: integer);
var
  i: Integer;
begin
  FHoverPoint:= -1;
  if APointIndex <> -1 then
  begin
    for i:= 0 to high(FPoints) do
      if FPoints[i].editorIndex = APointIndex then
      begin
        FHoverPoint:= i;
        break;
      end;
  end;
end;

procedure TCustomPolypointShape.InsertPointAuto;
var
  bestSegmentIndex, i: Integer;
  bestSegmentDist, segmentLen, segmentPos: single;
  u, n: TPointF;
  segmentDist: single;
begin
  if isEmptyPointF(FMousePos) then exit;

  for i := 0 to PointCount-1 do
    if (Points[i] = FMousePos) and not (FAddingPoint and (i = PointCount-1)) then exit;

  bestSegmentIndex := -1;
  bestSegmentDist := MaxSingle;
  for i := 0 to PointCount-1 do
  if FAddingPoint and (i >= PointCount-2) then break else
  begin
    if (i = PointCount-1) and not Closed then break;
    u := Points[(i+1) mod PointCount] - Points[i];
    segmentLen := VectLen(u);
    if segmentLen > 0 then
    begin
      u *= 1/segmentLen;
      segmentPos := (FMousePos-Points[i])*u;
      if (segmentPos > 0) and (segmentPos< segmentLen) then
      begin
        n := PointF(u.y,-u.x);
        segmentDist := abs((FMousePos-Points[i])*n);
        if segmentDist <= bestSegmentDist then
        begin
          bestSegmentDist := segmentDist;
          bestSegmentIndex := i;
        end;
      end;
    end;
  end;
  if bestSegmentIndex <> -1 then
  begin
    InsertPoint(bestSegmentIndex+1, FMousePos);
    FHoverPoint:= bestSegmentIndex+1;
  end;
end;

constructor TCustomPolypointShape.Create(AContainer: TVectorOriginal);
begin
  inherited Create(AContainer);
  FMousePos := EmptyPointF;
  FClosed:= false;
  FHoverPoint:= -1;
end;

procedure TCustomPolypointShape.AddPoint(const APoint: TPointF);
begin
  Points[PointCount] := APoint;
end;

function TCustomPolypointShape.RemovePoint(AIndex: integer): boolean;
var
  i: Integer;
begin
  if (AIndex < 0) or (AIndex >= PointCount) then exit(false);
  BeginUpdate;
  for i := AIndex to PointCount-2 do
    FPoints[i] := FPoints[i+1];
  setlength(FPoints, PointCount-1);
  EndUpdate;
  result := true;
end;

procedure TCustomPolypointShape.InsertPoint(AIndex: integer; APoint: TPointF);
var
  i: Integer;
begin
  if (AIndex < 0) or (AIndex > PointCount) then raise exception.Create('Index out of bounds');
  BeginUpdate;
  setlength(FPoints, PointCount+1);
  for i := PointCount-1 downto AIndex+1 do
    FPoints[i] := FPoints[i-1];
  FPoints[AIndex].coord := APoint;
  FPoints[AIndex].editorIndex:= -1;
  EndUpdate;
end;

procedure TCustomPolypointShape.MouseMove(Shift: TShiftState; X, Y: single; var
  ACursor: TOriginalEditorCursor; var AHandled: boolean);
begin
  FMousePos := PointF(X,Y);
  if FAddingPoint then
  begin
    BeginUpdate;
    FPoints[high(FPoints)].coord := FMousePos;
    EndUpdate;
    AHandled:= true;
  end;
end;

procedure TCustomPolypointShape.MouseDown(RightButton: boolean;
  Shift: TShiftState; X, Y: single; var ACursor: TOriginalEditorCursor; var
  AHandled: boolean);
begin
  if FAddingPoint then
  begin
    if not RightButton then
    begin
      if (length(FPoints)>1) and not PointsEqual(FPoints[high(FPoints)].coord,FPoints[high(FPoints)-1].coord) then
        AddPoint(FPoints[high(FPoints)].coord);
    end else
      Usermode := vsuEdit;
    AHandled:= true;
  end;
end;

procedure TCustomPolypointShape.KeyDown(Shift: TShiftState; Key: TSpecialKey;
  var AHandled: boolean);
begin
  if (Key = skDelete) and (FAddingPoint or ((FHoverPoint >= 0) and (FHoverPoint < PointCount))) then
  begin
    if (FHoverPoint >= 0) and (FHoverPoint < PointCount) then
    begin
      BeginUpdate;
      RemovePoint(FHoverPoint);
      if (FHoverPoint < PointCount) and IsEmptyPointF(FPoints[FHoverPoint].coord) then RemovePoint(FHoverPoint);
      EndUpdate;
      if PointCount = 0 then self.Remove;
    end;
    AHandled:= true;
  end else
  if (Key = skBackspace) and FAddingPoint then
  begin
    If PointCount <= 2 then self.Remove else
    If isEmptyPointF(FPoints[PointCount-3].coord) then
    begin
      BeginUpdate;
      setlength(FPoints, PointCount-3);
      EndUpdate;
      Usermode:= vsuEdit;
    end else
      RemovePoint(PointCount-2);
  end else
  if (Key = skInsert) then InsertPointAuto else
    inherited KeyDown(Shift, Key, AHandled);
end;

procedure TCustomPolypointShape.QuickDefine(const APoint1, APoint2: TPointF);
begin
  BeginUpdate;
  FPoints := nil;
  AddPoint(APoint1);
  if not PointsEqual(APoint1,APoint2) then
    AddPoint(APoint2);
  EndUpdate;
  FMousePos := APoint2;
end;

procedure TCustomPolypointShape.LoadFromStorage(AStorage: TBGRACustomOriginalStorage);
var
  x,y: Array of Single;
  i: Integer;
begin
  BeginUpdate;
  inherited LoadFromStorage(AStorage);
  x := AStorage.FloatArray['x'];
  y := AStorage.FloatArray['y'];
  setlength(FPoints, max(length(x),length(y)));
  for i := 0 to high(FPoints) do
  begin
    FPoints[i].coord := PointF(x[i],y[i]);
    FPoints[i].editorIndex := -1;
  end;
  FClosed:= AStorage.Bool['closed'];
  EndUpdate;
end;

procedure TCustomPolypointShape.SaveToStorage(AStorage: TBGRACustomOriginalStorage);
var
  x,y: Array of Single;
  i: Integer;
begin
  inherited SaveToStorage(AStorage);
  setlength(x, PointCount);
  setlength(y, PointCount);
  for i:= 0 to PointCount-1 do
  begin
    x[i] := Points[i].x;
    y[i] := Points[i].y;
  end;
  AStorage.FloatArray['x'] := x;
  AStorage.FloatArray['y'] := y;
  AStorage.Bool['closed'] := Closed;
end;

procedure TCustomPolypointShape.ConfigureEditor(AEditor: TBGRAOriginalEditor);
var
  i, nb: Integer;
begin
  AEditor.AddStartMoveHandler(@OnStartMove);
  AEditor.AddHoverPointHandler(@OnHoverPoint);
  nb := 0;
  FCenterPoint := PointF(0,0);
  for i:= 0 to PointCount-1 do
    if isEmptyPointF(Points[i]) then
      FPoints[i].editorIndex := -1
    else if (FAddingPoint and ((i = 0) or (i = PointCount-1))) then
    begin
      FPoints[i].editorIndex := -1;
      FCenterPoint += Points[i];
      inc(nb);
    end
    else
    begin
      FPoints[i].editorIndex := AEditor.AddPoint(Points[i], @OnMovePoint, false);
      FCenterPoint += Points[i];
      inc(nb);
    end;

  if (FAddingPoint and (nb > 2)) or (not FAddingPoint and (nb > 1)) then
  begin
    FCenterPoint *= 1/nb;
    FCenterPointEditorIndex := AEditor.AddPoint(FCenterPoint, @OnMoveCenterPoint, true);
  end;
end;

{ TPolylineShape }

function TPolylineShape.PenVisible(AAssumePenFill: boolean): boolean;
begin
  result := (PenWidth>0) and not IsClearPenStyle(PenStyle) and ((PenColor.alpha>0) or AAssumePenFill);
end;

function TPolylineShape.BackVisible: boolean;
begin
  result := BackFill.IsGradient or BackFill.IsTexture or
            (BackFill.IsSolid and (BackFill.SolidColor.alpha <> 0));
end;

class function TPolylineShape.Fields: TVectorShapeFields;
begin
  Result:= [vsfPenColor, vsfPenWidth, vsfPenStyle, vsfJoinStyle, vsfBackFill];
end;

procedure TPolylineShape.Render(ADest: TBGRABitmap; AMatrix: TAffineMatrix;
  ADraft: boolean);
var
  pts: array of TPointF;
  backScan: TBGRACustomScanner;
begin
  if not BackVisible and not PenVisible then exit;
  pts := GetCurve(AMatrix);
  if BackVisible then
  begin
    if BackFill.IsSolid then backScan := nil
    else backScan := BackFill.CreateScanner(AMatrix, ADraft);

    if ADraft then
    begin
      if Assigned(backScan) then
        ADest.FillPoly(pts, backScan, dmDrawWithTransparency) else
        ADest.FillPoly(pts, BackFill.SolidColor, dmDrawWithTransparency);
    end
    else
    begin
      if Assigned(backScan) then
        ADest.FillPolyAntialias(pts, backScan) else
        ADest.FillPolyAntialias(pts, BackFill.SolidColor);
    end;

    backScan.Free;
  end;
  if PenVisible then
  begin
    pts := ComputeStroke(pts, Closed, AMatrix);
    if ADraft and (PenWidth > 4) then
      ADest.FillPoly(pts, PenColor, dmDrawWithTransparency)
    else
      ADest.FillPolyAntialias(pts, PenColor);
  end;
end;

function TPolylineShape.GetRenderBounds(ADestRect: TRect; AMatrix: TAffineMatrix; AOptions: TRenderBoundsOptions): TRectF;
var
  pts: ArrayOfTPointF;
  xMargin, yMargin: single;
  fillBounds, penBounds: TRectF;
begin
  if not (BackVisible or (rboAssumeBackFill in AOptions)) and not PenVisible(rboAssumePenFill in AOptions) then
    result:= EmptyRectF
  else
  begin
    pts := GetCurve(AMatrix);
    if PenVisible(rboAssumePenFill in AOptions) then
    begin
      if JoinStyle = pjsRound then
      begin
        xMargin := (abs(AMatrix[1,1])+abs(AMatrix[1,2]))*PenWidth*0.5;
        yMargin := (abs(AMatrix[2,1])+abs(AMatrix[2,2]))*PenWidth*0.5;
        result := GetPointsBoundsF(pts);
        result.Left -= xMargin;
        result.Top -= yMargin;
        result.Right += xMargin;
        result.Bottom += yMargin;
      end else
      begin
        if BackVisible or (rboAssumeBackFill in AOptions) then fillBounds := GetPointsBoundsF(pts)
        else fillBounds := EmptyRectF;
        pts := ComputeStroke(pts, Closed, AMatrix);
        penBounds := GetPointsBoundsF(pts);
        result := fillBounds.Union(penBounds, true);
      end;
    end
    else
      result := GetPointsBoundsF(pts);
  end;
  result.Offset(0.5,0.5);
end;

function TPolylineShape.PointInShape(APoint: TPointF): boolean;
var
  pts: ArrayOfTPointF;
begin
  if not BackVisible and not PenVisible then exit;
  pts := GetCurve(AffineMatrixIdentity);
  if BackVisible and IsPointInPolygon(pts, APoint, true) then exit(true);
  if PenVisible then
  begin
    pts := ComputeStroke(pts, Closed, AffineMatrixIdentity);
    if IsPointInPolygon(pts, APoint, true) then exit(true);
  end;
  result := false;
end;

function TPolylineShape.GetIsSlow(AMatrix: TAffineMatrix): boolean;
begin
  Result:= PointCount > 40;
end;

class function TPolylineShape.StorageClassName: RawByteString;
begin
  result := 'polyline';
end;

{ TCurveShape }

procedure TCurveShape.SetSplineStyle(AValue: TSplineStyle);
begin
  if FSplineStyle=AValue then Exit;
  BeginUpdate;
  FSplineStyle:=AValue;
  EndUpdate;
end;

function TCurveShape.GetCurve(AMatrix: TAffineMatrix): ArrayOfTPointF;
var
  pts: array of TPointF;
begin
  pts := inherited GetCurve(AMatrix);
  if Closed then result := ComputeClosedSpline(pts, FSplineStyle)
  else result := ComputeOpenedSpline(pts, FSplineStyle);
end;

constructor TCurveShape.Create(AContainer: TVectorOriginal);
begin
  inherited Create(AContainer);
  FSplineStyle:= ssEasyBezier;
end;

procedure TCurveShape.LoadFromStorage(AStorage: TBGRACustomOriginalStorage);
begin
  BeginUpdate;
  inherited LoadFromStorage(AStorage);
  case AStorage.RawString['spline-style'] of
  'inside': SplineStyle := ssInside;
  'inside+ends': SplineStyle := ssInsideWithEnds;
  'crossing': SplineStyle := ssCrossing;
  'crossing+ends': SplineStyle := ssCrossingWithEnds;
  'outside': SplineStyle := ssOutside;
  'round-outside': SplineStyle := ssRoundOutside;
  'vertex-to-side': SplineStyle := ssVertexToSide;
  else
    {'easy-bezier'} SplineStyle := ssEasyBezier;
  end;
  EndUpdate;
end;

procedure TCurveShape.SaveToStorage(AStorage: TBGRACustomOriginalStorage);
var s: string;
begin
  inherited SaveToStorage(AStorage);
  case SplineStyle of
    ssInside: s := 'inside';
    ssInsideWithEnds: s := 'inside+ends';
    ssCrossing: s := 'crossing';
    ssCrossingWithEnds: s := 'crossing+ends';
    ssOutside: s := 'outside';
    ssRoundOutside: s := 'round-outside';
    ssVertexToSide: s := 'vertex-to-side';
    ssEasyBezier: s := 'easy-bezier';
  else s := '';
  end;
  AStorage.RawString['spline-style'] := s;
end;

class function TCurveShape.StorageClassName: RawByteString;
begin
  Result:= 'curve';
end;

initialization

  RegisterVectorShape(TRectShape);
  RegisterVectorShape(TEllipseShape);
  RegisterVectorShape(TPolylineShape);
  RegisterVectorShape(TCurveShape);

end.

