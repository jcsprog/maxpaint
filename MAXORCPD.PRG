#Include "minigui.ch"
#include "winprint.ch"

FUNCTION ORCPED
PARAMETERS LIBERA

SET FONT TO 'MS Shell Dlg', 8
SET DECIMALS TO 3

LiberacaoCiec(LIBERA)

   Public Nuevo := .F.
	Public a_Massas:={}
	Public etiqbranca:=.f.
  
	a_Massas:={}
	ICM->(DBGOTOP())
	Do while ICM->(!EOF())
	   V_MASSA:=ICM->CODMA
	   aadd(a_Massas,icm->codma)
		Do while ICM->(!EOF()) .and. icm->codma = V_MASSA
		   ICM->(Dbskip())
		Enddo
   Enddo
 
	DEFINE WINDOW OPL_2;
	           AT 0,0 ;
 				  WIDTH GetDesktopWidth()-260;
              HEIGHT 630 ;
	           TITLE "Orçamento de Produção de Tinta"	;
				  ICON "TUTOR";
		        CHILD ;
              FONT 'Arial' SIZE 12 ;
		        ON MAXIMIZE ThisWindow.Center ;
		        ON INIT ( OPL->(dbsetorder(2)),OPL->(dbgotop()),DesactivarOPL(),ActualizaOPL()) 

		DEFINE TOOLBAR ToolBar_1 BUTTONSIZE 59,35 FLAT BORDER
		
			BUTTON PRIMERO 		;
				CAPTION '&Primero' 	;
				PICTURE 'primero'	;
				ACTION ( OPL->(dBGoTop()) , OPL_2.Browse_1.Value := OPL->(RecNo()) ) 

			BUTTON ANTERIOR 	;
				CAPTION '&Anterior' 	;
				PICTURE 'anterior'	;
				ACTION ( OPL->(dBSkip ( -1 )) , OPL_2.Browse_1.Value := OPL->(RecNo()) ) 

			BUTTON SIGUIENTE	;
				CAPTION '&Proximo' 	;
				PICTURE 'siguiente'	;
				ACTION ( OPL->(dBSkip (1)) , if ( Eof() , OPL->(DbGoBottom()) , Nil ) , OPL_2.Browse_1.Value := OPL->(RecNo()) ) 

			BUTTON ULTIMO 		;
				CAPTION '&Ultimo' 	;
				PICTURE 'ultimo'	;
				ACTION ( OPL->(dBGoBottom () ), OPL_2.Browse_1.Value := OPL->(RecNo()) )  SEPARATOR 

			BUTTON BUSCAR 		;
				CAPTION '&Pesquisa' 	;
				PICTURE 'buscar'	;
				ACTION BuscarOPL()

			BUTTON Nuevo 		;
				CAPTION '&Novo' 	;
				PICTURE 'nuevo'	;
				ACTION ( Nuevo := .T. , NuevoOPL() )

			BUTTON EDITAR 		;
				CAPTION 'A&lterar' 	;
				PICTURE 'editar'	;
				ACTION If ( OPL->(TREG() ) , ActivarOPL() , Nil )

			BUTTON ELIMINAR 	;
				CAPTION 'De&letar'	;
				PICTURE 'borrar'	;
				ACTION (EliminarOPL(),msginfo("Necess�rio Corre��o do N.Lote no Cadastro de Empresa!","Verifique"))

			BUTTON IMPRIMIR 	;
				CAPTION '&Imprimir'	;
				PICTURE 'imprimir2' ;
				ACTION Imp_Orc_Etiq() //Impr_orc(OPL->NLOTE,OPL->NLOTE) 
				
			BUTTON CERRAR 	;
				CAPTION '&Fecha'	;
				PICTURE 'FREE' ;
            ACTION OPL_2.release 

		END TOOLBAR

                @ 56,10 BROWSE Browse_1				;
			            WIDTH 420  				;
                     HEIGHT 500           ; 
			            HEADERS { 'Lote','Data','Massa','Cliente'} ;
			            WIDTHS { 080,100,100,130}			;
			            WORKAREA OPL ;
			            FIELDS { 'OPL->NLOTE' , 'OPL->DTLAN','OPL->CODMASSA','OPL->CODCLI'} ;
			           	ON CHANGE ActualizaOPL() ;
			            ON DBLCLICK ( ActivarOPL() , If ( ! OPL->(TREG()) , DesactivarOPL() , Nil ) )  
			            
                     @ 70,440 LABEL AF ;
                              VALUE 'Lote ' ;
                              WIDTH 80           ;
                              HEIGHT 30           

                     @ 70,660 LABEL BF ;
                              VALUE 'Data'  ;
                              WIDTH 60           ;
                              HEIGHT 30           

                     @ 100,440 LABEL CLT ;
                              VALUE 'Pe�a'  ;
                              WIDTH 60           ;
                              HEIGHT 30           
                              
                     @ 100,800 LABEL cor ;
                              VALUE 'Cores '  ;
                              WIDTH 60           ;
                              HEIGHT 30           

                     @130,440 LABEL DF ;
                              VALUE 'Cliente'  ;
                              WIDTH 60           ;
                              HEIGHT 30           

                     @130,660 LABEL CF ;
                              VALUE 'Massa'  ;
                              WIDTH 60           ;
                              HEIGHT 30           

                     @130,820 LABEL Bdd ;
                              VALUE 'Validade'  ;
                              WIDTH 80           ;
                              HEIGHT 30           

			    	      @ 070,500 TEXTBOX T_LOTE;
			    	               OF OPL_2 ;
   			                  WIDTH 150 
   			                  
	  				      @ 070,730 DATEPICKER T_dtlan	

   			    	   @ 100,500 COMBOBOX T_PECA;
   			                  ITEMSOURCE FAM->CODMAX+"-"+FAM->DESCMAX;	
					  		         VALUESOURCE FAM->CODMAX;
  							         WIDTH 280 HEIGHT 150 

   			    	   @ 100,860 COMBOBOX T_CORES;
   			                  ITEMSOURCE CADC->DESVED;	
					  		         VALUESOURCE CADC->CODVED;
  							         WIDTH 160 HEIGHT 120 

                    	@ 130,500 TEXTBOX T_CLIENTE                ;
                              WIDTH 150                         ;
                              TOOLTIP "Digite o Nome para PESQUISA" ;
                              FONT "MS SANS SERIF" SIZE 11 BOLD;
                              BACKCOLOR _YELLOW2 FONTCOLOR _VERDE  ;
                              MAXLENGTH 40              ;
                              ON GOTFOCUS This.BackColor:= _BLUE3  ;
                              ON LOSTFOCUS This.BackColor:=_YELLOW2;
                              ON CHANGE { || Pesquisa_cp("cli","FANTA",1,OPL_2.T_CLIENTE.VALUE,"BROWSE_C","OPL_2","{ CLI->FANTA,CLI->DESCR,CLI->CGC}") } 	
                                                            
                	   @ 160,440 Grid BROWSE_C ;
		            	         WIDTH 530 		;
                              HEIGHT 110      ; 
			                     HEADERS { 'Fantasia' , 'Razao Social','CGC/CPF'}	;
			                     WIDTHS { 130, 260, 140};
										on change (OPL_2.T_CLIENTE.VALUE:=PegaValorDaColuna( "BROWSE_C" , "OPL_2" , 1 ))

            		   @ 130,720 COMBOBOX T_CODMASSA ;
			                     WIDTH 90 ;
			                     ITEMS a_Massas ;
			                     VALUE 1 ;
			                     on CHANGE ( Verifica_cli()) 
			                     
			    	      @ 130,900 TEXTBOX T_VALIDADE;
			    	               OF OPL_2 ;
   			                  WIDTH 140 ;
   			                  ON ENTER (OPL_2.T_MATPRIMA.SETFOCUS)

                     @280,440 LABEL Cxx ;
                              VALUE 'Quantidade                        X    '  ;
                              WIDTH 400           ;
                              HEIGHT 30  ;
 					               FONT 'Arial' SIZE 14 

				   	   @ 280,550 TEXTBOX X_QTE;
						            OF OPL_2 ;
						            WIDTH 90    ;
                              numeric inputmask '999999.999';
										ON ENTER (Grava_campo_GRID()) 

				   	   @ 280,700 TEXTBOX X_UNIT;
						            OF OPL_2 ;
						            WIDTH 90    ;
                              numeric inputmask '999999.999' 
                              
                     @280,830 LABEL Ctl ;
                              VALUE '='  ;
                              WIDTH 400           ;
                              HEIGHT 30  ;
 					               FONT 'Arial' SIZE 14 

				   	   @ 280,880 TEXTBOX X_TLT;
						            OF OPL_2 ;
						            WIDTH 90    ;
                              numeric inputmask '999999.999' 

                     @ 310,440 GRID T_MATPRIMA ;
                       	      WIDTH 530 ;
		                  	   HEIGHT 200 ;
			                     HEADERS { 'Mat�ria Prima', 'Quantidade',' X ', 'Kilos','=','Total' } ;
			                     WIDTHS {120,100,60,100,40,100} ; 
						            ON DBLCLICK ( PEGA_GRID(OPL_2.T_MATPRIMA.VALUE) )

                     @ 530,770 LABEL CSUBTL ;
                              VALUE 'Sub.Total :'  ;
                              WIDTH 200          ;
                              HEIGHT 30  ;
 					               FONT 'Arial' SIZE 14 

				   	   @ 530,870 TEXTBOX X_SUBTL;
						            OF OPL_2 ;
						            WIDTH 100    ;
                              numeric inputmask '99999.999'

	                  @ 560,760 BUTTON Btn_SOPL Of OPL_2	;
                               CAPTION '&Salvar'             ;
                               ACTION (if(OPL_2.T_CLIENTE.value==space(20),Msginfo("Confirme Codigo do Cliente!","Antes de roceguir"),AceptarOPL())) ;
                               WIDTH 80 HEIGHT 27   ;                                 
                               TOOLTIP "Salvar Registro" ;
                             FLAT

	                  @ 560,890 BUTTON Btn_COPL Of OPL_2	;
		                         CAPTION '&Cancelar'		;
                               ACTION DesactivarOPL() ;
			                      WIDTH 80 HEIGHT 27		;
                               TOOLTIP "Cancelar Opera��o"	;
			                    FLAT

	END WINDOW

   OPL_2.Browse_1.value:=OPL->(dbgobottom(),recno())

	OPL_2.Center

	OPL_2.Activate

RETURN


*------------------------------------------------------------------------------*
PROCEDURE DesactivarOPL                                                
*------------------------------------------------------------------------------*
         OPL_2.Browse_1.Enabled:=.T.
         OPL_2.T_LOTE.Enabled :=.F.
         OPL_2.T_dtlan.Enabled:=.F.
         OPL_2.T_CLIENTE.Enabled:=.F.
         OPL_2.T_CODMASSA.Enabled:=.f.
         OPL_2.T_MATPRIMA.enabled:=.f.
         OPL_2.BROWSE_C.enabled:=.f.
         OPL_2.X_QTE.ENABLED:=.F.
         OPL_2.X_UNIT.ENABLED:=.F.
         OPL_2.X_TLT.ENABLED:=.F.
         OPL_2.T_PECA.ENABLED:=.F.
         OPL_2.T_VALIDADE.ENABLED:=.F.
         OPL_2.T_CORES.ENABLED:=.F.
         OPL_2.X_SUBTL.ENABLED:=.F.

         OPL_2.Btn_COPL.Enabled:=.F.
   	   OPL_2.Btn_SOPL.Enabled:=.F.
   	   OPL_2.ToolBar_1.Enabled:=.T.
      	DELETE ITEM ALL FROM BROWSE_C OF OPL_2
         DELETE ITEM ALL FROM BROWSE_C OF OPL_2
         OPL_2.Browse_1.SetFocus

RETURN
*------------------------------------------------------------------------------*
PROCEDURE ActivarOPL
*------------------------------------------------------------------------------*
IF CALTE=.T.
         OPL_2.Browse_1.Enabled:=.F.
         OPL_2.T_LOTE.Enabled :=.F.
         OPL_2.T_dtlan.Enabled:=.T.
         OPL_2.T_CLIENTE.Enabled:=.T.
         OPL_2.T_CODMASSA.Enabled:=.T.
         OPL_2.T_MATPRIMA.enabled:=.T.
         OPL_2.BROWSE_C.enabled:=.t.
         
         OPL_2.X_QTE.ENABLED:=.F.
         OPL_2.X_UNIT.ENABLED:=.F.
         OPL_2.X_TLT.ENABLED:=.F.

         OPL_2.T_PECA.ENABLED:=.T.
         OPL_2.T_VALIDADE.ENABLED:=.T.
         OPL_2.T_CORES.ENABLED:=.T.
         
	      OPL_2.ToolBar_1.Enabled:= .F.
         OPL_2.Btn_COPL.Enabled:= .T.
      	OPL_2.Btn_SOPL.Enabled:= .T.
ENDIF
RETURN
*------------------------------------------------------------------------------*
PROCEDURE CancelarOPL()
*------------------------------------------------------------------------------*
	DesactivarOPL()
	ActualizaOPL()
	OPL->(DBUNLOCK())
	Nuevo := .F.
RETURN
*------------------------------------------------------------------------------*
PROCEDURE AceptarOPL()
*------------------------------------------------------------------------------*
	DesactivarOPL()
	If Nuevo == .T.
		OPL->(DbAppend())
		Nuevo := .F.
		emp->(treg())
		emp->nfis:=VAL(OPL_2.T_LOTE.VALUE)
		emp->(dbunlock())
	EndIf

	*** GRAVACAO DO CABECARIO
	OPL->NLOTE     := VAL(OPL_2.T_LOTE.VALUE)   
   OPL->DTLAN     := OPL_2.T_dtlan.VALUE   
   OPL->CODMASSA  := A_MASSAS[OPL_2.T_CODMASSA.VALUE]
   OPL->CODCLI    := OPL_2.T_CLIENTE.VALUE  
   OPL->NPEDI     := 0   
   OPL->CPECA     := OPL_2.T_PECA.VALUE   
   OPL->CVALIDADE := OPL_2.T_VALIDADE.VALUE
   OPL->CCOR      := OPL_2.T_CORES.VALUE

   OPL->(DBUNLOCK())

   *** GRAVACAO DO ITENS
   IF OPI->(DBSEEK(OPL_2.T_LOTE.VALUE))   
		DO WHILE OPI->(!EOF()) .AND. OPI->NLOTE = VAL(OPL_2.T_LOTE.VALUE)
		   OPI->(TREG())
		   OPI->(DBDELETE())
		   OPI->(DBUNLOCK())
		   OPI->(DBSKIP())
		ENDDO
	ENDIF

   FOR I:=1 TO OPL_2.T_MATPRIMA.ItemCount // INFORMAR QTE ITENS NA GRID
       OPI->(DBAPPEND())
       OPL_2.T_MATPRIMA.VALUE:=I  
       OPI->NLOTE    := VAL(OPL_2.T_LOTE.VALUE)  
       OPI->DTLAN    := OPL_2.T_dtlan.VALUE  
       OPI->CODMASSA := A_MASSAS[OPL_2.T_CODMASSA.VALUE]
       OPI->CODMT    := PegaValorDaColuna( "T_MATPRIMA" , "OPL_2" , 1 )  
       OPI->CODCLI   := OPL_2.T_CLIENTE.VALUE 
       OPI->NPEDI    := 0  
       OPI->QTELAN   := VAL(PegaValorDaColuna( "T_MATPRIMA" , "OPL_2" , 2 )) 
       OPI->VRUNIT   := VAL(PegaValorDaColuna( "T_MATPRIMA" , "OPL_2" , 4 )) 
       OPI->(DBUNLOCK())
	NEXT
   
	***** GRAVACAO DE OBSERVACOES VINDAS DE TAB
	IF OPO->(DBSEEK(OPL_2.T_LOTE.VALUE))
	   OPO->(TREG())
	   OPO->(DBDELETE())
	   OPO->(DBUNLOCK())
	   OPO->(DBSKIP())
	ENDIF
	
   if OMT->(DbSeek(OPL_2.T_CODMASSA.VALUE))
      OPO->(DBAPPEND())
      OPO->NLOTE  := VAL(OPL_2.T_LOTE.VALUE)
      OPO->OBSMT1 := OMT->OBSMT1
      OPO->OBSMT2 := OMT->OBSMT2
      OPO->OBSMT3 := OMT->OBSMT3
      OPO->OBSMT4 := OMT->OBSMT4
      OPO->(DBUNLOCK())
   ENDIF  

	MSGINFO("Dados Gravados !")
  
	OPL_2.Browse_1.Refresh 
	OPL->(DBUNLOCK())
RETURN

*------------------------------------------------------------------------------*
PROCEDURE ActualizaOPL()
*------------------------------------------------------------------------------*
local r_soma:=0.00
local r_sbto:=0.00
local r_recno:=OPL->(RECNO())

   OPL_2.X_SUBTL.value:=0.000
   //OPL->(DbSeek(STR(OPL->NLOTE,10)))
   OPL->(Dbgoto(r_recno))
	OPL_2.T_LOTE.VALUE :=STR(OPL->NLOTE,10)
	OPL_2.T_dtlan.VALUE :=OPL->DTLAN 
   OPL_2.T_CLIENTE.VALUE:=OPL->CODCLI
   OPL_2.T_CODMASSA.VALUE:=ASCAN(a_Massas,OPL->CODMASSA)
   OPL_2.T_PECA.VALUE:=IIF(FAM->(DBSEEK(OPL->CPECA)),FAM->(RECNO()),OPL->CPECA)   
   OPL_2.T_VALIDADE.VALUE:=OPL->CVALIDADE 
   OPL_2.T_CORES.VALUE:=IF(CADC->(DBSEEK(OPL->CCOR)),CADC->(RECNO()),0)      
   DELETE ITEM ALL FROM T_MATPRIMA OF OPL_2
   OPI->(dbseek(STR(OPL->NLOTE,10)))
   do while OPI->(!eof()) .AND. OPI->NLOTE=VAL(OPL_2.T_LOTE.VALUE)
      ADD ITEM { OPI->CODMT,STR(OPI->QTELAN,12,3),' X ' ,STR(OPI->VRUNIT,12,3),' = ',STR(OPI->QTELAN*OPI->VRUNIT,12,3)} TO T_MATPRIMA OF OPL_2 
      r_soma:=(OPI->QTELAN*OPI->VRUNIT)
      r_sbto+=r_soma
      OPI->(dbskip())
   enddo
   OPL_2.X_SUBTL.VALUE  :=ROUND(r_sbto,1)
   OPL_2.Browse_1.Value :=r_recno
   OPL_2.Browse_1.refresh
	OPL_2.Browse_1.setfocus

Return
    	   
*------------------------------------------------------------------------------*
Procedure BuscarOPL
*------------------------------------------------------------------------------*
Local Buscar
local n_pesq:=0

  Buscar:=Upper ( AllTrim ( InputBox( 'Informe N.Lote' , 'Pesquisa' ) ) )
  n_pesq:=val(Buscar)
  If OPL->(DbSeek(STR(n_pesq,10)))
 	  OPL_2.Browse_1.Value := OPL->(RecNo())
  Else
     MsgExclamation('Nao encontrado registro')
	EndIf
Return
*------------------------------------------------------------------------------*
PROCEDURE NuevoOPL()
*------------------------------------------------------------------------------*
IF CINCL=.T.
   OPL_2.T_LOTE.VALUE := str(EMP->NFIS+1,10)
   OPL_2.T_dtlan.VALUE := DATE()
   OPL_2.T_CLIENTE.VALUE:=SPACE(20)
	OPL_2.T_CODMASSA.VALUE:=1
	OPL_2.T_VALIDADE.VALUE:=space(20)
	OPL_2.T_PECA.VALUE:=1
	OPL_2.X_SUBTL.VALUE:=0.000
	DELETE ITEM ALL FROM BROWSE_C OF OPL_2
   DELETE ITEM ALL FROM T_MATPRIMA OF OPL_2
   ActivarOPL()
ENDIF
RETURN

*------------------------------------------------------------------------------*
Procedure EliminarOPL
*------------------------------------------------------------------------------*
IF CEXCL=.T.
	If MsgYesNo ( "Confirma Exclus�o ?","Aten��o")
		If OPL->(TREG())
			OPL->(dbdelete())
			OPL->(DBUNLOCK())
			OPL->(dbgotop()) 
			OPL_2.Browse_1.Value := OPL->(RecNo())
			ActualizaOPL()
		EndIf
	EndIf
ENDIF
Return

*------------------------------------------------------------------------------*
Procedure criamateriaprime
*------------------------------------------------------------------------------*
p_massa:=a_massas[OPL_2.T_CODMASSA.VALUE]+REPLICAT(SPACE(01),10-LEN(a_massas[OPL_2.T_CODMASSA.VALUE]))
DELETE ITEM ALL FROM T_MATPRIMA OF OPL_2
icm->(dbseek(p_Massa))
do while icm->(!eof()) .AND. ICM->CODMA = p_massa
   ADD ITEM { ICM->CODMT,"0.000",' X ' ,STR(ICM->CODQTE,12,3),' = ',STR(0.000*ICM->CODQTE,12,3)} TO T_MATPRIMA OF OPL_2           
   ICM->(dbskip())       
enddo
OPL_2.T_MATPRIMA.refresh
OPL_2.T_VALIDADE.SETFOCUS
return nil	

*------------------------------------------------------------------------------*
Procedure PEGA_GRID(POSICAO)
*------------------------------------------------------------------------------*
LOCAL N_PGRID:=POSICAO
OPL_2.X_QTE.ENABLED:=.T.
OPL_2.X_QTE.VALUE:=VAL(PegaValorDaColuna( "T_MATPRIMA" , "OPL_2" , 2 ))
OPL_2.X_UNIT.VALUE:=VAL(PegaValorDaColuna( "T_MATPRIMA" , "OPL_2" , 4 ))
OPL_2.X_QTE.SETFOCUS
return 	

*------------------------------------------------------------------------------*
Procedure REPROCESSO_SUBTL(C_calc)
*------------------------------------------------------------------------------*
LOCAL ANT_P_T_MATPRIMA:=OPL_2.T_MATPRIMA.VALUE
LOCAL R_SUBM:=0.00                                             
LOCAL R_SOMA:=0.000
FOR I:=1 TO OPL_2.T_MATPRIMA.ItemCount // INFORMAR QTE ITENS NA GRID
    OPL_2.T_MATPRIMA.VALUE:=I
    R_SUBM:=val(PegaValorDaColuna( "T_MATPRIMA" , "OPL_2" , 2 )) * val(PegaValorDaColuna( "T_MATPRIMA" , "OPL_2" , 4 ))
    R_SOMA+=R_SUBM
NEXT
OPL_2.X_SUBTL.VALUE:=ROUND(R_SOMA,1)
return 	


*------------------------------------------------------------------------------*
Procedure Grava_campo_GRID(POSICAO)
*------------------------------------------------------------------------------*
LOCAL POSICAO_1:=0 
LOCAL POSICAO_2:=0
LOCAL POSICAO_4:=0
LOCAL CTR_POS := 0

FOR I:=1 TO OPL_2.T_MATPRIMA.ItemCount // INFORMAR QTE ITENS NA GRID
    OPL_2.T_MATPRIMA.VALUE:=I
    CTR_POS := OPL_2.T_MATPRIMA.VALUE
    OPL_2.X_UNIT.VALUE:=VAL(PegaValorDaColuna( "T_MATPRIMA" , "OPL_2" , 4 ))
    POSICAO_1:= PegaValorDaColuna( "T_MATPRIMA" , "OPL_2" , 1 )
    POSICAO_2:= OPL_2.X_QTE.VALUE
    POSICAO_4:= VAL(PegaValorDaColuna( "T_MATPRIMA" , "OPL_2" , 4 ))
    OPL_2.X_TLT.value:=(OPL_2.X_QTE.VALUE * OPL_2.X_UNIT.VALUE)
    OPL_2.T_MATPRIMA.ITEM (CTR_POS):={ POSICAO_1,STR(POSICAO_2,12,3),' X ' ,STR(POSICAO_4,12,3),' = ',STR(POSICAO_2*POSICAO_4,12,3)}
NEXT

REPROCESSO_SUBTL(.t.)	

OPL_2.T_MATPRIMA.REFRESH
OPL_2.T_MATPRIMA.SETFOCUS
return 	

procedure Verifica_cli()
if len(alltrim(OPL_2.T_CLIENTE.VALUE))>0 .and. len(alltrim(OPL_2.T_CLIENTE.VALUE))<3
   msginfo("Necess�rio Cliente Correto!","Verifique")
elseif len(alltrim(OPL_2.T_CLIENTE.VALUE))>=3
	criamateriaprime()
endif
return                               

*------------------------------------------------------------------------------*
Procedure Imp_Orc_Etiq
*------------------------------------------------------------------------------*
local nOption:=0
nOption:=MsgOptions("Veja as Op��es de Impress�o ?","Ficha de Produ��o!","Users.Bmp" , {"&Ficha","&Etiquetas","&Cancela"},3,20,60) 
DO CASE
   CASE nOption==4
        return nil
   CASE nOption==1
        Impr_ORC(OPL->NLOTE,OPL->NLOTE)
   CASE nOption==2
        E_DESC :=IIF(FAM->(DBSEEK(OPL->CPECA)),FAM->DESCMAX,OPL->CPECA)
        E_CORE :=IIF(CADC->(DBSEEK(OPL->CCOR)),CADC->DESVED,OPL->CCOR) 
        E_LOTE :=STRZERO(OPL->NLOTE,10)
        IMPETIQargox(OPL->CPECA,E_DESC,E_CORE,OPL->CVALIDADE,STRZERO(OPL->NLOTE,10),OPL->DTLAN,etiqbranca)
ENDCASE	   
return nil

*------------------------------------------------------------------------------*
Procedure Impr_ORC(LOTEI,LOTEF) 
*------------------------------------------------------------------------------*
Local dirimp:=GetCurrentFolder(), PAG, LH
LOCAL R_Total:=0.000
LOCAL T_Total:=0.000
LOCAL TituloImp:="Lote_"+alltrim(str(lotei,10))
LOCAL C_CODMA:=SPACE(05)
LOCAL F_TLMate:=0.000
LOCAL F_Qtefor:=0.000
LOCAL F_Total:=0.000
Init PRINTSYS

Request HB_CODEPAGE_PT850
prys:="maxipaint.bmp"

PAG:=0
LH:=0 
if !OPL->(dbsetorder(1),(dbseek(str(LOTEI,10))))
   Msginfo("N.Lote:"+alltrim(str(lotei,10))+" - Encontrado !","Verifique")
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

IF OPL->(DBSEEK(STR(LOTEI,10)))	
   Do WHILE OPL->(!EOF()) .AND. OPL->NLOTE <= LOTEF
		LOTE:=STR(OPL->NLOTE,10)
		MASSA:=OPL->CODMASSA
		Cod_Max:=substr(OPL->CPECA,1,10)
		
      R_Total:=0.000
      T_Total:=0.000
      C_CODMA:=SPACE(05)
      n_qtegeral:=0
      T_Kilos:=0
      Nl_Real:=0
      
      F_TLMate:=0.000
      F_Qtefor:=0.000
      F_Total:=0.000
      		
		PAG=0
		
      Start page

      IF LH > 260 .OR. PAG=0
         IF PAG=0
            select font "ft18"
            @ 05,040 SAY EMP->DESCR TO PRINT
            @ 13,080 SAY "Ficha de Produ��o" TO PRINT //@ 13,070 SAY "Revestimentos Especiais" TO PRINT 
            
            select font "ft12"
            @ 21,010 SAY "Lote     :"+LOTE+"   Data :"+dtoc(OPL->DTLAN)+"   Pe�a :"+OPL->CPECA TO PRINT
            @ 29,010 SAY "Validade :"+OPL->CVALIDADE+" Cor :"+OPL->CCOR+"-"+if(CADC->(Dbseek(OPL->CCOR)),CADC->DESVED,"") to print
            @ 37,010 SAY "Cliente  :"+OPL->CODCLI to print
            @ 45,010 SAY "Massa    :"+OPL->CODMASSA to print
            select font "ft10"                          
            LH:=50
            @ LH,08,LH+5,35 RECTANGLE
            @ LH,35,LH+5,55 RECTANGLE 
            @ LH,55,LH+5,60 RECTANGLE 
            @ LH,60,LH+5,80 RECTANGLE 
            @ LH,80,LH+5,85 RECTANGLE 
            @ LH,85,LH+5,110 RECTANGLE 
            @ LH,110,LH+5,130 RECTANGLE 
            @ LH,130,LH+5,155 RECTANGLE 
            @ LH,09 SAY "Materia Prima" TO PRINT
            @ LH,36 SAY "Quantidade" TO PRINT
            @ LH,56 SAY " X " TO PRINT
            @ LH,67 SAY "Kilos" TO PRINT
            @ LH,81 SAY " = "  TO PRINT
            @ LH,89 SAY "Sub. Total" TO PRINT
            @ LH,111 SAY "R$ Unitario" TO PRINT
            @ LH,131 SAY "R$ Total" TO PRINT
            LH+=5
          Else
			   lh+=35
		    Endif
          PAG++
		ENDIF	 
		
      IF OPI->(DBSEEK(LOTE))	
         Do WHILE OPI->(!EOF()) .AND. OPI->NLOTE == VAL(LOTE)
         	n_qtegeral:=OPI->QTELAN

            @ LH,08,LH+5,35 RECTANGLE
            @ LH,35,LH+5,55 RECTANGLE 
            @ LH,55,LH+5,60 RECTANGLE 
            @ LH,60,LH+5,80 RECTANGLE 
            @ LH,80,LH+5,85 RECTANGLE 
            @ LH,85,LH+5,110 RECTANGLE 
            @ LH,110,LH+5,130 RECTANGLE 
            @ LH,130,LH+5,155 RECTANGLE 

            @ LH,09 SAY OPI->CODMT TO PRINT
	         @ LH,36 SAY STR(OPI->QTELAN,12,3) TO PRINT
	         @ LH,56 SAY " X " TO PRINT
	         @ LH,68 SAY STR(OPI->VRUNIT,09,3) TO PRINT
	         @ LH,81 SAY " = "  TO PRINT
	         @ LH,95 SAY STR(OPI->QTELAN*OPI->VRUNIT,12,3) TO PRINT
	         
            C_CODMA:=OPI->CODMT+REPLICAT(SPACE(01),10-LEN(OPI->CODMT))

	         IF FAM->(DBSEEK(C_CODMA))
	            @ LH,113 SAY STR(FAM->VLCOMP,12,2) TO PRINT
	            @ LH,138 SAY STR((OPI->QTELAN*OPI->VRUNIT)*FAM->VLCOMP,12,2) TO PRINT
	            T_Total+=((OPI->QTELAN*OPI->VRUNIT)*FAM->VLCOMP)
	         ENDIF
				   
            lh+=5
            R_Total+=(OPI->QTELAN*OPI->VRUNIT)
            T_Kilos+=OPI->VRUNIT
            OPI->(DBSKIP())
	      EndDo 
	      R_Total:=ROUND(R_TOTAL,1) // ARREDONDAMENTO
         @ LH,60,LH+5,80 RECTANGLE 
         @ LH,85,LH+5,110 RECTANGLE 
         @ LH,110,LH+5,130 RECTANGLE 
         @ LH,130,LH+5,155 RECTANGLE 
         @ LH,67 SAY "Sb.Total" TO PRINT
	      @ LH,93 SAY STR(R_Total,12,3) TO PRINT
         @ LH,111 SAY " Total" TO PRINT
	      @ LH,138 SAY STR(T_Total,12,2) TO PRINT
         lh+=7
		ENDIF
      
      C_CODMA:=MASSA+REPLICAT(SPACE(01),10-LEN(MASSA))
      IF icm->(DBSEEK(C_CODMA))   
         lh+=2
         select font "ft14"
         @ lh,010 SAY "Tabela de Composi��o" TO PRINT   
         lh+=7
			select font "ft10"                          
         @ LH,08,LH+5,35 RECTANGLE
         @ LH,35,LH+5,59 RECTANGLE 
         @ LH,59,LH+5,75 RECTANGLE
         @ LH,75,LH+5,100 RECTANGLE
         @ LH,09 SAY "Materia Prima" TO PRINT
         @ LH,36 SAY "Quantidade" TO PRINT
         @ LH,55 SAY "X" TO PRINT
         @ LH,60 SAY "( % )" TO PRINT
         @ LH,74 SAY "Total" TO PRINT
         lh+=5

         Nl_Real:=T_Kilos
			@ LH,08,LH+5,35 RECTANGLE
         @ LH,35,LH+5,54 RECTANGLE 
         @ LH,59,LH+5,75 RECTANGLE
         @ LH,75,LH+5,100 RECTANGLE
         @ LH,09 SAY Cod_Max TO PRINT
         @ LH,38 SAY STR(n_qtegeral,12,3) TO PRINT
         @ LH,55 SAY "X" TO PRINT
         @ LH,59 SAY transform(Nl_Real,"@E 99,999.999") TO PRINT
         @ LH,83 SAY transform(T_Total,"@e 999,999.99") TO PRINT
         F_Total+=T_Total
         F_TLMate+=Nl_Real
         F_Qtefor+=n_qtegeral         
         lh+=5

         IF AGR->(DBSEEK(Cod_Max))
            DO WHILE AGR->(!EOF()) .AND. agr->CODMAXAGR = Cod_Max // Cod_Max
               if fam->(dbseek(AGR->AGREGADO))
                  if FAM->QTECOMP <= 0
                     Nl_Real:=FAM->VLCOMP
                  else
                     Nl_Real:=(FAM->VLCOMP/FAM->QTECOMP)
                  endif
					endif
						   
               //Nl_Real:=if(fam->(dbseek(AGR->AGREGADO)),if(FAM->QTECOMP<0,FAM->VLCOMP,(FAM->VLCOMP/FAM->QTECOMP)),0.00)
				   @ LH,08,LH+5,35 RECTANGLE
               @ LH,35,LH+5,54 RECTANGLE 
               @ LH,59,LH+5,75 RECTANGLE
               @ LH,75,LH+5,100 RECTANGLE
               @ LH,09 SAY AGR->AGREGADO TO PRINT
               @ LH,38 SAY STR(n_qtegeral,12,3) TO PRINT
               @ LH,55 SAY "X" TO PRINT
               @ LH,58 SAY transform(Nl_Real,"@E 999,999.999") TO PRINT
               @ LH,82 SAY transform(n_qtegeral*Nl_Real,"@e 999,999.99") TO PRINT

               F_Total+=(n_qtegeral*Nl_Real)
               F_TLMate+=Nl_Real
               F_Qtefor+=n_qtegeral
               lh+=5
               AGR->(DBSKIP())
            ENDDO
         endif   
			if F_TLMate>0
				@ LH,08,LH+5,35 RECTANGLE
            @ LH,35,LH+5,54 RECTANGLE 
            @ LH,59,LH+5,75 RECTANGLE
            @ LH,75,LH+5,100 RECTANGLE
            @ LH,09 SAY "T o t a l " to PRINT
            @ LH,38 SAY "========" to print 
            @ LH,55 SAY "X" TO PRINT
            @ LH,59 SAY "========" to print 
            @ LH,82 SAY transform(F_Total,"@e 999,999.99") TO PRINT
            lh+=5
         endif			   
      ENDIF

      IF OMT->(DbSeek(OPL->CODMASSA))
         lh+=3
         select font "ft14"
         @ lh,040 SAY "Observa�oes da Produ��o" TO PRINT
         lh+=7
         select font "ft10"                          
         do while omt->(!eof()) .and. omt->OCODMA = OPL->CODMASSA 
            @ LH,08,LH+5,200 RECTANGLE
            @ LH,10 SAY OMT->OBSMT1 TO PRINT
		      LH+=5   
		      if !empty(OMT->OBSMT2)
    		      @ LH,08,LH+5,200 RECTANGLE
               @ LH,10 SAY OMT->OBSMT2 TO PRINT
            endif   
            if !empty(OMT->OBSMT3)   
		         LH+=5
		         @ LH,08,LH+5,200 RECTANGLE
               @ LH,10 SAY OMT->OBSMT3 TO PRINT
            endif   
            if !empty(OMT->OBSMT4)   
		         LH+=5
		         @ LH,08,LH+5,200 RECTANGLE
               @ LH,10 SAY OMT->OBSMT4 TO PRINT
               LH+=5
            endif
            omt->(dbskip())
         enddo
      ENDIF

      END page
      exit
   ENDDO  
ENDIF   
END doc
Release printsys
SetCurrentFolder(dirimp)
Return NIL