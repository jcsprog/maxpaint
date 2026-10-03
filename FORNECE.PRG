#Include "minigui.ch"

FUNCTION FORNECEDOR
PARAMETERS LIBERA

LiberacaoCiec(LIBERA)

    Public Nuevo := .F.
    	    
	DEFINE WINDOW FORNE_2;
	       AT 0,0 ;
 	       WIDTH 840;
               HEIGHT 480 ;
	       TITLE 'Cadastro Fornecedores'     	;
	       ICON "TUTOR";
	       CHILD ;
	       ON MAXIMIZE ThisWindow.Center ;
               ON INIT ( DesactivarForn(),ActualizaForn()) 

        DEFINE TOOLBAR ToolBar_1 BUTTONSIZE 59,35 FLAT BORDER

			BUTTON PRIMERO 		;
				CAPTION '&Primero' 	;
				PICTURE 'primero'	;
				ACTION ( FORN->(dBGoTop()) , FORNE_2.Browse_1.Value := FORN->(RecNo()) ) 

			BUTTON ANTERIOR 	;
				CAPTION '&Anterior' 	;
				PICTURE 'anterior'	;
				ACTION ( FORN->(dBSkip ( -1 )) , FORNE_2.Browse_1.Value := FORN->(RecNo()) ) 

			BUTTON SIGUIENTE	;
				CAPTION '&Proximo' 	;
				PICTURE 'siguiente'	;
				ACTION ( FORN->(dBSkip (1)) , if ( Eof() , FORN->(DbGoBottom()) , Nil ) , FORNE_2.Browse_1.Value := FORN->(RecNo()) ) 

			BUTTON ULTIMO 		;
				CAPTION '&Ultimo' 	;
				PICTURE 'ultimo'	;
				ACTION ( FORN->(dBGoBottom () ), FORNE_2.Browse_1.Value := FORN->(RecNo()) )  SEPARATOR 

			BUTTON BUSCAR 		;
				CAPTION '&Pesquisa' 	;
				PICTURE 'buscar'	;
				ACTION BuscarFORN()

			BUTTON Nuevo 		;
				CAPTION '&Novo' 	;
				PICTURE 'nuevo'	;
				ACTION ( Nuevo := .T. , NuevoForn() )

			BUTTON EDITAR 		;
				CAPTION 'A&lterar' 	;
				PICTURE 'editar'	;
				ACTION If ( FORN->(TREG() ) , ActivarForn() , Nil )

			BUTTON ELIMINAR 	;
				CAPTION 'De&letar'	;
				PICTURE 'borrar'	;
				ACTION EliminarForn() 

			BUTTON IMPRIMIR 	;
				CAPTION '&Imprimir'	;
				PICTURE 'imprimir2' ;
				ACTION ImprimirForn() 

			BUTTON CERRAR 	;
				CAPTION '&Fecha'	;
				PICTURE 'cerrar' ;
                ACTION FORNE_2.release 

		END TOOLBAR

                @ 56,10 BROWSE Browse_1				;
			            WIDTH 210  				;
                     HEIGHT 300                         ; 
			            HEADERS { 'Fantasia' , 'Raz�o Social' }	;
			            WIDTHS { 250 , 180 }			;
			            WORKAREA FORN			;
                     FIELDS { 'FORN->Fanta' , 'FORN->descr' } ;
			            ON CHANGE ActualizaForn() ;
			            ON DBLCLICK ( ActivarForn() , If ( ! FORN->(TREG()) , DesactivarForn() , Nil ) )
 
                     @ 70,230 LABEL Label_Fanta ;
                              VALUE 'Fantasia'    ;
                              WIDTH 60           ;
                              HEIGHT 30           

                     @100,230 LABEL Label_CGC ;
                              VALUE 'N� CNPJ  '  ;
                              WIDTH 60           ;
                              HEIGHT 30           
	                                            
	                  @130,230 LABEL Label_Descr;
		                        VALUE 'Raz�o Social'	;
                              WIDTH 100           ;
		                        HEIGHT 30			
	         
                     @160,230 LABEL Label_End;
                              VALUE 'Endere�o'              ;
                              WIDTH 60           ;
		                        HEIGHT 30		
                            
	                  @190,230 LABEL Label_Bairro	;
		                        VALUE 'Bairro'		;
                              WIDTH 60                   ;
		                        HEIGHT 30			
                         
                     @190,520 LABEL Label_Cidade ;
                              VALUE 'Cidade'      ;
                              WIDTH 60           ;
                              HEIGHT 30           
                       
                     @190,700 LABEL Label_UF    ;
                              VALUE 'UF'          ;
                              WIDTH 45                    ;
		                        HEIGHT 30			
							
	                  @220,230 LABEL Label_Cep	;
		                       VALUE 'Cep'		;
                             WIDTH 60           ;
		                       HEIGHT 30				
	                    
				         @220,445 LABEL Label_Pais	;
                             VALUE 'Pais'            ;
                             WIDTH 60                    ;
		                       HEIGHT 30			
	                    
                     @220,635 LABEL Label_Tel ;
                             VALUE 'Fone'  ;
                             WIDTH 60                    ;
		                       HEIGHT 30			
	    
	                  @250,230 LABEL Label_Ies	;
		                      VALUE 'Ins.Estadual'	;
                            WIDTH 150           ;
         	                HEIGHT 30				

 	                  @250,470 LABEL Label_Fax	;
		                      VALUE 'Fax'		;
                            WIDTH 60           ;
		                      HEIGHT 30		

                     @250,635 LABEL Telrd;
                             VALUE 'Resid.:';
                             WIDTH 60                    ;
		                       HEIGHT 30			

                     @280,230 LABEL Label_Baicob;
		                     VALUE 'Indica��o';
                           WIDTH 100           ;
		                     HEIGHT 30		
  
                    @280,470 LABEL Label_Cidcob;
                            VALUE 'Contato'    ;
                            WIDTH 100           ;
                            HEIGHT 30          	
                                      
                    @310,230 LABEL Label_Email;
                            VALUE 'Email'      ;
                            WIDTH 60           ;
                            HEIGHT 30          	

                    @310,610 LABEL Telresd;
                             VALUE 'Tel.Contato:';
                             WIDTH 60                    ;
		                       HEIGHT 30			
                                                           
	                 @ 70,310 TEXTBOX T_Fanta;
                            OF FORNE_2 ;
		                       WIDTH 250			;
                            TOOLTIP 'Nome Fantasia da Empresa' ;
                            MAXLENGTH 20 ;
                            UPPERCASE         ;
                            ON ENTER FORNE_2.T_cgc.SetFocus 
							
                    @100,310 TEXTBOX T_CGC  ;
                            OF FORNE_2 ;
                            WIDTH 150 ;
                            TOOLTIP 'Informe N� CNPJ '; 
                            MAXLENGTH 20   ;
                            ON ENTER FORNE_2.T_Descr.SetFocus
	                     			
 		              @130,310 TEXTBOX T_Descr ;
                            OF FORNE_2     ;
                            WIDTH 370       ;
                            MAXLENGTH 45   ;
                            ON ENTER FORNE_2.T_End.SetFocus
	         
                    @160,310 TEXTBOX T_End;
                            OF FORNE_2 ;
                            WIDTH 300         ;
                            MAXLENGTH 40      ;
                            ON ENTER FORNE_2.T_Bairro.SetFocus
                            
	                @190,310 TEXTBOX T_Bairro	;
                            OF FORNE_2 ;
		                      WIDTH 200          ;
                            MAXLENGTH 20       ;
                            ON ENTER FORNE_2.T_Cidade.SetFocus
                         
                    @190,570 TEXTBOX T_Cidade ;
                            OF FORNE_2 ;
                            WIDTH 120           ;
                            MAXLENGTH 15      ;
                            ON ENTER FORNE_2.T_UF.SetFocus

                    @190,740 TEXTBOX T_UF    ;
                            OF FORNE_2 ;
                            WIDTH 40                    ;
                            MAXLENGTH 02       ;
                            ON ENTER FORNE_2.T_Cep.SetFocus
	                  
					     @220,310 TEXTBOX T_Cep	;
                            INPUTMASK '99999-999';
                            ON ENTER FORNE_2.T_Pais.SetFocus 
							
	                 @220,480 TEXTBOX T_Pais	;
                            OF FORNE_2 ;
                            WIDTH 150           ;
                            MAXLENGTH 20        ;
                            ON ENTER FORNE_2.T_Tel.SetFocus
	                    
                   @220,675 TEXTBOX T_Tel ;
                            INPUTMASK '(99)99999-9999';
 	                         ON ENTER FORNE_2.T_Ies.SetFocus 
              		                  
	                @250,310 TEXTBOX T_Ies	;
                            OF FORNE_2 ;
		                      WIDTH 150      ;
                            MAXLENGTH 18   ;
                            ON ENTER FORNE_2.T_indica.SetFocus

	                @250,500 TEXTBOX T_Fax	;
                            INPUTMASK '(99)99999-9999';
	                         ON ENTER FORNE_2.T_TelRes.SetFocus 

                   @250,675 TEXTBOX T_TelRes ;
                            INPUTMASK '(99)99999-9999';
 	                         ON ENTER FORNE_2.T_Indica.SetFocus 
		            
                    @280,310 TEXTBOX T_indica;
                            OF FORNE_2 ;
                            WIDTH 150         ;
                            MAXLENGTH 20      ;
                            ON ENTER FORNE_2.T_Contato.SetFocus

                    @280,520 TEXTBOX T_Contato;
                            OF FORNE_2 ;
                            WIDTH 150           ;
                            MAXLENGTH 15       ;
                            ON ENTER FORNE_2.T_email.SetFocus

                    @310,310 TEXTBOX T_Email;
                            OF FORNE_2 ;
                            WIDTH 300           ;
                            MAXLENGTH 60       ;
                            ON ENTER FORNE_2.T_Telcont.SetFocus                  

                   @310,680 TEXTBOX T_Telcont ;
                            INPUTMASK '(99)99999-9999';
                            ON ENTER FORNE_2.Btn_sforn.SetFocus                  
/*       
				       @ 410,10 Grid Fornece_2 ;
		                    	 WIDTH 720  		;
                            HEIGHT 110      ; 
			                   HEADERS { 'Descri��o' , 'Produto','Pre�o','Cond.Pagto' };
			                   WIDTHS { 150 , 250, 100, 150}			
*/
	               @ 350,400 BUTTON Btn_SFORN Of FORNE_2	;
                          CAPTION '&Salvar'             ;
                          ACTION AceptarForn() ;
                          WIDTH 80 HEIGHT 27   ;                                 
                          TOOLTIP "Salvar Registro" ;
                          FLAT

	               @ 350,550 BUTTON Btn_CFORN Of FORNE_2	;
		                     CAPTION '&Cancelar'		;
                           ACTION CancelarForn() ;
			                  WIDTH 80 HEIGHT 27		;
                           TOOLTIP "Cancelar Opera��o"	;
			               FLAT

	END WINDOW

   FORNE_2.Browse_1.SetFocus
	
	FORNE_2.CENTER

	FORNE_2.ACTIVATE

RETURN

*------------------------------------------------------------------------------*
PROCEDURE DesactivarForn
*------------------------------------------------------------------------------*
        
         FORNE_2.Browse_1.Enabled:=.T.
         //FORNE_2.Fornece_2.Enabled:=.F.
         FORNE_2.T_Descr.Enabled:=.F.
         FORNE_2.T_Fanta.Enabled:=.F.
         FORNE_2.T_End.Enabled:=.F.
         FORNE_2.T_Tel.Enabled:=.F.
         FORNE_2.T_Cep.Enabled:=.F.
         FORNE_2.T_Cidade.Enabled:=.F.
         FORNE_2.T_Uf.Enabled:=.F.
         FORNE_2.T_CGC.Enabled:=.F.
         FORNE_2.T_IES.Enabled:=.F.
         FORNE_2.T_BAIRRO.Enabled:=.F.       
         FORNE_2.T_PAIS.Enabled:=.F.
         FORNE_2.T_FAX.Enabled:=.F.
         FORNE_2.T_telres.Enabled:=.F.
         FORNE_2.T_telcont.Enabled:=.F.
         FORNE_2.T_EMAIL.Enabled:=.F.
         FORNE_2.T_contato.Enabled:=.F.
         FORNE_2.T_indica.Enabled:=.F.
         FORNE_2.Btn_CFORN.Enabled:= .F.
   	   FORNE_2.Btn_SFORN.Enabled:= .F.
         FORNE_2.ToolBar_1.Enabled:= .T.
         FORNE_2.Browse_1.SetFocus

RETURN
*------------------------------------------------------------------------------*
PROCEDURE ActivarForn
*------------------------------------------------------------------------------*
IF CALTE=.T.        
         FORNE_2.Browse_1.Enabled:= .F.
	      FORNE_2.ToolBar_1.Enabled:= .F.
	      FORNE_2.T_Descr.Enabled:=.T.
         FORNE_2.T_Fanta.Enabled:=Nuevo
         FORNE_2.T_End.Enabled:=.T.
         FORNE_2.T_Tel.Enabled:=.T.
         FORNE_2.T_Cep.Enabled:=.T.
         FORNE_2.T_Cidade.Enabled:=.T.
         FORNE_2.T_Uf.Enabled:=.T.
         FORNE_2.T_CGC.Enabled:=.T.
         FORNE_2.T_IES.Enabled:=.T.
         FORNE_2.T_BAIRRO.Enabled:=.T.       
         FORNE_2.T_PAIS.Enabled:=.T.
         FORNE_2.T_telres.Enabled:=.T.
         FORNE_2.T_FAX.Enabled:=.T.
         FORNE_2.T_EMAIL.Enabled:=.T.
         FORNE_2.T_contato.Enabled:=.T.
         FORNE_2.T_indica.Enabled:=.T.
         FORNE_2.T_telcont.Enabled:=.T.
         FORNE_2.Btn_CFORN.Enabled:= .T.
      	FORNE_2.Btn_SFORN.Enabled:= .T.
ENDIF		   	 
RETURN
*------------------------------------------------------------------------------*
PROCEDURE CancelarForn()
*------------------------------------------------------------------------------*

	DesactivarForn()

	ActualizaForn()

	FORN->(dbUNLOCK())

	Nuevo := .F.

RETURN
*------------------------------------------------------------------------------*
PROCEDURE AceptarForn()
*------------------------------------------------------------------------------*

	DesactivarForn()

	If Nuevo == .T.
		FORN->(DbAppend())
		Nuevo := .F.
	EndIf

           FORN->DESCR  := FORNE_2.T_Descr.Value 
           FORN->FANTA  := FORNE_2.T_Fanta.Value 
           FORN->END    := FORNE_2.T_End.Value 
           FORN->TEL    := FORNE_2.T_Tel.Value 
           FORN->CEP    := FORNE_2.T_Cep.Value 
           FORN->CIDADE := FORNE_2.T_Cidade.Value 
           FORN->UF     := FORNE_2.T_Uf.Value 
           FORN->CGCREAL:= FORNE_2.T_CGC.Value 
           FORN->IES    := FORNE_2.T_IES.Value 
           FORN->PAIS   := FORNE_2.T_PAIS.Value 
           FORN->BAIRRO := FORNE_2.T_BAIRRO.Value 
           FORN->FAX    := FORNE_2.T_FAX.Value 
           FORN->EMAIL  := FORNE_2.T_EMAIL.Value 
           FORN->CONTATO:= FORNE_2.T_CONTATO.Value 
           FORN->INDICA := FORNE_2.T_INDICA.Value 
           FORN->TELRESD:= FORNE_2.T_telres.vALUE
           FORN->TELCONT:= FORNE_2.T_TELCONT.vALUE

	FORNE_2.Browse_1.Refresh

	If Nuevo == .T.
       FORNE_2.Browse_1.Value := FORN->(RecNo())
	EndIf

	FORN->(dbUNLOCK())

RETURN

*------------------------------------------------------------------------------*
PROCEDURE ActualizaForn()
*------------------------------------------------------------------------------*
    	
         FORN->(DbSeek(fanta))
         FORNE_2.T_Descr.Value   := FORN->Descr
         FORNE_2.T_Fanta.Value   := FORN->fanta
         FORNE_2.T_End.Value     := FORN->end
         FORNE_2.T_Tel.Value     := FORN->tel
         FORNE_2.T_Cep.Value     := FORN->cep
         FORNE_2.T_Cidade.Value  := FORN->cidade
         FORNE_2.T_Uf.Value      := FORN->uf
         FORNE_2.T_CGC.Value     := FORN->CGCREAL
         FORNE_2.T_IES.Value     := FORN->ies
         FORNE_2.T_BAIRRO.Value  := FORN->bairro       
         FORNE_2.T_PAIS.Value    := FORN->pais
         FORNE_2.T_FAX.Value     := FORN->fax
         FORNE_2.T_EMAIL.Value   := FORN->email
         FORNE_2.T_CONTATO.Value := FORN->CONTATO
         FORNE_2.T_INDICA.Value  := FORN->INDICA
         FORNE_2.T_TELRES.VALUE  := FORN->TELRESD
         FORNE_2.T_TELCONT.VALUE := FORN->TELCONT

         FMOSTPR()
Return

       	   
*------------------------------------------------------------------------------*
Procedure BuscarFORN
*------------------------------------------------------------------------------*
Local Buscar

  FORN->(dbsetorder(1))
  Buscar := Upper ( AllTrim ( InputBox( 'Informe Fantasia' , 'Pesquisa' ) ) )
  If .Not. Empty(Buscar)
    	If FORN->(DbSeek(Buscar))
			FORNE_2.Browse_1.Value := FORN->(RecNo())
		Else
         MsgExclamation('Nao encontrado registro')
		EndIf
	EndIf

Return


*------------------------------------------------------------------------------*
PROCEDURE NuevoForn
*------------------------------------------------------------------------------*
IF CINCL=.T. 
   	   FORNE_2.T_Descr.Value:=""
         FORNE_2.T_Fanta.Value:=""
         FORNE_2.T_End.Value := ""
         FORNE_2.T_Tel.Value := ""
         FORNE_2.T_Cep.Value := ""
         FORNE_2.T_Cidade.Value := ""
         FORNE_2.T_Uf.Value := ""
         FORNE_2.T_CGC.Value := ""
         FORNE_2.T_IES.Value := ""
         FORNE_2.T_BAIRRO.Value := ""       
         FORNE_2.T_PAIS.Value := ""
         FORNE_2.T_BAIRRO.Value := ""
         FORNE_2.T_INDICA.Value := ""
         FORNE_2.T_CONTATO.Value := ""
         FORNE_2.T_FAX.Value := ""
         FORNE_2.T_EMAIL.Value := ""
         FORNE_2.T_TELRES.VALUE:= ""
         ActivarForn()
ENDIF
RETURN NIL

*------------------------------------------------------------------------------*
Procedure EliminarForn
*------------------------------------------------------------------------------*
IF CEXCL=.T.
	If MsgYesNo ( "Confirma Exclus�o de Fornecedores ?","Aten��o")
		If FORN->(TREG())
			FORN->(dbdelete())
			FORN->(DBUNLOCK())
			FORN->(dbgotop()) 
			FORNE_2.Browse_1.Value := FORN->(RecNo())
			ActualizaForn()
		EndIf
	EndIf
ENDIF
Return NIL
*------------------------------------------------------------------------------*
Procedure ImprimirForn()
*------------------------------------------------------------------------------*
Local RecFORN 
IF CIMPR=.T.

	RecFORN := FORN->(RecNo())
	
	DO REPORT								;
        TITLE 'Cadastro de Fornecedores';
                HEADERS  {'','','','',''} , {'Fantasia','Razao Social','Cidade','Uf','Contato'};
                FIELDS   {'FORN->fanta','FORN->descr','FORN->CIDADE','FORN->UF','FORN->CONTATO'};
		WIDTHS   {20,30,20,5,20} 						;
		TOTALS   {.F.,.F.,.F.,.F.,.F.}					;
		WORKAREA FORN						;
		LPP 50								;
		CPL 80								;
		LMARGIN 5							;
		PREVIEW		;
		LANDSCAPE					
	
	FORN->(DbGoTo(RecFORN))
ENDIF	
Return

***********************************
PROCEDURE FMOSTPR
***********************************
/*
IF FRPR->(DBSEEK(FORNE_2.T_FANTA.VALUE))
   DELETE ITEM ALL FROM Fornece_2 OF FORNE_2
   DO WHILE FRPR->(!EOF()) .AND. FRPR->FANTA = FORNE_2.T_Fanta.VALUE
      ADD ITEM { FRPR->DESPRO,FRPR->DESFAM,TRANSFORM(FRPR->PRECO,"@E 99,999.99"),FRPR->COND } TO Fornece_2 OF Forne_2 
      FRPR->(DBSkip())
   EndDo
ELSE
   DELETE ITEM ALL FROM Fornece_2 OF FORNE_2
ENDIF		
RETURN NIL
*/