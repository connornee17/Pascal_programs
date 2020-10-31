program GameMain;
uses SwinGame, sysutils, sgTypes;

type
dataArray = array of Integer;



function ButtonClicked1(btnX, btnY: Single; btnWidth, btnHeight: Integer): Boolean; 
var 
  PositionX, 
  PositionY: Single; 
  ButtonMaxX, 
  ButtonMaxY: Single; 

begin 
  PositionX := MouseX(); 
  PositionY := MouseY(); 
  ButtonMaxX := btnX + btnWidth; 
  ButtonMaxY := btnY + btnHeight; 
  result := false; 

  if MouseClicked( LeftButton ) then 
    begin if (PositionX >= btnX) and (PositionX <= ButtonMaxX) and (PositionY >= btnY) and (PositionY <= ButtonMaxY) then 
      begin result := true;                                           
      end;                                                  
    end; 
end;



Procedure Swap(var dataA, dataB: Integer);
var
	temp: Integer;

begin
		temp := dataA;
		dataA := dataB;
		dataB := temp;
end;



Procedure PlotBars(data: dataArray);
var
	x: Integer;
	y: Integer;
	a: Integer;
begin
	DrawInterface();
    RefreshScreen();
	ClearScreen(ColorWhite);
    a := 0;
    x := 0;
    while a < 20 do
    begin
    	y := data[a];
    	FillRectangle(ColorRed, x, 600, 30, -y);
    	a := a + 1;
    	x := x + 30;
    end;
end;



Procedure ShowNumbersInList(data: dataArray);
var
a: Integer;
Item: String;

begin
	ListClearItems('NumbersList');
	a := 0;
  	while a < 20 do 
  	begin
  		Item := IntToStr(data[a]);
  	    ListAddItem('NumbersList', Item);
   	    a := a + 1;
   end;
end;



Procedure Sort(data: dataArray);
var
	i: Integer;
	j: Integer;
	k: Integer;

begin
	i := high(data);
	Repeat
		j := 0;
		for k := 1 to i do
			begin
				if data[k-1] > data[k] then
					begin
						Swap(data[k-1], data[k]);
						j := k;
					end;
				end;
		i := j;
		PlotBars(data);
		ShowNumbersInList(data);
		delay(200);
	until i = 0;
end;



Procedure PopulateArray(data: dataArray);
var
  a: Integer;
  Item: String;
begin
  a := 0;
  while a < 20 do
  begin
    data[a] := Rnd(ScreenHeight());
    a := a + 1;
  end;
 end;
  

  
Procedure DoSort();
var
data: dataArray;
  

begin
  setLength(data, 20);
  PopulateArray(data);
  ShowNumbersInList(data);
  PlotBars(data);
  Sort(data);
end;



Procedure InsertionSort(data: dataArray);
var
	a,
	b,
	index: Integer;

Begin
 For a := 0 to 20-1 do
  Begin
   index := data[a];
   b := a;
   While ((b > 0) AND (data[b-1] > index)) do
    Begin
     data[b] := data[b-1];
     b := b - 1;
    End;
   data[b] := index;
   PlotBars(data);
   ShowNumbersInList(data);
   delay(200);
  End;
  
End;
		


Procedure DoMySort();
var
data: dataArray;

begin
	setLength(data, 20);
	PopulateArray(data);
	ShowNumbersInList(data);
	PlotBars(data);
	InsertionSort(data);
end;




Procedure Main();
begin
  OpenGraphicsWindow('Sort Visualiser', 800, 600);
  
  LoadResourceBundle( 'NumberBundle.txt' );
  
  GUISetForegroundColor( ColorBlack );
  GUISetBackgroundColor( ColorWhite );
  
  ShowPanel( 'NumberPanel' );
  
  ClearScreen(ColorWhite);
  

    Repeat 
      ProcessEvents();
      UpdateInterface();
      DrawInterface();
      RefreshScreen(60);

      FillRectangle(ColorGrey, 20, 20, 70, 30);
      DrawText('My Sort', ColorBlack, 'arial.ttf', 14, 22, 22);

      if ButtonClicked1(20,20,70,30) then
      	begin
      		DoMySort();
      	end;

      if ButtonClicked('SortButton') then
        begin
          DoSort();
        end;

    Until WindowCloseRequested();
end;



begin
  Main();
end.