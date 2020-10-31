program GameMain;
uses SwinGame, sgTypes; 

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

Procedure Main();
var
  clr: Color;

Begin
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
end;




begin 
	main(); 
end.
