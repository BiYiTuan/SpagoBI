ALTER TABLE SBI_ORGANIZATIONS ADD COLUMN THEME VARCHAR(100) DEFAULT 'SPAGOBI.THEMES.THEME.default';
ALTER TABLE SBI_USER ADD COLUMN IS_SUPERADMIN BOOLEAN DEFAULT FALSE;

UPDATE SBI_USER us SET us.IS_SUPERADMIN = TRUE WHERE us.ID IN(
	SELECT ur.ID FROM SBI_EXT_USER_ROLES ur WHERE ur.EXT_ROLE_ID IN( 
		SELECT role.EXT_ROLE_ID FROM SBI_EXT_ROLES role WHERE role.ROLE_TYPE_CD = 'ADMIN'
	)
);

CREATE MEMORY TABLE SBI_AUTHORIZATIONS (
  ID INTEGER NOT NULL PRIMARY KEY,
  NAME varchar(200) DEFAULT NULL,
  USER_IN varchar(100) NOT NULL,
  USER_UP varchar(100) DEFAULT NULL,
  USER_DE varchar(100) DEFAULT NULL,
  TIME_IN timestamp DEFAULT NULL,
  TIME_UP timestamp  DEFAULT NULL,
  TIME_DE timestamp  DEFAULT NULL,
  SBI_VERSION_IN varchar(10) DEFAULT NULL,
  SBI_VERSION_UP varchar(10) DEFAULT NULL,
  SBI_VERSION_DE varchar(10) DEFAULT NULL,
  META_VERSION varchar(100) DEFAULT NULL,
  ORGANIZATION varchar(20) DEFAULT NULL
) ;


CREATE MEMORY  TABLE SBI_AUTHORIZATIONS_ROLES (
  AUTHORIZATION_ID INTEGER NOT NULL,
  ROLE_ID INTEGER NOT NULL,
  USER_IN varchar(100) NOT NULL,
  USER_UP varchar(100) DEFAULT NULL,
  USER_DE varchar(100) DEFAULT NULL,
  TIME_IN timestamp  DEFAULT current_timestamp NOT NULL,
  TIME_UP timestamp  DEFAULT NULL,
  TIME_DE timestamp  DEFAULT NULL,
  SBI_VERSION_IN varchar(10) DEFAULT NULL,
  SBI_VERSION_UP varchar(10) DEFAULT NULL,
  SBI_VERSION_DE varchar(10) DEFAULT NULL,
  META_VERSION varchar(100) DEFAULT NULL,
  ORGANIZATION varchar(20) DEFAULT NULL,
  PRIMARY KEY (AUTHORIZATION_ID,ROLE_ID ),
  CONSTRAINT FK_ROLE1 FOREIGN KEY (ROLE_ID) REFERENCES SBI_EXT_ROLES (EXT_ROLE_ID) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT FK_AUTHORIZATION_1 FOREIGN KEY (AUTHORIZATION_ID) REFERENCES SBI_AUTHORIZATIONS (ID) ON DELETE NO ACTION ON UPDATE NO ACTION
  ) ;
  

CREATE MEMORY TABLE SBI_ORGANIZATION_ENGINE (
  ENGINE_ID INTEGER NOT NULL,
  ORGANIZATION_ID INTEGER NOT NULL,
  USER_IN varchar(100) NOT NULL,
  USER_UP varchar(100) DEFAULT NULL,
  USER_DE varchar(100) DEFAULT NULL,
  TIME_IN TIMESTAMP DEFAULT NULL,
  TIME_UP timestamp DEFAULT NULL,
  TIME_DE timestamp DEFAULT NULL,
  SBI_VERSION_IN varchar(10) DEFAULT NULL,
  SBI_VERSION_UP varchar(10) DEFAULT NULL,
  SBI_VERSION_DE varchar(10) DEFAULT NULL,
  META_VERSION varchar(100) DEFAULT NULL,
  ORGANIZATION varchar(20) DEFAULT NULL,
  PRIMARY KEY (ENGINE_ID,ORGANIZATION_ID ),
  CONSTRAINT FK_ENGINE_1 FOREIGN KEY (ENGINE_ID) REFERENCES SBI_ENGINES (ENGINE_ID) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT FK_ORGANIZATION_1 FOREIGN KEY (ORGANIZATION_ID) REFERENCES SBI_ORGANIZATIONS (ID) ON DELETE NO ACTION ON UPDATE NO ACTION
) ;

CREATE MEMORY TABLE SBI_ORGANIZATION_DATASOURCE (
  DATASOURCE_ID INTEGER NOT NULL,
  ORGANIZATION_ID INTEGER NOT NULL,
  USER_IN varchar(100) NOT NULL,
  USER_UP varchar(100) DEFAULT NULL,
  USER_DE varchar(100) DEFAULT NULL,
  TIME_IN timestamp DEFAULT NULL,
  TIME_UP timestamp DEFAULT NULL,
  TIME_DE timestamp DEFAULT NULL,
  SBI_VERSION_IN varchar(10) DEFAULT NULL,
  SBI_VERSION_UP varchar(10) DEFAULT NULL,
  SBI_VERSION_DE varchar(10) DEFAULT NULL,
  META_VERSION varchar(100) DEFAULT NULL,
  ORGANIZATION varchar(20) DEFAULT NULL,
  PRIMARY KEY (DATASOURCE_ID,ORGANIZATION_ID ),
  CONSTRAINT FK_DATASOURCE_2 FOREIGN KEY (DATASOURCE_ID) REFERENCES SBI_DATA_SOURCE (DS_ID) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT FK_ORGANIZATION_2 FOREIGN KEY (ORGANIZATION_ID) REFERENCES SBI_ORGANIZATIONS (ID) ON DELETE NO ACTION ON UPDATE NO ACTION
) ;


insert into hibernate_sequences (SEQUENCE_NAME, NEXT_VAL) 
values('SBI_AUTHORIZATIONS', 1);
COMMIT;
insert into hibernate_sequences (SEQUENCE_NAME, NEXT_VAL) 
values('SBI_AUTHORIZATIONS_ROLES', 1);
COMMIT;
insert into hibernate_sequences (SEQUENCE_NAME, NEXT_VAL) 
values('SBI_ORGANIZATION_ENGINE', 1);
COMMIT;
insert into hibernate_sequences (SEQUENCE_NAME, NEXT_VAL) 
values('SBI_ORGANIZATION_DATASOURCE', 1);
COMMIT;


INSERT INTO sbi_organization_datasource (DATASOURCE_ID, ORGANIZATION_ID, USER_IN, TIME_IN, SBI_VERSION_IN)
  (SELECT ds.ds_id, org.id, 'server', CURRENT_TIMESTAMP, '4.1' FROM sbi_data_source ds, sbi_organizations org WHERE ds.organization = org.name);
COMMIT;  
  
 INSERT INTO sbi_organization_engine (ENGINE_ID, ORGANIZATION_ID,  USER_IN, TIME_IN, SBI_VERSION_IN)
  (SELECT eng.engine_id, org.id, 'server', CURRENT_TIMESTAMP, '4.1' FROM sbi_engines eng, sbi_organizations org WHERE eng.organization = org.name);
 COMMIT; 
 
UPDATE SBI_OBJECTS r
SET r.ENGINE_ID = OK WHERE EXISTS (
	SELECT B.ENGINE_ID AS OK, A.ENGINE_ID AS KO
	FROM
	  (SELECT ENGINE_ID, LABEL, ORGANIZATION FROM SBI_ENGINES WHERE ORGANIZATION !='SPAGOBI') A,
	  (SELECT ENGINE_ID, LABEL, ORGANIZATION FROM SBI_ENGINES WHERE ORGANIZATION ='SPAGOBI') B
WHERE A.LABEL=B.LABEL AND r.ENGINE_ID = KO
);  
--  (SELECT ENGINE_ID, LABEL, ORGANIZATION FROM SBI_ENGINES WHERE ORGANIZATION !='SPAGOBI');   a che serve ????

DELETE FROM SBI_EXPORTERS where engine_id IN (SELECT ENGINE_ID FROM SBI_ENGINES WHERE ORGANIZATION !='SPAGOBI');
COMMIT;

DELETE from SBI_ENGINES where organization !='SPAGOBI';
COMMIT; 


INSERT INTO SBI_AUTHORIZATIONS
(ID, NAME, USER_IN, TIME_IN) 
values ((SELECT NEXT_VAL FROM hibernate_sequences WHERE SEQUENCE_NAME='SBI_AUTHORIZATIONS'), 
'SAVE_SUBOBJECTS', 
'server',  current_timestamp) ;
commit;
update hibernate_sequences set next_val = next_val+1 where sequence_name = 'SBI_AUTHORIZATIONS';
commit;

INSERT INTO SBI_AUTHORIZATIONS
(ID, NAME, USER_IN, TIME_IN) 
values ((SELECT NEXT_VAL FROM hibernate_sequences WHERE SEQUENCE_NAME='SBI_AUTHORIZATIONS'), 
'SEE_SUBOBJECTS', 
'server',  current_timestamp) ;
commit;
update hibernate_sequences set next_val = next_val+1 where sequence_name = 'SBI_AUTHORIZATIONS';
commit;

INSERT INTO SBI_AUTHORIZATIONS
(ID, NAME, USER_IN, TIME_IN) 
values ((SELECT NEXT_VAL FROM hibernate_sequences WHERE SEQUENCE_NAME='SBI_AUTHORIZATIONS'), 
'SEE_VIEWPOINTS', 
'server',  current_timestamp) ;
commit;
update hibernate_sequences set next_val = next_val+1 where sequence_name = 'SBI_AUTHORIZATIONS';
commit;


INSERT INTO SBI_AUTHORIZATIONS
(ID, NAME, USER_IN, TIME_IN) 
values ((SELECT NEXT_VAL FROM hibernate_sequences WHERE SEQUENCE_NAME='SBI_AUTHORIZATIONS'), 
'SEE_SNAPSHOTS', 
'server',  current_timestamp) ;
commit;
update hibernate_sequences set next_val = next_val+1 where sequence_name = 'SBI_AUTHORIZATIONS';
commit;

INSERT INTO SBI_AUTHORIZATIONS
(ID, NAME, USER_IN, TIME_IN) 
values ((SELECT NEXT_VAL FROM hibernate_sequences WHERE SEQUENCE_NAME='SBI_AUTHORIZATIONS'), 
'SEE_NOTES', 
'server',  current_timestamp) ;
update hibernate_sequences set next_val = next_val+1 where sequence_name = 'SBI_AUTHORIZATIONS';
commit;

INSERT INTO SBI_AUTHORIZATIONS
(ID, NAME, USER_IN, TIME_IN) 
values ((SELECT NEXT_VAL FROM hibernate_sequences WHERE SEQUENCE_NAME='SBI_AUTHORIZATIONS'), 
'SEND_MAIL', 
'server',  current_timestamp) ;
update hibernate_sequences set next_val = next_val+1 where sequence_name = 'SBI_AUTHORIZATIONS';
commit;

INSERT INTO SBI_AUTHORIZATIONS
(ID, NAME, USER_IN, TIME_IN) 
values ((SELECT NEXT_VAL FROM hibernate_sequences WHERE SEQUENCE_NAME='SBI_AUTHORIZATIONS'), 
'SAVE_INTO_FOLDER', 
'server',  current_timestamp) ;
update hibernate_sequences set next_val = next_val+1 where sequence_name = 'SBI_AUTHORIZATIONS';
commit;

INSERT INTO SBI_AUTHORIZATIONS
(ID, NAME, USER_IN, TIME_IN) 
values ((SELECT NEXT_VAL FROM hibernate_sequences WHERE SEQUENCE_NAME='SBI_AUTHORIZATIONS'), 
'SAVE_REMEMBER_ME', 
'server',  current_timestamp) ;
update hibernate_sequences set next_val = next_val+1 where sequence_name = 'SBI_AUTHORIZATIONS';
commit;

INSERT INTO SBI_AUTHORIZATIONS
(ID, NAME, USER_IN, TIME_IN) 
values ((SELECT NEXT_VAL FROM hibernate_sequences WHERE SEQUENCE_NAME='SBI_AUTHORIZATIONS'), 
'SEE_METADATA', 
'server',  current_timestamp) ;
update hibernate_sequences set next_val = next_val+1 where sequence_name = 'SBI_AUTHORIZATIONS';
commit;

INSERT INTO SBI_AUTHORIZATIONS
(ID, NAME, USER_IN, TIME_IN) 
values ((SELECT NEXT_VAL FROM hibernate_sequences WHERE SEQUENCE_NAME='SBI_AUTHORIZATIONS'), 
'SAVE_METADATA', 
'server',  current_timestamp) ;
update hibernate_sequences set next_val = next_val+1 where sequence_name = 'SBI_AUTHORIZATIONS';
commit;

INSERT INTO SBI_AUTHORIZATIONS
(ID, NAME, USER_IN, TIME_IN) 
values ((SELECT NEXT_VAL FROM hibernate_sequences WHERE SEQUENCE_NAME='SBI_AUTHORIZATIONS'), 
'BUILD_QBE_QUERY', 
'server',  current_timestamp) ;
update hibernate_sequences set next_val = next_val+1 where sequence_name = 'SBI_AUTHORIZATIONS';
commit;

INSERT INTO SBI_AUTHORIZATIONS
(ID, NAME, USER_IN, TIME_IN) 
values ((SELECT NEXT_VAL FROM hibernate_sequences WHERE SEQUENCE_NAME='SBI_AUTHORIZATIONS'), 
'DO_MASSIVE_EXPORT', 
'server',  current_timestamp) ;
update hibernate_sequences set next_val = next_val+1 where sequence_name = 'SBI_AUTHORIZATIONS';
commit;

INSERT INTO SBI_AUTHORIZATIONS
(ID, NAME, USER_IN, TIME_IN) 
values ((SELECT NEXT_VAL FROM hibernate_sequences WHERE SEQUENCE_NAME='SBI_AUTHORIZATIONS'), 
'EDIT_WORKSHEET', 
'server',  current_timestamp) ;
update hibernate_sequences set next_val = next_val+1 where sequence_name = 'SBI_AUTHORIZATIONS';
commit;


INSERT INTO SBI_AUTHORIZATIONS
(ID, NAME, USER_IN, TIME_IN) 
values ((SELECT NEXT_VAL FROM hibernate_sequences WHERE SEQUENCE_NAME='SBI_AUTHORIZATIONS'), 
'MANAGE_USERS', 
'server',  current_timestamp) ;
update hibernate_sequences set next_val = next_val+1 where sequence_name = 'SBI_AUTHORIZATIONS';
commit;

INSERT INTO SBI_AUTHORIZATIONS
(ID, NAME, USER_IN, TIME_IN) 
values ((SELECT NEXT_VAL FROM hibernate_sequences WHERE SEQUENCE_NAME='SBI_AUTHORIZATIONS'), 
'SEE_DOCUMENT_BROWSER', 
'server',  current_timestamp) ;
update hibernate_sequences set next_val = next_val+1 where sequence_name = 'SBI_AUTHORIZATIONS';
commit;

INSERT INTO SBI_AUTHORIZATIONS
(ID, NAME, USER_IN, TIME_IN) 
values ((SELECT NEXT_VAL FROM hibernate_sequences WHERE SEQUENCE_NAME='SBI_AUTHORIZATIONS'), 
'SEE_FAVOURITES', 
'server',  current_timestamp) ;
update hibernate_sequences set next_val = next_val+1 where sequence_name = 'SBI_AUTHORIZATIONS';
commit;

INSERT INTO SBI_AUTHORIZATIONS
(ID, NAME, USER_IN, TIME_IN) 
values ((SELECT NEXT_VAL FROM hibernate_sequences WHERE SEQUENCE_NAME='SBI_AUTHORIZATIONS'), 
'SEE_SUBSCRIPTIONS', 
'server',  current_timestamp) ;
update hibernate_sequences set next_val = next_val+1 where sequence_name = 'SBI_AUTHORIZATIONS';
commit;


INSERT INTO SBI_AUTHORIZATIONS
(ID, NAME, USER_IN, TIME_IN) 
values ((SELECT NEXT_VAL FROM hibernate_sequences WHERE SEQUENCE_NAME='SBI_AUTHORIZATIONS'), 
'SEE_MY_DATA', 
'server',  current_timestamp) ;
update hibernate_sequences set next_val = next_val+1 where sequence_name = 'SBI_AUTHORIZATIONS';
commit;


INSERT INTO SBI_AUTHORIZATIONS
(ID, NAME, USER_IN, TIME_IN) 
values ((SELECT NEXT_VAL FROM hibernate_sequences WHERE SEQUENCE_NAME='SBI_AUTHORIZATIONS'), 
'SEE_TODO_LIST', 
'server',  current_timestamp) ;
update hibernate_sequences set next_val = next_val+1 where sequence_name = 'SBI_AUTHORIZATIONS';
commit;



INSERT INTO SBI_AUTHORIZATIONS
(ID, NAME, USER_IN, TIME_IN) 
values ((SELECT NEXT_VAL FROM hibernate_sequences WHERE SEQUENCE_NAME='SBI_AUTHORIZATIONS'), 
'CREATE_DOCUMENTS', 
'server',  current_timestamp) ;
update hibernate_sequences set next_val = next_val+1 where sequence_name = 'SBI_AUTHORIZATIONS';
commit;


-------------------
INSERT INTO SBI_AUTHORIZATIONS_ROLES 
(AUTHORIZATION_ID, ROLE_ID, ORGANIZATION, TIME_IN, USER_IN) 
SELECT (SELECT ID FROM SBI_AUTHORIZATIONS WHERE NAME= 'SAVE_SUBOBJECTS') F ,
D.EXT_ROLE_ID, 
D.ORGANIZATION, 
CURRENT_TIMESTAMP, 'server' FROM SBI_EXT_ROLES D WHERE D.SAVE_SUBOBJECTS =1;

INSERT INTO SBI_AUTHORIZATIONS_ROLES 
(AUTHORIZATION_ID, ROLE_ID, ORGANIZATION, TIME_IN, USER_IN) 
SELECT (SELECT ID FROM SBI_AUTHORIZATIONS WHERE NAME= 'CREATE_DOCUMENTS') F ,
D.EXT_ROLE_ID, 
D.ORGANIZATION, 
CURRENT_TIMESTAMP, 'server' FROM SBI_EXT_ROLES D WHERE D.CREATE_DOCUMENTS =1;
INSERT INTO SBI_AUTHORIZATIONS_ROLES 
(AUTHORIZATION_ID, ROLE_ID, ORGANIZATION, TIME_IN, USER_IN) 
SELECT (SELECT ID FROM SBI_AUTHORIZATIONS WHERE NAME= 'SEE_SUBOBJECTS') F ,
D.EXT_ROLE_ID, 
D.ORGANIZATION, 
CURRENT_TIMESTAMP, 'server' FROM SBI_EXT_ROLES D WHERE D.SEE_SUBOBJECTS =1;
INSERT INTO SBI_AUTHORIZATIONS_ROLES 
(AUTHORIZATION_ID, ROLE_ID, ORGANIZATION, TIME_IN, USER_IN) 
SELECT (SELECT ID FROM SBI_AUTHORIZATIONS WHERE NAME= 'SEE_VIEWPOINTS') F ,
D.EXT_ROLE_ID, 
D.ORGANIZATION, 
CURRENT_TIMESTAMP, 'server' FROM SBI_EXT_ROLES D WHERE D.SEE_VIEWPOINTS =1;
INSERT INTO SBI_AUTHORIZATIONS_ROLES 
(AUTHORIZATION_ID, ROLE_ID, ORGANIZATION, TIME_IN, USER_IN) 
SELECT (SELECT ID FROM SBI_AUTHORIZATIONS WHERE NAME= 'SEE_SNAPSHOTS') F ,
D.EXT_ROLE_ID, 
D.ORGANIZATION, 
CURRENT_TIMESTAMP, 'server' FROM SBI_EXT_ROLES D WHERE D.SEE_SNAPSHOTS =1;
INSERT INTO SBI_AUTHORIZATIONS_ROLES 
(AUTHORIZATION_ID, ROLE_ID, ORGANIZATION, TIME_IN, USER_IN) 
SELECT (SELECT ID FROM SBI_AUTHORIZATIONS WHERE NAME= 'SEE_NOTES') F ,
D.EXT_ROLE_ID, 
D.ORGANIZATION, 
CURRENT_TIMESTAMP, 'server' FROM SBI_EXT_ROLES D WHERE D.SEE_NOTES =1;
INSERT INTO SBI_AUTHORIZATIONS_ROLES 
(AUTHORIZATION_ID, ROLE_ID, ORGANIZATION, TIME_IN, USER_IN) 
SELECT (SELECT ID FROM SBI_AUTHORIZATIONS WHERE NAME= 'SEND_MAIL') F ,
D.EXT_ROLE_ID, 
D.ORGANIZATION, 
CURRENT_TIMESTAMP, 'server' FROM SBI_EXT_ROLES D WHERE D.SEND_MAIL =1;
INSERT INTO SBI_AUTHORIZATIONS_ROLES 
(AUTHORIZATION_ID, ROLE_ID, ORGANIZATION, TIME_IN, USER_IN) 
SELECT (SELECT ID FROM SBI_AUTHORIZATIONS WHERE NAME= 'SAVE_INTO_FOLDER') F ,
D.EXT_ROLE_ID, 
D.ORGANIZATION, 
CURRENT_TIMESTAMP, 'server' FROM SBI_EXT_ROLES D WHERE D.SAVE_INTO_FOLDER =1;
INSERT INTO SBI_AUTHORIZATIONS_ROLES
(AUTHORIZATION_ID, ROLE_ID, ORGANIZATION, TIME_IN, USER_IN) 
SELECT (SELECT ID FROM SBI_AUTHORIZATIONS WHERE NAME= 'SAVE_REMEMBER_ME') F ,
D.EXT_ROLE_ID, 
D.ORGANIZATION, 
CURRENT_TIMESTAMP, 'server' FROM SBI_EXT_ROLES D WHERE D.SAVE_REMEMBER_ME =1;
INSERT INTO SBI_AUTHORIZATIONS_ROLES 
(AUTHORIZATION_ID, ROLE_ID, ORGANIZATION, TIME_IN, USER_IN) 
SELECT (SELECT ID FROM SBI_AUTHORIZATIONS WHERE NAME= 'SEE_METADATA') F ,
D.EXT_ROLE_ID, 
D.ORGANIZATION, 
CURRENT_TIMESTAMP, 'server' FROM SBI_EXT_ROLES D WHERE D.SEE_METADATA =1;
INSERT INTO SBI_AUTHORIZATIONS_ROLES 
(AUTHORIZATION_ID, ROLE_ID, ORGANIZATION, TIME_IN, USER_IN) 
SELECT (SELECT ID FROM SBI_AUTHORIZATIONS WHERE NAME= 'SAVE_METADATA') F ,
D.EXT_ROLE_ID, 
D.ORGANIZATION, 
CURRENT_TIMESTAMP, 'server' FROM SBI_EXT_ROLES D WHERE D.SAVE_METADATA =1;
INSERT INTO SBI_AUTHORIZATIONS_ROLES 
(AUTHORIZATION_ID, ROLE_ID, ORGANIZATION, TIME_IN, USER_IN) 
SELECT (SELECT ID FROM SBI_AUTHORIZATIONS WHERE NAME= 'BUILD_QBE_QUERY') F ,
D.EXT_ROLE_ID, 
D.ORGANIZATION, 
CURRENT_TIMESTAMP, 'server' FROM SBI_EXT_ROLES D WHERE D.BUILD_QBE_QUERY =1;
INSERT INTO SBI_AUTHORIZATIONS_ROLES 
(AUTHORIZATION_ID, ROLE_ID, ORGANIZATION, TIME_IN, USER_IN) 
SELECT (SELECT ID FROM SBI_AUTHORIZATIONS WHERE NAME= 'DO_MASSIVE_EXPORT') F ,
D.EXT_ROLE_ID, 
D.ORGANIZATION, 
CURRENT_TIMESTAMP, 'server' FROM SBI_EXT_ROLES D WHERE D.DO_MASSIVE_EXPORT =1;
INSERT INTO SBI_AUTHORIZATIONS_ROLES 
(AUTHORIZATION_ID, ROLE_ID, ORGANIZATION, TIME_IN, USER_IN) 
SELECT (SELECT ID FROM SBI_AUTHORIZATIONS WHERE NAME= 'EDIT_WORKSHEET') F ,
D.EXT_ROLE_ID, 
D.ORGANIZATION, 
CURRENT_TIMESTAMP, 'server' FROM SBI_EXT_ROLES D WHERE D.EDIT_WORKSHEET =1;
INSERT INTO SBI_AUTHORIZATIONS_ROLES 
(AUTHORIZATION_ID, ROLE_ID, ORGANIZATION, TIME_IN, USER_IN) 
SELECT (SELECT ID FROM SBI_AUTHORIZATIONS WHERE NAME= 'MANAGE_USERS') F ,
D.EXT_ROLE_ID, 
D.ORGANIZATION, 
CURRENT_TIMESTAMP, 'server' FROM SBI_EXT_ROLES D WHERE D.MANAGE_USERS =1;
INSERT INTO SBI_AUTHORIZATIONS_ROLES 
(AUTHORIZATION_ID, ROLE_ID, ORGANIZATION, TIME_IN, USER_IN) 
SELECT (SELECT ID FROM SBI_AUTHORIZATIONS WHERE NAME= 'SEE_DOCUMENT_BROWSER') F ,
D.EXT_ROLE_ID, 
D.ORGANIZATION, 
CURRENT_TIMESTAMP, 'server' FROM SBI_EXT_ROLES D WHERE D.SEE_DOCUMENT_BROWSER =1;
INSERT INTO SBI_AUTHORIZATIONS_ROLES 
(AUTHORIZATION_ID, ROLE_ID, ORGANIZATION, TIME_IN, USER_IN) 
SELECT (SELECT ID FROM SBI_AUTHORIZATIONS WHERE NAME= 'SEE_FAVOURITES') F ,
D.EXT_ROLE_ID, 
D.ORGANIZATION, 
CURRENT_TIMESTAMP, 'server' FROM SBI_EXT_ROLES D WHERE D.SEE_FAVOURITES =1;
INSERT INTO SBI_AUTHORIZATIONS_ROLES 
(AUTHORIZATION_ID, ROLE_ID, ORGANIZATION, TIME_IN, USER_IN) 
SELECT (SELECT ID FROM SBI_AUTHORIZATIONS WHERE NAME= 'SEE_SUBSCRIPTIONS') F ,
D.EXT_ROLE_ID, 
D.ORGANIZATION, 
CURRENT_TIMESTAMP, 'server' FROM SBI_EXT_ROLES D WHERE D.SEE_SUBSCRIPTIONS =1;
INSERT INTO SBI_AUTHORIZATIONS_ROLES 
(AUTHORIZATION_ID, ROLE_ID, ORGANIZATION, TIME_IN, USER_IN) 
SELECT (SELECT ID FROM SBI_AUTHORIZATIONS WHERE NAME= 'SEE_MY_DATA') F ,
D.EXT_ROLE_ID, 
D.ORGANIZATION, 
CURRENT_TIMESTAMP, 'server' FROM SBI_EXT_ROLES D WHERE D.SEE_MY_DATA =1;
INSERT INTO SBI_AUTHORIZATIONS_ROLES 
(AUTHORIZATION_ID, ROLE_ID, ORGANIZATION, TIME_IN, USER_IN) 
SELECT (SELECT ID FROM SBI_AUTHORIZATIONS WHERE NAME= 'SEE_TODO_LIST') F ,
D.EXT_ROLE_ID, 
D.ORGANIZATION, 
CURRENT_TIMESTAMP, 'server' FROM SBI_EXT_ROLES D WHERE D.SEE_TODO_LIST =1;

---------------------

UPDATE SBI_ENGINES SET DRIVER_NM = 'it.eng.spagobi.engines.drivers.gis.GisDriver' 
		WHERE DRIVER_NM = 'it.eng.spagobi.engines.drivers.generic.GenericDriver' 
		AND BIOBJ_TYPE IN (SELECT VALUE_ID FROM SBI_DOMAINS WHERE DOMAIN_CD = 'BIOBJ_TYPE' AND VALUE_CD = 'MAP'); 
COMMIT;

ALTER TABLE SBI_EXT_ROLES DROP COLUMN SAVE_SUBOBJECTS;
ALTER TABLE SBI_EXT_ROLES DROP COLUMN SEE_SUBOBJECTS;
ALTER TABLE SBI_EXT_ROLES DROP COLUMN  SEE_VIEWPOINTS;
ALTER TABLE SBI_EXT_ROLES DROP COLUMN  SEE_SNAPSHOTS;
ALTER TABLE SBI_EXT_ROLES DROP COLUMN  SEE_NOTES;
ALTER TABLE SBI_EXT_ROLES DROP COLUMN  SEND_MAIL;
ALTER TABLE SBI_EXT_ROLES DROP COLUMN  SAVE_INTO_FOLDER;
ALTER TABLE SBI_EXT_ROLES DROP COLUMN  SAVE_REMEMBER_ME;
ALTER TABLE SBI_EXT_ROLES DROP COLUMN  SEE_METADATA; 
ALTER TABLE SBI_EXT_ROLES DROP COLUMN SAVE_METADATA;
ALTER TABLE SBI_EXT_ROLES DROP COLUMN  BUILD_QBE_QUERY;
ALTER TABLE SBI_EXT_ROLES DROP COLUMN  DO_MASSIVE_EXPORT;
ALTER TABLE SBI_EXT_ROLES DROP COLUMN  EDIT_WORKSHEET;
ALTER TABLE SBI_EXT_ROLES DROP COLUMN  MANAGE_USERS;
ALTER TABLE SBI_EXT_ROLES DROP COLUMN  SEE_DOCUMENT_BROWSER;
ALTER TABLE SBI_EXT_ROLES DROP COLUMN  SEE_FAVOURITES;
ALTER TABLE SBI_EXT_ROLES DROP COLUMN  SEE_SUBSCRIPTIONS;
ALTER TABLE SBI_EXT_ROLES DROP COLUMN  SEE_MY_DATA;
ALTER TABLE SBI_EXT_ROLES DROP COLUMN  SEE_TODO_LIST;
ALTER TABLE SBI_EXT_ROLES DROP COLUMN  CREATE_DOCUMENTS;

commit;

INSERT INTO SBI_AUTHORIZATIONS
(ID, NAME, USER_IN, TIME_IN) 
values ((SELECT NEXT_VAL FROM hibernate_sequences WHERE SEQUENCE_NAME='SBI_AUTHORIZATIONS'), 
'KPI_COMMENT_EDIT_ALL', 
'server',CURRENT_TIMESTAMP) ;
update hibernate_sequences set next_val = next_val+1 where sequence_name = 'SBI_AUTHORIZATIONS';
commit;
INSERT INTO SBI_AUTHORIZATIONS
(ID, NAME, USER_IN, TIME_IN) 
values ((SELECT NEXT_VAL FROM hibernate_sequences WHERE SEQUENCE_NAME='SBI_AUTHORIZATIONS'), 
'KPI_COMMENT_EDIT_MY', 
'server',CURRENT_TIMESTAMP) ;
update hibernate_sequences set next_val = next_val+1 where sequence_name = 'SBI_AUTHORIZATIONS';
commit;
INSERT INTO SBI_AUTHORIZATIONS
(ID, NAME, USER_IN, TIME_IN) 
values ((SELECT NEXT_VAL FROM hibernate_sequences WHERE SEQUENCE_NAME='SBI_AUTHORIZATIONS'), 
'KPI_COMMENT_DELETE', 
'server',CURRENT_TIMESTAMP) ;
update hibernate_sequences set next_val = next_val+1 where sequence_name = 'SBI_AUTHORIZATIONS';
commit;


--27/01/2014: Added SpagoBICockpitEngine configuration
INSERT INTO sbi_engines
(ENGINE_ID,ENCRYPT,NAME,DESCR,MAIN_URL,SECN_URL,OBJ_UPL_DIR,OBJ_USE_DIR,DRIVER_NM,LABEL,ENGINE_TYPE,CLASS_NM,BIOBJ_TYPE,USE_DATASET,USE_DATASOURCE,USER_IN,USER_UP,USER_DE,TIME_IN,
TIME_UP,TIME_DE,SBI_VERSION_IN,SBI_VERSION_UP,SBI_VERSION_DE,META_VERSION,ORGANIZATION)
VALUES ((SELECT next_val FROM hibernate_sequences WHERE sequence_name = 'SBI_ENGINES'), 0, 'Cockpit Engine', 'Cockpit Engine', '/SpagoBICockpitEngine/CockpitEngineStartAction', NULL, NULL, NULL, 'it.eng.spagobi.engines.drivers.cockpit.CockpitDriver', 'SpagoBICockpitEngine', (SELECT VALUE_ID FROM SBI_DOMAINS WHERE DOMAIN_CD = 'ENGINE_TYPE' AND VALUE_CD = 'EXT'), '',(SELECT VALUE_ID FROM SBI_DOMAINS WHERE DOMAIN_CD = 'BIOBJ_TYPE' AND VALUE_CD = 'DOCUMENT_COMPOSITE'), false, false, 'database', 'biadmin', NULL, '2014-01-09 00:00:00', '2014-01-09 00:00:00', NULL, '4.1', '4.1', NULL, NULL, 'SPAGOBI');
update hibernate_sequences set next_val = next_val+1 where sequence_name = 'SBI_ENGINES';
commit;
INSERT INTO SBI_ORGANIZATION_ENGINE (ENGINE_ID, ORGANIZATION_ID, CREATION_DATE, LAST_CHANGE_DATE, USER_IN, TIME_IN, SBI_VERSION_IN)
values((SELECT engine_id from SBI_ENGINES where label='SpagoBICockpitEngine'), (select id from SBI_ORGANIZATIONS where name = 'SPAGOBI'),
CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'server', CURRENT_TIMESTAMP, '4.1');
COMMIT;

update SBI_ENGINES SET DRIVER_NM = 'it.eng.spagobi.engines.drivers.xmla.XMLADriver' where label = 'XMLAEngine';
commit;