#Include "minigui.ch"

FUNCTION ETIQBRANCA

   public etiqbranca:=.t.

	DEFINE WINDOW ETIQ_B;
	           AT 0,0 ;
 				  WIDTH 430; 
              HEIGHT 360 ;
	           TITLE "Etiquetas Em Branco (Definidas)"	;
				  ICON "TUTOR";
		        CHILD ;
              FONT 'Arial' SIZE 12 ;
        		  BACKCOLOR YELLOW ;
		        ON MAXIMIZE ThisWindow.Center ;
		        ON INIT ( Ativa_Etiqb()) 

                     @ 30,010 LABEL LT ;
                              VALUE 'Peça'  ;
                              WIDTH 60           ;
                              HEIGHT 20   
										
   			    	   @ 60,010 TEXTBOX T_PECA;
 			    	               OF ETIQ_B ;
  							         WIDTH 150 

                     @ 30,230 LABEL NP ;
                              VALUE 'Nome'  ;
                              WIDTH 60           ;
                              HEIGHT 20           

   			    	   @ 60,230 TEXTBOX T_NPECA;
 			    	               OF ETIQ_B ;
  							         WIDTH 150 

                     @ 90,010 LABEL CO ;
                              VALUE 'Cores'  ;
                              WIDTH 60           ;
                              HEIGHT 20           

   			    	   @ 120,10 TEXTBOX T_CORES;
			    	               OF ETIQ_B ;
  							         WIDTH 150 

                     @ 90,230 LABEL VL ;
                              VALUE 'Validade'  ;
                              WIDTH 100          ;
                              HEIGHT 20           

			    	      @ 120,230 TEXTBOX T_VALIDADE;
			    	               OF ETIQ_B ;
   			                  WIDTH 150 

                     @ 150,10 LABEL PC ;
                              VALUE 'Lote' ;
                              WIDTH 80           ;
                              HEIGHT 20           

			    	      @ 180,10 TEXTBOX T_LOTE;
			    	               OF ETIQ_B ;
   			                  WIDTH 150 
											 
                     @ 150,230 LABEL dtf ;
                              VALUE 'Fabricação'  ;
                              WIDTH 100           ;
                              HEIGHT 20           
  			                  
	  				      @ 180,230 DATEPICKER T_dtlan	

	                  @ 230,120 BUTTON Btn_SETQ Of ETIQ_B	;
                               CAPTION '&Imprimir'             ;
                               ACTION IMPETIQargox(ETIQ_B.T_PECA.VALUE,ETIQ_B.T_NPECA.VALUE,ETIQ_B.T_CORES.VALUE,ETIQ_B.T_VALIDADE.VALUE,ETIQ_B.T_LOTE.VALUE,ETIQ_B.T_dtlan.VALUE,etiqbranca);
										 WIDTH 80 HEIGHT 27   ;                                 
                               TOOLTIP "Salvar Registro" ;
                             FLAT

	                  @ 230,250 BUTTON Btn_CETQ Of ETIQ_B	;
		                         CAPTION '&Cancelar'		;
                               ACTION ETIQ_B.RELEASE ;
			                      WIDTH 80 HEIGHT 27		;
                               TOOLTIP "Cancelar Operação"	;
			                    FLAT

	END WINDOW

	ETIQ_B.CENTER

	ETIQ_B.ACTIVATE 

RETURN

*------------------------------------------------------------------------------*
PROCEDURE Ativa_Etiqb()
*------------------------------------------------------------------------------*
   ETIQ_B.T_LOTE.VALUE := 0
   ETIQ_B.T_dtlan.VALUE := DATE()
   ETIQ_B.T_PECA.VALUE:=SPACE(10)
   ETIQ_B.T_NPECA.VALUE:=SPACE(20)
	ETIQ_B.T_CORES.VALUE:=SPACE(05)
   ETIQ_B.T_VALIDADE.VALUE:=SPACE(10) 
RETURN

**************************************************************************************
PROCEDURE IMPETIQargox(p_peca,pn_peca,p_cores,p_validade,p_lote,p_data) 
**************************************************************************************
#Include "minigui.ch"
#include "winprint.ch"
local cArquivo := "Etiqueta.TXT" 
Local cCtr := chr(2), cEol := Hb_Eol(), N_ETIQ:=1
Local cPrinter,BUSCAR
local nOption:=0

BUSCAR:=Upper ( AllTrim ( InputBox( 'N.Etiquetas :' , 'Informe' ) ) )

N_ETIQ:=VAL(BUSCAR)    

nOption:=MsgOptions("Opções?","Etiquetas","Users.Bmp" , {"&Comum","&CRQ"},2,20,60) 

cPrinter := GetPrinter()

 SET DEVI TO PRIN
 SET PRIN TO ( cArquivo )

 @ Prow()+0, PCol() Say cCtr + "e" + cEol  // habilita o sensor gap
 @ Prow()+0, PCol() Say cCtr + "m" + cEol  // unidade em milimitro
 @ Prow()+0, PCol() Say cCtr + "M0300" + cEol // fixa o comprimento em 30mm
 @ Prow()+0, PCol() Say cCtr + "L" + cEol  // entra em modo formato etiqueta
 @ Prow()+0, PCol() Say "H20"   + cEol  // fixa temperatura vai de: H10 a H20 recomendavel H16
 @ Prow()+0, PCol() Say "D11"   + cEol  // Padrao para pixels


///         Y=linha   X=coluna
///1900 004 0190      0010
if nOption == 2
   @ Prow()+0, PCol() Say "190000402500020" + "MaxiPaint - Revestimentos Especiais" + cEol
   @ Prow()+0, PCol() Say "190000402200020" + "_____________________________________________" + cEol 
endif

 @ Prow()+0, PCol() Say "190000402500020" + p_PECA + cEol // titulo em fonte pequena
 @ Prow()+0, PCol() Say "190000402500400" + "|"+pn_peca + cEol 

 @ Prow()+0, PCol() Say "190000402200020" + "_____________________________________________" + cEol 

 @ Prow()+0, PCol() Say "190000401700020" + p_cores + cEol 
 @ Prow()+0, PCol() Say "190000401700400" + "|Validade : "+ p_validade + cEol 

 @ Prow()+0, PCol() Say "190000401400020" + "_____________________________________________" + cEol 

 @ Prow()+0, PCol() Say "190000400900020" + "N.Lote" + cEol 
 @ Prow()+0, PCol() Say "190000400900400" + "|Data Fabricacao" + cEol 

 @ Prow()+0, PCol() Say "190000400300020" + p_lote + cEol 
 @ Prow()+0, PCol() Say "190000400300400" + "|"+dtoc(p_data) + cEol 

 if nOption == 2
   @ Prow()+0, PCol() Say "190000402200020" + "_____________________________________________" + cEol 
   @ Prow()+0, PCol() Say "190000402500020" + "C N P J :" + cEol
   @ Prow()+0, PCol() Say "190000402200020" + "_____________________________________________" + cEol 
   @ Prow()+0, PCol() Say "190000402500020" + "C R Q   :" + cEol
   @ Prow()+0, PCol() Say "190000402200020" + "_____________________________________________" + cEol 
 endif 

 @ Prow()+0, PCol() Say "E" + cEol // envia para a impressora
 @ Prow()+0, PCol() Say "Q" + cEol   // esvazia a memoria da impressora

 SET PRIN TO
 SET DEVI TO SCREEN

 cPrinter := GetDefaultPrinter() // pega impressora padrao
 for i:=1 to N_ETIQ
     PrintFileRaw( cPrinter, cArquivo, "Etiqueta Lote ->"+str(i,3) )
 next

 if etiqbranca
    ETIQ_B.RELEASE 
 endif
    
Return