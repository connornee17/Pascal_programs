//
// Game in which the player seeks out target food
//

program FoodHunter;
uses SwinGame, sgTypes, SysUtils;

const 
	SPEED = 3;

type
	//
	// There are 4 kinds of food in the game
	//
	FoodKind = ( Chips, Burger, Icecream, Pizza );


	//
	// Each item of food on the screen has these values
	//
	FoodData = record
		kind : FoodKind;	// a kind
		bmp: Bitmap;		// the actual bitmap
		x, y: Integer;		// a location
		dx, dy: Integer;	// an x and y movement
	end;

	//
	// The Hunter seeks food - this is the associated data
	//
	HunterData = record
		x, y: Integer;			// the location of the hunter
		bmp: Bitmap;			// the hunter's bitmap
		targetKind: FoodKind;	// the kind of food the hunter is after
	end;

	//
	// The game's overall data
	//
	FoodHunterData = record
		score: Integer;			// The score +1 for target food -1 for others
		hunter: HunterData;		// There is one hunter
		food: array of FoodData;			// There is an array of food
		time: Timer;			// Keeps track to time
	end;

//
// Load the game's resources
//
procedure LoadResources();
begin
	LoadBitmapNamed('Hunter', 	'Hunter.png');

	LoadBitmapNamed('Chips', 	'Chips.png');
	LoadBitmapNamed('Burger', 	'Burger.png');
	LoadBitmapNamed('Icecream', 'Icecream.png');
	LoadBitmapNamed('Pizza', 	'Pizza.png');

	LoadBitmapNamed('SmallChips', 	'SmallChips.png');
	LoadBitmapNamed('SmallBurger', 	'SmallBurger.png');
	LoadBitmapNamed('SmallIcecream', 'SmallIcecream.png');
	LoadBitmapNamed('SmallPizza', 	'SmallPizza.png');

	LoadSoundEffectNamed('Yum', 'Yum.wav');
	LoadSoundEffectNamed('Yuk', 'Yuk.wav'); 
end;

//
// Gets the bitmap for indicated food kind
//
function FoodBitmap(kind: FoodKind): Bitmap;
begin
	case kind of 
		Chips:		result := BitmapNamed('Chips');
		Burger:		result := BitmapNamed('Burger');
		Icecream:	result := BitmapNamed('Icecream');
		Pizza:		result := BitmapNamed('Pizza');
	else
		result := nil;
	end;
end;

//
// Gets the small bitmap for indicated food kind - for target
//
function SmallFoodBitmap(kind: FoodKind): Bitmap;
begin
	case kind of 
		Chips:		result := BitmapNamed('SmallChips');
		Burger:		result := BitmapNamed('SmallBurger');
		Icecream:	result := BitmapNamed('SmallIcecream');
		Pizza:		result := BitmapNamed('SmallPizza');
	else
		result := nil;
	end;
end;

//
// Randomly pick a kind of food
//
function RandomFoodKind() : FoodKind;
begin
	result := FoodKind(Rnd(4));
end;

//
// Generate a random food item
//
function RandomFood() : FoodData;
begin
	result.kind := RandomFoodKind();
	result.bmp := FoodBitmap(result.kind);
	
	result.x := Rnd(ScreenWidth() - BitmapWidth(result.bmp));
	result.y := Rnd(ScreenHeight() - BitmapHeight(result.bmp));

	result.dx := Round(Rnd() * 4 - 2); // -2 to +2
	result.dy := Round(Rnd() * 4 - 2); // -2 to +2
end;

//
// Draw the food to the screen
//
procedure DrawFood(const food: FoodData);
begin
	DrawBitmap(food.bmp, food.x, food.y);
end;

//
// Draw the Hunter and their target food
//
procedure DrawHunter(const hunter: HunterData);
var
	foodBmp: Bitmap;
	foodX, foodY: Single;
begin
	DrawBitmap(hunter.bmp, hunter.x, hunter.y);
	
	foodBmp := SmallFoodBitmap(hunter.targetKind);

	foodX := hunter.x + (BitmapWidth(hunter.bmp) - BitmapWidth(foodBmp)) / 2;
	foodY := hunter.y + (BitmapHeight(hunter.bmp)) / 2;

	DrawBitmap(foodBmp, foodX, foodY);
end;

//
// Draw the whole game - the score, hunter, and all of the food
//
procedure DrawGame(var game: FoodHunterData);
var
	i: Integer;
begin
	ClearScreen(ColorWhite);
	DrawText('Score: ' + IntToStr(game.score), ColorBlack, 0, 0);
	DrawHunter(game.hunter);

	
	for i := 0 to High(game.food) Do
	begin
	DrawFood(game.food[i]);
	end;

	RefreshScreen(60);
end;

//
// Wrap the passed in "character" - allows the character to
// pass from the right of the screen to the left etc.
//
// Pass in the character's bitmap, and its x and y variables
//
procedure WrapCharacter(bmp: Bitmap; var x, y: Integer);
begin
	if x < -BitmapWidth(bmp) then //offscreen left
	begin
		x := ScreenWidth();
	end
	else if x > ScreenWidth() then //offscreen right
	begin
		x := -BitmapWidth(bmp);
	end;

	if y < -BitmapHeight(bmp) then //offscreen top
	begin
		y := ScreenHeight();
	end
	else if y > ScreenHeight() then //offscreen bottom
	begin
		y := -BitmapHeight(bmp);
	end;
end;

//
// Update the passed in food item
//
procedure UpdateFood(var food: FoodData);
begin
	food.x += food.dx;
	food.y += food.dy;
	WrapCharacter(food.bmp, food.x, food.y);
end;

//
// Has the food hit the hunter?
//
function FoodHitHunter(const food: FoodData; const hunter: HunterData): Boolean;
begin
	result := BitmapCollision(food.bmp, food.x, food.y, hunter.bmp, hunter.x, hunter.y);
end;

//
// Check collisions between a food item and the hunter - adjust score when hit
//
procedure CheckFoodCollision(var food: FoodData; const hunter: HunterData; var score:Integer);
begin
	if FoodHitHunter(food, hunter) then
	begin
		if food.kind = hunter.targetKind then
		begin
			PlaySoundEffect('Yum');
			score += 1;
		end
		else
		begin
			PlaySoundEffect('Yuk');
			score -= 1;
		end;

		food := RandomFood();
	end;
end;

//
// Update the game - move all the food and check for collisions, update target food
//
procedure UpdateGame(var game: FoodHunterData);
var
	i: Integer;
begin

	for i := 0 to High(game.food) Do
	begin
	UpdateFood(game.food[i]);
	CheckFoodCollision(game.food[i], game.hunter, game.score);
	end;

	if TimerTicks(game.time) > 5000 then
	begin
		ResetTimer(game.time);
		game.hunter.targetKind := RandomFoodKind();
	end;
end;

//
// Move the hunter
//
procedure HandleInput(var game: FoodHunterData);
begin
	ProcessEvents();

	if KeyDown(LeftKey) then game.hunter.x -= SPEED;
	if KeyDown(RightKey) then game.hunter.x += SPEED;
	if KeyDown(UpKey) then game.hunter.y -= SPEED;
	if KeyDown(DownKey) then game.hunter.y += SPEED;

	WrapCharacter(game.hunter.bmp, game.hunter.x, game.hunter.y);
end;

//
// Initialise all of the food in the game
//
procedure SetupFood(var game: FoodHunterData; numFood: Integer);
var
	i: Integer;
begin
	setLength(game.food,numFood);

	for i := 0 to numFood-1 Do
	begin
	game.food[i] := RandomFood();
	end;
end;

//
// Initialise the game - the food, hunter, score, and time
//
procedure SetupGame(var game: FoodHunterData);
begin
    SetupFood(game, 5);
    
    game.score := 0;

    game.hunter.bmp := BitmapNamed('Hunter');
    game.hunter.x := Round((ScreenWidth() - BitmapWidth(game.hunter.bmp)) / 2);
    game.hunter.y := Round((ScreenHeight() - BitmapHeight(game.hunter.bmp)) / 2);
	game.hunter.targetKind := FoodKind(Rnd(4));

    game.time := CreateTimer();
    StartTimer(game.time);
end;

procedure Main();
var
	mainGameData: FoodHunterData;
begin
	OpenAudio();
    OpenGraphicsWindow('Food Hunter', 600, 600);
    LoadDefaultColors();
    LoadResources();

	SetupGame(mainGameData);

    repeat
    	HandleInput(mainGameData);
    	UpdateGame(mainGameData);
    	DrawGame(mainGameData);
    until WindowCloseRequested();
end;

begin
	Main();
end.
