#Include "minigui.ch"
#include "winprint.ch"

FUNCTION ITENS
PARAMETERS LIBERA

LiberacaoCiec(LIBERA)

   Public Nuevo := .F.
	 	    
	DEFINE WINDOW FAM_2;
	           AT 0,0 ;
 				  WIDTH 770;
              HEIGHT 600 ;
	           TITLE "Cadastro de Produtos" 	;
				  ICON "TUTOR";
		        CHILD ;
		        ON MAXIMIZE ThisWindow.Center ;
		        ON INIT ( DesactivarFAM(),ActualizaFAM()) 

		DEFINE TOOLBAR ToolBar_1 BUTTONSIZE 59,35 FLAT BORDER

			BUTTON PRIMERO 		;
				CAPTION '&Primero' 	;
				PICTURE 'primero'	;
				ACTION ( FAM->(dBGoTop()) , FAM_2.Browse_1.Value := FAM->(RecNo()) ) 

			BUTTON ANTERIOR 	;
				CAPTION '&Anterior' 	;
				PICTURE 'anterior'	;
				ACTION ( FAM->(dBSkip ( -1 )) , FAM_2.Browse_1.Value := FAM->(RecNo()) ) 

			BUTTON SIGUIENTE	;
				CAPTION '&Proximo' 	;
				PICTURE 'siguiente'	;
				ACTION ( FAM->(dBSkip (1)) , if ( Eof() , FAM->(DbGoBottom()) , Nil ) , FAM_2.Browse_1.Value := FAM->(RecNo()) ) 

			BUTTON ULTIMO 		;
				CAPTION '&Ultimo' 	;
				PICTURE 'ultimo'	;
				ACTION ( FAM->(dBGoBottom () ), FAM_2.Browse_1.Value := FAM->(RecNo()) )  SEPARATOR 

			BUTTON BUSCAR 		;
				CAPTION '&Pesquisa' 	;
				PICTURE 'buscar'	;
				ACTION BuscarFAM()

			BUTTON Nuevo 		;
				CAPTION '&Novo' 	;
				PICTURE 'nuevo'	;
				ACTION ( Nuevo := .T. , NuevoFAM() )

			BUTTON EDITAR 		;
				CAPTION 'A&lterar' 	;
				PICTURE 'editar'	;
				ACTION If ( FAM->(TREG() ) , ActivarFAM() , Nil )

			BUTTON ELIMINAR 	;
				CAPTION 'De&letar'	;
				PICTURE 'borrar'	;
				ACTION EliminarFAM() 

			BUTTON IMPRIMIR 	;
				CAPTION '&Imprimir'	;
				PICTURE 'imprimir2' ;
				ACTION ImprimirFAM() 

			BUTTON CERRAR 	;
				CAPTION '&Fecha'	;
				PICTURE 'cerrar' ;
            ACTION FAM_2.release 

		END TOOLBAR
 
                @ 56,10 BROWSE Browse_1				;
			            WIDTH 380  				;
                     HEIGHT 260         ; 
			            HEADERS { 'Maxpaint','Descrição','Embalagem'} ;
			            WIDTHS { 80 , 180, 100 }			;
			            WORKAREA FAM			;       
                     FIELDS { 'FAM->CODMAX' , 'FAM->DESCMAX','FAM->EMBALA'} ;
                     ON CHANGE ActualizaFAM() ;
			            ON DBLCLICK ( ActivarFAM() , If ( ! FAM->(TREG()) , DesactivarFAM() , Nil ) )

                     @ 70,400 LABEL A ;
                              VALUE 'MaxiPaint' ;
                              WIDTH 80           ;
                              HEIGHT 30           
         
                     @100,400 LABEL C;
                              VALUE 'Descrição  '  ;
                              WIDTH 80           ;
		                        HEIGHT 30		
                            
	                  @130,400 LABEL D ;
		                        VALUE 'Embalagem';
                              WIDTH 90          ;
		                        HEIGHT 30			

	                  @160,400 LABEL Rc ;
		                        VALUE 'R$ Compra';
                              WIDTH 90          ;
		                        HEIGHT 30			

                     @160,560 LABEL qtcp ;
		                        VALUE 'Qtd.Compra';
                              WIDTH 90          ;
		                        HEIGHT 30		
		                        
	                  @190,400 LABEL RV ;
		                        VALUE 'R$ Venda';
                              WIDTH 90          ;
		                        HEIGHT 30			
		                        
	                  @220,400 LABEL Re ;
		                        VALUE 'Estoque';
                              WIDTH 90          ;
		                        HEIGHT 30			
				
					      @070,470 TEXTBOX T_CODMAX ;
					               OF FAM_2  ;
		            	         WIDTH 100  ;
										ON ENTER ( FAMCTRL())       

					      @100,470 TEXTBOX T_DESCMAX ;
					               OF FAM_2  ;
		            	         WIDTH 230 ;
		            	         MAXLENGTH 35 			  

			    	      @130,470 COMBOBOX T_EMBALA;
   			                  ITEMSOURCE CADP->DESPEC;	
					  		         VALUESOURCE CADP->CODPEC;
  							         WIDTH 190 HEIGHT 120 
										
                     @160,470 TEXTBOX T_VLCOMP;
                             OF FAM_2 ;
                             WIDTH 80  ;                              								
   					 		     NUMERIC INPUTMASK '99999.999'
										
							@160,630 TEXTBOX T_QTECOMP;
                             OF FAM_2 ;
                             WIDTH 80  ;                              								
   					 		     NUMERIC INPUTMASK '9999999';
									  ON ENTER FAM_2.T_VLREAL.setfocus	

                     @190,470 TEXTBOX T_VLREAL;
                             OF FAM_2 ;
                             WIDTH 80  ;                              								
   					 		     NUMERIC INPUTMASK '99999.999'	

                     @220,470 TEXTBOX T_QTEMAX;
                             OF FAM_2 ;
                             WIDTH 80  ;                              								
   					 		     NUMERIC INPUTMASK '99999.99';
									  ON ENTER FAM_2.Btn_SFAM.setfocus	
   					 		     
                     @ 330,010 FRAME Frame_2 WIDTH 480 HEIGHT 200 CAPTION "Agregados do Produto"   					 		     

      				   @ 350,020 Grid G_Agregado ;
		                	      WIDTH 460  		;
                              HEIGHT 170     ; 
			                     HEADERS {'Agregado','Descrição','Quantidade','R$','Ctr'}; 
					               WIDTHS { 90 , 200, 80, 90, 90} ;
					               TOOLTIP "Para Excluir Agregado, Clik no Mesmo" ;
						            ON DBLCLICK { || ALTERAGREG() }
							         
	                  @280,400 BUTTON Btn_SFAM Of FAM_2	;
                             CAPTION '&Salvar'             ;
                             ACTION AceptarFAM() ;
                             WIDTH 80 HEIGHT 27   ;                                 
                             TOOLTIP "Salvar Registro" ;
                             FLAT

	                  @280,530 BUTTON Btn_CFAM Of FAM_2	;
		                       CAPTION '&Cancelar'		;
                             ACTION CancelarFAM() ;
			                    WIDTH 80 HEIGHT 27		;
                             TOOLTIP "Cancelar Operação"	;
			                    FLAT

	END WINDOW

   FAM_2.Browse_1.SetFocus
	
	FAM_2.CENTER 

	FAM_2.ACTIVATE 

RETURN

*------------------------------------------------------------------------------*
PROCEDURE DesactivarFAM
*------------------------------------------------------------------------------*
        
         FAM_2.Browse_1.Enabled:=.T.
         FAM_2.T_CODMAX.ENABLED:=.F.
         FAM_2.T_DESCMAX.ENABLED:=.F.
         FAM_2.T_VLCOMP.ENABLED:=.F.
         FAM_2.T_VLREAL.ENABLED:=.F.
         FAM_2.T_EMBALA.ENABLED:=.F.
         FAM_2.T_QTEMAX.ENABLED:=.F.
         FAM_2.T_QTECOMP.ENABLED:=.F.
         FAM_2.Btn_CFAM.Enabled:=.F.
   	   FAM_2.Btn_SFAM.Enabled:=.F.
         FAM_2.ToolBar_1.Enabled:=.T.
         FAM_2.G_Agregado.Enabled:=.T.
         FAM_2.Browse_1.SetFocus

RETURN
*------------------------------------------------------------------------------*
PROCEDURE ActivarFAM
*------------------------------------------------------------------------------*
IF CALTE=.T. 
    
         FAM_2.T_CODMAX.ENABLED:=Nuevo
         FAM_2.T_DESCMAX.ENABLED:=.T.
         FAM_2.T_VLCOMP.ENABLED:=.T.
         FAM_2.T_VLREAL.ENABLED:=.T.
         FAM_2.T_EMBALA.ENABLED:=.T.
         FAM_2.T_QTEMAX.ENABLED:=.T.
         FAM_2.T_QTECOMP.ENABLED:=.T.
	      FAM_2.ToolBar_1.Enabled:= .F.
         FAM_2.Btn_CFAM.Enabled:= .T.
      	FAM_2.Btn_SFAM.Enabled:= .T.
         FAM_2.Browse_1.Enabled:=.F.

ENDIF		   	 
RETURN
*------------------------------------------------------------------------------*
PROCEDURE CancelarFAM()
*------------------------------------------------------------------------------*
	DesactivarFAM()
	ActualizaFAM()
	FAM->(DBUNLOCK())
	Nuevo := .F.
RETURN
*------------------------------------------------------------------------------*
PROCEDURE AceptarFAM()
*------------------------------------------------------------------------------*

	DesactivarFAM()

	If Nuevo == .T.
		FAM->(DbAppend())
		Nuevo := .F.
	EndIf

   FAM->CODMAX := FAM_2.T_CODMAX.VALUE
   FAM->DESCMAX:= FAM_2.T_DESCMAX.VALUE
   FAM->QTEMAX := FAM_2.T_QTEMAX.VALUE
   FAM->VLCOMP := FAM_2.T_VLCOMP.VALUE
   FAM->VLREAL := FAM_2.T_VLREAL.VALUE
   FAM->EMBALA := FAM_2.T_EMBALA.VALUE
   FAM->QTECOMP :=FAM_2.T_QTECOMP.VALUE
	FAM_2.Browse_1.Refresh

	FAM->(DBUNLOCK())

RETURN

*------------------------------------------------------------------------------*
PROCEDURE ActualizaFAM()
*------------------------------------------------------------------------------*
   FAM->(DbSeek(FAM->CODMAX))
   FAM_2.T_CODMAX.VALUE:=FAM->CODMAX 
   FAM_2.T_DESCMAX.VALUE:=FAM->DESCMAX
   FAM_2.T_QTEMAX.VALUE:=FAM->QTEMAX 
   FAM_2.T_VLCOMP.VALUE:=FAM->VLCOMP 
   FAM_2.T_VLREAL.VALUE:=FAM->VLREAL
	FAM_2.T_QTECOMP.VALUE:=FAM->QTECOMP 
   FAM_2.T_EMBALA.VALUE:=if(CADP->(DBSEEK(FAM->EMBALA)),CADP->(RECNO()),space(05))//CADP->DESPEC,SPACE(05))//FAM->EMBALA 
   Grid_Agreg(FAM->CODMAX)
Return

       	   
*------------------------------------------------------------------------------*
Procedure BuscarFAM
*------------------------------------------------------------------------------*
Local Buscar

  FAM->(dbsetorder(1))
  Buscar := Upper ( AllTrim ( InputBox( 'Informe Cod. Maxipaint' , 'Pesquisa' ) ) )
  If !Empty(Buscar)
      SET SOFTSEEK ON  
    	If FAM->(DbSeek(Buscar))
			FAM_2.Browse_1.Value := FAM->(RecNo())
		Else
         MsgExclamation('Nao encontrado registro')
		EndIf
		SET SOFTSEEK off
	EndIf

Return


*------------------------------------------------------------------------------*
PROCEDURE NuevoFAM()
*------------------------------------------------------------------------------*
IF CINCL=.T.
   FAM_2.T_CODMAX.VALUE:=SPACE(10) 
   FAM_2.T_DESCMAX.VALUE:=SPACE(35)
   FAM_2.T_QTEMAX.VALUE:=0 
   FAM_2.T_VLCOMP.VALUE:=0.000
   FAM_2.T_VLREAL.VALUE:=0.000 
   FAM_2.T_QTECOMP.VALUE:=0
   FAM_2.T_EMBALA.VALUE:=SPACE(05) 
   ActivarFAM()
ENDIF
RETURN

*------------------------------------------------------------------------------*
procedure EliminarFAM()
*------------------------------------------------------------------------------*
IF CEXCL=.T.
	If MsgYesNo ( "Confirma Exclusão ?","Atenção")
		If FAM->(TREG())
			FAM->(dbdelete())
			FAM->(DBUNLOCK())
			FAM->(dbgotop()) 
			FAM_2.Browse_1.Value := FAM->(RecNo())
			ActualizaFAM()
		EndIf
	EndIf
ENDIF
Return

*------------------------------------------------------------------------------*
procedure FAMCTRL()
*------------------------------------------------------------------------------*
LOCAL C_CODMA:=FAM_2.T_CODMAX.VALUE+REPLICAT(SPACE(01),10-LEN(FAM_2.T_CODMAX.VALUE))
IF Nuevo == .T.
   IF FAM->(DBSEEK(C_CODMA))
		MSGINFO("Codigo Maxipaint já Cadastrado!","Verifique")
   	FAM_2.T_CODMAX.VALUE:=SPACE(10)
	   FAM_2.T_CODMAX.SETFOCUS  
	ENDIF   
ENDIF
Return NIL

*------------------------------------------------------------------------------*
procedure Grid_Agreg(P_CodMax)
*------------------------------------------------------------------------------*
local p_ProdMax:=0
DELETE ITEM ALL FROM G_Agregado OF FAM_2
IF AGR->(DBSEEK(P_CodMax))
   p_ProdMax:=fam->(recno())
   do while agr->(!eof()) .and. agr->CODMAXAGR == P_CodMax
      ADD ITEM { AGR->AGREGADO,if(fam->(dbseek(AGR->AGREGADO)),fam->DESCMAX,space(30)),str(AGR->QTEAGR,10),if(fam->(dbseek(AGR->AGREGADO)),str(FAM->VLREAL,12,3),'0.000'),str(agr->(recno()),10) }  TO G_Agregado OF FAM_2 
	   agr->(dbskip())
	enddo
	fam->(dbgoto(p_ProdMax))
ENDIF
Return NIL

procedure ImprimirFAM()

Local dirimp:=GetCurrentFolder(), PAG, LH
LOCAL nOption:=0,p_fam:=0
Init PRINTSYS
 Request HB_CODEPAGE_PT850
 
AGR->(DBGOTOP())
FAM->(DBGOTOP())

TituloImp:="Rel.Produtos" 
nOption:=MsgOptions("Escolha Uma Opção ?","Impressão", "Users.Bmp" , {"Analitico","Sintético","Retorna"},3, 20) 
SELECT BY DIALOG PREVIEW
IF HBPRNERROR>0
   release printsys
   SetCurrentFolder(dirimp)
   return nil
ENDIF
HB_SETCODEPAGE( "PT850" )

SET UNITS MM
//SET UNITS ROWCOL // MM ROWCOL  

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

set page orientation DMORIENT_LANDSCAPE papersize DMPAPER_A4 font "ft10"

start doc name TituloImp
PAG:=0
LH:=02
start page
Do WHILE fam->(!EOF())
	
   IF LH > 238 .OR. PAG=0
      IF PAG<>0
         END page
         start page
      endif
      LH:=02
		PAG++
      select font "ft14"
      @ lh,020 SAY empresa+'-> Cadastro da Produtos ' TO PRINT
      select font "ft10"
      lh+=5

      CB_ImprimirFAM(lh)         
    
      @ LH,001 SAY "Cod.MaxPaint" TO PRINT
      @ LH,023 SAY "Composto" TO PRINT
      @ LH,043 SAY "Descrição" TO PRINT
      @ LH,126 SAY "R$ Compra" TO PRINT
      @ LH,146 SAY "R$ Venda" TO PRINT
      @ LH,166 SAY "Est" TO PRINT
      @ LH,176 SAY "Tl.Comp." TO PRINT
      @ LH,201 SAY "Tl.Venda" TO PRINT
      @ LH,216 SAY "Embalagem" TO PRINT
         
      LH+=5
   endif

   CB_ImprimirFAM(lh)

   @ LH,001 SAY fam->codmax TO PRINT
	@ LH,023 SAY fam->codcomp TO PRINT  
   @ LH,043 SAY fam->descmax TO PRINT 
   @ LH,130 SAY transform(fam->vlcomp,"@e 9,999.99") TO PRINT
   @ LH,149 SAY transform(fam->vlreal,"@e 9,999.999") TO PRINT
   @ LH,167 SAY str(fam->qtemax,5) TO PRINT
   @ LH,179 SAY transform(fam->qtemax*fam->vlcomp,"@E 9.999,999") TO PRINT
   @ LH,200 SAY transform(fam->qtemax*fam->vlreal,"@E 9.999,999") TO PRINT
   @ LH,216 SAY if(CADP->(dbseek(FAM->EMBALA)),CADP->DESPEC,FAM->EMBALA) TO PRINT 

   if nOption = 1
      
      if AGR->(DbSeek(fam->codmax))
         lh+=5

         @ LH,022,LH+5,042 RECTANGLE 
         @ LH,042,LH+5,125 RECTANGLE 
         @ LH,125,LH+5,145 RECTANGLE
         @ LH,145,LH+5,165 RECTANGLE

         @ LH,023 SAY "Agregado" TO PRINT
         @ LH,043 SAY "Descrição" TO PRINT
         @ LH,127 SAY "Quantidade" TO PRINT
         @ LH,146 SAY "R$ Venda" TO PRINT
         lh+=5
         
         do while agr->(!eof()) .and. agr->CODMAXAGR == fam->codmax
            p_fam:=fam->(recno())

            @ LH,022,LH+5,042 RECTANGLE 
            @ LH,042,LH+5,125 RECTANGLE 
            @ LH,125,LH+5,145 RECTANGLE
            @ LH,145,LH+5,165 RECTANGLE
         
            @ LH,023 SAY AGR->AGREGADO TO PRINT 
            @ LH,043 SAY if(fam->(dbseek(AGR->AGREGADO)),fam->DESCMAX,space(30)) TO PRINT 
            @ LH,131 SAY str(AGR->QTEAGR,5) TO PRINT
            @ LH,147 SAY if(fam->(dbseek(AGR->AGREGADO)),transform(fam->vlreal,"@E 99.999,999"),space(30)) TO PRINT 
            fam->(dbgoto(p_fam))

				lh+=5
            agr->(dbskip())
         enddo
         
         CB_ImprimirFAM(lh)
         @ LH,001 SAY "Cod.MaxPaint" TO PRINT
         @ LH,023 SAY "Composto" TO PRINT
         @ LH,043 SAY "Descrição" TO PRINT
         @ LH,126 SAY "R$ Compra" TO PRINT
         @ LH,146 SAY "R$ Venda" TO PRINT
         @ LH,166 SAY "Est" TO PRINT
         @ LH,176 SAY "Tl.Comp." TO PRINT
         @ LH,201 SAY "Tl.Venda" TO PRINT
         @ LH,216 SAY "Embalagem" TO PRINT
      endif
   endif					   

	lh+=5
   FAM->(DBSKIP())
EndDo  
END page
END doc
Release printsys
SetCurrentFolder(dirimp)
Return NIL

*------------------------------------------------------------------------------*
procedure CB_ImprimirFAM(lh)
*------------------------------------------------------------------------------*
      @ LH,000,LH+5,022 RECTANGLE 
      @ LH,022,LH+5,042 RECTANGLE 
      @ LH,042,LH+5,125 RECTANGLE 
      @ LH,125,LH+5,145 RECTANGLE
      @ LH,145,LH+5,165 RECTANGLE
      @ LH,165,LH+5,175 RECTANGLE
      @ LH,175,LH+5,200 RECTANGLE
      @ LH,200,LH+5,215 RECTANGLE
      @ LH,215,LH+5,265 RECTANGLE
return

*------------------------------------------------------------------------------*
procedure ALTERAGREG()
*------------------------------------------------------------------------------*
Local nOption:=0 
	  
     CHAVE:=VAL(PegaValorDaColuna( "G_Agregado","FAM_2",5))
	  
	  agr->(DBGOTO(CHAVE))

     nOption:=MsgOptions("Atenção","Lançamentos Agregados", "Users.Bmp" , {"&Exclui","&Retorna"},2, 20,60 ) 
		
     IF nOPTION=1
		  If MsgYesNo ('Confirma Exclusão de Agregado ?','ATENÇÃO') 
		     agr->(RLock())
		     agr->(DBDELETE())
			  agr->(DBUNLOCK())
        Endif
        Grid_Agreg(agr->CODMAXAGR)   
     endif
	     
Return NIL
