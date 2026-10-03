#Include "minigui.ch"

PROCEDURE LSTPORCPED
		   
DEFINE WINDOW IMPR_ORC_PED;
	           AT 0,0 ;
 				  WIDTH 280	;
              HEIGHT 150 ;
				  font 'arial' size 11 ;
	           TITLE 'Impressão de Orcamentos';
				  ICON "TUTOR";                  
				  CHILD ;
		        ON MAXIMIZE ThisWindow.Center 
				  
				  @  20,020 LABEL nInicial ;
                        VALUE 'Nº Inicial ' ;
                        WIDTH 100    
						  
				  @  20,130 LABEL nFinal ;
                        VALUE 'Nº Final  ' ;
                        WIDTH 100    

              @  40,020 TEXTBOX Pinicial;
                        OF IMPR_ORC_PED ;
         		         WIDTH 80 ;
						      NUMERIC INPUTMASK '99999999' 
							
              @  40,130 TEXTBOX PFinal;
                        OF IMPR_ORC_PED ;
         		         WIDTH 80 ;
						      NUMERIC INPUTMASK '99999999' 

				  @ 80,020 BUTTON Btn_Achaped of IMPR_ORC_PED  ;
                       CAPTION '&Confirma'	     	;
                       ACTION Impr_ORC(IMPR_ORC_PED.PINICIAL.VALUE,IMPR_ORC_PED.PFINAL.VALUE)        ; 
					    	  WIDTH 80 HEIGHT 25		;
                       TOOLTIP "Busca Orcamento p/ Impressao" ;
	  		            FLAT
							 
				  @ 80,130 BUTTON Btn_CancelaBx Of IMPR_ORC_PED   ;
                       CAPTION '&Cancela'		;
                       ACTION IMPR_ORC_PED.RELEASE ;
							  WIDTH 80 HEIGHT 25		;
                       TOOLTIP "Retorna P/ Tela Principal" ;
	  		            FLAT
							 
	END WINDOW
	
	IMPR_ORC_PED.CENTER

	IMPR_ORC_PED.ACTIVATE

RETURN

*------------------------------------------------------------------------------*
PROCEDURE IMPORCPEDI(pinicial,pfinal)
*------------------------------------------------------------------------------*
local PLOTEI:=PINICIAL
local PLOTEF:=PFINAL
IF !OPL->(Dbseek(Str(PLOTEI,10)))
   MSGINFO ('Orcamento Não Encontrado->'+STRZERO(plotei,10),'Informação')
Else
   Impr_ORC(PLOTEI,PLOTEF)
Endif   
Return NIL

