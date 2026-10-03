*********************************
** MAXPAINT - DESENVOLVIMENTO 10/02/2016 INICIO
*********************************
#include "MiniGUI.ch"
#include "tsbrowse.ch"
#include "hmg.ch"
#include "winprint.ch"
#include "HBCompat.ch"
#include "Directry.ch"

#define BM_WIDTH     1
#define BM_HEIGHT    2

MEMVAR _BLUE,_YELLOW,_BLACK,_ROSA,_BLUE3
MEMVAR _BLUE2,_YELLOW2,_BLUE5,_VERDE
memvar lPreview

REQUEST descend

FUNCTION Main()

   SET DELETED ON
   SET CENTURY ON
   SET EXCLUSIVE OFF      
   SET DATE BRIT
   SET EPOCH TO 1920
   SET CENTURY ON
   SET DECIMALS TO 2
   SET DATE FORMAT TO "DD/MM/YYYY"
   SET LANGUAGE TO PORTUGUESE      
   Set Navigation Extended 
   SET ShowDetailError ON
   SET BROWSESYNC ON
   SET MULTIPLE OFF WARNING
	DBCOMMITALL()

/*
	use maxopitem exclusive
	Index on descend(STR(NLOTE,10)) to IDMAXOR2
*/
	dbcloseall()
	
	ARQPRINC() 
   EMPRESA:=alltrim(EMP->DESCR)+"/Revestimentos Especiais"		
   VUSUARIO:=""      
   
   PUBLIC _BLUE:={0,0,255},_YELLOW:={255,255,200},_BLACK:={0,0,0},_ROSA:={255,200,200},_BLUE3:={211,237,250}
   PUBLIC _BLUE2:={0,128,255},_YELLOW2:={255,255,225},_BLUE5:={ 0 , 0 ,255},_VERDE:={0,128,128}
   PUBLIC CINCL:=.F.,CALTE:=.F.,CEXCL:=.F.,CIMPR:=.F.,ADM:=.F.,ENDCLI:="",ENDEMP:=""

   Define window Form_10 ;
       AT 0 , 0 ;
       WIDTH GetDesktopWidth();
       HEIGHT GetDesktopHeight()-30; 
	    Title EMPRESA ;
       MAIN ;
	    Icon 'MAIN.ICO';
       FONT 'Arial' SIZE 12 ;
       ON INIT ( SENHA(), FORM_10.STATUSBAR.ITEM(2):="Usuario :"+VUSUARIO ) ;
       ON INTERACTIVECLOSE MsgYesNo ( 'Sair do Sistema ?', 'Finaliza',dbcloseall(), , .F. )       

		 DEFINE BKGBRUSH newBrush PATTERN IN Form_10 BITMAP MAXFUNDO.BMP

       Define main menu

           Popup 'Cadastros'
             Item 'Empresa '  Action emp(23) IMAGE 'BORRAR' MESSAGE "Cadastro da Empresa"
             SEPARATOR
             Item '&Cadastro de Clientes  ' Action clientes(1) IMAGE 'Clientes' MESSAGE "Cadastro de Clientes"
             SEPARATOR
             Item '&Cadastro Fornecedores   ' Action Fornecedor(2) IMAGE "edit_edit" MESSAGE "Cadastro de Fornecedores"
             SEPARATOR
             Item 'Cores das Tintas ' Action CORTINTAS(3) IMAGE "tipos" MESSAGE "Cadastro das Cores das Tintas"
             SEPARATOR
             Item 'Embalagens       ' Action PRODUTO(3) IMAGE "edit_new" MESSAGE "Cadastro das Embalagens"
             SEPARATOR
             Item 'Tabela Composicao' Action TABICM(9) IMAGE "button7" MESSAGE "Cadastro da Tabela de Composicao"
             SEPARATOR
             Item 'Produtos         ' Action ITENS(4) IMAGE 'contactos' MESSAGE "Cadastro de Produtos Maxipaint"
             Item 'Produtos/Agregados' Action AGREGA() IMAGE "hp_gopage" MESSAGE "Cadastro de Produtos Maxipaint"
             SEPARATOR
             Item 'Controle Formulas' Action TBFORM(4) IMAGE "edit_ok" MESSAGE "Controle de Formulas"
             Separator
             Separator
             Item 'Fim' Action (dbcloseall(),Form_10.Release) Image 'edit_close'
           End Popup

           Popup 'Processos Diarios'
                 Item 'Orçamento ' Action ORCPED(3) IMAGE "edit_new" MESSAGE "Orçamento de Producao de Tintas"
                 Item 'Etiquetas Definidas' Action ETIQBRANCA() IMAGE "edit_copy" MESSAGE "Impressão de Etiquetas Definidas pelo Usuario"
           end popup

           Popup 'Relatorios'
                 Item 'Orçamentos ' Action LSTPORCPED(10,1) IMAGE "edit_print" MESSAGE "Impressao de Orcamentos"
           End Popup
     
           Popup 'Utilitarios'

              Popup 'Senhas Usuarios ' 
                    ITEM 'Inclusão ' Action USUARIOS(1,10) IMAGE "Free" MESSAGE "Criar Usuario e Liberações"
                    ITEM 'Alteração' Action USUARIOS(2,10) IMAGE "info" MESSAGE "Alterar Liberação do Sistema"
                    ITEM 'Exclusão' Action USUARIOS(3,10) IMAGE "check" MESSAGE "Exclusão de Usuario e Suas Liberações"
                    ITEM 'Troca de Senha' Action USUARIOS(4,10) IMAGE "exit" MESSAGE "Troca de Senha"
      		  end popup
      
              SEPARATOR
              Item 'Reorganização   ' Action REORGANIZA(23) IMAGE "edit_ok" MESSAGE "Reorganização de Arquivos do Sistema"
      		  SEPARATOR
              Item 'B a c k u p' Action BACKUPJCS(23) IMAGE "button5" MESSAGE "Backup Geral do Sistema / Restauração do Sistema"
           End Popup

           Popup 'Informações'

              Item 'Desenvolvimento' Action MsgInfo ( "Desevolvido por João Carlos de Souza| Analista Sistemas | Cel.:9.7378-8895 ",MiniGuiVersion() )

           End Popup

           DEFINE STATUSBAR FONT 'MS Sans Serif' SIZE 9 
               STATUSITEM ""
 	     	      STATUSITEM "Usuario:" WIDTH 150
      		   STATUSITEM "Versão 2.00" WIDTH 80
		         STATUSITEM 'JCSoft (11)9.7378-8895' WIDTH 150
		         CLOCK WIDTH 85
      		   DATE 
           END STATUSBAR

           FORM_10.STATUSBAR.ITEM(2):="Usuario: " + VUSUARIO
      
       End Menu
   End Window

   Form_10.Center 
   Form_10.Activate
	 
Return

// fontes p/ compilacao com apenas minigui geral
/*
#include "ciec3.prg"
#include "CIEC5.PRG"
#include "ciec5st.prg"
#include "cliente.prg"
#include "EMPRESA.PRG"
#include "FORNECE.PRG"
#include "INDICE.PRG"
#include "JCSBACK.PRG"
#include "MAX3.PRG"
#include "MAX4.PRG"
#include "MAX4AGR.PRG"
#include "MAX5.PRG"
#include "MAX6.PRG"
#include "MAX6E.PRG"
#include "MAX7.PRG"
#include "MAXORCPD.PRG"
#include "senha.prg"
#include "USUARIOS.PRG"
*/

// MsgOptions([cText], [cTitle], [cImage], aOptions, [nDefaultOption], [nSeconds])


Function MsgOptions(cText, cTitle, cImage, aOptions, nDefaultOption, nSeconds )
   Local nItem:=0, nBtnWidth:=0, aBtn:=Array(Len(aOptions)), aImgInfo
   Local nBtnPosX:=10, nBtnPosY:=85, cOption:=""

   Default cText           To "SELECIONE UMA OP��O"
   Default cTitle          To "P E S Q U I S A "
   Default cImage          To ""
   Default nDefaultOption  To 1
   Default nSeconds        To 0

   DEFINE FONT _Font_Options FONTNAME "MS Sans Serif" SIZE 12

   //Calcular anchura m�xima de un bot�n para igualarlos todos
   For nItem:=1 To Len(aOptions)
      aOptions[nItem]:=Alltrim(aOptions[nItem])
      nBtnWidth:=Max( GetTextWidth(, aOptions[nItem], GetFontHandle("_Font_Options")), nBtnWidth )
   Next
   nBtnWidth+=5

   DEFINE WINDOW _Options  ;
      AT 0,0               ;
      WIDTH (Len(aOptions)*(10+nBtnWidth))+15 ;
      HEIGHT 155           ;
      TITLE cTitle         ;
      ICON "BUSCAR.ICO"    ;
      MODAL                ;
      NOSIZE               ;
      ON RELEASE IF( IsControlDefined( Timer_1, _Options ), _Options.Timer_1.Release, )

      ON KEY ESCAPE ACTION _Options.Release

      If !Empty(cImage)
         aImgInfo := BmpSize(cImage)
         If !Empty(aImgInfo [BM_WIDTH])
           @ 20, 10 IMAGE _Image PICTURE (cImage) WIDTH aImgInfo [BM_WIDTH] HEIGHT aImgInfo [BM_HEIGHT]
           @ 40, 55 LABEL _Label VALUE cText WIDTH (Len(aOptions)*(10+nBtnWidth))-50 HEIGHT 30 ;
             TRANSPARENT CENTERALIGN FONT "_Font_Options"
         Endif
      Else
           @ 40, 10 LABEL _Label VALUE cText WIDTH (Len(aOptions)*(10+nBtnWidth))-10 HEIGHT 30 ;
             TRANSPARENT CENTERALIGN FONT "_Font_Options"
      Endif

      For nItem:=1 To Len(aOptions)
         aBtn[nItem]:="_Btn_"+Ltrim(Str(nItem))
         cOption:=aBtn[nItem]
         @ nBtnPosY, nBtnPosX BUTTON &cOption CAPTION aOptions[nItem] WIDTH nBtnWidth HEIGHT 25 FONT "_Font_Options" ;
                   ACTION ( cOption:=GetProperty("_Options", This.Name, "Caption"), _Options.Release )
         nBtnPosX+=nBtnWidth+10
      Next

      DoMethod("_Options", aBtn[nDefaultOption], "SetFocus")

      If nSeconds>0
         DEFINE TIMER Timer_1 Interval nSeconds*1000  ;
                ACTION ( cOption:=aOptions[nDefaultOption], _Options.Release )
      Endif

   END WINDOW

   CENTER WINDOW _Options

   ACTIVATE WINDOW _Options

   RELEASE FONT _Font_Options

Return Ascan(aOptions,Alltrim(cOption))

/*
 * MsgLogo(cImage, [nSeconds])
*/

Function MsgLogo( cImage, nSeconds, lRound )

Local aImgInfo:=GetImageSize(cImage), width, height

Default nSeconds To 5, lRound To .F.

   If .Not. IsWindowDefined( _Logo ) .And. .Not. Empty( aImgInfo [BM_WIDTH] )

      width :=aImgInfo [BM_WIDTH]+GetBorderWidth()
      height:=aImgInfo [BM_HEIGHT]+GetBorderHeight()

      DEFINE WINDOW _Logo   ;
         AT 0,0             ;
         WIDTH width        ;
         HEIGHT height      ;
         CHILD TOPMOST      ;
         NOCAPTION          ;
         ON SIZE (_Logo.Width:=width, _Logo.Height:=height) ;
         ON MOUSECLICK _Logo.Release

         @ 0, 0 IMAGE _Image PICTURE (cImage) WIDTH aImgInfo [BM_WIDTH] HEIGHT aImgInfo [BM_HEIGHT]

         DEFINE TIMER Timer_1 INTERVAL nSeconds*1000 ACTION _Logo.Release

      END WINDOW

      If lRound
         SET REGION OF _Logo ROUNDRECT 68,68,width,height
      Endif

      CENTER WINDOW _Logo

      ACTIVATE WINDOW _Logo

   Else
      MsgInfo("No se ha podido llevar a cabo la operaci�n", "Error")
   Endif

Return Nil

*-------------------------------------------------------------
Static Function GetImageSize( cImagePath )
*-------------------------------------------------------------
Local ObjImage, aRetArr:={0,0}

   If FILE( GetStartUpFolder() + '\ximage.dll' )

	objImage := CreateObject( "XStandard.Image" )

	if objImage:Load( cImagePath ) == .T.
		aRetArr[1] := objImage:Width
		aRetArr[2] := objImage:Height
	endif

	objImage := NIL

   Endif

Return aRetArr

*-------------------------------------------------------------
Static Function UnRegXImage()
*-------------------------------------------------------------

	If FILE( GetStartUpFolder() + '\ximage.dll' )
		EXECUTE FILE "regsvr32" PARAMETERS "/u /s XImage.dll" HIDE
	Endif

Return Nil

/*
 * MsgDesktop([cText], [cTitle], [cImage], [lFlash])
*/
Function PegaValorDaColuna( xObj, xForm, nCol)
	 Local nPos := GetProperty ( xForm , xObj , 'Value' )
	 Local aRet := GetProperty ( xForm , xObj , 'Item' , nPos )
Return aRet[nCol]	


FUNCTION TREG

PRIVATE LIN,COL
LIN = ROW()
COL = COL()
*
IF RLOCK()
   RETURN (.T.) && Travado
ENDIF
*
TONE(500,3)
MSGINFO("REGISTRO EM MANUTENCAO - Tentando Novo Acesso, <ESC> Interrompe")
DO WHILE LASTKEY() # 27 && Tentar Ate Travamento ou Digitacao <ESC>
   IF !RLOCK()
      MSGINFO("Registro Em Manuten��o Tentando Acesso !!! ")
      RETURN(.F.)
   ELSEIF RLOCK()
      RETURN (.T.) && Travado
   ENDIF
ENDDO
RETURN (.F.)


PROC MESES
PARAMETERS VDTAD
M=SUBS(DTOC(VDTAD),4,2)
VINIC=IF(M="01","JANEIRO",IF(M="02","FEVEREIRO",IF(M="03","MARCO",IF(M="04","ABRIL",IF(M="05","MAIO"," ")))))
IF VINIC=" "
   VINIC=IF(M="06","JUNHO",IF(M="07","JULHO",IF(M="08","AGOSTO",IF(M="09","SETEMBRO",IF(M="10","OUTUBRO",IF(M="11","NOVEMBRO",IF(M="12","DEZEMBRO"," ")))))))
ENDIF
RETURN VINIC

************************
PROCEDURE ARQPRINC
************************
****CRIA INDICES MATRIZES
IF !FILE("IDJCS1.NTX")
   USE JCSARQ EXCLUSIVE
   INDEX ON NOMEU+STR(COD,5) TO IDJCS1
   INDEX ON SENHAU+STR(COD,5) TO IDJCS2
   USE

   USE LANINDI EXCLUSIVE
   INDEX ON STR(COD,5)+APELIDO+NINDE TO IDLINDC 
   USE

   USE INDICES EXCLUSIVE
   INDEX ON STR(COD,5)+APELIDO TO IDINDIC 
	USE

   USE ARQEMP EXCLUSIVE
	INDEX ON CODIGO TO AGENDA1
	INDEX ON DESCR TO AGENDA2
	USE
   DBCLOSEALL()
   
ENDIF   

USE ARQEMP ALIAS EMP INDEX AGENDA1,AGENDA2 NEW SHARED
RETURN NIL

**********************************
PROCEDURE LiberacaoCiec(LIBCIEC)
**********************************
//PARAMETERS LIBCIEC
IF JCS->(DBSEEK(VUsuario+STR(LIBCIEC,5)))
   CINCL:=JCS->INCLU
	CALTE:=JCS->ALTEU 
	CEXCL:=JCS->EXCLU 
	CIMPR:=JCS->IMPRU
	ADM  :=JCS->ADM
ENDIF
RETURN NIL

*****************************
PROCEDURE VERLIBERA
*****************************
DO CASE 
   CASE CINCL=.F.
        MSGINFO("Sem Libera��o p/ Inclus�o!!","Libera��o de Modulos")
	CASE CALTE=.F.
        MSGINFO("Sem Libera��o p/ Altera��o!!","Libera��o de Modulos")
	CASE CEXCL=.F.
        MSGINFO("Sem Libera��o p/ Exclus�o!!","Libera��o de Modulos")
	CASE CIMPR=.F.
        MSGINFO("Sem Libera��o p/ Impress�o!!","Libera��o de Modulos")
ENDCASE
RETURN NIL

Function Pesquisa_cp(c_alias,c_Pesq,n_indice,c_digitado,c_grid,c_form,c_Campos)
Local cPesq := AllTrim(c_digitado) 
Local nTamanhoNomeParaPESQUISA := Len(cPesq)
Local nQuantRegistrosProcessados	:= 0
Local nQuantMaximaDeRegistrosNoGRID	:= 70
Local cCAMPO := c_Pesq //"CODMAX"

&c_alias->(DBSETORDER(n_indice)) //FAM->(DBSETORDER(1))

*** Efetua PESQUISA no Arquivo para posicionar no primeiro registro que satisfa�a a condi��o
&c_alias->(DBSeek(cPesq))

*** Exclui todos os registros do GRID
DELETE ITEM ALL FROM &c_grid OF &c_form  // L_ProdMax

*** Entra no La�o (While ) at� que encontre o fim do arquivo
DO WHILE &c_alias->(!Eof())
   *** Se o Substr do apelido for igual � variavel cPesq ( Conte�do do campo TXTPESQUISA)
   If Substr( &c_alias->&cCAMPO,1,nTamanhoNomeParaPESQUISA) == cPesq
      *** Acumula contador
      nQuantRegistrosProcessados += 1
      *** Se a quantidade de resgistros lidos atingiu o limite de registros definidos para o GRID sai do la�o/While
      if nQuantRegistrosProcessados > nQuantMaximaDeRegistrosNoGRID
         EXIT
      EndIf
      *** Adiciona registro no GRID
      ADD ITEM &c_Campos TO &c_grid OF &c_form //{ FAM->CODMAX,FAM->DESCMAX,FAM->EMBALA } TO L_ProdMax OF agr_2
      *** Se o Substr de Apelido estiver fora da faixa de PESQUISA, abandona o la�o
  ElseIf Substr( &c_alias->&cCAMPO,1,nTamanhoNomeParaPESQUISA) > cPesq
     EXIT
  Endif
  ** Pula para Pr�ximo registro
  &c_alias->(DBSkip())
ENDDO

Return Nil 
	
FUNCTION OPAQ
PARAMETERS ARQ,MOD
IF .NOT. RIGHT(ARQ,3) = 'DBF'
   ARQ:=ARQ+".DBF"
ENDIF
IF .NOT.FILE(ARQ)
   TONE(500,3)
   MSGINFO("Arquivo "+"("+ARQ+")"+" Inexistente !!!")
   RETURN (.F.)
ENDIF
IF MOD = 1
   USE &ARQ. EXCLUSIVE
   IF NETERR()
      MSGINFO("Abertura Exclusiva "+"("+ARQ+")"+" Negada !!!")
      RETURN (.F.)
   ENDIF
ELSE
   USE &ARQ.
   IF NETERR()
      MSGINFO("Abertura Compartilhada "+"("+ARQ+")"+" Negada !!!")
      RETURN (.F.)
   ENDIF
ENDIF
RETURN (.T.)

PROCEDURE TESTE
MSGBOX("EM CRIA��O")
RETURN
 
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
