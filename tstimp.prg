/*
 Compilar usando: Hbmk2 exemplo.prg -lhbwin
*/
#Include "minigui.ch"
#include "winprint.ch"
#include "hmg.ch"

/*

   local cEol := Hb_Eol()

   

     START PRINTDOC STOREJOBDATA aJobData

      START PRINTPAGE


      @ prow()+1,pcol()+25 PRINT IMAGE "max.jpg" ;
         WIDTH 50 ;
         HEIGHT 30

      @ Prow()+0, PCol() print "E" + cEol // envia para a impressora
      @ Prow()+0, PCol() print "Q" + cEol   // esvazia a memoria da impressora
     
      END PRINTPAGE


   END PRINTDOC

RETURN
*/
Function Main()

 c_peca :="00002" 
 c_nome :="MAXITHERMIC"
 c_npeca:="00002"
 c_cores:="BRANCO"
 c_valid:="24 meses"
 c_nlote:="N. Lote"
 c_ndata:="Data Fabricacao"
 c_lote :="856"
 c_data := "13/04/2016"

 EtqGondola()
 
Return Nil

Function EtqGondola()
 Local cCtr := chr(2), cEol := Hb_Eol(), cDescProd
 Local cPrinter, cFileImp:="Etiqueta_n.Txt"

 for i:=1 to 2

 START PRINTDOC STOREJOBDATA aJobData
  
 START PRINTPAGE

 @ prow()+1,pcol()+25 PRINT IMAGE "max.jpg" ;
           WIDTH 50 ;
           HEIGHT 30
 
 @ Prow()+1, PCol() Print chr(2) + "O0220"
 @ Prow()+1, PCol() Print chr(2) + "m"
 @ Prow()+1, PCol() Print chr(2) + "M0300"
 @ Prow()+1, PCol() Print chr(2) + "c0000"
 @ Prow()+1, PCol() Print chr(2) + "f500"
 @ Prow()+1, PCol() Print chr(2) + "e"
 @ Prow()+1, PCol() Print chr(2) + "LC0000"
 @ Prow()+1, PCol() Print "H14"
 @ Prow()+1, PCol() Print "D11"
 @ Prow()+1, PCol() Print "SC"
 @ Prow()+1, PCol() Print "PC"
 @ Prow()+1, PCol() Print "R0000"
 @ Prow()+1, PCol() Print "z"
 @ Prow()+1, PCol() Print "W"
 

///         Y=linha   X=coluna
///1900 004 0190      0010

 @ Prow()+0, PCol() Print "190000406000020" + "-------------------------------------------------------------------------" + cEol 

 @ Prow()+0, PCol() Print "190000405700020" + c_PECA + "  |  " +c_nome + cEol // titulo em fonte pequena
 
 @ Prow()+0, PCol() Print "190000405400020" + "-------------------------------------------------------------------------" + cEol 

 @ Prow()+0, PCol() Print "190000405100020" + c_cores + cEol 
 @ Prow()+0, PCol() Print "190000405100400" + "|Validade : "+ c_valid + cEol 

 @ Prow()+0, PCol() Print "190000404800020" + "-------------------------------------------------------------------------" + cEol 

 @ Prow()+0, PCol() Print "190000404500020" + "N.Lote" + cEol 
 @ Prow()+0, PCol() Print "190000404500400" + "|Data Fabricacao" + cEol 

 @ Prow()+0, PCol() Print "190000404200020" + "-------------------------------------------------------------------------" + cEol 

 @ Prow()+0, PCol() Print "190000403900020" + c_lote + cEol 
 @ Prow()+0, PCol() Print "190000403900400" + "|"+ c_data + cEol 

 @ Prow()+0, PCol() Print "190000403600020" + "-------------------------------------------------------------------------" + cEol 

 @ Prow()+0, PCol() Print "190000403300020" + "C N P J :" + cEol
 @ Prow()+0, PCol() Print "190000403000020" + "-------------------------------------------------------------------------" + cEol 

 @ Prow()+0, PCol() Print "190000402700020" + "C R Q   :" + cEol
 @ Prow()+0, PCol() Print "190000402400020" + "-------------------------------------------------------------------------" + cEol  

 @ Prow()+0, PCol() Print "E" + cEol // envia para a impressora
 @ Prow()+0, PCol() Print "Q" + cEol   // esvazia a memoria da impressora

 @ Prow()+0, PCol() print "E" + cEol // envia para a impressora
 
 @ Prow()+0, PCol() print "Q" + cEol   // esvazia a memoria da impressora
     
 END PRINTPAGE

 END PRINTDOC

 next

Return 

 
//////////////////////////////
// This function prints the entire file in one call to PrintFileRaw()
FUNCTION WinPrintRaw(cPrinter,cFileName,cDocumentName)
//////////////////////////////
  LOCAL nPrn:= -1, cMess:= "WinPrintRaw(): "

  IF !EMPTY(cFilename)
    IF (nPrn := PrintFileRaw(cPrinter,cFileName,cDocumentName)) < 0
      DO CASE
      CASE nPrn = -1
        Alert(cMess+"Incorrect parameters passed to function")
      CASE nPrn = -2
        Alert(cMess+"WINAPI OpenPrinter() call failed")
      CASE nPrn = -3
        Alert(cMess+"WINAPI StartDocPrinter() call failed")
      CASE nPrn = -4
        Alert(cMess+"WINAPI StartPagePrinter() call failed")
      CASE nPrn = -5
        Alert(cMess+"WINAPI malloc() of memory failed")
      CASE nPrn = -6
        Alert(cMess+"WINAPI CreateFile() call failed - File "+cFileName+" no found??")
      ENDCASE
    ENDIF
  ENDIF

RETURN(nPrn)

#pragma BEGINDUMP

#undef UNICODE

#include <windows.h>
#include "hbapi.h"
#include "hbvm.h"
#include "hbstack.h"
#include "hbapiitm.h"

#ifndef __XHARBOUR__
   #define ISCHAR( n )           HB_ISCHAR( n )
#endif

#define MAX_FILE_NAME 1024
#define BIG_BUFFER (1024*32)

HB_FUNC ( ENUMPRINTERS )
{
  UCHAR *Result ;
  DWORD x, Flags = PRINTER_ENUM_LOCAL | PRINTER_ENUM_CONNECTIONS ;
  LPSTR Name = NULL ;
  DWORD Level = 5 ;
  PRINTER_INFO_5 *pPrinterEnum, *pFree;
  PRINTER_INFO_4 *pPrinterEnum4, *pFree4;
  DWORD cbBuf  ;
  DWORD BytesNeeded=0 ;
  DWORD NumOfPrinters=0 ;
  OSVERSIONINFO osvi ;  //  altered to check Windows Version
  osvi.dwOSVersionInfoSize = sizeof(OSVERSIONINFO);
  GetVersionEx (&osvi);
  if (osvi.dwPlatformId == VER_PLATFORM_WIN32_NT)
  {
    Level = 4 ;
    EnumPrinters(Flags,Name,Level,(LPBYTE) pPrinterEnum4,0,&BytesNeeded,&NumOfPrinters) ;
    if (BytesNeeded > 0)
    {
      Result = (UCHAR *) hb_xgrab(BytesNeeded) ;
      *Result = '\0' ;
      pFree4 = pPrinterEnum4 = (PRINTER_INFO_4 *)  hb_xgrab(BytesNeeded) ;
      cbBuf = BytesNeeded ;
      if (EnumPrinters(Flags,Name,Level,(LPBYTE) pPrinterEnum4,cbBuf,&BytesNeeded,&NumOfPrinters))
      {
        for (x=0 ; x < NumOfPrinters ; x++, pPrinterEnum4++ )
        {
          strcat(Result,pPrinterEnum4->pPrinterName) ;
          strcat(Result,";") ;
        }
      }
      hb_retc(Result) ;
      hb_xfree(Result) ;
      hb_xfree(pFree4) ;
    }
    else
      hb_retc("") ;
  }
  else
   {
    EnumPrinters(Flags,Name,Level,(LPBYTE) pPrinterEnum,0,&BytesNeeded,&NumOfPrinters) ;
    if (BytesNeeded > 0)
    {
      Result = (UCHAR *) hb_xgrab(BytesNeeded) ;
      *Result = '\0' ;
      pFree = pPrinterEnum = (PRINTER_INFO_5 *)  hb_xgrab(BytesNeeded) ;
      cbBuf = BytesNeeded ;
      if (EnumPrinters(Flags,Name,Level,(LPBYTE) pPrinterEnum,cbBuf,&BytesNeeded,&NumOfPrinters))
      {
        for (x=0 ; x < NumOfPrinters ; x++, pPrinterEnum++ )
        {
          strcat(Result,pPrinterEnum->pPrinterName) ;
          strcat(Result,";") ;
        }
      }
      hb_retc(Result) ;
      hb_xfree(Result) ;
      hb_xfree(pFree) ;
    }
    else
      hb_retc("") ;
  }
}

HB_FUNC( WINDEFAULTPRINTER )
{
  DWORD x, y ;
  UCHAR lpReturnedString[MAX_FILE_NAME] ;
  x = GetProfileString("windows","device","",lpReturnedString,MAX_FILE_NAME-1);
  y = 0 ;
  while ( y < x && lpReturnedString[y] != ',' )
    y++ ;
  hb_retclen(lpReturnedString,y) ;
}

HB_FUNC( PRINTFILERAW )
{
  UCHAR  printBuffer[BIG_BUFFER], *cPrinterName, *cFileName, *cDocName ;
  HANDLE  hPrinter, hFile ;
  DOC_INFO_1 DocInfo ;
  DWORD nRead, nWritten, rVal = -1 ;
  if (ISCHAR(1) && ISCHAR(2))
  {
    cPrinterName= (UCHAR*)hb_parc(1) ;
    cFileName= (UCHAR*)hb_parc(2) ;
    if ( OpenPrinter(cPrinterName, &hPrinter, NULL) != 0 )
    {
      DocInfo.pDocName = (UCHAR*)hb_parc(3) ;
      DocInfo.pOutputFile = NULL ;
      DocInfo.pDatatype = "RAW" ;
      if ( StartDocPrinter(hPrinter,1,(char *) &DocInfo) != 0 )
      {
        if ( StartPagePrinter(hPrinter) != 0 )
        {
          hFile = CreateFile(cFileName,GENERIC_READ,0,NULL,OPEN_EXISTING,FILE_ATTRIBUTE_NORMAL,NULL)   ;
          if (hFile != INVALID_HANDLE_VALUE )
           {
            while (ReadFile(hFile, printBuffer, BIG_BUFFER, &nRead, NULL) && (nRead > 0))
            {
              if (printBuffer[nRead-1] == 26 )
                nRead-- ; // Skip the EOF() character
              WritePrinter(hPrinter, printBuffer, nRead, &nWritten) ;
            }
            rVal = 1 ;
            CloseHandle(hFile) ;
          }
          else
            rVal= -6 ;
          EndPagePrinter(hPrinter) ;  // 28/11/2001 10:16
        }
        else
          rVal = -4 ;
        EndDocPrinter(hPrinter);
      }
      else
        rVal= -3 ;
      ClosePrinter(hPrinter) ;
    }
    else
      rVal= -2 ;
  }
  hb_retnl(rVal) ;
}

#pragma ENDUMP

/////////////////////////////////////////////////////////////////////////
////   THE END   ////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////
