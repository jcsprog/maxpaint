REQUEST DBFCDX
Function Main
LOCAL aDBStrut := {}
Local cArqTmp :="TMP"+STRZERO(SECONDS(),5,0)
Local cArqCSV :="Produtos.csv"
RDDSetDefault("DBFCDX")
cTexto := memoread("Produtos.csv")
cTexto := StrTran(cTexto,hb_eol(),";") //precisa disso p/ trocar hb_eol() por ';' final da linha
aText := ListToArray(cTexto,";") //Transforma qualquer texto em array...
nTReg := mlcount(cTexto,500) //Total de linhas p/ importar!!
//alert(str(nTReg))
alert(hb_valtoexp(aText))

/*  ver esta linha
cTexto := memoread("LivroDiario20150622.csv")
nTReg := mlcount(cTexto,500)

cTexto := StrTran(cTexto,hb_eol(),";")
aText := ListToArray(cTexto,";")

AADD(aDBStrut,{ "PlanID", "C", 5, 0 }) 
AADD(aDBStrut,{ "Usuario", "C", 1, 0 }) 
AADD(aDBStrut,{ "Cartorio", "C", 1, 0 }) 
AADD(aDBStrut,{ "DtLivro", "C", 8, 0 }) 
AADD(aDBStrut,{ "Dia", "C", 2, 0 }) 
AADD(aDBStrut,{ "Mes", "C", 2, 0 }) 
AADD(aDBStrut,{ "Ano", "C", 4, 0 }) 
AADD(aDBStrut,{ "Competen", "C", 10, 0 }) 
AADD(aDBStrut,{ "Quant", "C", 05, 0 }) 
AADD(aDBStrut,{ "Conta", "C", 10, 0 }) 
AADD(aDBStrut,{ "Referenc", "C", 20, 0 }) 
AADD(aDBStrut,{ "De_Para", "C", 20, 0 }) 
AADD(aDBStrut,{ "Ato_Histor", "C", 20, 0 }) 
AADD(aDBStrut,{ "Receita", "C", 10, 0 })     
AADD(aDBStrut,{ "Despesa", "C", 10, 0 })     
AADD(aDBStrut,{ "Despesa_d", "C", 10, 0 })     
AADD(aDBStrut,{ "Despesa_n", "C", 10, 0 })     
AADD(aDBStrut,{ "Tot_Receit", "C", 10, 0 })     
AADD(aDBStrut,{ "Tot_Despes", "C", 10, 0 })     
AADD(aDBStrut,{ "Resultado", "C", 10, 0 })     
*/
//DbDrop("mem:"+cArqTmp,,"DBFCDX") //Apaga DBF na memória se existir
//DbCreate("mem:"+cArqTmp,aDbStrut,'DBFCDX',.T.,"tmp") //Cria e abre DBF temporário
//Append from (cArqCSV) DELIMITED WITH ({,";"}) //Import
//tmp->(DbGoTop())

nText := len(aText)
y:=0
For N:=1 to nTReg
   tmp->(DbAppend())
   tab->PRODUTO  := aText[++y]
   tab->LABORATO := aText[++y]
   tab->GRUPO    := aText[++y]  
   tab->EAN      := aText[++y]    
   tab->ATIVO    := aText[++y]    
Next

browse()
cls

/*----------------------------------------------------------------------------
 Function: ListToArray
------------------------------------------------------------------------------
 Purpose:  Convert a delimited string to an array
------------------------------------------------------------------------------
 Parms:    (1) The string to be parsed (may contain several delimiters)
           (2) The delimiter character (defaults to ",")
           (3) An option string, indicating how each element is trimmed etc
                 N - No trimming of elements (by default, blanks are trimmed)
                 D - If string is empty, returns {""} i.e. an array with one
                     dummy element.  Default is to return an empty array {}.
------------------------------------------------------------------------------
 Returns:  An array, with each element containing a segment of the string
------------------------------------------------------------------------------
 Notes:    Examples of usage:
             aRes := ListToArray("AB, BC,CD ")    // Result: {"AB","BC","CD"}
             aRes := ListToArray("A, B, C ",,"N") // Result: {"A"," B"," C "}
             aRes := ListToArray("A; B; C",";")   // Result: {"A","B","C"}
             aRes := ListToArray("   ")           // Result: {}
             aRes := ListToArray("   ","D")       // Result: {""}
----------------------------------------------------------------------------*/

FUNCTION ListToArray ( cList, cDelimiter, cOptions )

local  nPos
local  aList := {}        // Define an empty array
local  cToken             // Token in the list
local  lMore := .T.
local  lTrim := .T.
local  nDelimLen

hb_DEFAULT ( @cDelimiter, "," )
nDelimLen := Len(cDelimiter)

if .not.Empty(cOptions)            // Deal with the Options (if any supplied)
   cOptions := Upper(cOptions)
   lTrim := .not.("N" $ cOptions)
   if Empty(cList) .and. .not.("D"$ cOptions)   // Unless D, return an empty
      lMore := .F.                              // array if string is blank.
   endif
endif

do while lMore
   lEof := .F.   
   nPos := at(cDelimiter, cList)

   if nPos > 0                                   // If found a delimiter
      cToken := substr(cList,1,nPos-1)           // Extract token
   else
      cToken := cList                            // Else use remainder of str
      lMore := .F.
   endif

   if lTrim
      cToken := AllTrim(cToken)                  // Trim unless asked not to
   endif

   aAdd ( aList, cToken )                        // Add a new element
   cList := substr(cList, nPos+nDelimLen)

enddo

RETURN aList       // End of function ListToArray 

/* 
                 @ 56,10 BROWSE Browse_1				;
			            WIDTH 420  				;
                     HEIGHT 500           ; 
			            HEADERS { 'Lote','Data','Massa','Cliente'} ;
			            WIDTHS { 080,100,100,130}			;
			            WORKAREA OPL ;
			            FIELDS { 'OPL->NLOTE' , 'OPL->DTLAN','OPL->CODMASSA','OPL->CODCLI'} ;
			            ON GOTFOCUS HMG_SetOrder( 1, .T. );
							ON CHANGE ActualizaOPL() ;
			            ON DBLCLICK ( ActivarOPL() , If ( ! OPL->(TREG()) , DesactivarOPL() , Nil ) ) ; 
			            COLUMNSORT {/*.T., .F., .F., .F.*/}
*/