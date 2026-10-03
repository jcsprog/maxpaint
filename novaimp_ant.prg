#include "hmg.ch"

MEMVAR aJobData

*------------------------------------------------------------------------------*
FUNCTION Main()
*------------------------------------------------------------------------------*
   PRIVATE aJobData   // aJobData must be declared as Public or Private
  
   DEFINE WINDOW Win_1 ;
      AT 0, 0 ;
      WIDTH 400 ;
      HEIGHT 400 ;
      TITLE 'MiniPrint Library Test' ;
      MAIN

      DEFINE MAIN MENU
         DEFINE POPUP 'File'
            MENUITEM 'Default Printer' ACTION PrintTest1()

         END POPUP
      END MENU

     // @ 10, 10 LABEL Label_1 VALUE "" WIDTH 500 HEIGHT 100
     // @ 120, 10 EDITBOX EditBox_1 VALUE "" WIDTH 700 HEIGHT 500 FONT "Courier New" SIZE 10

      //DEFINE TIMER Timer_1 INTERVAL 250 ACTION DisplayJobInfo()

   END WINDOW

   MAXIMIZE WINDOW Win_1

   ACTIVATE WINDOW Win_1

RETURN NIL

*------------------------------------------------------------------------------*
PROCEDURE PrintTest1()
*------------------------------------------------------------------------------*

   SELECT PRINTER DEFAULT ;
      ORIENTATION PRINTER_ORIENT_PORTRAIT ;
      PAPERSIZE PRINTER_PAPER_LETTER ;
      QUALITY  PRINTER_RES_MEDIUM

   PrintDoc()

RETURN

*------------------------------------------------------------------------------*
PROCEDURE PrintDoc
*------------------------------------------------------------------------------*
 
   local cEol := Hb_Eol()

   START PRINTDOC STOREJOBDATA aJobData

        START PRINTPAGE

      @ prow()+1,pcol()+25 PRINT IMAGE "max.jpg" ;
         WIDTH 50 ;
         HEIGHT 30

      @ Prow()+0, PCol() print "E" + cEol // envia para a impressora
      @ Prow()+0, PCol() print "Q" + cEol   // esvazia a memoria da impressora
     
      END PRINTPAGE

   END PRINTDOC

RETURN

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
