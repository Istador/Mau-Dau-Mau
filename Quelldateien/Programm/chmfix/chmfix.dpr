program chmfix;
{
  author:     Robin Christopher Ladiges
  website:    http://blackpinguin.de/
  project:    Mau Dau Mau
  binary:     chmfix.exe
  unit:       chmfix
  file:       chmfix.dpr
  filepath:   .\chmfix\
  year:       2008/2009
  desc:       This file fix a problem that happen with the Microsoft Update
              KB896358, witch prohibit uninstalled chm-files to open subpages.
              This fix change a registry entry to permit maudaumau.chm
              to open subpages.

  license:    creative commons by-nc-sa 3.0 germany
   look out license.txt in this folder
   human-readable summary : http://creativecommons.org/licenses/by-nc-sa/3.0/de/
}


{$APPTYPE CONSOLE}

uses
  SysUtils,
  registry,
  windows;



function registry_update(chmfile,keyaddr : string):boolean;
var
 regist: TRegistry;
 text,key: string;
begin
 text:='';
 result:=true;
 regist:=TRegistry.Create;
 regist.RootKey:=HKEY_LOCAL_MACHINE;
 regist.OpenKey(keyaddr,true);
 WriteLn('  HKEY_LOCAL_MACHINE\'+keyaddr+'\');
 try
  if (regist.ReadInteger('MaxAllowedZone') <> 1) then
   begin
    regist.WriteInteger('MaxAllowedZone',1);
    result:=false;
    WriteLn('  - MaxAllowedZone updated.');
   end;
 except
  regist.WriteInteger('MaxAllowedZone',1);
  result:=false;
  WriteLn('  - MaxAllowedZone added.');
 end;
 try
  key:=regist.ReadString('UrlAllowList');
  text:=key;
  if text='' then text:=chmfile+';'+'file://;'
  else
   begin
    if pos(chmfile+';',text) = 0 then text:=chmfile+';'+text;
    if pos('file://;',text) = 0 then
     begin
      if text[length(text)] <> ';' then text:=text+';';
      text:=text+'file://;';
     end;
   end;
  if (key <> text) then
   begin
    regist.writestring('UrlAllowList',text);
    result:=false;
    if key = '' then WriteLn('  - UrlAllowList added.')
    else WriteLn('  - UrlAllowList updated.');
   end;
 except
  text:=chmfile+';'+'file://;';
  regist.writestring('UrlAllowList',text);
  result:=false;
  WriteLn('  - UrlAllowList added.');
 end;
 if result then WriteLn('  - Nothing to update.');
 regist.Free;
end;


var chmfile:string;
begin
 WriteLn('');
 WriteLn('  ############################################');
 WriteLn('  # Mau Dau Mau Help Registry Fix v 1.2.8.93 #');
 WriteLn('  # by Robin Ladiges http://blackpinguin.de/ #');
 WriteLn('  ############################################');
 WriteLn('');
 chmfile:=ExtractFilePath(ParamStr(0))+'maudaumau.chm';
 if FileExists(chmfile) then
  begin
   registry_update(chmfile,'SOFTWARE\Microsoft\HTMLHelp\1.x\HHRestrictions');
   registry_update(chmfile,'SOFTWARE\Microsoft\HTMLHelp\1.x\ItssRestrictions');
  end
 else
  WriteLn('ERROR: maudaumau.chm not found.');
end.
