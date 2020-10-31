program SimplePolitics;
uses TerminalUserInput;

Const YEAR_TRUMP_ELECTED = 2016;

procedure Main();
var
	userName: String; 
	yearBorn: Integer; 
	ageWhenTrumpElected: Integer;
	brexit: Boolean;
begin
     WriteLn('Please enter your name: ');
     ReadLn(userName);
     WriteLn('What year were you born?: ');
     ReadLn(yearBorn);
     ageWhenTrumpElected := YEAR_TRUMP_ELECTED - yearBorn;
     WriteLn(userName, ' you were ', ageWhenTrumpElected, ' years old when Trump was elected');
     WriteLn('Press Enter to Continue');
     ReadLn();
     brexit := readBoolean('are you a Brexit supporter? please type yes or no: ');
     if (brexit)  then 
     	writeLn(userName, ' is a brexit supporter')
     else
     	writeLn(userName, ' is not a brexit supporter');
     readLn();
end;

begin
    Main();
end.

