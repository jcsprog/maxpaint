/*
 Compilar usando: Hbmk2 exemplo.prg -lhbwin
*/
#Include "minigui.ch"
#include "winprint.ch"


Function Main()

 cProduto := "NESCAU 2.0 LATA 400 G"
 cUnitario := "UN" // UN, KG, LT, FD, CX, etc...
 nPreco := 4.80
 cCodigo := "7891000053508" // GTIN valido ou nao sera impresso

 c_peca :="00002" 
 c_nome :="MAXITHERMIC"
 c_npeca:="00002"
 c_cores:="BRANCO"
 c_valid:="24 meses"
 c_nlote:="N. Lote"
 c_ndata:="Data Fabricacao"
 c_lote :="856"
 c_data := "13/04/2016"


 cPrinter := GetPrinter()
   
SELECT PRINTER cPrinter PAPERSIZE PRINTER_PAPER_USER PAPERLENGTH 36 PAPERWIDTH 105 PREVIEW

START PRINTDOC
 
START PRINTPAGE

@ Prow()+0, PCol() Print "190000402200020" + "_____________________________________________" 

 @ Prow()++, PCol() Print "190000402500020" + c_peca 
 @ Prow()++, PCol() Print "190000402500400" + "|"+c_nome 

 @ Prow()++, PCol() Print "190000402200020" + "_____________________________________________" 

 @ Prow()++, PCol() Print "190000401700020" + c_cores 
 @ Prow()++, PCol() Print "190000401700400" + "|Validade : "+ c_valid 

 @ Prow()++, PCol() Print "190000401400020" + "_____________________________________________" 

 @ Prow()++, PCol() Print "190000400900020" + "N.Lote" 
 @ Prow()++, PCol() Print "190000400900400" + "|Data Fabricacao"  

 @ Prow()++, PCol() Print "190000400300020" + c_lote 
 @ Prow()++, PCol() Print "190000400300400" + "|"+c_data 

  @ Prow()++, PCol() Print "190000401400020" + "_____________________________________________" 

 @ Prow()++, PCol() Print "190000400900020" + "N.Lote"  
 @ Prow()++, PCol() Print "190000402500020" + c_peca 
 @ Prow()++, PCol() Print "190000402500400" + "|"+c_nome  

 END PRINTPAGE
 
END PRINTDOC

Return