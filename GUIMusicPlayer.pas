program BasicReadWrite;
uses TerminalUserInput, SwinGame, sgTypes;

type Genre = (Pop, Classic, Rock, Country, Metal);

track = Record
	trackName: String;
	trackLocation: String;
end;

trackArray = array of track;



album = Record
	albumName: String;
	artistsName: String;
  ImageLocation: String;
	albumGenre: String;
	albumTracks: trackArray;
  NumberofTracks: Integer;
end;

albumArray = array of album;


var
  NumberofAlbums: Integer;



function ButtonClicked(btnX, btnY: Single; btnWidth, btnHeight: Integer): Boolean; 
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
  


procedure ReadLinesFromFile(var myAlbums: albumArray);
var 
	
	myTracks: trackArray;
	myFile: TextFile;
	MytextFile: String;
  a: Integer;
	b: Integer;

begin
 WriteLn('');
 MytextFile := ReadString('Enter File Name: ');
 AssignFile(myFile, MytextFile);
 Reset(myFile);


 ReadLn(myFile, NumberOfAlbums);
 WriteLn('The number of albums is: ', NumberOfAlbums);
 setLength(myAlbums, NumberOfAlbums);

 a := 0;
  while a < NumberOfAlbums do
  begin
  	ReadLn(myFile, myAlbums[a].albumName);
 	  ReadLn(myFile, myAlbums[a].artistsName);
    ReadLn(myFile, myAlbums[a].ImageLocation);
 	  ReadLn(myFile, myAlbums[a].AlbumGenre);
 	  ReadLn(myFile, myAlbums[a].NumberofTracks);
 	  setLength(myAlbums[a].albumTracks, myAlbums[a].NumberOfTracks);
  	setLength(myTracks, myAlbums[a].NumberOfTracks);
	  b := 0;
	  while b < myAlbums[a].NumberofTracks do
  		begin
  			ReadLn(myFile, myAlbums[a].albumTracks[b].trackName);
  			ReadLn(myFile, myAlbums[a].albumTracks[b].tracklocation);
  			b := b + 1;
  		end;
  	a := a + 1;
  end;
 Close(myFile);
 WriteLn('');
 WriteLn('Read file successfully. Please press Enter to return to menu');
 ReadLn();
end;



procedure PrintFileToTerminal(myAlbums: albumArray);
var
  a: Integer;
  b: Integer;


begin
  WriteLn('');
  WriteLn('The number of albums is: ', NumberOfAlbums);
  a := 0;
  while a < NumberOfAlbums do
  begin
    WriteLn('Album ', a+1, ': ');
    WriteLn('Album name is: ', myAlbums[a].albumName);
    WriteLn('Artists name is: ', myAlbums[a].artistsName);
    WriteLn('The Image Location is: ', myAlbums[a].ImageLocation);
    WriteLn('The genre is: ', myAlbums[a].AlbumGenre);
    WriteLn('The number of tracks is: ', myAlbums[a].NumberofTracks);
    b := 0;
    while b < myAlbums[a].NumberofTracks do
        begin
          WriteLn('Track ', b+1, ': ');
          WriteLn('Name of track is: ', myAlbums[a].albumTracks[b].trackName);
          WriteLn('Location of track is: ', myAlbums[a].albumTracks[b].tracklocation);
          b := b + 1;
      end;
    a := a + 1;
  end;
 WriteLn('');
 WriteLn('Files printed successfully. Please press Enter to return to menu');
 ReadLn();
end;



procedure playTrack(var myAlbums: albumArray);
var
  SelectedTrack: Integer;
  SelectedAlbum: Integer;
  clr: Color;

begin
  writeLn('');
  SelectedAlbum := ReadIntegerRange('Please enter the Album number you want to play: ', 1, length(myAlbums)+1);
  WriteLn('You have selected the Album: ', myAlbums[SelectedAlbum -1].albumName);

  writeLn('');
  SelectedTrack := ReadIntegerRange('Please enter the Track number you want played from the album: ', 1, length(myAlbums[SelectedAlbum -1].albumTracks) +1);
  WriteLn('You have selected the track: ', myAlbums[SelectedAlbum -1].albumTracks[SelectedTrack -1].trackName, ', from the Album ', myAlbums[SelectedAlbum -1].albumName);
  writeLn('Now playing...');


  OpenGraphicsWindow('Test Program for Button Click Code', 800, 600);
  clr := Colorblue;
  
  repeat 
    ClearScreen(clr); 
    DrawFramerate(0,0);                                          
    FillRectangle(ColorGrey, 50, 500, 100, 30); 
      DrawText('Stop', ColorBlack, 'arial.ttf', 14, 55, 505);
      FillRectangle(ColorGrey, 200, 500, 100, 30); 
      DrawText('Play/Pause', ColorBlack, 'arial.ttf', 14, 205, 505);
      FillRectangle(ColorGrey, 350, 500, 100, 30); 
      DrawText('Next', ColorBlack, 'arial.ttf', 14, 355, 505);

    
    RefreshScreen(); Processevents();

      iF ButtonClicked(50, 500, 100, 30) then
        begin clr := RandomRGBColor(255);
    end;    

    iF ButtonClicked(200, 500, 100, 30) then
        begin clr := RandomRGBColor(255);
    end;

    iF ButtonClicked(350, 500, 100, 30) then
        begin clr := RandomRGBColor(255);
    end;  
  until WindowCloseRequested();

  writeLn('');
  writeLn('Track successfully played. Please press Enter to return to menu');
  readLn();
end;



procedure AlbumEdit(myAlbums: albumArray);



procedure Menu(myAlbums: albumArray);
var
  Selected: Integer;

begin 
Selected := -1;
  while Selected <> 5 do
    begin
    writeLn('1. Read in Albums');
    writeLn('2. Display Albums');
    writeLn('3. Select an Album to play');
    writeLn('4. Update an existing Album');
    writeLn('5. Exit the application');

    Selected := ReadIntegerRange('Enter menu number: ', 1,5);

    if Selected = 1 then
      ReadLinesFromFile(myAlbums);
    if Selected = 2 then
      PrintFileToTerminal(myAlbums);
    if Selected = 3 then
      playTrack(myAlbums);
    if Selected = 4 then
      AlbumEdit(myAlbums);

    end;

end;



procedure Main();
var 
	myAlbums: albumArray;
begin
  Menu(myAlbums);
end;



begin
  Main();
end.