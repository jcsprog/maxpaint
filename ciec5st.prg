#Include "minigui.ch"

FUNCTION TABSBT
PARAMETERS LIBERA

   Public Nuevo := .F.
    	    
	DEFINE WINDOW SBT_2;
	           AT 0,0 ;
 				  WIDTH 700;
              HEIGHT 340 ;
	           TITLE "Tabela de Subst. Tributária"	;
				  ICON "TUTOR";
		        CHILD ;
		        ON MAXIMIZE ThisWindow.Center ;
		        ON INIT ( DesactivarSBT(),ActualizaSBT()) 

		DEFINE TOOLBAR ToolBar_1 BUTTONSIZE 59,35 FLAT BORDER

			BUTTON PRIMERO 		;
				CAPTION '&Primero' 	;
				PICTURE 'primero'	;
				ACTION ( SBT->(dBGoTop()) , SBT_2.Browse_1.Value := SBT->(RecNo()) ) 

			BUTTON ANTERIOR 	;
				CAPTION '&Anterior' 	;
				PICTURE 'anterior'	;
				ACTION ( SBT->(dBSkip ( -1 )) , SBT_2.Browse_1.Value := SBT->(RecNo()) ) 

			BUTTON SIGUIENTE	;
				CAPTION '&Proximo' 	;
				PICTURE 'siguiente'	;
				ACTION ( SBT->(dBSkip (1)) , if ( Eof() , SBT->(DbGoBottom()) , Nil ) , SBT_2.Browse_1.Value := SBT->(RecNo()) ) 

			BUTTON ULTIMO 		;
				CAPTION '&Ultimo' 	;
				PICTURE 'ultimo'	;
				ACTION ( SBT->(dBGoBottom () ), SBT_2.Browse_1.Value := SBT->(RecNo()) )  SEPARATOR 

			BUTTON BUSCAR 		;
				CAPTION '&Pesquisa' 	;
				PICTURE 'buscar'	;
				ACTION BuscarSBT()

			BUTTON Nuevo 		;
				CAPTION '&Novo' 	;
				PICTURE 'nuevo'	;
				ACTION ( Nuevo := .T. , NuevoSBT() )

			BUTTON EDITAR 		;
				CAPTION 'A&lterar' 	;
				PICTURE 'editar'	;
				ACTION If ( SBT->(TREG() ) , ActivarSBT() , Nil )

			BUTTON ELIMINAR 	;
				CAPTION 'De&letar'	;
				PICTURE 'borrar'	;
				ACTION EliminarSBT() 

			BUTTON CERRAR 	;
				CAPTION '&Fecha'	;
				PICTURE 'cerrar' ;
            ACTION SBT_2.release 

		END TOOLBAR
 
                @ 56,10 BROWSE Browse_1				;
			            WIDTH 360  				;
                     HEIGHT 200           ; 
			            HEADERS { 'Sigla','Estado','% SBT','% AIV'} ;
			            WIDTHS { 80, 140, 80,80 }			;
			            WORKAREA SBT			;
                     FIELDS { 'SBT->ESTADO' , 'SBT->NESTA','SBT->ICMST','SBT->IAV'} ;
			            ON CHANGE ActualizaSBT() ;
			            ON DBLCLICK ( ActivarSBT() , If ( ! SBT->(TREG()) , DesactivarSBT() , Nil ) )

                     @ 70,400 LABEL AF ;
                              VALUE 'Sigla' ;
                              WIDTH 80           ;
                              HEIGHT 30           

                     @100,400 LABEL BF ;
                              VALUE 'Estado'  ;
                              WIDTH 60           ;
                              HEIGHT 30           

                     @130,400 LABEL CF ;
                              VALUE '% SBT '  ;
                              WIDTH 60           ;
                              HEIGHT 30           

                     @160,400 LABEL DF ;
                              VALUE '% IAV '  ;
                              WIDTH 60           ;
                              HEIGHT 30           

			    	     @ 070,470 TEXTBOX T_ESTADO;
			    	               OF SBT_2 ;
   			                  WIDTH 30 

			    	     @ 100,470 TEXTBOX T_NESTA;
			    	               OF SBT_2 ;
   			                  WIDTH 200 

			    	     @ 130,470 TEXTBOX T_SBTS;
			    	               OF SBT_2 ;
   			                  WIDTH 80 ;
  					 		         NUMERIC INPUTMASK '9999';	
                              ON ENTER SBT_2.T_IAV.SetFocus

			    	     @ 160,470 TEXTBOX T_IAV;
			    	               OF SBT_2 ;
   			                  WIDTH 80 ;
  					 		         NUMERIC INPUTMASK '9999.99';	
                              ON ENTER SBT_2.Btn_SSBT.SetFocus

	                 @ 190,400 BUTTON Btn_SSBT Of SBT_2	;
                          CAPTION '&Salvar'             ;
                          ACTION AceptarSBT() ;
                          WIDTH 80 HEIGHT 27   ;                                 
                          TOOLTIP "Salvar Registro" ;
                          FLAT

	                 @ 190,500 BUTTON Btn_CSBT Of SBT_2	;
		                     CAPTION '&Cancelar'		;
                           ACTION SBT_2.RELEASE ;
			                  WIDTH 80 HEIGHT 27		;
                           TOOLTIP "Cancelar Operação"	;
			               FLAT

	END WINDOW

   SBT_2.Browse_1.SetFocus
	
	SBT_2.CENTER 

	SBT_2.ACTIVATE 

RETURN


*------------------------------------------------------------------------------*
function DesactivarSBT()
*------------------------------------------------------------------------------*
         SBT_2.Browse_1.Enabled:=.T.
         SBT_2.T_ESTADO.Enabled :=.F.
         SBT_2.T_NESTA.Enabled:=.F.
         SBT_2.T_SBTS.Enabled:=.F.
         SBT_2.T_IAV.Enabled:=.F.
         SBT_2.Btn_CSBT.Enabled:=.F.
   	   SBT_2.Btn_SSBT.Enabled:=.F.
         SBT_2.ToolBar_1.Enabled:=.T.
         SBT_2.Browse_1.SetFocus
RETURN
*------------------------------------------------------------------------------*
PROCEDURE ActivarSBT
*------------------------------------------------------------------------------*
         SBT_2.Browse_1.Enabled:=.F.
         SBT_2.T_ESTADO.Enabled :=.T.
         SBT_2.T_NESTA.Enabled:=.T.
         SBT_2.T_SBTS.Enabled:=.T.
         SBT_2.T_IAV.Enabled:=.T.
	      SBT_2.ToolBar_1.Enabled:= .F.
         SBT_2.Btn_CSBT.Enabled:= .T.
      	SBT_2.Btn_SSBT.Enabled:= .T.
RETURN
*------------------------------------------------------------------------------*
PROCEDURE CancelarSBT()
*------------------------------------------------------------------------------*
	DesactivarSBT()
	ActualizaSBT()
	sbt->(dbunlock())
	Nuevo := .F.
RETURN
*------------------------------------------------------------------------------*
PROCEDURE AceptarSBT()
*------------------------------------------------------------------------------*
	DesactivarSBT()
	If Nuevo == .T.
		SBT->(DbAppend())
		Nuevo := .F.
	EndIf
   SBT->ESTADO :=SBT_2.T_ESTADO.VALUE
	SBT->NESTA  :=SBT_2.T_NESTA.VALUE
	SBT->ICMST  :=SBT_2.T_SBTS.VALUE
	SBT->IAV    :=SBT_2.T_IAV.VALUE
	SBT_2.Browse_1.Refresh
	SBT->(DBUNLOCK())
RETURN

*------------------------------------------------------------------------------*
PROCEDURE ActualizaSBT()
*------------------------------------------------------------------------------*
   SBT->(DbSeek(SBT->ESTADO))
	SBT_2.T_ESTADO.VALUE:=SBT->ESTADO
	SBT_2.T_NESTA.VALUE:=SBT->NESTA 
	SBT_2.T_SBTS.VALUE :=SBT->ICMST 
	SBT_2.T_IAV.VALUE  :=SBT->IAV 
Return
    	   
*------------------------------------------------------------------------------*
Procedure BuscarSBT
*------------------------------------------------------------------------------*
Local Buscar
  Buscar := Upper ( AllTrim ( InputBox( 'Informe Estado' , 'Pesquisa' ) ) )
  If .Not. Empty(Buscar)
    	If SBT->(DbSeek(Buscar))
			SBT_2.Browse_1.Value := SBT->(RecNo())
		Else
         MsgExclamation('Nao encontrado registro')
		EndIf
	EndIf
Return
*------------------------------------------------------------------------------*
PROCEDURE NuevoSBT()
*------------------------------------------------------------------------------*
     SBT_2.T_ESTADO.value:=space(02)
     SBT_2.T_NESTA.value :=space(20)
     SBT_2.T_SBTS.value  :=0
     SBT_2.T_IAV.value   :=0.00
     ActivarSBT()
RETURN

*------------------------------------------------------------------------------*
Procedure EliminarSBT
*------------------------------------------------------------------------------*
	If MsgYesNo ( "Confirma Exclusão ?","Atenção!")
		If SBT->(TREG())
			SBT->(dbdelete())
			SBT->(DBUNLOCK())
			SBT->(dbgotop()) 
			SBT_2.Browse_1.Value := SBT->(RecNo())
			ActualizaSBT()
		EndIf
	EndIf
Return
