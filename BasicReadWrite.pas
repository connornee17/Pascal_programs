program BasicReadWrite;

procedure WriteLines(var myFile: TextFile);
begin
  WriteLn(myFile, 'this is my test file');
  WriteLn(myFile, 10);
end;

procedure ReadLinesToTerminal(var myFile: TextFile);
var message: String;
    number: Integer;
begin
 ReadLn(myFile, message);
 ReadLn(myFile, number);
 WriteLn('Text is: ', message, ' Number is: ', number);
 ReadLn();
end;

procedure Main();
var myFile: TextFile;
begin
  AssignFile(myFile, 'mytestfile.dat');
  ReWrite(myFile);
  WriteLines(myFile);
  Close(myFile);

  AssignFile(myFile, 'mytestfile.dat');
  Reset(myFile);
  ReadLinesToTerminal(myFile);
  Close(myFile);
end;

begin
  Main();
end.

