unit LazpaintMainForm;

{$mode objfpc}{$H+}

interface

{$IFDEF DARWIN}
  {$DEFINE USEPAINTBOXPICTURE}
{$ENDIF}

uses
  Classes, LMessages, SysUtils, LazFileUtils, LResources, Forms,
  Controls, Graphics, Dialogs, Menus, ExtDlgs, ComCtrls, ActnList, StdCtrls,
  ExtCtrls, Buttons, types, LCLType, BGRAImageList, BGRAVirtualScreen,

  BGRABitmap, BGRABitmapTypes, BGRALayers, BGRASVGOriginal,

  LazPaintType, UMainFormLayout, UTool, UImage, UImageAction, UZoom, UImageView,
  UImageObservation, UConfig, LCScaleDPI, UResourceStrings,
  UMenu, uscripting, ubrowseimages, UToolPolygon, UBarUpDown,

  laztablet, udarktheme;

const
  MinPenWidthValue = 10;

type
  { TFMain }

  TFMain = class(TForm)
    FileRememberSaveFormat: TAction;
    SelectionVerticalFlip: TAction;
    SelectionHorizontalFlip: TAction;
    LayerZoom: TAction;
    ImageSwapRedBlue: TAction;
    ImageLinearNegative: TAction;
    ImageNegative: TAction;
    ForgetDialogAnswers: TAction;
    FileChooseEntry: TAction;
    Panel_Aliasing: TPanel;
    ToolBar22: TToolBar;
    ToolButton8: TToolButton;
    ToolHotSpot: TAction;
    Combo_Ratio: TComboBox;
    FileUseImageBrowser: TAction;
    Combo_GradientColorspace: TComboBox;
    ItemUseImageBrowser: TMenuItem;
    Label_Ratio: TLabel;
    Panel_Ratio: TPanel;
    Tool_Aliasing: TToolButton;
    ViewPalette: TAction;
    ViewStatusBar: TAction;
    ImageList24: TBGRAImageList;
    ImageList64: TBGRAImageList;
    ImageList32: TBGRAImageList;
    ImageList48: TBGRAImageList;
    ItemViewPalette: TMenuItem;
    MenuIconSize: TMenuItem;
    ItemIconSize16: TMenuItem;
    ItemIconSize32: TMenuItem;
    ItemIconSize48: TMenuItem;
    ItemIconSizeAuto: TMenuItem;
    ItemIconSize64: TMenuItem;
    ItemIconSize24: TMenuItem;
    ItemViewStatusBar: TMenuItem;
    MenuShowPalette: TMenuItem;
    ToolClone: TAction;
    FilterRain: TAction;
    BrushRemoveCurrent: TAction;
    BrushLoadFromFile: TAction;
    BrushCreateGeometric: TAction;
    ComboBox_BrushSelect: TComboBox;
    Label_Brush: TLabel;
    Label_Spacing: TLabel;
    MenuDockToolboxLeft: TMenuItem;
    MenuDockToolboxRight: TMenuItem;
    MenuUndockToolbox: TMenuItem;
    MenuZoomToolbar: TMenuItem;
    MenuCopyPasteToolbar: TMenuItem;
    MenuCoordinatesToolbar: TMenuItem;
    MenuUndoRedoToolbar: TMenuItem;
    OpenBrushDialog: TOpenDialog;
    Panel_Brush: TPanel;
    PopupToolbox: TPopupMenu;
    PopupToolbar: TPopupMenu;
    ToolBar21: TToolBar;
    ToolBrush: TAction;
    ToolButton21: TToolButton;
    ToolButton22: TToolButton;
    ToolButton4: TToolButton;
    ToolButton7: TToolButton;
    ToolChangeDocking: TAction;
    FilterBlurBox: TAction;
    ComboBox_ArrowStart: TComboBox;
    ComboBox_ArrowEnd: TComboBox;
    EditPasteAsNewLayer: TAction;
    MenuItem1: TMenuItem;
    ItemDockLayersAndColors: TMenuItem;
    ItemFullscreen: TMenuItem;
    ItemViewDockToolbox: TMenuItem;
    SaveSelectionDialog: TSaveDialog;
    SavePictureDialog1: TSaveDialog;
    TimerDocking: TTimer;
    vsGridNbX: TBGRAVirtualScreen;
    vsGridNbY: TBGRAVirtualScreen;
    vsPhongBorderSize: TBGRAVirtualScreen;
    vsShapeAltitude: TBGRAVirtualScreen;
    vsBrushSpacing: TBGRAVirtualScreen;
    vsTextShadowX: TBGRAVirtualScreen;
    vsTextOutlineWidth: TBGRAVirtualScreen;
    vsArrowSizeY: TBGRAVirtualScreen;
    vsTextShadowY: TBGRAVirtualScreen;
    vsArrowSizeX: TBGRAVirtualScreen;
    vsTextSize: TBGRAVirtualScreen;
    vsTextBlur: TBGRAVirtualScreen;
    vsTolerance: TBGRAVirtualScreen;
    vsTextureOpacity: TBGRAVirtualScreen;
    vsPenOpacity: TBGRAVirtualScreen;
    FileSaveAsInSameFolder: TAction;
    FilePrint: TAction;
    FilterNoise: TAction;
    ColorPosterize: TAction;
    ColorCurves: TAction;
    FilterComplementaryColor: TAction;
    FilterFunction: TAction;
    FilterPhong: TAction;
    FileReload: TAction;
    MainMenu1: TMainMenu;
    MenuFile: TMenuItem;
    ItemViewImageList: TMenuItem;
    ViewImageList: TAction;
    MenuRecentFiles: TMenuItem;
    ItemDonate: TMenuItem;
    MenuLanguage: TMenuItem;
    ItemQuitSeparator: TMenuItem;
    ItemQuit: TMenuItem;
    MenuEdit: TMenuItem;
    MenuSelect: TMenuItem;
    MenuView: TMenuItem;
    ItemViewToolbox: TMenuItem;
    ItemViewColors: TMenuItem;
    ItemViewGrid: TMenuItem;
    ItemViewLayerStack: TMenuItem;
    MenuImage: TMenuItem;
    MenuRemoveTransparency: TMenuItem;
    MenuColors: TMenuItem;
    MenuTool: TMenuItem;
    MenuFilter: TMenuItem;
    MenuRadialBlur: TMenuItem;
    MenuRender: TMenuItem;
    MenuHelp: TMenuItem;
    Open3DObjectDialog: TOpenDialog;
    Panel_PerspectiveOption: TPanel;
    Perspective_Repeat: TToolButton;
    Perspective_TwoPlanes: TToolButton;
    ToolBar18: TToolBar;
    ToolBar19: TToolBar;
    ToolBar20: TToolBar;
    Tool_CurveMovePoint: TToolButton;
    Tool_CurveModeAuto: TToolButton;
    ToolLayerMapping: TAction;
    ImageFlatten: TAction;
    LayerRotate: TAction;
    LayerMove: TAction;
    LayerFromFile: TAction;
    LayerMergeOver: TAction;
    LayerDuplicate: TAction;
    LayerRemoveCurrent: TAction;
    LayerAddNew: TAction;
    LayerVerticalFlip: TAction;
    LayerHorizontalFlip: TAction;
    ImageCropLayer: TAction;
    Tool_CurveModeAngle: TToolButton;
    Tool_EraseAlpha: TToolButton;
    Tool_EraseBlur: TToolButton;
    Tool_CurveModeCurve: TToolButton;
    ViewLayerStackButton: TAction;
    ViewLayerStack: TAction;
    FileImport3D: TAction;
    ToolTextureMapping: TAction;
    EditSelection: TAction;
    FilterClearTypeInverse: TAction;
    FilterClearType: TAction;
    ToolPhong: TAction;
    FileLoadSelection: TAction;
    FileSaveSelectionAs: TAction;
    ToolText: TAction;
    FilterPixelate: TAction;
    EditPasteAsNew: TAction;
    ViewGrid: TAction;
    EmbeddedCancel: TAction;
    EmbeddedValidate: TAction;
    RenderWoodVertical: TAction;
    FilterTwirl: TAction;
    ToolDeformation: TAction;
    RenderWater: TAction;
    RenderMarble: TAction;
    RenderRoundStone: TAction;
    RenderStone: TAction;
    RenderSnowPrint: TAction;
    RenderCamouflage: TAction;
    RenderMetalFloor: TAction;
    RenderCyclicPerlinNoise: TAction;
    RenderWood: TAction;
    RenderPlastik: TAction;
    ToolNoTexture: TAction;
    ToolLoadTexture: TAction;
    RenderPerlinNoise: TAction;
    FilterBlurFast: TAction;
    FilterPlane: TAction;
    ToolMagicWand: TAction;
    ImageRepeat: TAction;
    RenderCustomWater: TAction;
    HelpAbout: TAction;
    HelpIndex: TAction;
    ColorColorize: TAction;
    ColorShiftColors: TAction;
    FilterLinearNegative: TAction;
    ColorLightness: TAction;
    ColorIntensity: TAction;
    RenderClouds: TAction;
    ImageRotateCCW: TAction;
    ImageRotateCW: TAction;
    ImageChangeCanvasSize: TAction;
    ImageFillBackground: TAction;
    ImageClearAlpha: TAction;
    EditSelectionFit: TAction;
    ImageCrop: TAction;
    FilterCylinder: TAction;
    FilterSphere: TAction;
    ViewColors: TAction;
    ViewToolbox: TAction;
    EditSelectAll: TAction;
    FilterContour: TAction;
    FilterBlurCustom: TAction;
    FilterGrayscale: TAction;
    ToolRotateSelection: TAction;
    EditDeleteSelection: TAction;
    EditCut: TAction;
    EditPaste: TAction;
    EditCopy: TAction;
    ToolMoveSelection: TAction;
    ToolSelectPen: TAction;
    EditInvertSelection: TAction;
    EditDeselect: TAction;
    ToolSelectSpline: TAction;
    ToolSelectPoly: TAction;
    ToolSelectEllipse: TAction;
    ToolSelectRect: TAction;
    FilterNegative: TAction;
    FilterNormalize: TAction;
    FilterEmboss: TAction;
    FilterBlurMotion: TAction;
    FilterBlurPrecise: TAction;
    FilterBlurDisk: TAction;
    FilterBlurCorona: TAction;
    FilterBlurRadial: TAction;
    ViewZoomFit: TAction;
    ViewZoomOriginal: TAction;
    FilterSharpen: TAction;
    FilterSmooth: TAction;
    ImageSmartZoom3: TAction;
    FilterMedian: TAction;
    ImageResample: TAction;
    EditRedo: TAction;
    EditUndo: TAction;
    ImageHorizontalFlip: TAction;
    ImageVerticalFlip: TAction;
    ToolGradient: TAction;
    ToolFloodfill: TAction;
    ToolSpline: TAction;
    ToolEraser: TAction;
    ToolPolygon: TAction;
    ToolColorPicker: TAction;
    ToolEllipse: TAction;
    ToolRect: TAction;
    ToolPen: TAction;
    ToolHand: TAction;
    ViewZoomOut: TAction;
    ViewZoomIn: TAction;
    FileQuit: TAction;
    FileSaveAs: TAction;
    FileSave: TAction;
    FileOpen: TAction;
    FileNew: TAction;
    Edit_Zoom: TEdit;
    OpenTextureDialog: TOpenDialog;
    OpenPictureDialog1: TOpenDialog;
    Panel_TextOutline: TPanel;
    TimerUpdate: TTimer;
    Label_OutlineWidth: TLabel;
    ToolBar17: TToolBar;
    Tool_TextAlignLeft: TToolButton;
    Tool_TextAlignCenter: TToolButton;
    Tool_TextAlignRight: TToolButton;
    Tool_TextOutline: TToolButton;
    ToolButton_ViewLayerStack: TToolButton;
    Label_Altitude: TLabel;
    Label_PhongBorder: TLabel;
    Label_CurrentDiff: TLabel;
    Label_Shape: TLabel;
    Panel_PhongShape: TPanel;
    Panel_Altitude: TPanel;
    ToolBar16: TToolBar;
    Tool_PhongShapeVerticalCone: TToolButton;
    Tool_PhongShapeHorizontalCylinder: TToolButton;
    Tool_PhongShapeVerticalCylinder: TToolButton;
    Tool_TextPhong: TToolButton;
    Tool_PhongShapeSphere: TToolButton;
    Tool_PhongShapeRectangle: TToolButton;
    Tool_PhongShapeCone: TToolButton;
    Tool_PhongShapeRoundRect: TToolButton;
    FontDialog1: TFontDialog;
    LoadSelectionDialog: TOpenPictureDialog;
    Label_TextBlur: TLabel;
    Label_ShadowOffset: TLabel;
    Label_Text: TLabel;
    Panel_Text: TPanel;
    ToolBar15: TToolBar;
    Tool_TextFont: TToolButton;
    Tool_TextShadow: TToolButton;
    Combo_SplineStyle: TComboBox;
    PaintBox_Picture: TPaintBox;
    PaintBox_PenPreview: TPaintBox;
    Panel_Embedded: TPanel;
    Panel_PenWidthPreview: TPanel;
    Panel_SplineStyle: TPanel;
    Label_Curve: TLabel;
    Panel_Grid: TPanel;
    Label_Grid: TLabel;
    Label_GridX: TLabel;
    TimerHidePenPreview: TTimer;
    ToolBar13: TToolBar;
    Tool_CloseShape: TToolButton;
    ToolBar14: TToolBar;
    ToolButton19: TToolButton;
    ToolButton20: TToolButton;
    ToolButton3: TToolButton;
    Tool_GridMoveWithoutDeformation: TToolButton;
    Image_CurrentTexture: TImage;
    Panel_Texture: TPanel;
    Panel_PenStyle: TPanel;
    Panel_LineCap: TPanel;
    Panel_JoinStyle: TPanel;
    ToolBar11: TToolBar;
    ToolBar12: TToolBar;
    ToolBar4: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    Tool_PenDashDotDot: TToolButton;
    Tool_PenDot: TToolButton;
    Tool_JoinBevel: TToolButton;
    Tool_PenSolid: TToolButton;
    Tool_PenDashDot: TToolButton;
    Tool_JoinRound: TToolButton;
    Tool_CapSquare: TToolButton;
    Tool_CapFlat: TToolButton;
    Tool_CapRound: TToolButton;
    ToolBar10: TToolBar;
    Tool_SinGradient: TToolButton;
    Tool_JoinMiter: TToolButton;
    Tool_PenDash: TToolButton;
    Label_Coordinates: TLabel;
    Panel_Coordinates: TPanel;
    Image_SwapColors: TImage;
    Label_Eraser: TLabel;
    Image_CurrentTool: TImage;
    Label_Pen: TLabel;
    Label_Back: TLabel;
    Label_CurrentZoom: TLabel;
    Panel_Undo: TPanel;
    Panel_CopyPaste: TPanel;
    Panel_ToolbarBackground: TPanel;
    Panel_File: TPanel;
    Panel_GradientType: TPanel;
    Panel_Tool: TPanel;
    Panel_Zoom: TPanel;
    Panel_Color: TPanel;
    Panel_PenWidth: TPanel;
    Panel_Eraser: TPanel;
    Panel_Tolerance: TPanel;
    Panel_ShapeOption: TPanel;
    Label_PenWidth: TLabel;
    Tool_DrawShapeBorder: TToolButton;
    Tool_FillShape: TToolButton;
    Shape_BackColor: TShape;
    Shape_PenColor: TShape;
    Label_Tolerance: TLabel;
    ToolBar2: TToolBar;
    ToolBar3: TToolBar;
    ToolBar5: TToolBar;
    ToolBar6: TToolBar;
    ToolBar7: TToolBar;
    ToolBar8: TToolBar;
    ToolBar9: TToolBar;
    ToolButton14: TToolButton;
    ToolButton15: TToolButton;
    ToolButton16: TToolButton;
    ToolButton17: TToolButton;
    ToolButton18: TToolButton;
    ToolButton23: TToolButton;
    ToolButton24: TToolButton;
    ToolButton29: TToolButton;
    ToolButton30: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    Tool_DiamondGradient: TToolButton;
    Tool_LinearGradient: TToolButton;
    Tool_ProgressiveFloodfill: TToolButton;
    Tool_RadialGradient: TToolButton;
    Tool_ReflectedGradient: TToolButton;
    ToolButton_ZoomOriginal: TToolButton;
    ColorDialog1: TColorDialog;
    ActionList1: TActionList;
    ImageList16: TBGRAImageList;
    vsBackOpacity: TBGRAVirtualScreen;
    vsEraserOpacity: TBGRAVirtualScreen;
    vsPenWidth: TBGRAVirtualScreen;
    procedure BrushCreateGeometricExecute(Sender: TObject);
    procedure BrushCreateGeometricUpdate(Sender: TObject);
    procedure BrushLoadFromFileExecute(Sender: TObject);
    procedure BrushLoadFromFileUpdate(Sender: TObject);
    procedure BrushRemoveCurrentExecute(Sender: TObject);
    procedure BrushRemoveCurrentUpdate(Sender: TObject);
    procedure ComboBox_ArrowEndChange(Sender: TObject);
    procedure ComboBox_ArrowEndDrawItem({%H-}Control: TWinControl; Index: Integer;
      ARect: TRect; State: TOwnerDrawState);
    procedure ComboBox_ArrowStartChange(Sender: TObject);
    procedure ComboBox_ArrowStartDrawItem({%H-}Control: TWinControl; Index: Integer;
      ARect: TRect; State: TOwnerDrawState);
    procedure ComboBox_BrushSelectChange(Sender: TObject);
    procedure ComboBox_BrushSelectDrawItem({%H-}Control: TWinControl;
      Index: Integer; ARect: TRect; State: TOwnerDrawState);
    procedure Combo_RatioChange(Sender: TObject);
    procedure EditCopyExecute(Sender: TObject);
    procedure EditCopyUpdate(Sender: TObject);
    procedure EditCutExecute(Sender: TObject);
    procedure EditCutUpdate(Sender: TObject);
    procedure EditDeleteSelectionUpdate(Sender: TObject);
    procedure EditPasteExecute(Sender: TObject);
    procedure EditSelectionUpdate(Sender: TObject);
    procedure FileChooseEntryExecute(Sender: TObject);
    procedure FileChooseEntryUpdate(Sender: TObject);
    procedure FileImport3DUpdate(Sender: TObject);
    procedure FilePrintExecute(Sender: TObject);
    procedure FileRememberSaveFormatExecute(Sender: TObject);
    procedure FileSaveAsInSameFolderExecute(Sender: TObject);
    procedure FileSaveAsInSameFolderUpdate(Sender: TObject);
    procedure FileUseImageBrowserExecute(Sender: TObject);
    procedure FileUseImageBrowserUpdate(Sender: TObject);
    procedure ForgetDialogAnswersExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var {%H-}CloseAction: TCloseAction);
    procedure FormMouseLeave(Sender: TObject);
    procedure FormWindowStateChange(Sender: TObject);
    procedure ItemDockLayersAndColorsClick(Sender: TObject);
    procedure ItemFullscreenClick(Sender: TObject);
    procedure ItemIconSize24Click(Sender: TObject);
    procedure ItemViewDockToolboxClick(Sender: TObject);
    procedure LayerZoomExecute(Sender: TObject);
    procedure MenuCoordinatesToolbarClick(Sender: TObject);
    procedure MenuCopyPasteToolbarClick(Sender: TObject);
    procedure MenuDockToolboxLeftClick(Sender: TObject);
    procedure MenuDockToolboxRightClick(Sender: TObject);
    procedure ItemIconSize16Click(Sender: TObject);
    procedure ItemIconSize32Click(Sender: TObject);
    procedure ItemIconSize48Click(Sender: TObject);
    procedure ItemIconSizeAutoClick(Sender: TObject);
    procedure MenuIconSizeClick(Sender: TObject);
    procedure ItemIconSize64Click(Sender: TObject);
    procedure MenuShowPaletteClick(Sender: TObject);
    procedure MenuUndockToolboxClick(Sender: TObject);
    procedure MenuUndoRedoToolbarClick(Sender: TObject);
    procedure MenuViewClick(Sender: TObject);
    procedure MenuZoomToolbarClick(Sender: TObject);
    procedure PaintBox_PenPreviewMouseDown(Sender: TObject;
      {%H-}Button: TMouseButton; {%H-}Shift: TShiftState; X, Y: Integer);
    procedure PopupToolbarPopup(Sender: TObject);
    procedure PopupToolboxPopup(Sender: TObject);
    procedure SelectionHorizontalFlipUpdate(Sender: TObject);
    procedure SelectionVerticalFlipUpdate(Sender: TObject);
    procedure SpinEdit_PhongBorderSizeChange(Sender: TObject);
    procedure Combo_SplineStyleChange(Sender: TObject);
    procedure EditDeselectUpdate(Sender: TObject);
    procedure EditPasteUpdate(Sender: TObject);
    procedure EditRedoUpdate(Sender: TObject);
    procedure EditSelectionExecute(Sender: TObject);
    procedure EditUndoUpdate(Sender: TObject);
    procedure EmbeddedCancelExecute(Sender: TObject);
    procedure EmbeddedValidateExecute(Sender: TObject);
    procedure FileImport3DExecute(Sender: TObject);
    procedure FileReloadUpdate(Sender: TObject);
    procedure FileSaveSelectionAsUpdate(Sender: TObject);
    procedure FormDropFiles(Sender: TObject; const FileNames: array of String);
    procedure FormKeyUp(Sender: TObject; var Key: Word; {%H-}Shift: TShiftState);
    procedure FormMouseEnter(Sender: TObject);
    procedure FormUTF8KeyPress(Sender: TObject; var UTF8Key: TUTF8Char);
    procedure ImageCropLayerUpdate(Sender: TObject);
    procedure ImageFlattenExecute(Sender: TObject);
    procedure ImageFlattenUpdate(Sender: TObject);
    procedure LayerAddNewUpdate(Sender: TObject);
    procedure LayerDuplicateUpdate(Sender: TObject);
    procedure LayerFromFileExecute(Sender: TObject);
    procedure LayerMergeOverUpdate(Sender: TObject);
    procedure LayerMoveExecute(Sender: TObject);
    procedure LayerMoveUpdate(Sender: TObject);
    procedure LayerRemoveCurrentUpdate(Sender: TObject);
    procedure LayerRotateExecute(Sender: TObject);
    procedure LayerRotateUpdate(Sender: TObject);
    procedure ItemDonateClick(Sender: TObject);
    procedure PaintBox_PictureMouseEnter(Sender: TObject);
    procedure Perspective_RepeatClick(Sender: TObject);
    procedure Perspective_TwoPlanesClick(Sender: TObject);
    procedure SpinEdit_ShapeAltitudeChange(Sender: TObject);
    procedure SpinEdit_BrushSpacingChange(Sender: TObject);
    procedure SpinEdit_TextSizeChange(Sender: TObject);
    procedure SpinEdit_TextureOpacityChange(Sender: TObject);
    procedure SpinEdit_TextBlurChange(Sender: TObject);
    procedure GridNb_SpinEditChange(Sender: TObject);
    procedure Image_CurrentTextureMouseDown(Sender: TObject;
      {%H-}Button: TMouseButton; {%H-}Shift: TShiftState; {%H-}X, {%H-}Y: Integer);
    procedure PaintBox_PenPreviewPaint(Sender: TObject);
    procedure PaintBox_PictureMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PaintBox_PictureMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure PaintBox_PictureMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PaintBox_PictureMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure PaintBox_PicturePaint(Sender: TObject);
    procedure Panel_PenWidthMouseMove(Sender: TObject; {%H-}Shift: TShiftState; {%H-}X,
      {%H-}Y: Integer);
    procedure Panel_ToolbarBackgroundMouseMove(Sender: TObject;
      {%H-}Shift: TShiftState; {%H-}X, {%H-}Y: Integer);
    procedure SpinEdit_PenWidthMouseMove(Sender: TObject; {%H-}Shift: TShiftState;
      {%H-}X, {%H-}Y: Integer);
    procedure RenderAnyExecute(Sender: TObject);
    procedure FilterAnyExecute(Sender: TObject);
    procedure TimerDockingTimer(Sender: TObject);
    procedure ToolAnyExecute(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormHide(Sender: TObject);
    procedure FormMouseWheel(Sender: TObject; {%H-}Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure HelpAboutExecute(Sender: TObject);
    procedure HelpIndexExecute(Sender: TObject);
    procedure ImageChangeCanvasSizeExecute(Sender: TObject);
    procedure ImageCropUpdate(Sender: TObject);
    procedure ImageRepeatExecute(Sender: TObject);
    procedure MenuFileClick(Sender: TObject);
    procedure RecentFileClick(Sender: TObject);
    procedure LanguageClick(Sender: TObject);
    procedure SpinEdit_TextOutlineWidthChange(Sender: TObject);
    procedure SpinEdit_TextShadowXChange(Sender: TObject);
    procedure SpinEdit_TextShadowYChange(Sender: TObject);
    procedure TimerUpdateTimer(Sender: TObject);
    procedure TimerHidePenPreviewTimer(Sender: TObject);
    procedure ToolChangeDockingExecute(Sender: TObject);
    procedure ToolHotSpotUpdate(Sender: TObject);
    procedure ToolRotateSelectionUpdate(Sender: TObject);
    procedure Tool_CurveModeAngleClick(Sender: TObject);
    procedure Tool_CurveModeAutoClick(Sender: TObject);
    procedure Tool_CurveModeCurveClick(Sender: TObject);
    procedure Tool_CurveMovePointClick(Sender: TObject);
    procedure Tool_EraseOptionClick(Sender: TObject);
    procedure Tool_PhongShapeHorizontalCylinderClick(Sender: TObject);
    procedure Tool_PhongShapeVerticalConeClick(Sender: TObject);
    procedure Tool_PhongShapeVerticalCylinderClick(Sender: TObject);
    procedure ToolLayerMappingUpdate(Sender: TObject);
    procedure Tool_TextAlignClick(Sender: TObject);
    procedure Tool_TextPhongClick(Sender: TObject);
    procedure Tool_GridMoveWithoutDeformationClick(Sender: TObject);
    procedure Tool_PhongShapeConeClick(Sender: TObject);
    procedure Tool_PhongShapeRectangleClick(Sender: TObject);
    procedure Tool_PhongShapeRoundRectClick(Sender: TObject);
    procedure Tool_PhongShapeSphereClick(Sender: TObject);
    procedure Tool_SinGradientClick(Sender: TObject);
    procedure Combo_GradientColorspaceChange(Sender: TObject);
    procedure ToolLoadTextureExecute(Sender: TObject);
    procedure ToolNoTextureExecute(Sender: TObject);
    procedure ToolNoTextureUpdate(Sender: TObject);
    procedure Tool_CapFlatClick(Sender: TObject);
    procedure Tool_CapRoundClick(Sender: TObject);
    procedure Tool_CapSquareClick(Sender: TObject);
    procedure Tool_JoinBevelClick(Sender: TObject);
    procedure Tool_JoinRoundClick(Sender: TObject);
    procedure Tool_JoinMiterClick(Sender: TObject);
    procedure Tool_PenDashClick(Sender: TObject);
    procedure Tool_PenDashDotClick(Sender: TObject);
    procedure Tool_PenDashDotDotClick(Sender: TObject);
    procedure Tool_PenDotClick(Sender: TObject);
    procedure Tool_PenSolidClick(Sender: TObject);
    procedure Tool_TextFontClick(Sender: TObject);
    procedure Tool_TextOutlineClick(Sender: TObject);
    procedure Tool_TextShadowClick(Sender: TObject);
    procedure ViewColorsExecute(Sender: TObject);
    procedure ViewColorsUpdate(Sender: TObject);
    procedure ViewGridUpdate(Sender: TObject);
    procedure ViewImageListExecute(Sender: TObject);
    procedure ViewLayerStackButtonUpdate(Sender: TObject);
    procedure ViewLayerStackExecute(Sender: TObject);
    procedure ViewLayerStackUpdate(Sender: TObject);
    procedure ViewPaletteExecute(Sender: TObject);
    procedure ViewPaletteUpdate(Sender: TObject);
    procedure ViewStatusBarExecute(Sender: TObject);
    procedure ViewStatusBarUpdate(Sender: TObject);
    procedure ViewToolboxUpdate(Sender: TObject);
    procedure ViewImagelistUpdate(Sender: TObject);
    procedure SpinEdit_EraserChange(Sender: TObject);
    procedure ScriptExecute(Sender: TObject);
    procedure FileQuitExecute(Sender: TObject);
    procedure FileSaveUpdate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; {%H-}Shift: TShiftState);
    procedure FormResize(Sender: TObject);
    procedure ImageActionExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormPaint(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Image_SwapColorsMouseDown(Sender: TObject; {%H-}Button: TMouseButton;
      {%H-}Shift: TShiftState; {%H-}X, {%H-}Y: Integer);
    procedure SpinEdit_PenWidthChange(Sender: TObject);
    procedure Tool_CloseShapeClick(Sender: TObject);
    procedure Shape_BackColorMouseDown(Sender: TObject; Button: TMouseButton;
      {%H-}Shift: TShiftState; {%H-}X, {%H-}Y: Integer);
    procedure Shape_PenColorMouseDown(Sender: TObject; Button: TMouseButton;
      {%H-}Shift: TShiftState; {%H-}X, {%H-}Y: Integer);
    procedure SpinEdit_BackOpacityChange(Sender: TObject);
    procedure SpinEdit_PenOpacityChange(Sender: TObject);
    procedure SpinEdit_ArrowSizeChange(Sender: TObject);
    procedure SpinEdit_ToleranceChange(Sender: TObject);
    procedure Tool_DiamondGradientClick(Sender: TObject);
    procedure Tool_LinearGradientClick(Sender: TObject);
    procedure Tool_ProgressiveFloodfillClick(Sender: TObject);
    procedure Tool_RadialGradientClick(Sender: TObject);
    procedure Tool_ReflectedGradientClick(Sender: TObject);
    procedure Tool_AliasingClick(Sender: TObject);
    procedure Tool_DrawShapeBorderClick(Sender: TObject);
    procedure Tool_FillShapeClick(Sender: TObject);
    procedure ToolMoveSelectionUpdate(Sender: TObject);
    procedure ViewToolboxExecute(Sender: TObject);
    procedure SpinEdit_PenWidthExit(Sender: TObject);
    procedure SpinEdit_GridNbExit(Sender: TObject);
    procedure WMEraseBkgnd(var {%H-}Message: TLMEraseBkgnd); message LM_ERASEBKGND;

  private
    function GetImage: TLazPaintImage;
  private
    { private declarations }
    FLayout: TMainFormLayout;
    SpinEdit_PenOpacity, SpinEdit_BackOpacity, SpinEdit_TextureOpacity,
    SpinEdit_Eraser,SpinEdit_Tolerance,SpinEdit_PenWidth,
    SpinEdit_BrushSpacing: TBarUpDown;

    SpinEdit_ArrowSizeX,SpinEdit_ArrowSizeY: TBarUpDown;

    SpinEdit_TextShadowX,
    SpinEdit_TextOutlineWidth,
    SpinEdit_TextShadowY,
    SpinEdit_TextSize,
    SpinEdit_TextBlur: TBarUpDown;

    SpinEdit_GridNbX,SpinEdit_GridNbY: TBarUpDown;

    SpinEdit_PhongBorderSize, SpinEdit_ShapeAltitude: TBarUpDown;

    FActiveSpinEdit: TBarUpDown;
    FLastWidth,FLastHeight,FLastBPP,FLastFrameIndex: integer;
    {$IFDEF LINUX}
    FTopMostHiddenMinimised: TTopMostInfo;
    {$ENDIF}
    FBrowseImages: TFBrowseImages;
    FBrowseSelections: TFBrowseImages;
    FBrowseTextures: TFBrowseImages;
    FBrowseBrushes: TFBrowseImages;
    FSaveImage: TFBrowseImages;
    FSaveSelection: TFBrowseImages;

    FTablet: TLazTablet;

    FLoadInitialDir, FSaveInitialDir: string;
    FSaveSelectionInitialFilename: string;
    FInTextFont: boolean;
    FInPenWidthChange: boolean;
    FOnlineUpdater: TLazPaintCustomOnlineUpdater;
    initialized: boolean;
    shouldArrangeOnResize: boolean;
    btnLeftDown, btnRightDown, btnMiddleDown: boolean;
    spacePressed: boolean;
    FormMouseMovePos: TPoint;
    InFormMouseMove: boolean;
    InFormPaint: boolean;
    FirstPaint, LoadToolWindow: boolean;
    CanCompressOrUpdateStack: boolean;
    FShowSelectionNormal: boolean;
    FLazPaintInstance: TLazPaintCustomInstance;
    Config: TLazPaintConfig;
    FImageActions: TImageActions;
    StartDirectory: string;
    previousToolImg: integer;
    currentToolLabel: string;
    InShowNoPicture: boolean;
    FTopMostInfo: TTopMostInfo;
    DelayedPaintPicture: boolean;
    Panel_LineCap_FullSize: integer;
    FCoordinatesCaption: string;
    FCoordinatesCaptionCount: NativeInt;
    FImageView: TImageView;
    FUpdateStackWhenIdle: boolean;

    function GetCurrentPressure: single;
    function GetUseImageBrowser: boolean;
    procedure UpdateStatusText;
    procedure CreateToolbarElements;
    function GetCurrentToolAction: TAction;
    procedure NoTextureIcon;
    procedure RegisterToolbarElements;
    procedure InitToolbarElements;
    procedure DestroyMenuAndToolbar;
    function ShowOpenBrushDialog: boolean;
    function TextSpinEditFocused: boolean;
    procedure UpdateBrush;

    procedure CreateMenuAndToolbar;
    function GetToolManager: TToolManager;
    procedure LayoutPictureAreaChange({%H-}ASender: TObject; {%H-}ANewArea: TRect);
    procedure UpdatePanelTextWidth;
    function GetCurrentTool: TPaintToolType;
    procedure SwitchColors;
    procedure Init;
    procedure OnLatestVersionUpdate(ANewVersion: string);
    procedure OnToolChanged({%H-}sender: TToolManager; {%H-}ANewTool: TPaintToolType);
    procedure OnQueryExitToolHandler({%H-}sender: TLazPaintImage);
    procedure OnZoomChanged({%H-}sender: TZoom; {%H-}ANewZoom: single);
    procedure SetLazPaintInstance(const AValue: TLazPaintCustomInstance);
    procedure SetShowSelectionNormal(const AValue: boolean);
    procedure ToggleToolwindowsVisible;
    procedure UpdateTextSizeIncrement;
    procedure UpdateToolImage;
    procedure ToggleGridVisible;
    procedure ToggleToolboxVisible;
    procedure ToggleImageListVisible;
    procedure ToggleColorsVisible;
    procedure ToggleLayersVisible;
    procedure ShowColorDialogForPen;
    procedure ShowColorDialogForBack;
    procedure ShowPenPreview(ShouldRepaint: boolean= False);
    procedure HidePenPreview(TimeMs: Integer = 300);
    procedure OnPaintHandler;
    procedure OnImageChangedHandler({%H-}AEvent: TLazPaintImageObservationEvent);
    procedure UpdateTextureIcon;
    procedure LabelAutosize(ALabel: TLabel);
    procedure AskMergeSelection(ACaption: string);
    procedure ReleaseMouseButtons(Shift: TShiftState);
    procedure UpdatePanelPhongShape;
    procedure UpdateCurveMode;
    function ShowOpenTextureDialog: boolean;
    procedure ShowNoPicture;
    procedure SetCurveMode(AMode: TToolSplineMode);
    procedure IncreasePenSize;
    procedure DecreasePenSize;
    function PenSizeDelta(direction: integer): integer;
    procedure UpdateWindowCaption;
    procedure ImageCurrentFilenameChanged({%H-}sender: TLazPaintImage);

    procedure RegisterScripts(ARegister: Boolean);
    function ScriptFileOpen(AVars: TVariableSet): TScriptResult;
    function ScriptFileSaveAs(AVars: TVariableSet): TScriptResult;
    function ScriptFileSave({%H-}AVars: TVariableSet): TScriptResult;
    function ScriptFileReload({%H-}AVars: TVariableSet): TScriptResult;
    function ScriptFileLoadSelection(AVars: TVariableSet): TScriptResult;
    function ScriptFileSaveSelectionAs(AVars: TVariableSet): TScriptResult;
    function ScriptEditPasteAsNew({%H-}AVars: TVariableSet): TScriptResult;
    function ScriptFilter(AVars: TVariableSet): TScriptResult;
    function ScriptChooseTool(AVars: TVariableSet): TScriptResult;
    function ScriptViewZoomIn({%H-}AVars: TVariableSet): TScriptResult;
    function ScriptViewZoomOut({%H-}AVars: TVariableSet): TScriptResult;
    function ScriptViewZoomOriginal({%H-}AVars: TVariableSet): TScriptResult;
    function ScriptViewZoomFit({%H-}AVars: TVariableSet): TScriptResult;
    function ScriptViewGrid(AVars: TVariableSet): TScriptResult;
    function GetScriptContext: TScriptContext;
    procedure CallScriptFunction(AName:string); overload;
    procedure CallScriptFunction(AParams:TVariableSet); overload;
    procedure ZoomFitIfTooBig;
    property Scripting: TScriptContext read GetScriptContext;
    property Image: TLazPaintImage read GetImage;

  public
    { public declarations }
    FormBackgroundColor: TColor;
    UpdateStackOnTimer: boolean;
    Zoom: TZoom;

    procedure PaintPictureNow;
    function TryOpenFileUTF8(filenameUTF8: string; AddToRecent: Boolean=True; ALoadedImage: PImageEntry = nil;
      ASkipDialogIfSingleImage: boolean = false): Boolean;
    function PictureCanvasOfs: TPoint;
    procedure UpdateLineCapBar;
    procedure UpdateToolbar;
    function ChooseTool(Tool : TPaintToolType): boolean;
    procedure PictureSelectedLayerIndexChanged({%H-}sender: TLazPaintImage);
    procedure PictureSelectedLayerIndexChanging({%H-}sender: TLazPaintImage);
    property LazPaintInstance: TLazPaintCustomInstance read FLazPaintInstance write SetLazPaintInstance;
    procedure UpdateEditPicture(ADelayed: boolean = false);
    property CurrentTool: TPaintToolType read GetCurrentTool;
    property CurrentToolAction: TAction read GetCurrentToolAction;
    property ShowSelectionNormal: boolean read FShowSelectionNormal write SetShowSelectionNormal;
    property ToolManager: TToolManager read GetToolManager;
    property Layout: TMainFormLayout read FLayout;
    property UseImageBrowser: boolean read GetUseImageBrowser;
    property CurrentPressure: single read GetCurrentPressure;
  end;

implementation

uses LCLIntf, BGRAUTF8, ugraph, math, umac, uclipboard, ucursors,
   ufilters, ULoadImage, ULoading, UFileExtensions, UBrushType,
   ugeometricbrush, UPreviewDialog, UQuestion, BGRALayerOriginal;

const PenWidthFactor = 10;

{ TFMain }

{$i maintoolbar.inc}

procedure TFMain.FormCreate(Sender: TObject);
begin
  initialized := false;

  FLayout := TMainFormLayout.Create(self);
  FImageView := nil;

  ScaleControl(Self,OriginalDPI);

  //use background color
  FormBackgroundColor := OutsideColor;
  self.Color := clBtnFace; //toolbar color inherited on mac

  {$IFDEF USEPAINTBOXPICTURE}
  PaintBox_Picture.SetBounds(0,0,ClientWidth,ClientHeight);
  PaintBox_Picture.Visible := True;
  {$ENDIF}

  //mac interface
  CheckActions(ActionList1);
  CheckQuitMenu(ItemQuit,ItemQuitSeparator);

  {$IFDEF WINDOWS}
  StartDirectory := SysToUTF8(ExtractFilePath(Application.ExeName));
  {$ELSE}
  StartDirectory := GetCurrentDirUTF8;
  {$ENDIF}

  OpenPictureDialog1.Filter := GetExtensionFilter([eoReadable]);
  OpenTextureDialog.Filter := OpenPictureDialog1.Filter;
  LoadSelectionDialog.Filter := OpenPictureDialog1.Filter;
  SavePictureDialog1.Filter := GetExtensionFilter([eoWritable]);
  SaveSelectionDialog.Filter := SavePictureDialog1.Filter;

  Zoom := TZoom.Create(Label_CurrentZoom,Edit_Zoom,FLayout);
  Zoom.OnZoomChanged:= @OnZoomChanged;
  previousToolImg:= -1;

  //mouse status
  btnLeftDown := false;
  btnRightDown := false;
  btnMiddleDown:= false;
  FTablet := TLazTablet.Create(self);

  //recursive calls
  InFormMouseMove:= false;
  InFormPaint := false;

  CreateMenuAndToolbar;
  {$IFDEF LINUX}
  ComboBox_BrushSelect.Top := ComboBox_BrushSelect.Top - 2;
  ComboBox_BrushSelect.Font.Height := -10;
  ComboBox_BrushSelect.Font.Height := -( 10 + ((Panel_Brush.ClientHeight-2)-ComboBox_BrushSelect.Height) );

  ComboBox_ArrowStart.Top := ComboBox_ArrowStart.Top - 2;
  ComboBox_ArrowStart.Font.Height := ComboBox_BrushSelect.Font.Height;
  ComboBox_ArrowEnd.Top := ComboBox_ArrowEnd.Top - 2;
  ComboBox_ArrowEnd.Font.Height := ComboBox_BrushSelect.Font.Height;
  {$ENDIF}

  FLayout.OnPictureAreaChange := @LayoutPictureAreaChange;
  //DarkTheme.SetDarkTheme(Self);
  initialized := true;
  FirstPaint := true;
end;

procedure TFMain.CreateMenuAndToolbar;
var m: TMainFormMenu;
begin
  CreateToolbarElements;

  m := TMainFormMenu.Create(ActionList1);
  m.PredefinedMainMenus([MenuFile,MenuEdit,MenuSelect,MenuView, MenuImage,MenuRemoveTransparency,
    MenuColors,MenuTool, MenuFilter,MenuRadialBlur, MenuRender,MenuHelp]);
  m.Toolbars([Panel_Embedded,Panel_File,Panel_Zoom,Panel_Undo,Panel_CopyPaste,Panel_Coordinates,
    Panel_Tool,Panel_Color,Panel_Texture,Panel_Grid,Panel_PenWidth,Panel_Aliasing,Panel_ShapeOption,Panel_LineCap,Panel_JoinStyle,
    Panel_PenStyle,Panel_SplineStyle,Panel_Eraser,Panel_Tolerance,Panel_GradientType,Panel_Text,Panel_TextOutline,
    Panel_PhongShape,Panel_Altitude,Panel_PerspectiveOption,Panel_Brush,Panel_Ratio],Panel_ToolbarBackground);
  m.Apply;
  FLayout.Menu := m;
end;

function TFMain.GetToolManager: TToolManager;
begin
  result := FLazPaintInstance.ToolManager;
end;

procedure TFMain.FormDestroy(Sender: TObject);
begin
  if Assigned(Image) then
  begin
    Image.OnSelectionChanged := nil;
    Image.OnSelectedLayerIndexChanged:= nil;
    Image.OnSelectedLayerIndexChanging:= nil;
  end;
  FLayout.ToolBoxPopup := nil;
  RegisterScripts(False);
  FreeAndNil(FImageActions);

  If Assigned(ToolManager) then
  begin
    if ToolManager.OnToolChanged = @OnToolChanged then
      ToolManager.OnToolChanged := nil;
  end;
  FreeAndNil(Zoom);
  FreeAndNil(FOnlineUpdater);

  DestroyMenuAndToolbar;

  FreeAndNil(FTablet);

  FreeAndNil(FBrowseSelections);
  FreeAndNil(FBrowseImages);
  FreeAndNil(FBrowseTextures);
  FreeAndNil(FBrowseBrushes);
  if Assigned(FSaveImage) and Config.DefaultRememberSaveFormat then
    Config.SetSaveExtensions(FSaveImage.DefaultExtensions);
  FreeAndNil(FSaveImage);
  FreeAndNil(FSaveSelection);

  FreeAndNil(FImageView);
  FreeAndNil(FLayout);
end;

procedure TFMain.SetLazPaintInstance(const AValue: TLazPaintCustomInstance);
begin
  if (FLazPaintInstance = nil) and (AValue <> nil) then
  begin
    FLazPaintInstance := AValue;
    FLayout.LazPaintInstance := AValue;
    Init;
  end;
end;

procedure TFMain.Init;
begin
  initialized := false;
  Config := LazPaintInstance.Config;
  if Config.Default3dObjectDirectory = '' then
    Config.SetDefault3dObjectDirectory(StartDirectory);

  MainMenu1.Images := LazPaintInstance.Icons[DoScaleX(20,OriginalDPI)];
  if Config.DefaultRememberStartupTargetDirectory then
    FSaveInitialDir := Config.DefaultStartupTargetDirectory;
  if Config.DefaultRememberStartupSourceDirectory then
    FLoadInitialDir := Config.DefaultStartupSourceDirectory;
  FileRememberSaveFormat.Checked:= Config.DefaultRememberSaveFormat;

  FImageView := TImageView.Create(LazPaintInstance, Zoom,
                {$IFDEF USEPAINTBOXPICTURE}PaintBox_Picture.Canvas{$ELSE}self.Canvas{$ENDIF},
                FormBackgroundColor);

  FImageActions := TImageActions.Create(LazPaintInstance);
  LazPaintInstance.EmbeddedResult := mrNone;

  Image.OnSelectedLayerIndexChanged:= @PictureSelectedLayerIndexChanged;
  Image.OnSelectedLayerIndexChanging:= @PictureSelectedLayerIndexChanging;
  Image.CurrentFilenameUTF8 := '';

  RegisterToolbarElements;

  ToolManager.SetCurrentToolType(ptHand);
  ToolManager.OnToolChanged := @OnToolChanged;

  InitToolbarElements;

  FImageActions.SetCurrentBitmap(TBGRABitmap.Create(Config.DefaultImageWidth,Config.DefaultImageHeight,Config.DefaultImageBackgroundColor), false);
  image.ClearUndo;
  image.SetSavedFlag;

  ViewGrid.Checked := LazPaintInstance.GridVisible;
  ItemViewGrid.Checked:= LazPaintInstance.GridVisible;
  ColorCurves.Visible := not LazPaintInstance.BlackAndWhite;
  ColorColorize.Visible := not LazPaintInstance.BlackAndWhite;
  ColorShiftColors.Visible := not LazPaintInstance.BlackAndWhite;
  FilterComplementaryColor.Visible := not LazPaintInstance.BlackAndWhite;
  ColorIntensity.Visible := not LazPaintInstance.BlackAndWhite;
  FilterGrayscale.Visible := not LazPaintInstance.BlackAndWhite;
  FilterClearType.Visible := not LazPaintInstance.BlackAndWhite;
  FilterClearTypeInverse.Visible := not LazPaintInstance.BlackAndWhite;
  Panel_Zoom.Visible := Config.DefaultZoomToolbarVisible;
  Panel_Undo.Visible := Config.DefaultUndoRedoToolbarVisible;
  Panel_CopyPaste.Visible := Config.DefaultCopyPasteToolbarVisible;
  Panel_Coordinates.Visible := Config.DefaultCoordinatesToolbarVisible;
  FLayout.ToolBoxPopup := PopupToolbox;

  if not LazPaintInstance.Embedded then
  begin
    FOnlineUpdater := LazPaintInstance.GetOnlineUpdater;
    If Assigned(FOnlineUpdater) then
      FOnlineUpdater.OnLatestVersionUpdate := @OnLatestVersionUpdate;
  end;
  if Config.DefaultToolboxWindowVisible and (FLayout.DefaultToolboxDocking <> twWindow) then
    FLayout.ToolBoxVisible := true;
  initialized := true;

  RegisterScripts(True);

  Image.OnImageChanged.AddObserver(@OnImageChangedHandler);
  Image.OnQueryExitToolHandler := @OnQueryExitToolHandler;
  Image.Zoom := Zoom;
  UpdateWindowCaption;
  Image.OnCurrentFilenameChanged := @ImageCurrentFilenameChanged;
end;

procedure TFMain.FormShow(Sender: TObject);
begin
  LazPaintInstance.ColorToFChooseColor;
  LazPaintInstance.ShowTopmost(FTopMostInfo);
  if Position = poDefault then LazPaintInstance.RestoreMainWindowPosition;

  FLayout.Arrange;
  UpdateToolImage;
  UpdateToolBar;
  shouldArrangeOnResize := true;
end;

procedure TFMain.OnLatestVersionUpdate(ANewVersion: string);
begin
  if ANewVersion <> LazPaintVersionStr then
    LazPaintInstance.ShowMessage(rsLazPaint, rsLatestVersion + ' ' + ANewVersion);
end;

procedure TFMain.RegisterScripts(ARegister: Boolean);
begin
  Scripting.RegisterScriptFunction('FileOpen',@ScriptFileOpen,ARegister);
  Scripting.RegisterScriptFunction('FileSaveAs',@ScriptFileSaveAs,ARegister);
  Scripting.RegisterScriptFunction('FileSave',@ScriptFileSave,ARegister);
  Scripting.RegisterScriptFunction('FileReload',@ScriptFileReload,ARegister);
  Scripting.RegisterScriptFunction('FileLoadSelection',@ScriptFileLoadSelection,ARegister);
  Scripting.RegisterScriptFunction('FileSaveSelectionAs',@ScriptFileSaveSelectionAs,ARegister);
  Scripting.RegisterScriptFunction('EditPasteAsNew',@ScriptEditPasteAsNew,ARegister);
  Scripting.RegisterScriptFunction('Filter',@ScriptFilter,ARegister);
  Scripting.RegisterScriptFunction('ChooseTool',@ScriptChooseTool,ARegister);
  Scripting.RegisterScriptFunction('ViewZoomIn',@ScriptViewZoomIn,ARegister);
  Scripting.RegisterScriptFunction('ViewZoomOut',@ScriptViewZoomOut,ARegister);
  Scripting.RegisterScriptFunction('ViewZoomOriginal',@ScriptViewZoomOriginal,ARegister);
  Scripting.RegisterScriptFunction('ViewZoomFit',@ScriptViewZoomFit,ARegister);
  Scripting.RegisterScriptFunction('ViewGrid',@ScriptViewGrid,ARegister);
end;

procedure TFMain.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if not Assigned(FImageView) then exit;
  ReleaseMouseButtons(Shift);
  if not (Button in[mbLeft,mbRight,mbMiddle]) then exit;
  CanCompressOrUpdateStack := false;
  Image.OnImageChanged.DelayedStackUpdate := True;

  if btnLeftDown or btnRightDown or btnMiddleDown then exit;
  if Button = mbLeft then
    btnLeftDown := true else
  if Button = mbRight then
    btnRightDown := true else
  if Button = mbMiddle then
  begin
    btnMiddleDown:= true;
    if not ToolManager.ToolSleeping then ToolManager.ToolSleep;
  end;
  if ToolManager.ToolDown(FImageView.FormToBitmap(X,Y),btnRightDown,CurrentPressure) then
      PaintPictureNow;
  UpdateToolbar;
end;

procedure TFMain.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var BmpPos: TPointF;
    updateForVSCursor: boolean;

//var tickstart:DWord;
begin
  //tickstart := GetTickCount;
  if not Assigned(FImageView) then exit;

  ReleaseMouseButtons(Shift);
  HidePenPreview;
  if LazPaintInstance.TopMostHasFocus then
  begin
    if LazPaintInstance.TopMostOkToUnfocus then
      SafeSetFocus(self)
    else
      exit;
  end;
  if (CurrentTool = ptText) and TextSpinEditFocused then SpinEdit_PenOpacity.SetFocus;

  FormMouseMovePos := Point(X,Y);
  if InFormMouseMove then exit;
  InFormMouseMove := True;
  //Application.ProcessMessages; //empty message stack

  BmpPos := FImageView.FormToBitmap(FormMouseMovePos);
  FCoordinatesCaption := IntToStr(round(BmpPos.X))+','+IntToStr(round(BmpPos.Y));
  Inc(FCoordinatesCaptionCount);
  if FCoordinatesCaptionCount > 8 then
  begin
    FCoordinatesCaptionCount := 0;
    Label_Coordinates.caption := FCoordinatesCaption;
    Label_Coordinates.Update;
    UpdateStatusText;
  end;
  updateForVSCursor:= false;
  if ToolManager.ToolMove(BmpPos,CurrentPressure) then
  begin
    FImageView.UpdatePicture(PictureCanvasOfs, FLayout.WorkArea,
                             {$IFDEF USEPAINTBOXPICTURE}PaintBox_Picture{$ELSE}self{$ENDIF});
    ToolManager.ToolMoveAfter(FImageView.FormToBitmap(FormMouseMovePos)); //new BmpPos after repaint
  end else
    updateForVSCursor := true;
  UpdateToolbar;

  if updateForVSCursor then
    FImageView.UpdateCursor(X,Y, PictureCanvasOfs, FLayout.WorkArea,
                            {$IFDEF USEPAINTBOXPICTURE}PaintBox_Picture{$ELSE}self{$ENDIF},
                            Point(0,0), self);

  if ToolManager.ToolSleeping and not spacePressed and not btnLeftDown and not btnRightDown
    and not btnMiddleDown then
    ToolManager.ToolWakeUp;

  InFormMouseMove := False;
  //Canvas.TextOut(FLayout.WorkArea.Left,FLayout.WorkArea.Top,inttostr(GetTickCount-tickstart)+'     ');
end;

procedure TFMain.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var redraw: boolean;
begin
  if not Assigned(FImageView) then exit;

  redraw := ToolManager.ToolMove(FImageView.FormToBitmap(X,Y),CurrentPressure);
  if (btnLeftDown and (Button = mbLeft)) or (btnRightDown and (Button=mbRight))
    or (btnMiddleDown and (Button = mbMiddle)) then
  begin
    if ToolManager.ToolUp then redraw := true;
    btnLeftDown := false;
    btnRightDown := false;
    btnMiddleDown:= false;
  end;
  if redraw then PaintPictureNow;
  if FUpdateStackWhenIdle then
  begin
    UpdateStackOnTimer:= true;
    FUpdateStackWhenIdle:= false;
  end;
  UpdateToolbar;
  ReleaseMouseButtons(Shift);

  if ToolManager.ToolSleeping and not spacePressed and not btnLeftDown and not btnRightDown
   and not btnMiddleDown then
    ToolManager.ToolWakeUp;
end;

function TFMain.ScriptFileOpen(AVars: TVariableSet): TScriptResult;
var vFilename: TScriptVariableReference;
    topInfo: TTopMostInfo;
    i: integer;
    cancelled: boolean;
    chosenFiles: array of string;
    loadedImage: TImageEntry;
begin
  loadedImage := TImageEntry.Empty;
  try
    topInfo.defined:= false;
    if Image.IsFileModified then
    begin
      topInfo := FLazPaintInstance.HideTopmost;
      case LazPaintInstance.SaveQuestion(rsOpen) of
      IDYES: begin
               result := Scripting.CallScriptFunction('FileSave');
               if result <> srOk then
               begin
                 FLazPaintInstance.ShowTopmost(topInfo);
                 exit;
               end;
             end;
      IDCANCEL: begin
                  FLazPaintInstance.ShowTopmost(topInfo);
                  result := srCancelledByUser;
                  exit;
                end;
      end;
    end;
    vFileName := AVars.GetVariable('FileName');
    if AVars.IsReferenceDefined(vFileName) then
    begin
      FLazPaintInstance.ShowTopmost(topInfo);
      if TryOpenFileUTF8(AVars.GetString(vFilename), true, nil) then
        result := srOk
      else
        result := srException;
    end
    else
    begin
      if UseImageBrowser then
      begin
        if not assigned(FBrowseImages) then
        begin
          FBrowseImages := TFBrowseImages.Create(self);
          FBrowseImages.LazPaintInstance := LazPaintInstance;
          FBrowseImages.ShowRememberStartupDirectory := true;
        end;
      end;
      try
        if not topInfo.defined then topInfo := FLazPaintInstance.HideTopmost;
        if UseImageBrowser then
        begin
          self.Hide;
          FBrowseImages.InitialDirectory:= FLoadInitialDir;
          FBrowseImages.AllowMultiSelect:= true;
          if FBrowseImages.ShowModal = mrOK then
          begin
            setlength(chosenFiles, FBrowseImages.SelectedFileCount);
            for i := 0 to high(chosenFiles) do
              chosenFiles[i] := FBrowseImages.SelectedFile[i];
            loadedImage := FBrowseImages.GetChosenImage;
            cancelled := false
          end
          else
          begin
            chosenFiles := nil;
            cancelled := true;
          end;
          FBrowseImages.AllowMultiSelect:= false;
        end else
        begin
          OpenPictureDialog1.InitialDir:= FLoadInitialDir;
          OpenPictureDialog1.Options := OpenPictureDialog1.Options + [ofAllowMultiSelect];
          if OpenPictureDialog1.Execute then
          begin
            setlength(chosenFiles,1);
            chosenFiles[0]:= OpenPictureDialog1.FileName;
            cancelled := false;
          end
          else
          begin
            chosenFiles:= nil;
            cancelled:= true;
          end;
          OpenPictureDialog1.Options := OpenPictureDialog1.Options - [ofAllowMultiSelect];
        end;
        if not cancelled then
        begin
          if length(chosenFiles) = 1 then
          begin
            if TryOpenFileUTF8(chosenFiles[0],true,@loadedImage,true) then
            begin
              result := srOk;
              if Assigned(Scripting.RecordingFunctionParameters) then
                 Scripting.RecordingFunctionParameters.AddString('FileName',chosenFiles[0]);
            end
            else
              result := srException;
          end else
          begin
            result := srOk;
            FormDropFiles(self, chosenFiles);
          end;
          FLoadInitialDir:= ExtractFilePath(chosenFiles[0]);
          if Config.DefaultRememberStartupSourceDirectory then
            Config.SetStartupSourceDirectory(FLoadInitialDir);
        end
        else
          result := srCancelledByUser;
      finally
        self.Show;
        FLazPaintInstance.ShowTopmost(topInfo);
      end;
    end;
  except
    on ex: Exception do
    begin
      LazPaintInstance.ShowError('FileOpen',ex.Message);
      result := srException;
    end;
  end;
  loadedImage.FreeAndNil;
end;

procedure TFMain.FileQuitExecute(Sender: TObject);
begin
  Close;
end;

function TFMain.ScriptFileSaveAs(AVars: TVariableSet): TScriptResult;

  function DoSaveAs(filename: string): TScriptResult;
  var saved: boolean;
  begin
    if not Image.AbleToSaveAsUTF8(filename) then
    begin
      LazPaintInstance.ShowError(rsSave, rsFileExtensionNotSupported);
      result := srException;
    end else
    begin
      try
        saved := false;
        if (Image.currentFilenameUTF8 <> '') and
          ( ((SuggestImageFormat(Image.currentFilenameUTF8) in [ifIco,ifCur])
           and (SuggestImageFormat(filename) in [ifIco,ifCur])) or
           ((SuggestImageFormat(Image.currentFilenameUTF8) = ifTiff)
           and (SuggestImageFormat(filename) = ifTiff)) ) then
        begin
           Image.UpdateMultiImage(filename);
           saved := true;
        end
        else
        begin
          if not LazPaintInstance.ShowSaveOptionDlg(nil,filename) then
            result := srCancelledByUser
          else
            saved := true;
        end;

        if saved then
        begin
          Config.AddRecentFile(filename);
          Config.AddRecentDirectory(ExtractFilePath(filename));
          FSaveInitialDir := extractFilePath(filename);
          if Config.DefaultRememberStartupTargetDirectory then
            Config.SetStartupTargetDirectory(FSaveInitialDir);
          Image.CurrentFilenameUTF8 := filename;
          result := srOk;
          if Assigned(Scripting.RecordingFunctionParameters) then
             Scripting.RecordingFunctionParameters.AddString('FileName',filename);
        end;
      except
        on ex: Exception do
        begin
          LazPaintInstance.ShowError('FileSaveAs',ex.Message);
          result := srException;
        end;
      end;
    end;
  end;

var filename: string;
    vFileName: TScriptVariableReference;
    topMost: TTopMostInfo;
    defaultExt: string;
begin
  AskMergeSelection(rsSave);
  filename := ExtractFileName(Image.CurrentFilenameUTF8);
  vFileName := AVars.GetVariable('FileName');
  if AVars.IsReferenceDefined(vFileName) then filename := AVars.GetString(vFileName);
  if filename = '' then filename := rsNoName;
  if SavePictureDialog1.FilterIndex > 1 then
    filename := ApplySelectedFilterExtension(filename,SavePictureDialog1.Filter,SavePictureDialog1.FilterIndex);
  if not Image.AbleToSaveAsUTF8(filename) then
  begin
    SavePictureDialog1.FilterIndex := 1;
    filename := ChangeFileExt(Filename,'');
  end;
  SavePictureDialog1.FileName := filename;
  topMost := LazPaintInstance.HideTopmost;

  case SuggestImageFormat(Image.CurrentFilenameUTF8) of
  ifCur: defaultExt := '.cur';
  ifIco: defaultExt := '.ico';
  else
    begin
      if Image.NbLayers > 1 then defaultExt := '.lzp' else
        defaultExt := '.png';
    end;
  end;

  if UseImageBrowser then
  begin
    if not assigned(FSaveImage) then
    begin
      FSaveImage := TFBrowseImages.Create(self);
      FSaveImage.LazPaintInstance := LazPaintInstance;
      FSaveImage.IsSaveDialog := true;
      FSaveImage.Caption := SavePictureDialog1.Title;
      FSaveImage.ShowRememberStartupDirectory:= true;
      if Config.DefaultRememberSaveFormat then
        FSaveImage.DefaultExtensions:= Config.DefaultSaveExtensions;
    end;
    FSaveImage.InitialFilename := filename;
    FSaveImage.DefaultExtension := defaultExt;
    FSaveImage.InitialDirectory:= FSaveInitialDir;
    if FSaveImage.ShowModal = mrOK then
      result := DoSaveAs(FSaveImage.FileName)
    else
      result := srCancelledByUser;
  end else
  begin
    SavePictureDialog1.DefaultExt := defaultExt;
    SavePictureDialog1.InitialDir:= FSaveInitialDir;
    if SavePictureDialog1.Execute then
    begin
      result := DoSaveAs(SavePictureDialog1.FileName);
    end else
      result := srCancelledByUser;
  end;
  LazPaintInstance.ShowTopmost(topMost);
end;

function TFMain.ScriptFileSave(AVars: TVariableSet): TScriptResult;
begin
  if (Image.CurrentFilenameUTF8 = '') or not Image.AbleToSaveAsUTF8(Image.CurrentFilenameUTF8) then
    result := Scripting.CallScriptFunction('FileSaveAs', True) else
    begin
      AskMergeSelection(rsSave);
      try
        if SuggestImageFormat(Image.currentFilenameUTF8) in [ifIco,ifCur,ifTiff,ifGif] then
        begin
           Image.UpdateMultiImage;
           result := srOk;
        end
        else
        begin
          if LazPaintInstance.ShowSaveOptionDlg(nil,Image.currentFilenameUTF8) then
            result := srOk
          else
            result := srCancelledByUser;
        end;

      except
        on ex: Exception do
        begin
          LazPaintInstance.ShowError(rsSave,ex.Message);
          result := srException;
        end;
      end;
    end;
end;

procedure TFMain.FileSaveUpdate(Sender: TObject);
begin
   FileSave.Enabled := image.IsFileModified;
end;

procedure TFMain.FilterAnyExecute(Sender: TObject);
var filterName: string;
    params: TVariableSet;
    s: string;
begin
  if Sender is TAction then
  begin
    filterName := (Sender as TAction).Name;
    if (length(filterName) >= 7) and (copy(filterName,1,6) = 'Filter') and
        (filterName[7] = upcase(filterName[7])) then
          delete(filterName,1,6);
    params := TVariableSet.Create('Filter');
    params.AddString('Name', filterName);
    s := (Sender as TAction).Caption;
    while (s<>'') and (s[length(s)] in[' ',':','.','?','!']) do
      delete(s,length(s),1);
    params.AddString('Caption', s);
    CallScriptFunction(params);
    params.Free;
  end;
end;

procedure TFMain.TimerDockingTimer(Sender: TObject);
var r: TRect;
begin
  if LoadToolWindow then
  begin
    LoadToolWindow := false;
    //show in descending order of size
    r := Config.DefaultImageListPosition;
    if (r.right > r.left) and (r.bottom > r.top) then
    begin
      LazPaintInstance.MoveImageListWindowTo(r.left,r.top);
      LazPaintInstance.ImageListWindowWidth:= r.right-r.left;
      LazPaintInstance.ImageListWindowHeight:= r.Bottom-r.Top;
    end
    else
      LazPaintInstance.MoveImageListWindowTo(self.Left+self.Width-LazPaintInstance.ImageListWindowWidth,
                         self.Top+self.Height-LazPaintInstance.ChooseColorHeight-LazPaintInstance.ImageListWindowHeight);
    if Config.DefaultImagelistWindowVisible then ToggleImageListVisible;

    r := Config.DefaultLayerWindowPosition;
    if (r.right > r.left) and (r.bottom > r.top) then
    begin
      LazPaintInstance.MoveLayerWindowTo(r.left,r.top);
      LazPaintInstance.LayerWindowWidth := r.right-r.left;
      LazPaintInstance.LayerWindowHeight := r.Bottom-r.Top;
    end
    else
      LazPaintInstance.MoveLayerWindowTo(self.Left+self.Width-LazPaintInstance.LayerWindowWidth,
                         self.Top+self.Height-LazPaintInstance.ChooseColorHeight-LazPaintInstance.LayerWindowHeight);
    if Config.DefaultLayerWindowVisible then ToggleLayersVisible;

    r := Config.DefaultColorWindowPosition;
    if (r.right > r.left) and (r.bottom > r.top) then
      LazPaintInstance.MoveChooseColorTo(r.left,r.top)
    else
      LazPaintInstance.MoveChooseColorTo(self.Left+self.Width-LazPaintInstance.ChooseColorWidth,
                         self.Top+self.Height-LazPaintInstance.ChooseColorHeight);
    if Config.DefaultColorWindowVisible then ToggleColorsVisible;

    r := Config.DefaultToolboxWindowPosition;
    if (r.right > r.left) and (r.bottom > r.top) then
      LazPaintInstance.MoveToolboxTo(r.left,r.Top)
    else
      LazPaintInstance.MoveToolboxTo(self.Left,self.Top+self.Height-LazPaintInstance.ToolBoxHeight);
    if Config.DefaultToolboxWindowVisible and not LazPaintInstance.ToolboxVisible then ToggleToolboxVisible;
  end;
  LazPaintInstance.ApplyDocking;
end;

procedure TFMain.RenderAnyExecute(Sender: TObject);
var filterName: string;
    params: TVariableSet;
begin
  if Sender is TAction then
  begin
    filterName := (Sender as TAction).Name;
    if (length(filterName) >= 7) and (copy(filterName,1,6) = 'Render') and
        (filterName[7] = upcase(filterName[7])) then
          delete(filterName,1,6);
    params := TVariableSet.Create('Filter');
    params.AddString('Name', filterName);
    CallScriptFunction(params);
    params.Free;
  end;
end;

procedure TFMain.ToolAnyExecute(Sender: TObject);
var toolName: string;
    params: TVariableSet;
begin
  if Sender is TAction then
  begin
    toolName := (Sender as TAction).Name;
    if (length(toolName) >= 5) and (copy(toolName,1,4) = 'Tool') and
        (toolName[5] = upcase(toolName[5])) then
          delete(toolName,1,4);
    params := TVariableSet.Create('ChooseTool');
    params.AddString('Name', toolName);
    CallScriptFunction(params);
    params.Free;
  end;
end;

procedure TFMain.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState
  );
begin
  try
    if Zoom.EditingZoom then exit;
    if not ((CurrentTool = ptText) and TextSpinEditFocused and (Key = VK_BACK)) and ToolManager.ToolKeyDown(Key) then
    begin
      DelayedPaintPicture := True;
    end else
    if Key = VK_F6 then
    begin
      ToggleToolwindowsVisible;
      Key := 0;
    end else
    If (Key = VK_SPACE) and not spacePressed then
    begin
      spacePressed:= true;
      Key := 0;
      if not ToolManager.ToolSleeping and not btnLeftDown and not btnRightDown then ToolManager.ToolSleep;
    end else
    if LazPaintInstance.ImageListWindowVisible then
      LazPaintInstance.ImageListWindowVisibleKeyDown(Key,Shift);
    If Key = 0 then UpdateToolbar;
  except
    on ex:exception do
      LazPaintInstance.ShowError('KeyDown',ex.Message);
  end;
end;

procedure TFMain.FormResize(Sender: TObject);
begin
  if shouldArrangeOnResize then FLayout.Arrange;
end;

procedure TFMain.ImageActionExecute(Sender: TObject);
var actionName: string;
begin
  if Sender is TAction then
  begin
    actionName:= (Sender as TAction).Name;
    CallScriptFunction(actionName);
  end;
end;

procedure TFMain.EditUndoUpdate(Sender: TObject);
begin
  EditUndo.Enabled := image.CanUndo;
end;

procedure TFMain.EmbeddedCancelExecute(Sender: TObject);
begin
  LazPaintInstance.EmbeddedResult := mrCancel;
  Close;
end;

procedure TFMain.EmbeddedValidateExecute(Sender: TObject);
begin
  LazPaintInstance.EmbeddedResult := mrOK;
  Close;
end;

procedure TFMain.FileImport3DExecute(Sender: TObject);
var topmostInfo: TTopMostInfo;
  dir3d: String;
begin
  topmostInfo:= LazPaintInstance.HideTopmost;
  Open3DObjectDialog.InitialDir := Config.Default3dObjectDirectory;
  if Open3DObjectDialog.InitialDir = '' then
  begin
    dir3d := {$IFDEF WINDOWS}SysToUTF8({$ENDIF}ExtractFilePath(Application.ExeName){$IFDEF WINDOWS}){$ENDIF}+'models';
    if DirectoryExistsUTF8(dir3d) then
      Open3DObjectDialog.InitialDir := dir3d;
  end;
  if Open3DObjectDialog.Execute then
  begin
    FImageActions.Import3DObject(Open3DObjectDialog.FileName);
    Config.SetDefault3dObjectDirectory(ExtractFilePath(Open3DObjectDialog.FileName));
  end;
  LazPaintInstance.ShowTopmost(topmostInfo);
end;

function TFMain.ScriptFileLoadSelection(AVars: TVariableSet): TScriptResult;
var selectionFileName: string;
    vFileName: TScriptVariableReference;
    topmost: TTopMostInfo;
    loadedImage: TImageEntry;
begin
  loadedImage := TImageEntry.Empty;
  vFileName := AVars.GetVariable('FileName');
  if AVars.IsReferenceDefined(vFileName) then
    selectionFileName := AVars.GetString(vFileName)
  else
  begin
    topmost := LazPaintInstance.HideTopmost;
    if UseImageBrowser then
    begin
      if not assigned(FBrowseSelections) then
      begin
        FBrowseSelections := TFBrowseImages.Create(self);
        FBrowseSelections.LazPaintInstance := LazPaintInstance;
        FBrowseSelections.AllowMultiSelect := false;
        FBrowseSelections.Caption := LoadSelectionDialog.Title;
      end;
      self.Hide;
      try
        if FBrowseSelections.ShowModal = mrOK then
        begin
          LazPaintInstance.ShowTopmost(topmost);
          selectionFileName := FBrowseSelections.Filename;
          loadedImage := FBrowseSelections.GetChosenImage;
          Config.AddRecentDirectory(ExtractFilePath(selectionFileName));
        end else
        begin
          result := srCancelledByUser;
          LazPaintInstance.ShowTopmost(topmost);
          exit;
        end;
      finally
        self.Show;
      end;
    end else
    begin
      if LoadSelectionDialog.Execute then
      begin
        LazPaintInstance.ShowTopmost(topmost);
        selectionFileName := LoadSelectionDialog.Filename
      end
      else
      begin
        result := srCancelledByUser;
        LazPaintInstance.ShowTopmost(topmost);
        exit;
      end;
    end;
  end;
  if FImageActions.LoadSelection(selectionFileName, @loadedImage) then
  begin
    FSaveSelectionInitialFilename := selectionFileName;
    if Assigned(Scripting.RecordingFunctionParameters) then
       Scripting.RecordingFunctionParameters.AddString('FileName',selectionFileName);
    result := srOk;
  end
  else result := srException;
  loadedImage.FreeAndNil;
end;

function TFMain.ScriptFileReload(AVars: TVariableSet): TScriptResult;
var topmostInfo: TTopMostInfo; res: integer;
begin
  if (Image.CurrentFilenameUTF8 = '') then
  begin
    result := srOk;
    exit;
  end;
  if Image.IsFileModified then
  begin
    topmostInfo := LazPaintInstance.HideTopmost;
    res := MessageDlg(rsReload,rsReloadChanged,mtWarning,mbYesNo,0);
    LazPaintInstance.ShowTopmost(topmostInfo);
    if res <> IDYES then
    begin
      result := srCancelledByUser;
      exit;
    end;
  end;
  if TryOpenFileUTF8(Image.CurrentFilenameUTF8) then
    result := srOk
  else
    result := srException;
end;

procedure TFMain.FileReloadUpdate(Sender: TObject);
begin
  FileReload.Enabled := (Image.CurrentFilenameUTF8 <> '');
end;

function TFMain.ScriptFileSaveSelectionAs(AVars: TVariableSet): TScriptResult;
var filename: string;
    vFileName: TScriptVariableReference;
begin
  if Image.SelectionMaskEmpty then
  begin
    result := srOk;
    exit;
  end;
  filename := '';
  vFileName := AVars.GetVariable('FileName');
  if AVars.IsReferenceDefined(vFileName) then
    filename:= AVars.GetString(vFileName);
  if filename = '' then filename := FSaveSelectionInitialFilename;
  if UseImageBrowser then
  begin
    if not assigned(FSaveSelection) then
    begin
      FSaveSelection := TFBrowseImages.Create(self);
      FSaveSelection.LazPaintInstance := LazPaintInstance;
      FSaveSelection.IsSaveDialog := true;
      FSaveSelection.Caption := SaveSelectionDialog.Title;
      FSaveSelection.DefaultExtension := SaveSelectionDialog.DefaultExt;
    end;
    if pos(PathDelim,filename)<>0 then FSaveSelection.InitialDirectory := ExtractFilePath(filename);
    FSaveSelection.InitialFilename := ExtractFileName(filename);
    if (FSaveSelection.ShowModal = mrOk) and (FSaveSelection.Filename <> '') then
      filename := FSaveSelection.Filename
    else
      filename := '';
  end else
  begin
    SaveSelectionDialog.FileName:= filename;
    if pos(PathDelim,SaveSelectionDialog.FileName)<>0 then
    begin
      filename := SaveSelectionDialog.FileName;
      SaveSelectionDialog.FileName := ExtractFileName(filename);
      SaveSelectionDialog.InitialDir := ExtractFilePath(filename);
    end;
    if SaveSelectionDialog.Execute then
      filename := SaveSelectionDialog.FileName
    else
      filename := '';
  end;
  if filename <> '' then
  begin
    if not Image.AbleToSaveSelectionAsUTF8(filename) then
    begin
      LazPaintInstance.ShowError(rsSave,rsFileExtensionNotSupported);
      result := srException;
    end else
    begin
      try
        Image.SaveSelectionMaskToFileUTF8(filename);
        result := srOk;
        if Assigned(Scripting.RecordingFunctionParameters) then
           Scripting.RecordingFunctionParameters.AddString('FileName',filename);
      except
        on ex: Exception do
        begin
          LazPaintInstance.ShowError('FileSaveSelectionAs',ex.Message);
          result := srException;
        end;
      end;
    end;
  end else
    result := srCancelledByUser;
end;

function TFMain.ScriptFilter(AVars: TVariableSet): TScriptResult;
var filter: TPictureFilter;
begin
  filter := StrToPictureFilter(AVars.GetString(AVars.GetVariable('Name')));
  if filter = pfNone then
     result := srInvalidParameters
  else
  begin
    if ExecuteFilter(LazPaintInstance, filter, AVars) then
      result := srOk
    else
      result := srException;
  end;
end;

procedure TFMain.FileSaveSelectionAsUpdate(Sender: TObject);
begin
  FileSaveSelectionAs.Enabled := not Image.SelectionMaskEmpty;
end;

procedure TFMain.FormDropFiles(Sender: TObject; const FileNames: array of String);
var
  i,tx,ty: integer;
  Errors: String='';
  loadedLayers: array of record
     bmp: TBGRABitmap;
     orig: TBGRALayerCustomOriginal;
     filename: string;
  end;
  topmost: TTopMostInfo;
  choice: TModalResult;
  svgOrig: TBGRALayerSVGOriginal;
begin
  if Length(FileNames)<1 then exit;
  if Length(FileNames)= 1
     then TryOpenFileUTF8(FileNames[0])
  else
     begin
       {$IFNDEF LINUX}
       //Button values higher than 10 are used, in order to avoid Delphis icons on the buttons.
       choice := QuestionDlg (rsOpenMultipleImageFiles, rsMoreThanOneFile, mtConfirmation, [mrLast+1,rsOpenFilesAsLayers,mrLast+2,rsAddToImageList,mrLast+3,rsOpenFirstFileOnly,mrCancel,rsCancel ],'');
       {$ELSE}
       choice := mrLast+1;
       {$ENDIF}
       case choice of
       mrLast+1: begin  //OpenFilesAsLayers
            if Image.IsFileModified then
               case LazPaintInstance.SaveQuestion(rsOpen) of
                IDYES: Scripting.CallScriptFunction('FileSave');
                IDCANCEL: exit;
              end; //case
              //When files are open this way, they get the name of the first of them.
              //They shall have no name, in order to prevent saving with Save (it then gets redirected to Save As)
              setlength(loadedLayers,length(FileNames));
              tx := 0;
              ty := 0;
              for i := 0 to high(FileNames) do
              begin
                try
                  MessagePopupForever(rsLoading + ' ' + inttostr(i+1) + '/' + inttostr(length(FileNames)));
                  LazPaintInstance.UpdateWindows;
                  loadedLayers[i].filename := Filenames[i];
                  case DetectFileFormat(Filenames[i]) of
                   ifSvg:
                     begin
                       svgOrig := LoadSVGOriginalUTF8(Filenames[i]);
                       loadedLayers[i].orig := svgOrig;
                       if ceil(svgOrig.Width) > tx then tx := ceil(svgOrig.Width);
                       if ceil(svgOrig.Height) > ty then ty := ceil(svgOrig.Height);
                     end
                   else
                     begin
                       loadedLayers[i].bmp := LoadFlatImageUTF8(Filenames[i]).bmp;
                       if loadedLayers[i].bmp.Width > tx then tx := loadedLayers[i].bmp.Width;
                       if loadedLayers[i].bmp.Height > ty then ty := loadedLayers[i].bmp.Height;
                     end;
                  end;
                  MessagePopupHide;
                except on ex:exception do
                  //begin
                    Errors:= Errors + StringReplace(rsErrorOnOpeningFile, '%1', FileNames[i], [])+ ' ('+ ex.Message + ')'+ LineEnding;
                  //end;
                  end; //try except
              end; //for
              MessagePopupForever(rsOpening+'...');
              LazPaintInstance.UpdateWindows;
              try
                if (tx > 0) and (ty > 0) then
                begin
                  Image.CurrentFilenameUTF8 := '';
                  Image.Assign(TBGRABitmap.Create(tx,ty),true,false);
                  ZoomFitIfTooBig;
                  for i := 0 to high(loadedLayers) do
                  if Assigned(loadedLayers[i].bmp) then
                  begin
                    FImageActions.AddLayerFromBitmap(loadedLayers[i].bmp,ExtractFileName(loadedLayers[i].filename));
                    loadedLayers[i].bmp := nil;
                  end else
                  begin
                    FImageActions.AddLayerFromOriginal(loadedLayers[i].orig,ExtractFileName(loadedLayers[i].filename));
                    loadedLayers[i].orig := nil;
                  end;
                end;
              except on ex:exception do
                begin
                  MessagePopupHide;
                  topmost := LazPaintInstance.HideTopmost;
                  LazPaintInstance.ShowError(rsOpenMultipleImageFiles,ex.Message);
                  LazPaintInstance.ShowTopmost(topmost);
                end;
              end;
              MessagePopupHide;
              if Length(Errors)>0 then
              begin
                topmost := LazPaintInstance.HideTopmost;
                QuestionDlg (rsError,rsFollowingErrorsOccured+ LineEnding+ Errors, mtError,[11,rsOkay],'');
                LazPaintInstance.ShowTopmost(topmost);
              end;
              for i := 0 to high(loadedLayers) do
              begin
                FreeAndNil(loadedLayers[i].bmp);
                FreeAndNil(loadedLayers[i].orig);
              end;
          end;  //OpenFilesAsLayers
       mrLast+2: begin
             if not LazPaintInstance.ImageListWindowVisible then
                LazPaintInstance.ImageListWindowVisible := true;
             LazPaintInstance.UpdateWindows;
             LazPaintInstance.AddToImageList(FileNames);
           end;
       mrLast+3: begin
           if Image.IsFileModified then
             case LazPaintInstance.SaveQuestion(rsOpen) of
                IDYES: Scripting.CallScriptFunction('FileSave');
                IDCANCEL: exit;
             end; //case
             TryOpenFileUTF8(FileNames[0]);
           end;
       end; //case
     end; //else
end;

procedure TFMain.FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if ToolManager.ToolKeyUp(Key) then
  begin
    DelayedPaintPicture := True;
  end else
  If Key = VK_SPACE then
  begin
    spacePressed:= false;
    if ToolManager.ToolSleeping and not spacePressed and not btnRightDown and not btnLeftDown then
      ToolManager.ToolWakeUp;
    Key := 0;
  end;
end;

procedure TFMain.FormMouseEnter(Sender: TObject);
begin
  Image.PrepareForRendering;
end;

procedure TFMain.FormUTF8KeyPress(Sender: TObject; var UTF8Key: TUTF8Char);
var selectedTool: TPaintToolType;
  toolProcessKey: boolean;
begin
  try
    if Zoom.EditingZoom then exit;
    toolProcessKey:= true;
    if (CurrentTool = ptText) and ((UTF8Key = #8) or ((length(UTF8Key)=1) and (UTF8Key[1] in['0'..'9']))) then
    begin
      if TextSpinEditFocused then
         toolProcessKey:= false;
    end;
    if toolProcessKey and ToolManager.ToolKeyPress(UTF8Key) then
    begin
      DelayedPaintPicture := true;
    end else
    if UTF8Key <> '' then
    begin
      if UTF8UpperCase(UTF8Key) = 'X' then
      begin
        SwitchColors;
        UTF8Key:= '';
      end else
      if UTF8Key = '+' then
      begin
         ViewZoomIn.Execute;
         UTF8Key := '';
      end else
      if UTF8Key = '-' then
      begin
         ViewZoomOut.Execute;
         UTF8Key := '';
      end else
      begin
        selectedTool := ToolManager.GetCurrentToolType;
        FLayout.Menu.CycleTool(selectedTool, UTF8Key);
        if selectedTool <> ToolManager.GetCurrentToolType then ChooseTool(selectedTool);
      end;
    end;
  except
    on ex:exception do
      LazPaintInstance.ShowError('KeyPress',ex.Message);
  end;
end;

procedure TFMain.FormMouseLeave(Sender: TObject);
begin
  Cursor := crDefault;
end;

procedure TFMain.FormWindowStateChange(Sender: TObject);
begin
  {$IFDEF LINUX}
  if not FTopMostHiddenMinimised.defined and
    (self.WindowState = wsMinimized) then
  begin
    FTopMostHiddenMinimised := LazPaintInstance.HideTopmost;
  end else
  if FTopMostHiddenMinimised.defined and not (self.WindowState = wsMinimized) then
  begin
    LazPaintInstance.ShowTopmost(FTopMostHiddenMinimised);
    FTopMostHiddenMinimised.defined := false;
  end;
  {$ENDIF}
end;

procedure TFMain.ImageCropLayerUpdate(Sender: TObject);
begin
  ImageCropLayer.Enabled := not image.SelectionMaskEmpty;
  ImageCropLayer.Visible := (image.NbLayers > 1);
end;

procedure TFMain.ImageFlattenExecute(Sender: TObject);
begin
  if ToolManager.ToolSleeping then exit;
  ChooseTool(ptHand);
  image.Flatten;
end;

procedure TFMain.ImageFlattenUpdate(Sender: TObject);
begin
  ImageFlatten.Enabled := Image.NbLayers > 1;
end;

procedure TFMain.LayerAddNewUpdate(Sender: TObject);
begin
  LayerAddNew.Enabled := LazPaintInstance.Image.NbLayers < MaxLayersToAdd;
end;

procedure TFMain.LayerDuplicateUpdate(Sender: TObject);
begin
  LayerDuplicate.Enabled := LazPaintInstance.Image.NbLayers < MaxLayersToAdd;
end;

procedure TFMain.LayerFromFileExecute(Sender: TObject);
var i: integer;
    topmostInfo: TTopMostInfo;
    layerLoaded:boolean;
    chosenFiles: array of string;
    loadedImage: TBGRABitmap;
begin
  if not image.SelectionLayerIsEmpty then
  begin
    LazPaintInstance.ShowMessage(rsLazPaint,rsMustReleaseSelection);
    exit;
  end;
  topmostInfo := LazPaintInstance.HideTopmost;
  chosenFiles := nil;
  loadedImage := nil;
  if UseImageBrowser then
  begin
    if not assigned(FBrowseImages) then
    begin
      FBrowseImages := TFBrowseImages.Create(self);
      FBrowseImages.LazPaintInstance := LazPaintInstance;
      FBrowseImages.ShowRememberStartupDirectory := true;
    end;
    self.Hide;
    FBrowseImages.InitialDirectory:= FLoadInitialDir;
    FBrowseImages.AllowMultiSelect := true;
    FBrowseImages.OpenLayerIcon := true;
    try
      if FBrowseImages.ShowModal = mrOK then
      begin
        setlength(chosenFiles, FBrowseImages.SelectedFileCount);
        for i := 0 to high(chosenFiles) do
          chosenFiles[i] := FBrowseImages.SelectedFile[i];
        loadedImage := FBrowseImages.GetChosenImage.bmp;
      end;
    except
      on ex: Exception do
      begin
        LazPaintInstance.ShowError('LayerFromFile',ex.Message);
      end;
    end;
    FBrowseImages.OpenLayerIcon := false;
    FBrowseImages.AllowMultiSelect := false;
    self.Show;
  end else
  begin
    OpenPictureDialog1.InitialDir:= FLoadInitialDir;
    OpenPictureDialog1.Options := OpenPictureDialog1.Options + [ofAllowMultiSelect];
    layerLoaded := false;
    if OpenPictureDialog1.Execute then
    begin
      setlength(chosenFiles, OpenPictureDialog1.Files.Count);
      for i := 0 to OpenPictureDialog1.Files.Count-1 do
        chosenFiles[i] := OpenPictureDialog1.Files[i];
    end;
    OpenPictureDialog1.Options := OpenPictureDialog1.Options - [ofAllowMultiSelect];
  end;
  if chosenFiles <> nil then
  begin
    if Assigned(loadedImage) and (length(chosenFiles)=1) then
    begin
      layerLoaded := FImageActions.TryAddLayerFromFile(chosenFiles[0], loadedImage);
    end else
    begin
      FreeAndNil(loadedImage);
      for i := 0 to high(chosenFiles) do
        begin
          if FImageActions.TryAddLayerFromFile(chosenFiles[i]) then
            layerLoaded := true;
        end;
    end;
    FLoadInitialDir:= ExtractFilePath(chosenFiles[0]);
    if Config.DefaultRememberStartupSourceDirectory then
      Config.SetStartupSourceDirectory(FLoadInitialDir);
  end;

  LazPaintInstance.ShowTopmost(topmostInfo);
  if layerLoaded and not LazPaintInstance.LayerWindowVisible then
    LazPaintInstance.LayerWindowVisible := true;
end;

procedure TFMain.LayerMergeOverUpdate(Sender: TObject);
begin
  LayerMergeOver.Enabled := (image.CurrentLayerIndex > 0) and Image.CurrentLayerVisible;
end;

procedure TFMain.LayerMoveExecute(Sender: TObject);
begin
  ChooseTool(ptMoveLayer);
end;

procedure TFMain.LayerMoveUpdate(Sender: TObject);
begin
  LayerMove.Enabled := Image.CurrentLayerVisible and Image.SelectionMaskEmpty;
end;

procedure TFMain.LayerRemoveCurrentUpdate(Sender: TObject);
begin
  LayerRemoveCurrent.Enabled := LazPaintInstance.Image.NbLayers > 1;
end;

procedure TFMain.LayerRotateExecute(Sender: TObject);
begin
  ChooseTool(ptRotateLayer);
end;

procedure TFMain.LayerRotateUpdate(Sender: TObject);
begin
  LayerRotate.Enabled := Image.CurrentLayerVisible and Image.SelectionMaskEmpty;
end;

procedure TFMain.ItemDonateClick(Sender: TObject);
begin
  LazPaintInstance.Donate;
end;

procedure TFMain.PaintBox_PictureMouseEnter(Sender: TObject);
begin
  FormMouseEnter(Sender);
end;

procedure TFMain.PaintBox_PictureMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  FormMouseDown(Sender,Button,Shift,X+PaintBox_Picture.Left,Y+PaintBox_Picture.Top);
end;

procedure TFMain.PaintBox_PictureMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  FormMouseMove(Sender,Shift,X+PaintBox_Picture.Left,Y+PaintBox_Picture.Top);
end;

procedure TFMain.PaintBox_PictureMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FormMouseUp(Sender,Button,Shift,X+PaintBox_Picture.Left,Y+PaintBox_Picture.Top);
end;

procedure TFMain.PaintBox_PictureMouseWheel(Sender: TObject;
  Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint;
  var Handled: Boolean);
begin
  FormMouseWheel(Sender,Shift,WheelDelta,Point(MousePos.X+PaintBox_Picture.Left,MousePos.Y+PaintBox_Picture.Top),Handled);
end;

procedure TFMain.PaintBox_PicturePaint(Sender: TObject);
begin
  {$IFDEF USEPAINTBOXPICTURE}
    OnPaintHandler;
  {$ENDIF}
end;

procedure TFMain.FormCloseQuery(Sender: TObject; var CanClose: boolean);
var topmostInfo: TTopMostInfo;
begin
  if ToolManager.ToolSleeping then
  begin
    CanClose := false;
    exit;
  end;
  if CurrentTool in [ptDeformation,ptLayerMapping,ptTextureMapping] then
    ChooseTool(ptHand)
  else
    if not Image.CheckNoAction then
    begin
      CanClose := false;
      exit;
    end;
  if not LazPaintInstance.Embedded and image.IsFileModified and not image.Empty then
  begin
    topmostInfo:= LazPaintInstance.HideTopmost;

    case LazPaintInstance.SaveQuestion(rsExitRequest) of
    IDYES: FileSave.Execute;
    IDNO: ;
    IDCANCEL: begin
                CanClose := false;
                LazPaintInstance.CancelRestart;
                LazPaintInstance.ShowTopmost(topmostInfo);
              end;
    end;
  end else
  if LazPaintInstance.Embedded and (LazPaintInstance.EmbeddedResult = mrNone) and
    ((LazPaintInstance.EmbeddedImageBackup <> nil) or not image.Empty) and (not image.FlatImageEquals(LazPaintInstance.EmbeddedImageBackup)) then
  begin
    topmostInfo := LazPaintInstance.HideTopmost;
    case MessageDlg(rsCloseRequest,rsKeepChanges,mtConfirmation,mbYesNoCancel,0) of
    IDYES: LazPaintInstance.EmbeddedResult := mrOk;
    IDNO: LazPaintInstance.EmbeddedResult := mrCancel;
    IDCANCEL: begin
                CanClose := false;
                LazPaintInstance.CancelRestart;
                LazPaintInstance.ShowTopmost(topmostInfo);
              end;
    end;
  end;
end;

procedure TFMain.FormHide(Sender: TObject);
begin
  shouldArrangeOnResize := false;
  FTopMostInfo := LazPaintInstance.HideTopmost;
  LazPaintInstance.SaveMainWindowPosition;
end;

procedure TFMain.FormMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
  if not Assigned(FImageView) then exit;
  Zoom.SetPosition(FImageView.FormToBitmap(MousePos.X,MousePos.Y), MousePos);
  if WheelDelta > 0 then Zoom.ZoomIn(ssCtrl in Shift) else
  if WheelDelta < 0 then Zoom.ZoomOut(ssCtrl in Shift);
  Zoom.ClearPosition;
  Handled := True;
end;

procedure TFMain.HelpAboutExecute(Sender: TObject);
begin
  LazPaintInstance.ShowAboutDlg;
end;

procedure TFMain.HelpIndexExecute(Sender: TObject);
begin
  OpenURL('http://wiki.lazarus.freepascal.org/LazPaint');
end;

procedure TFMain.ImageChangeCanvasSizeExecute(Sender: TObject);
begin
  LazPaintInstance.ShowCanvasSizeDlg;
end;

procedure TFMain.ImageCropUpdate(Sender: TObject);
begin
  ImageCrop.Enabled := not image.SelectionMaskEmpty;
end;

procedure TFMain.ImageRepeatExecute(Sender: TObject);
begin
  LazPaintInstance.ShowRepeatImageDlg;
end;

procedure TFMain.MenuFileClick(Sender: TObject);

  procedure EmptyMenu(AMenu: TMenuItem);
  var
    i: integer;
    item: TMenuItem;
  begin
    for i := AMenu.Count-1 downto 0 do
    begin
      item := AMenu.Items[i];
      AMenu.Delete(i);
      item.Free;
    end;
  end;

var
  i: integer;
  item: TMenuItem;
  currentLanguage: string;

begin
     EmptyMenu(MenuRecentFiles);
     for i := 0 to Config.RecentFilesCount-1 do
     if Config.RecentFile[i]<>Image.CurrentFilenameUTF8 then
     begin
       item := NewItem(Config.RecentFile[i],0,false,true,@RecentFileClick,0,'');
       MenuRecentFiles.Add(item);
     end;
     MenuRecentFiles.Enabled := MenuRecentFiles.Count <> 0;

     EmptyMenu(MenuLanguage);
     currentLanguage := Config.DefaultLangage;
     for i := 0 to Config.Languages.Count-1 do
     begin
       item := NewItem(Config.Languages[i],0,false,true,@LanguageClick,0,'');
       if currentLanguage = item.Caption then
         item.Checked := true;
       MenuLanguage.Add(item);
     end;
     MenuLanguage.Enabled := MenuLanguage.Count <> 0;
end;

procedure TFMain.RecentFileClick(Sender: TObject);
var openParams: TVariableSet;
begin
  if Sender is TMenuItem then
  begin
    openParams := TVariableSet.Create('FileOpen');
    openParams.AddString('FileName',(sender as TMenuItem).Caption);
    Scripting.CallScriptFunction(openParams);
    openParams.Free;
  end;
end;

procedure TFMain.LanguageClick(Sender: TObject);
var language: string;
begin
  if Sender is TMenuItem then
  begin
    language := (Sender as TMenuItem).Caption;
    if Config.DefaultLangage <> language then
    begin
      Config.SetDefaultLangage(language);
      LazPaintInstance.Restart;
    end;
  end;
end;

procedure TFMain.TimerUpdateTimer(Sender: TObject);
begin
  TimerUpdate.Enabled := false;
  EditUndo.Update;
  EditRedo.Update;
  UpdateStatusText;
  if FCoordinatesCaptionCount > 0 then
  begin
    Label_Coordinates.Caption := FCoordinatesCaption;
    Label_Coordinates.Update;
    FCoordinatesCaptionCount := 0;
  end;
  if CanCompressOrUpdateStack and UpdateStackOnTimer then
  begin
    LazPaintInstance.NotifyStackChange;
    UpdateStackOnTimer := false;
  end else
  begin
    if CanCompressOrUpdateStack then image.CompressUndo;
  end;
  if DelayedPaintPicture or ToolManager.ToolUpdateNeeded then
  begin
    if ToolManager.ToolUpdateNeeded then ToolManager.ToolUpdate;
    PaintPictureNow;
  end;
  TimerUpdate.Enabled := true;
end;

procedure TFMain.ToolRotateSelectionUpdate(Sender: TObject);
begin
  ToolRotateSelection.Enabled := not image.SelectionMaskEmpty;
end;

procedure TFMain.ToolLayerMappingUpdate(Sender: TObject);
begin
  ToolLayerMapping.Enabled := Image.CurrentLayerVisible and Image.SelectionMaskEmpty;
end;

procedure TFMain.ToolLoadTextureExecute(Sender: TObject);
begin
  ShowOpenTextureDialog;
end;

procedure TFMain.ToolNoTextureExecute(Sender: TObject);
begin
  try
    ToolManager.SetToolTexture(nil);

    UpdateTextureIcon;
    UpdateEditPicture;

  except
    on ex:Exception do
      LazPaintInstance.ShowError('ToolNoTextureExecute',ex.Message);
  end;
end;

procedure TFMain.ToolNoTextureUpdate(Sender: TObject);
begin
  ToolNoTexture.Enabled := ToolManager.GetToolTexture <> nil;
end;

procedure TFMain.ViewColorsExecute(Sender: TObject);
begin
  ToggleColorsVisible;
end;

procedure TFMain.ViewColorsUpdate(Sender: TObject);
begin
  ViewColors.Checked := LazPaintInstance.ChooseColorVisible;
  ItemViewColors.Checked := ViewColors.Checked;
end;

procedure TFMain.ViewGridUpdate(Sender: TObject);
begin
  ViewGrid.Checked:= LazPaintInstance.GridVisible;
end;

procedure TFMain.ViewImageListExecute(Sender: TObject);
begin
  ToggleImageListVisible;
end;

procedure TFMain.ViewToolboxExecute(Sender: TObject);
begin
  ToggleToolboxVisible;
end;

procedure TFMain.ViewLayerStackButtonUpdate(Sender: TObject);
begin
  ViewLayerStackButton.Checked := LazPaintInstance.LayerWindowVisible;
end;

procedure TFMain.ViewLayerStackExecute(Sender: TObject);
begin
  ToggleLayersVisible;
end;

procedure TFMain.ViewLayerStackUpdate(Sender: TObject);
begin
  ViewLayerStack.Checked := LazPaintInstance.LayerWindowVisible;
end;

procedure TFMain.ViewPaletteExecute(Sender: TObject);
begin
  Layout.PaletteVisible := not Layout.PaletteVisible;
end;

procedure TFMain.ViewPaletteUpdate(Sender: TObject);
begin
  ViewPalette.Checked := Layout.PaletteVisible;
end;

procedure TFMain.ViewStatusBarExecute(Sender: TObject);
begin
  Layout.StatusBarVisible := not Layout.StatusBarVisible;
end;

procedure TFMain.ViewStatusBarUpdate(Sender: TObject);
begin
  ViewStatusBar.Checked := Layout.StatusBarVisible;
end;

procedure TFMain.ViewToolboxUpdate(Sender: TObject);
begin
  ViewToolBox.Checked := LazPaintInstance.ToolboxVisible;
end;

procedure TFMain.ViewImagelistUpdate(Sender: TObject);
begin
  ViewImageList.Checked := LazPaintInstance.ImageListWindowVisible;
end;

function TFMain.ScriptEditPasteAsNew(AVars: TVariableSet): TScriptResult;
var bmp: TBGRABitmap;
begin
  if ToolManager.ToolSleeping then
  begin
    result := srException;
    exit;
  end;
  Cursor := crHourGlass;
  try
    bmp := GetBitmapFromClipboard;
    Cursor := crDefault;
    if bmp <> nil then
    begin
      if bmp.NbPixels > 0 then
      begin
        ChooseTool(ptHand);
        if Image.IsFileModified then
        begin
          case LazPaintInstance.SaveQuestion(rsNewImage) of
          IDYES: scripting.CallScriptFunction('FileSave');
          IDCANCEL: begin
              bmp.Free;
              result := srCancelledByUser;
              exit;
            end;
          end;
        end;
        image.Assign(bmp,true,false);
        Image.CurrentFilenameUTF8 := '';
        image.SetSavedFlag;
        result := srOk;
      end
       else
       begin
         bmp.Free;
         result := srException;
       end;
    end else
      result := srException;
  except on ex:exception do
    begin
      Cursor := crDefault;
      LazPaintInstance.ShowError(rsLazPaint, ex.Message);
      result := srException;
    end;
  end;
end;

function TFMain.ChooseTool(Tool: TPaintToolType): boolean;
var params: TVariableSet;
begin
  params := TVariableSet.Create('ChooseTool');
  params.AddString('Name', PaintToolTypeStr[Tool]);
  result := Scripting.CallScriptFunction(params) = srOk;
  params.Free;
end;

procedure TFMain.LayoutPictureAreaChange(ASender: TObject; ANewArea: TRect);
begin
   {$IFDEF USEPAINTBOXPICTURE}
   PaintBox_Picture.SetBounds(ANewArea.Left,ANewArea.Top,ANewArea.Right-ANewArea.Left,ANewArea.Bottom-ANewArea.Top);
   {$ENDIF}
   if Assigned(FImageView) then FImageView.InvalidatePicture(True, ANewArea, Point(0,0), self);
end;

procedure TFMain.ToggleGridVisible;
begin
  LazPaintInstance.GridVisible := not LazPaintInstance.GridVisible;
end;

procedure TFMain.ToggleToolboxVisible;
begin
  LazPaintInstance.ToolboxVisible := not LazPaintInstance.ToolboxVisible;
end;

procedure TFMain.ToggleImageListVisible;
begin
  LazPaintInstance.ImageListWindowVisible := not LazPaintInstance.ImageListWindowVisible;
end;

procedure TFMain.ToggleColorsVisible;
begin
  LazPaintInstance.ChooseColorVisible := not LazPaintInstance.ChooseColorVisible;
end;

procedure TFMain.ToggleLayersVisible;
begin
  LazPaintInstance.LayerWindowVisible := not LazPaintInstance.LayerWindowVisible;
end;

procedure TFMain.ToggleToolwindowsVisible;
var wantedState: boolean;
begin
  if LazPaintInstance.ToolboxVisible or LazPaintInstance.ChooseColorVisible or LazPaintInstance.LayerWindowVisible then
    wantedState := false
  else
    wantedState := true;
  if LazPaintInstance.ToolboxVisible <> wantedState then ToggleToolboxVisible;
  if LazPaintInstance.ChooseColorVisible <> wantedState then ToggleColorsVisible;
  if LazPaintInstance.LayerWindowVisible <> wantedState then ToggleLayersVisible;
end;

function TFMain.ScriptChooseTool(AVars: TVariableSet): TScriptResult;
var toolName: string;
  Tool: TPaintToolType;
  topmostInfo: TTopMostInfo;
  useSelection: boolean;
  newTexture: TBGRABitmap;
  res: TQuestionResult;
begin
  if ToolManager.ToolSleeping then exit;
  toolName := AVars.Strings['Name'];
  Tool := StrToPaintToolType(toolName);
  if CompareText(PaintToolTypeStr[Tool],toolName)=0 then
  begin
    result := srOk;
    if Tool = ToolManager.GetCurrentToolType then
    begin
      ToolManager.ToolOpen;
      exit;
    end;
    try
      if not ((Tool in [ptMoveSelection,ptRotateSelection]) and
        (CurrentTool in [ptMoveSelection,ptRotateSelection])) then
        ToolManager.ToolCloseDontReopen;
      if self.Visible then
      begin
        case Tool of
          ptTextureMapping:
          begin
            useSelection:= false;
            newTexture := nil;
            if not image.SelectionMaskEmpty and not image.SelectionLayerIsEmpty then
            begin
              topmostInfo := LazPaintInstance.HideTopmost;
              if Config.DefaultTransformSelectionAnswer <> mrNone then
                res := QuestionResult(Config.DefaultTransformSelectionAnswer)
              else
              begin
                res := ShowQuestionDialog(rsTextureMapping,rsTransformSelectionContent,[mbYes,mbNo],true);
                if res.Remember and (res.ButtonResult in [mrYes,mrNo]) then
                  Config.SetDefaultTransformSelectionAnswer(res.ButtonResult);
              end;
              LazPaintInstance.ShowTopmost(topmostInfo);
              case res.ButtonResult of
                mrYes: begin
                  useSelection:= true;
                  if image.SelectionLayerReadonly <> nil then
                  begin
                    newTexture := image.SelectionLayerReadonly.Duplicate as TBGRABitmap;
                    newTexture.ApplyMask(image.SelectionMaskReadonly, image.SelectionLayerBounds);
                    if newTexture.Empty then
                    begin
                      newTexture.Free;
                      MessagePopup(rsNothingToBeRetrieved,2000);
                    end
                    else
                    begin
                      FImageActions.RemoveSelection;
                      BGRAReplace(newTexture, newTexture.GetPart(newTexture.GetImageBounds));
                      ToolManager.SetToolTexture(newTexture);
                      newTexture.FreeReference;
                      UpdateTextureIcon;
                    end;
                  end;
                end;
              end;
            end;
            if (ToolManager.GetToolTexture = nil) or ToolManager.GetToolTexture.Empty then
            begin
              if useSelection then
              begin
                Tool := ptHand;
                result := srException;
              end else
              if not ShowOpenTextureDialog then
              begin
                Tool := ptHand;
                result := srCancelledByUser;
              end
              else
              if (ToolManager.GetToolTexture = nil) or ToolManager.GetToolTexture.Empty then
              begin
                Tool := ptHand;
                result := srException;
              end;
            end;
          end;
          ptLayerMapping:
          begin
            EditDeselect.Execute;
            if image.CurrentLayerEmpty then
            begin
              MessagePopup(rsEmptyLayer,2000);
              Tool := ptHand;
              result := srException;
            end;
          end;
          ptMoveLayer, ptRotateLayer, ptZoomLayer:
          begin
            if image.CurrentLayerEquals(BGRAPixelTransparent) then
            begin
              MessagePopup(rsLazPaint, 4000);
              Tool := ptHand;
              result := srException;
            end;
          end;
          ptDeformation:
          begin
            if (image.SelectionMaskEmpty and image.CurrentLayerEquals(image.CurrentLayerPixel[0,0])) or
               (not image.SelectionMaskEmpty and image.SelectionLayerIsEmpty) then
            begin
              LazPaintInstance.ShowMessage(rsLazPaint, rsNothingToBeDeformed);
              Tool := ptHand;
              result := srException;
            end;
          end;
          ptMoveSelection,ptRotateSelection:
          begin
            if not ToolManager.SetCurrentToolType(Tool) then
            begin
              result := srException;
              exit;
            end;
            if image.CurrentLayerVisible and not image.SelectionMaskEmpty and image.SelectionLayerIsEmpty and not image.CurrentLayerEmpty then
            begin
              topmostInfo := LazPaintInstance.HideTopmost;
              if Config.DefaultRetrieveSelectionAnswer <> mrNone then
                res := QuestionResult(Config.DefaultRetrieveSelectionAnswer)
              else
              begin
                res := ShowQuestionDialog(rsMovingOrRotatingSelection,rsRetrieveSelectedArea,[mbYes,mbNo],true);
                if res.Remember and (res.ButtonResult in [mrYes,mrNo]) then
                  Config.SetDefaultRetrieveSelectionAnswer(res.ButtonResult);
              end;
              LazPaintInstance.ShowTopmost(topmostInfo);
              case res.ButtonResult of
                mrYes: FImageActions.RetrieveSelection;
              end;
            end;
          end;
        end;
      end;
      ToolManager.SetCurrentToolType(Tool);
      if Assigned(FImageView) then
        FImageView.FillSelectionHighlight := ToolManager.DisplayFilledSelection and not FShowSelectionNormal;
    except
      on ex:Exception do
      begin
        LazPaintInstance.ShowError('ChooseTool',ex.Message);
        result := srException;
      end;
    end;
  end else
    result := srInvalidParameters;
end;

function TFMain.ScriptViewZoomIn(AVars: TVariableSet): TScriptResult;
begin
  Zoom.ZoomIn;
  result := srOk;
end;

function TFMain.ScriptViewZoomOut(AVars: TVariableSet): TScriptResult;
begin
  Zoom.ZoomOut;
  result := srOk;
end;

function TFMain.ScriptViewZoomOriginal(AVars: TVariableSet): TScriptResult;
begin
  Zoom.ZoomOriginal;
  result := srOk;
end;

function TFMain.ScriptViewZoomFit(AVars: TVariableSet): TScriptResult;
begin
  Image.ZoomFit;
  result := srOk;
end;

function TFMain.ScriptViewGrid(AVars: TVariableSet): TScriptResult;
begin
  if AVars.IsDefined('Visible') then
  begin
    if LazPaintInstance.GridVisible <> AVars.Booleans['Visible'] then
      ToggleGridVisible;
  end else
    ToggleGridVisible;
  result := srOk;
end;

procedure TFMain.BrushCreateGeometricExecute(Sender: TObject);
var b: TLazPaintBrush;
begin
  b := ShowGeometricBrushDialog(LazPaintInstance);
  if Assigned(b) then
  begin
    ToolManager.AddBrush(b);
    UpdateBrush;
  end;
end;

procedure TFMain.BrushCreateGeometricUpdate(Sender: TObject);
begin
  BrushCreateGeometric.Enabled := ToolManager.ToolBrushCount < 9;
end;

procedure TFMain.EditSelectionUpdate(Sender: TObject);
begin
  EditSelection.Enabled := not Scripting.Recording;
end;

procedure TFMain.FileChooseEntryExecute(Sender: TObject);
var
  openParams: TVariableSet;
begin
  openParams := TVariableSet.Create('FileOpen');
  openParams.AddString('FileName',Image.currentFilenameUTF8);
  Scripting.CallScriptFunction(openParams);
  openParams.Free;
end;

procedure TFMain.FileChooseEntryUpdate(Sender: TObject);
begin
  FileChooseEntry.Enabled := Image.IsIconCursor or Image.IsTiff or Image.IsGif;
end;

procedure TFMain.EditCopyExecute(Sender: TObject);
begin
  if not ToolManager.ToolCopy then
    Scripting.CallScriptFunction('EditCopy');
end;

procedure TFMain.EditCopyUpdate(Sender: TObject);
begin
  EditCopy.Enabled := ToolManager.ToolProvideCopy or not image.SelectionMaskEmpty;
end;

procedure TFMain.EditCutExecute(Sender: TObject);
begin
  if not ToolManager.ToolCut then
    Scripting.CallScriptFunction('EditCut');
end;

procedure TFMain.EditCutUpdate(Sender: TObject);
begin
  EditCut.Enabled := ToolManager.ToolProvideCut or not image.SelectionMaskEmpty;
end;

procedure TFMain.EditDeleteSelectionUpdate(Sender: TObject);
begin
  EditDeleteSelection.Enabled := not image.SelectionMaskEmpty;
end;

procedure TFMain.EditPasteExecute(Sender: TObject);
begin
  if not ToolManager.ToolPaste then
    Scripting.CallScriptFunction('EditPaste');
end;

procedure TFMain.FileImport3DUpdate(Sender: TObject);
begin
  FileImport3d.Enabled := not Scripting.Recording
end;

procedure TFMain.FilePrintExecute(Sender: TObject);
begin
  LazPaintInstance.ShowPrintDlg;
end;

procedure TFMain.FileRememberSaveFormatExecute(Sender: TObject);
begin
  FileRememberSaveFormat.Checked := not FileRememberSaveFormat.Checked;
  Config.SetRememberSaveFormat(FileRememberSaveFormat.Checked);
end;

procedure TFMain.FileSaveAsInSameFolderExecute(Sender: TObject);
var dir: string;
begin
  dir := ExtractFilePath(Image.CurrentFilenameUTF8);
  if dir <> '' then FSaveInitialDir := dir;
  Scripting.CallScriptFunction('FileSaveAs');
end;

procedure TFMain.FileSaveAsInSameFolderUpdate(Sender: TObject);
begin
  FileSaveAsInSameFolder.Enabled := ExtractFilePath(Image.CurrentFilenameUTF8)<>'';
end;

procedure TFMain.FileUseImageBrowserExecute(Sender: TObject);
begin
  Config.SetDefaultUseImageBrowser(not UseImageBrowser);
end;

procedure TFMain.FileUseImageBrowserUpdate(Sender: TObject);
begin
  FileUseImageBrowser.Checked := UseImageBrowser;
end;

procedure TFMain.ForgetDialogAnswersExecute(Sender: TObject);
begin
  Config.SetDefaultTransformSelectionAnswer(0);
  Config.SetDefaultRetrieveSelectionAnswer(0);
end;

procedure TFMain.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  Image.OnCurrentFilenameChanged := nil;
  Image.OnImageChanged.RemoveObserver(@OnImageChangedHandler);
  Image.OnQueryExitToolHandler := nil;
  Image.Zoom := nil;
end;

procedure TFMain.ItemDockLayersAndColorsClick(Sender: TObject);
begin
  LazPaintInstance.DockLayersAndColors := not LazPaintInstance.DockLayersAndColors;
end;

procedure TFMain.ItemFullscreenClick(Sender: TObject);
begin
  LazPaintInstance.Fullscreen := not LazPaintInstance.Fullscreen;
end;

procedure TFMain.ItemViewDockToolboxClick(Sender: TObject);
begin
  if Layout.ToolBoxDocking in[twWindow,twNone] then
    Layout.ToolBoxDocking := twLeft
  else
    Layout.ToolBoxDocking := twWindow;
end;

procedure TFMain.LayerZoomExecute(Sender: TObject);
begin
  ChooseTool(ptZoomLayer);
end;

procedure TFMain.MenuCoordinatesToolbarClick(Sender: TObject);
begin
  Panel_Coordinates.Visible := not Panel_Coordinates.Visible;
  Config.SetDefaultCoordinatesToolbarVisible(Panel_Coordinates.Visible);
  Layout.Arrange;
end;

procedure TFMain.MenuCopyPasteToolbarClick(Sender: TObject);
begin
  Panel_CopyPaste.Visible := not Panel_CopyPaste.Visible;
  Config.SetDefaultCopyPasteToolbarVisible(Panel_CopyPaste.Visible);
  Layout.Arrange;
end;

procedure TFMain.MenuDockToolboxLeftClick(Sender: TObject);
begin
  Layout.ToolBoxDocking := twLeft;
end;

procedure TFMain.MenuDockToolboxRightClick(Sender: TObject);
begin
  Layout.ToolBoxDocking := twRight;
end;

procedure TFMain.ItemIconSize16Click(Sender: TObject);
begin
  LazPaintInstance.ChangeIconSize(16);
end;

procedure TFMain.ItemIconSize24Click(Sender: TObject);
begin
  LazPaintInstance.ChangeIconSize(24);
end;

procedure TFMain.ItemIconSize32Click(Sender: TObject);
begin
  LazPaintInstance.ChangeIconSize(32);
end;

procedure TFMain.ItemIconSize48Click(Sender: TObject);
begin
  LazPaintInstance.ChangeIconSize(48);
end;

procedure TFMain.ItemIconSize64Click(Sender: TObject);
begin
  LazPaintInstance.ChangeIconSize(64);
end;

procedure TFMain.ItemIconSizeAutoClick(Sender: TObject);
begin
  LazPaintInstance.ChangeIconSize(0);
end;

procedure TFMain.MenuIconSizeClick(Sender: TObject);
var iconSize: integer;
begin
  iconSize := Config.DefaultIconSize(0);
  ItemIconSize16.Checked := iconSize=16;
  ItemIconSize24.Checked := iconSize=24;
  ItemIconSize32.Checked := iconSize=32;
  ItemIconSize48.Checked := iconSize=48;
  ItemIconSize64.Checked := iconSize=64;
  ItemIconSizeAuto.Checked := iconSize=0;
end;

procedure TFMain.MenuShowPaletteClick(Sender: TObject);
begin
  Layout.PaletteVisible := not Layout.PaletteVisible;
end;

procedure TFMain.MenuUndockToolboxClick(Sender: TObject);
begin
  Layout.ToolBoxDocking := twWindow;
end;

procedure TFMain.MenuUndoRedoToolbarClick(Sender: TObject);
begin
  Panel_Undo.Visible := not Panel_Undo.Visible;
  Config.SetDefaultUndoRedoToolbarVisible(Panel_Undo.Visible);
  Layout.Arrange;
end;

procedure TFMain.MenuViewClick(Sender: TObject);
begin
  ItemViewDockToolbox.Checked := (Layout.ToolBoxDocking <> twWindow) and (Layout.ToolBoxDocking <> twNone);
  ItemDockLayersAndColors.Checked := LazPaintInstance.DockLayersAndColors;
  ItemFullscreen.Checked := LazPaintInstance.Fullscreen;
  {$IFDEF LINUX}
  ItemFullscreen.Visible := false;
  {$ENDIF}
end;

procedure TFMain.MenuZoomToolbarClick(Sender: TObject);
begin
  Panel_Zoom.Visible := not Panel_Zoom.Visible;
  Config.SetDefaultZoomToolbarVisible(Panel_Zoom.Visible);
  Layout.Arrange;
end;

procedure TFMain.EditPasteUpdate(Sender: TObject);
begin
  EditPaste.Enabled := ToolManager.ToolProvidePaste or Image.CurrentLayerVisible;
end;

procedure TFMain.EditDeselectUpdate(Sender: TObject);
begin
  EditDeselect.Enabled := not image.SelectionMaskEmpty;
  if image.SelectionMaskEmpty then FSaveSelectionInitialFilename := '';
end;

procedure TFMain.EditRedoUpdate(Sender: TObject);
begin
  EditRedo.Enabled := image.CanRedo;
end;

procedure TFMain.EditSelectionExecute(Sender: TObject);
begin
  LazPaintInstance.EditSelection;
end;

procedure TFMain.ScriptExecute(Sender: TObject);
var actionName: string;
begin
  if Sender is TAction then
  begin
    actionName := (Sender as TAction).Name;
    CallScriptFunction(actionName);
  end;
end;

procedure TFMain.AskMergeSelection(ACaption: string);
var topmostInfo: TTopMostInfo; res: integer;
begin
  if not image.SelectionMaskEmpty and not image.SelectionLayerIsEmpty then
  begin
    topmostInfo:= LazPaintInstance.HideTopmost;
    res := MessageDlg(ACaption,rsMergeSelection,mtConfirmation,[mbYes,mbNo],0);
    LazPaintInstance.ShowTopmost(topmostInfo);
    case res of
      mrYes: EditDeselect.Execute;
    end;
  end;
end;

procedure TFMain.ReleaseMouseButtons(Shift: TShiftState);
begin
  if not (ssLeft in Shift) and btnLeftDown then
  begin
    btnLeftDown := false;
    if ToolManager.ToolUp then PaintPictureNow;
  end;
  if not (ssRight in Shift) and btnRightDown then
  begin
    btnRightDown := false;
    if ToolManager.ToolUp then PaintPictureNow;
  end;
  if not btnLeftDown and not btnRightDown then
  begin
    CanCompressOrUpdateStack := true;
    Image.OnImageChanged.DelayedStackUpdate := False;
  end;
end;

function TFMain.ShowOpenTextureDialog: boolean;
var newTex: TBGRABitmap;
  texFilename: string;
  topMostInfo: TTopMostInfo;
begin
  result := false;
  newTex := nil;
  topMostInfo := LazPaintInstance.HideTopmost;
  try
    texFilename := '';
    if UseImageBrowser then
    begin
      if not assigned(FBrowseTextures) then
      begin
        FBrowseTextures := TFBrowseImages.Create(self);
        FBrowseTextures.LazPaintInstance := LazPaintInstance;
        FBrowseTextures.AllowMultiSelect := false;
        FBrowseTextures.Caption := OpenTextureDialog.Title;
      end;
      self.Hide;
      try
        FBrowseTextures.InitialDirectory := Config.DefaultTextureDirectory;
        if FBrowseTextures.ShowModal = mrOK then
        begin
          texFilename := FBrowseTextures.Filename;
          newTex := FBrowseTextures.GetChosenImage.bmp;
        end;
      finally
        self.Show;
      end;
    end else
    begin
      OpenTextureDialog.InitialDir := Config.DefaultTextureDirectory;
      if OpenTextureDialog.Execute then
        texFilename:= OpenTextureDialog.FileName;
    end;
    if texFilename <> '' then
    begin
      try
        if not Assigned(newTex) then
          newTex := LoadFlatImageUTF8(texFilename).bmp;
        if LazPaintInstance.BlackAndWhite then
          newTex.InplaceGrayscale;
        ToolManager.SetToolTexture(newTex);
        newTex.FreeReference;
        newTex := nil;
        result := true;
        UpdateTextureIcon;
        UpdateEditPicture;
        Config.SetDefaultTextureDirectory(ExtractFilePath(texFilename));
      except
        on ex:Exception do
          LazPaintInstance.ShowError(rsOpen,ex.Message);
      end;
    end;
  except
    on ex:Exception do
      LazPaintInstance.ShowError('ShowOpenTextureDialog',ex.Message);
  end;
  FreeAndNil(newTex);
  LazPaintInstance.ShowTopmost(topMostInfo);
end;

function TFMain.ShowOpenBrushDialog: boolean;
var newBrushBmp: TBGRABitmap;
  newBrush: TLazPaintBrush;
  brushFilename: string;
  topMostInfo: TTopMostInfo;
begin
  result := false;
  topMostInfo := LazPaintInstance.HideTopmost;
  newBrushBmp := nil;
  try
    brushFilename := '';
    if UseImageBrowser then
    begin
      if not assigned(FBrowseBrushes) then
      begin
        FBrowseBrushes := TFBrowseImages.Create(self);
        FBrowseBrushes.LazPaintInstance := LazPaintInstance;
        FBrowseBrushes.AllowMultiSelect := false;
        FBrowseBrushes.Caption := OpenBrushDialog.Title;
      end;
      self.Hide;
      try
        FBrowseBrushes.InitialDirectory := Config.DefaultBrushDirectory;
        if FBrowseBrushes.ShowModal = mrOK then
        begin
          brushFilename := FBrowseBrushes.Filename;
          newBrushBmp := FBrowseBrushes.GetChosenImage.bmp;
        end;
      finally
        self.Show;
      end;
    end else
    begin
      OpenBrushDialog.InitialDir := Config.DefaultTextureDirectory;
      if OpenBrushDialog.Execute then
        brushFilename:= OpenBrushDialog.FileName;
    end;
    if brushFilename <> '' then
    begin
      try
        if not assigned(newBrushBmp) then
          newBrushBmp := LoadFlatImageUTF8(brushFilename).bmp;
        newBrush := TLazPaintBrush.Create;
        newBrush.AssignBrushImage(newBrushBmp);
        FreeAndNil(newBrushBmp);
        ToolManager.AddBrush(newBrush);
        result := true;
        UpdateBrush;
        Config.SetDefaultBrushDirectory(ExtractFilePath(brushFilename));
      except
        on ex:Exception do
          LazPaintInstance.ShowError(rsOpen,ex.Message);
      end;
    end;
  except
    on ex:Exception do
      LazPaintInstance.ShowError('ShowOpenBrushDialog',ex.Message);
  end;
  FreeAndNil(newBrushBmp);
  LazPaintInstance.ShowTopmost(topMostInfo);
end;

procedure TFMain.ShowNoPicture;
begin
  InShowNoPicture := true;
  PaintPictureNow;
  InShowNoPicture:= false;
end;

procedure TFMain.UpdateWindowCaption;
var bppStr: string;
begin
  if Image.IsTiff or Image.IsGif then
  begin
    if Image.FrameIndex = TImageEntry.NewFrameIndex then
      bppStr := ' '+rsNewImage
    else
      bppStr := ' #'+inttostr(Image.FrameIndex+1);
  end else
    if Image.bpp = 0 then
      bppStr := ''
    else
      bppStr := ' '+inttostr(Image.bpp)+'bit';

  if Image.CurrentFilenameUTF8 = '' then
    self.Caption := inttostr(Image.Width)+'x'+inttostr(Image.Height) + bppStr + ' - ' + LazPaintInstance.Title
  else
    self.Caption := inttostr(Image.Width)+'x'+inttostr(Image.Height) + bppStr + ' - ' + image.CurrentFilenameUTF8;
end;

procedure TFMain.ImageCurrentFilenameChanged(sender: TLazPaintImage);
begin
  UpdateWindowCaption;
end;

function TFMain.GetCurrentTool: TPaintToolType;
begin
  result := ToolManager.GetCurrentToolType;
end;

procedure TFMain.OnToolChanged(sender: TToolManager; ANewTool: TPaintToolType);
begin
  if self.Visible then
  begin
    UpdatePanelTextWidth;
    FLayout.Arrange;
    PaintBox_PenPreview.Invalidate;
    Image.OnImageChanged.NotifyObservers;
    UpdateToolImage;
    UpdateToolBar;
  end;
end;

procedure TFMain.OnQueryExitToolHandler(sender: TLazPaintImage);
begin
  if ToolManager.ToolSleeping then exit;
  ChooseTool(ptHand);
end;

procedure TFMain.ZoomFitIfTooBig;
begin
  if Assigned(Zoom) then
  begin
    with FLayout.WorkArea do
      if (image.Width*Zoom.Factor > right-left) or (image.Height*Zoom.Factor > bottom-top) then
        ViewZoomFit.Execute;
  end;
end;

function TFMain.TryOpenFileUTF8(filenameUTF8: string; AddToRecent: Boolean;
     ALoadedImage: PImageEntry; ASkipDialogIfSingleImage: boolean): Boolean;
var
  newPicture: TImageEntry;
  format: TBGRAImageFormat;

  procedure StartImport;
  begin
    ToolManager.ToolCloseDontReopen;
    if (CurrentTool in [ptDeformation,ptRotateSelection,ptMoveSelection,ptTextureMapping,ptLayerMapping])
     or ((CurrentTool = ptHotSpot) and (format <> ifCur)) then
      ChooseTool(ptHand);
    ShowNoPicture;
    Image.OnImageChanged.NotifyObservers;
  end;
  procedure EndImport(BPP: integer = 0; frameIndex: integer = 0);
  begin
    if AddToRecent then
    begin
      Config.AddRecentFile(filenameUTF8);
      Config.AddRecentDirectory(ExtractFilePath(filenameUTF8));
    end;
    Image.CurrentFilenameUTF8 := filenameUTF8;
    image.ClearUndo;
    image.SetSavedFlag(BPP, frameIndex);
    ToolManager.ToolOpen;
    ZoomFitIfTooBig;
    result := true;
  end;
  procedure ImportNewPicture;
  begin
    if (newPicture.bmp <> nil) and (newPicture.bmp.Width > 0) and (newPicture.bmp.Height > 0) then
    begin
      StartImport;
      with ComputeAcceptableImageSize(newPicture.bmp.Width,newPicture.bmp.Height) do
        if (cx < newPicture.bmp.Width) or (cy < newPicture.bmp.Height) then
          BGRAReplace(newPicture.bmp, newPicture.bmp.Resample(cx,cy,rmFineResample));
      image.Assign(newPicture.bmp,True, false);
      newPicture.bmp := nil;
      EndImport(newPicture.bpp, newPicture.frameIndex);
    end else FreeAndNil(newPicture.bmp);
  end;

  procedure ImportSvg;
  var
    layered: TBGRALayeredBitmap;
  begin
    StartImport;
    layered := LoadSVGImageUTF8(filenameUTF8);
    Image.Assign(layered,true, false);
    EndImport;
  end;

begin
  result := false;
  if filenameUTF8 = '' then exit;
  if ToolManager.ToolSleeping then exit;
  if not AbleToLoadUTF8(filenameUTF8) then
  begin
    LazPaintInstance.ShowMessage(rsOpen,rsFileFormatNotRecognized);
    exit;
  end;
  newPicture := TImageEntry.Empty;
  try
    format := Image.DetectImageFormat(filenameUTF8);
    if format = ifSvg then
    begin
      ImportSvg;
    end else
    if Assigned(ALoadedImage) and Assigned(ALoadedImage^.bmp) then
    begin
      newPicture := ALoadedImage^;
      ALoadedImage^.bmp := nil;
      ImportNewPicture;
    end
    else
    if format in[ifIco,ifCur] then
    begin
      newPicture := ShowPreviewDialog(LazPaintInstance, FilenameUTF8, rsIconOrCursor, ASkipDialogIfSingleImage);
      ImportNewPicture;
    end
    else
    if format in[ifIco,ifTiff] then
    begin
      newPicture := ShowPreviewDialog(LazPaintInstance, FilenameUTF8, 'TIFF', ASkipDialogIfSingleImage);
      ImportNewPicture;
    end
    else
    if format = ifGif then
    begin
      newPicture := ShowPreviewDialog(LazPaintInstance, FilenameUTF8, rsAnimatedGIF, ASkipDialogIfSingleImage);
      ImportNewPicture;
    end else
    begin
      StartImport;
      image.LoadFromFileUTF8(filenameUTF8);
      EndImport;
    end;

  except
    on ex: Exception do
    begin
      newPicture.FreeAndNil;
      ToolManager.ToolOpen;
      Image.OnImageChanged.NotifyObservers;
      LazPaintInstance.ShowError(rsOpen,ex.Message);
    end;
  end;
end;

procedure TFMain.ToolMoveSelectionUpdate(Sender: TObject);
begin
  ToolMoveSelection.Enabled := not image.SelectionMaskEmpty;
end;

{****************************** Picture ************************}

procedure TFMain.OnPaintHandler;
begin
  if FirstPaint then
  begin
    LoadToolwindow := True;
    FirstPaint := false;
  end;
  if InFormPaint then exit;
  InFormPaint := true;

  if Assigned(FImageView) then FImageView.DoPaint(PictureCanvasOfs, FLayout.WorkArea, InShowNoPicture);
  DelayedPaintPicture:= false;
  if FActiveSpinEdit <> nil then
  begin
    FActiveSpinEdit.DelayTimer;
    FActiveSpinEdit := nil;
  end;

  InFormPaint := false;
end;

procedure TFMain.OnImageChangedHandler(AEvent: TLazPaintImageObservationEvent);
begin
  if Assigned(FImageView) then
    FImageView.InvalidatePicture(False, FLayout.WorkArea, Point(0,0), self);

  if (image.Width <> FLastWidth) or (image.Height <> FLastHeight)
   or (image.BPP <> FLastBPP) or (image.FrameIndex <> FLastFrameIndex) then
  begin
    FLastWidth:= image.Width;
    FLastHeight:= image.Height;
    FLastBPP := image.BPP;
    FLastFrameIndex:= image.FrameIndex;
    UpdateWindowCaption;
  end;
  if not image.CurrentLayerVisible and not ToolManager.ToolCanBeUsed then
  begin
    ChooseTool(ptHand);
    MessagePopup(rsToolOnInvisibleLayer,5000);
  end;
  if AEvent.DelayedStackUpdate then FUpdateStackWhenIdle := true;
end;

procedure TFMain.UpdateEditPicture(ADelayed: boolean = false);
begin
  if ToolManager.ToolUpdate then
  begin
    if ADelayed then DelayedPaintPicture := True
    else
      PaintPictureNow;
  end;
end;

procedure TFMain.OnZoomChanged(sender: TZoom; ANewZoom: single);
begin
  if Assigned(FImageView) then FImageView.OnZoomChanged(sender, ANewZoom, FLayout.WorkArea);
  UpdateToolbar;
  PaintPictureNow;
end;

procedure TFMain.PaintPictureNow;
begin
  if not visible then exit;
  UpdateStackOnTimer := true;
  Image.OnImageChanged.NotifyObservers;
  {$IFDEF USEPAINTBOXPICTURE}PaintBox_Picture{$ELSE}self{$ENDIF}.Update;
end;

procedure TFMain.FormPaint(Sender: TObject);
begin
  {$IFNDEF USEPAINTBOXPICTURE}
  OnPaintHandler;
  {$ENDIF}
end;

procedure TFMain.PictureSelectedLayerIndexChanged(sender: TLazPaintImage);
begin
  if not image.CurrentLayerVisible and not ToolManager.ToolCanBeUsed then
    ChooseTool(ptHand)
  else
    ToolManager.ToolOpen;
end;

procedure TFMain.PictureSelectedLayerIndexChanging(sender: TLazPaintImage);
begin
  ToolManager.ToolCloseDontReopen;
end;

procedure TFMain.SetShowSelectionNormal(const AValue: boolean);
begin
  FShowSelectionNormal := AValue;
  if Assigned(FImageView) then
    FImageView.FillSelectionHighlight := ToolManager.DisplayFilledSelection and not FShowSelectionNormal;
end;

procedure TFMain.WMEraseBkgnd(var Message: TLMEraseBkgnd);
begin
   //  block Erasing background
   //  inherited EraseBackground(DC);
end;

function TFMain.GetImage: TLazPaintImage;
begin
  result := LazPaintInstance.Image;
end;

procedure TFMain.UpdateStatusText;
var s: string;
begin
  if ToolManager.CurrentTool <> nil then
  begin
    s := ToolManager.CurrentTool.StatusText;
    if s = '' then s := currentToolLabel;
  end
  else s := '';
  Layout.StatusText := s;
end;

function TFMain.GetUseImageBrowser: boolean;
begin
  result := Config.DefaultUseImageBrowser;
end;

function TFMain.GetCurrentPressure: single;
begin
  if Assigned(FTablet) and FTablet.Present and FTablet.Entering and (FTablet.Max > 0) then
    result := FTablet.Pressure/FTablet.Max
  else
    result := 1;
end;

function TFMain.GetScriptContext: TScriptContext;
begin
  result := LazPaintInstance.ScriptContext;
end;

procedure TFMain.CallScriptFunction(AName: string);
begin
  case Scripting.CallScriptFunction(AName) of
    srFunctionNotDefined: LazPaintInstance.ShowMessage(rsScript,StringReplace(rsFunctionNotDefined,'%1',AName,[]));
  end;
end;

procedure TFMain.CallScriptFunction(AParams: TVariableSet);
begin
  case Scripting.CallScriptFunction(AParams) of
    srFunctionNotDefined: LazPaintInstance.ShowMessage(rsScript,StringReplace(rsFunctionNotDefined,'%1',AParams.FunctionName,[]));
  end;
end;

function TFMain.PictureCanvasOfs: TPoint;
begin
  {$IFDEF USEPAINTBOXPICTURE}
  result := Point(-PaintBox_Picture.Left,-PaintBox_Picture.Top);
  {$ELSE}
  result := Point(0,0);
  {$ENDIF}
end;

{$R *.lfm}

end.
