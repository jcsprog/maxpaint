#include "hmg.ch"

MEMVAR aJobData

*------------------------------------------------------------------------------*
FUNCTION Main()
*------------------------------------------------------------------------------*
   local cEol := Hb_Eol()
   PRIVATE aJobData   // aJobData must be declared as Public or Private
  
   SELECT PRINTER DEFAULT ;
      ORIENTATION PRINTER_ORIENT_PORTRAIT ;
      PAPERSIZE PRINTER_PAPER_LETTER ;
      QUALITY  PRINTER_RES_MEDIUM

   c_peca :="00002" 
   c_nome :="MAXITHERMIC"
   c_npeca:="00002"
   c_cores:="BRANCO"
   c_valid:="24 meses"
   c_nlote:="N. Lote"
   c_ndata:="Data Fabricacao"
   c_lote :="856"
   c_data := "13/04/2016"

   for i:=1 to 10
   START PRINTDOC STOREJOBDATA aJobData

   START PRINTPAGE

   @ Prow()+1, PCol()+35 Print "Cheirinho" FONT "Arial" SIZE 12  // titulo em fonte pequena
   @ Prow()+8, PCol()+35 Print "Fragrancia :........................................" FONT "Arial" SIZE 12 
   @ Prow()+16, PCol()+35 Print "R$ 15,00 " FONT "Arial" SIZE 12 

   @ Prow()+24, PCol()+35 Print "Cheirinho" FONT "Arial" SIZE 12  // titulo em fonte pequena
   @ Prow()+32, PCol()+35 Print "Fragrancia :........................................" FONT "Arial" SIZE 12 
   @ Prow()+40, PCol()+35 Print "R$ 15,00 " FONT "Arial" SIZE 12 

   @ Prow()+48, PCol()+35 Print "Cheirinho" FONT "Arial" SIZE 12  // titulo em fonte pequena
   @ Prow()+56, PCol()+35 Print "Fragrancia :........................................" FONT "Arial" SIZE 12 
   @ Prow()+64, PCol()+35 Print "R$ 15,00 " FONT "Arial" SIZE 12 

   @ Prow()+1, PCol() print "E" + cEol // envia para a impressora
   @ Prow()+1, PCol() print "Q" + cEol   // esvazia a memoria da impressora

  END PRINTPAGE

END PRINTDOC
next
RETURN NIL

#define JOB_STATUS_PAUSED              0x00000001
#define JOB_STATUS_ERROR               0x00000002
#define JOB_STATUS_DELETING            0x00000004
#define JOB_STATUS_SPOOLING            0x00000008
#define JOB_STATUS_PRINTING            0x00000010
#define JOB_STATUS_OFFLINE             0x00000020
#define JOB_STATUS_PAPEROUT            0x00000040
#define JOB_STATUS_PRINTED             0x00000080
#define JOB_STATUS_DELETED             0x00000100
#define JOB_STATUS_BLOCKED_DEVQ        0x00000200
#define JOB_STATUS_USER_INTERVENTION   0x00000400
#define JOB_STATUS_RESTART             0x00000800
#define JOB_STATUS_COMPLETE            0x00001000


#define PRINTER_STATUS_OK                    0
#define PRINTER_STATUS_PAUSED                0x00000001
#define PRINTER_STATUS_ERROR                 0x00000002
#define PRINTER_STATUS_PENDING_DELETION      0x00000004
#define PRINTER_STATUS_PAPER_JAM             0x00000008
#define PRINTER_STATUS_PAPER_OUT             0x00000010
#define PRINTER_STATUS_MANUAL_FEED           0x00000020
#define PRINTER_STATUS_PAPER_PROBLEM         0x00000040
#define PRINTER_STATUS_OFFLINE               0x00000080
#define PRINTER_STATUS_IO_ACTIVE             0x00000100
#define PRINTER_STATUS_BUSY                  0x00000200
#define PRINTER_STATUS_PRINTING              0x00000400
#define PRINTER_STATUS_OUTPUT_BIN_FULL       0x00000800
#define PRINTER_STATUS_NOT_AVAILABLE         0x00001000
#define PRINTER_STATUS_WAITING               0x00002000
#define PRINTER_STATUS_PROCESSING            0x00004000
#define PRINTER_STATUS_INITIALIZING          0x00008000
#define PRINTER_STATUS_WARMING_UP            0x00010000
#define PRINTER_STATUS_TONER_LOW             0x00020000
#define PRINTER_STATUS_NO_TONER              0x00040000
#define PRINTER_STATUS_PAGE_PUNT             0x00080000
#define PRINTER_STATUS_USER_INTERVENTION     0x00100000
#define PRINTER_STATUS_OUT_OF_MEMORY         0x00200000
#define PRINTER_STATUS_DOOR_OPEN             0x00400000
#define PRINTER_STATUS_SERVER_UNKNOWN        0x00800000
#define PRINTER_STATUS_POWER_SAVE            0x01000000
