
	.SEGMENT "0"


	.FUNCT	BEG-PARDON
	PRINTR	"[I beg your pardon?]"


	.FUNCT	UNKNOWN-WORD,RLEXV,X
	CALL2	NUMBER?,RLEXV >X
	ZERO?	X /?CCL3
	RETURN	X
?CCL3:	PRINTI	"[I don't know the word """
	SUB	RLEXV,P-LEXV
	DIV	STACK,2
	PUT	OOPS-TABLE,O-PTR,STACK
	ICALL2	WORD-PRINT,RLEXV
	PRINTI	".""]"
	CRLF	
	ICALL2	COUNT-ERRORS,1
	THROW	PARSER-RESULT-DEAD,PARSE-SENTENCE-ACTIVATION
	RTRUE	


	.FUNCT	WORD-PRINT,PTR,LEN,OFFS
	ASSIGNED?	'LEN /?CND1
	GETB	PTR,2 >LEN
?CND1:	ASSIGNED?	'OFFS /?PRG5
	GETB	PTR,3 >OFFS
?PRG5:	DLESS?	'LEN,0 /TRUE
	GETB	P-INBUF,OFFS
	PRINTC	STACK
	INC	'OFFS
	JUMP	?PRG5


	.FUNCT	PRINT-VOCAB-WORD,WD,TMP,?TMP1
	ADD	LONG-WORD-TABLE,2 >?TMP1
	GET	LONG-WORD-TABLE,0
	DIV	STACK,2
	INTBL?	WD,?TMP1,STACK,132 >TMP \?CCL3
	GET	TMP,1
	PRINT	STACK
	RTRUE	
?CCL3:	EQUAL?	WD,W?INT.NUM,W?INT.TIM /FALSE
	PRINTB	WD
	RTRUE	


	.FUNCT	MOBY-FIND?,SEARCH
	BTST	SEARCH,128 /TRUE
	EQUAL?	WINNER,EXECUTIONER /TRUE
	RFALSE	


	.FUNCT	NP-SAVE,ROBJ,TMP
	COPYT	SEARCH-RES,ORPHAN-SR,20
	COPYT	ROBJ,ORPHAN-NP,20
	GET	ROBJ,5 >TMP
	ZERO?	TMP /?CCL3
	GET	TMP,2
	COPYT	STACK,ORPHAN-NP2,10
	PUT	ORPHAN-NP,5,ORPHAN-NP2
	JUMP	?CND1
?CCL3:	GET	ROBJ,4 >TMP
	ZERO?	TMP /?CCL5
	COPYT	TMP,ORPHAN-NP2,20
	PUT	ORPHAN-NP,4,ORPHAN-NP2
	JUMP	?CND1
?CCL5:	GET	ROBJ,6 >TMP
	ZERO?	TMP /?CND1
	COPYT	TMP,ORPHAN-NP2,20
	PUT	ORPHAN-NP,6,ORPHAN-NP2
?CND1:	GET	ROBJ,1 >TMP
	ZERO?	TMP /?CCL9
	COPYT	TMP,ORPHAN-ADJS,18
	PUT	ORPHAN-NP,1,ORPHAN-ADJS
	GET	TMP,2 >TMP
	GRTR?	0,TMP /?CCL12
	GRTR?	TMP,LAST-OBJECT /?CCL12
	PUT	ORPHAN-ADJS,2,TMP
	RETURN	ORPHAN-NP
?CCL12:	COPYT	TMP,ORPHAN-NP2,20
	PUT	ORPHAN-ADJS,2,ORPHAN-NP2
	RETURN	ORPHAN-NP
?CCL9:	PUT	ORPHAN-NP,1,0
	RETURN	ORPHAN-NP


	.FUNCT	PARSER-ERROR,STR,CLASS,OTHER,OTHER2,RP
	ZERO?	CURRENT-REDUCTION /FALSE
	GET	CURRENT-REDUCTION,2 >RP
	GRTR?	ERROR-PRIORITY,RP /?CCL3
	EQUAL?	ERROR-PRIORITY,RP \FALSE
	EQUAL?	CLASS,PARSER-ERROR-NOUND /?PRD9
	GET	ERROR-ARGS,1
	EQUAL?	STACK,PARSER-ERROR-NOUND /?CCL3
?PRD9:	EQUAL?	CLASS,PARSER-ERROR-ORPH-NP /?CCL3
	EQUAL?	CLASS,PARSER-ERROR-NOOBJ,PARSER-ERROR-ORPH-S \FALSE
	GET	ERROR-ARGS,1
	EQUAL?	STACK,PARSER-ERROR-NOUND \FALSE
?CCL3:	SET	'ERROR-PRIORITY,RP
	SET	'ERROR-STRING,STR
	ZERO?	CLASS /?CCL17
	PUT	ERROR-ARGS,0,3
	PUT	ERROR-ARGS,1,CLASS
	PUT	ERROR-ARGS,2,OTHER
	PUT	ERROR-ARGS,3,OTHER2
	CALL2	PMEM?,OTHER
	ZERO?	STACK /FALSE
	GETB	OTHER,1
	EQUAL?	STACK,4 \?CND20
	GET	OTHER,4 >OTHER
?CND20:	GETB	OTHER,1
	EQUAL?	STACK,2 \FALSE
	CALL2	NP-SAVE,OTHER
	PUT	ERROR-ARGS,2,STACK
	RFALSE	
?CCL17:	PUT	ERROR-ARGS,0,0
	RFALSE	


	.FUNCT	TELL-THE,OBJ,TMP
	EQUAL?	OBJ,PLAYER \?CCL3
	PRINTI	"you"
	RTRUE	
?CCL3:	CALL2	GET-OWNER,OBJ >TMP
	ZERO?	TMP /?CCL6
	EQUAL?	TMP,PLAYER \?CCL9
	PRINTI	"your "
	JUMP	?CND4
?CCL9:	EQUAL?	TMP,OBJ /?CND4
	ICALL2	TELL-THE,TMP
	PRINTI	"'s "
	JUMP	?CND4
?CCL6:	FSET?	OBJ,NARTICLEBIT /?CND4
	PRINTI	"the "
?CND4:	CALL2	DPRINT,OBJ
	RSTACK	


	.FUNCT	TELL-CTHE,OBJ,TMP
	EQUAL?	OBJ,PLAYER \?CCL3
	PRINTI	"You"
	RTRUE	
?CCL3:	CALL2	GET-OWNER,OBJ >TMP
	ZERO?	TMP /?CCL6
	EQUAL?	TMP,PLAYER \?CCL9
	PRINTI	"Your "
	JUMP	?CND4
?CCL9:	EQUAL?	TMP,OBJ /?CND4
	ICALL2	TELL-CTHE,TMP
	PRINTI	"'s "
	JUMP	?CND4
?CCL6:	FSET?	OBJ,NARTICLEBIT /?CND4
	PRINTI	"The "
?CND4:	CALL2	DPRINT,OBJ
	RSTACK	


	.FUNCT	WORD-TYPE?,WD,TYP,TYP2,GC,WCN
	GETB	WD,8
	BTST	STACK,128 /?CCL3
	GETB	WD,8 >WCN
	JUMP	?CND1
?CCL3:	GETB	WD,8
	BAND	STACK,127
	SHIFT	STACK,7 >WCN
?CND1:	ZERO?	WCN \?CND4
	GET	WD,3 >WD
	GETB	WD,8
	BTST	STACK,128 /?CCL8
	GETB	WD,8 >WCN
	JUMP	?CND4
?CCL8:	GETB	WD,8
	BAND	STACK,127
	SHIFT	STACK,7 >WCN
?CND4:	ASSIGNED?	'TYP2 \?CND9
	CALL	WORD-TYPE?,WD,TYP2
	ZERO?	STACK /?CND9
	RETURN	WD
?CND9:	EQUAL?	TYP,P-COMMA-CODE \?CCL15
	EQUAL?	WD,W?COMMA,W?AND \?CCL15
	RETURN	WD
?CCL15:	EQUAL?	TYP,P-ADJ-CODE \?CCL19
	SET	'GC,4
	JUMP	?CND13
?CCL19:	EQUAL?	TYP,P-DIR-CODE \?CCL21
	SET	'GC,8
	JUMP	?CND13
?CCL21:	EQUAL?	TYP,P-EOI-CODE \?CCL23
	SET	'GC,8192
	JUMP	?CND13
?CCL23:	EQUAL?	TYP,P-NOUN-CODE \?CCL25
	SET	'GC,2
	JUMP	?CND13
?CCL25:	EQUAL?	TYP,P-PARTICLE-CODE \?CCL27
	SET	'GC,16
	JUMP	?CND13
?CCL27:	EQUAL?	TYP,P-PREP-CODE \?CCL29
	SET	'GC,32
	JUMP	?CND13
?CCL29:	EQUAL?	TYP,P-QUANT-CODE \?CCL31
	SET	'GC,2048
	JUMP	?CND13
?CCL31:	EQUAL?	TYP,P-QW1-CODE \?CCL33
	SET	'GC,0
	JUMP	?CND13
?CCL33:	EQUAL?	TYP,P-VERB-CODE \?CND13
	SET	'GC,1
?CND13:	BAND	WCN,GC
	ZERO?	STACK /FALSE
	RETURN	WD


	.FUNCT	IGNORE-FIRST-WORD,WD1,WD2,NW
	ASSIGNED?	'WD2 /?CND1
	SET	'WD2,1
?CND1:	GET	TLEXV,0
	EQUAL?	STACK,WD1,WD2 \FALSE
	LESS?	1,P-LEN \FALSE
	GET	TLEXV,P-LEXELEN >NW
	ZERO?	NW /FALSE
	GETB	NW,8
	BTST	STACK,128 /?CCL12
	GETB	NW,8
	JUMP	?CND10
?CCL12:	GETB	NW,8
	BAND	STACK,127
	SHIFT	STACK,7
?CND10:	BTST	STACK,1 \FALSE
	ADD	TLEXV,4 >TLEXV
	DEC	'P-LEN
	RTRUE	


	.FUNCT	FIX-TITLE-ABBRS,LEN,PTR,N,L
	GETB	P-LEXV,P-LEXWORDS >LEN
	SET	'PTR,P-LEXV+2
	SET	'L,LEN
?PRG1:	DLESS?	'L,0 /TRUE
	GET	PTR,0
	EQUAL?	STACK,W?ST,W?D,W?J /?PRD8
	GET	PTR,0
	EQUAL?	STACK,W?A \?CND3
?PRD8:	GET	PTR,2
	EQUAL?	W?PERIOD,STACK \?CND3
	GET	PTR,4
	CALL2	CAPITAL-NOUN?,STACK
	ZERO?	STACK /?CND3
	PUT	PTR,2,W?NO.WORD
?CND3:	ADD	PTR,4 >PTR
	JUMP	?PRG1


	.FUNCT	FIX-QUOTATIONS,X,QFLAG,LEN,PTR
	SET	'QFLAG,FALSE-VALUE
	GETB	P-LEXV,P-LEXWORDS >LEN
	SET	'PTR,P-LEXV+2
?PRG1:	ZERO?	LEN /TRUE
	INTBL?	W?QUOTE,PTR,LEN,132 >PTR \TRUE
	ZERO?	QFLAG \?CCL10
	SET	'QFLAG,TRUE-VALUE
	SUB	PTR,P-LEXV
	DIV	STACK,2
	ADD	2,STACK >X
	ICALL	MAKE-ROOM-FOR-TOKENS,1,P-LEXV,X
	PUT	P-LEXV,X,W?NO.WORD
	JUMP	?CND8
?CCL10:	SET	'QFLAG,FALSE-VALUE
?CND8:	ADD	PTR,4 >PTR
	SUB	PTR,P-LEXV
	DIV	STACK,4 >X
	GETB	P-LEXV,P-LEXWORDS
	SUB	STACK,X >LEN
	JUMP	?PRG1


	.FUNCT	PARSER,OWINNER,LEN,N,PTR,VAL,?PR-LEN,CNT,?TMP1
	SET	'PTR,P-LEXSTART
	ICALL1	PMEM-RESET
	SET	'ERROR-PRIORITY,255
	SET	'ERROR-STRING,FALSE-VALUE
	SET	'OWINNER,WINNER
	ZERO?	M-PTR /?CCL4
	COPYT	M-LEXV,P-LEXV,LEXV-LENGTH-BYTES
	COPYT	M-INBUF,P-INBUF,61
	SET	'P-LEN,M-LEN
	ZERO?	VERBOSITY /?CND5
	EQUAL?	PLAYER,WINNER \?CND5
	CRLF	
?CND5:	SET	'TLEXV,M-PTR
	SET	'M-PTR,FALSE-VALUE
	SET	'P-CONT,FALSE-VALUE
	JUMP	?CND2
?CCL4:	GRTR?	P-CONT,0 \?CCL10
	SET	'TLEXV,P-CONT
	ZERO?	VERBOSITY /?CND11
	EQUAL?	PLAYER,WINNER \?CND11
	CRLF	
?CND11:	SET	'P-CONT,FALSE-VALUE
	JUMP	?CND2
?CCL10:	SET	'WINNER,PLAYER
	ZERO?	P-OFLAG \?CND15
	GET	OOPS-TABLE,O-PTR
	ZERO?	STACK \?CND15
	PUT	OOPS-TABLE,O-END,FALSE-VALUE
?CND15:	LOC	WINNER
	IN?	STACK,ROOMS \?CND19
	LOC	WINNER >HERE
?CND19:	ZERO?	LIT /?CCL22
	EQUAL?	HERE,LIT /?CND21
	CALL2	VISIBLE?,LIT
	ZERO?	STACK \?CND21
?CCL22:	CALL1	LIT? >LIT
?CND21:	FCLEAR	IT,TOUCHBIT
	FCLEAR	HER,TOUCHBIT
	FCLEAR	HIM,TOUCHBIT
	GET	0,8
	BTST	STACK,4 \?CND27
	ICALL1	V-$REFRESH
?CND27:	ZERO?	VERBOSITY /?CND29
	CRLF	
?CND29:	ICALL1	UPDATE-STATUS-LINE
	PRINTC	62
	ICALL1	READ-INPUT
	ICALL1	FIX-QUOTATIONS
	ICALL1	FIX-TITLE-ABBRS
	GETB	P-LEXV,P-LEXWORDS >P-LEN
	SET	'TLEXV,P-LEXV+2
?CND2:	GET	TLEXV,0
	EQUAL?	STACK,W?PERIOD,W?THEN \?CND32
	ADD	TLEXV,4 >TLEXV
	DEC	'P-LEN
?CND32:	ICALL2	IGNORE-FIRST-WORD,W?YOU
	ICALL	IGNORE-FIRST-WORD,W?GO,W?TO
	ZERO?	P-LEN \?CND34
	ICALL1	BEG-PARDON
	RFALSE	
?CND34:	GET	TLEXV,0
	CALL	WORD-TYPE?,STACK,P-DIR-CODE >LEN
	ZERO?	LEN /?CCL38
	EQUAL?	P-LEN,1 /?CTR37
	SUB	TLEXV,P-LEXV
	LESS?	STACK,234 \?CTR37
	GET	TLEXV,P-LEXELEN
	CALL	WORD-TYPE?,STACK,P-EOI-CODE,P-COMMA-CODE
	ZERO?	STACK /?CCL38
?CTR37:	PUT	STATE-STACK,0,20
	PUT	DATA-STACK,0,20
	XPUSH	LEN,DATA-STACK /?BOGUS44
?BOGUS44:	ICALL2	RED-SD,1
	SET	'P-CONT,FALSE-VALUE
	SET	'P-OFLAG,0
	SET	'P-WORDS-AGAIN,1
	PUT	OOPS-TABLE,O-END,FALSE-VALUE
	SET	'M-PTR,FALSE-VALUE
	PUTB	P-LEXV,P-LEXWORDS,P-LEN
	COPYT	P-LEXV,G-LEXV,LEXV-LENGTH-BYTES
	COPYT	P-INBUF,G-INBUF,61
	PUT	PARSE-RESULT,13,0
	DEC	'P-LEN
	LESS?	0,P-LEN \TRUE
	ADD	TLEXV,4 >TLEXV
	GET	TLEXV,0 >LEN
	ZERO?	LEN /TRUE
	GETB	LEN,8
	BTST	STACK,128 /?CCL52
	GETB	LEN,8
	JUMP	?CND50
?CCL52:	GETB	LEN,8
	BAND	STACK,127
	SHIFT	STACK,7
?CND50:	BTST	STACK,8192 \TRUE
	SET	'P-WORDS-AGAIN,P-WORD-NUMBER
	DLESS?	'P-LEN,1 /TRUE
	ADD	TLEXV,4 >P-CONT
	RTRUE	
?CCL38:	GET	TLEXV,0
	EQUAL?	STACK,W?OOPS,W?O \?CCL56
	GET	TLEXV,P-LEXELEN
	EQUAL?	STACK,W?PERIOD,W?COMMA \?CND59
	ADD	PTR,P-LEXELEN >PTR
	DEC	'P-LEN
?CND59:	GRTR?	P-LEN,1 /?CCL63
	ICALL1	NAKED-OOPS
	RFALSE	
?CCL63:	CALL2	META-LOC,OWINNER
	EQUAL?	HERE,STACK /?CCL65
	ICALL2	NOT-HERE,OWINNER
	RFALSE	
?CCL65:	GET	OOPS-TABLE,O-PTR >VAL
	ZERO?	VAL /?CCL67
	SUB	P-LEN,1
	ICALL	REPLACE-ONE-TOKEN,STACK,P-LEXV,PTR,G-LEXV,VAL
	SET	'WINNER,OWINNER
	ICALL2	COPY-INPUT,TRUE-VALUE
	JUMP	?CND36
?CCL67:	PUT	OOPS-TABLE,O-END,FALSE-VALUE
	ICALL1	CANT-OOPS
	RFALSE	
?CCL56:	ZERO?	P-OFLAG \?CND36
	LESS?	P-CONT,1 \?CND36
	PUT	OOPS-TABLE,O-END,FALSE-VALUE
?CND36:	SET	'P-CONT,FALSE-VALUE
	GET	TLEXV,0
	EQUAL?	STACK,W?AGAIN,W?G \?CCL73
	ZERO?	P-OFLAG \?CTR75
	ZERO?	P-WON /?CTR75
	GETB	G-INBUF,2
	ZERO?	STACK \?CCL76
?CTR75:	ICALL1	CANT-AGAIN
	RFALSE	
?CCL76:	GRTR?	P-LEN,1 \?CND74
	SUB	TLEXV,P-LEXV
	LESS?	STACK,234 \?CND74
	GET	TLEXV,P-LEXELEN >N
	EQUAL?	N,W?PERIOD,W?COMMA,W?THEN /?CTR84
	EQUAL?	N,W?AND \?CCL85
?CTR84:	ADD	TLEXV,4 >TLEXV
	DEC	'P-LEN
?CND74:	DEC	'P-LEN
	ADD	TLEXV,4 >TLEXV
	GRTR?	P-LEN,0 \?CCL90
	COPYT	P-LEXV,M-LEXV,LEXV-LENGTH-BYTES
	COPYT	P-INBUF,M-INBUF,61
	SET	'M-LEN,P-LEN
	SET	'M-PTR,TLEXV
	SET	'P-CONT,M-PTR
	JUMP	?CND88
?CCL85:	ICALL1	DONT-UNDERSTAND
	RFALSE	
?CCL90:	SET	'M-PTR,FALSE-VALUE
?CND88:	CALL2	META-LOC,OWINNER
	EQUAL?	HERE,STACK /?CND91
	ICALL2	NOT-HERE,OWINNER
	RFALSE	
?CND91:	SET	'WINNER,OWINNER
	COPYT	G-INBUF,P-INBUF,61
	COPYT	G-LEXV,P-LEXV,LEXV-LENGTH-BYTES
	SET	'P-LEN,P-WORDS-AGAIN
	GET	OOPS-TABLE,O-START >TLEXV
	JUMP	?CND71
?CCL73:	SET	'M-PTR,FALSE-VALUE
	PUTB	P-LEXV,P-LEXWORDS,P-LEN
	COPYT	P-LEXV,G-LEXV,LEXV-LENGTH-BYTES
	COPYT	P-INBUF,G-INBUF,61
	PUT	OOPS-TABLE,O-START,TLEXV
	PUT	OOPS-TABLE,O-LENGTH,P-LEN
	GET	OOPS-TABLE,O-END
	ZERO?	STACK \?CND71
	GETB	P-LEXV,P-LEXWORDS
	MUL	4,STACK >LEN
	DEC	'LEN
	GETB	TLEXV,LEN >?TMP1
	DEC	'LEN
	GETB	TLEXV,LEN
	ADD	?TMP1,STACK
	PUT	OOPS-TABLE,O-END,STACK
?CND71:	SET	'P-WALK-DIR,FALSE-VALUE
	CALL2	PARSE-IT,FALSE-VALUE >CNT
?PRG95:	ZERO?	CNT \?CCL99
	CALL1	PRINT-PARSER-FAILURE >CNT
	JUMP	?PRG95
?CCL99:	EQUAL?	CNT,1 /FALSE
	PUT	OOPS-TABLE,O-PTR,FALSE-VALUE
	CALL1	GAME-VERB?
	ZERO?	STACK \?CND102
	SET	'P-OFLAG,0
?CND102:	GET	CNT,0 >LEN
	EQUAL?	LEN,W?TWICE,W?THRICE \?CND104
	GET	OOPS-TABLE,O-START
	INTBL?	LEN,STACK,P-WORDS-AGAIN,132 >N \?CND104
	ICALL	CHANGE-LEXV,N,W?ONCE
	EQUAL?	LEN,W?THRICE \?CCL110
	PUSH	2
	JUMP	?CND108
?CCL110:	PUSH	1
?CND108:	ICALL2	DO-IT-AGAIN,STACK
	CALL2	PARSE-IT,FALSE-VALUE >CNT
	JUMP	?PRG95
?CND104:	EQUAL?	LEN,W?DON'T \?CND111
	EQUAL?	WINNER,EXECUTIONER \?CCL115
	PRINTI	"""Tell me what you want me to do, not what you don't."""
	CRLF	
	RFALSE	
?CCL115:	PRINTI	"[Not done.]"
	CRLF	
	RFALSE	
?CND111:	GET	GWIM-MSG,1
	ZERO?	STACK /TRUE
	ICALL1	TELL-GWIM-MSG
	PUT	GWIM-MSG,1,0
	RTRUE	


	.FUNCT	TELL-GWIM-MSG,WD,VB
	PRINTC	91
	GET	GWIM-MSG,0 >WD
	ZERO?	WD /?CND1
	ICALL2	PRINT-VOCAB-WORD,WD
	PRINTC	32
	GET	PARSER-RESULT,1 >VB
	EQUAL?	VB,W?SIT,W?LIE \?CCL5
	EQUAL?	WD,W?DOWN \?CND1
	PRINTI	"on "
	JUMP	?CND1
?CCL5:	EQUAL?	VB,W?GET \?CND1
	EQUAL?	WD,W?OUT \?CND1
	PRINTI	"of "
?CND1:	GET	GWIM-MSG,1
	ICALL2	TELL-THE,STACK
	PRINTR	"]"


	.FUNCT	PARSE-IT,V,RES,NUM,SAV-LEXV,OLD-OBJECT,TV,T2,?TMP1
	SET	'SAV-LEXV,TLEXV
	PUT	SPLIT-STACK,0,0
	SET	'ERROR-PRIORITY,255
	PUT	ERROR-ARGS,1,0
	SET	'P-OLEN,P-LEN
	SET	'OTLEXV,TLEXV
?PRG1:	INC	'NUM
	ICALL2	BE-PATIENT,NUM
	PUT	STATE-STACK,0,20
	XPUSH	1,STATE-STACK /?BOGUS3
?BOGUS3:	PUT	DATA-STACK,0,20
	ICALL2	PMEM-RESET,FALSE-VALUE
	SET	'P-WORD-NUMBER,0
	SET	'TLEXV,SAV-LEXV
	SET	'P-LEN,P-OLEN
	PUT	GWIM-MSG,0,0
	PUT	GWIM-MSG,1,0
	SET	'OLD-OBJECT,PARSE-RESULT
	PUT	OLD-OBJECT,0,FALSE-VALUE
	ZERO?	V \?CCL6
	PUSH	0
	JUMP	?CND4
?CCL6:	GET	V,1
?CND4:	PUT	OLD-OBJECT,1,STACK
	PUT	OLD-OBJECT,2,FALSE-VALUE
	PUT	OLD-OBJECT,3,FALSE-VALUE
	PUT	OLD-OBJECT,4,FALSE-VALUE
	ZERO?	V \?CCL9
	PUSH	0
	JUMP	?CND7
?CCL9:	GET	V,5
?CND7:	PUT	OLD-OBJECT,5,STACK
	PUT	OLD-OBJECT,6,FALSE-VALUE
	PUT	OLD-OBJECT,7,FALSE-VALUE
	PUT	OLD-OBJECT,8,FALSE-VALUE
	ZERO?	V \?CCL12
	PUSH	0
	JUMP	?CND10
?CCL12:	GET	V,9
?CND10:	PUT	OLD-OBJECT,9,STACK
	ZERO?	V \?CCL15
	PUSH	0
	JUMP	?CND13
?CCL15:	GET	V,10
?CND13:	PUT	OLD-OBJECT,10,STACK
	ZERO?	V \?CCL18
	PUSH	0
	JUMP	?CND16
?CCL18:	GET	V,11
?CND16:	PUT	OLD-OBJECT,11,STACK
	PUT	OLD-OBJECT,12,FALSE-VALUE
	ZERO?	V \?CCL21
	PUSH	0
	JUMP	?CND19
?CCL21:	GET	V,13
?CND19:	PUT	OLD-OBJECT,13,STACK
	ZERO?	V \?CCL24
	PUSH	0
	JUMP	?CND22
?CCL24:	GET	V,14
?CND22:	PUT	OLD-OBJECT,14,STACK
	PUT	OLD-OBJECT,15,FALSE-VALUE
	PUT	OLD-OBJECT,16,0
	CALL2	PARSE-SENTENCE,PARSE-RESULT >RES
	EQUAL?	RES,PARSER-RESULT-AGAIN \?CCL27
	PUT	SPLIT-STACK,0,0
	SET	'ERROR-PRIORITY,255
	SET	'P-OLEN,P-LEN
	SET	'SAV-LEXV,TLEXV
	JUMP	?PRG1
?CCL27:	LESS?	RES,PARSER-RESULT-WON \?REP2
	GET	SPLIT-STACK,0
	ZERO?	STACK /?REP2
	ZERO?	RES /?REP2
?PRG33:	GET	SPLIT-STACK,0 >T2
	SUB	T2,1
	GET	SPLIT-STACK,STACK
	ZERO?	STACK \?CCL37
	GET	SPLIT-STACK,T2 >OLD-OBJECT
	ZERO?	OLD-OBJECT /?CTR39
	GET	OLD-OBJECT,0
	ZERO?	STACK /?CTR39
	ADD	OLD-OBJECT,4 >TV
	GET	TV,0
	ZERO?	STACK \?CCL40
?CTR39:	SUB	T2,2
	PUT	SPLIT-STACK,0,STACK
	JUMP	?CND35
?CCL40:	PUT	SPLIT-STACK,T2,TV
	JUMP	?REP34
?CCL37:	GET	SPLIT-STACK,T2 >?TMP1
	SUB	T2,1
	GET	SPLIT-STACK,STACK
	EQUAL?	?TMP1,STACK \?CCL45
	SUB	T2,2
	PUT	SPLIT-STACK,0,STACK
?CND35:	GET	SPLIT-STACK,0
	ZERO?	STACK \?PRG33
?REP34:	GET	SPLIT-STACK,0
	ZERO?	STACK \?PRG1
?REP2:	SUB	0,NUM
	ICALL2	BE-PATIENT,STACK
	EQUAL?	RES,PARSER-RESULT-WON \?CCL52
	RETURN	PARSER-RESULT
?CCL45:	GET	SPLIT-STACK,T2
	ADD	1,STACK
	PUT	SPLIT-STACK,T2,STACK
	JUMP	?REP34
?CCL52:	ZERO?	RES /TRUE
	RFALSE	


	.FUNCT	BUZZER-WORD?,WD,PTR,N,?TMP1
	ADD	3,P-ERRS >P-ERRS
	EQUAL?	WD,W?(SOMETHI,W?SOMETHING \?CCL3
	PRINTI	"[Type a real word instead of"
	PRINT	P-SOMETHING
	RTRUE	
?CCL3:	GET	P-W-WORDS,0
	INTBL?	WD,P-W-WORDS+2,STACK \?CCL5
	ICALL2	W-WORD-REPLY,WD
	RTRUE	
?CCL5:	ADD	P-Q-WORDS,2 >?TMP1
	GET	P-Q-WORDS,0
	INTBL?	WD,?TMP1,STACK /?CCL6
	GET	P-Q-WORDS1,0
	INTBL?	WD,P-Q-WORDS1+2,STACK \?CND1
?CCL6:	ICALL1	TELL-PLEASE-USE-COMMANDS
	RTRUE	
?CND1:	GET	P-N-WORDS,0
	INTBL?	WD,P-N-WORDS+2,STACK \?CCL11
	PRINTR	"[Use numerals for numbers, for example ""10.""]"
?CCL11:	GET	P-C-WORDS,0
	INTBL?	WD,P-C-WORDS+2,STACK \FALSE
	PRINTC	91
	CALL2	PICK-ONE,OFFENDED
	PRINT	STACK
	PRINTR	"]"


	.FUNCT	W-WORD-REPLY,WD
	EQUAL?	WD,W?WHAT,W?WHO \?CTR2
	EQUAL?	WINNER,PLAYER /?CCL3
?CTR2:	EQUAL?	WD,W?WHERE \?CCL8
	ICALL	TO-DO-X-USE-Y,STR?7,STR?8
	RTRUE	
?CCL8:	ICALL	TO-DO-X-USE-Y,STR?9,STR?10
	RTRUE	
?CCL3:	PRINTI	"[Maybe you could "
	FSET?	LIBRARY,TOUCHBIT \?CCL11
	PRINTI	"look that up in the"
	JUMP	?CND9
?CCL11:	PRINTI	"find an"
?CND9:	PRINTR	" encyclopedia.]"


	.FUNCT	TO-DO-X-USE-Y,STR1,STR2
	PRINTI	"[To "
	PRINT	STR1
	PRINTI	" something, use the command: "
	PRINT	STR2
	PRINT	P-SOMETHING
	RTRUE	


	.FUNCT	TELL-PLEASE-USE-COMMANDS,THRESH
	FSET?	GREAT-HALL,TOUCHBIT \?CCL3
	SET	'THRESH,10
	JUMP	?CND1
?CCL3:	SET	'THRESH,2
?CND1:	PRINTC	91
	LESS?	P-ERRS,THRESH \?CCL6
	PRINT	STR?12
	PRINTI	", not statements or questions"
	PRINTR	".]"
?CCL6:	CALL1	TELL-SAMPLE-COMMANDS
	RSTACK	


	.FUNCT	NUMBER?,RLEXV,BPTR,SUM,TIM,NEG,CHR,CNT,?TMP1
	GETB	RLEXV,3 >BPTR
	GETB	RLEXV,2 >CNT
?PRG1:	DLESS?	'CNT,0 /?REP2
	GETB	P-INBUF,BPTR >CHR
	EQUAL?	CHR,58 \?CCL8
	SET	'TIM,SUM
	SET	'SUM,0
	JUMP	?CND6
?CCL8:	EQUAL?	CHR,45 \?CCL10
	ZERO?	NEG \FALSE
	SET	'NEG,TRUE-VALUE
	JUMP	?CND6
?CCL10:	GRTR?	CHR,57 /FALSE
	LESS?	CHR,48 /FALSE
	GRTR?	SUM,3276 /FALSE
	MUL	SUM,10 >?TMP1
	SUB	CHR,48
	ADD	?TMP1,STACK >SUM
?CND6:	INC	'BPTR
	JUMP	?PRG1
?REP2:	ZERO?	TIM /?CCL22
	GRTR?	TIM,23 /FALSE
	ZERO?	NEG \FALSE
	MUL	TIM,60
	ADD	SUM,STACK >SUM
	ICALL	CHANGE-LEXV,RLEXV,W?INT.TIM,BPTR,SUM
	RETURN	W?INT.TIM
?CCL22:	ZERO?	NEG /?CND27
	SUB	0,SUM >SUM
?CND27:	ICALL	CHANGE-LEXV,RLEXV,W?INT.NUM,BPTR,SUM
	RETURN	W?INT.NUM


	.FUNCT	CHANGE-LEXV,PTR,WRD,BPTR,SUM,X
	PUT	PTR,0,WRD
	SUB	PTR,P-LEXV
	ADD	G-LEXV,STACK >X
	PUT	X,0,WRD
	ASSIGNED?	'BPTR \FALSE
	PUT	PTR,1,SUM
	PUT	X,1,SUM
	SET	'P-NUMBER,SUM
	RETURN	P-NUMBER


	.FUNCT	PARSE-SENTENCE,PR,SPLIT-NUM,RES-WCN,CURRENT-TOKEN,CAV,OFFS,T2,CURRENT-ACTION,REDUCTION,N,?TMP1
	SET	'SPLIT-NUM,-1
	GET	TLEXV,0 >CURRENT-TOKEN
	CATCH	 >PARSE-SENTENCE-ACTIVATION
	ZERO?	CURRENT-TOKEN \?PRG5
	CALL2	UNKNOWN-WORD,TLEXV >CURRENT-TOKEN
	ZERO?	CURRENT-TOKEN \?PRG5
	RETURN	PARSER-RESULT-DEAD
?PRG5:	GETB	CURRENT-TOKEN,8
	BTST	STACK,128 /?CCL10
	GETB	CURRENT-TOKEN,8 >RES-WCN
	JUMP	?CND7
?CCL10:	GETB	CURRENT-TOKEN,8
	BAND	STACK,127
	SHIFT	STACK,7 >RES-WCN
?CND7:	ZERO?	RES-WCN \?CCL13
	GET	CURRENT-TOKEN,3
	ZERO?	STACK \?CCL16
	CALL	BUZZER-WORD?,CURRENT-TOKEN,TLEXV
	ZERO?	STACK /?CND17
	MUL	P-LEXELEN,P-WORD-NUMBER
	ADD	STACK,P-LEXSTART
	PUT	OOPS-TABLE,O-PTR,STACK
	RETURN	PARSER-RESULT-DEAD
?CND17:	SET	'CAV,FALSE-VALUE
?CND11:	ZERO?	CAV /?PST36
	GET	CAV,1 >CURRENT-ACTION
	JUMP	?PRG38
?CCL16:	GET	CURRENT-TOKEN,3 >CURRENT-TOKEN
	JUMP	?PRG5
?CCL13:	SET	'OFFS,0
	CALL2	PEEK-PSTACK,STATE-STACK
	GET	ACTION-TABLE,STACK
	GET	STACK,0
	CALL	GET-TERMINAL-ACTION,RES-WCN,STACK,OFFS >CAV
	ZERO?	CAV /?CND19
	BAND	RES-WCN,32767 >?TMP1
	GET	CAV,OFFS
	BCOM	STACK
	BAND	?TMP1,STACK
	ZERO?	STACK /?CND19
	ADD	CAV,4
	CALL	GET-TERMINAL-ACTION,RES-WCN,STACK,OFFS
	ZERO?	STACK /?CND19
	ADD	SPLIT-NUM,2 >SPLIT-NUM
	ADD	SPLIT-NUM,1
	GET	SPLIT-STACK,0 >T2
	GRTR?	STACK,T2 \?CCL26
	INC	'T2
	LESS?	T2,21 /?CND27
	ICALL1	P-NO-MEM-ROUTINE
?CND27:	PUT	SPLIT-STACK,0,T2
	PUT	SPLIT-STACK,T2,0
	INC	'T2
	LESS?	T2,21 /?CND29
	ICALL1	P-NO-MEM-ROUTINE
?CND29:	PUT	SPLIT-STACK,0,T2
	PUT	SPLIT-STACK,T2,CAV
	JUMP	?CND19
?CCL26:	GET	SPLIT-STACK+2,SPLIT-NUM >CAV
	ZERO?	CAV /?CND31
	CALL	GET-TERMINAL-ACTION,RES-WCN,CAV,OFFS >CAV
?CND31:	PUT	SPLIT-STACK+2,SPLIT-NUM,CAV
?CND19:	ZERO?	CAV \?CND11
	RETURN	PARSER-RESULT-FAILED
?PST36:	SET	'CURRENT-ACTION,0
?PRG38:	ZERO?	CAV /?CCL42
	BAND	CURRENT-ACTION,65280
	ZERO?	STACK /?CCL42
	ADD	SPLIT-NUM,2 >SPLIT-NUM
	ADD	SPLIT-NUM,1
	GET	SPLIT-STACK,0 >T2
	GRTR?	STACK,T2 \?CCL47
	INC	'T2
	LESS?	T2,21 /?CND48
	ICALL1	P-NO-MEM-ROUTINE
?CND48:	PUT	SPLIT-STACK,0,T2
	GETB	CURRENT-ACTION,0
	PUT	SPLIT-STACK,T2,STACK
	INC	'T2
	LESS?	T2,21 /?CND50
	ICALL1	P-NO-MEM-ROUTINE
?CND50:	PUT	SPLIT-STACK,0,T2
	PUT	SPLIT-STACK,T2,1
	GETB	CURRENT-ACTION,1 >CURRENT-ACTION
	JUMP	?CND40
?CCL47:	GET	SPLIT-STACK+2,SPLIT-NUM
	GETB	CURRENT-ACTION,STACK >CURRENT-ACTION
	JUMP	?CND40
?CCL42:	ZERO?	CAV /?CND40
	ZERO?	CURRENT-ACTION \?CND40
	RETURN	PARSER-RESULT-FAILED
?CND40:	ZERO?	CAV /?CTR56
	LESS?	CURRENT-ACTION,128 \?CCL57
?CTR56:	ZERO?	CAV /?CND60
	XPUSH	CURRENT-TOKEN,DATA-STACK \?CCL64
	XPUSH	CURRENT-ACTION,STATE-STACK /?CND60
?CCL64:	ICALL1	P-NO-MEM-ROUTINE
?CND60:	DLESS?	'P-LEN,1 \?CCL69
	SET	'CURRENT-TOKEN,W?END.OF.INPUT
	ADD	1,P-WORD-NUMBER >P-WORDS-AGAIN
	SET	'P-CONT,FALSE-VALUE
	SET	'P-LEN,0
	JUMP	?CND67
?CCL69:	INC	'P-WORD-NUMBER
	ADD	TLEXV,4 >TLEXV
	GET	TLEXV,0 >CURRENT-TOKEN
	GRTR?	TLEXV,OTLEXV \?CND67
	SET	'OTLEXV,TLEXV
?CND67:	ZERO?	CURRENT-TOKEN \?CCL74
	CALL2	UNKNOWN-WORD,TLEXV >CURRENT-TOKEN
	ZERO?	CURRENT-TOKEN \?PRG5
	RETURN	PARSER-RESULT-DEAD
?CCL74:	EQUAL?	CURRENT-TOKEN,W?THEN,W?!,W?PERIOD /?CCL77
	EQUAL?	CURRENT-TOKEN,W?? \?PRG5
?CCL77:	SET	'P-WORDS-AGAIN,P-WORD-NUMBER
	DLESS?	'P-LEN,1 /?CCL82
	ADD	TLEXV,4 >P-CONT
	JUMP	?PRG5
?CCL82:	SET	'P-CONT,FALSE-VALUE
	JUMP	?PRG5
?CCL57:	GRTR?	CURRENT-ACTION,128 \?CCL84
	SUB	CURRENT-ACTION,129
	GET	REDUCTION-TABLE,STACK >REDUCTION
	GET	REDUCTION,0 >RES-WCN
	ZERO?	RES-WCN /?CND87
	SET	'N,RES-WCN
?PRG89:	DLESS?	'N,0 /?CND87
	POP	STATE-STACK
	JUMP	?PRG89
?CND87:	SET	'CURRENT-REDUCTION,REDUCTION
	SET	'P-RUNNING,TLEXV
	GET	REDUCTION,1 >?TMP1
	GET	REDUCTION,0
	CALL	?TMP1,STACK >RES-WCN
	SET	'TLEXV,P-RUNNING
	GRTR?	TLEXV,OTLEXV \?CND93
	SET	'OTLEXV,TLEXV
?CND93:	LESS?	P-LEN,1 \?CCL97
	SET	'CURRENT-TOKEN,W?END.OF.INPUT
	JUMP	?CND95
?CCL97:	GET	TLEXV,0 >CURRENT-TOKEN
?CND95:	SET	'CURRENT-REDUCTION,FALSE-VALUE
	ZERO?	RES-WCN \?CTR99
	RETURN	PARSER-RESULT-FAILED
?CTR99:	XPUSH	RES-WCN,DATA-STACK /?CND98
	ICALL1	P-NO-MEM-ROUTINE
?CND98:	CALL2	PEEK-PSTACK,STATE-STACK
	GET	ACTION-TABLE,STACK >?TMP1
	GET	REDUCTION,4
	CALL	GET-NONTERMINAL-ACTION,?TMP1,STACK
	XPUSH	STACK,STATE-STACK /?PRG5
	ICALL1	P-NO-MEM-ROUTINE
	JUMP	?PRG5
?CCL84:	POP	DATA-STACK >PARSER-RESULT
	RETURN	PARSER-RESULT-WON


	.FUNCT	GET-TERMINAL-ACTION,TYPE,STATE,OFFS,V
	ZERO?	STATE /FALSE
	SET	'V,STATE
?PRG4:	GET	V,0
	ZERO?	STACK /FALSE
	GET	V,OFFS
	BAND	TYPE,STACK
	ZERO?	STACK /?CND8
	RETURN	V
?CND8:	ADD	V,4 >V
	JUMP	?PRG4


	.FUNCT	GET-NONTERMINAL-ACTION,STATE,TYPE,V
	GET	STATE,1
	ZERO?	STACK /FALSE
	GET	STATE,1 >V
?PRG4:	GETB	V,0
	ZERO?	STACK /FALSE
	GETB	V,0
	EQUAL?	STACK,TYPE \?CND6
	GETB	V,1
	RSTACK	
?CND6:	ADD	V,2 >V
	JUMP	?PRG4


	.FUNCT	BE-PATIENT,NUM
	LESS?	NUM,0 \?CCL3
	LESS?	NUM,-15 \FALSE
	BUFOUT	TRUE-VALUE
	PRINTR	"]"
?CCL3:	MOD	NUM,16
	ZERO?	STACK \FALSE
	EQUAL?	NUM,16 \?CCL11
	BUFOUT	FALSE-VALUE
	PRINTI	"[Please be patient..."
	RTRUE	
?CCL11:	PRINTC	46
	RTRUE	


	.FUNCT	P-NO-MEM-ROUTINE,TYP
	PRINTI	"[Sorry, but that"
	EQUAL?	TYP,7 \?CCL3
	PRINTI	"'s too many objects"
	JUMP	?CND1
?CCL3:	PRINTI	" sentence is too complicated"
?CND1:	PRINTI	".]
"
	THROW	PARSER-RESULT-DEAD,PARSE-SENTENCE-ACTIVATION
	RTRUE	


	.FUNCT	DO-IT-AGAIN,NUM,X,TMP
	ASSIGNED?	'NUM /?CND1
	SET	'NUM,1
?CND1:	SUB	TLEXV,P-LEXV
	DIV	STACK,2 >X
	ZERO?	P-CONT \?CND3
	ADD	X,P-LEXELEN >X
?CND3:	GET	OOPS-TABLE,O-START >TMP
	ZERO?	TMP /?PRG7
	SUB	TMP,P-LEXV+2
	DIV	STACK,4 >TMP
	GETB	G-LEXV,P-LEXWORDS
	ADD	STACK,TMP
	PUTB	G-LEXV,P-LEXWORDS,STACK
?PRG7:	ICALL	MAKE-ROOM-FOR-TOKENS,2,G-LEXV,X
	PUT	G-LEXV,X,W?PERIOD
	ADD	X,P-LEXELEN
	PUT	G-LEXV,STACK,W?AGAIN
	DLESS?	'NUM,1 \?PRG7
	GETB	G-LEXV,P-LEXWORDS
	SUB	STACK,TMP
	PUTB	G-LEXV,P-LEXWORDS,STACK
	CALL2	COPY-INPUT,TRUE-VALUE
	RSTACK	


	.FUNCT	INVALID-OBJECT?,OBJ
	CALL1	EVERYWHERE-VERB?
	ZERO?	STACK \FALSE
	EQUAL?	OBJ,CEILING \?CCL5
	FSET?	HERE,OUTSIDEBIT \?CCL5
	EQUAL?	HERE,ROOF,PARAPET \TRUE
?CCL5:	EQUAL?	OBJ,LOCK-OBJECT \?CCL10
	CALL	NOUN-USED?,LOCK-OBJECT,W?KEYHOLE
	ZERO?	STACK /?CCL10
	EQUAL?	HERE,LOWEST-HALL /TRUE
?CCL10:	EQUAL?	OBJ,WALL \FALSE
	FSET?	HERE,OUTSIDEBIT \FALSE
	GET	FINDER,6
	EQUAL?	W?ONE,STACK /FALSE
	EQUAL?	HERE,PERIMETER-WALL /FALSE
	RTRUE	


	.FUNCT	TEST-THINGS,RM,F,CT,RMG,RMGL,TTBL,NOUN,V,?TMP2,?TMP1
	GETP	RM,P?THINGS >RMG
	GET	RMG,0 >RMGL
	ADD	RMG,2 >RMG
	GET	F,5 >CT
	ZERO?	CT /?CND1
	GET	CT,4 >CT
?CND1:	GET	F,6 >NOUN
	GET	F,5
	ADD	STACK,10 >V
?PRG3:	GET	RMG,1 >TTBL
	ZERO?	TTBL /?CND5
	EQUAL?	NOUN,W?ONE /?PRD9
	ADD	TTBL,2 >?TMP1
	GET	TTBL,0
	INTBL?	NOUN,?TMP1,STACK \?CND5
?PRD9:	ZERO?	CT /?PRD12
	GET	RMG,0 >TTBL
	ZERO?	TTBL /?CND5
	GET	V,0 >?TMP2
	ADD	TTBL,2 >?TMP1
	GET	TTBL,0
	INTBL?	?TMP2,?TMP1,STACK \?CND5
?PRD12:	GET	F,7
	ZERO?	STACK /?CCL6
	GET	OWNER-SR-HERE,1
	EQUAL?	1,STACK \?CND5
	GET	OWNER-SR-HERE,4
	EQUAL?	PSEUDO-OBJECT,STACK \?CND5
	EQUAL?	LAST-PSEUDO-LOC,RM \?CND5
	GETP	PSEUDO-OBJECT,P?ACTION >?TMP1
	GET	RMG,2
	EQUAL?	?TMP1,STACK \?CND5
?CCL6:	SET	'LAST-PSEUDO-LOC,RM
	GET	RMG,2
	PUTP	PSEUDO-OBJECT,P?ACTION,STACK
	GETPT	PSEUDO-OBJECT,P?ACTION
	SUB	STACK,7 >V
	COPYT	NOUN,V,6
	ICALL	ADD-OBJECT,PSEUDO-OBJECT,F
	RFALSE	
?CND5:	ADD	RMG,6 >RMG
	DLESS?	'RMGL,1 \?PRG3
	RTRUE	

	.ENDSEG

	.ENDI
