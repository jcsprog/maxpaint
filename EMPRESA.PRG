#Include "minigui.ch"
#define BLUE { 0, 0, 128 }

PROCEDURE EMP()
PARAMETERS LIBERA

LiberacaoCiec(LIBERA)
IF ADM=0 
   MSGINFO("Sem Liberação !!","Apenas Administrador")
   RETURN NIL
ENDIF

        i := 0
        cCodigo := emp->codigo
        cdescr  := emp->descr
        cEnd    := Emp->End
        cCep    := emp->Cep
        cCidade := emp->Cidade
        cuf     := emp->uf
        cTel    := emp->tel
        ccgc    := emp->cgc
        CORCA   := STR(EMP->ORCA,10)
        cEmail  := Emp->EMail
        cped    := str(emp->Nped,10)
        clote   := str(emp->Nfis,10)
        cCRQ    := emp->diretor
                                
        DEFINE WINDOW form_2 ;
	         	AT 0,0			;
	         	WIDTH 490		;
		         HEIGHT 350                   	;
		         TITLE 'Cadastro da Empresa'		;
            	CHILD ;
		         ON MAXIMIZE ThisWindow.Center

               @ 10,10 LABEL Label_Codigo ;
                       VALUE 'Codigo'    ;
                       WIDTH 60           
                                   
               @ 40,10 LABEL Label_Nome   ;
                       VALUE 'Descricao'   ;
                       WIDTH 60                     

               @ 70,10 LABEL Label_Endereco	;
         	           VALUE 'Endereço'		;
                       WIDTH 60                    

               @100,10 LABEL Label_Cidade ;
                       VALUE 'Cidade'              ;
                       WIDTH 60                   

	            @100,360 LABEL Label_Cep		;
		                 VALUE 'Cep'		;
                       WIDTH 29                         

               @130,10 LABEL Label_CGC ;
                       VALUE 'CNPJ'              ;
                       WIDTH 60                 

               @130,345 LABEL Label_ESTADO        ;
                        VALUE 'Estado'              ;
                        WIDTH 45                           

               @160,10 LABEL Label_Fone1	;
                       VALUE 'TeleFone'            ;
                       WIDTH 60                        

               @160,190 LABEL Label_ORCA	;
                       VALUE 'Orçamento'            ;
                       WIDTH 100                        

               @160,345 LABEL Label_PED ;
                        VALUE 'Pedido'    ;
                        WIDTH 45                           

               @190,10 LABEL Label_lote	;
      		       VALUE 'Lote'		;
                       WIDTH 60                 

               @190,190 LABEL Label_crq	;
                       VALUE 'CRQ'            ;
                       WIDTH 60            

               @220,10 LABEL Label_Email	;
      		           VALUE 'e-mail'		;
                       WIDTH 60                 

               @ 13,70 TEXTBOX T_Codigo		;
    		              WIDTH 40			;
                       VALUE ccodigo          ;
                       TOOLTIP 'Codigo do Contato'
                       ON ENTER Form_2.T_Nome.SetFocus

               @ 43,70 TEXTBOX T_Nome          ; 
                       OF Form_2         ;
                       WIDTH 400         ;
                       VALUE cdescr               ;
                       TOOLTIP 'Descrição' ;
                       MAXLENGTH 45        ;
                       UPPERCASE         ;
                       ON ENTER Form_2.T_Endereco.SetFocus
              
               @ 73,70 TEXTBOX T_Endereco	;
                       OF Form_2          ;
                       WIDTH 400		;
                       VALUE cEnd           ;
                       TOOLTIP 'Endereço ';
                       MAXLENGTH 40        ;
                       UPPERCASE ;
                       ON ENTER Form_2.T_Cidade.SetFocus

               @103,70 TEXTBOX T_CIDADE   ;
                       OF Form_2          ; 
                       WIDTH 250         ;
                       VALUE cCIDADE     ;
                       TOOLTIP 'Cidade';
                       MAXLENGTH 20    ;
                       ON ENTER Form_2.T_Cep.SetFocus

               @103,390 TEXTBOX T_Cep   ;
                       OF Form_2             ; 
                       WIDTH 80          ;
                       VALUE cCep                ;
                       TOOLTIP 'Cep '  ;
                       MAXLENGTH 10 ;
                       ON ENTER Form_2.T_CGC.SetFocus

              @133,70 TEXTBOX T_CGC ;
                      OF Form_2         ;
                      WIDTH 250         ;
                      VALUE cCGC         ;
                      TOOLTIP 'Inscrição do CNPJ'       ;
                      MAXLENGTH 18 ;
                      ON ENTER Form_2.T_Estado.SetFocus

              @133,390 TEXTBOX T_Estado	;
		                OF Form_2		;
		                WIDTH 30		;
                      VALUE cuf        ;
                      TOOLTIP 'Estado';
                      MAXLENGTH 02 ;
                      ON ENTER Form_2.T_Fone1.SetFocus

              @163,70 TEXTBOX T_Fone1   ;
                      OF Form_2 ;
                      WIDTH 110         ;
                      VALUE ctel              ;
                      TOOLTIP 'Telefone ';
                      MAXLENGTH "(99) 9999-9999" ;
                      ON ENTER Form_2.T_ORCA.SetFocus

              @163,260 TEXTBOX T_ORCA     ;
                      OF Form_2         ;
                      WIDTH 80          ;
                      VALUE cORCA       ;
                      TOOLTIP 'Controle de N. Orçamentos';
                      MAXLENGTH 10              ;
                      ON ENTER Form_2.T_PED.SetFocus

              @163,390 TEXTBOX T_PED     ;
                      OF Form_2         ;
                      WIDTH 80          ;
                      VALUE cPED       ;
                      TOOLTIP 'Controle de N. Pedidos ';
                      MAXLENGTH 10              ;
                      ON ENTER Form_2.T_LOTE.SetFocus

              @193,70 TEXTBOX T_LOTE     ;
                      OF Form_2         ;
                      WIDTH 80          ;
                      VALUE clote       ;      
                      TOOLTIP 'Controle de N. Lotes ';
                      MAXLENGTH 10              ;
                      ON ENTER Form_2.T_CRQ.SetFocus

              @193,260 TEXTBOX T_CRQ     ;
                        OF Form_2         ;
                        WIDTH 100          ;
                        VALUE cCRQ       ;
                        MAXLENGTH 20        ;
                        ON ENTER Form_2.T_EMAIL.SetFocus

              @220,70 TEXTBOX T_Email ;
                      OF Form_2		;
                      WIDTH 400		;
                      VALUE cEmail              ;
                      TOOLTIP 'E-mail do Contato';
                      MAXLENGTH 40		;
                      ON ENTER Form_2.Btn_Salvar.SetFocus

              @ 252,70 BUTTON Btn_Salvar Of Form_2	;
                      CAPTION '&Salvar'             ;
                      ACTION Salvar_Registro()            ;       
                      WIDTH 120 HEIGHT 27         ;
                      FONT "Arial" SIZE 09          ;
                      TOOLTIP "Salvar Registro" ;
                      FLAT

              @ 252,346  BUTTON Btn_Cancelar Of Form_2	;
 	                   CAPTION '&Cancelar'		;
  	         		    ACTION  Form_2.Release		;       
			             WIDTH 120 HEIGHT 27		;
		                TOOLTIP "Cancelar"	;
			             FLAT

        Form_2.T_Codigo.ENABLED :=.F.
        Form_2.T_Nome.ENABLED:=.F.

END WINDOW


Form_2.CENTER 
Form_2.ACTIVATE
Return 

Function Salvar_Registro()
  	  	      
        If EMP->(TREG())
           emp->codigo := Form_2.T_Codigo.Value
           emp->descr  := Form_2.T_Nome.Value
           emp->End    := Form_2.T_Endereco.Value
           Emp->ORCA   := val(Form_2.T_ORCA.Value)
           Emp->nped   := val(Form_2.T_ped.Value)
           Emp->nfis   := val(Form_2.T_lote.Value)
           emp->Cep    := Form_2.T_Cep.Value 
           emp->Cidade := Form_2.T_Cidade.Value 
           emp->uf     := Form_2.T_Estado.Value
           emp->tel    := Form_2.T_Fone1.Value
           emp->cgc    := Form_2.T_cgc.Value 
           emp->EMail  := Form_2.T_Email.Value 
           emp->diretor:= Form_2.T_CRQ.Value
           emp->(DBUnlock())
           MsgInfo( "Registo Alterado!!" )
        EndIf


	Form_2.Release 
        Return 






