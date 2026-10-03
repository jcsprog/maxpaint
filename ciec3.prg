#Include "minigui.ch"

FUNCTION PRODUTO
PARAMETERS LIBERA

LiberacaoCiec(LIBERA)

   Public Nuevo := .F.
    	    
	DEFINE WINDOW PROD_2;
	           AT 0,0 ;
 				  WIDTH 700;
              HEIGHT 340 ;
	           TITLE "Embalagens"	;
				  ICON "TUTOR";
		        CHILD ;
		        ON MAXIMIZE ThisWindow.Center ;
		        ON INIT ( DesactivarPROD(),ActualizaPROD()) 

		DEFINE TOOLBAR ToolBar_1 BUTTONSIZE 59,35 FLAT BORDER

			BUTTON PRIMERO 		;
				CAPTION '&Primero' 	;
				PICTURE 'primero'	;
				ACTION ( CADP->(dBGoTop()) , PROD_2.Browse_1.Value := CADP->(RecNo()) ) 

			BUTTON ANTERIOR 	;
				CAPTION '&Anterior' 	;
				PICTURE 'anterior'	;
				ACTION ( CADP->(dBSkip ( -1 )) , PROD_2.Browse_1.Value := CADP->(RecNo()) ) 

			BUTTON SIGUIENTE	;
				CAPTION '&Proximo' 	;
				PICTURE 'siguiente'	;
				ACTION ( CADP->(dBSkip (1)) , if ( Eof() , CADP->(DbGoBottom()) , Nil ) , PROD_2.Browse_1.Value := CADP->(RecNo()) ) 

			BUTTON ULTIMO 		;
				CAPTION '&Ultimo' 	;
				PICTURE 'ultimo'	;
				ACTION ( CADP->(dBGoBottom () ), PROD_2.Browse_1.Value := CADP->(RecNo()) )  SEPARATOR 

			BUTTON BUSCAR 		;
				CAPTION '&Pesquisa' 	;
				PICTURE 'buscar'	;
				ACTION BuscarPROD()

			BUTTON Nuevo 		;
				CAPTION '&Novo' 	;
				PICTURE 'nuevo'	;
				ACTION ( Nuevo := .T. , NuevoPROD() )

			BUTTON EDITAR 		;
				CAPTION 'A&lterar' 	;
				PICTURE 'editar'	;
				ACTION If ( CADP->(TREG() ) , ActivarPROD() , Nil )

			BUTTON ELIMINAR 	;
				CAPTION 'De&letar'	;
				PICTURE 'borrar'	;
				ACTION EliminarPROD() 

			BUTTON IMPRIMIR 	;
				CAPTION '&Imprimir'	;
				PICTURE 'imprimir2' ;
				ACTION ImprimirPROD() 

			BUTTON CERRAR 	;
				CAPTION '&Fecha'	;
				PICTURE 'cerrar' ;
                ACTION PROD_2.release 

		END TOOLBAR
 
                @ 56,10 BROWSE Browse_1				;
			            WIDTH 300  				;
                     HEIGHT 200           ; 
			            HEADERS { 'Codigo','Descrição','Controle'} ;
			            WIDTHS { 100, 180,80 }			;
			            WORKAREA CADP			;
                     FIELDS { 'CADP->CODPEC' , 'CADP->DESPEC','CADP->CONTROLE' } ;
			            ON CHANGE ActualizaPROD() ;
			            ON DBLCLICK ( ActivarPROD() , If ( ! CADP->(TREG()) , DesactivarPROD() , Nil ) )

                     @ 70,350 LABEL AF ;
                              VALUE 'Codigo' ;
                              WIDTH 80           ;
                              HEIGHT 30           

                     @100,350 LABEL BF ;
                              VALUE 'Descrição'  ;
                              WIDTH 60           ;
                              HEIGHT 30           

                     @130,350 LABEL CF ;
                              VALUE 'Controle'  ;
                              WIDTH 60           ;
                              HEIGHT 30           

			    	     @ 070,430 TEXTBOX T_CODPEC;
			    	               OF PROD_2 ;
   			                  WIDTH 100 

			    	     @ 100,430 TEXTBOX T_DESPEC;
			    	               OF PROD_2 ;
   			                  WIDTH 200 ;
                              ON ENTER PROD_2.Btn_SPROD.SetFocus

                    @ 130,430 TEXTBOX T_CONTROLE;
                             OF FAM_2 ;
                             WIDTH 120  ;                              								
   					 		     NUMERIC INPUTMASK '999999.999'	

	                 @ 170,430 BUTTON Btn_SPROD Of PROD_2	;
                          CAPTION '&Salvar'             ;
                          ACTION AceptarPROD() ;
                          WIDTH 80 HEIGHT 27   ;                                 
                          TOOLTIP "Salvar Registro" ;
                          FLAT

	                 @ 170,520 BUTTON Btn_CPROD Of PROD_2	;
		                     CAPTION '&Cancelar'		;
                           ACTION CancelarPROD() ;
			                  WIDTH 80 HEIGHT 27		;
                           TOOLTIP "Cancelar Operação"	;
			               FLAT

	END WINDOW

   PROD_2.Browse_1.SetFocus
	
	PROD_2.CENTER 

	PROD_2.ACTIVATE 

RETURN
*------------------------------------------------------------------------------*
PROCEDURE DesactivarPROD
*------------------------------------------------------------------------------*
         PROD_2.Browse_1.Enabled:=.T.
         PROD_2.T_CODPEC.Enabled :=.F.
         PROD_2.T_DESPEC.Enabled:=.F.
         PROD_2.T_CONTROLE.Enabled:=.F.
         PROD_2.Btn_CPROD.Enabled:=.F.
   	   PROD_2.Btn_SPROD.Enabled:=.F.
         PROD_2.ToolBar_1.Enabled:=.T.
         PROD_2.Browse_1.SetFocus
RETURN
*------------------------------------------------------------------------------*
PROCEDURE ActivarPROD
*------------------------------------------------------------------------------*
IF CALTE=.T.
         PROD_2.Browse_1.Enabled:=Nuevo
         PROD_2.T_CODPEC.Enabled:=.T.
         PROD_2.T_DESPEC.Enabled:=.T.
         PROD_2.T_CONTROLE.Enabled:=.T.
	      PROD_2.ToolBar_1.Enabled:= .F.
         PROD_2.Btn_CPROD.Enabled:= .T.
      	PROD_2.Btn_SPROD.Enabled:= .T.
ENDIF
RETURN
*------------------------------------------------------------------------------*
PROCEDURE CancelarPROD()
*------------------------------------------------------------------------------*
	DesactivarPROD()
	ActualizaPROD()
	CADP->(dbUNLOCK())
	Nuevo := .F.
RETURN
*------------------------------------------------------------------------------*
PROCEDURE AceptarPROD()
*------------------------------------------------------------------------------*
	DesactivarPROD()
	If Nuevo == .T.
		CADP->(DbAppend())
		Nuevo := .F.
	EndIf
   CADP->CODPEC :=PROD_2.T_CODPEC.VALUE
	CADP->DESPEC :=PROD_2.T_DESPEC.VALUE
	CADP->CONTROLE:=PROD_2.T_CONTROLE.VALUE
	PROD_2.Browse_1.Refresh
	CADP->(DBUNLOCK())
RETURN

*------------------------------------------------------------------------------*
PROCEDURE ActualizaPROD()
*------------------------------------------------------------------------------*
   CADP->(DbSeek(CADP->CODPEC))
	PROD_2.T_CODPEC.VALUE:=CADP->CODPEC
	PROD_2.T_DESPEC.VALUE :=CADP->DESPEC 
	PROD_2.T_CONTROLE.VALUE :=CADP->CONTROLE 
Return
       	   
*------------------------------------------------------------------------------*
Procedure BuscarPROD
*------------------------------------------------------------------------------*
Local Buscar

  CADP->(dbsetorder(1))
  Buscar := Upper ( AllTrim ( InputBox( 'Informe Codigo' , 'Pesquisa' ) ) )
  If .Not. Empty(Buscar)
    	If CADP->(DbSeek(Buscar))
			PROD_2.Browse_1.Value := CADP->(RecNo())
		Else
         MsgExclamation('Nao encontrado registro')
		EndIf
	EndIf

	CADP->(DBSETORDER(1))
Return


*------------------------------------------------------------------------------*
PROCEDURE NuevoPROD()
*------------------------------------------------------------------------------*
IF CINCL=.T.
      PROD_2.T_CODPEC.Value:=space(05)
		PROD_2.T_DESPEC.Value:=SPACE(15)
		PROD_2.T_CONTROLE.Value:=0.000
		
      ActivarPROD()
ENDIF
RETURN

*------------------------------------------------------------------------------*
Procedure EliminarPROD
*------------------------------------------------------------------------------*
IF CEXCL=.T.
  	If MsgYesNo ( "Confirma Exclusão ?","Atenção")
   	If CADP->(TREG())
	   	CADP->(dbdelete())
  			CADP->(DBUNLOCK())
	   	CADP->(dbgotop()) 
  			PROD_2.Browse_1.Value := CADP->(RecNo())
   		ActualizaPROD()
   	endif	   
   endif 	
ENDIF	
Return

*--------------------------------------------------------*
FUNCTION ImprimirPROD()
*--------------------------------------------------------*
	CADP->(RecNo())
	
	DO REPORT								;
      title  empresa+'| Cadastro das Embalagens' ;
      headers  {'',''} , { 'Codigo', 'Embalagens','Controle'} ;
      fields   {'cadp->codpec','cadp->despec','cadp->controle'}   ;
      widths   {10,60,10}                                        ;
      totals   {.F.,.F.,.F.}                                      ;
      nformats {'','',"@E 9999999.999"}                                        ;
      workarea cadp                                                           ;
		LPP 50								;
		CPL 80								;
		LMARGIN 5							;
		PREVIEW							
Return
