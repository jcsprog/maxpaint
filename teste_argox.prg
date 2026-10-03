cPrinter := GetPrinter()
   
SELECT PRINTER cPrinter PAPERSIZE PRINTER_PAPER_USER PAPERLENGTH 36 PAPERWIDTH 105 PREVIEW

START PRINTDOC
 
      xDt   := Frm_Etiq_Canc.DtP_Canc.Value
      xPos  := 1
      xLn   := 1 //5 //vLin[xPos] //nLinIni
      xCol  := 10 //5
      cCart := ALLTRIM(SETCART->NOM_CART) + "-" + ALLTRIM(SETCART->CIDADE) + "/RJ"
      cEnd  := ALLTRIM(SETCART->ENDERECO) + "-" + ALLTRIM(SETCART->COMPL)
    
      WHILE ! EOF() .AND. DTPAGTO == Frm_Etiq_Canc.Dtp_Canc.Value
        
         IF "CANCELADO" $ TITULOS->SITUACAO
             START PRINTPAGE

                 @ 7,xCol PRINT PADC(cCart,100) FONT "Times New Roman" SIZE 8 BOLD
                 xLn += 2 

                 @ 10,xCol PRINT PADC(cEnd,100) FONT "Times New Roman" SIZE 8 BOLD
                 xLn += 2.5
      
                 @ 13,xCol PRINT "Certifico e dou fé, atendendo a requerimento do interessado, e tendo em vista a quitação" FONT "Times New Roman" SIZE 7.5
                 @ 16,xCol PRINT "do título, os quais ficam arquivadas em pasta própria, que fica CANCELADO o protesto" FONT "Times New Roman" SIZE 7.5
              
               @ 19,xCol PRINT "lavrado no Livro " + ALLTRIM(TITULOS->LIVRO) + ", Fls " + ALLTRIM(STR(TITULOS->FOLHAS,5,0)) + ;
                                " em " + DTOC(TITULOS->DTPAGTO) + ", nos termos do Artigo 26 da Lei" FONT "Times New Roman" SIZE 7.5
              
           @ 22,xCol PRINT "nº 9492/97. Barra Mansa, "  + STRZERO(DAY(xDt),2,0) + " de " + CMES2(MONTH(xDt)) + " de " + ;
                               STR(YEAR(xDt),4,0) + "."FONT "Times New Roman" SIZE 8
            
               @ 25,xCol PRINT "Selo Eletrônico: " + TITULOS->SELOCAN + " " + TITULOS->ALE_CAN FONT "Times New Roman" SIZE 8 BOLD
      
               xLn += 3
               xPos++
            END PRINTPAGE
         ENDIF
  
         DBSKIP()  
      END  
END PRINTDOC
