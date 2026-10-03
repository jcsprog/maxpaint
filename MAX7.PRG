#Include "minigui.ch"
#include "winprint.ch"

FUNCTION TBFORM
PARAMETERS LIBERA

LiberacaoCiec(LIBERA)

   Public Nuevo := .F.
	Public a_Massas:={}

	a_Massas:={}
	ICM->(DBGOTOP())
	Do while ICM->(!EOF())
	   V_MASSA:=ICM->CODMA
	   aadd(a_Massas,icm->codma)
		Do while ICM->(!EOF()) .and. icm->codma = V_MASSA
		   ICM->(Dbskip())
		Enddo
   Enddo
    	    
	DEFINE WINDOW FOR_2;
	           AT 0,0 ;
 				  WIDTH 700;
              HEIGHT 330 ;
	           TITLE "Controle de Formulas"	;
				  ICON "TUTOR";
		        CHILD ;
		        ON MAXIMIZE ThisWindow.Center ;
		        ON INIT ( DesactivarFORM(),ActualizaFORM()) 

		DEFINE TOOLBAR ToolBar_1 BUTTONSIZE 59,35 FLAT BORDER
		
			BUTTON PRIMERO 		;
				CAPTION '&Primero' 	;
				PICTURE 'primero'	;
				ACTION ( FORM->(dBGoTop()) , FOR_2.Browse_1.Value := FORM->(RecNo()) ) 

			BUTTON ANTERIOR 	;
				CAPTION '&Anterior' 	;
				PICTURE 'anterior'	;
				ACTION ( FORM->(dBSkip ( -1 )) , FOR_2.Browse_1.Value := FORM->(RecNo()) ) 

			BUTTON SIGUIENTE	;
				CAPTION '&Proximo' 	;
				PICTURE 'siguiente'	;
				ACTION ( FORM->(dBSkip (1)) , if ( Eof() , FORM->(DbGoBottom()) , Nil ) , FOR_2.Browse_1.Value := FORM->(RecNo()) ) 

			BUTTON ULTIMO 		;
				CAPTION '&Ultimo' 	;
				PICTURE 'ultimo'	;
				ACTION ( FORM->(dBGoBottom () ), FOR_2.Browse_1.Value := FORM->(RecNo()) )  SEPARATOR 

			BUTTON BUSCAR 		;
				CAPTION '&Pesquisa' 	;
				PICTURE 'buscar'	;
				ACTION BuscarFORM()

			BUTTON Nuevo 		;
				CAPTION '&Novo' 	;
				PICTURE 'nuevo'	;
				ACTION ( Nuevo := .T. , NuevoFORM() )

			BUTTON EDITAR 		;
				CAPTION 'A&lterar' 	;
				PICTURE 'editar'	;
				ACTION If ( FORM->(TREG() ) , ActivarFORM() , Nil )

			BUTTON ELIMINAR 	;
				CAPTION 'De&letar'	;
				PICTURE 'borrar'	;
				ACTION EliminarFORM() 
				
			BUTTON IMPRIMIR 	;
				CAPTION '&Imprimir'	;
				PICTURE 'imprimir2' ;
				ACTION ImpriFORM(FORM->CODMA) 

			BUTTON CERRAR 	;
				CAPTION '&Fecha'	;
				PICTURE 'FREE' ;
            ACTION FOR_2.release 

		END TOOLBAR
 
                @ 56,10 BROWSE Browse_1				;
			            WIDTH 270  				;
                     HEIGHT 180           ; 
			            HEADERS { 'Massa','Materia Prima'} ;
			            WIDTHS { 115, 115 }			;
			            WORKAREA FORM			;
                     FIELDS { 'FORM->CODMA' , 'FORM->CODMT'} ;
			            ON CHANGE ActualizaFORM() ;
			            ON DBLCLICK ( ActivarFORM() , If ( ! FORM->(TREG()) , DesactivarFORM() , Nil ) )

                     @ 70,300 LABEL AF ;
                              VALUE 'Massa' ;
                              WIDTH 80           ;
                              HEIGHT 30           

                     @100,300 LABEL BF ;
                              VALUE 'Mt.Prima'  ;
                              WIDTH 60           ;
                              HEIGHT 30           

                     @130,300 LABEL Bm ;
                              VALUE 'Quantidade'  ;
                              WIDTH 70           ;
                              HEIGHT 30           

            		  @ 070,370 COMBOBOX T_CODMA ;
			                     WIDTH 150 ;
			                     ITEMS a_Massas ;
			                     VALUE 1 

			    	     @100,370 COMBOBOX T_CODMT;
   			                 ITEMSOURCE FAM->CODMAX+" - "+SUBSTR(FAM->DESCMAX,1,15);	
					  		        VALUESOURCE FAM->CODMAX;
  							        WIDTH 190 HEIGHT 120 ;
  			                    ON ENTER ( CHEKDPLform())

			    	     @ 130,370 TEXTBOX T_CODQTE ;
			    	               OF ICM_2 ;
   			                  WIDTH 80 ;
  					 		         NUMERIC INPUTMASK '999999.999'
															  
	                 @ 170,370 BUTTON Btn_SFORM Of FOR_2	;
                          CAPTION '&Salvar'             ;
                          ACTION AceptarFORM() ;
                          WIDTH 80 HEIGHT 27   ;                                 
                          TOOLTIP "Salvar Registro" ;
                          FLAT

	                 @ 170,470 BUTTON Btn_CFORM Of FOR_2	;
		                     CAPTION '&Cancelar'		;
                           ACTION DesactivarFORM() ;//FOR_2.RELEASE ;
			                  WIDTH 80 HEIGHT 27		;
                           TOOLTIP "Cancelar Operação"	;
			               FLAT

	END WINDOW

   FOR_2.Browse_1.SetFocus
	
	FOR_2.CENTER 

	FOR_2.ACTIVATE

RETURN


*------------------------------------------------------------------------------*
PROCEDURE DesactivarFORM
*------------------------------------------------------------------------------*
         FOR_2.Browse_1.Enabled:=.T.
         FOR_2.T_CODMA.Enabled :=.F.
         FOR_2.T_CODMT.Enabled:=.F.
         FOR_2.T_CODQTE.Enabled:=.F. 
         FOR_2.Btn_CFORM.Enabled:=.F.
   	   FOR_2.Btn_SFORM.Enabled:=.F.
   	   
   	   FOR_2.ToolBar_1.Enabled:=.T.
         FOR_2.Browse_1.SetFocus
RETURN
*------------------------------------------------------------------------------*
PROCEDURE ActivarFORM
*------------------------------------------------------------------------------*
IF CALTE=.T.
         FOR_2.Browse_1.Enabled:=.F.
         FOR_2.T_CODMA.Enabled :=Nuevo
         FOR_2.T_CODMT.Enabled:=.T.
         FOR_2.T_CODQTE.Enabled:=.T.
	      FOR_2.ToolBar_1.Enabled:= .F.
         FOR_2.Btn_CFORM.Enabled:= .T.
      	FOR_2.Btn_SFORM.Enabled:= .T.
ENDIF
RETURN
*------------------------------------------------------------------------------*
PROCEDURE CancelarFORM()
*------------------------------------------------------------------------------*
	DesactivarFORM()
	ActualizaFORM()
	FORM->(dbUNLOCK())
	Nuevo := .F.
RETURN
*------------------------------------------------------------------------------*
PROCEDURE AceptarFORM()
*------------------------------------------------------------------------------*
	DesactivarFORM()
	If Nuevo == .T.
		FORM->(DbAppend())
		Nuevo := .F.
	EndIf
   FORM->CODMA  :=A_MASSAS[FOR_2.T_CODMA.VALUE]
	FORM->CODMT  :=FOR_2.T_CODMT.VALUE
   FORM->CODQTE :=FOR_2.T_CODQTE.VALUE
	FOR_2.Browse_1.Refresh
	FORM->(DBUNLOCK())
RETURN

*------------------------------------------------------------------------------*
PROCEDURE ActualizaFORM()
*------------------------------------------------------------------------------*
   FORM->(DbSeek(FORM->CODMA+FORM->CODMT))
	FOR_2.T_CODMA.VALUE :=ASCAN(a_Massas,FORM->CODMA)
	FOR_2.T_CODMT.VALUE :=if(fam->(dbseek(FORM->CODMT)),fam->(recno()),FORM->CODMT) 
	FOR_2.T_CODQTE.VALUE:=FORM->CODQTE

Return
    	   
*------------------------------------------------------------------------------*
Procedure BuscarFORM
*------------------------------------------------------------------------------*
Local Buscar
  Buscar := Upper ( AllTrim ( InputBox( 'Informe Codigo da Massa' , 'Pesquisa' ) ) )
  If .Not. Empty(Buscar)
    	If FORM->(DbSeek(Buscar))
			FOR_2.Browse_1.Value := FORM->(RecNo())
		Else
         MsgExclamation('Nao encontrado registro')
		EndIf
	EndIf
Return
*------------------------------------------------------------------------------*
PROCEDURE NuevoFORM()
*------------------------------------------------------------------------------*
IF CINCL=.T.
     FOR_2.T_CODMA.value:=space(10)
     FOR_2.T_CODMT.value:=space(10)
     FOR_2.T_CODQTE.VALUE:=0.000
     ActivarFORM()
ENDIF
RETURN

*------------------------------------------------------------------------------*
Procedure EliminarFORM
*------------------------------------------------------------------------------*
IF CEXCL=.T.
	If MsgYesNo ( "Confirma Exclusão ?","Atenção")
		If FORM->(TREG())
			FORM->(dbdelete())
			FORM->(DBUNLOCK())
			FORM->(dbgotop()) 
			FOR_2.Browse_1.Value := FORM->(RecNo())
			ActualizaFORM()
		EndIf
	EndIf
ENDIF
Return

*------------------------------------------------------------------------------*
Procedure CHEKDPLform() 
*------------------------------------------------------------------------------*
LOCAL C_CODMA:=FOR_2.T_CODMA.value+REPLICAT(SPACE(01),10-LEN(FOR_2.T_CODMA.value))
LOCAL C_CODMT:=FOR_2.T_CODMT.value+REPLICAT(SPACE(01),10-LEN(FOR_2.T_CODMT.value))
if Nuevo
   if FORM->(dbseek(C_CODMA+C_CODMT))
	   Msginfo("Codigo de Massa + Matéria Prime já Cadastrados!","Verifique")
      FOR_2.T_CODMT.value :=space(10)
      FOR_2.T_CODMT.SETFOCUS
	endif
endif
return 	

*------------------------------------------------------------------------------*
Procedure ImpriFORM(MASSA) 
*------------------------------------------------------------------------------*
Local dirimp:=GetCurrentFolder(), PAG, LH
LOCAL nOption:=0
LOCAL TituloImp:="Massa_"+alltrim(MASSA)
Init PRINTSYS

Request HB_CODEPAGE_PT850
prys:="maxipaint.bmp"

PAG:=0
LH:=0 
if ! FORM->(dbseek(MASSA))
   Msginfo("Não Encontrada Massa :"+MASSA+"!","Verifique")
   return
endif

SELECT BY DIALOG PREVIEW

IF HBPRNERROR>0
   release printsys
   SetCurrentFolder(dirimp)
   return nil
ENDIF
   
HB_SETCODEPAGE( "PT850" )

SET UNITS MM
define font "ft08" name "times new roman" size 08
define font "ft10" name "times new roman" size 10
define font "ft12" name "times new roman" size 12 //bold=negrita
define font "ft14" name "times new roman" size 14
define font "ft18" name "times new roman" size 18

define pen "p0" style PS_SOLID width 1 color 0x000000
define pen "p1" style PS_DOT width 1 color 0xFF0000
define pen "p2" style PS_NULL

select font "ft10"
select pen "p0"

set page orientation DMORIENT_PORTRAIT papersize DMPAPER_A4 font "ft10"
start doc name TituloImp

Do WHILE FORM->(!EOF()) .AND. FORM->CODMA == MASSA
   CCMASSA :=FORM->CODMA

	start page

   DO WHILE FORM->(!EOF()) .AND. FORM->CODMA == CCMASSA
      IF LH > 260 .OR. PAG=0
         IF PAG=0
            //@ 03,08 PICTURE prys SIZE 25,30 
            select font "ft18"
            @ 10,070 SAY "Controle de Formulas" TO PRINT
            @ 20,040 SAY "Massa :"+FORM->CODMA TO PRINT
            select font "ft10"
            LH:=30
            @ LH,08,LH+5,35 RECTANGLE
            @ LH,09 SAY "Materia Prima" TO PRINT
            lh+=5
          Else
			   lh+=40
		    Endif
          PAG++
		ENDIF	 
      @ LH,08,LH+5,55 RECTANGLE
      @ LH,09 SAY FORM->CODMT TO PRINT
      LH+=5
	   FORM->(DBSKIP())
	EndDo   
	lh+=5   

   END page
   EXIT
EndDo  
END doc
Release printsys
SetCurrentFolder(dirimp)

Return NIL