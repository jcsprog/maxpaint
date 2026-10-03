#Include "minigui.ch"

FUNCTION CORTINTAS
PARAMETERS LIBERA

LiberacaoCiec(LIBERA)

   Public Nuevo := .F.
    	    
	DEFINE WINDOW MAX_2;
	           AT 0,0 ;
 				  WIDTH 700;
              HEIGHT 340 ;
	           TITLE "Cores das Tintas"	;
				  ICON "TUTOR";
		        CHILD ;
		        ON MAXIMIZE ThisWindow.Center ;
		        ON INIT ( DesactivarCADC(),ActualizaCADC()) 

		DEFINE TOOLBAR ToolBar_1 BUTTONSIZE 59,35 FLAT BORDER

			BUTTON PRIMERO 		;
				CAPTION '&Primero' 	;
				PICTURE 'primero'	;
				ACTION ( CADC->(dBGoTop()) , MAX_2.Browse_1.Value := CADC->(RecNo()) ) 

			BUTTON ANTERIOR 	;
				CAPTION '&Anterior' 	;
				PICTURE 'anterior'	;
				ACTION ( CADC->(dBSkip ( -1 )) , MAX_2.Browse_1.Value := CADC->(RecNo()) ) 

			BUTTON SIGUIENTE	;
				CAPTION '&Proximo' 	;
				PICTURE 'siguiente'	;
				ACTION ( CADC->(dBSkip (1)) , if ( Eof() , CADC->(DbGoBottom()) , Nil ) , MAX_2.Browse_1.Value := CADC->(RecNo()) ) 

			BUTTON ULTIMO 		;
				CAPTION '&Ultimo' 	;
				PICTURE 'ultimo'	;
				ACTION ( CADC->(dBGoBottom () ), MAX_2.Browse_1.Value := CADC->(RecNo()) )  SEPARATOR 

			BUTTON BUSCAR 		;
				CAPTION '&Pesquisa' 	;
				PICTURE 'buscar'	;
				ACTION BuscarCADC()

			BUTTON Nuevo 		;
				CAPTION '&Novo' 	;
				PICTURE 'nuevo'	;
				ACTION ( Nuevo := .T. , NuevoCADC() )

			BUTTON EDITAR 		;
				CAPTION 'A&lterar' 	;
				PICTURE 'editar'	;
				ACTION  If(CADC->(TREG()),ActivarCADC(),Nil)

			BUTTON ELIMINAR 	;
				CAPTION 'De&letar'	;
				PICTURE 'borrar'	;
				ACTION EliminarCADC() 

			BUTTON IMPRIMIR 	;
				CAPTION '&Imprimir'	;
				PICTURE 'imprimir2' ;
				ACTION ImprimirCADC() 

			BUTTON CERRAR 	;
				CAPTION '&Fecha'	;
				PICTURE 'cerrar' ;
                ACTION MAX_2.release 
	
		END TOOLBAR
 
                @ 56,10 BROWSE Browse_1				;
			            WIDTH 300  				;
                     HEIGHT 200           ; 
			            HEADERS { 'Codigo','Descrição'} ;
			            WIDTHS { 100, 180,80 }			;
			            WORKAREA CADC			;
                     FIELDS { 'CADC->CODVED' , 'CADC->DESVED'} ;
			            ON CHANGE ActualizaCADC() ;
			            ON DBLCLICK ( ActivarCADC() , If ( ! CADC->(TREG()) , DesactivarCADC() , Nil ) )

                     @ 70,350 LABEL AF ;
                              VALUE 'Codigo' ;
                              WIDTH 80           ;
                              HEIGHT 30           

                     @100,350 LABEL BF ;
                              VALUE 'Descrição'  ;
                              WIDTH 60           ;
                              HEIGHT 30           

			    	     @ 070,430 TEXTBOX T_CODVED;
			    	               OF MAX_2 ;
   			                  WIDTH 100 

			    	     @ 100,430 TEXTBOX T_DESVED;
			    	               OF MAX_2 ;
   			                  WIDTH 200 ;
                              ON ENTER MAX_2.Btn_SCADC.SetFocus

	                 @ 170,430 BUTTON Btn_SCADC Of MAX_2	;
                          CAPTION '&Salvar'             ;
                          ACTION AceptarCADC() ;
                          WIDTH 80 HEIGHT 27   ;                                 
                          TOOLTIP "Salvar Registro" ;
                          FLAT

	                 @ 170,520 BUTTON Btn_CCADC Of MAX_2	;
		                     CAPTION '&Cancelar'		;
                           ACTION CancelarCADC() ;
			                  WIDTH 80 HEIGHT 27		;
                           TOOLTIP "Cancelar Operação"	;
			               FLAT

	END WINDOW

   MAX_2.Browse_1.SetFocus
	
	MAX_2.CENTER

	MAX_2.ACTIVATE

RETURN
*------------------------------------------------------------------------------*
PROCEDURE DesactivarCADC
*------------------------------------------------------------------------------*
         MAX_2.Browse_1.Enabled:=.T.
         MAX_2.T_CODVED.Enabled :=.F.
         MAX_2.T_DESVED.Enabled:=.F.
         MAX_2.Btn_CCADC.Enabled:=.F.
   	   MAX_2.Btn_SCADC.Enabled:=.F.
         MAX_2.ToolBar_1.Enabled:=.T.
         MAX_2.Browse_1.SetFocus
RETURN
*------------------------------------------------------------------------------*
PROCEDURE ActivarCADC
*------------------------------------------------------------------------------*
IF CALTE=.T.
         MAX_2.Browse_1.Enabled:=.F.
         MAX_2.T_DESVED.Enabled:=.T.
	      MAX_2.ToolBar_1.Enabled:= .F.
         MAX_2.Btn_CCADC.Enabled:= .T.
      	MAX_2.Btn_SCADC.Enabled:= .T.
ENDIF
RETURN
*------------------------------------------------------------------------------*
PROCEDURE CancelarCADC()
*------------------------------------------------------------------------------*
	DesactivarCADC()
	ActualizaCADC()
	CADC->(dbUNLOCK())
	Nuevo := .F.
RETURN
*------------------------------------------------------------------------------*
PROCEDURE AceptarCADC()
*------------------------------------------------------------------------------*
	DesactivarCADC()

	If Nuevo == .T.
		CADC->(DbAppend())
		Nuevo := .F.
	EndIf
   CADC->CODVED :=MAX_2.T_CODVED.VALUE
	CADC->DESVED :=MAX_2.T_DESVED.VALUE
	MAX_2.Browse_1.Refresh
	CADC->(DBUNLOCK())
RETURN

*------------------------------------------------------------------------------*
PROCEDURE ActualizaCADC()
*------------------------------------------------------------------------------*
   CADC->(Dbseek(CADC->CODVED))
	MAX_2.T_CODVED.VALUE:=CADC->CODVED
	MAX_2.T_DESVED.VALUE:=CADC->DESVED 
Return
       	   
*------------------------------------------------------------------------------*
Procedure BuscarCADC
*------------------------------------------------------------------------------*
Local Buscar

  CADC->(dbsetorder(1))
  Buscar := Upper ( AllTrim ( InputBox( 'Informe Codigo' , 'Pesquisa' ) ) )
  If .Not. Empty(Buscar)
    	If CADC->(DbSeek(Buscar))
			MAX_2.Browse_1.Value := CADC->(RecNo())
		Else
         MsgExclamation('Nao encontrado registro')
		EndIf
	EndIf

	CADC->(DBSETORDER(1))
Return


*------------------------------------------------------------------------------*
PROCEDURE NuevoCADC()
*------------------------------------------------------------------------------*
IF CINCL=.T.
   MAX_2.T_CODVED.Value:=REPLIC("0",5-LEN(LTRIM(STR(VAL(CADC->CODVED)+1,5))))+LTRIM(STR(VAL(CADC->CODVED)+1,5))
	MAX_2.T_DESVED.Value:=SPACE(15)
   ActivarCADC()
ENDIF
RETURN

*------------------------------------------------------------------------------*
Procedure EliminarCADC
*------------------------------------------------------------------------------*
IF CEXCL=.T.
  	If MsgYesNo ( "Confirma Exclusão ?","Atenção")
   	If CADC->(TREG())
	   	CADC->(dbdelete())
  			CADC->(DBUNLOCK())
	   	CADC->(dbgotop()) 
  			MAX_2.Browse_1.Value := CADC->(RecNo())
   		ActualizaCADC()
   	endif	   
   endif 	
ENDIF	
Return

*--------------------------------------------------------*
FUNCTION ImprimirCADC()
*--------------------------------------------------------*
	CADC->(RecNo())
	
	DO REPORT								;
      title  empresa+'| Cadastro Cores das Tintas' ;
      headers  {'',''} , { 'Codigo', 'Descricao'} ;
      fields   {'CADC->CODVED','CADC->DESVED'}   ;
      widths   {10,60}                                        ;
      totals   {.F.,.F.}                                      ;
      nformats {'',''}                                        ;
      workarea cadp                                                           ;
		LPP 50								;
		CPL 80								;
		LMARGIN 5							;
		PREVIEW							
Return
