#Include "minigui.ch"
#include "winprint.ch"

FUNCTION TABICM
PARAMETERS LIBERA

LiberacaoCiec(LIBERA)

   Public Nuevo := .F.
    	    
	DEFINE WINDOW ICM_2;
	           AT 0,0 ;
 				  WIDTH 780;
              HEIGHT 660 ;
	           TITLE "Tabela de Composição"	;
				  ICON "TUTOR";
		        CHILD ;
		        ON MAXIMIZE ThisWindow.Center ;
		        ON INIT ( DesactivarICM(),ActualizaICM()) 

		DEFINE TOOLBAR ToolBar_1 BUTTONSIZE 59,35 FLAT BORDER
		
			BUTTON PRIMERO 		;
				CAPTION '&Primero' 	;
				PICTURE 'primero'	;
				ACTION ( ICM->(dBGoTop()) , ICM_2.Browse_1.Value := ICM->(RecNo()) ) 

			BUTTON ANTERIOR 	;
				CAPTION '&Anterior' 	;
				PICTURE 'anterior'	;
				ACTION ( ICM->(dBSkip ( -1 )) , ICM_2.Browse_1.Value := ICM->(RecNo()) ) 

			BUTTON SIGUIENTE	;
				CAPTION '&Proximo' 	;
				PICTURE 'siguiente'	;
				ACTION ( ICM->(dBSkip (1)) , if ( Eof() , ICM->(DbGoBottom()) , Nil ) , ICM_2.Browse_1.Value := ICM->(RecNo()) ) 

			BUTTON ULTIMO 		;
				CAPTION '&Ultimo' 	;
				PICTURE 'ultimo'	;
				ACTION ( ICM->(dBGoBottom () ), ICM_2.Browse_1.Value := ICM->(RecNo()) )  SEPARATOR 

			BUTTON BUSCAR 		;
				CAPTION '&Pesquisa' 	;
				PICTURE 'buscar'	;
				ACTION BuscarICM()

			BUTTON Nuevo 		;
				CAPTION '&Novo' 	;
				PICTURE 'nuevo'	;
				ACTION ( Nuevo := .T. , NuevoICM() )

			BUTTON EDITAR 		;
				CAPTION 'A&lterar' 	;
				PICTURE 'editar'	;                    
				ACTION If ( ICM->(TREG() ) ,(Nuevo:=.F.,ActivarICM()) , Nil )

			BUTTON ELIMINAR 	;
				CAPTION 'De&letar'	;
				PICTURE 'borrar'	;
				ACTION EliminarICM() 
				
			BUTTON OBSMPRIMA 	;
				CAPTION '&Observ.'	;
				PICTURE 'check'	;
				ACTION ObsCtrl() 

			BUTTON IMPRIMIR 	;
				CAPTION '&Imprimir'	;
				PICTURE 'imprimir2' ;
				ACTION ImprimirMT(ICM->CODMA) 

			BUTTON CERRAR 	;
				CAPTION '&Fecha'	;
				PICTURE 'FREE' ;
            ACTION ICM_2.release 

		END TOOLBAR
 
                @ 56,10 BROWSE Browse_1				;
			            WIDTH 360  				;
                     HEIGHT 180           ; 
			            HEADERS { 'Massa','Materia Prima','Kilos'} ;
			            WIDTHS { 115, 115, 110 }			;
			            WORKAREA ICM			;
                     FIELDS { 'ICM->CODMA' , 'ICM->CODMT','ICM->CODQTE'} ;
			            ON CHANGE ActualizaICM() ;
			            ON DBLCLICK ( ActivarICM() , If ( ! ICM->(TREG()) , DesactivarICM() , Nil ) )

                     @ 70,400 LABEL AF ;
                              VALUE 'Massa' ;
                              WIDTH 80           ;
                              HEIGHT 30           

                     @100,400 LABEL BF ;
                              VALUE 'Mt.Prima'  ;
                              WIDTH 60           ;
                              HEIGHT 30           

                     @130,400 LABEL CF ;
                              VALUE 'Kilos'  ;
                              WIDTH 60           ;
                              HEIGHT 30           

			    	     @ 070,470 TEXTBOX T_CODMA;
			    	               OF ICM_2 ;
   			                  WIDTH 150 

			    	     @100,470 COMBOBOX T_CODMT;
   			                 ITEMSOURCE FAM->CODMAX+" - "+SUBSTR(FAM->DESCMAX,1,15);	
					  		        VALUESOURCE FAM->CODMAX;
  							        WIDTH 190 HEIGHT 120 ;
  			                    ON ENTER ( CHEKDUPLI())
															  
			    	     @ 130,470 TEXTBOX T_CODQTE ;
			    	               OF ICM_2 ;
   			                  WIDTH 80 ;
  					 		         NUMERIC INPUTMASK '999999.999';
                              ON ENTER ICM_2.Btn_SICM.SetFocus

	                 @ 170,540 BUTTON Btn_SICM Of ICM_2	;
                          CAPTION '&Salvar'             ;
                          ACTION AceptarICM() ;
                          WIDTH 80 HEIGHT 27   ;                                 
                          TOOLTIP "Salvar Registro" ;
                          FLAT

	                 @ 170,640 BUTTON Btn_CICM Of ICM_2	;
		                     CAPTION '&Cancelar'		;
                           ACTION DesactivarICM() ;//ICM_2.RELEASE ;
			                  WIDTH 80 HEIGHT 27		;
                           TOOLTIP "Cancelar Operação"	;
			               FLAT
		               
			           @ 250,010 LABEL OBSMT ;
                              VALUE 'Observações Materia Prima' ;
                              WIDTH 400           ;
                              HEIGHT 30         ;
                              font 'arial' size 14 
                              
			    	     @ 300,010 TEXTBOX T_OBSMT1;
			    	               WIDTH 750
										 
			    	     @ 330,010 TEXTBOX T_OBSMT2;
			    	               WIDTH 750

			    	     @ 360,010 TEXTBOX T_OBSMT3;
			    	               WIDTH 750

			    	     @ 390,010 TEXTBOX T_OBSMT4;
			    	               WIDTH 750
			    	               
			    	     @ 420,010 TEXTBOX T_OBSMT5;
			    	               WIDTH 750
										 
			    	     @ 450,010 TEXTBOX T_OBSMT6;
			    	               WIDTH 750

			    	     @ 480,010 TEXTBOX T_OBSMT7;
			    	               WIDTH 750

			    	     @ 510,010 TEXTBOX T_OBSMT8;
			    	               WIDTH 750			    	               

	                 @ 560,380 BUTTON Btn_OBSMT Of ICM_2	;
		                     CAPTION '&Salva Observações'		;
                           ACTION GRAVAOBSMT() ;
			                  WIDTH 140 HEIGHT 27		;
                           TOOLTIP "Grava os Dados de Observações"	;
			               FLAT
			               
			           @ 560,540 BUTTON Btn_OBSCAN Of ICM_2	;   
						         CAPTION '&Retona';
                           ACTION CANCELAOBS() ;
									WIDTH 80 HEIGHT 27 ;
                           TOOLTIP "Deleta Observações"	; 
							    FLAT 
						  						      
			           @ 560,660 BUTTON Btn_OBSDEL Of ICM_2	;   
						         CAPTION '&Excluir';
                           ACTION DELETAOBS() ;
									WIDTH 80 HEIGHT 27 ;
                           TOOLTIP "Deleta Observações"	; 
							    FLAT 
		                   

	END WINDOW

   ICM_2.Browse_1.SetFocus
	
	ICM_2.CENTER 

	ICM_2.ACTIVATE  

RETURN


*------------------------------------------------------------------------------*
PROCEDURE DesactivarICM
*------------------------------------------------------------------------------*
         ICM_2.Browse_1.Enabled:=.T.
         ICM_2.T_CODMA.Enabled :=.F.
         ICM_2.T_CODMT.Enabled:=.F.
         ICM_2.T_CODQTE.Enabled:=.F.
         
         ICM_2.T_OBSMT1.Enabled:=.F.
         ICM_2.T_OBSMT2.Enabled:=.F.
         ICM_2.T_OBSMT3.Enabled:=.F.
         ICM_2.T_OBSMT4.Enabled:=.F.
         ICM_2.T_OBSMT5.Enabled:=.F.
         ICM_2.T_OBSMT6.Enabled:=.F.
         ICM_2.T_OBSMT7.Enabled:=.F.
         ICM_2.T_OBSMT8.Enabled:=.F.        
			 
         ICM_2.Btn_CICM.Enabled:=.F.
   	   ICM_2.Btn_SICM.Enabled:=.F.
   	   ICM_2.Btn_OBSMT.Enabled:=.F.
   	   ICM_2.Btn_OBSDEL.Enabled:=.F.
         ICM_2.Btn_OBSCAN.Enabled:=.f.   	   
   	   ICM_2.ToolBar_1.Enabled:=.T.
         ICM_2.Browse_1.SetFocus
RETURN
*------------------------------------------------------------------------------*
PROCEDURE ActivarICM
*------------------------------------------------------------------------------*
IF CALTE=.T.
      ICM_2.Browse_1.Enabled:=.F.
      ICM_2.T_CODMA.Enabled:=Nuevo
      ICM_2.T_CODMT.Enabled:=.T.
      ICM_2.T_CODQTE.Enabled:=.T.
	   ICM_2.ToolBar_1.Enabled:=.F.
      ICM_2.Btn_CICM.Enabled:=.T.
   	ICM_2.Btn_SICM.Enabled:=.T.
     	IF !NUEVO
         ICM_2.T_CODMA.Enabled :=.F.
         ICM_2.T_CODMT.Enabled:=.F.
		ENDIF
ENDIF
RETURN
*------------------------------------------------------------------------------*
PROCEDURE CancelarICM()
*------------------------------------------------------------------------------*
	DesactivarICM()
	ActualizaICM()
	icm->(DBUNLOCK())
	Nuevo := .F.
RETURN
*------------------------------------------------------------------------------*
PROCEDURE AceptarICM()
*------------------------------------------------------------------------------*
	DesactivarICM()
	If Nuevo == .T.
		ICM->(DbAppend())
		Nuevo := .F.
	EndIf
   ICM->CODMA  :=ICM_2.T_CODMA.VALUE
	ICM->CODMT  :=ICM_2.T_CODMT.VALUE
	ICM->CODQTE :=ICM_2.T_CODQTE.VALUE
	ICM_2.Browse_1.Refresh
	ICM->(DBUNLOCK())
RETURN

*------------------------------------------------------------------------------*
PROCEDURE ActualizaICM()
*------------------------------------------------------------------------------*
   ICM->(DbSeek(ICM->CODMA+ICM->CODMT))
	ICM_2.T_CODMA.VALUE :=ICM->CODMA
	ICM_2.T_CODMT.VALUE :=if(fam->(dbseek(ICM->CODMT)),fam->(recno()),ICM->CODMT) 
	ICM_2.T_CODQTE.VALUE:=ICM->CODQTE 
	if OMT->(DbSeek(ICM->CODMA+ICM->CODMT))
      ICM_2.T_OBSMT1.Value:=OMT->OBSMT1
      ICM_2.T_OBSMT2.value:=OMT->OBSMT2
      ICM_2.T_OBSMT3.value:=OMT->OBSMT3
      ICM_2.T_OBSMT4.value:=OMT->OBSMT4
      ICM_2.T_OBSMT5.Value:=OMT->OBSMT5
      ICM_2.T_OBSMT6.value:=OMT->OBSMT6
      ICM_2.T_OBSMT7.value:=OMT->OBSMT7
      ICM_2.T_OBSMT8.value:=OMT->OBSMT8
	else
	   ICM_2.T_OBSMT1.Value:=space(80)
      ICM_2.T_OBSMT2.value:=space(80)
      ICM_2.T_OBSMT3.value:=space(80)
      ICM_2.T_OBSMT4.value:=space(80)
      ICM_2.T_OBSMT5.Value:=space(80)
      ICM_2.T_OBSMT6.value:=space(80)
      ICM_2.T_OBSMT7.value:=space(80)
      ICM_2.T_OBSMT8.value:=space(80)
	endif
Return
    	   
*------------------------------------------------------------------------------*
Procedure BuscarICM
*------------------------------------------------------------------------------*
Local Buscar
  Buscar := Upper ( AllTrim ( InputBox( 'Informe Codigo da Massa' , 'Pesquisa' ) ) )
  If .Not. Empty(Buscar)
    	If ICM->(DbSeek(Buscar))
			ICM_2.Browse_1.Value := ICM->(RecNo())
		Else
         MsgExclamation('Não encontrado registro')
		EndIf
	EndIf
Return
*------------------------------------------------------------------------------*
PROCEDURE NuevoICM()
*------------------------------------------------------------------------------*
IF CINCL=.T.
     ICM_2.T_CODMA.value:=space(10)
     ICM_2.T_CODMT.value:=space(10)
     ICM_2.T_CODQTE.value:=0.000
      ActivarICM()
ENDIF
RETURN

*------------------------------------------------------------------------------*
Procedure EliminarICM
*------------------------------------------------------------------------------*
local x_CODMA
local x_CODMT
IF CEXCL=.T.
	If MsgYesNo ( "Confirma Exclusão ?","Atenção")
	   x_CODMA:=ICM->CODMA
      x_CODMT:=ICM->CODMT
		If ICM->(TREG())
			ICM->(dbdelete())
			ICM->(DBUNLOCK())
			ICM->(dbgotop()) 
			if OMT->(DbSeek(x_CODMA+x_CODMT))
            OMT->(TREG())
            OMT->(DBDELETE())
            OMT->(DBUNLOCK())
         endif 
	   endif		 
		ICM_2.Browse_1.Value := ICM->(RecNo()) 
		ActualizaICM()
	EndIf
ENDIF
Return

*------------------------------------------------------------------------------*
Procedure CHEKDUPLI
*------------------------------------------------------------------------------*
LOCAL C_CODMA:=ICM_2.T_CODMA.value+REPLICAT(SPACE(01),10-LEN(ICM_2.T_CODMA.value))
LOCAL C_CODMT:=ICM_2.T_CODMT.value+REPLICAT(SPACE(01),10-LEN(ICM_2.T_CODMT.value))
if Nuevo
   if icm->(dbseek(C_CODMA+C_CODMT))
	   Msginfo("Codigo de Massa + Matéria Prime já Cadastrados!","Verifique")
      ICM_2.T_CODMT.value :=space(10)
      ICM_2.T_CODMT.SETFOCUS
      DesactivarICM()
	endif
endif
return 	

*------------------------------------------------------------------------------*
Procedure ObsCtrl
*------------------------------------------------------------------------------*
DesactivarICM()
ICM_2.Browse_1.Enabled:=.f.
ICM_2.T_OBSMT1.Enabled:=.t.
ICM_2.T_OBSMT2.Enabled:=.t.
ICM_2.T_OBSMT3.Enabled:=.t.
ICM_2.T_OBSMT4.Enabled:=.t.
ICM_2.T_OBSMT5.Enabled:=.t.
ICM_2.T_OBSMT6.Enabled:=.t.
ICM_2.T_OBSMT7.Enabled:=.t.
ICM_2.T_OBSMT8.Enabled:=.t.
ICM_2.Btn_OBSDEL.Enabled:=.t.
ICM_2.Btn_OBSCAN.Enabled:=.T.
                           
if OMT->(DbSeek(ICM->CODMA+ICM->CODMT))
   ICM_2.T_OBSMT1.Value:=OMT->OBSMT1
   ICM_2.T_OBSMT2.value:=OMT->OBSMT2
   ICM_2.T_OBSMT3.value:=OMT->OBSMT3
   ICM_2.T_OBSMT4.value:=OMT->OBSMT4
   ICM_2.T_OBSMT5.Value:=OMT->OBSMT5
   ICM_2.T_OBSMT6.value:=OMT->OBSMT6
   ICM_2.T_OBSMT7.value:=OMT->OBSMT7
   ICM_2.T_OBSMT8.value:=OMT->OBSMT8
Else
   ICM_2.T_OBSMT1.Value:=space(80)
   ICM_2.T_OBSMT2.value:=space(80)
   ICM_2.T_OBSMT3.value:=space(80)
   ICM_2.T_OBSMT4.value:=space(80)
   ICM_2.T_OBSMT5.Value:=space(80)
   ICM_2.T_OBSMT6.value:=space(80)
   ICM_2.T_OBSMT7.value:=space(80)
   ICM_2.T_OBSMT8.value:=space(80)   
endif
ICM_2.Btn_OBSMT.Enabled:=.T.
return

*------------------------------------------------------------------------------*
Procedure GRAVAOBSMT()
*------------------------------------------------------------------------------*
if OMT->(DbSeek(ICM->CODMA+ICM->CODMT))
   OMT->(TREG())
Else
   OMT->(DBAPPEND())
   OMT->ocodma:=ICM_2.T_CODMA.value
	OMT->ocodmt:=ICM_2.T_CODMT.value
endif	
OMT->OBSMT1:=ICM_2.T_OBSMT1.Value
OMT->OBSMT2:=ICM_2.T_OBSMT2.value
OMT->OBSMT3:=ICM_2.T_OBSMT3.value
OMT->OBSMT4:=ICM_2.T_OBSMT4.value
OMT->OBSMT5:=ICM_2.T_OBSMT5.Value
OMT->OBSMT6:=ICM_2.T_OBSMT6.value
OMT->OBSMT7:=ICM_2.T_OBSMT7.value
OMT->OBSMT8:=ICM_2.T_OBSMT8.value
OMT->(DBUNLOCK())
CANCELAOBS() 
DesactivarICM()
return

*------------------------------------------------------------------------------*
Procedure DELETAOBS()
*------------------------------------------------------------------------------*
if OMT->(DbSeek(ICM->CODMA+ICM->CODMT))
   If MsgYesNo ('Confirma Exclusão da Observações ?','Atenção')
      OMT->(TREG())
      OMT->(DBDELETE())
      OMT->(DBUNLOCK())
      Msginfo("Exclusão da Observações!","Realizada")
   ENDIF   
endif
CANCELAOBS()
DesactivarICM()
return

*------------------------------------------------------------------------------*
Procedure CANCELAOBS() 
*------------------------------------------------------------------------------*
ICM_2.Browse_1.Enabled:=.f.
ICM_2.T_OBSMT1.Enabled:=.F.
ICM_2.T_OBSMT2.Enabled:=.f.
ICM_2.T_OBSMT3.Enabled:=.f.
ICM_2.T_OBSMT4.Enabled:=.f.
ICM_2.T_OBSMT5.Enabled:=.F.
ICM_2.T_OBSMT6.Enabled:=.f.
ICM_2.T_OBSMT7.Enabled:=.f.
ICM_2.T_OBSMT8.Enabled:=.f.
ICM_2.Btn_OBSDEL.Enabled:=.f.
ICM_2.Btn_OBSMT.Enabled:=.f.
ICM_2.Btn_OBSCAN.Enabled:=.f.
return

*------------------------------------------------------------------------------*
Procedure ImprimirMT(MASSA) 
*------------------------------------------------------------------------------*
Local dirimp:=GetCurrentFolder(), PAG, LH
LOCAL nOption:=0
LOCAL TituloImp:="Massa_"+alltrim(MASSA)
Init PRINTSYS 

Request HB_CODEPAGE_PT850
prys:="maxipaint.bmp"

PAG:=0
LH:=0 
if ! icm->(dbseek(MASSA))
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

Do WHILE ICM->(!EOF()) .AND. ICM->CODMA == MASSA
   CCMASSA :=ICM->CODMA

	start page

   DO WHILE ICM->(!EOF()) .AND. ICM->CODMA == CCMASSA
      IF LH > 260 .OR. PAG=0
         IF PAG=0
            //@ 03,08 PICTURE prys SIZE 25,30 
            select font "ft18"
            @ 10,070 SAY "Tabela de Composição" TO PRINT
            @ 20,040 SAY "Massa :"+ICM->CODMA TO PRINT
            select font "ft10"
            LH:=30
            @ LH,08,LH+5,35 RECTANGLE
            @ LH,35,LH+5,55 RECTANGLE  
            @ LH,55,LH+5,100 RECTANGLE
            @ LH,09 SAY "Materia Prima" TO PRINT
	         @ LH,36 SAY "Quantidade" TO PRINT
	         @ LH,56 SAY "Observações" TO PRINT
            lh+=5
          Else
			   lh+=40
		    Endif
          PAG++
		ENDIF	 
      @ LH,08,LH+5,55 RECTANGLE
      @ LH,35,LH+5,55 RECTANGLE  
      @ LH,55,LH+5,100 RECTANGLE
      @ LH,09 SAY ICM->CODMT TO PRINT
	   @ LH,36 SAY STR(ICM->CODQTE,12,3) TO PRINT
      LH+=5
	   ICM->(DBSKIP())
	EndDo   
	lh+=5   
   
   IF OMT->(DbSeek(CCMASSA))
      @ LH,08,LH+5,100 RECTANGLE
      @ LH,50 SAY " # Processo de Mistura # " TO PRINT 
      LH+=5
		@ LH,08,LH+5,100 RECTANGLE
      @ LH,08 SAY OMT->OBSMT1 TO PRINT
      LH+=5
   	@ LH,08,LH+5,100 RECTANGLE
      @ LH,08 SAY OMT->OBSMT2 TO PRINT
      LH+=5
		@ LH,08,LH+5,100 RECTANGLE
      @ LH,08 SAY OMT->OBSMT3 TO PRINT
      LH+=5
		@ LH,08,LH+5,100 RECTANGLE
      @ LH,08 SAY OMT->OBSMT4 TO PRINT
      LH+=5
		@ LH,08,LH+5,100 RECTANGLE
      @ LH,08 SAY OMT->OBSMT5 TO PRINT
      LH+=5
   	@ LH,08,LH+5,100 RECTANGLE
      @ LH,08 SAY OMT->OBSMT6 TO PRINT
      LH+=5
		@ LH,08,LH+5,100 RECTANGLE
      @ LH,08 SAY OMT->OBSMT7 TO PRINT
      LH+=5
		@ LH,08,LH+5,100 RECTANGLE
      @ LH,08 SAY OMT->OBSMT8 TO PRINT      
   ENDIF
	LH+=5

   END page
   EXIT
EndDo  
END doc
Release printsys
SetCurrentFolder(dirimp)

Return NIL