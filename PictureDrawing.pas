program PictureDrawing;
uses SwinGame, sgTypes;

begin
	OpenGraphicsWindow('House Drawing', 800, 600);
	ClearScreen(ColorWhite);

	fillRectangle(ColorBlue, 100, 100, 100, 50);
	fillTriangle(ColorGreen, 50, 50, 50, 100, 150, 200);
	fillEllipse(ColorRed, 200, 100, 500, 100);
	fillCircle(ColorPurple, 300, 400, 200);

	RefreshScreen();
	Delay(5000);
end.
