#Include "minigui.ch"

FUNCTION ETIQBRANCA

   public etiqbranca:=.t.

	DEFINE WINDOW ETIQ_B;
	           AT 0,0 ;
 				  WIDTH 430; 
              HEIGHT 360 ;
	           TITLE "Etiquetas Em Branco (Definidas)"	;
				  ICON "TUTOR";
		        CHILD ;
              FONT 'Arial' SIZE 12 ;
        		  BACKCOLOR YELLOW ;
		        ON MAXIMIZE ThisWindow.Center ;
		        ON INIT ( Ativa_Etiqb()) 

                     @ 30,010 LABEL LT ;
                              VALUE 'Peça'  ;
                              WIDTH 60           ;
                              HEIGHT 20   
										
   			    	   @ 60,010 TEXTBOX T_PECA;
 			    	               OF ETIQ_B ;
  							         WIDTH 150 

                     @ 30,230 LABEL NP ;
                              VALUE 'Nome'  ;
                              WIDTH 60           ;
                              HEIGHT 20           

   			    	   @ 60,230 TEXTBOX T_NPECA;
 			    	               OF ETIQ_B ;
  							         WIDTH 150 

                     @ 90,010 LABEL CO ;
                              VALUE 'Cores'  ;
                              WIDTH 60           ;
                              HEIGHT 20           

   			    	   @ 120,10 TEXTBOX T_CORES;
			    	               OF ETIQ_B ;
  							         WIDTH 150 

                     @ 90,230 LABEL VL ;
                              VALUE 'Validade'  ;
                              WIDTH 100          ;
                              HEIGHT 20           

			    	      @ 120,230 TEXTBOX T_VALIDADE;
			    	               OF ETIQ_B ;
   			                  WIDTH 150 

                     @ 150,10 LABEL PC ;
                              VALUE 'Lote' ;
                              WIDTH 80           ;
                              HEIGHT 20           

			    	      @ 180,10 TEXTBOX T_LOTE;
			    	               OF ETIQ_B ;
   			                  WIDTH 150 
											 
                     @ 150,230 LABEL dtf ;
                              VALUE 'Fabricação'  ;
                              WIDTH 100           ;
                              HEIGHT 20           
  			                  
	  				      @ 180,230 DATEPICKER T_dtlan	

	                  @ 230,120 BUTTON Btn_SETQ Of ETIQ_B	;
                               CAPTION '&Imprimir'             ;
                               ACTION IMPETIQargox(ETIQ_B.T_PECA.VALUE,ETIQ_B.T_NPECA.VALUE,ETIQ_B.T_CORES.VALUE,ETIQ_B.T_VALIDADE.VALUE,ETIQ_B.T_LOTE.VALUE,ETIQ_B.T_dtlan.VALUE,etiqbranca);
										 WIDTH 80 HEIGHT 27   ;                                 
                               TOOLTIP "Salvar Registro" ;
                             FLAT

	                  @ 230,250 BUTTON Btn_CETQ Of ETIQ_B	;
		                         CAPTION '&Cancelar'		;
                               ACTION ETIQ_B.RELEASE ;
			                      WIDTH 80 HEIGHT 27		;
                               TOOLTIP "Cancelar Operação"	;
			                    FLAT

	END WINDOW

	ETIQ_B.CENTER

	ETIQ_B.ACTIVATE 

RETURN

*------------------------------------------------------------------------------*
PROCEDURE Ativa_Etiqb()
*------------------------------------------------------------------------------*
   ETIQ_B.T_LOTE.VALUE := 0
   ETIQ_B.T_dtlan.VALUE := DATE()
   ETIQ_B.T_PECA.VALUE:=SPACE(10)
   ETIQ_B.T_NPECA.VALUE:=SPACE(20)
	ETIQ_B.T_CORES.VALUE:=SPACE(05)
   ETIQ_B.T_VALIDADE.VALUE:=SPACE(10) 
RETURN

**************************************************************************************
PROCEDURE IMPETIQargox(p_peca,pn_peca,p_cores,p_validade,p_lote,p_data) 
**************************************************************************************
#Include "minigui.ch"
#include "winprint.ch"
#include "hmg.ch"

MEMVAR aJobData

local cArquivo := "Etiqueta.TXT" 
Local cCtr := chr(2), cEol := Hb_Eol(), N_ETIQ:=1
local nOption:=0
PRIVATE aJobData   // aJobData must be declared as Public or Private
  
BUSCAR:=Upper ( AllTrim ( InputBox( 'N.Etiquetas :' , 'Informe' ) ) )

N_ETIQ:=VAL(BUSCAR)    

SELECT PRINTER DEFAULT ;
    ORIENTATION PRINTER_ORIENT_PORTRAIT ;
    PAPERSIZE PRINTER_PAPER_LETTER ;
    QUALITY  PRINTER_RES_MEDIUM

for i:=1 to 2

    START PRINTDOC STOREJOBDATA aJobData
 
    START PRINTPAGE
 
    @ prow()+1,pcol()+25 PRINT IMAGE "max.jpg" ;
              WIDTH 50 ;
              HEIGHT 30
 
    @ Prow()+28, PCol()+2 Print "-------------------------------------------------------------------------" 
    @ Prow()+31, PCol()+2 Print p_PECA FONT "Arial" SIZE 12  // titulo em fonte pequena
    @ Prow()+31, PCol()+30 Print "|" +pn_peca FONT "Arial" SIZE 12 
 
    @ Prow()+34, PCol()+2 Print "-------------------------------------------------------------------------" 
 
    @ Prow()+37, PCol()+02 Print "Cor" FONT "Arial" SIZE 12
    @ Prow()+37, PCol()+30 Print "|Validade  " FONT "Arial" SIZE 12
    @ Prow()+40, PCol()+2 Print "-------------------------------------------------------------------------" 
 
    @ Prow()+43, PCol()+02 Print p_cores FONT "Arial" SIZE 12
    @ Prow()+43, PCol()+30 Print "|"+ p_validade FONT "Arial" SIZE 12
 
    @ Prow()+46, PCol()+02 Print "-------------------------------------------------------------------------" 
 
    @ Prow()+49, PCol()+2 Print "N.Lote" FONT "Arial" SIZE 12
    @ Prow()+49, PCol()+30 Print "|Data Fabricacao" FONT "Arial" SIZE 12
 
    @ Prow()+52, PCol()+2 Print "-------------------------------------------------------------------------" 
 
    @ Prow()+55, PCol()+2 Print p_lote FONT "Arial" SIZE 12
    @ Prow()+55, PCol()+30 Print "|"+ DTOC(p_data) FONT "Arial" SIZE 12
 
    @ Prow()+58, PCol()+2 Print "-------------------------------------------------------------------------" 
 
    @ Prow()+61, PCol()+2 Print "C N P J :"  + emp->cgc FONT "Arial" SIZE 12
    @ Prow()+64, PCol()+2 Print "-------------------------------------------------------------------------" 
 
    @ Prow()+67, PCol()+2 Print "C R Q   :" + emp->diretor FONT "Arial" SIZE 12
    @ Prow()+70, PCol()+2 Print "-------------------------------------------------------------------------" 
    
    @ Prow()+1, PCol() print "E" + cEol // envia para a impressora
    @ Prow()+1, PCol() print "Q" + cEol   // esvazia a memoria da impressora
 
   END PRINTPAGE
 
   END PRINTDOC
 next

 if etiqbranca
    ETIQ_B.RELEASE 
 endif

 RETURN NIL
  
#define JOB_STATUS_PAUSED              0x00000001
#define JOB_STATUS_ERROR               0x00000002
#define JOB_STATUS_DELETING            0x00000004
#define JOB_STATUS_SPOOLING            0x00000008
#define JOB_STATUS_PRINTING            0x00000010
#define JOB_STATUS_OFFLINE             0x00000020
#define JOB_STATUS_PAPEROUT            0x00000040
#define JOB_STATUS_PRINTED             0x00000080
#define JOB_STATUS_DELETED             0x00000100
#define JOB_STATUS_BLOCKED_DEVQ        0x00000200
#define JOB_STATUS_USER_INTERVENTION   0x00000400
#define JOB_STATUS_RESTART             0x00000800
#define JOB_STATUS_COMPLETE            0x00001000


#define PRINTER_STATUS_OK                    0
#define PRINTER_STATUS_PAUSED                0x00000001
#define PRINTER_STATUS_ERROR                 0x00000002
#define PRINTER_STATUS_PENDING_DELETION      0x00000004
#define PRINTER_STATUS_PAPER_JAM             0x00000008
#define PRINTER_STATUS_PAPER_OUT             0x00000010
#define PRINTER_STATUS_MANUAL_FEED           0x00000020
#define PRINTER_STATUS_PAPER_PROBLEM         0x00000040
#define PRINTER_STATUS_OFFLINE               0x00000080
#define PRINTER_STATUS_IO_ACTIVE             0x00000100
#define PRINTER_STATUS_BUSY                  0x00000200
#define PRINTER_STATUS_PRINTING              0x00000400
#define PRINTER_STATUS_OUTPUT_BIN_FULL       0x00000800
#define PRINTER_STATUS_NOT_AVAILABLE         0x00001000
#define PRINTER_STATUS_WAITING               0x00002000
#define PRINTER_STATUS_PROCESSING            0x00004000
#define PRINTER_STATUS_INITIALIZING          0x00008000
#define PRINTER_STATUS_WARMING_UP            0x00010000
#define PRINTER_STATUS_TONER_LOW             0x00020000
#define PRINTER_STATUS_NO_TONER              0x00040000
#define PRINTER_STATUS_PAGE_PUNT             0x00080000
#define PRINTER_STATUS_USER_INTERVENTION     0x00100000
#define PRINTER_STATUS_OUT_OF_MEMORY         0x00200000
#define PRINTER_STATUS_DOOR_OPEN             0x00400000
#define PRINTER_STATUS_SERVER_UNKNOWN        0x00800000
#define PRINTER_STATUS_POWER_SAVE            0x01000000

/*
#Include "minigui.ch"
#include "winprint.ch"

local cArquivo := "Etiqueta.TXT" 
Local cCtr := chr(2), cEol := Hb_Eol(), N_ETIQ:=1
Local cPrinter
local nOption:=0

BUSCAR:=Upper ( AllTrim ( InputBox( 'N.Etiquetas :' , 'Informe' ) ) )

N_ETIQ:=VAL(BUSCAR)    

cPrinter := GetPrinter()

 SET DEVI TO PRIN
 SET PRIN TO ( cArquivo )

 @ Prow()+0, PCol() Say chr(2) + "O0220"
 @ Prow()+0, PCol() Say chr(2) + "m"
 @ Prow()+0, PCol() Say  chr(2) + "M3000"
 @ Prow()+0, PCol() Say  chr(2) + "c0000"
 @ Prow()+0, PCol() Say  chr(2) + "f500"
 @ Prow()+0, PCol() Say  chr(2) + "e"
 @ Prow()+0, PCol() Say  chr(2) + "LC0000"
 @ Prow()+0, PCol() Say  "H14"
 @ Prow()+0, PCol() Say  "D11"
 @ Prow()+0, PCol() Say  "SC"
 @ Prow()+0, PCol() Say  "PC"
 @ Prow()+0, PCol() Say  "R0000"
 @ Prow()+0, PCol() Say  "z"
 @ Prow()+0, PCol() Say  "W"
 
///         Y=linha   X=coluna
///1900 004 0190      0010

@ Prow()+0, PCol() Say "190000407000250" + "M  a  x  i  P  a  i  n  t" + cEol

@ Prow()+0, PCol() Say "190000406500135" + "IMAGINATION AND CREATION" + cEol 

@ Prow()+0, PCol() Say "190000406000020" + "--------------------------------------------------------" + cEol 

@ Prow()+0, PCol() Say "190000405700020" + p_PECA + cEol // titulo em fonte pequena
@ Prow()+0, PCol() Say "190000405700400" + "|" +pn_peca + cEol // titulo em fonte pequena

@ Prow()+0, PCol() Say "190000405400020" + "-------------------------------------------------------------------------" + cEol 

@ Prow()+0, PCol() Say "190000405100020" + "C o r " + cEol 
@ Prow()+0, PCol() Say "190000405100400" + "|Validade" + cEol 

@ Prow()+0, PCol() Say "190000404800020" + "-------------------------------------------------------------------------" + cEol 

@ Prow()+0, PCol() Say "190000404500020" + p_cores + cEol 
@ Prow()+0, PCol() Say "190000404500400" + "|"+ p_validade + cEol 

@ Prow()+0, PCol() Say "190000404200020" + "-------------------------------------------------------------------------" + cEol 

@ Prow()+0, PCol() Say "190000403900020" + "N.Lote" + cEol 
@ Prow()+0, PCol() Say "190000403900400" + "|Data Fabricacao" + cEol 

@ Prow()+0, PCol() Say "190000403600020" + "-------------------------------------------------------------------------" + cEol 

@ Prow()+0, PCol() Say "190000403300020" + p_lote + cEol 
@ Prow()+0, PCol() Say "190000403300400" + "|"+ dtoc(p_data) + cEol 

@ Prow()+0, PCol() Say "190000403000020" + "-------------------------------------------------------------------------" + cEol 

@ Prow()+0, PCol() Say "190000402700020" + "C N P J : " + emp->cgc + cEol
@ Prow()+0, PCol() Say "190000402400020" + "-------------------------------------------------------------------------" + cEol 

@ Prow()+0, PCol() Say "190000402100020" + "C R Q   : " + emp->diretor + cEol
@ Prow()+0, PCol() Say "190000401800020" + "-------------------------------------------------------------------------" + cEol  

@ Prow()+0, PCol() Say "E" + cEol // envia para a impressora
@ Prow()+0, PCol() Say "Q" + cEol   // esvazia a memoria da impressora


/*
 @ Prow()+0, PCol() Say "190000402500020" + p_PECA + cEol // titulo em fonte pequena
 @ Prow()+0, PCol() Say "190000402500400" + "|"+pn_peca + cEol 

 @ Prow()+0, PCol() Say "190000402200020" + "_____________________________________________" + cEol 

 @ Prow()+0, PCol() Say "190000401700020" + p_cores + cEol 
 @ Prow()+0, PCol() Say "190000401700400" + "|Validade : "+ p_validade + cEol 

 @ Prow()+0, PCol() Say "190000401400020" + "_____________________________________________" + cEol 

 @ Prow()+0, PCol() Say "190000400900020" + "N.Lote" + cEol 
 @ Prow()+0, PCol() Say "190000400900400" + "|Data Fabricacao" + cEol 

 @ Prow()+0, PCol() Say "190000400300020" + p_lote + cEol 
 @ Prow()+0, PCol() Say "190000400300400" + "|"+dtoc(p_data) + cEol 

 if nOption == 2
   @ Prow()+0, PCol() Say "190000402200020" + "_____________________________________________" + cEol 
   @ Prow()+0, PCol() Say "190000402500020" + "C N P J :" + cEol
   @ Prow()+0, PCol() Say "190000402200020" + "_____________________________________________" + cEol 
   @ Prow()+0, PCol() Say "190000402500020" + "C R Q   :" + cEol
   @ Prow()+0, PCol() Say "190000402200020" + "_____________________________________________" + cEol 
 endif 

 @ Prow()+0, PCol() Say "E" + cEol // envia para a impressora
 @ Prow()+0, PCol() Say "Q" + cEol   // esvazia a memoria da impressora

 

 SET PRIN TO
 SET DEVI TO SCREEN

 cPrinter := GetDefaultPrinter() // pega impressora padrao
 for i:=1 to N_ETIQ
     PrintFileRaw( cPrinter, cArquivo, "Etiqueta Lote ->"+str(i,3) )
 next

 if etiqbranca
    ETIQ_B.RELEASE 
 endif
    
Return
*/