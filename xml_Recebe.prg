***********************
Function LerDANFE(oDlg)
***********************
*
*
LOCAL cStr, oNFe, cDirXML, cArq, oDlgDanfe, cTitulo := "Importar NFe", lOk := .F., lDuplicatas:=.T.
LOCAL cUF:="", dEmi:=CToD(""), dSaiEnt := CToD(""), cEAN
PREPARE FONT oFont NAME "Verdana" WIDTH 0 HEIGHT -18

INIT DIALOG oDlgDanfe CLIPPER TITLE cTitulo Font oFont AT 0,0 SIZE 380,150 STYLE DS_CENTER + WS_SYSMENU ;
On Exit {||.t. }

dRecebido := date()

@ 005,035 Say "Recebimento:" size 130,20
@ 140,030 get oRecebido Var dRecebido size 100,30

@ 005,090 get CheckBox lDuplicatas  Caption  'Lan�ar duplicatas.' size 250,20

@ 270,020 Button oBt Caption 'Cancelar'   Size 100,30  ON CLICK {||hwg_EndDialog()}
@ 270,070 Button oBt Caption 'Confirmar'  Size 100,30  ON CLICK {||lOk:=.t.,hwg_EndDialog()}

oDlgDanfe:Activate()

IF !lOk
   Return .t.
ENDIF

If en->(dbseek('DIR'+'DANFE'))
   cDirDanfe := alltrim(en->dados)
Else
   cDirDanfe := 'c:\maxpaint\danfe\'
EndIf

   cArq := HWG_SelectFile( "Arquivos XML ( *.xml )", "*.xml", cDirDanfe )

   cStr := hb_MemoRead( cArq )

   DirChange( cPasta )

   IF Empty( cStr )
      hwg_Msginfo("Não achou o arquivo XML")
      RETURN
   ENDIF

   oXML := TXMLDocument():New( cStr, HBXML_STYLE_NOESCAPE )
   IF oXML:nError != HBXML_ERROR_NONE
      hwg_Msgstop( "xml com problema " + Str( oXML:nError ) )
      RETURN
   ENDIF

   oNFe := oXML:findfirst( "infNFe" )
   IF oNFe == NIL
      hwg_Msgstop( "TAG infNFe não localizada." )
      RETURN
   ENDIF

      oIde := oXML:findfirst( "ide" )
      IF oIde == NIL
         hwg_Msgstop( "TAG ide não localizada." )
         RETURN
      ENDIF

      oIterator := TXmlIterator():New( oIde )

      DO WHILE .T.

         oCurrent := oIterator:Next()
         IF oCurrent == NIL
            //hwg_Msginfo("Fim da Leitura da oIDE ")
            Exit
         ELSE
            //hwg_Msginfo("Tag Atual: " + oCurrent:cName) //? "current tag : " + oCurrent:cName
            IF oCurrent:cName == "cUF"
               cUF := oCurrent:cData
            ELSEIF oCurrent:cName == "nNF"
               cNF := oCurrent:cData
            ELSEIF oCurrent:cName == "serie"
               cSerie := oCurrent:cData
            ELSEIF oCurrent:cName $ "dEmi dhEmi"
               dEmi := hb_stod( strtran(oCurrent:cData,"-","") )
            //ELSEIF oCurrent:cName == "dSaiEnt"
            //   dSaiEnt := hb_stod( strtran(oCurrent:cData,"-","") )
            ENDIF
         ENDIF

      ENDDO

      If Empty(cNF)
          hwg_Msgstop("DANFE com problema."+hb_eol()+"Numero da NFe, n�o informado.")
          Return
      EndIf
      If Empty(dEmi)
          hwg_Msgstop("DANFE com problema."+hb_eol()+"DATA da emissão, não informada.")
          Return
      EndIf

      oEmit := oXML:findfirst( "emit" )
      IF oEmit == NIL
         hwg_Msgstop( "TAG emit não localizada." )
         RETURN
      ENDIF

      oIterator := TXmlIterator():New( oEmit )
      cCNPJ   := ""
      cFone   := ""      
      dSaiEnt := date()

      DO WHILE .T.

         oCurrent := oIterator:Next()
         IF oCurrent == NIL
            //hwg_Msginfo("Fim da Leitura da oEmit ")
            EXIT
         ELSE
            //hwg_Msginfo("Tag Atual: " + oCurrent:cName) //? "current tag : " + oCurrent:cName
            IF oCurrent:cName == "CNPJ"
               cCNPJ := oCurrent:cData
            ELSEIF oCurrent:cName == "xNome"
               cNome := oCurrent:cData
            ELSEIF oCurrent:cName == "xLgr"
               xLgr := oCurrent:cData
            ELSEIF oCurrent:cName == "nro"
               cNRO := oCurrent:cData
            ELSEIF oCurrent:cName == "xBairro"
               xBairro := oCurrent:cData
            ELSEIF oCurrent:cName == "xMun"
               xMun := oCurrent:cData
            ELSEIF oCurrent:cName == "UF"
               cUF := oCurrent:cData
            ELSEIF oCurrent:cName == "CEP"
               cCEP := oCurrent:cData
            ELSEIF oCurrent:cName == "fone"
               cFone := oCurrent:cData
            ELSEIF oCurrent:cName == "IE"
               cIE := oCurrent:cData
            ENDIF
         ENDIF

      ENDDO
      
      fo->(OrdSetFocus(3)) //CNPJ      
      If fo->(DbSeek(cCNPJ))
         cCodFor := fo->cod_fornec
         er->(ordSetFocus(1))
         IF er->( dbSeek(strzero(val(cNF),9)+cCodFor+dtos(dRecebido)) )
            hwg_MsgStop("NFe já cadastrada !")
            RETURN .F.
         ENDIF
      ELSE
         cCodFor := ""
      ENDIF
      
      er->(ordSetFocus(6)) //dtos(es_datarec)
        
      If empty(cCNPJ)
         cCNPJ := "SEM CNPJ"
      EndIf
      //Novo fornecedor
      If Empty(cCodFor)
          fo->(OrdSetFocus(1))
          fo->(DbGoBottom()) 
          nPos   := hb_At( SubStr(fo->cod_fornec,1,1), "ABCDEFGHIJKLMNOPQRSTUVWXYZ" )
          cLetra := SubStr("ABCDEFGHIJKLMNOPQRSTUVWXYZ",nPos+1,1)
          IF SubStr(fo->cod_fornec,2,3) == "999" 
             cCodFor := cLetra + "001"   
          Else
             cCodFor := cLetra + strzero(val(substr(fo->cod_fornec,2,3))+1,3)
          Endif
             
          incluir('fo')
          fo->cod_fornec := cCodFor
          fo->cgc        := cCNPJ
          fo->fornecedor := cNome
          fo->endereco   := alltrim(xLgr) + ", " + cNRO
          fo->bairro     := xBairro
          fo->cidade     := xMun
          fo->uf         := cUF
          fo->cep        := cCEP
          fo->telefone   := cFone
          fo->insc_estad := cIE
      EndIF

         Incluir('er')
         er->cod_fornec := cCodFor
         er->fornecedor := cNome
         er->cnpj       := cCNPJ
         er->cfop       := ""
         er->es_numero  := strzero(val(cNF),9)
         er->es_modelo  := 55
         er->es_serie   := cSerie
         er->es_subseri := ""
         er->es_dataemi := dEmi
         er->es_datarec := dRecebido //dSaiEnt
         er->es_situaca :=  "N"
         er->es_codfisc := "1"
         er->loja       := "001"
         er->es_emitent := "T"
         er->DifNF      := 0
         er->es_emitent := 'T'
         
      oDet := oXML:findfirst( "det" )
      IF oDet == NIL
         hwg_Msgstop( "TAG det não localizada." )
         RETURN
      ENDIF
      nItem := 0
      cd->(ordSetFocus(1))
      cd->(OrdScope(0,NIL))
      cd->(OrdScope(1,NIL))

      Do While .T.

         oIterator := TXmlIterator():New( oDet )
         nIPI := nPIS := nCOFINS := 0
         cEAN := ""
         DO WHILE .T.

            oCurrent := oIterator:Next()

            IF oCurrent == NIL
               EXIT
            ELSE

               IF oCurrent:cName == "cProd"
                  cProd := oCurrent:cData
               ELSEIF oCurrent:cName == "xProd"
                  xProd := AllTrim(charone(" ",oCurrent:cData))
               ELSEIF oCurrent:cName == "NCM"
                  cNCM := oCurrent:cData
               ELSEIF oCurrent:cName == "CFOP"
                  cCFOP := oCurrent:cData
               ELSEIF oCurrent:cName == "uCom"
                  uCom := oCurrent:cData
               ELSEIF oCurrent:cName == "qCom"
                  qCom := val(oCurrent:cData)
               ELSEIF oCurrent:cName == "vUnTrib"
                  nUnTrib := val(oCurrent:cData)
               ELSEIF oCurrent:cName == "pIPI"
                  nIPI := val(oCurrent:cData)
               ELSEIF oCurrent:cName == "pCOFINS"
                  nCOFINS := val(oCurrent:cData)
               ELSEIF oCurrent:cName == "pPIS"
                  nPIS := val(oCurrent:cData)                  
               ELSEIF oCurrent:cName == "vDesc"
                  nDesconto := val(oCurrent:cData)
               ELSEIF oCurrent:cName == "cEAN"
                   IF hb_IsChar(oCurrent:cData)
                      cEAN := AllTrim(oCurrent:cData)
                   ENDIF
               ENDIF
            ENDIF

         ENDDO
         //Verifica se a mercadoria j� foi comprada deste fornecedor
         cCodMerc := ""
         nMargem  := nImpFed :=0
         IF cd->(DbSeek(cCNPJ+cProd))
            IF !empty(cd->codigosis)
               cCodMerc := cd->codigosis
               If eq->(DbSeek(cCodMerc))
                  nMargem := eq->margem
                  nImpFed := eq->imposto
                  xProd   := eq->mercadoria
               EndIf
            ENDIF
            If Empty(cd->descricao)
               TravaRegistro('cd')
               cd->descricao := xProd
            EndIf
         ELSE
            incluir('cd')
            cd->cnpj      := cCNPJ
            cd->codigonfe := cProd
            cd->descricao := xProd
         ENDIF

         IF cCFOP == "5405"
            cCFOP := "1403"
         ELSEIF cCFOP == "6405"
            cCFOP := "2403"
         ELSEIF cCFOP == "5403"
            cCFOP := "1403"
         ELSEIF cCFOP == "6403"
            cCFOP := "2403"
         ELSEIF cCFOP == "5102"
            cCFOP := "1102"
         ELSEIF cCFOP == "6102"
            cCFOP := "2102"
         ELSEIF cCFOP == "5905"
            cCFOP := "1905"
         ELSEIF cCFOP == "6905"
            cCFOP := "2905"
         ELSEIF cCFOP == "5101"
            cCFOP := "1102"
         ELSEIF cCFOP == "6101"
            cCFOP := "2102"
         ENDIF

         nItem ++
         incluir('et')
         et->nf_entrada := strzero(val(cNF),9)
         et->cod_fornec := cCodFor
         et->data       := dRecebido //dSaiEnt
         et->cfop       := cCFOP
         et->cprod      := cProd
         et->cod_mercad := cCodMerc
         et->mercadoria := xProd
         et->quantidade := qCom
         et->item       := nItem
         et->valor_unit := nUnTrib
         et->ncm        := cNCM
         et->descfreace := nDesconto
         et->icms_credi := 0
         et->ipi        := nIPI
         et->pis        := nPIS
         et->cofins     := nCOFINS
         et->frete      := 0
         et->lucro      := nMargem
         et->gastos     := 0
         et->i_f        := nImpFed
         et->icms_debit := 0
         et->comissao   := 0
         et->local      := 0
         et->etiquetas  := qCom
         et->ean        := cEAN
         
         If !nc->(DbSeek(cNCM))
            incluir('nc')
            nc->cod_ncm := cNCM
         EndIf

         oDet := oXML:findnext( "det" )
         If oDet == NIL
            exit
         EndIf

      EndDo
      NetFlush('nc')
      NetFlush('et')
      NetFlush('cd')
      cd->(ordSetFocus(1))
      cd->(OrdScope(0,cCNPJ))
      cd->(OrdScope(1,cCNPJ))

      oTotal := oXML:findfirst( "total" )
      IF oTotal == NIL
         hwg_Msgstop( "TAG total n�o localizada." )
         RETURN
      ENDIF

        //Store 0.00 to nNF, nBC, nICMS, nST, nProd, nFrete, nSeg, nDesc, nIsento, nIPI, nOutro
        oIterator := TXmlIterator():New( oTotal )

        DO WHILE .T.

            oCurrent := oIterator:Next()

            IF oCurrent == NIL
               EXIT
            ELSE

               IF oCurrent:cName == "vBC"
                  nBC := val(oCurrent:cData)
               ELSEIF oCurrent:cName == "vICMS"
                  nICMS := val(oCurrent:cData)
               ELSEIF oCurrent:cName == "vST"
                  nST := val(oCurrent:cData)
               ELSEIF oCurrent:cName == "vProd"
                  nProd := val(oCurrent:cData)
               ELSEIF oCurrent:cName == "vFrete"
                  nFrete := val(oCurrent:cData)
               ELSEIF oCurrent:cName == "vSeg"
                  nSeg := val(oCurrent:cData)
               ELSEIF oCurrent:cName == "vDesc"
                  nDesc := val(oCurrent:cData)
               ELSEIF oCurrent:cName == "vII"
                  nIsento := val(oCurrent:cData)
               ELSEIF oCurrent:cName == "vIPI"
                  nIPI := val(oCurrent:cData)
               ELSEIF oCurrent:cName == "vPIS"
                  nPIS := val(oCurrent:cData)
               ELSEIF oCurrent:cName == "vCOFINS"
                  nCOFINS := val(oCurrent:cData)
               ELSEIF oCurrent:cName == "vOutro"
                  nOutDespAce := val(oCurrent:cData)
               ELSEIF oCurrent:cName == "vNF"
                  nNF := val(oCurrent:cData)

               ENDIF
            ENDIF

         ENDDO
             //hwg_Msginfo(str(nOutDespAce))
              Travaregistro('er')
              er->es_valorto := nNF
              er->es_baseicm := nBC
              er->es_valicms := nICMS
              er->es_isenta  := nISento
              er->es_outras  := nST //nOutro
              er->desconto   := nDesc
              er->es_totprod := nProd
              er->es_frete   := nFrete
              er->es_ipi     := nIPI
              er->es_aliquot := 0 //nST
              er->outdespace := nOutDespAce
              er->cofins     := nCOFINS
              er->pis        := nPIS 
              NetFlush('er')

        //Contas a pagar 
        /*
        oFat := oXML:findfirst( "fat" )
        IF oFat == NIL
           hwg_Msgstop( "TAG fat n�o localizada." )
        Else
            oIterator := TXmlIterator():New( oFat )

            DO WHILE .T.

               oCurrent := oIterator:Next()
               IF oCurrent == NIL
                  EXIT
               Else
                  IF oCurrent:cName == "nFat"
                     cFat := val(oCurrent:cData)
                  EndIf
               EndIf

            ENDDO

        ENDIF
        */
   If lDuplicatas
      oDup := oXML:findfirst( "dup" )
      IF oDup == NIL
           hwg_Msgstop( "TAG dup n�o localizada." + hb_eol() + "N�o houve lan�amentos no contas a pagar." )
      Else
         Do While .t.

            oIterator := TXmlIterator():New( oDup )

               DO WHILE .T.

                  oCurrent := oIterator:Next()

                  IF oCurrent == NIL
                     EXIT
                  ELSE
                     IF oCurrent:cName == "nDup"
                        cDup := oCurrent:cData
                     ELSEIF oCurrent:cName == "dVenc"
                        dVenc := hb_stod( strtran(oCurrent:cData,"-","") )
                     ELSEIF oCurrent:cName == "vDup"
                        nDup := val(oCurrent:cData)
                     ENDIF

                  ENDIF
               EndDo

               incluir('pa')
               pa->nf_compra  := strzero(val(cNF),9)
               pa->cod_fornec := cCodFor
               pa->fornecedor := cNome
               pa->duplicata  := cDup
               pa->data_vcto  := dVenc
               pa->valor      := nDup
               pa->data_emis  := dEmi
               pa->loja       := "001"

               oDup := oXML:findnext( "dup" )
               If oDup == NIL
                  exit
               EndIf

         EndDo

         NetFlush('pa')

      EndIf
   EndIf

  oXML := NIL

et->(ordSetFocus(1))
et->(OrdScope(0,er->es_numero+er->cod_fornec+dtos(er->es_datarec) ))
et->(OrdScope(1,er->es_numero+er->cod_fornec+dtos(er->es_datarec) ))
et->(DbGoTop())

pa->(ordSetFocus(5))
pa->(OrdScope(0,er->cod_fornec) )
pa->(OrdScope(1,er->cod_fornec) )
pa->(DbGoBottom())

oDlg:oBrw:Refresh()
oDlg:oTab:oBrPd:Refresh()
oDlg:oTab:oBrwDP:Refresh()

IF hwg_MsgYesNo("DANFE Importado. Deseja Apagar o XML ?")
    FErase( cArq )
ENDIF
   
RETURN .t.
