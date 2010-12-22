CREATE TABLE SBI_CHECKS (
       CHECK_ID INTEGER IDENTITY(1, 1) NOT NULL,      
       DESCR                 VARCHAR(160) NULL,
       LABEL                 VARCHAR(20) NOT NULL,
       VALUE_TYPE_CD         VARCHAR(20) NOT NULL,
       VALUE_TYPE_ID         INTEGER NOT NULL,
       VALUE_1               VARCHAR(400) NULL,
       VALUE_2               VARCHAR(400) NULL,
       NAME                  VARCHAR(40) NOT NULL,
       CONSTRAINT XAK1SBI_CHECKS UNIQUE (LABEL),
       CONSTRAINT PK_SBI_CHECKS PRIMARY KEY CLUSTERED(CHECK_ID)
)ON [PRIMARY]

CREATE TABLE SBI_DOMAINS (
       VALUE_ID  INTEGER IDENTITY(1, 1) NOT NULL,
       VALUE_CD             VARCHAR(100) NULL,
       VALUE_NM             VARCHAR(40) NULL,
       DOMAIN_CD            VARCHAR(20) NULL,
       DOMAIN_NM            VARCHAR(40) NULL,
       VALUE_DS             VARCHAR(160) NULL,
       CONSTRAINT XAK1SBI_DOMAINS UNIQUE (VALUE_CD, DOMAIN_CD),
       CONSTRAINT PK_SBI_DOMAINS PRIMARY KEY CLUSTERED(VALUE_ID)
)ON [PRIMARY]

CREATE TABLE SBI_ENGINES (
       ENGINE_ID            INTEGER IDENTITY(1, 1) NOT NULL,
       ENCRYPT              SMALLINT NULL,
       NAME                 VARCHAR(40) NOT NULL,
       DESCR                VARCHAR(160) NULL,
       MAIN_URL             VARCHAR(400) NULL,
       SECN_URL             VARCHAR(400) NULL,
       OBJ_UPL_DIR          VARCHAR(400) NULL,
       OBJ_USE_DIR          VARCHAR(400) NULL,
       DRIVER_NM            VARCHAR(400) NULL,
       LABEL                VARCHAR(40) NOT NULL,
       ENGINE_TYPE          INTEGER NOT NULL,
       CLASS_NM             VARCHAR(400) NULL,
       BIOBJ_TYPE           INTEGER NOT NULL,
	   DEFAULT_DS_ID		INTEGER,
       CONSTRAINT XAK1SBI_ENGINES UNIQUE (LABEL),
       CONSTRAINT PK_SBI_ENGINES PRIMARY KEY CLUSTERED(ENGINE_ID)
)ON [PRIMARY]


CREATE TABLE SBI_EXT_ROLES (
       EXT_ROLE_ID           INTEGER IDENTITY(1, 1) NOT NULL,
       NAME                 VARCHAR(100) NULL,
       DESCR                VARCHAR(160) NULL,
       CODE                 VARCHAR(20) NULL,
       ROLE_TYPE_CD         VARCHAR(20) NOT NULL,
       ROLE_TYPE_ID         INTEGER NOT NULL, 
       SAVE_SUBOBJECTS				BOOLEAN DEFAULT TRUE,
       SEE_SUBOBJECTS				BOOLEAN DEFAULT TRUE,
       SEE_VIEWPOINTS				BOOLEAN DEFAULT TRUE,
       SEE_SNAPSHOTS				BOOLEAN DEFAULT TRUE,
       SEE_NOTES					BOOLEAN DEFAULT TRUE,
       SEND_MAIL					BOOLEAN DEFAULT TRUE,
       SAVE_INTO_FOLDER				BOOLEAN DEFAULT TRUE,
       SAVE_REMEMBER_ME				BOOLEAN DEFAULT TRUE,
       SEE_METADATA 				BOOLEAN DEFAULT TRUE,
       SAVE_METADATA 				BOOLEAN DEFAULT TRUE,
       BUILD_QBE_QUERY 				BOOLEAN DEFAULT TRUE,
       CONSTRAINT PK_SBI_EXT_ROLES PRIMARY KEY CLUSTERED(EXT_ROLE_ID)
)ON [PRIMARY]


CREATE TABLE SBI_FUNC_ROLE (
       ROLE_ID              INTEGER NOT NULL,
       FUNCT_ID             INTEGER NOT NULL,
       STATE_CD             VARCHAR(20) NULL,
       STATE_ID             INTEGER NOT NULL,
       CONSTRAINT PK_SBI_FUNC_ROLE PRIMARY KEY CLUSTERED(FUNCT_ID, STATE_ID, ROLE_ID)
)ON [PRIMARY]


CREATE TABLE SBI_FUNCTIONS (
       FUNCT_ID             INTEGER IDENTITY(1, 1) NOT NULL,
       FUNCT_TYPE_CD        VARCHAR(20) NOT NULL,
       PARENT_FUNCT_ID      INTEGER NULL,
       NAME                 VARCHAR(40) NULL,
       DESCR                VARCHAR(160) NULL,
       PATH                 VARCHAR(400) NULL,
       CODE                 VARCHAR(40) NOT NULL,
       PROG 				        INTEGER NOT NULL,
       FUNCT_TYPE_ID        INTEGER NOT NULL,
       CONSTRAINT XAK1SBI_FUNCTIONS UNIQUE (CODE),
       CONSTRAINT PK_SBI_FUNCTIONS PRIMARY KEY CLUSTERED(FUNCT_ID)
)ON [PRIMARY]



CREATE TABLE SBI_LOV (
       LOV_ID               INTEGER IDENTITY(1, 1) NOT NULL,
       DESCR                VARCHAR(160) NULL,
       LABEL                VARCHAR(20) NOT NULL,
       INPUT_TYPE_CD        VARCHAR(20) NOT NULL,
       DEFAULT_VAL          VARCHAR(40) NULL,
       LOV_PROVIDER         TEXT NULL,
       INPUT_TYPE_ID        INTEGER NOT NULL,
       PROFILE_ATTR         VARCHAR(20) NULL,
       NAME                 VARCHAR(40) NOT NULL,
       CONSTRAINT XAK1SBI_LOV UNIQUE (LABEL),
       CONSTRAINT PK_SBI_LOV PRIMARY KEY CLUSTERED(LOV_ID)
)ON [PRIMARY]


CREATE TABLE SBI_OBJ_FUNC (
       BIOBJ_ID             INTEGER NOT NULL,
       FUNCT_ID             INTEGER NOT NULL,
       PROG                 INTEGER NULL,
       CONSTRAINT PK_SBI_OBJ_FUNC PRIMARY KEY CLUSTERED(BIOBJ_ID, FUNCT_ID)
)ON [PRIMARY]


CREATE TABLE SBI_OBJ_PAR (
       OBJ_PAR_ID           INTEGER IDENTITY(1, 1) NOT NULL,
       PAR_ID               INTEGER NOT NULL,
       BIOBJ_ID             INTEGER NOT NULL,
       LABEL                VARCHAR(40) NOT NULL,
       REQ_FL               SMALLINT NULL,
       MOD_FL               SMALLINT NULL,
       VIEW_FL              SMALLINT NULL,
       MULT_FL              SMALLINT NULL,
       PROG                 INTEGER NOT NULL,
       PARURL_NM            VARCHAR(20) NULL,
       PRIORITY             INTEGER NULL,
        CONSTRAINT PK_SBI_OBJ_PAR PRIMARY KEY CLUSTERED([OBJ_PAR_ID])
)ON [PRIMARY]


CREATE TABLE SBI_OBJ_STATE (
       BIOBJ_ID             INTEGER NOT NULL,
       STATE_ID             INTEGER NOT NULL,
       END_DT               datetime NULL,
       START_DT             datetime NOT NULL,
       NOTE                 VARCHAR(300) NULL,
       CONSTRAINT PK_SBI_OBJ_STATE PRIMARY KEY (BIOBJ_ID, STATE_ID, START_DT)
)ON [PRIMARY]



CREATE TABLE SBI_OBJECTS (
       BIOBJ_ID             INTEGER IDENTITY(1, 1) NOT NULL,
       ENGINE_ID            INTEGER NOT NULL,
       DESCR                VARCHAR(400) NULL,
       LABEL                VARCHAR(20) NOT NULL,
       ENCRYPT              SMALLINT NULL,
       PATH                 VARCHAR(400) NULL,
       REL_NAME             VARCHAR(400) NULL,
       STATE_ID             INTEGER NOT NULL,
       STATE_CD             VARCHAR(20) NOT NULL,
       BIOBJ_TYPE_CD        VARCHAR(20) NOT NULL,
       BIOBJ_TYPE_ID        INTEGER NOT NULL,
       SCHED_FL             SMALLINT NULL,
       EXEC_MODE_ID         INTEGER NULL,
       STATE_CONS_ID        INTEGER NULL,
       EXEC_MODE_CD         VARCHAR(20) NULL,
       STATE_CONS_CD        VARCHAR(20) NULL,
       NAME                 VARCHAR(200) NOT NULL,
       VISIBLE              SMALLINT NOT NULL,
       UUID                 VARCHAR(40) NOT NULL,
	   DATA_SOURCE_ID		INTEGER,
       PROF_VISIBILITY 		VARCHAR(400),
       CONSTRAINT XAK1SBI_OBJECTS UNIQUE (LABEL),
       CONSTRAINT PK_SBI_OBJECTS PRIMARY KEY CLUSTERED(BIOBJ_ID)
)ON [PRIMARY]


CREATE TABLE SBI_PARAMETERS (
       PAR_ID               INTEGER IDENTITY(1, 1) NOT NULL,
       DESCR                VARCHAR(160) NULL,
       LENGTH               SMALLINT NOT NULL,
       LABEL                VARCHAR(20) NOT NULL,
       PAR_TYPE_CD          VARCHAR(20) NOT NULL,
       MASK                 VARCHAR(20) NULL,
       PAR_TYPE_ID          INTEGER NOT NULL,
       NAME                 VARCHAR(40) NOT NULL,
       FUNCTIONAL_FLAG		SMALLINT NOT NULL DEFAULT 1,
       TEMPORAL_FLAG		SMALLINT NOT NULL DEFAULT 0,
       CONSTRAINT XAK1SBI_PARAMETERS UNIQUE (LABEL),
       CONSTRAINT PK_SBI_PARAMETERS PRIMARY KEY CLUSTERED(PAR_ID)
)ON [PRIMARY]



CREATE TABLE SBI_PARUSE (
       USE_ID               INTEGER IDENTITY(1, 1) NOT NULL,
       LOV_ID               INTEGER NULL,
       LABEL                VARCHAR(20) NOT NULL,
       DESCR                VARCHAR(160) NULL,
       PAR_ID               INTEGER NOT NULL,
       NAME                 VARCHAR(40) NOT NULL,
       MAN_IN               INTEGER NOT NULL,
       SELECTION_TYPE  VARCHAR(20) DEFAULT 'LIST',
       MULTIVALUE_FLAG  INTEGER DEFAULT 0,
       CONSTRAINT XAK1SBI_PARUSE UNIQUE (PAR_ID, LABEL),
       CONSTRAINT PK_SBI_PARUSE PRIMARY KEY CLUSTERED(USE_ID)
)ON [PRIMARY]
 

CREATE TABLE SBI_PARUSE_CK (
       CHECK_ID             INTEGER NOT NULL,
       USE_ID               INTEGER NOT NULL,
       PROG                 INTEGER NULL,
       CONSTRAINT PK_SBI_PARUSE_CK PRIMARY KEY CLUSTERED(USE_ID, CHECK_ID)
)ON [PRIMARY]
 


CREATE TABLE SBI_PARUSE_DET (
       EXT_ROLE_ID          INTEGER NOT NULL,
       PROG                 INTEGER NULL,
       USE_ID               INTEGER NOT NULL,
       HIDDEN_FL            SMALLINT NULL,
       DEFAULT_VAL          VARCHAR(40) NULL,
       CONSTRAINT PK_SBI_PARUSE_DET PRIMARY KEY CLUSTERED(USE_ID, EXT_ROLE_ID)
)ON [PRIMARY]
 

CREATE TABLE SBI_SUBREPORTS (
       MASTER_RPT_ID        INTEGER NOT NULL,
       SUB_RPT_ID           INTEGER NOT NULL,
       CONSTRAINT PK_SBI_SUBREPORTS PRIMARY KEY CLUSTERED(MASTER_RPT_ID, SUB_RPT_ID)
)ON [PRIMARY]
        

CREATE TABLE SBI_OBJ_PARUSE (
	OBJ_PAR_ID          INTEGER NOT NULL,
	USE_ID              INTEGER NOT NULL,
	OBJ_PAR_FATHER_ID   INTEGER NOT NULL,
	FILTER_OPERATION    VARCHAR(20) NOT NULL,
	PROG INTEGER NOT NULL,
	FILTER_COLUMN       VARCHAR(30) NOT NULL,
	PRE_CONDITION VARCHAR(10),
  POST_CONDITION VARCHAR(10),
  LOGIC_OPERATOR VARCHAR(10),
  CONSTRAINT PK_SBI_OBJ_PARUSE PRIMARY KEY(OBJ_PAR_ID,USE_ID,OBJ_PAR_FATHER_ID,FILTER_OPERATION)
)ON [PRIMARY]
        

CREATE TABLE SBI_EVENTS (
	ID                  INTEGER IDENTITY(1, 1) NOT NULL,
  USER_EVENT          VARCHAR(40) NOT NULL,
  CONSTRAINT PK_SBI_EVENTS PRIMARY KEY(ID)
)ON [PRIMARY]
  

CREATE TABLE SBI_EVENTS_LOG (
	ID                  INTEGER IDENTITY(1, 1) NOT NULL,
	USER_EVENT          VARCHAR(40) NOT NULL,
	EVENT_DATE          DATETIME  NOT NULL,
	DESCR               TEXT NOT NULL,
	PARAMS              VARCHAR(1000),
	HANDLER 	          VARCHAR(400) NOT NULL DEFAULT 'it.eng.spabi.events.handlers.DefaultEventPresentationHandler',
  CONSTRAINT PK_SBI_EVENTS_LOG  PRIMARY KEY(ID)
)ON [PRIMARY]
        

CREATE TABLE SBI_EVENTS_ROLES (
       EVENT_ID            INTEGER NOT NULL,
       ROLE_ID             INTEGER NOT NULL,
       CONSTRAINT PK_SBI_EVENTS_ROLES PRIMARY KEY (EVENT_ID, ROLE_ID)
)ON [PRIMARY]
        

CREATE TABLE SBI_AUDIT ( 
		ID 				  	  INTEGER IDENTITY(1, 1) NOT NULL,
		USERNAME 			  VARCHAR(40) NOT NULL,
		USERGROUP 			VARCHAR(100),
		DOC_REF 			  INTEGER,
		DOC_ID 				  INTEGER,
		DOC_LABEL 		  VARCHAR(20) NOT NULL,
		DOC_NAME 			  VARCHAR(40) NOT NULL,
		DOC_TYPE 			  VARCHAR(20) NOT NULL,
		DOC_STATE 		  VARCHAR(20) NOT NULL,
		DOC_PARAMETERS 		TEXT,
		SUBOBJ_REF			INTEGER,
		SUBOBJ_ID			INTEGER,
		SUBOBJ_NAME         VARCHAR(50),
		SUBOBJ_OWNER 	    VARCHAR(50),
		SUBOBJ_ISPUBLIC 	SMALLINT NULL,
		ENGINE_REF 			INTEGER,
		ENGINE_ID 			INTEGER,
		ENGINE_LABEL 		VARCHAR(20) NOT NULL,
		ENGINE_NAME 		VARCHAR(40) NOT NULL,
		ENGINE_TYPE 		VARCHAR(20) NOT NULL,
		ENGINE_URL 			VARCHAR(400),
		ENGINE_DRIVER 	VARCHAR(400),
		ENGINE_CLASS 		VARCHAR(400),
		REQUEST_TIME 		datetime NOT NULL,
		EXECUTION_START datetime,
		EXECUTION_END 	datetime,
		EXECUTION_TIME	INTEGER,
		EXECUTION_STATE VARCHAR(20),
		ERROR				    SMALLINT,
		ERROR_MESSAGE 	VARCHAR(400),
		ERROR_CODE 			VARCHAR(20),
		EXECUTION_MODALITY 	VARCHAR(20),
    CONSTRAINT PK_SBI_AUDIT 	PRIMARY KEY (ID)
)ON [PRIMARY]

CREATE TABLE SBI_ACTIVITY_MONITORING (
  ID INTEGER IDENTITY(1, 1) NOT NULL,
  ACTION_TIME   datetime,
  USERNAME 	 	VARCHAR(40) NOT NULL,
  USERGROUP		VARCHAR(400),
  LOG_LEVEL 	VARCHAR(10) ,
  ACTION_CODE 	VARCHAR(45) NOT NULL,
  INFO 			VARCHAR(400),
  PRIMARY KEY (ID)
)ON [PRIMARY]
  	


CREATE TABLE SBI_GEO_MAPS (
       MAP_ID               INTEGER IDENTITY(1, 1) NOT NULL,
       NAME                 VARCHAR(40) NOT NULL,
       DESCR                VARCHAR(160) NULL,
       URL					VARCHAR(400) NULL,
       FORMAT 				VARCHAR(40) NULL,   
       BIN_ID         		INTEGER NULL,
       CONSTRAINT XAK1SBI_GEO_MAPS UNIQUE (NAME),
       CONSTRAINT PK_SBI_GEO_MAPS PRIMARY KEY CLUSTERED(MAP_ID)
)ON [PRIMARY]
 

CREATE TABLE SBI_GEO_FEATURES (
       FEATURE_ID           INTEGER IDENTITY(1, 1) NOT NULL,  
       NAME                 VARCHAR(40) NOT NULL,
       DESCR                VARCHAR(160) NULL,
       TYPE					        VARCHAR(40)  NULL,
       CONSTRAINT XAK1SBI_GEO_FEATURES UNIQUE (NAME),
       CONSTRAINT PK_SBI_GEO_FEATURES PRIMARY KEY CLUSTERED(FEATURE_ID)
)ON [PRIMARY]
  

CREATE TABLE SBI_GEO_MAP_FEATURES (
       MAP_ID             INTEGER NOT NULL,
       FEATURE_ID         INTEGER NOT NULL,
       SVG_GROUP          VARCHAR(40),
       VISIBLE_FLAG		    VARCHAR(1),
       CONSTRAINT PK_SBI_GEO_MAP_FEATURES PRIMARY KEY (MAP_ID, FEATURE_ID)
)ON [PRIMARY]

CREATE TABLE SBI_VIEWPOINTS (
		VP_ID 				INTEGER IDENTITY(1, 1) NOT NULL,      
		BIOBJ_ID 			INTEGER NOT NULL, 
		VP_NAME 			VARCHAR(40) NOT NULL,
	    VP_OWNER 			VARCHAR(40),
		VP_DESC 			VARCHAR(160),
		VP_SCOPE 			VARCHAR (20) NOT NULL, 
		VP_VALUE_PARAMS 	TEXT, 
		VP_CREATION_DATE 	datetime NOT NULL,
       CONSTRAINT XPKSBI_VIEWPOINTS  PRIMARY KEY (VP_ID)
)ON [PRIMARY]


CREATE TABLE SBI_DATA_SOURCE (
		DS_ID 				INTEGER IDENTITY(1, 1) NOT NULL,
		DESCR 				VARCHAR(160), 
		LABEL	 			VARCHAR(50) NOT NULL,
    	JNDI	 			VARCHAR(50),
		URL_CONNECTION		VARCHAR(500),
		USERNAME 			VARCHAR(50), 
		PWD				 	VARCHAR(50), 
		DRIVER			 	VARCHAR(160),
	    DIALECT_ID			INTEGER NOT NULL,
		MULTI_SCHEMA TINYINT(1) NOT NULL DEFAULT '0',
		ATTR_SCHEMA VARCHAR(45) DEFAULT NULL ,
		CONSTRAINT XAK1SBI_DATA_SOURCE UNIQUE (LABEL),
        CONSTRAINT XPKSBI_DATA_SOURCE  PRIMARY KEY (DS_ID)
)ON [PRIMARY]

CREATE TABLE SBI_SNAPSHOTS (
		SNAP_ID				INTEGER IDENTITY(1, 1) NOT NULL,
		BIOBJ_ID			INTEGER,
		BIN_ID				INTEGER,
		NAME				VARCHAR(100),
		DESCRIPTION			VARCHAR(1000),
		CREATION_DATE		TIMESTAMP NOT NULL,                                    
        CONSTRAINT XPKSBI_SNAPSHOTS  PRIMARY KEY (SNAP_ID)
)ON [PRIMARY]

CREATE TABLE SBI_USER_FUNCTIONALITY (
		USER_FUNCT_ID 		INTEGER IDENTITY(1, 1)  NOT NULL,
		NAME 	            VARCHAR(50),  
    	DESCRIPTION 	    VARCHAR(100),      
		CONSTRAINT XAK1SBI_USER_FUNCTIONALITY UNIQUE (USER_FUNCT_ID),
	    CONSTRAINT XPKSBI_USER_FUNCTIONALITY PRIMARY KEY (USER_FUNCT_ID)
)ON [PRIMARY]


CREATE TABLE SBI_ROLE_TYPE_USER_FUNCTIONALITY (
		ROLE_TYPE_ID 		INTEGER NOT NULL,
		USER_FUNCT_ID 	    INTEGER NOT NULL,     
		CONSTRAINT XAK1SBI_ROLE_TYPE_USER_FUNCTIONALITY UNIQUE (ROLE_TYPE_ID,USER_FUNCT_ID),
		CONSTRAINT XPKSBI_ROLE_TYPE_USER_FUNCTIONALITY 	PRIMARY KEY (ROLE_TYPE_ID,USER_FUNCT_ID)
)ON [PRIMARY]

CREATE TABLE SBI_DOSSIER_PRESENTATIONS (
        PRESENTATION_ID 			INTEGER IDENTITY(1, 1) NOT NULL,
        WORKFLOW_PROCESS_ID 		BIGINT NOT NULL,
        BIOBJ_ID 					INTEGER NOT NULL,
        BIN_ID 						INTEGER NOT NULL,
        NAME 						VARCHAR(40) NOT NULL,
        PROG 						INTEGER NULL,
        CREATION_DATE 				TIMESTAMP,
        APPROVED 					SMALLINT NULL,
        CONSTRAINT PK_SBI_DOSSIER_PRESENTATIONS PRIMARY KEY CLUSTERED(PRESENTATION_ID)
)ON [PRIMARY]

CREATE TABLE SBI_DOSSIER_PARTS_TEMP (
        PART_ID 					INTEGER IDENTITY(1, 1) NOT NULL,
        WORKFLOW_PROCESS_ID 		BIGINT NOT NULL,
        BIOBJ_ID 					INTEGER NOT NULL,
        PAGE_ID 					INTEGER NOT NULL,
        CONSTRAINT PK_SBI_DOSSIER_PARTS_TEMP PRIMARY KEY CLUSTERED(PART_ID)
)ON [PRIMARY]

CREATE TABLE SBI_DOSSIER_BINARY_CONTENTS_TEMP (
        BIN_ID 						INTEGER IDENTITY(1, 1) NOT NULL,
        PART_ID 					INTEGER NOT NULL,
        NAME 						VARCHAR(20),
        BIN_CONTENT 				image NOT NULL,
        TYPE 						VARCHAR(20) NOT NULL,
        CREATION_DATE 				TIMESTAMP,
        CONSTRAINT PK_SBI_DOSSIER_BINARY_CONTENTS_TEMP PRIMARY KEY CLUSTERED(BIN_ID)
)ON [PRIMARY]

CREATE TABLE SBI_REMEMBER_ME (
       ID               INTEGER IDENTITY(1, 1) NOT NULL,
       NAME 			VARCHAR(50) NOT NULL,
       DESCRIPTION      VARCHAR2(2000),
       USERNAME			VARCHAR(40) NOT NULL,
       BIOBJ_ID         INTEGER NOT NULL,
       SUBOBJ_ID        INTEGER NULL,
       PARAMETERS       TEXT,
       CONSTRAINT PK_SBI_REMEMBER_ME PRIMARY KEY CLUSTERED(ID)
)ON [PRIMARY]

CREATE TABLE SBI_MENU (
       	MENU_ID 		IDENTITY(1, 1) NOT NULL,
		NAME 			VARCHAR(50), 
		DESCR 			VARCHAR(2000),
		PARENT_ID 		INTEGER DEFAULT 0, 
		BIOBJ_ID 		INTEGER,
		VIEW_ICONS 		BOOLEAN,
		HIDE_TOOLBAR 	BOOLEAN, 
		HIDE_SLIDERS 	BOOLEAN,
		STATIC_PAGE 	VARCHAR(45),
		BIOBJ_PARAMETERS TEXT NULL,
		SUBOBJ_NAME 	VARCHAR(50) NULL,
		SNAPSHOT_NAME 	VARCHAR(100) NULL,
		SNAPSHOT_HISTORY INTEGER NULL,
		FUNCTIONALITY VARCHAR(50) NULL,
		INITIAL_PATH VARCHAR(400) NULL,
		EXT_APP_URL VARCHAR(1000) NULL,
		PROG         INTEGER NOT NULL DEFAULT 1,
		CONSTRAINT PK_SBI_MENU PRIMARY KEY CLUSTERED(MENU_ID)
)ON [PRIMARY]

CREATE TABLE SBI_DATA_SET (
	DS_ID 			IDENTITY(1, 1) NOT NULL,
	DESCR 			VARCHAR(160),
	LABEL 			VARCHAR (50) NOT NULL ,
	NAME 			VARCHAR (50) NOT NULL ,
	FILE_NAME 		VARCHAR (300),
	QUERY 			VARCHAR(MAX), --CLOB
	ADRESS 			VARCHAR (250),
	EXECUTOR_CLASS 	VARCHAR (250),
	PARAMS 			VARCHAR (1000),
	DS_METADATA 	VARCHAR (2000),
	DATA_SOURCE_ID 	INTEGER,
	OBJECT_TYPE 	VARCHAR (50),
	OPERATION 		VARCHAR (250),
	JCLASS_NAME 	VARCHAR (100),
	SCRIPT 			VARCHAR (1000),
	TRANSFORMER_ID INTEGER,
    PIVOT_COLUMN   VARCHAR(50),
	PIVOT_ROW      VARCHAR(50),
	PIVOT_VALUE    VARCHAR(50),
	NUM_ROWS	   BOOLEAN DEFAULT FALSE,
	LANGUAGE_SCRIPT    VARCHAR(50),
	CONSTRAINT PK_SBI_DATA_SET PRIMARY KEY CLUSTERED(DS_ID)
)ON [PRIMARY]

CREATE TABLE SBI_EXPORTERS (
       ENGINE_ID             INTEGER NOT NULL,
       DOMAIN_ID             INTEGER NOT NULL,
       DEFAULT_VALUE         BOOLEAN NULL,
       CONSTRAINT PK_EXPORTERS PRIMARY KEY CLUSTERED(DOMAIN_ID, ENGINE_ID)
)ON [PRIMARY]

CREATE TABLE SBI_OBJ_METADATA (
	OBJ_META_ID 		INTEGER NOT NULL ,
    LABEL	 	        VARCHAR(20) NOT NULL,
    NAME 	            VARCHAR(40) NOT NULL,
    DESCRIPTION	        VARCHAR(100),  
    DATA_TYPE_ID		INTEGER NOT NULL,
    CREATION_DATE 	    datetime NOT NULL,
    CONSTRAINT PK_SBI_OBJ_METADATA PRIMARY KEY CLUSTERED(OBJ_META_ID)
)ON [PRIMARY]

CREATE TABLE SBI_OBJ_METACONTENTS (
  OBJ_METACONTENT_ID INTEGER  NOT NULL,
  OBJMETA_ID 		 INTEGER  NOT NULL ,
  BIOBJ_ID 			 INTEGER  NOT NULL,
  SUBOBJ_ID 		 INTEGER,
  BIN_ID 			 INTEGER,
  CREATION_DATE 	 datetime NOT NULL,  
  LAST_CHANGE_DATE   datetime NOT NULL,
  CONSTRAINT PK_SBI_OBJ_METACONTENTS PRIMARY KEY CLUSTERED(OBJ_METACONTENT_ID)
)ON [PRIMARY]

CREATE TABLE SBI_USER (
	USER_ID VARCHAR(100) NOT NULL,
	PASSWORD VARCHAR(150),
	FULL_NAME VARCHAR(255),
	ID INTEGER NOT NULL,
	DT_PWD_BEGIN datetime,
	DT_PWD_END datetime,
	FLG_PWD_BLOCKED BOOLEAN,
	DT_LAST_ACCESS datetime,
 	CONSTRAINT PK_SBI_USER PRIMARY KEY CLUSTERED (ID)
 )ON [PRIMARY]

CREATE TABLE SBI_ATTRIBUTE (
	ATTRIBUTE_NAME VARCHAR(255) NOT NULL,
	DESCRIPTION VARCHAR(500) NOT NULL,
	ATTRIBUTE_ID INTEGER NOT NULL,
CONSTRAINT PK_SBI_USER PRIMARY KEY CLUSTERED (ATTRIBUTE_ID)
 )ON [PRIMARY]

CREATE TABLE SBI_USER_ATTRIBUTES (
	ID INTEGER NOT NULL,
	ATTRIBUTE_ID INTEGER NOT NULL,
	ATTRIBUTE_VALUE VARCHAR(500),
CONSTRAINT PK_SBI_USER PRIMARY KEY CLUSTERED (ID,ATTRIBUTE_ID)
 )ON [PRIMARY]


CREATE TABLE SBI_EXT_USER_ROLES (
	ID INTEGER NOT NULL,
	EXT_ROLE_ID INTEGER NOT NULL,
CONSTRAINT PK_SBI_USER PRIMARY KEY CLUSTERED (ID,EXT_ROLE_ID)
 )ON [PRIMARY]
 
 CREATE TABLE SBI_KPI_ERROR (
  KPI_ERROR_ID INTEGER NOT NULL,
  KPI_MODEL_INST_ID INTEGER NOT NULL,
  USER_MSG VARCHAR(1000),
  FULL_MSG VARCHAR(MAX),
  TS_DATE TIMESTAMP ,
  LABEL_MOD_INST VARCHAR(100) ,
  PARAMETERS	 VARCHAR(1000),
  CONSTRAINT PK_SBI_KPI_ERROR PRIMARY KEY CLUSTERED (KPI_ERROR_ID)
 )ON [PRIMARY]
 
 -- Organization Unit
CREATE TABLE SBI_ORG_UNIT (
  ID            INTEGER NOT NULL,
  LABEL            VARCHAR(100) NOT NULL,
  NAME             VARCHAR(100) NOT NULL,
  DESCRIPTION      VARCHAR(1000),
  CONSTRAINT XAK1SBI_ORG_UNIT UNIQUE (LABEL),
  CONSTRAINT PK_SBI_ORG_UNIT PRIMARY KEY CLUSTERED(ID)
)ON [PRIMARY]

CREATE TABLE SBI_ORG_UNIT_HIERARCHIES (
  ID            INTEGER NOT NULL,
  LABEL            VARCHAR(200) NOT NULL,
  NAME             VARCHAR(400) NOT NULL,
  DESCRIPTION      VARCHAR(1000),
  TARGET     VARCHAR(1000),
  COMPANY    VARCHAR(200),
  CONSTRAINT XAK1SBI_ORG_UNIT_HIERARCHIES UNIQUE (LABEL),
  CONSTRAINT PK_SBI_ORG_UNIT_HIERARCHIES PRIMARY KEY CLUSTERED(ID)
)ON [PRIMARY]

CREATE TABLE SBI_ORG_UNIT_NODES (
  NODE_ID            INTEGER NOT NULL,
  OU_ID           INTEGER NOT NULL,
  HIERARCHY_ID  INTEGER NOT NULL,
  PARENT_NODE_ID INTEGER NULL,
  PATH VARCHAR(4000) NOT NULL,
  CONSTRAINT PK_SBI_ORG_UNIT_NODES PRIMARY KEY CLUSTERED(NODE_ID)
)ON [PRIMARY]

CREATE TABLE SBI_ORG_UNIT_GRANT (
  ID INTEGER NOT NULL,
  HIERARCHY_ID  INTEGER NOT NULL,
  KPI_MODEL_INST_NODE_ID INTEGER NOT NULL,
  START_DATE  datetime,
  END_DATE  datetime,
  LABEL            VARCHAR(200) NOT NULL,
  NAME             VARCHAR(400) NOT NULL,
  DESCRIPTION      VARCHAR(1000),
  CONSTRAINT XAK1SBI_ORG_UNIT_GRANT UNIQUE (LABEL),
  CONSTRAINT PK_SBI_ORG_UNIT_GRANT PRIMARY KEY CLUSTERED(ID)
)ON [PRIMARY]

CREATE TABLE SBI_ORG_UNIT_GRANT_NODES (
  NODE_ID INTEGER NOT NULL,
  KPI_MODEL_INST_NODE_ID INTEGER NOT NULL,
  GRANT_ID INTEGER NOT NULL,
  CONSTRAINT PK_SBI_ORG_UNIT_GRANT_NODES PRIMARY KEY CLUSTERED(NODE_ID, KPI_MODEL_INST_NODE_ID, GRANT_ID)
)ON [PRIMARY]




