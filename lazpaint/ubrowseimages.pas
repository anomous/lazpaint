unit ubrowseimages;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs,
  ComCtrls, ExtCtrls, Buttons, StdCtrls, BGRAVirtualScreen, BGRABitmap,
  BGRABitmapTypes, BGRAAnimatedGif, UMySLV, LazPaintType, Masks, LCLType,
  UFileSystem, UImagePreview;

const
  MaxIconCacheCount = 512;

type

  { TFBrowseImages }

  TFBrowseImages = class(TForm)
    CheckBox_UseDirectoryOnStartup: TCheckBox;
    DirectoryEdit1: TEdit;
    ToolButton_CreateFolderOrContainer: TToolButton;
    Tool_SelectDrive: TToolButton;
    ToolButtonSeparator: TToolButton;
    ToolButton_OpenSelectedFiles: TToolButton;
    vsList: TBGRAVirtualScreen;
    ComboBox_FileExtension: TComboBox;
    Edit_Filename: TEdit;
    ListBox_RecentDirs: TListBox;
    Panel3: TPanel;
    ToolBar1: TToolBar;
    ToolButton_GoUp: TToolButton;
    ToolButton_ViewBigIcon: TToolButton;
    ToolButton_ViewDetails: TToolButton;
    vsPreview: TBGRAVirtualScreen;
    ImageListToolbar: TImageList;
    ImageList128: TImageList;
    Label_Status: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    Splitter1: TSplitter;
    Timer1: TTimer;
    procedure CheckBox_UseDirectoryOnStartupChange(Sender: TObject);
    procedure ComboBox_FileExtensionChange(Sender: TObject);
    procedure DirectoryEdit1Change(Sender: TObject);
    procedure Edit_FilenameChange(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var {%H-}CanClose: boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; {%H-}Shift: TShiftState);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormUTF8KeyPress(Sender: TObject; var UTF8Key: TUTF8Char);
    procedure ListBox_RecentDirsClick(Sender: TObject);
    procedure ShellListView1DblClick(Sender: TObject);
    procedure ShellListView1SelectItem(Sender: TObject; Item: integer;
      {%H-}Selected: Boolean);
    procedure ShellListView1OnSort(Sender: TObject);
    procedure ShellListView1OnFormatType(Sender: Tobject; var AType:string);
    procedure Timer1Timer(Sender: TObject);
    procedure ToolButton_CreateFolderOrContainerClick(Sender: TObject);
    procedure ToolButton_OpenSelectedFilesClick(Sender: TObject);
    procedure ToolButton_ViewDetailsClick(Sender: TObject);
    procedure ToolButton_GoUpClick(Sender: TObject);
    procedure ToolButton_ViewBigIconClick(Sender: TObject);
    procedure Tool_SelectDriveClick(Sender: TObject);
    function OnDeleteConfirmation({%H-}AForm:TForm; const AFiles: array of string; AContained: boolean): boolean;
  private
    FLazPaintInstance: TLazPaintCustomInstance;
    FDefaultExtension: string;
    { private declarations }
    FFileExtensions: array of string;
    FDefaultExtensions: string;
    FOpenButtonHint: string;
    FIsSaveDialog: boolean;
    FOverwritePrompt: boolean;
    ShellListView1: TLCShellListView;
    FInFormShow: boolean;
    FChosenImage: TImageEntry;
    FPreview: TImagePreview;
    FComputeIconCurrentItem: integer;
    FPreviewFilename: string;
    FInShowPreview,FInHidePreview: boolean;
    FSavedDetailsViewWidth: integer;
    FLastDirectory: string;
    FFileSystems: TFileSystemArray;
    FFilename: string;
    FBmpIcon: TBGRABitmap;
    FLastBigIcon: boolean;
    FImageFileNotChecked, FImageFileUnkown, FImageFolder,
    FImageHardDrive, FImageCdRom, FImageUsbStick, FImageRamDrive, FImageNetworkDrive: TBGRABitmap;
    InFilenameChange: boolean;
    FSelectedFiles: array of string;
    FCreateFolderOrContainerCaption: string;
    function GetCurrentExtensionFilter: string;
    function GetInitialFilename: string;
    function GetOpenLayerIcon: boolean;
    procedure SetInitialFilename(AValue: string);
    procedure SetLazPaintInstance(AValue: TLazPaintCustomInstance);
    procedure SetOpenLayerIcon(AValue: boolean);
    procedure UpdateToolButtonOpen;
    function GetAllowMultiSelect: boolean;
    function GetSelectedFile(AIndex: integer): string;
    function GetSelectedFileCount: integer;
    procedure ResetDirectory(AFocus: boolean; AForceReload: boolean = false);
    procedure ClearThumbnails;
    procedure SetAllowMultiSelect(AValue: boolean);
    procedure SetIsSaveDialog(AValue: boolean);
    procedure StartThumbnails;
    procedure SelectCurrentDir;
    procedure UpdatePreview(AFilename:string); overload;
    procedure UpdatePreview; overload;
    procedure ShowPreview;
    procedure HidePreview;
    procedure UpdateConstraints;
    procedure ViewDetails;
    procedure ViewBigIcons;
    procedure ValidateFileOrDir;
    procedure GoDirUp;
    procedure InitComboExt;
    procedure SetShellMask;
    procedure DeleteSelectedFiles;
    procedure SelectFile(AName: string);
    procedure PreviewValidate({%H-}ASender: TObject);
  public
    { public declarations }
    ShowRememberStartupDirectory: boolean;
    function GetChosenImage: TImageEntry;
    procedure FreeChosenImage;
    property LazPaintInstance: TLazPaintCustomInstance read FLazPaintInstance write SetLazPaintInstance;
    property Filename: string read FFilename;
    property SelectedFileCount: integer read GetSelectedFileCount;
    property SelectedFile[AIndex:integer]: string read GetSelectedFile;
    property AllowMultiSelect: boolean read GetAllowMultiSelect write SetAllowMultiSelect;
    property InitialDirectory: string read FLastDirectory write FLastDirectory;
    property IsSaveDialog: boolean read FIsSaveDialog write SetIsSaveDialog;
    property OverwritePrompt: boolean read FOverwritePrompt write FOverwritePrompt;
    property DefaultExtension: string read FDefaultExtension write FDefaultExtension;
    property DefaultExtensions: string read FDefaultExtensions write FDefaultExtensions;
    property InitialFilename: string read GetInitialFilename write SetInitialFilename;
    property CurrentExtensionFilter: string read GetCurrentExtensionFilter;
    property OpenLayerIcon: boolean read GetOpenLayerIcon write SetOpenLayerIcon;
  end;

var
  FBrowseImages: TFBrowseImages;

implementation

{$R *.lfm}

uses BGRAThumbnail, BGRAPaintNet, BGRAOpenRaster, BGRAReadLzp,
    BGRAWriteLzp, FPimage,
    Types, UResourceStrings,
    UConfig, bgrareadjpeg, FPReadJPEG,
    UFileExtensions, BGRAUTF8, LazFileUtils,
    UGraph;

var
  IconCache: TStringList;

{ TFBrowseImages }

procedure TFBrowseImages.DirectoryEdit1Change(Sender: TObject);
begin
  ResetDirectory(False);
end;

procedure TFBrowseImages.Edit_FilenameChange(Sender: TObject);
var i: integer;
  txt: string;
  first: boolean;
begin
  if InFilenameChange then exit;
  InFilenameChange := true;
  ShellListView1.DeselectAll;
  UpdatePreview('');
  first := true;
  txt := trim(Edit_Filename.Text);
  for i := 0 to ShellListView1.ItemCount-1 do
    if UTF8CompareText(ShellListView1.ItemName[i],txt) = 0 then
    begin
      if first then
      begin
        ShellListView1.SelectedIndex := i;
        ShellListView1.MakeItemVisible(i);
        ShellListView1SelectItem(nil, i, true);
        if not ShellListView1.ItemIsFolder[i] then
          UpdatePreview(ShellListView1.ItemFullName[i]);
      end;
      ShellListView1.ItemSelected[i] := true;
      first := false;
    end;
  if first then
  begin
    for i := 0 to ShellListView1.ItemCount-1 do
      if UTF8CompareText(ChangeFileExt(ShellListView1.ItemName[i],''),txt) = 0 then
      begin
        if first then
        begin
          ShellListView1.SelectedIndex := i;
          ShellListView1.MakeItemVisible(i);
          ShellListView1SelectItem(nil, i, true);
          UpdatePreview(ShellListView1.ItemFullName[i]);
        end;
        ShellListView1.ItemSelected[i] := true;
        first := false;
      end;
  end;
  if IsSaveDialog then UpdateToolButtonOpen;
  InFilenameChange := false;
end;

procedure TFBrowseImages.ComboBox_FileExtensionChange(Sender: TObject);
begin
  ClearThumbnails;
  SetShellMask;
  StartThumbnails;
  if IsSaveDialog then
  begin
    If (ExtractFileExt(Edit_Filename.Text) <> '') and (ComboBox_FileExtension.ItemIndex > 0) then
      Edit_Filename.Text := ApplySelectedFilterExtension(Edit_Filename.Text, '?|'+CurrentExtensionFilter,1) else
      Edit_FilenameChange(nil);
  end else
    Edit_Filename.Text := '';
end;

procedure TFBrowseImages.CheckBox_UseDirectoryOnStartupChange(Sender: TObject);
begin
  if IsSaveDialog then
    LazPaintInstance.Config.SetRememberStartupTargetDirectory(CheckBox_UseDirectoryOnStartup.Checked)
  else
    LazPaintInstance.Config.SetRememberStartupSourceDirectory(CheckBox_UseDirectoryOnStartup.Checked)
end;

procedure TFBrowseImages.FormCloseQuery(Sender: TObject; var CanClose: boolean);
var r:TRect;
begin
  LazPaintInstance.Config.SetDefaultBrowseWindowMaximized(self.WindowState = wsMaximized);
  if self.WindowState = wsNormal then
  begin
    r.left := Left;
    r.top := Top;
    r.right := r.left+ClientWidth;
    r.Bottom := r.top+ClientHeight;
    LazPaintInstance.Config.SetDefaultBrowseWindowPosition(r);
  end
  else
    LazPaintInstance.Config.SetDefaultBrowseWindowPosition(EmptyRect);
end;

procedure TFBrowseImages.FormCreate(Sender: TObject);
var bmp : TBitmap; delta: integer;
begin
  FLastDirectory := '';
  FOverwritePrompt:= true;
  FOpenButtonHint:= ToolButton_OpenSelectedFiles.Hint;

  FPreview := TImagePreview.Create(vsPreview, Label_Status, true);
  FPreview.OnValidate:= @PreviewValidate;
  FChosenImage := TImageEntry.Empty;

  InitComboExt;

  bmp := TBitmap.Create;
  ImageList128.GetBitmap(0,bmp);
  FImageFileNotChecked := TBGRABitmap.Create(bmp);
  ImageList128.GetBitmap(1,bmp);
  FImageFolder := TBGRABitmap.Create(bmp);
  ImageList128.GetBitmap(2,bmp);
  FImageFileUnkown := TBGRABitmap.Create(bmp);
  ImageList128.GetBitmap(3,bmp);
  FImageHardDrive := TBGRABitmap.Create(bmp);
  ImageList128.GetBitmap(4,bmp);
  FImageCdRom := TBGRABitmap.Create(bmp);
  ImageList128.GetBitmap(5,bmp);
  FImageUsbStick := TBGRABitmap.Create(bmp);
  ImageList128.GetBitmap(6,bmp);
  FImageRamDrive := TBGRABitmap.Create(bmp);
  ImageList128.GetBitmap(7,bmp);
  FImageNetworkDrive := TBGRABitmap.Create(bmp);
  bmp.Free;
  ImageList128.Clear;

  ShellListView1 := TLCShellListView.Create(vsList);
  SetShellMask;
  ShellListView1.OnDblClick := @ShellListView1DblClick;
  ShellListView1.OnSelectItem := @ShellListView1SelectItem;
  ShellListView1.OnSort := @ShellListView1OnSort;
  ShellListView1.OnFormatType := @ShellListView1OnFormatType;

  BGRAPaintNet.RegisterPaintNetFormat;
  BGRAOpenRaster.RegisterOpenRasterFormat;

  FFileSystems := FileManager.GetFileSystems;
  if length(FFileSystems)>0 then
  begin
    Tool_SelectDrive.Visible := true;
  end else
  begin
    Tool_SelectDrive.Visible := false;
    delta := ImageListToolbar.Width+Toolbar1.Indent;
    ToolBar1.Width := ToolBar1.Width-delta;
    DirectoryEdit1.Left := DirectoryEdit1.Left-delta;
    DirectoryEdit1.Width := DirectoryEdit1.Width+delta;
  end;

  FCreateFolderOrContainerCaption := ToolButton_CreateFolderOrContainer.Hint;
  ToolButton_CreateFolderOrContainer.Hint := ToolButton_CreateFolderOrContainer.Hint + '...';
end;

procedure TFBrowseImages.FormDestroy(Sender: TObject);
begin
  ShellListView1.VirtualScreenFreed;
  FreeAndNil(ShellListView1);
  FreeAndNil(FChosenImage.bmp);
  FreeAndNil(FPreview);
  FreeAndNil(FBmpIcon);
  FreeAndNil(FImageFileNotChecked);
  FreeAndNil(FImageFileUnkown);
  FreeAndNil(FImageFolder);
  FreeAndNil(FImageHardDrive);
  FreeAndNil(FImageCdRom);
  FreeAndNil(FImageUsbStick);
  FreeAndNil(FImageRamDrive);
  FreeAndNil(FImageNetworkDrive);
end;

procedure TFBrowseImages.FormHide(Sender: TObject);
begin
  FLastBigIcon := (ShellListView1.ViewStyle = vsIcon);
  if not IsSaveDialog then FFilename:= FPreviewFilename;
  Timer1.Enabled := false;
  vsList.Anchors := [akLeft,akTop,akRight,akBottom];
  FLastDirectory := DirectoryEdit1.Text;
  DirectoryEdit1.Text := '';
  UpdatePreview('');
end;

procedure TFBrowseImages.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
  begin
    if Edit_Filename.Focused and (trim(Edit_Filename.Text)='..') then
      GoDirUp
    else
    begin
      ValidateFileOrDir;
      ShellListView1.SetFocus;
    end;
    Key := 0;
  end else
  if (Key = VK_BACK) and not Edit_Filename.Focused and not DirectoryEdit1.Focused then
  begin
    GoDirUp;
    Key := 0;
  end else
  if (KEY = VK_DELETE) and not Edit_Filename.Focused and not DirectoryEdit1.Focused then
  begin
    DeleteSelectedFiles;
    Key := 0;
  end;
end;

procedure TFBrowseImages.FormResize(Sender: TObject);
begin
  UpdateConstraints;
end;

procedure TFBrowseImages.FormShow(Sender: TObject);
var r:TRect; i: integer;
begin
  if FInFormShow then exit;
  FInFormShow:= true;
  ListBox_RecentDirs.Clear;
  for i := 0 to LazPaintInstance.Config.RecentDirectoriesCount-1 do
    ListBox_RecentDirs.Items.Add(LazPaintInstance.Config.RecentDirectory[i]);
  InFilenameChange := true;
  if not IsSaveDialog then Edit_Filename.Text := '';
  FFilename := '';
  FSelectedFiles := nil;
  InFilenameChange := false;
  if Assigned(LazPaintInstance) then
  begin
    if LazPaintInstance.Config.DefaultBrowseWindowMaximized then self.WindowState := wsMaximized
      else
    begin
      self.WindowState := wsNormal;
      r := LazPaintInstance.Config.DefaultBrowseWindowPosition;
      if (r.right > r.left) and (r.bottom > r.top) then
      begin
        self.Position := poDesigned;
        self.Left := r.Left;
        self.Top := r.Top;
        self.ClientWidth := r.right-r.left;
        self.ClientHeight := r.bottom-r.top
      end;
    end;
  end;
  if FLastBigIcon then ViewBigIcons;
  if (FLastDirectory = '') or not FileManager.IsDirectory(FLastDirectory) then
    DirectoryEdit1.Text := DefaultPicturesDirectory
  else
    DirectoryEdit1.Text := FLastDirectory;
  Timer1.Enabled := true;
  vsList.Anchors := [akLeft,akTop];
  ShellListView1.SetFocus;
  FreeAndNil(FChosenImage.bmp);
  UpdatePreview;
  UpdateToolButtonOpen;
  if FDefaultExtensions<>'' then
  begin
    for i := 0 to high(FFileExtensions) do
      if FFileExtensions[i] = FDefaultExtensions then
      begin
        ComboBox_FileExtension.ItemIndex := i;
        break;
      end;
  end;
  if IsSaveDialog then
  begin
    If (ExtractFileExt(Edit_Filename.Text) <> '') and (ComboBox_FileExtension.ItemIndex > 0) then
      Edit_Filename.Text := ApplySelectedFilterExtension(Edit_Filename.Text, '?|'+CurrentExtensionFilter,1)
    else
      Edit_FilenameChange(nil);
  end;
  FInFormShow:= false;
end;

procedure TFBrowseImages.FormUTF8KeyPress(Sender: TObject;
  var UTF8Key: TUTF8Char);
begin
  if (UTF8Key <> '') and (Utf8Key[1] > #32) and not Edit_Filename.Focused and
    not DirectoryEdit1.Focused then
  begin
    SafeSetFocus(Edit_Filename);
    Edit_Filename.Text := UTF8Key;
    Edit_Filename.SelLength:= 0;
    Edit_Filename.SelStart := UTF8Length(UTF8Key);
    UTF8Key := #0;
  end;
end;

procedure TFBrowseImages.ListBox_RecentDirsClick(Sender: TObject);
begin
  if ListBox_RecentDirs.ItemIndex <> -1 then
  begin
    if ChompPathDelim(DirectoryEdit1.Text) <> ChompPathDelim(ListBox_RecentDirs.Items[ListBox_RecentDirs.ItemIndex]) then
      DirectoryEdit1.Text := AppendPathDelim(ListBox_RecentDirs.Items[ListBox_RecentDirs.ItemIndex]);
  end;
end;

procedure TFBrowseImages.ShellListView1DblClick(Sender: TObject);
begin
  ValidateFileOrDir;
end;

procedure TFBrowseImages.ShellListView1SelectItem(Sender: TObject; Item: integer;
  Selected: Boolean);
var wasTimer: boolean;
begin
  wasTimer := Timer1.Enabled;
  Timer1.Enabled := false;

  if not InFilenameChange and ShellListView1.ItemSelected[Item] then
  begin
    InFilenameChange := true;
    Edit_Filename.Text := ShellListView1.ItemName[Item];
    InFilenameChange := false;
  end;

  if ShellListView1.ItemSelected[Item] and not ShellListView1.ItemIsFolder[Item] then
    UpdatePreview(ShellListView1.ItemFullName[Item])
  else
    if FPreviewFilename = ShellListView1.ItemFullName[Item] then
      UpdatePreview('');

  UpdateToolButtonOpen;
  Timer1.Enabled := wasTimer;
end;

procedure TFBrowseImages.ShellListView1OnSort(Sender: TObject);
begin
  FComputeIconCurrentItem := 0;
end;

procedure TFBrowseImages.ShellListView1OnFormatType(Sender: Tobject;
  var AType: string);
var format: TBGRAImageFormat;
begin
  if AType = 'Folder' then AType := rsFolder else
  begin
    format := SuggestImageFormat(AType);
    if format = ifPng then AType := 'PNG' //too long to write explicitely
    else if format = ifGIF then AType := 'GIF' //do not know if animated or not
    else if format = ifIco then AType := 'Icon'
    else if format = ifCur then AType := 'Cursor'
    else if format = ifSvg then AType := 'SVG'  //too long to write explicitely
    else AType := GetImageFormatName(format);
  end;
end;

procedure TFBrowseImages.Timer1Timer(Sender: TObject);
var i: integer;
  iconRect,shellRect:TRect;
  endDate: TDateTime;

  function DetermineIcon(i: integer): boolean;
  var itemPath,cacheName,dummyCaption: string;
    cacheIndex: integer;
    found: boolean;
    mem: TMemoryStream;
    s: TStream;
  begin
    result := false;
    if ShellListView1.GetItemImage(i) = FImageFileNotChecked then
    begin
      if ShellListView1.ItemIsFolder[i] then
        ShellListView1.SetItemImage(i,FImageFolder,false)
      else
      begin
        itemPath := ShellListView1.ItemFullName[i];
        cacheName := itemPath+':'+FloatToStr(ShellListView1.ItemLastModification[i]);
        cacheIndex := IconCache.IndexOf(cacheName);
        if not Assigned(FBmpIcon) then FBmpIcon := TBGRABitmap.Create;
        if cacheIndex <> -1 then
        begin
          TStream(IconCache.Objects[cacheIndex]).Position:= 0;
          TBGRAReaderLazPaint.LoadRLEImage(TStream(IconCache.Objects[cacheIndex]),FBmpIcon,dummyCaption);
          found := true;
        end
        else
        begin
          try
            s := FileManager.CreateFileStream(itemPath, fmOpenRead or fmShareDenyWrite);
            try
              found := GetStreamThumbnail(s,ShellListView1.LargeIconSize,ShellListView1.LargeIconSize, BGRAPixelTransparent, True, ExtractFileExt(itemPath), FBmpIcon) <> nil;
            finally
              s.Free;
            end;
          except
            found := false;
          end;
          if found then
          begin
            if IconCache.Count >= MaxIconCacheCount then IconCache.Delete(0);
            mem := TMemoryStream.Create;
            TBGRAWriterLazPaint.WriteRLEImage(mem,FBmpIcon);
            IconCache.AddObject(cacheName,mem);
          end;
        end;
        if found then
        begin
          ShellListView1.SetItemImage(i,FBmpIcon.Duplicate as TBGRABitmap,True);
        end else
          ShellListView1.SetItemImage(i,FImageFileUnkown,False);
      end;
      result := true;
    end;
  end;

var someIconDone: boolean;

begin
  Timer1.Enabled:= false;
  EndDate := Now + 50 / MSecsPerDay;
  if FPreview.Filename <> FPreviewFilename then
    UpdatePreview
  else
    FPreview.HandleTimer;
  if FComputeIconCurrentItem < ShellListView1.ItemCount then
  begin
    vsList.Cursor := crAppStart;
    shellRect := rect(0,0,ShellListView1.Width,ShellListView1.Height);
    someIconDone := false;
    for i := FComputeIconCurrentItem to ShellListView1.ItemCount-1 do
    if ShellListView1.GetItemImage(i) = FImageFileNotChecked then
    If Now >= EndDate then break else
    begin
      iconRect := ShellListView1.ItemDisplayRect[i];
      if IntersectRect(iconRect,iconRect,shellRect) then
        if DetermineIcon(i) then someIconDone := true;
    end;
    if not someIconDone then EndDate := Now + 50 / MSecsPerDay;
    for i := FComputeIconCurrentItem to ShellListView1.ItemCount-1 do
    If Now >= EndDate then break else
    begin
      FComputeIconCurrentItem := i+1;
      DetermineIcon(i);
    end;
    vsList.Cursor := crDefault;
  end;
  vsList.SetBounds(vsList.Left, vsList.Top, Panel2.Width, Panel2.Height-Panel3.Height);
  ShellListView1.Update;
  Timer1.Enabled:= true;
end;

procedure TFBrowseImages.ToolButton_CreateFolderOrContainerClick(Sender: TObject);
var
  newName: String;
  newFullname: string;
begin
  if pos(PathDelim, DirectoryEdit1.Text) = 0 then exit;
  newName := InputBox(FCreateFolderOrContainerCaption, rsEnterFolderOrContainerName, '');
  if newName = '' then exit;
  if (pos(':',newName) <> 0) or (pos('\',newName) <> 0) then
    MessageDlg(rsInvalidName, mtError, [mbOK], 0) else
  begin
    newFullname := ChompPathDelim(DirectoryEdit1.Text)+PathDelim+newName;
    if FileManager.IsDirectory(newFullname) then
      MessageDlg(rsFolderOrContainerAlreadyExists, mtInformation, [mbOK], 0)
    else
    begin
      if FileManager.FileExists(newFullname) then
      begin
        if MessageDlg(rsOverwriteFile, mtConfirmation, [mbYes,mbNo], 0) = mrYes then
        begin
          try
            FileManager.DeleteFile(newFullname);
          except
            on ex:exception do
            begin
              MessageDlg(ex.Message, mtError, [mbOk], 0);
              exit;
            end;
          end;
        end
        else exit;
      end;
      try
        FileManager.CreateDirectory(newFullname);
      except
        on ex:exception do
          MessageDlg(ex.Message, mtError, [mbOk], 0);
      end;
      ResetDirectory(True,True);
      SelectFile(newName);
    end;
  end;

end;

procedure TFBrowseImages.ToolButton_OpenSelectedFilesClick(Sender: TObject);
begin
  ValidateFileOrDir;
  ShellListView1.SetFocus;
end;

procedure TFBrowseImages.ToolButton_ViewDetailsClick(Sender: TObject);
begin
  ViewDetails;
end;

procedure TFBrowseImages.ToolButton_GoUpClick(Sender: TObject);
begin
  GoDirUp;
end;

procedure TFBrowseImages.ToolButton_ViewBigIconClick(Sender: TObject);
begin
  ViewBigIcons;
end;

procedure TFBrowseImages.Tool_SelectDriveClick(Sender: TObject);
begin
  DirectoryEdit1.Text := ':';
end;

function TFBrowseImages.OnDeleteConfirmation(AForm: TForm;
  const AFiles: array of string; AContained: boolean): boolean;
begin
  if AContained then
  begin
    if length(AFiles)=1 then
      result := QuestionDlg(rsDeleteFile,rsConfirmDeleteFromContainer,mtConfirmation,[mrOK,rsOkay,mrCancel,rsCancel],0)=mrOk else
    if length(AFiles)>1 then
      result := QuestionDlg(rsDeleteFile,StringReplace(rsConfirmDeleteMultipleFromContainer,'%1',IntToStr(length(AFiles)),[]),mtConfirmation,[mrOK,rsOkay,mrCancel,rsCancel],0)=mrOk
  end else
  if length(AFiles)=1 then
    result := QuestionDlg(rsDeleteFile,rsConfirmMoveToTrash,mtConfirmation,[mrOK,rsOkay,mrCancel,rsCancel],0)=mrOk else
  if length(AFiles)>1 then
    result := QuestionDlg(rsDeleteFile,StringReplace(rsConfirmMoveMultipleToTrash,'%1',IntToStr(length(AFiles)),[]),mtConfirmation,[mrOK,rsOkay,mrCancel,rsCancel],0)=mrOk
  else
    result := true;
end;

procedure TFBrowseImages.UpdateToolButtonOpen;
var chosenFilename: string;
begin
  chosenFilename := Trim(Edit_Filename.Text);
  ToolButton_OpenSelectedFiles.Enabled := (ShellListView1.SelectedCount> 0) or (IsSaveDialog and (chosenFilename<>''));
end;

function TFBrowseImages.GetInitialFilename: string;
begin
  result := Edit_Filename.Text;
end;

function TFBrowseImages.GetOpenLayerIcon: boolean;
begin
  result := ToolButton_OpenSelectedFiles.ImageIndex = 7;
end;

function TFBrowseImages.GetCurrentExtensionFilter: string;
begin
  if (ComboBox_FileExtension.ItemIndex >= 0) and (ComboBox_FileExtension.ItemIndex < length(FFileExtensions)) then
    result := FFileExtensions[ComboBox_FileExtension.ItemIndex]
  else
    result := '*.*';
end;

procedure TFBrowseImages.SetInitialFilename(AValue: string);
begin
  Edit_Filename.Text := Trim(AValue);
end;

procedure TFBrowseImages.SetLazPaintInstance(AValue: TLazPaintCustomInstance);
begin
  if FLazPaintInstance=AValue then Exit;
  FLazPaintInstance:=AValue;
  if Assigned(FPreview) then
    FPreview.LazPaintInstance := AValue;
end;

procedure TFBrowseImages.SetOpenLayerIcon(AValue: boolean);
begin
  if AValue then
    ToolButton_OpenSelectedFiles.ImageIndex := 7
  else
    ToolButton_OpenSelectedFiles.ImageIndex := 5;
end;

procedure TFBrowseImages.ResetDirectory(AFocus: boolean; AForceReload: boolean);
var newDir: string;
begin
  newDir := DirectoryEdit1.Text;
  if Assigned(ShellListView1) and ((newDir <> ShellListView1.Root) or AForceReload) then
  begin
    ClearThumbnails;
    if newDir = ShellListView1.Root then
      ShellListView1.Reload
    else
      ShellListView1.Root := newDir;
    StartThumbnails;
    if AFocus then ShellListView1.SetFocus;
    if ShellListView1.ItemCount <> 0 then
    begin
      ShellListView1.MakeItemVisible(0);
    end;
    SelectCurrentDir;
    ToolButton_CreateFolderOrContainer.Enabled := pos(PathDelim, newDir) <> 0;
  end;
end;

function TFBrowseImages.GetSelectedFile(AIndex: integer): string;
begin
  if (AIndex < 0) or (AIndex >= length(FSelectedFiles)) then
    result := ''
  else
    result := FSelectedFiles[AIndex];
end;

function TFBrowseImages.GetAllowMultiSelect: boolean;
begin
  result := ShellListView1.AllowMultiSelect;
end;

function TFBrowseImages.GetSelectedFileCount: integer;
begin
  result := length(FSelectedFiles);
end;

procedure TFBrowseImages.ClearThumbnails;
var I: integer;
begin
  ShellListView1.BeginUpdate;
  for I := 0 to ShellListView1.ItemCount-1 do
    ShellListView1.SetItemImage(i,FImageFileNotChecked,false);
  ShellListView1.EndUpdate;
end;

procedure TFBrowseImages.SetAllowMultiSelect(AValue: boolean);
begin
  ShellListView1.AllowMultiSelect := AValue;
end;

procedure TFBrowseImages.SetIsSaveDialog(AValue: boolean);
begin
  if FIsSaveDialog=AValue then Exit;
  FIsSaveDialog:=AValue;
  if AValue then
  begin
    ToolButton_OpenSelectedFiles.ImageIndex := 4;
    ToolButton_OpenSelectedFiles.Hint := rsSaveAsButtonHint;
    AllowMultiSelect:= false;
  end else
  begin
    ToolButton_OpenSelectedFiles.ImageIndex := 5;
    ToolButton_OpenSelectedFiles.Hint := FOpenButtonHint;
  end;
  InitComboExt;
end;

procedure TFBrowseImages.StartThumbnails;
var I: integer;
  t: string;
begin
  for I := 0 to ShellListView1.ItemCount-1 do
    begin
      if ShellListView1.ItemIsFolder[I] then
      begin
        t := ShellListView1.itemDevice[I];
        if t = rsFixedDrive then
          ShellListView1.SetItemImage(i,FImageHardDrive,false)
        else if t = rsCdRom then
          ShellListView1.SetItemImage(i,FImageCdRom,false)
        else if t = rsRemovableDrive then
          ShellListView1.SetItemImage(i,FImageUsbStick,false)
        else if t = rsNetworkDrive then
          ShellListView1.SetItemImage(i,FImageNetworkDrive,false)
        else if t = rsRamDisk then
          ShellListView1.SetItemImage(i,FImageRamDrive,false)
        else
          ShellListView1.SetItemImage(i,FImageFolder,false);
      end
      else
        ShellListView1.SetItemImage(i,FImageFileNotChecked,false);
    end;
  FComputeIconCurrentItem := 0;
end;

procedure TFBrowseImages.SelectCurrentDir;
var I: integer;
begin
  ListBox_RecentDirs.ItemIndex := -1;
  for I := 0 to ListBox_RecentDirs.Count-1 do
    if ChompPathDelim(ListBox_RecentDirs.Items[i]) = ChompPathDelim(DirectoryEdit1.Text) then
    begin
      ListBox_RecentDirs.ItemIndex:= I;
      break;
    end;
end;

procedure TFBrowseImages.UpdatePreview(AFilename: string);
begin
  if IsSaveDialog then
    FPreviewFilename := ''
  else
    FPreviewFilename := AFilename;
end;

procedure TFBrowseImages.UpdatePreview;
begin
  if (FPreviewFilename = '') or not Panel1.Visible then
  begin
    FPreview.Filename:= '';
    vsPreview.Visible := false;
    Label_Status.Caption := rsRecentDirectories;
    ListBox_RecentDirs.Visible := true;
    if IsSaveDialog then
      CheckBox_UseDirectoryOnStartup.Checked := FLazPaintInstance.Config.DefaultRememberStartupTargetDirectory
    else
      CheckBox_UseDirectoryOnStartup.Checked := FLazPaintInstance.Config.DefaultRememberStartupSourceDirectory;
    CheckBox_UseDirectoryOnStartup.Left := Label_Status.Left+Label_Status.Width + 10;
    CheckBox_UseDirectoryOnStartup.Visible := ShowRememberStartupDirectory;
    SelectCurrentDir;
  end else
  begin
    ListBox_RecentDirs.Visible := false;
    CheckBox_UseDirectoryOnStartup.Visible := false;
    vsPreview.Visible := true;
    FPreview.Filename:= FPreviewFilename;
  end;
end;

procedure TFBrowseImages.ShowPreview;
begin
  if FInShowPreview or Panel1.Visible then exit;
  FInShowPreview := true;
  Panel1.Visible := true;
  UpdateConstraints;
  Panel2.Align := alLeft;
  Panel2.Width := FSavedDetailsViewWidth;
  Splitter1.Visible := true;
  UpdatePreview;
  FInShowPreview := false;
end;

procedure TFBrowseImages.HidePreview;
begin
  if FInHidePreview or not Panel1.Visible then exit;
  FInHidePreview:= true;
  FSavedDetailsViewWidth := Panel2.Width;
  Panel1.Visible := false;
  UpdateConstraints;
  Splitter1.Visible := false;
  Panel2.Width := ClientWidth;
  Panel2.Align := alClient;
  FInHidePreview:= false;
end;

procedure TFBrowseImages.UpdateConstraints;
begin
  if Panel1.Visible then
    Panel2.Constraints.MaxWidth := ClientWidth-Splitter1.Width-64
  else
    Panel2.Constraints.MaxWidth := 0;
end;

procedure TFBrowseImages.ViewDetails;
begin
  ShellListView1.BeginUpdate;
  ShellListView1.ViewStyle := vsReport;
  ShowPreview;
  ShellListView1.EndUpdate;
end;

procedure TFBrowseImages.ViewBigIcons;
begin
  ShellListView1.BeginUpdate;
  HidePreview;
  ShellListView1.ViewStyle := vsIcon;
  ShellListView1.EndUpdate;
end;

procedure TFBrowseImages.ValidateFileOrDir;
var fullName: string;
  i,count: integer;
begin
  if ShellListView1.SelectedIndex <> -1 then
  begin
    fullName := ShellListView1.ItemFullName[ShellListView1.SelectedIndex];
    if ShellListView1.ItemIsFolder[ShellListView1.SelectedIndex] then
    begin
      DirectoryEdit1.Text := fullName;
      InFilenameChange := true;
      Edit_Filename.text := '';
      InFilenameChange := false;
      ShellListView1.SetFocus;
    end
    else
    begin
      count := 0;
      for i := 0 to ShellListView1.ItemCount-1 do
        if ShellListView1.ItemSelected[i] and not ShellListView1.ItemIsFolder[i] then inc(count);
      if (count > 0) and IsSaveDialog and OverwritePrompt then
      begin
        if QuestionDlg(rsSave, rsOverwriteFile, mtConfirmation, [mrOk, rsOkay, mrCancel, rsCancel],0) <> mrOk then exit;
      end;
      setlength(FSelectedFiles,count);
      count := 0;
      for i := 0 to ShellListView1.ItemCount-1 do
        if ShellListView1.ItemSelected[i] and not ShellListView1.ItemIsFolder[i] then
        begin
          FSelectedFiles[count] := ShellListView1.ItemFullName[i];
          inc(count);
        end;
      if IsSaveDialog and (count > 0) then FFilename := FSelectedFiles[0];
      UpdatePreview(fullName);

      //if we are opening one image and its preview contains all data
      //then we can provide the loaded image / frame
      if not IsSaveDialog and (count = 1)
         and (FPreview.Filename = FPreviewFilename)
         and not FPreview.PreviewDataLoss then
      begin
        FChosenImage := FPreview.GetPreviewBitmap;
        if FChosenImage.bmp = nil then exit;
      end;

      if ComboBox_FileExtension.ItemIndex <> -1 then
        FDefaultExtensions := FFileExtensions[ComboBox_FileExtension.ItemIndex];
      ModalResult:= mrOk;
    end;
  end else
    if IsSaveDialog and (Trim(Edit_Filename.Text)<>'') and (DirectoryEdit1.Text <> ':') and
      FileManager.IsDirectory(trim(DirectoryEdit1.Text)) then
    begin
      FFilename:= IncludeTrailingPathDelimiter(trim(DirectoryEdit1.Text))+Edit_Filename.Text;
      if (ExtractFileExt(FFilename)='') then
      begin
        if (ComboBox_FileExtension.ItemIndex > 0) then
          FFilename:= ApplySelectedFilterExtension(FFilename,'?|'+CurrentExtensionFilter,1)
        else if DefaultExtension <> '' then
          FFilename += DefaultExtension;
      end;
      if FileManager.FileExists(FFilename) and IsSaveDialog and OverwritePrompt then
      begin
        if QuestionDlg(rsSave, rsOverwriteFile, mtConfirmation, [mrOk, rsOkay, mrCancel, rsCancel],0) <> mrOk then exit;
      end;
      setlength(FSelectedFiles,1);
      FSelectedFiles[0] := FFilename;
      if ComboBox_FileExtension.ItemIndex <> -1 then
        FDefaultExtensions := FFileExtensions[ComboBox_FileExtension.ItemIndex];
      ModalResult:= mrOk;
    end;
end;

procedure TFBrowseImages.GoDirUp;
var dir: string;
  itemToSelect: string;
begin
  dir := DirectoryEdit1.Text;
  FileManager.RemoveLastPathElement(dir, itemToSelect);
  if dir = '' then
  begin
    FFileSystems:= FileManager.GetFileSystems;
    if length(FFileSystems)>0 then DirectoryEdit1.Text := ':';
    itemToSelect := '';
  end else
    DirectoryEdit1.Text := dir;
  ShellListView1.SetFocus;
  UpdatePreview('');
  InFilenameChange := true;
  Edit_Filename.text := '';
  InFilenameChange := false;
  SelectFile(itemToSelect);
end;

procedure TFBrowseImages.InitComboExt;
var extFilter: string;
  parsedExt: TStringList;
  i: integer;
begin
  if IsSaveDialog then
    extFilter := GetExtensionFilter([eoWritable],'')
  else
    extFilter := GetExtensionFilter([eoReadable],'');
  parsedExt := TParseStringList.Create(extFilter,'|');
  setlength(FFileExtensions, parsedExt.Count div 2);
  ComboBox_FileExtension.Clear;
  for i := 0 to high(FFileExtensions) do
  begin
    FFileExtensions[i] := parsedExt[i*2+1];
    ComboBox_FileExtension.Items.Add(parsedExt[i*2]);
  end;
  parsedExt.Free;
  if ComboBox_FileExtension.Items.Count > 0 then
    ComboBox_FileExtension.ItemIndex := 0;
end;

procedure TFBrowseImages.SetShellMask;
begin
  if ComboBox_FileExtension.ItemIndex >= 0 then
    ShellListView1.Mask := CurrentExtensionFilter;
end;

procedure TFBrowseImages.DeleteSelectedFiles;
var filesToDelete: array of string;
  i,deleteCount: integer;
begin
  deleteCount := 0;
  for i := 0 to ShellListView1.ItemCount-1 do
    if ShellListView1.ItemSelected[i] then
    begin
      if FileManager.FileExists(ShellListView1.ItemFullName[i]) then
        inc(deleteCount)
      else
      begin
        if ShellListView1.ItemFullName[i] = FPreviewFilename then UpdatePreview('');
        ShellListView1.ItemSelected[i] := false;
        if FileManager.IsDirectory(ShellListView1.ItemFullName[i]) then
        begin
          if FileManager.IsDirectoryEmpty(ShellListView1.ItemFullName[i]) then
          begin
            try
              FileManager.DeleteDirectory(ShellListView1.ItemFullName[i]);
              ShellListView1.RemoveItemFromList(i);
            except on ex:Exception do
              MessageDlg(rsDeleteFile, ex.Message, mtError, [mbOk], 0);
            end;
          end else
            MessageDlg(rsDeleteFile, rsDirectoryNotEmpty, mtError, [mbOk], 0);
        end;
      end;
    end;

  setlength(filesToDelete, deleteCount);
  deleteCount := 0;
  for i := 0 to ShellListView1.ItemCount-1 do
    if ShellListView1.ItemSelected[i] then
    begin
      filesToDelete[deleteCount] := ShellListView1.ItemFullName[i];
      inc(deleteCount);
    end;

  if deleteCount > 0 then
  begin
    self.Enabled := false;
    FileManager.MoveToTrash(self, filesToDelete, @OnDeleteConfirmation);
    self.Enabled := true;

    for i := ShellListView1.ItemCount-1 downto 0 do
      if ShellListView1.ItemSelected[i] then
      begin
        if not FileManager.FileExists(ShellListView1.ItemFullName[i]) then
        begin
          if ShellListView1.ItemFullName[i] = FPreviewFilename then
            UpdatePreview('');
          ShellListView1.RemoveItemFromList(i);
        end;
      end;
  end;
end;

procedure TFBrowseImages.SelectFile(AName: string);
var
  idx: Integer;
begin
  idx := ShellListView1.IndexByName(AName, {$IFNDEF WINDOWS}True{$ELSE}False{$ENDIF});
  if (idx <> -1) then
  begin
    ShellListView1.SelectedIndex := idx;
    ShellListView1.MakeItemVisible(idx);
    InFilenameChange := true;
    Edit_Filename.text := ShellListView1.ItemName[idx];
    InFilenameChange := false;
  end;
end;

procedure TFBrowseImages.PreviewValidate(ASender: TObject);
begin
  ValidateFileOrDir;
end;

function TFBrowseImages.GetChosenImage: TImageEntry;
begin
  result := FChosenImage;
  FChosenImage := TImageEntry.Empty;
end;

procedure TFBrowseImages.FreeChosenImage;
begin
  FreeAndNil(FChosenImage.bmp);
end;

initialization

IconCache := TStringList.Create;
IconCache.CaseSensitive := true;
IconCache.OwnsObjects := true;

finalization

IconCache.Free;

end.

