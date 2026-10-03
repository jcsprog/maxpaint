#Include "minigui.ch"
#include "winprint.ch"

FUNCTION ETIQBRANCA

	DEFINE WINDOW ETIQ_B;
	           AT 0,0 ;
 				  WIDTH 400;
              HEIGHT 330 ;
	           TITLE "Etiquetas Em Branco (Definidas)"	;
				  ICON "TUTOR";
		        CHILD ;
              FONT 'Arial' SIZE 12 ;
        		  BACKCOLOR YELLOW ;
		        ON MAXIMIZE ThisWindow.Center ;
		        ON INIT ( Ativa_Etiqb()) 

                     @ 30,010 LABEL PC ;
                              VALUE 'Lote' ;
                              WIDTH 80           ;
                              HEIGHT 30           

                     @ 60,010 LABEL CO ;
                              VALUE 'Cores'  ;
                              WIDTH 60           ;
                              HEIGHT 30           
												 
                     @ 90,010 LABEL LT ;
                              VALUE 'Pe�a'  ;
                              WIDTH 60           ;
                              HEIGHT 30           
                              
                     @120,010 LABEL NP ;
                              VALUE 'Nome'  ;
                              WIDTH 60           ;
                              HEIGHT 30           

                     @150,010 LABEL VL ;
                              VALUE 'Validade'  ;
                              WIDTH 100          ;
                              HEIGHT 30           

                     @180,010 LABEL dtf ;
                              VALUE 'Fabrica��o'  ;
                              WIDTH 100           ;
                              HEIGHT 30           

			    	      @ 030,120 TEXTBOX T_LOTE;
			    	               OF ETIQ_B ;
   			                  WIDTH 150 

   			    	   @ 060,120 TEXTBOX T_CORES;
			    	               OF ETIQ_B ;
  							         WIDTH 150 
  							         
   			    	   @ 090,120 TEXTBOX T_PECA;
 			    	               OF ETIQ_B ;
  							         WIDTH 150 

   			    	   @ 120,120 TEXTBOX T_NPECA;
 			    	               OF ETIQ_B ;
  							         WIDTH 150 

			    	      @ 150,120 TEXTBOX T_VALIDADE;
			    	               OF ETIQ_B ;
   			                  WIDTH 150 
   			                  
	  				      @ 180,120 DATEPICKER T_dtlan	

	                  @ 230,120 BUTTON Btn_SETQ Of ETIQ_B	;
                               CAPTION '&Imprimir'             ;
                               ACTION IMPETIQBRANCA() ;
                               WIDTH 80 HEIGHT 27   ;                                 
                               TOOLTIP "Salvar Registro" ;
                             FLAT

	                  @ 230,250 BUTTON Btn_CETQ Of ETIQ_B	;
		                         CAPTION '&Cancelar'		;
                               ACTION ETIQ_B.RELEASE ;
			                      WIDTH 80 HEIGHT 27		;
                               TOOLTIP "Cancelar Opera��o"	;
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

*------------------------------------------------------------------------------*
PROCEDURE IMPETITXT
*------------------------------------------------------------------------------*
#include "winprint.ch"
Local dirimp:=GetCurrentFolder(), PAG, LH
Local N_ETIQ:=1
local N_CONT:=0
local N_pag:=0

LOCAL BUSCAR

BUSCAR:=Upper ( AllTrim ( InputBox( 'N� Etiquetas :' , 'Informe' ) ) )

N_ETIQ:=VAL(BUSCAR)    

TITULOIMP:="ETIQUETAS"
	
INIT PRINTSYS

SELECT BY DIALOG PREVIEW

IF HBPRNERROR > 0
   RETURN NIL
ENDIF

//SET UNITS MM

// Defini��o das fontes.
define font "ft09" name "times new roman" size 09
define font "ft10" name "times new roman" size 10
define font "ft12" name "times new roman" size 12 //bold=negrita
define font "ft14" name "times new roman" size 14
define font "ft18" name "times new roman" size 18

// Defini��o das Linhas.
define pen "p0" style PS_SOLID width 1 color 0x000000
define pen "p1" style PS_DOT width 1 color 0xFF0000
define pen "p2" style PS_NULL

set page orientation DMORIENT_PORTRAIT papersize DMPAPER_LETTER font "ft14"
start doc name TituloImp
start page

select font "ft14"
select pen "p0"

LH:=PROW()
FOR N_CONT:=1 TO N_ETIQ

    if n_pag == 4
	    end page
       start page
       n_pag:=0
       LH:=PROW()
	 endif      

    n_pag+=1

    @ LH,02,LH+6,25 RECTANGLE
    @ LH,25,LH+6,54 RECTANGLE
    lh+=1
    @ LH,03 SAY ETIQ_B.T_PECA.VALUE TO PRINT
    @ LH,26 SAY ETIQ_B.T_NPECA.VALUE TO PRINT
    @ LH,02 SAY "_________________________________________" TO PRINT
    LH+=2
    @ LH,03 SAY ETIQ_B.T_CORES.VALUE TO PRINT
    @ LH,26 SAY "Validade:"+ETIQ_B.T_VALIDADE.VALUE TO PRINT
    @ LH,02 SAY "_________________________________________" TO PRINT
    LH+=1
    @ LH,03 SAY "N� Lote"  to print
    @ LH,26 SAY "Data Fabrica��o" TO PRINT
	 lh+=1
    @ LH,03 SAY IF(ETIQ_B.T_LOTE.VALUE="0",SPACE(10),ETIQ_B.T_LOTE.VALUE) TO PRINT
    @ LH,29 SAY ETIQ_B.T_dtlan.VALUE TO PRINT

    LH+=2
    
NEXT

end page
end doc
release printsys
SetCurrentFolder(dirimp)
RETURN NIL

*------------------------------------------------------------------------------*
PROCEDURE IMPETIQBRANCA
*------------------------------------------------------------------------------*
#include "winprint.ch"
Local dirimp:=GetCurrentFolder(), PAG, LH
Local N_ETIQ:=1
local N_CONT:=0
local N_pag:=0

LOCAL BUSCAR

BUSCAR:=Upper ( AllTrim ( InputBox( 'N� Etiquetas :' , 'Informe' ) ) )

N_ETIQ:=VAL(BUSCAR)    

TITULOIMP:="ETIQUETAS"
	
INIT PRINTSYS

SELECT BY DIALOG PREVIEW

IF HBPRNERROR > 0
   RETURN NIL
ENDIF

//SET UNITS MM

// Defini��o das fontes.
define font "ft09" name "times new roman" size 09
define font "ft10" name "times new roman" size 10
define font "ft12" name "times new roman" size 12 //bold=negrita
define font "ft14" name "times new roman" size 14
define font "ft18" name "times new roman" size 18

// Defini��o das Linhas.
define pen "p0" style PS_SOLID width 1 color 0x000000
define pen "p1" style PS_DOT width 1 color 0xFF0000
define pen "p2" style PS_NULL

set page orientation DMORIENT_PORTRAIT papersize DMPAPER_LETTER font "ft14"
start doc name TituloImp
start page

select font "ft14"
select pen "p0"

LH:=PROW()
FOR N_CONT:=1 TO N_ETIQ

    if n_pag == 4
	    end page
       start page
       n_pag:=0
       LH:=PROW()
	 endif      

    n_pag+=1

    @ LH,02,LH+6,25 RECTANGLE
    @ LH,25,LH+6,54 RECTANGLE
    lh+=1
    @ LH,03 SAY ETIQ_B.T_PECA.VALUE TO PRINT
    @ LH,26 SAY ETIQ_B.T_NPECA.VALUE TO PRINT
    @ LH,02 SAY "_________________________________________" TO PRINT
    LH+=2
    @ LH,03 SAY ETIQ_B.T_CORES.VALUE TO PRINT
    @ LH,26 SAY "Validade:"+ETIQ_B.T_VALIDADE.VALUE TO PRINT
    @ LH,02 SAY "_________________________________________" TO PRINT
    LH+=1
    @ LH,03 SAY "N. Lote"  to print
    @ LH,26 SAY "Data Fabricação" TO PRINT
	 lh+=1
    @ LH,03 SAY IF(ETIQ_B.T_LOTE.VALUE="0",SPACE(10),ETIQ_B.T_LOTE.VALUE) TO PRINT
    @ LH,29 SAY ETIQ_B.T_dtlan.VALUE TO PRINT

    LH+=2
    
NEXT

end page
end doc
release printsys
SetCurrentFolder(dirimp)
RETURN NIL
