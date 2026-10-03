#Include "minigui.ch"
#include "winprint.ch"
FUNCTION ETIQPROD
PARAMETERS LIBERA

LiberacaoCiec(LIBERA)

   Public Nuevo := .F.
   Public a_Cores:={}
   Public ctrl_grid:=0

	DEFINE WINDOW ETIQ_1;
	           AT 0,0 ;
 				  WIDTH 850;
              HEIGHT 450 ;
	           TITLE "Controle de Etiquetas de Produção "	;
				  ICON "TUTOR";
		        CHILD ;
              FONT 'Arial' SIZE 12 ;
		        ON MAXIMIZE ThisWindow.Center ;
		        ON INIT ( DesactivarETQ(),ActualizaETQ()) 

		DEFINE TOOLBAR ToolBar_1 BUTTONSIZE 59,35 FLAT BORDER
		
			BUTTON PRIMERO 		;
				CAPTION '&Primero' 	;
				PICTURE 'primero'	;
				ACTION ( ETQ->(dBGoTop()) , ETIQ_1.Browse_1.Value := ETQ->(RecNo()) ) 

			BUTTON ANTERIOR 	;
				CAPTION '&Anterior' 	;
				PICTURE 'anterior'	;
				ACTION ( ETQ->(dBSkip ( -1 )) , ETIQ_1.Browse_1.Value := ETQ->(RecNo()) ) 

			BUTTON SIGUIENTE	;
				CAPTION '&Proximo' 	;
				PICTURE 'siguiente'	;
				ACTION ( ETQ->(dBSkip (1)) , if ( Eof() , ETQ->(DbGoBottom()) , Nil ) , ETIQ_1.Browse_1.Value := ETQ->(RecNo()) ) 

			BUTTON ULTIMO 		;
				CAPTION '&Ultimo' 	;
				PICTURE 'ultimo'	;
				ACTION ( ETQ->(dBGoBottom () ), ETIQ_1.Browse_1.Value := ETQ->(RecNo()) )  SEPARATOR 

			BUTTON BUSCAR 		;
				CAPTION '&Pesquisa' 	;
				PICTURE 'buscar'	;
				ACTION BuscarETQ()

			BUTTON Nuevo 		;
				CAPTION '&Novo' 	;
				PICTURE 'nuevo'	;
				ACTION ( Nuevo := .T. , NuevoETQ() )

			BUTTON EDITAR 		;
				CAPTION 'A&lterar' 	;
				PICTURE 'editar'	;
				ACTION If ( ETQ->(TREG() ) , ActivarETQ() , Nil )

			BUTTON ELIMINAR 	;
				CAPTION 'De&letar'	;
				PICTURE 'borrar'	;
				ACTION EliminarETQ() 

			BUTTON IMPRIMIR 	;
				CAPTION '&Imprimir'	;
				PICTURE 'imprimir2' ;
				ACTION IMPETIQPRD(ETQ->NLOTE) 
				
			BUTTON CERRAR 	;
				CAPTION '&Fecha'	;
				PICTURE 'FREE' ;
            ACTION ETIQ_1.release 

		END TOOLBAR
 
                @ 56,10 BROWSE Browse_1				;
			            WIDTH 420  				;
                     HEIGHT 350           ; 
			            HEADERS { 'Lote','Cod.Pe�a','Dt.Fabrica��o','Cores'} ;
			            WIDTHS { 080,100,150,130}			;
			            WORKAREA ETQ			;
                     FIELDS { 'ETQ->NLOTE' ,'ETQ->CPECA','ETQ->DTLAN','ETQ->CCOR'} ;
			            ON CHANGE ActualizaETQ() ;
			            ON DBLCLICK ( ActivarETQ() , If ( ! ETQ->(TREG()) , DesactivarETQ() , Nil ) )

                     @ 70,440 LABEL PC ;
                              VALUE 'Lote' ;
                              WIDTH 80           ;
                              HEIGHT 30           

                     @100,440 LABEL CO ;
                              VALUE 'Cores'  ;
                              WIDTH 60           ;
                              HEIGHT 30           
												 
                     @130,440 LABEL LT ;
                              VALUE 'Pe�a'  ;
                              WIDTH 60           ;
                              HEIGHT 30           
                              
                     @160,440 LABEL VL ;
                              VALUE 'Validade'  ;
                              WIDTH 100          ;
                              HEIGHT 30           

                     @190,440 LABEL dtf ;
                              VALUE 'Fabrica��o'  ;
                              WIDTH 100           ;
                              HEIGHT 30           

			    	      @ 070,530 TEXTBOX T_LOTE;
			    	               OF ETIQ_1 ;
   			                  WIDTH 150 

   			    	   @ 100,530 COMBOBOX T_CORES;
   			                  ITEMSOURCE CADC->DESVED;	
					  		         VALUESOURCE CADC->CODVED;
  							         WIDTH 250 HEIGHT 120 

   			    	   @ 130,530 COMBOBOX T_PECA;
   			                  ITEMSOURCE FAM->CODMAX+"-"+FAM->DESCMAX;	
					  		         VALUESOURCE FAM->CODMAX;
  							         WIDTH 250 HEIGHT 120 

			    	      @ 160,530 TEXTBOX T_VALIDADE;
			    	               OF ETIQ_1 ;
   			                  WIDTH 140 
   			                  
	  				      @ 190,530 DATEPICKER T_dtlan	

	                  @ 230,550 BUTTON Btn_SETQ Of ETIQ_1	;
                               CAPTION '&Salvar'             ;
                               ACTION AceptarETQ() ;
                               WIDTH 80 HEIGHT 27   ;                                 
                               TOOLTIP "Salvar Registro" ;
                             FLAT

	                  @ 230,700 BUTTON Btn_CETQ Of ETIQ_1	;
		                         CAPTION '&Cancelar'		;
                               ACTION DesactivarETQ() ;
			                      WIDTH 80 HEIGHT 27		;
                               TOOLTIP "Cancelar Opera��o"	;
			                    FLAT

	END WINDOW

   ETIQ_1.Browse_1.SetFocus
	
	ETIQ_1.CENTER

	ETIQ_1.ACTIVATE 

RETURN


*------------------------------------------------------------------------------*
PROCEDURE DesactivarETQ                                                
*------------------------------------------------------------------------------*
         ETIQ_1.Browse_1.Enabled:=.T.
         ETIQ_1.T_LOTE.Enabled :=.F.
         ETIQ_1.T_dtlan.Enabled:=.F.
         ETIQ_1.T_PECA.ENABLED:=.F.
         ETIQ_1.T_VALIDADE.ENABLED:=.F.
         ETIQ_1.T_CORES.ENABLED:=.F.

         ETIQ_1.Btn_CETQ.Enabled:=.F.
   	   ETIQ_1.Btn_SETQ.Enabled:=.F.
   	   ETIQ_1.ToolBar_1.Enabled:=.T.
         ETIQ_1.Browse_1.SetFocus
         
RETURN
*------------------------------------------------------------------------------*
PROCEDURE ActivarETQ
*------------------------------------------------------------------------------*
IF CALTE=.T.
         ETIQ_1.Browse_1.Enabled:=.F.
         ETIQ_1.T_LOTE.Enabled :=.t.
         ETIQ_1.T_dtlan.Enabled:=.T.
         ETIQ_1.T_PECA.ENABLED:=.T.
         ETIQ_1.T_VALIDADE.ENABLED:=.T.
         ETIQ_1.T_CORES.ENABLED:=.T.
         
	      ETIQ_1.ToolBar_1.Enabled:= .F.
         ETIQ_1.Btn_CETQ.Enabled:= .T.
      	ETIQ_1.Btn_SETQ.Enabled:= .T.
ENDIF
RETURN
*------------------------------------------------------------------------------*
PROCEDURE CancelarETQ()
*------------------------------------------------------------------------------*
	DesactivarETQ()
	ActualizaETQ()
	ETQ->(DBUNLOCK())
	Nuevo := .F.
RETURN
*------------------------------------------------------------------------------*
PROCEDURE AceptarETQ()
*------------------------------------------------------------------------------*
	DesactivarETQ()
	If Nuevo == .T.
		ETQ->(DbAppend())
		Nuevo := .F.
	EndIf
	
	*** GRAVACAO DO CABECARIO
	ETQ->NLOTE     := VAL(ETIQ_1.T_LOTE.VALUE)   
   ETQ->DTLAN     := ETIQ_1.T_dtlan.VALUE   
   ETQ->CPECA     := ETIQ_1.T_PECA.VALUE   
   ETQ->CVALIDADE := ETIQ_1.T_VALIDADE.VALUE
   ETQ->CCOR      := ETIQ_1.T_CORES.VALUE
   ETQ->(DBUNLOCK())

	MSGINFO("Dados Gravados !")
  
	ETIQ_1.Browse_1.Refresh
RETURN

*------------------------------------------------------------------------------*
PROCEDURE ActualizaETQ()
*------------------------------------------------------------------------------*
   ETQ->(DbSeek(STR(ETQ->NLOTE,10)))
	ETIQ_1.T_LOTE.VALUE :=STR(ETQ->NLOTE,10)
	ETIQ_1.T_dtlan.VALUE :=ETQ->DTLAN 
   ETIQ_1.T_PECA.VALUE:=IIF(FAM->(DBSEEK(ETQ->CPECA)),FAM->(RECNO()),ETQ->CPECA)   
   ETIQ_1.T_VALIDADE.VALUE:=ETQ->CVALIDADE 
   ETIQ_1.T_CORES.VALUE:=IIF(CADC->(DBSEEK(ETQ->CCOR)),CADC->(RECNO()),0)      
Return
    	   
*------------------------------------------------------------------------------*
Procedure BuscarETQ
*------------------------------------------------------------------------------*
Local Buscar
  Buscar := Upper ( AllTrim ( InputBox( 'Informe N.Lote ' , 'Pesquisa' ) ) )
  If .Not. Empty(Buscar)
    	If ETQ->(DbSeek(str(Buscar,10)))
			ETIQ_1.Browse_1.Value := ETQ->(RecNo())
		Else
         MsgExclamation('Nao encontrado registro')
		EndIf
	EndIf
Return
*------------------------------------------------------------------------------*
PROCEDURE NuevoETQ()
*------------------------------------------------------------------------------*
IF CINCL=.T.
   ETIQ_1.T_LOTE.VALUE := str(EMP->NFIS+1,10)
   ETIQ_1.T_dtlan.VALUE := DATE()
   ETIQ_1.T_PECA.VALUE:=SPACE(10)
	ETIQ_1.T_CORES.VALUE:=SPACE(05)
   ETIQ_1.T_VALIDADE.VALUE:=SPACE(10) 
	
   ActivarETQ()
ENDIF
RETURN

*------------------------------------------------------------------------------*
Procedure EliminarETQ
*------------------------------------------------------------------------------*
IF CEXCL=.T.
	If MsgYesNo ( "Confirma Exclus�o ?","Aten��o")
		If ETQ->(TREG())
			ETQ->(dbdelete())
			ETQ->(DBUNLOCK())
			ETQ->(dbgotop()) 
			ETIQ_1.Browse_1.Value := ETQ->(RecNo())
			ActualizaETQ()
		EndIf
	EndIf
ENDIF
Return

*------------------------------------------------------------------------------*
PROCEDURE IMPETIQPRD
*------------------------------------------------------------------------------*
#include "winprint.ch"
Local dirimp:=GetCurrentFolder(), PAG, LH
Local N_ETIQ:=1
local n_pag:=0
LOCAL BUSCAR

BUSCAR:=Upper ( AllTrim ( InputBox( 'Etiquetas :' , 'Informe Quantidade' ) ) )

N_ETIQ:=VAL(BUSCAR)    

TITULOIMP:="ETIQUETAS DE PEDIDOS"
	
INIT PRINTSYS

SELECT BY DIALOG PREVIEW

IF HBPRNERROR > 0
   RETURN NIL
ENDIF

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

FOR I:=1 TO N_ETIQ

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
    @ LH,03 SAY ETQ->CPECA TO PRINT
    @ LH,26 SAY IIF(FAM->(DBSEEK(ETQ->CPECA)),FAM->DESCMAX,ETQ->CPECA) TO PRINT
    @ LH,02 SAY "_________________________________________" TO PRINT
    LH+=2
    @ LH,03 SAY IIF(CADC->(DBSEEK(ETQ->CCOR)),CADC->DESVED,ETQ->CCOR) TO PRINT
    @ LH,26 SAY "Validade:"+ETQ->CVALIDADE TO PRINT
    @ LH,02 SAY "_________________________________________" TO PRINT
    LH+=1
    @ LH,03 SAY "N� Lote"  to print
    @ LH,26 SAY "Data Fabrica��o" TO PRINT
	 lh+=1
    @ LH,03 SAY STRZERO(ETQ->NLOTE,10) TO PRINT
    @ LH,29 SAY ETQ->DTLAN TO PRINT

    LH+=2
    
NEXT
end page
end doc
release printsys
SetCurrentFolder(dirimp)
RETURN NIL

