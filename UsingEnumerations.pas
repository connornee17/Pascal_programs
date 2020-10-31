program UsingEnumerations;
uses TerminalUserInput;

type Genre = (Pop, Classic, Rock);

album = Record
	artistName: String;
	albumGenre: Genre;
	folderLocation: String;
	yearReleased: Integer;
end;

function readData(): album;

var g: Genre;
	selection: Integer;
	myAlbum: album;
	
begin

	selection := ReadIntegerRange('Select a genre, Pop = 1, Classic = 2, Rock = 3: ', 1, 3);
	// Now you need to tell the compiler that you want to treat this
	// integer as a thing of type Genre (not of type integer) so you
	// need to 'cast' it to the Genre type:

	// Also enumerations start at 0 - we asked above for a number from 1 - 3
	// so we need to subtrat 1.
	g := Genre(selection -1);

	Writeln(' You selected: ', g);
	myAlbum.albumGenre := g;
	myAlbum.artistName := readString('Enter artist''s name: ');
	myAlbum.folderLocation := readString('Enter folder location: ');

	myAlbum.yearReleased := readInteger('Enter year album was released: ');
	while (myAlbum.yearReleased <0) or (myAlbum.yearReleased >2018) do
	begin
		writeLn('That is not a valid year');
		myAlbum.yearReleased := readInteger('Enter year album was released: ')	
	end;

	result := myAlbum;

	
end;

procedure printRecord(myAlbum: album);

begin
	writeLn('You have selected the genre: ', myAlbum.albumGenre, ' and the Artist''s name: ', myAlbum.artistName, ' in the year: ', myAlbum.yearReleased, ' in the folder location: ', myAlbum.folderLocation);
end;

procedure Main();

var myAlbum: album;

begin

	myAlbum := readData();
	printRecord(myAlbum);

end;


begin
	Main();
end.