program ClassicSpaceShooter;
uses SwinGame, sgTypes, SysUtils;


const 
	PlayerSpeed = 5;
	EnemySpeed = 2;
	PlayerBulletSpeed = 7;
	EnemyBulletSpeed = 5;


Type

	PlayerData = Record
		bmp: Bitmap;
		x, y: Integer;
	end;

	EnemyData = Record
		bmp: Bitmap;
		x, y: Integer;
	end;

	PlayerBulletData = Record
		bmp: Bitmap;
		x,y: Integer;
	end;

	EnemyBulletData = Record
		bmp: Bitmap;
		x,y: Integer;
	end;


	SpaceShooterData = Record
		CurrentScore: Integer;
		Player: PlayerData;
		PlayerBullets: array of PlayerBulletData;
		Enemies: array of  EnemyData;
		EnemyBullets: array of EnemyBulletData;
		time1: Timer;
		time2: Timer;
	end;

var
MyFile: TextFile;
HighScore: Integer;


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



Procedure LoadResources();
begin
	LoadBitmapNamed('Player', 	'Player.png');
	LoadBitmapNamed('Enemy', 	'Enemy.png');
	LoadBitmapNamed('PlayerBullet', 'PlayerBullet.png');
	LoadBitmapNamed('EnemyBullet', 	'EnemyBullet.png');
end;



Procedure CreatePlayerBullet(var game: SpaceShooterData);
	var numBullets: Integer;
begin
	numBullets := Length(game.PlayerBullets);
	numbullets += 1;

	SetLength(game.playerBullets, numBullets);
	game.playerBullets[High(game.playerBullets)].bmp := BitmapNamed('PlayerBullet');
	game.PlayerBullets[High(game.playerBullets)].x := game.Player.x +13;
    game.PlayerBullets[High(game.playerBullets)].y := game.Player.y -20;


end;



Procedure CreateEnemyBullets(var game: SpaceShooterData);
		var numEnemyBullets: Integer;
begin
	numEnemyBullets := Length(game.EnemyBullets);
	numEnemyBullets += 1;

	SetLength(game.EnemyBullets, numEnemyBullets);
	game.EnemyBullets[High(game.EnemyBullets)].bmp := BitmapNamed('EnemyBullet');
	game.EnemyBullets[High(game.EnemyBullets)].x := Rnd(ScreenWidth());;
    game.EnemyBullets[High(game.EnemyBullets)].y := -30;
end;



Procedure CreateEnemy(var game: SpaceShooterData);
	var numEnemies: Integer;
begin
	numEnemies := Length(game.Enemies);
	numEnemies += 1;

	SetLength(game.Enemies, numEnemies);
	game.Enemies[High(game.Enemies)].bmp := BitmapNamed('Enemy');
	game.Enemies[High(game.Enemies)].x := Rnd(ScreenWidth());;
    game.Enemies[High(game.Enemies)].y := -30;
end;



Procedure DrawPlayer(var game: SpaceShooterData);
begin
	DrawBitmap(game.Player.bmp, game.Player.x, game.Player.y);
end;



Procedure WrapPlayer(bmp: Bitmap; var x: Integer);
begin
	if x < -BitmapWidth(bmp) then
	begin
		x := ScreenWidth();
	end
	else if x > ScreenWidth() then
	begin
		x := -BitmapWidth(bmp);
	end;
end;



Procedure PlayerInput(var game: SpaceShooterData);
begin
	ProcessEvents();
	if KeyDown(RightKey) then game.Player.x += PlayerSpeed;
	if KeyDown(LeftKey) then game.Player.x -= PlayerSpeed;
	if KeyReleased(SpaceKey) then CreatePlayerBullet(game);
	WrapPlayer(game.Player.bmp, game.Player.x);
end;



Procedure SetupGame(var game: SpaceShooterData);
begin
	game.Player.bmp := BitmapNamed('Player');
	game.Player.x := Round((ScreenWidth() - BitmapWidth(game.Player.bmp)) / 2);
    game.Player.y := Round((ScreenHeight() - BitmapHeight(game.Player.bmp)) / 2 +220);
    game.CurrentScore := 0;
    SetLength(game.playerBullets, 0);
    SetLength(game.Enemies, 0);
    game.time1 := CreateTimer();
    StartTimer(game.time1);
    game.time2 := CreateTimer();
    StartTimer(game.time2);
end;



Procedure DrawEnemyBullets(var game: SpaceShooterData);
var 
	i: Integer;
begin
	i := 0;
	while i < Length(game.EnemyBullets) do
	begin
		DrawBitmap(game.EnemyBullets[i].bmp, game.EnemyBullets[i].x, game.EnemyBullets[i].y);
		i := i + 1;
	end;
end;



Procedure DrawBullets(var game: SpaceShooterData);
var
	i: Integer;
begin
	i := 0;
	while i < Length(game.playerBullets) do 
		begin
		DrawBitmap(game.PlayerBullets[i].bmp, game.PlayerBullets[i].x, game.PlayerBullets[i].y);
		i := i + 1;
		end;
end;



Procedure DrawEnemies(var game: SpaceShooterData);
var 
	i: Integer;
begin
	i := 0;
	while i < Length(game.Enemies) do
	begin
		DrawBitmap(game.Enemies[i].bmp, game.Enemies[i].x, game.Enemies[i].y);
		i := i + 1;
	end;
end;



Procedure DrawGame(var game: SpaceShooterData);
begin
	ClearScreen(ColorBlack);
	DrawText('Score: ' + IntToStr(game.CurrentScore), ColorWhite, 0, 0);
	DrawText('HighScore: ' + IntToStr(HighScore), ColorWhite, 0, 20);
	DrawPlayer(game);
	DrawBullets(game);
	DrawEnemies(game);
	DrawEnemyBullets(game);
end;



Procedure UpdateEnemyBullets(var game: SpaceShooterData);
var
	i, j, k: Integer;
begin
	i := 0;
	k := 0;
	while i < Length(game.EnemyBullets) do
	begin
		if game.EnemyBullets[i].y > 620 then
		begin
			j := 0;
			while j < Length(game.EnemyBullets) do
			begin
				game.EnemyBullets[j] := game.EnemyBullets[j + 1];
				j += 1;
			end;
			k := Length(game.EnemyBullets);
			k -= 1;
			SetLength(game.EnemyBullets, k);
		end;
		i += 1;
	end;

	i := 0;
	while i < Length(game.EnemyBullets) do
	begin
		game.EnemyBullets[i].y += EnemyBulletSpeed;
		i := i + 1;
	end;
end;



Procedure UpdateBullets(var game: SpaceShooterData);
var
	i, j, k: Integer;
begin
	i := 0;
	k := 0;
	while i < Length(game.PlayerBullets) do
	begin
		if game.PlayerBullets[i].y < -20 then
		begin
			j := 0;
			while j < Length(game.PlayerBullets) do
			begin
				game.PlayerBullets[j] := game.PlayerBullets[j + 1];
				j += 1;
			end;
			k := Length(game.PlayerBullets);
			k -= 1;
			SetLength(game.PlayerBullets, k);
		end;
		i += 1;
	end;

	i := 0;
	while i < Length(game.PlayerBullets) do
	begin
		game.PlayerBullets[i].y -= PlayerBulletSpeed;
		i := i + 1;
	end;
end;



Procedure UpdateEnemies(var game: SpaceShooterData);
var
	i, j, k: Integer;
begin
	i := 0;
	k := 0;
	while i < Length(game.Enemies) do
	begin
		if game.Enemies[i].y > 620 then
		begin
			j := 0;
			while j < Length(game.Enemies) do
			begin
				game.Enemies[j] := game.Enemies[j + 1];
				j += 1;
			end;
			k := Length(game.Enemies);
			k -= 1;
			SetLength(game.Enemies, k);
		end;
		i += 1;
	end;

	i := 0;
	while i < Length(game.Enemies) do
	begin
		game.Enemies[i].y += EnemySpeed;
		i := i + 1;
	end;
end;



function PlayerBulletbmpCollison(var PlayerBullets: PlayerBulletData; var Enemies: EnemyData): Boolean;
begin
	result := BitmapCollision(PlayerBullets.bmp, PlayerBullets.x, PlayerBullets.y, Enemies.bmp, Enemies.x, Enemies.y);
end;
//Returns true if Players bullet collides with enemy.


Procedure PlayerBulletEnemyCollision(var game: SpaceShooterData; EnemyNo: Integer; BulletNo: Integer);
var 
	k, j: Integer;
	a, b: Integer;

begin
	j := EnemyNo;
	if (High(game.Enemies) > 0) then
	begin
	while j < High(game.Enemies) do
		begin
			game.Enemies[j] := game.Enemies[j + 1];
			j += 1;
		end;
		k := Length(game.Enemies);
		k -= 1;
		SetLength(game.Enemies, k);
		game.CurrentScore := game.CurrentScore + 50;
	end;
	b:= BulletNo;
	if (High(game.PlayerBullets) >= 0) then
	begin
	while b < High(game.PlayerBullets) do
		begin
			game.PlayerBullets[b] := game.PlayerBullets[b + 1];
			b += 1;
		end;
		a := Length(game.PlayerBullets);
		a -= 1;
		SetLength(game.PlayerBullets, a);
	end;	
end;



function PlayerbmpEnemyCollison(var Player: PlayerData; var Enemies: EnemyData): Boolean;
begin
	result := BitmapCollision(Player.bmp, Player.x, Player.y, Enemies.bmp, Enemies.x, Enemies.y);
end;
//Returns true if Player and enemy collide



function PlayerbmpEnemyBulletsCollison(var Player: PlayerData; var EnemyBullets: EnemyBulletData): Boolean;
begin
	result := BitmapCollision(Player.bmp, Player.x, Player.y, EnemyBullets.bmp, EnemyBullets.x, EnemyBullets.y);
end;
//Returns true if Player and enemy collide



Procedure GameOverScreen(var game: SpaceShooterData);
Begin
	if (game.CurrentScore > HighScore) then
	begin
		AssignFile(myFile, 'highscore.dat');
		ReWrite(MyFile);
		WriteLn(MyFile, game.CurrentScore);
		Close(myFile);
	end;
	repeat 
	ProcessEvents();
	ClearScreen(ColorBlack);
	DrawText('Your score was: ' + IntToStr(game.CurrentScore), ColorWhite, 'arial.ttf', 20, 115, 250);
	DrawText('GAME OVER!', ColorWhite, 'arial.ttf', 25, 125, 200);
	
	if (game.CurrentScore > HighScore) then
	begin
		DrawText('NEW HIGH SCORE!: ' + IntToStr(game.CurrentScore), ColorWhite, 'arial.ttf', 20, 90, 300);
	end
	else if (game.CurrentScore <= HighScore) then
	begin
		DrawText('Current high score is: ' + IntToStr(HighScore), ColorWhite, 'arial.ttf', 20, 87, 300);
	end;

	RefreshScreen(60);
	until WindowCloseRequested();
end;


Procedure UpdateGame(var game: SpaceShooterData);
var
	i: Integer;
	j: Integer;

begin
	// If any of the players bullets collide with an enmey.
	for i := 0 to High(game.Enemies) Do
	begin
		for j := 0 to High(game.PlayerBullets) Do
		Begin
			if PlayerBulletbmpCollison(game.PlayerBullets[j], game.Enemies[i]) then
			begin
				PlayerBulletEnemyCollision(game, i, j);
			end;
		end;
	end;

	// If any of the enemies collide with the player.
	for i := 0 to High(game.Enemies) Do
	Begin
		if PlayerbmpEnemyCollison(game.Player, game.Enemies[i]) then
		begin
			GameOverScreen(game);
		end;
	end;

	//If any of the Enemy Bullets collide with the player.
	for i := 0 to High(game.EnemyBullets) Do
	Begin
		if PlayerbmpEnemyBulletsCollison(game.Player, game.EnemyBullets[i]) then
		begin
			GameOverScreen(game);
		end;
	end;
	

	UpdateBullets(game);
	UpdateEnemies(game);
	UpdateEnemyBullets(game);

	if TimerTicks(game.time2) > 750 then
	begin
		ResetTimer(game.time2);
		CreateEnemyBullets(game);
	end;
	
	if TimerTicks(game.time1) > 1000 then
	begin
		ResetTimer(game.time1);
		CreateEnemy(game);
	end;
end;



Procedure MainMenu(var game: SpaceShooterData);
begin
	ProcessEvents();
	ClearScreen(ColorBlack);
	DrawText('Score: ' + IntToStr(game.CurrentScore), ColorWhite, 0, 0);
	DrawText('HighScore: ' + IntToStr(HighScore), ColorWhite, 0, 20);
	FillRectangle(ColorWhite, 150, 300, 100, 30);
	FillRectangle(colorWhite, 103, 350, 185, 30);
	DrawText('START', ColorBlack, 'arial.ttf', 14, 177, 305);
	DrawText('RESET HIGH SCORE', ColorBlack, 'arial.ttf', 14, 130, 355);
	DrawText('CLASSIC SPACE SHOOTER!', ColorWhite, 'arial.ttf', 25, 35, 200);
end;



Procedure OpenFile();
begin
	AssignFile(myFile, 'highscore.dat');
	Reset(myFile);
	ReadLn(myFile, HighScore);
	Close(myFile);
end;



Procedure Main();
var
	GameData: SpaceShooterData;

begin
	openGraphicsWindow('Classic Space Shooter', 400, 600);
	LoadResources();
	SetupGame(GameData);
	OpenFile();

		repeat
		MainMenu(GameData);
		if ButtonClicked(103, 350, 185, 30) then
		begin
			AssignFile(myFile, 'highscore.dat');
			ReWrite(MyFile);
			WriteLn(MyFile, 0);
			Close(myFile);
			OpenFile();
		end;
		if ButtonClicked(150, 300, 100, 30) then
		begin
			repeat
			PlayerInput(GameData);
			UpdateGame(GameData);
			DrawGame(GameData);
			RefreshScreen(60);
			until WindowCloseRequested();
		end;
		RefreshScreen(60);
		until WindowCloseRequested();
end;


begin
	Main();
end.