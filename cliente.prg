#Include "minigui.ch"
#include "winprint.ch"

FUNCTION clientes
PARAMETERS LIBERA

LiberacaoCiec(LIBERA)

   Public Nuevo := .F.
   ENDCLI:=""
   ENDEMP:=""
      	    
	DEFINE WINDOW clien_2;
	           AT 0,0 ;
 				  WIDTH 1000;
              HEIGHT 530;
	           TITLE 'Cadastro Clientes'     	;
				  ICON "TUTOR";
      		  CHILD ;
     		     ON MAXIMIZE ThisWindow.Center ;
		        ON INIT ( DesactivarEdicion(),Actualizar()) 

		DEFINE TOOLBAR ToolBar_1 BUTTONSIZE 59,35 FLAT BORDER

			BUTTON PRIMERO 		;
				CAPTION '&Primero' 	;
				PICTURE 'primero'	;
				ACTION ( CLI->(dBGoTop()) , Clien_2.Browse_1.Value := CLI->(RecNo()) ) 

			BUTTON ANTERIOR 	;
				CAPTION '&Anterior' 	;
				PICTURE 'anterior'	;
				ACTION ( CLI->(dBSkip ( -1 )) , Clien_2.Browse_1.Value := CLI->(RecNo()) ) 

			BUTTON SIGUIENTE	;
				CAPTION '&Proximo' 	;
				PICTURE 'siguiente'	;
				ACTION ( CLI->(dBSkip (1)) , if ( Eof() , CLI->(DbGoBottom()) , Nil ) , Clien_2.Browse_1.Value := CLI->(RecNo()) ) 

			BUTTON ULTIMO 		;
				CAPTION '&Ultimo' 	;
				PICTURE 'ultimo'	;
				ACTION ( CLI->(dBGoBottom () ), Clien_2.Browse_1.Value := CLI->(RecNo()) )  SEPARATOR 

			BUTTON BUSCAR 		;
				CAPTION '&Pesquisa' 	;
				PICTURE 'buscar'	;
				ACTION BuscarCLI()

			BUTTON Nuevo 		;
				CAPTION '&Novo' 	;
				PICTURE 'nuevo'	;
				ACTION ( Nuevo := .T., Nuevo(), NIL )

			BUTTON EDITAR 		;
				CAPTION 'A&lterar' 	;
				PICTURE 'editar'	;
				ACTION If ( CLI->(TREG() ) , ActivarEdicion() , Nil )

			BUTTON ELIMINAR 	;
				CAPTION 'De&letar'	;
				PICTURE 'borrar'	;
				ACTION Eliminar() 

			BUTTON IMPRIMIR 	;
				CAPTION '&Imprimir'	;
				PICTURE 'imprimir2' ;
            ACTION IMPCLIENTE() // Imprimir() 
/*
			BUTTON ROTA 	;
				CAPTION '&Rota'	;
				PICTURE 'google' ;
            ACTION ROTACLIENTE(ENDCLI,ENDEMP)
*/        
			BUTTON CERRAR 	;
				CAPTION '&Fecha'	;
				PICTURE 'cerrar' ;
            ACTION Clien_2.release 

		END TOOLBAR

                @ 56,10 BROWSE Browse_1				;
			            WIDTH 210  				;
                     HEIGHT 360                              ; 
			            HEADERS { 'Fantasia' ,'Telefone', 'Razão Social' }	;
			            WIDTHS { 190,190,300 }			;
			            WORKAREA cli			;
                     FIELDS { 'Cli->Fanta','CLI->TEL','Cli->descr' } ;
			            ON CHANGE Actualizar() ;
			            ON DBLCLICK ( ActivarEdicion() , If ( ! CLI->(TREG()) , DesactivarEdicion() , Nil ) )
 
                     @ 70,230 LABEL Label_Fanta ;
                              VALUE 'Fantasia'    ;
                              WIDTH 60           ;
                              HEIGHT 30           
/*							
  					      @ 70,680 LABEL Label_Tcomp;
		                        VALUE 'Tipo Compra';
                              WIDTH 100           ;
		                        HEIGHT 30				
							
                     @ 70,770 LABEL Label_Status;
		                        VALUE 'Tipo Produto';
                              WIDTH 100           ;
		                        HEIGHT 30		
						 
                     @ 70,875 Label Label_Etiq ;
					               VALUE "Etiqueta" ;
							         width 130 ;
							         height 30 
*/                                         
                    @100,230 LABEL Label_CGC ;
                            VALUE 'N.CNPJ  '  ;
                            WIDTH 60           ;
                            HEIGHT 30           
	                                            
	                @130,230 LABEL Label_Descr;
		                    VALUE 'Razão Social'	;
                            WIDTH 100           ;
		                    HEIGHT 30			
	         
                   @160,230 LABEL Label_End;
                            VALUE 'Endereço'              ;
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
                       
                   @190,800 LABEL Label_UF    ;
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
	                       
	                @220,795 LABEL Label_Fax	;
		                  VALUE 'Fax'		;
                          WIDTH 60           ;
		                  HEIGHT 30		
	    
	                @250,230 LABEL Label_Ies	;
		                 VALUE 'Ins.Estadual'	;
                         WIDTH 150           ;
         	            HEIGHT 30				
	                         	         
	                @250,500 LABEL Label_Endcob;
		                VALUE 'Endereço de Cobrança';
                        WIDTH 150           ;
		                HEIGHT 30		

                    @280,230 LABEL Label_Baicob;
		                 VALUE 'Bairro Pgto';
                         WIDTH 100           ;
		                 HEIGHT 30		
  
                    @280,490 LABEL Label_Cidcob;
                            VALUE 'Cidade'      ;
                            WIDTH 100           ;
                            HEIGHT 30          	

                    @280,700 LABEL Label_Ufcob;
                            VALUE 'UF'          ;
                            WIDTH 60                    ;
		                    HEIGHT 30			
							
	                @280,770 LABEL Label_Cepcob;
                            VALUE 'Cep Cob'          ;
                            WIDTH 100                    ;
		                    HEIGHT 30		
							
                    @310,230 LABEL Label_Vcdp1  ;
                            VALUE 'Faturar'      ;
                            WIDTH 100           ;
                            HEIGHT 30                      
                                      
                    @310,490 LABEL Label_Email;
                            VALUE 'Email'      ;
                            WIDTH 60           ;
                            HEIGHT 30          	
                                         
                    @340,230 LABEL Label_Transp;
                            VALUE 'Transportadora';
                            WIDTH 130           ;
                            HEIGHT 30           
							
					     @340,600 LABEL Label_TraTel;
                            VALUE 'Tel.Transp.'      ;
                            WIDTH 100                    ;
		                    HEIGHT 30		
                                        
                    @340,790 LABEL Label_TlCel;
                            VALUE 'Celular'      ;
                            WIDTH 100           ;
                            HEIGHT 30           	
						
                    @370,230 LABEL Label_Ncont;
					             VALUE 'Contato'        ;
                            WIDTH 170                    ;
		                      HEIGHT 30							                                     

                    @370,480 LABEL Label_Embala;
                            VALUE 'Embalagem'      ;
                            WIDTH 100           ;
                            HEIGHT 30         

                    @370,620 LABEL Label_Nfe;
                            VALUE 'NFE'      ;
                            WIDTH 60           ;
                            HEIGHT 30         
                     
                    @400,230 LABEL Label_Sci;
                            VALUE 'S.C.I.'       ;
                            WIDTH 100                    ;
		                    HEIGHT 30			
                         
                    @430,10 LABEL Label_Obs;
                            VALUE 'Observações ' ;
                            WIDTH 150               ;
		                      HEIGHT 30		
/*					
   				     @ 490,615 LABEL ITENS_1 VALUE "P r o d u t o s" ;	
				                WIDTH 450           ;
                            HEIGHT 100           
	
	                 @ 510,615 Grid Browse_3 ;
		                  	 WIDTH 390  		;
                            HEIGHT 150      ; 
			                   HEADERS { 'Produto' , 'Descri��o Itens ','Un.','Pre�o'}	;
			                   WIDTHS { 100 , 170, 40, 75}			         
*/                                                           
	                @ 70,310 TEXTBOX T_Fanta;
                            OF Clien_2 ;
		                      WIDTH 250			;
                            TOOLTIP 'Nome Fantasia da Empresa' ;
                            MAXLENGTH 20 ;
                            UPPERCASE         ;
                            ON ENTER ( Checa_Cli(clien_2.T_Fanta.Value) )
/*							
                    @ 95,680 LISTBOX T_Tpcomp;
                            OF clien_2 ;
		                      WIDTH 80 height 70  ;
							       items {"Atacado","Varejo"}
                            							
					     @ 95,770 LISTBOX T_status ;
					              OF Clien_2 ;
		                	    WIDTH 95 HEIGHT 70 ;
			                   ITEMS atipos 
			                		                           					
					     @ 95,875 LISTBOX T_ETiq ;
					             OF Client_2 ;
					             WIDTH 70 HEIGHT 50 ;
							       ITEMS aTsm 		
*/					                    
                    @100,310 TEXTBOX T_CGC  ;
                            OF Clien_2 ;
                            WIDTH 150 ;
                            TOOLTIP 'Informe N.CNPJ do Cliente'; 
                            MAXLENGTH 20   ;
                            ON ENTER clien_2.T_Descr.SetFocus
	                     			
 		              @130,310 TEXTBOX T_Descr ;
                            OF Clien_2     ;
                            WIDTH 370       ;
                            MAXLENGTH 40   ;
                            ON ENTER clien_2.T_End.SetFocus
	         
                    @160,310 TEXTBOX T_End;
                            OF Clien_2 ;
                            WIDTH 300         ;
                            MAXLENGTH 40      ;
                            ON ENTER clien_2.T_Bairro.SetFocus
                            
	                @190,310 TEXTBOX T_Bairro	;
                            OF Clien_2 ;
		                    WIDTH 200                    ;
                            MAXLENGTH 20       ;
                            ON ENTER clien_2.T_Cidade.SetFocus
                         
                    @190,570 TEXTBOX T_Cidade ;
                            OF Clien_2 ;
                            WIDTH 200           ;
                            MAXLENGTH 15      ;
                            ON ENTER clien_2.T_UF.SetFocus

                    @190,820 TEXTBOX T_UF    ;
                            OF Clien_2 ;
                            WIDTH 45                    ;
                            MAXLENGTH 02       ;
                            ON ENTER clien_2.T_Cep.SetFocus
	                  
					    @220,310 TEXTBOX T_Cep	;
                            INPUTMASK '99999-999';
                            ON ENTER clien_2.T_Pais.SetFocus 
							
	                @220,480 TEXTBOX T_Pais	;
                            OF Clien_2 ;
                            WIDTH 150           ;
                            MAXLENGTH 20        ;
                            ON ENTER clien_2.T_Tel.SetFocus
	                    
                    @220,675 TEXTBOX T_Tel ;
 	                        ON ENTER clien_2.T_Fax.SetFocus 
                            // INPUTMASK '(99)9999-9999';


	                 @220,820 TEXTBOX T_Fax	;
	                        ON ENTER clien_2.T_Ies.SetFocus 
                           //INPUTMASK '(99)9999-9999';

              		                  
	                 @250,310 TEXTBOX T_Ies	;
                            OF Clien_2 ;
		                     WIDTH 150           ;
                            MAXLENGTH 18       ;
                            ON ENTER clien_2.T_Endcob.SetFocus

	                @250,650 TEXTBOX T_Endcob;
                            OF clien_2 ;
		                    WIDTH 250          ;
                            MAXLENGTH 35       ;
                            ON ENTER clien_2.T_Baicob.SetFocus 
		            
                    @280,310 TEXTBOX T_Baicob;
                            OF Clien_2 ;
                            WIDTH 150         ;
                            MAXLENGTH 20      ;
                            ON ENTER Clien_2.T_Cidcob.SetFocus

                    @280,540 TEXTBOX T_Cidcob;
                            OF Clien_2 ;
                            WIDTH 150           ;
                            MAXLENGTH 15       ;
                            ON ENTER Clien_2.T_Ufcob.SetFocus
 
                    @280,730 TEXTBOX T_Ufcob;
                            OF clien_2 ;
                            WIDTH 30          ;
                            MAXLENGTH 02      ;
                            ON ENTER clien_2.T_Cepcob.SetFocus   

					     @280,830 TEXTBOX T_CepCob;
                            INPUTMASK '99999-999';
                            ON ENTER clien_2.T_Cdp1.SetFocus          		
  
                    @310,310 TEXTBOX T_Cdp1;
                            OF clien_2 ;
                            NUMERIC ;
                            WIDTH 30          ;
                            MAXLENGTH 10      ;
                            ON ENTER clien_2.T_Cdp2.SetFocus                  

                    @310,350 TEXTBOX T_Cdp2;
                            OF clien_2 ;
                            NUMERIC ;
                            WIDTH 30          ;
                            MAXLENGTH 10      ;
                            ON ENTER clien_2.T_Cdp3.SetFocus                  

                    @310,390 TEXTBOX T_Cdp3;
                            OF clien_2 ;
                            NUMERIC ;
                            WIDTH 30          ;
                            MAXLENGTH 10      ;
                            ON ENTER clien_2.T_Email.SetFocus                  
                                                    
                    @310,530 TEXTBOX T_Email;
                            OF Clien_2 ;
                            WIDTH 300           ;
                            MAXLENGTH 60       ;
                            ON ENTER clien_2.T_Transp.SetFocus                  

                    @340,330 TEXTBOX T_Transp;
                            OF Clien_2 ;
                            WIDTH 250          ;
                            MAXLENGTH 30       ;
                            ON ENTER clien_2.T_Tratel.SetFocus 

                    @340,670 TEXTBOX T_Tratel;
                             ON ENTER clien_2.T_tlcel.SetFocus 
                             //INPUTMASK '(99)9999-9999'
                            		           
                    @340,840 TEXTBOX T_TlCel;
                             ON ENTER clien_2.T_Ncont.SetFocus 
                             //INPUTMASK '(99)9999-9999';
                
                    @370,310 TEXTBOX T_Ncont; 
                            OF clien_2 ;
                            WIDTH 145        ;
                            MAXLENGTH 30    ;
                            ON ENTER clien_2.T_Embala.SetFocus 

                    @370,560 TEXTBOX T_Embala;
                            OF Clien_2 ;
                            NUMERIC ;
                            WIDTH 40           ;
                            MAXLENGTH 5     ;
                            ON ENTER clien_2.T_Nfe.SetFocus 

                    @370,660 TEXTBOX T_Nfe;
                            OF Clien_2 ;
                            WIDTH 300           ;
                            MAXLENGTH 60       ;
                            ON ENTER clien_2.T_Sci.SetFocus                  

                    @400,310 TEXTBOX T_Sci;
                            OF Clien_2 ;
                            WIDTH 350        ;
                            MAXLENGTH 60     ;
                            ON ENTER clien_2.T_Obs1.SetFocus                        

                    @430,100 TEXTBOX T_Obs1;
                            OF Clien_2 ;
                            WIDTH 250                    ;
                            MAXLENGTH 30     ;
                            ON ENTER clien_2.T_Obs2.SetFocus                        

                    @430,350 TEXTBOX T_Obs2;
                            OF Clien_2 ;
                            WIDTH 250                    ;
                            MAXLENGTH 30     ;
                            ON ENTER clien_2.T_Obs3.SetFocus  
 
                    @455,100 TEXTBOX T_Obs3;
                            OF Clien_2 ;
                            WIDTH 250                    ;
                            MAXLENGTH 30     ;
                            ON ENTER clien_2.T_Obs4.SetFocus 

                    @455,350 TEXTBOX T_Obs4;
                            OF Clien_2 ;
                            WIDTH 250                    ;
                            MAXLENGTH 30     ;
                            ON ENTER clien_2.Btn_Scli.SetFocus 
/*       
        		   @ 490,10 LABEL PEDIDO_1 VALUE "P e d i d o s"	;
				         WIDTH 450           ;
                     HEIGHT 50           
						   
				   @ 510,10 Grid Browse_2 ;
		            	WIDTH 595  		;
                     HEIGHT 150      ; 
			            HEADERS { 'Pedido' , 'Dt.Pedido','Descricao','Qte','Forma','Flexa','Perimetro','M(2)' }	;
			            WIDTHS { 65 , 75, 150, 50, 100, 50, 50, 50} ;
							ON DBLCLICK ( BUSCAPED()) 
*/
	             @ 430,670 BUTTON Btn_Scli Of clien_2	;
                          CAPTION '&Salvar'             ;
                          ACTION AceptarEdicion() ;
                          WIDTH 120 HEIGHT 27   ;                                 
                          TOOLTIP "Salvar Registro" ;
                          FLAT

	              @ 430,840 BUTTON Btn_Ccli Of clien_2	;
		                     CAPTION '&Cancelar'		;
                           ACTION CancelarEdicion() ;
			                  WIDTH 120 HEIGHT 27		;
                           TOOLTIP "Cancelar Operação"	;
			    FLAT

	END WINDOW

   clien_2.Browse_1.SetFocus
	
	clien_2.CENTER

	clien_2.ACTIVATE 

RETURN

*------------------------------------------------------------------------------*
PROCEDURE DesactivarEdicion
*------------------------------------------------------------------------------*
        
         Clien_2.Browse_1.Enabled:= .T.
//         Clien_2.Browse_2.Enabled:= .T.
         Clien_2.T_Descr.Enabled:=.F.
         Clien_2.T_Fanta.Enabled:=.F.
         Clien_2.T_End.Enabled:=.F.
         Clien_2.T_Tel.Enabled:=.F.
         Clien_2.T_Cep.Enabled:=.F.
         Clien_2.T_Cidade.Enabled:=.F.
         Clien_2.T_Uf.Enabled:=.F.
         Clien_2.T_CGC.Enabled:=.F.
         Clien_2.T_IES.Enabled:=.F.
         Clien_2.T_BAIRRO.Enabled:=.F.       
         Clien_2.T_PAIS.Enabled:=.F.
         Clien_2.T_ENDCOB.Enabled:=.F.
         Clien_2.T_BAICOB.Enabled:=.F.
         Clien_2.T_CIDCOB.Enabled:=.F.
         Clien_2.T_CEPCOB.Enabled:=.F.
         Clien_2.T_UFCOB.Enabled:=.F.
         Clien_2.T_FAX.Enabled:=.F.
         clien_2.T_OBS1.Enabled:=.F.
         Clien_2.T_OBS2.Enabled:=.F.
         Clien_2.T_OBS3.Enabled:=.F.
         clien_2.T_OBS4.Enabled:=.F.
         Clien_2.T_EMAIL.Enabled:=.F.
         clien_2.T_TRANSP.Enabled:=.F.
         clien_2.T_TRATEL.Enabled:=.F.
         Clien_2.T_EMBALA.Enabled:=.F.
         clien_2.T_Nfe.Enabled:=.F.
//         clien_2.T_STATUS.Enabled:=.F.
         clien_2.T_TLCEL.Enabled:=.F.
         Clien_2.T_NCONT.Enabled:=.F.
         Clien_2.T_SCI.Enabled:=.F.
         clien_2.T_CDP1.Enabled:=.F.
         clien_2.T_CDP2.Enabled:=.F.
         clien_2.T_CDP3.Enabled:=.F.
//         Clien_2.T_ETIQ.Enabled:=.F.
//         clien_2.T_TPCOMP.Enabled:=.F.
         Clien_2.Btn_Ccli.Enabled:= .F.
   	   Clien_2.Btn_Scli.Enabled:= .F.

         Clien_2.ToolBar_1.Enabled:= .T.

         Clien_2.Browse_1.SetFocus
			
RETURN
*------------------------------------------------------------------------------*
PROCEDURE ActivarEdicion
*------------------------------------------------------------------------------*
IF CALTE=.T.        
         clien_2.Browse_1.Enabled:= .F.
	      Clien_2.ToolBar_1.Enabled:= .F.
	      Clien_2.T_Descr.Enabled:=.T.
         Clien_2.T_Fanta.Enabled:=Nuevo
         Clien_2.T_End.Enabled:=.T.
         Clien_2.T_Tel.Enabled:=.T.
         Clien_2.T_Cep.Enabled:=.T.
         Clien_2.T_Cidade.Enabled:=.T.
         Clien_2.T_Uf.Enabled:=.T.
         Clien_2.T_CGC.Enabled:=.T.
         Clien_2.T_IES.Enabled:=.T.
         Clien_2.T_BAIRRO.Enabled:=.T.       
         Clien_2.T_PAIS.Enabled:=.T.
         Clien_2.T_BAIRRO.Enabled:=.T.
         Clien_2.T_ENDCOB.Enabled:=.T.
         Clien_2.T_BAICOB.Enabled:=.T.
         Clien_2.T_CIDCOB.Enabled:=.T.
         Clien_2.T_CEPCOB.Enabled:=.T.
         Clien_2.T_UFCOB.Enabled:=.T.
         Clien_2.T_FAX.Enabled:=.T.
         clien_2.T_OBS1.Enabled:=.T.
         Clien_2.T_OBS2.Enabled:=.T.
         Clien_2.T_OBS3.Enabled:=.T.
         clien_2.T_OBS4.Enabled:=.T.
         Clien_2.T_EMAIL.Enabled:=.T.
         clien_2.T_TRANSP.Enabled:=.T.
         clien_2.T_TRATEL.Enabled:=.T.
         Clien_2.T_EMBALA.Enabled:=.T.
         clien_2.T_Nfe.Enabled:=.T.
//         clien_2.T_STATUS.Enabled:=.T.
         clien_2.T_TLCEL.Enabled:=.T.
         Clien_2.T_NCONT.Enabled:=.T.
         Clien_2.T_SCI.Enabled:=.T.
         clien_2.T_CDP1.Enabled:=.T.
         clien_2.T_CDP2.Enabled:=.T.
         clien_2.T_CDP3.Enabled:=.T.
//         Clien_2.T_ETIQ.Enabled:=.T.
//         clien_2.T_TPCOMP.Enabled:=.T.
         Clien_2.Btn_Ccli.Enabled:= .T.
    	 Clien_2.Btn_Scli.Enabled:= .T.
ENDIF		   	 
RETURN NIL
*------------------------------------------------------------------------------*
PROCEDURE CancelarEdicion()
*------------------------------------------------------------------------------*

	DesactivarEdicion()

	Actualizar()

	Cli->(dbUNLOCK())

	Nuevo := .F.

RETURN
*------------------------------------------------------------------------------*
PROCEDURE AceptarEdicion()
*------------------------------------------------------------------------------*

	DesactivarEdicion()

	If Nuevo == .T.
		Cli->(DbAppend())
		Nuevo := .F.
	EndIf
           CLI->DESCR  := Clien_2.T_Descr.Value 
           CLI->FANTA  := Clien_2.T_Fanta.Value 
           CLI->END    := Clien_2.T_End.Value 
           CLI->TEL    := Clien_2.T_Tel.Value 
           CLI->CEP    := Clien_2.T_Cep.Value 
           CLI->CIDADE := Clien_2.T_Cidade.Value 
           CLI->UF     := Clien_2.T_Uf.Value 
           CLI->CGC    := Clien_2.T_CGC.Value 
           CLI->IES    := Clien_2.T_IES.Value 
           CLI->PAIS   := Clien_2.T_PAIS.Value 
           CLI->BAIRRO := Clien_2.T_BAIRRO.Value 
           CLI->ENDCOB := Clien_2.T_ENDCOB.Value 
           CLI->BAICOB := Clien_2.T_BAICOB.Value 
           CLI->CIDCOB := Clien_2.T_CIDCOB.Value 
           CLI->CEPCOB := Clien_2.T_CEPCOB.Value 
           CLI->UFCOB  := Clien_2.T_UFCOB.Value 
           CLI->FAX    := Clien_2.T_FAX.Value 
           CLI->OBS1   := clien_2.T_OBS1.Value 
           CLI->OBS2   := Clien_2.T_OBS2.Value 
           CLI->OBS3   := Clien_2.T_OBS3.Value 
           CLI->OBS4   := clien_2.T_OBS4.Value 
           CLI->EMAIL  := Clien_2.T_EMAIL.Value 
           CLI->TRANSP := clien_2.T_TRANSP.Value 
           CLI->TRATEL := clien_2.T_TRATEL.Value 
           CLI->EMBALA := Clien_2.T_EMBALA.Value
           CLI->NFE    := clien_2.T_Nfe.value
//           CLI->STATUS := IF(clien_2.T_STATUS.Value=1,"A","V")
           CLI->TLCEL  := clien_2.T_TLCEL.Value 
           CLI->NCONT  := Clien_2.T_NCONT.Value 
           CLI->SCI    := Clien_2.T_SCI.Value 
           CLI->CDP1   := clien_2.T_CDP1.Value
           CLI->CDP2   := clien_2.T_CDP2.Value
           CLI->CDP3   := clien_2.T_CDP3.Value
//           CLI->ETIQ   := IF(clien_2.T_ETIQ.Value=1,"S","N")
/*
           IF clien_2.T_TPCOMP.Value=1
   	        CLI->TPCOMP := "V"
           ELSEIF clien_2.T_TPCOMP.Value=2
		        CLI->TPCOMP := "E"
           ELSEIF clien_2.T_TPCOMP.Value=3
		        CLI->TPCOMP := "C"
           ELSEIF clien_2.T_TPCOMP.Value=4
		        CLI->TPCOMP := "A"
		   ENDIF	  
*/
	Clien_2.Browse_1.Refresh

	If Nuevo == .T.
       clien_2.Browse_1.Value := Cli->(RecNo())
	EndIf

	CLI->(DBUNLOCK())

RETURN

*------------------------------------------------------------------------------*
PROCEDURE Actualizar()
*------------------------------------------------------------------------------*
    	
*         CLI->(DbSeek(fanta))
         CLI->(DBGOTO(CLI->(RECNO())))
         Clien_2.T_Descr.Value   := Cli->Descr
         Clien_2.T_Fanta.Value   := cli->fanta
         Clien_2.T_End.Value     := cli->end
         Clien_2.T_Tel.Value     := cli->tel
         Clien_2.T_Cep.Value     := cli->cep
         Clien_2.T_Cidade.Value  := cli->cidade
         Clien_2.T_Uf.Value      := cli->uf
         Clien_2.T_CGC.Value     := cli->cgc
         Clien_2.T_IES.Value     := cli->ies
         Clien_2.T_BAIRRO.Value  := cli->bairro       
         Clien_2.T_PAIS.Value    := cli->pais
         Clien_2.T_ENDCOB.Value  := cli->endcob
         Clien_2.T_BAICOB.Value  := cli->baicob
         Clien_2.T_CIDCOB.Value  := cli->cidcob
         Clien_2.T_CEPCOB.Value  := cli->cepcob
         Clien_2.T_UFCOB.Value   := cli->ufcob
         Clien_2.T_FAX.Value     := cli->fax
         clien_2.T_OBS1.Value    := cli->obs1
         Clien_2.T_OBS2.Value    := cli->obs2
         Clien_2.T_OBS3.Value    := cli->obs3
         clien_2.T_OBS4.Value    := cli->obs4
         Clien_2.T_EMAIL.Value   := cli->email
         clien_2.T_TRANSP.Value  := cli->transp
         clien_2.T_TRATEL.Value  := cli->tratel
         Clien_2.T_EMBALA.Value  := cli->embala
         clien_2.T_Nfe.value     := CLI->NFE   
//         clien_2.T_STATUS.Value  := IF(cli->status="A",1,2)
         clien_2.T_TLCEL.Value   := cli->tlcel
         Clien_2.T_NCONT.Value   := cli->ncont
         Clien_2.T_SCI.Value     := cli->sci
         clien_2.T_CDP1.Value    := cli->cdp1
         clien_2.T_CDP2.Value    := cli->cdp2
         clien_2.T_CDP3.Value    := cli->cdp3
//         Clien_2.T_ETIQ.Value    := IF(cli->etiq="S",1,2)
/*
 	      IF CLI->TPCOMP="V"
		      CLIEN_2.T_TPCOMP.VALUE:=1
         ELSEIF CLI->TPCOMP="E"
		      CLIEN_2.T_TPCOMP.VALUE:=2
		   ELSEIF CLI->TPCOMP="C"	  
		      Clien_2.T_TPCOMP.Value:=3
		   ELSEIF CLI->TPCOMP="A"	  
		      clien_2.T_TPCOMP.Value:=4
		   ENDIF	
*/
         // DADOS ROTA 
         ENDCLI:=AllTrim(EMP->END)+","+AllTrim(EMP->CIDADE)+","+EMP->UF
         ENDEMP:=AllTrim(CLI->END)+","+AllTrim(CLI->CIDADE)+","+CLI->UF		 

         ACTUALANP()	     
Return

*------------------------------------------------------------------------------*
PROCEDURE ActuaLANP()
*------------------------------------------------------------------------------*
    Local pFANTA	:= CLIEN_2.T_Fanta.value

	 /*  ENCHE GRID DOS ITENS COM O PEDIDO ESCOLHIDO  */
/*
    LANP->(DBSETORDER(6))	 
    DELETE ITEM ALL FROM BROWSE_2 OF CLIEN_2

    lanp->( ordscope(0,pfanta ))
    lanp->( ordscope(1,pfanta ))
    lanp->( dbgotop() )
	 // IF LANP->(DBSeek(pfanta))	
    // Do While LANP->(!EOF()) .AND. LANP->FANTA = Pfanta 
    Do While LANP->(!EOF())
       IF LANP->NPED>0
    		 VDESC:=IF(FAM->(DBSEEK(LANP->CODFAM)),substr(FAM->DESFAM,1,25),"")
	       ADD ITEM { STR(LANP->NPED,10),DTOC(LANP->DTLAN),VDESC,STR(LANP->QTE,4),LANP->MOD,str(lanp->cm1,5),str(lanp->cm2,5),str(lanp->cm3,6,2) } TO Browse_2 OF clien_2  
	    ENDIF   
	    lanp->(DBSkip())
	 EndDo
    lanp->( ordscope( 0, NIL ) ) 
    lanp->( ordscope( 1, NIL ) )

	 /*  ENCHE GRID DOS ITENS COM O PEDIDO ESCOLHIDO  */
/*
    CLPR->(DBSETORDER(1))	 
	 IF CLPR->(DBSeek(pfanta))	
	    DELETE ITEM ALL FROM BROWSE_3 OF CLIEN_2
        Do While CLPR->(!EOF()) .AND. CLPR->FANTA = Pfanta 
	       ADD ITEM { CLPR->DESPRO,CLPR->DESFAM,CLPR->UNIFAM,STR(CLPR->PRECO,12,2)} TO Browse_3 OF clien_2
	       CLPR->(DBSkip())
	    EndDo
     ELSE
	 	DELETE ITEM ALL FROM BROWSE_3 OF CLIEN_2
     ENDIF			 
*/     
Return NIL
       	   
*------------------------------------------------------------------------------*
Procedure BuscarCLI
*------------------------------------------------------------------------------*
Local Buscar
Local nOption:=0 

  nOption:=MsgOptions(,,"Users.Bmp" , {"&Fantasia","&Razao Social","&CGC/CNPJ","&Telefone"}, 2, 20 )

  DO CASE
     CASE nOption = 1
          cli->(dbsetorder(1))
          Buscar := Upper ( AllTrim ( InputBox( 'Informe Fantasia' , 'Pesquisa' ) ) )
     CASE nOPTION=2
          cli->(dbsetorder(2))
          Buscar := Upper ( AllTrim ( InputBox( 'Informe Razao Social' , 'Pesquisa' ) ) )
     CASE nOPTION=3
          cli->(dbsetorder(5))
          Buscar := Upper ( AllTrim ( InputBox( 'Informe CGC/CNPJ' , 'Pesquisa' ) ) )
     CASE nOPTION=4
			 buscar:=space(15)
          cli->(dbsetorder(3))
          Buscar := Upper ( AllTrim ( InputBox( 'Informe Telefone' , 'Pesquisa' ) ) )
  ENDCASE 			  
         
  If .Not. Empty(Buscar)
   	SET SOFTSEEK ON
		cli->(DbSeek(Buscar))
      Clien_2.Browse_1.Value := Cli->(RecNo())
		SET SOFTSEEK OFF
	EndIf
Return


*------------------------------------------------------------------------------*
PROCEDURE Nuevo()
*------------------------------------------------------------------------------*

IF CINCL=.T. 
	      Clien_2.T_Descr.Value:=""
         Clien_2.T_Fanta.Value:=""
         Clien_2.T_End.Value := ""
         Clien_2.T_Tel.Value := ""
         Clien_2.T_Cep.Value := ""
         Clien_2.T_Cidade.Value := ""
         Clien_2.T_Uf.Value := ""
         Clien_2.T_CGC.Value := ""
         Clien_2.T_IES.Value := ""
         Clien_2.T_BAIRRO.Value := ""       
         Clien_2.T_PAIS.Value := ""
         Clien_2.T_BAIRRO.Value := ""
         Clien_2.T_ENDCOB.Value := ""
         Clien_2.T_BAICOB.Value := ""
         Clien_2.T_CIDCOB.Value := ""
         Clien_2.T_CEPCOB.Value := ""
         Clien_2.T_UFCOB.Value := ""
         Clien_2.T_FAX.Value := ""
         clien_2.T_OBS1.Value := ""
         Clien_2.T_OBS2.Value := ""
         Clien_2.T_OBS3.Value := ""
         clien_2.T_OBS4.Value := ""
         Clien_2.T_EMAIL.Value := ""
         clien_2.T_TRANSP.Value := ""
         clien_2.T_TRATEL.Value := ""
         Clien_2.T_EMBALA.Value := ""
//         clien_2.T_STATUS.Value := ""
         clien_2.T_TLCEL.Value := ""
         Clien_2.T_NCONT.Value := ""
         Clien_2.T_SCI.Value := ""
         clien_2.T_CDP1.Value := ""
         clien_2.T_CDP2.Value := ""
         clien_2.T_CDP3.Value := ""
//         Clien_2.T_ETIQ.Value := ""
//         clien_2.T_TPCOMP.Value := ""
         ActivarEdicion()
ENDIF         
RETURN

*------------------------------------------------------------------------------*
Procedure Eliminar
*------------------------------------------------------------------------------*
IF CEXCL=.T.
	If MsgYesNo ( "Confirma Exclus�o de Cliente ?","Aten��o")
		If CLI->(TREG())
			Cli->(dbdelete())
			Cli->(dbunlock())
			Cli->(dbgotop()) 
			clien_2.Browse_1.Value := Cli->(RecNo())
			Actualizar()
		EndIf
	EndIf
ENDIF
Return NIL

**************************************
PROCEDURE Imprimir
**************************************
IF CIMPR=.T.
   NOPTION:=0
   nOption:=MsgOptions("Deseja Impress�o ?","Veja as Op��es ?","Users.Bmp" , {"&Cliente","&Varios","&Cancela"},1,30,60) 

   IF NOPTION=3
      RETURN NIL
   ENDIF

   IF NOPTION=1
      IMPCLIENTE()
   ELSE
  	   IMPRICLI()
   ENDIF	   
ENDIF   
RETURN NIL

*------------------------------------------------------------------------------*
Procedure ImpriCLI
*------------------------------------------------------------------------------*
Local Reccli 

	Reccli := cli->(RecNo())
	
	DO REPORT								;
        TITLE EMPRESA;
                HEADERS  {'','','','',''} , {'Fantasia','Razao Social','Cidade','Uf','Contato'};
                FIELDS   {'cli->fanta','cli->descr','CLI->CIDADE','CLI->UF','CLI->NCONT'};
		WIDTHS   {20,30,20,5,20} 						;
		TOTALS   {.F.,.F.,.F.,.F.,.F.}					;
		WORKAREA cli						;
		LPP 50								;
		CPL 80								;
		LMARGIN 5							;
		PREVIEW							
	
	cli->(DbGoTo(Reccli))
Return

**************************************************
PROCEDURE IMPCLIENTE
**************************************************
#include "winprint.ch"
Local dirimp:=GetCurrentFolder(), PAG, LH, CHK:="N"

TITULOIMP:="Relatorio Cliente"
  
INIT PRINTSYS

SELECT BY DIALOG PREVIEW

IF HBPRNERROR > 0
   RETURN NIL
ENDIF
    
// Defini��o das fontes.
define font "ft10" name "times new roman" size 10
define font "ft12" name "times new roman" size 12 //bold=negrita
define font "ft14" name "times new roman" size 14
define font "ft18" name "times new roman" size 18

// Defini��o das Linhas.
define pen "p0" style PS_SOLID width 1 color 0x000000
define pen "p1" style PS_DOT width 1 color 0xFF0000
define pen "p2" style PS_NULL

set page orientation DMORIENT_PORTRAIT papersize DMPAPER_LETTER font "ft10"

start doc name TituloImp
start page

PAG:=0
select font "ft12"
select pen "p0"

           LH=2
           @ LH++,03 SAY "                 C a d a s t r o   de   C l i e n t e s " to print
           LH+=2
           @ LH++,03 SAY "Nome Fantasia         :"+CLI->FANTA+" Produto :"+IF(CLI->status="V","Vidros ",IF(CLI->STATUS="E","Espelhos ",IF(CLI->STATUS="C","Convexo","Ambos "))) to print
           @ LH++,03 SAY "N. CGC                :"+CLI->CGC+" Etiqueta :"+CLI->ETIQ to print
           @ LH++,03 SAY "Razao Social          :"+CLI->DESCR to print
           @ LH++,03 SAY "Endereco              :"+CLI->END to print
           @ LH++,03 SAY "Bairro                :"+CLI->BAIRRO to print
           @ LH++,03 SAY "Cidade                :"+CLI->CIDADE to print
           @ LH++,03 SAY "UF                    :"+CLI->UF to print
           @ LH++,03 SAY "Pais                  :"+CLI->PAIS to print
           @ LH++,03 SAY "Telefone              :"+CLI->TEL to print
           @ LH++,03 SAY "Fax                   :"+CLI->FAX to print
           @ LH++,03 SAY "CEP                   :"+CLI->CEP to print
           @ LH++,03 SAY "N. Inscricao Estadual :"+CLI->IES+" Tipo Cliente:"+CLI->TPCOMP to print
           @ LH++,03 SAY "Endereco de Cobranca  :"+CLI->ENDCOB to print
           @ LH++,03 SAY "Bairro de Pagamento   :"+CLI->BAICOB+" Cidade :"+CLI->CIDCOB+" UF:"+CLI->UFCOB to print
           @ LH++,03 SAY "Faturar               :"+STR(CLI->CDP1,2)+"/"+STR(CLI->CDP2,2)+"/"+STR(CLI->CDP3)+" Cep Cobran�a:"+CLI->CEPCOB to print
           @ LH++,03 SAY "Email                 :"+CLI->EMAIL to print
           @ LH++,03 SAY "Transportadora        :"+CLI->TRANSP+" Tel.:"+CLI->TRATEL to print
           @ LH++,03 SAY "Telefone Celular      :"+CLI->TLCEL+" Contato :"+CLI->NCONT to print
           @ LH++,03 SAY "Embalagem             :"+STR(CLI->EMBALA,4) to print
           @ LH++,03 SAY "S.C.I.:"+CLI->SCI to print
end page
end doc

release printsys
SetCurrentFolder(dirimp)
RETURN NIL

Procedure Checa_Cli()
**********************************
* verifica possibilidade de inclus�o
**********************************
If cli->(DbSeek(clien_2.T_Fanta.Value))
   Msginfo("Nome Fantasia J� Cadastrado!","Verifique")
   CancelarEdicion()
EndIf   
Return NIL
