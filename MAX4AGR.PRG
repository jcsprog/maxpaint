#Include "minigui.ch"

FUNCTION AGREGA
PARAMETERS LIBERA

//LiberacaoCiec(LIBERA)
//PUBLIC CINCL:=.T.,CALTE:=.T.,CEXCL:=.T.,CIMPR:=.T.
   Public Nuevo := .F.
	 	    
	DEFINE WINDOW AGR_2;
	           AT 0,0 ;
 				  WIDTH 770;
              HEIGHT 470 ;
	           TITLE "Cadastro de Agregador" 	;
				  ICON "TUTOR";
		        CHILD ;
		        ON MAXIMIZE ThisWindow.Center ;
		        ON INIT ( DesactivarAGR(),ActualizaAGR()) 

		DEFINE TOOLBAR ToolBar_1 BUTTONSIZE 59,35 FLAT BORDER

			BUTTON PRIMERO 		;
				CAPTION '&Primero' 	;
				PICTURE 'primero'	;
				ACTION ( AGR->(dBGoTop()) , AGR_2.Browse_1.Value := AGR->(RecNo()) ) 

			BUTTON ANTERIOR 	;
				CAPTION '&Anterior' 	;
				PICTURE 'anterior'	;
				ACTION ( AGR->(dBSkip ( -1 )) , AGR_2.Browse_1.Value := AGR->(RecNo()) ) 

			BUTTON SIGUIENTE	;
				CAPTION '&Proximo' 	;
				PICTURE 'siguiente'	;
				ACTION ( AGR->(dBSkip (1)) , if ( Eof() , AGR->(DbGoBottom()) , Nil ) , AGR_2.Browse_1.Value := AGR->(RecNo()) ) 

			BUTTON ULTIMO 		;
				CAPTION '&Ultimo' 	;
				PICTURE 'ultimo'	;
				ACTION ( AGR->(dBGoBottom () ), AGR_2.Browse_1.Value := AGR->(RecNo()) )  SEPARATOR 

			BUTTON BUSCAR 		;
				CAPTION '&Pesquisa' 	;
				PICTURE 'buscar'	;
				ACTION BuscarAGR()

			BUTTON Nuevo 		;
				CAPTION '&Novo' 	;
				PICTURE 'nuevo'	;
				ACTION ( Nuevo := .T. , NuevoAGR() )

			BUTTON EDITAR 		;
				CAPTION 'A&lterar' 	;
				PICTURE 'editar'	;
				ACTION ( Nuevo := .F. , if( AGR->(TREG())  , ActivarAGR() , Nil )  )

			BUTTON ELIMINAR 	;
				CAPTION 'De&letar'	;
				PICTURE 'borrar'	;
				ACTION EliminarAGR() 

			BUTTON IMPRIMIR 	;
				CAPTION '&Imprimir'	;
				PICTURE 'imprimir2' ;
				ACTION ImprimirAGR() 

			BUTTON CERRAR 	;
				CAPTION '&Fecha'	;
				PICTURE 'cerrar' ;
            ACTION AGR_2.release 

		END TOOLBAR
 
                @ 56,10 BROWSE Browse_1				;
			            WIDTH 380  				;
                     HEIGHT 370         ; 
			            HEADERS { 'Maxpaint','Agregado','Descrição','Qte'} ;
			            WIDTHS { 60,70,160,70 }			;
			            WORKAREA AGR			;       
                     FIELDS { 'AGR->CODMAXAGR' , 'AGR->AGREGADO','if(fam->(dbseek(AGR->AGREGADO)),fam->DESCMAX,space(30))','AGR->QTEAGR'} ;
                     ON CHANGE ActualizaAGR() ;
			            ON DBLCLICK ( ActivarAGR() , If ( ! AGR->(TREG()) , DesactivarAGR() , Nil ) )

                     @ 70,400 LABEL A ;
                              VALUE 'MaxiPaint' ;
                              WIDTH 90           ;
                              HEIGHT 30       ;
										SIZE 11 BOLD    
         
                     @201,400 LABEL C;
                              VALUE 'Agregado  '  ;
                              WIDTH 80           ;
		                        HEIGHT 30		    ;
		                        SIZE 11 BOLD
                            
	                  @331,400 LABEL Rc ;
		                        VALUE 'Quantidade';
                              WIDTH 100          ;
		                        HEIGHT 30		;
										SIZE 11 BOLD	
	                  	                        
                     @070,480 TEXTBOX T_CODMAXAGR     ;
                              WIDTH 100               ;
										TOOLTIP "Digite o Nome para PESQUISA" ;
                              FONT "MS SANS SERIF" SIZE 11 BOLD;
                              BACKCOLOR _YELLOW2 FONTCOLOR _VERDE  ;
                              MAXLENGTH 10                 ;
                              ON GOTFOCUS This.BackColor:= _BLUE3  ;
                              ON LOSTFOCUS This.BackColor:=_YELLOW2; 
                              ON CHANGE { || Pesquisa_cp("fam","CODMAX",1,agr_2.T_CODMAXAGR.VALUE,"L_ProdMax","AGR_2","{ FAM->CODMAX,FAM->DESCMAX,FAM->EMBALA }") } 	
										                  	                        
                     @100,400 Grid L_ProdMax ;
		            	         WIDTH 350 		;
                              HEIGHT 090      ;
										HEADERS { 'Cod.Max' , 'Descrição','Embala'} ;
			                     WIDTHS {60,200,100} ;
						            ON CHANGE (AGR_2.T_CODMAXAGR.Value:=PegaValorDaColuna( "L_ProdMax" , "AGR_2" , 1 )) 
										ON DBLCLICK (if(!empty(AGR_2.T_CODMAXAGR.Value),AGR_2.T_AGREGADO.setfocus,AGR_2.T_CODMAXAGR.Setfocus))                 	                        

                     @200,480 TEXTBOX T_AGREGADO     ;
                              WIDTH 100               ;
										TOOLTIP "Digite o Nome para PESQUISA" ;
                              FONT "MS SANS SERIF" SIZE 11 BOLD;
                              BACKCOLOR _YELLOW2 FONTCOLOR _VERDE  ;
                              MAXLENGTH 10                 ;
                              ON GOTFOCUS This.BackColor:= _BLUE3  ;
                              ON LOSTFOCUS This.BackColor:=_YELLOW2; 
                              ON CHANGE { || Pesquisa_cp("fam","CODMAX",1,agr_2.T_AGREGADO.VALUE,"L_ProdAgr","AGR_2","{ FAM->CODMAX,FAM->DESCMAX,FAM->EMBALA }") } 	
									                  	                        
                     @230,400 Grid L_ProdAgr ;
		            	         WIDTH 350 		;
                              HEIGHT 090      ;
										HEADERS { 'Cod.Max' , 'Descrição','Embala'} ;
			                     WIDTHS {60,200,100} ;
						            ON CHANGE (AGR_2.T_AGREGADO.Value:=PegaValorDaColuna( "L_ProdAgr" , "AGR_2" , 1 )) ;
										ON DBLCLICK (if(!empty(AGR_2.T_AGREGADO.Value),AGR_2.T_QTEAGR.setfocus,AGR_2.T_AGREGADO.Setfocus))                 	                        
								
                     @330,490 TEXTBOX T_QTEAGR;
                             OF AGR_2 ;
                             WIDTH 60  ;                              								
   					 		     NUMERIC INPUTMASK '999.99999'	
                                                 
	                  @370,400 BUTTON Btn_SAGR Of AGR_2	;
                             CAPTION '&Salvar'             ;
                             ACTION AceptarAGR() ;
                             WIDTH 80 HEIGHT 27   ;                                 
                             TOOLTIP "Salvar Registro" ;
                             FLAT

	                  @370,530 BUTTON Btn_CAGR Of AGR_2	;
		                       CAPTION '&Cancelar'		;
                             ACTION CancelarAGR() ;
			                    WIDTH 80 HEIGHT 27		;
                             TOOLTIP "Cancelar Operação"	;
			                    FLAT
 
	END WINDOW

   AGR_2.Browse_1.SetFocus
	
	AGR_2.CENTER 

	AGR_2.ACTIVATE  

RETURN

*------------------------------------------------------------------------------*
procedure DesactivarAGR
*------------------------------------------------------------------------------*
         AGR_2.Browse_1.Enabled:=.T.
         AGR_2.T_CODMAXAGR.ENABLED:=.F.
         AGR_2.T_AGREGADO.ENABLED:=.F.
         AGR_2.T_QTEAGR.ENABLED:=.F.
         AGR_2.Btn_CAGR.Enabled:=.F.
   	   AGR_2.Btn_SAGR.Enabled:=.F.
   	   AGR_2.L_ProdMax.Enabled:=.t.
   	   AGR_2.L_ProdAgr.Enabled:=.t.
         AGR_2.ToolBar_1.Enabled:=.T.
         AGR_2.Browse_1.SetFocus
RETURN
*------------------------------------------------------------------------------*
procedure ActivarAGR
*------------------------------------------------------------------------------*
IF CALTE=.T. 

         AGR_2.T_CODMAXAGR.ENABLED:=nuevo
         AGR_2.T_AGREGADO.ENABLED:=.t.
         AGR_2.T_QTEAGR.ENABLED:=.t.
         AGR_2.Btn_CAGR.Enabled:=.t.
   	   AGR_2.Btn_SAGR.Enabled:=.t.
         AGR_2.ToolBar_1.Enabled:=.f.
ENDIF		   	 
RETURN
*------------------------------------------------------------------------------*
procedure CancelarAGR()
*------------------------------------------------------------------------------*
	DesactivarAGR()
	ActualizaAGR()
	AGR->(DBUNLOCK())
	Nuevo := .F.
RETURN
*------------------------------------------------------------------------------*
procedure AceptarAGR()
*------------------------------------------------------------------------------*

	If Nuevo == .T.
		AGR->(DbAppend())
	Else
	   DesactivarAGR()
	endif   

   AGR->CODMAXAGR := AGR_2.T_CODMAXAGR.VALUE
   AGR->AGREGADO  := AGR_2.T_AGREGADO.VALUE
   AGR->QTEAGR    := AGR_2.T_QTEAGR.VALUE
   AGR->CTRAGR    := strzero(AGR->(RECNO()),5)

	AGR->(DBUNLOCK())
	
	If Nuevo == .T.
      AGR_2.T_AGREGADO.VALUE:=space(05)
      AGR_2.T_QTEAGR.VALUE:=0.000
      AGR_2.L_ProdMax.Enabled:=.F.
      AGR_2.T_AGREGADO.Setfocus
   endif
	
	AGR_2.Browse_1.Refresh
	   
RETURN

*------------------------------------------------------------------------------*
procedure ActualizaAGR()
*------------------------------------------------------------------------------*
   AGR->(DbSeek(AGR->CODMAXAGR+AGR->AGREGADO))
   AGR_2.T_CODMAXAGR.VALUE:=AGR->CODMAXAGR 
   AGR_2.T_AGREGADO.VALUE:=AGR->AGREGADO 
   AGR_2.T_QTEAGR.VALUE:=AGR->QTEAGR 
Return

       	   
*------------------------------------------------------------------------------*
procedure BuscarAGR
*------------------------------------------------------------------------------*
Local Buscar

  AGR->(dbsetorder(1))
  Buscar := Upper ( AllTrim ( InputBox( 'Informe Cod. Maxipaint' , 'Pesquisa' ) ) )
  If !Empty(Buscar)
      SET SOFTSEEK ON  
    	If AGR->(DbSeek(Buscar))
			AGR_2.Browse_1.Value := AGR->(RecNo())
		Else
         MsgExclamation('Nao encontrado registro')
		EndIf
		SET SOFTSEEK off
	EndIf

Return


*------------------------------------------------------------------------------*
procedure NuevoAGR()
*------------------------------------------------------------------------------*
IF CINCL=.T.
   AGR_2.T_CODMAXAGR.VALUE:=space(10)
   AGR_2.T_AGREGADO.VALUE:=space(05)
   AGR_2.T_QTEAGR.VALUE:=0.000
   ActivarAGR()
ENDIF
RETURN

*------------------------------------------------------------------------------*
procedure EliminarAGR
*------------------------------------------------------------------------------*
IF CEXCL=.T.
	If MsgYesNo ( "Confirma Exclusão ?","Atenção")
		If AGR->(TREG())
			AGR->(dbdelete())
			AGR->(DBUNLOCK())
			AGR->(dbgotop()) 
			AGR_2.Browse_1.Value := AGR->(RecNo())
			ActualizaAGR()
		EndIf
	EndIf
ENDIF
Return

*--------------------------------------------------------*
procedure ImprimirAGR()
*--------------------------------------------------------*
AGR->(DBGOTOP())

	DO REPORT								;
      title  empresa+'| Cadastro da Produtos/Agregados ' ;
      headers  {'','','','',''} , { 'Cd.Max.', 'Cod.Agr.','Descrição','Quantidade'} ;
      fields   {'AGR->CODMAXAGR','AGR->AGREGADO','if(fam->(dbseek(AGR->AGREGADO)),fam->DESCMAX,space(30))','AGR->QTEAGR'}   ;
      widths   {10,10,35,10}                                        ;
      totals   {.F.,.F.,.F.,.F.}                                      ;
      nformats {'','','','999.999'}    ;
      workarea AGR                                                           ;
     	LPP 55								;
		CPL 77								;
		LMARGIN 3							;
		TMARGIN 3                     ;
		PAPERSIZE DMPAPER_A4          ;
		PREVIEW			               ;
				
Return