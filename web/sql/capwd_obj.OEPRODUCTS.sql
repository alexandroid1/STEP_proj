BEGIN
    DECLARE V_ERRMSG CHAR(999) DEFAULT '';
    DECLARE V_TYPEID DEC(9, 0) DEFAULT 0;
    DECLARE V_SEQID DEC(9, 0) DEFAULT 0;
    DECLARE V_PRODID DEC(9, 0) DEFAULT 0;
    DECLARE V_PRODUOM DEC(9, 0) DEFAULT 0;
    DECLARE V_INDEXSTR DEC(9, 0) DEFAULT 0;
    DECLARE V_INDEXEND DEC(9, 0) DEFAULT 0;
    DECLARE V_INDEX DEC(9, 0) DEFAULT 0;
    DECLARE V_STOREID DEC(15, 0) DEFAULT 0;
    DECLARE V_TOTSTK DEC(9, 0) DEFAULT 0;
--if showStkOnly=Y,v_index=v_totStk
    DECLARE V_MMTYPEID DEC(9, 0) DEFAULT 0;
    DECLARE V_MMTYPEIDC CHAR(2) DEFAULT '';
    DECLARE V_ITEMCOUNT INT DEFAULT 0;
    DECLARE V_CATENAME VARCHAR(300) DEFAULT '';
    DECLARE V_SEARCHSTR VARCHAR(100) DEFAULT '';
    DECLARE V_ATEND CHAR(1) DEFAULT '';
    DECLARE V_CALLFROM CHAR(3) DEFAULT '';
--srchBy + isLikeSrch
    DECLARE V_CATEPATH VARCHAR(255) DEFAULT '';
    DECLARE V_CATEPATH1 VARCHAR(255) DEFAULT '';
--for return
    DECLARE V_LSTORDRID DEC(9, 0) DEFAULT 0;
    DECLARE V_GETPRC CHAR(1) DEFAULT '';
    DECLARE V_GETQTY CHAR(1) DEFAULT '';
    DECLARE V_DOCDATE DATE;
    DECLARE V_AVBQTY DEC(15, 6) DEFAULT 0;
-- for unit price API
    DECLARE V_DIRSHIP CHAR(1) DEFAULT 'N';
    DECLARE V_ZEROID DEC(9, 0) DEFAULT 0;
    DECLARE V_PRICE DEC(21, 6) DEFAULT 0;
    DECLARE V_PRICEUOM DEC(9, 0) DEFAULT 0;
    DECLARE V_ORGPRICE DEC(21, 6) DEFAULT 0;
    DECLARE V_BRKMINAMT DEC(21, 6) DEFAULT 0;
    DECLARE V_BRKMINQTY DEC(15, 6) DEFAULT 0;
    DECLARE V_BRKPCT DEC(07, 4) DEFAULT 0;
    DECLARE V_BRKAMT DEC(21, 6) DEFAULT 0;
    DECLARE V_PRICEORG CHAR(1) DEFAULT '';
    DECLARE V_SPAID DEC(9, 0) DEFAULT 0;
    DECLARE V_SPAPRICE DEC(21, 6) DEFAULT 0;
    DECLARE V_COSTTYPE CHAR(1) DEFAULT '';
    DECLARE V_PRODCOST DEC(21, 6) DEFAULT 0;
    DECLARE V_PURCHCOST DEC(21, 6) DEFAULT 0;
    DECLARE V_SYSGM DEC(15, 6) DEFAULT 0;
    DECLARE V_LINEGM DEC(15, 6) DEFAULT 0;
    DECLARE V_SELLTOPRC DEC(15, 6) DEFAULT 0;
    DECLARE V_QTYORD DEC(15, 6) DEFAULT 1;
    DECLARE V_HASPRCBRK CHAR(1) DEFAULT '';
    DECLARE V_FORMULAID DEC(9, 0) DEFAULT 0;
    DECLARE V_PARAMID DEC(9, 0) DEFAULT 0;
    DECLARE V_BRKFROM CHAR(2) DEFAULT '';
    DECLARE V_WHMEMO CHAR(255) DEFAULT '';
    DECLARE V_LOCKPRC CHAR(1) DEFAULT '';
    DECLARE V_OPRICE DEC(21, 6) DEFAULT 0;
-- Return blank search result
    DECLARE CURDUMMY INSENSITIVE CURSOR WITH RETURN FOR
        SELECT * FROM SYSIBM/SYSDUMMY1 WHERE IBMREQD = '';
/* return search result */
    DECLARE CURLIST INSENSITIVE CURSOR WITH RETURN FOR
        SELECT
            WKPRODID,
            TRIM(COALESCE(BRNAME, '')),
            TRIM(PRMFGCAT),
            TRIM(PRDISPLAY),
            PRMINSLQTY,
            PRSLINCQTY,
            TRIM(COALESCE(M1.MENAME, '')),
            OECHKAVBF(WKCOMPANY, WKPRODID),
            PRUOMSELL,
            WDPRDIMGF(WKCOMPANY, WKPRODID,
                      V_MMTYPEID),
            WKAVBQTY,
            WKPRICE,
            TRIM(COALESCE(M2.MENAME, '')),
            WKPRCUOM
        FROM
            QTEMP / WKPRDSRCH JOIN PWDPRODUCT ON ( WKCOMPANY = PRCOMPANY AND WKPRODID = PRPRODID ) LEFT JOIN PWDMEASURE M1 ON ( WKCOMPANY = M1.MECOMPANY AND PRUOMSELL = M1. MEUOMIDID ) LEFT JOIN PWDMEASURE M2 ON ( WKCOMPANY = M2.MECOMPANY AND WKPRCUOM = M2. MEUOMIDID ) LEFT JOIN PWDBRAND ON ( WKCOMPANY = BRCOMPANY AND PRBRANDID = BRBRANDID ) WHERE WKCOMPANY = COMPANYID ORDER BY WKSEQID;
-- Return info
    DECLARE CURINFO INSENSITIVE CURSOR WITH RETURN FOR SELECT
                                                           V_CATEPATH1,
                                                           V_CATENAME,
                                                           V_ITEMCOUNT,
                                                           V_LSTORDRID,
                                                           V_INDEX,
                                                           V_GETPRC,
                                                           V_GETQTY
                                                       FROM SYSIBM / SYSDUMMY1;
-- Return order list
    DECLARE CURORDER INSENSITIVE CURSOR WITH RETURN FOR SELECT
                                                            EOORDERID,
                                                            TRIM(EOCSTPO) || '-' || TRIM(EOCSTPOREL)
                                                        FROM POESLORD
                                                        WHERE EOCOMPANY = COMPANYID AND EOCUSTOMID = CUSTEID AND
                                                              EOCONTEID = CONTEID AND EOSTATUS = ''
                                                        ORDER BY EOCSTPO, EOCSTPOREL;
/* search prod by ID */ DECLARE CURPRODID INSENSITIVE CURSOR FOR SELECT DISTINCT
                                                                     PIPRODID,
                                                                     PRUOMSELL,
                                                                     PICODE
                                                                 FROM PWDPRODID
                                                                     JOIN PWDPRODUCT
                                                                         ON (PRCOMPANY = PICOMPANY AND
                                                                             PRPRODID = PIPRODID)
                                                                 WHERE PICOMPANY = COMPANYID AND PITYPE <> '04' AND
                                                                       PRACTIVE = 'Y' AND
                                                                       UPPER(PINSPLCODE) = V_SEARCHSTR
                                                                 ORDER BY
                                                                     PICODE FOR READ ONLY OPTIMIZE FOR 60 ROWS WITH NC;
/* search prod by ID, like search */ DECLARE CURPRODIDLK INSENSITIVE CURSOR FOR SELECT DISTINCT
                                                                                    PIPRODID,
                                                                                    PRUOMSELL,
                                                                                    PICODE
                                                                                FROM PWDPRODID
                                                                                    JOIN PWDPRODUCT
                                                                                        ON (PRCOMPANY = PICOMPANY AND
                                                                                            PRPRODID = PIPRODID)
                                                                                WHERE PICOMPANY = COMPANYID AND
                                                                                      PITYPE <> '04' AND PRACTIVE = 'Y'
                                                                                      AND
                                                                                      UPPER(PINSPLCODE) LIKE V_SEARCHSTR
                                                                                ORDER BY
                                                                                    PICODE FOR READ ONLY OPTIMIZE FOR 60 ROWS WITH NC;
/* search prod by Cust Part# */ DECLARE CURPRODCSTPRT INSENSITIVE CURSOR FOR SELECT
                                                                                 PIPRODID,
                                                                                 PRUOMSELL
                                                                             FROM PWDPRODID
                                                                                 JOIN PWDPRODUCT
                                                                                     ON (PRCOMPANY = PICOMPANY AND
                                                                                         PRPRODID = PIPRODID)
                                                                             WHERE
                                                                                 PICOMPANY = COMPANYID AND PITYPE = '04'
                                                                                 AND PRACTIVE = 'Y' AND
                                                                                 PIENTITYID = CUSTEID AND
                                                                                 UPPER(PINSPLCODE) = V_SEARCHSTR
                                                                             ORDER BY
                                                                                 PICODE FOR READ ONLY OPTIMIZE FOR 60 ROWS WITH NC;
/* search prod by Cust Part#, like search */ DECLARE CURPRODCSTPRTLK INSENSITIVE CURSOR FOR SELECT
                                                                                                PIPRODID,
                                                                                                PRUOMSELL
                                                                                            FROM PWDPRODID
                                                                                                JOIN PWDPRODUCT ON (
                                                                                                    PRCOMPANY =
                                                                                                    PICOMPANY
                                                                                                    AND
                                                                                                    PRPRODID = PIPRODID)
                                                                                            WHERE
                                                                                                PICOMPANY = COMPANYID
                                                                                                AND
                                                                                                PITYPE = '04' AND
                                                                                                PRACTIVE = 'Y' AND
                                                                                                PIENTITYID = CUSTEID AND
                                                                                                UPPER(PINSPLCODE) LIKE
                                                                                                V_SEARCHSTR
                                                                                            ORDER BY
                                                                                                PICODE FOR READ ONLY OPTIMIZE FOR 60 ROWS WITH NC;
/* search prod by Category */ DECLARE CURPRODCATEGORY INSENSITIVE CURSOR FOR SELECT
                                                                                 PRPRODID,
                                                                                 PRUOMSELL
                                                                             FROM PWDCTGPROD
                                                                                 JOIN PWDPRODUCT ON (
                                                                                     PRCOMPANY = PPCOMPANY AND
                                                                                     PRPRODID = PPPRODID AND
                                                                                     PRACTIVE = 'Y')
                                                                             WHERE PPCOMPANY = COMPANYID AND
                                                                                   PPCATGRYID IN (SELECT CTCATGRYID
                                                                                                  FROM PWDCATGRY
                                                                                                  WHERE CTCOMPANY =
                                                                                                        COMPANYID AND
                                                                                                        CTGTYPID =
                                                                                                        V_TYPEID AND
                                                                                                        CTCATPATH LIKE
                                                                                                        V_CATEPATH) FOR READ ONLY OPTIMIZE FOR 60 ROWS WITH NC;
/* search prod by Brand */ DECLARE CURPRODBRAND INSENSITIVE CURSOR FOR SELECT
                                                                           PRPRODID,
                                                                           PRUOMSELL
                                                                       FROM PWDPRODUCT
                                                                       WHERE PRCOMPANY = COMPANYID AND
                                                                             PRBRANDID = CATEGORYID AND PRACTIVE =
                                                                                                        'Y' FOR READ ONLY OPTIMIZE FOR 60 ROWS WITH NC;
/* search prod by keyword, like search */ DECLARE CURKEYWORD INSENSITIVE CURSOR FOR SELECT
                                                                                        PRPRODID,
                                                                                        PRUOMSELL
                                                                                    FROM PWDPRODUCT
                                                                                    WHERE PRCOMPANY = COMPANYID AND
                                                                                          PRACTIVE = 'Y' AND
                                                                                          UPPER(PRLNGDESC) LIKE
                                                                                          V_SEARCHSTR
                                                                                    ORDER BY
                                                                                        PRMFGCAT FOR READ ONLY OPTIMIZE FOR 60 ROWS WITH NC;
-- Handler to empty tables when table already exist
DECLARE CONTINUE HANDLER FOR SQLSTATE '42710' DELETE FROM QTEMP / WKPRDSRCH;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET V_ATEND = 'Y';
DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN GET DIAGNOSTICS EXCEPTION 1 ERRMSG = MESSAGE_TEXT;
    SET FLAG = 'F';
    SET ERRMSG = 'OEPRODUCTS failed! ' || SUBSTR(ERRMSG, 1, 50);
END;
SET FLAG = '';
SET ERRMSG = '';
IF SEARCHBY = 'KW'
THEN SET ISLIKESEARCH = 'Y'; END IF;
/* count item */ SELECT COUNT(*)
                 INTO V_ITEMCOUNT
                 FROM POESLORDLN
                 WHERE ELCOMPANY = COMPANYID AND ELCONTEID = CONTEID AND ELCUSTEID = CUSTEID AND ELSTATUS = '';
IF SEARCHBY = ''
THEN OPEN CURDUMMY;
    OPEN CURINFO;
    OPEN CURORDER;
    RETURN; END IF;
/* create work file for prod search */ DECLARE GLOBAL TEMPORARY TABLE SESSION / WKPRDSRCH LIKE WKPRDSRCH INCLUDING IDENTITY NOT LOGGED;
--ON COMMIT DELETE ROWS WITH REPLACE;
-- read prod template setup
SELECT
    PTSHOWPRC,
    PTSHOWSTK
INTO V_GETPRC, V_GETQTY
FROM PWDPRDTMPL
WHERE PTCOMPANY = COMPANYID;
SET V_INDEXSTR = (PAGENUM - 1) * PAGESIZE;
SET V_INDEXEND = PAGENUM * PAGESIZE;
-- include one extra for nextBtn
IF SEARCHBY = 'CT'
THEN /* get search category type */ IF DEFCAT = 'Y'
THEN SELECT CTGTYPID
     INTO V_TYPEID
     FROM PWDCATGRY
     WHERE CTCOMPANY = COMPANYID AND CTCATGRYID = CATEGORYID;
ELSE SELECT PCCTGTYPID
     INTO V_TYPEID
     FROM PWDCTGTYP
     WHERE PCCOMPANY = COMPANYID AND PCISDFSRCH = 'Y'; END IF;
    SET V_CALLFROM = SEARCHBY;
/* get category path */ SELECT TRIM(CTCATPATH)
                        INTO V_CATEPATH
                        FROM PWDCATGRY
                        WHERE CTCOMPANY = COMPANYID AND CTCATGRYID = CATEGORYID;
    SET V_CATEPATH1 = V_CATEPATH;
    SET V_CATEPATH = TRIM(V_CATEPATH) || '%';
/* get category full name */ SET V_CATENAME = WDCATENMF(COMPANYID, CATEGORYID);
    SELECT EOORDERID
    INTO V_LSTORDRID
    FROM POESLORD
    WHERE EOCOMPANY = COMPANYID AND EOCUSTOMID = CUSTEID AND EOCONTEID = CONTEID AND EOSTATUS = ''
    ORDER BY EOORDERID DESC
    FETCH FIRST 1 ROW ONLY;
ELSE IF SEARCHBY = 'BR'
THEN SET V_CALLFROM = SEARCHBY;
-- get brand name
    SELECT TRIM(BRNAME)
    INTO V_CATENAME
    FROM PWDBRAND
    WHERE BRCOMPANY = COMPANYID AND BRBRANDID = CATEGORYID;
ELSE SET V_CALLFROM = SEARCHBY || ISLIKESEARCH; END IF;
    SET V_SEARCHSTR = UPPER(SEARCHSTR);
    IF ISLIKESEARCH = 'Y'
    THEN SET V_SEARCHSTR = '%' || V_SEARCHSTR || '%'; END IF; END IF;
/* CT=category             UP=(upc),     MC=(Mfr. catalog)       CP=(cust Prt),       KW=(Keyword)     BR=brand   */ CASE V_CALLFROM
    WHEN 'IDN'
    THEN OPEN CURPRODID;
    WHEN 'IDY'
    THEN OPEN CURPRODIDLK;
    WHEN 'CPN'
    THEN OPEN CURPRODCSTPRT;
    WHEN 'CPY'
    THEN OPEN CURPRODCSTPRTLK;
    WHEN 'KWN'
    THEN OPEN CURKEYWORD;
    WHEN 'KWY'
    THEN OPEN CURKEYWORD;
    WHEN 'CT'
    THEN OPEN CURPRODCATEGORY;
    WHEN 'BR'
    THEN OPEN CURPRODBRAND; END CASE;
LOOP_LABEL1 :
LOOP
/* reset atEnd flag before fetch */
    SET V_ATEND = '';
    CASE V_CALLFROM
        WHEN 'IDN'
        THEN FETCH CURPRODID
        INTO V_PRODID, V_PRODUOM;
        WHEN 'IDY'
        THEN FETCH CURPRODIDLK
        INTO V_PRODID, V_PRODUOM;
        WHEN 'CPN'
        THEN FETCH CURPRODCSTPRT
        INTO V_PRODID, V_PRODUOM;
        WHEN 'CPY'
        THEN FETCH CURPRODCSTPRTLK
        INTO V_PRODID, V_PRODUOM;
        WHEN 'KWN'
        THEN FETCH CURKEYWORD
        INTO V_PRODID, V_PRODUOM;
        WHEN 'KWY'
        THEN FETCH CURKEYWORD
        INTO V_PRODID, V_PRODUOM;
        WHEN 'CT'
        THEN FETCH CURPRODCATEGORY
        INTO V_PRODID, V_PRODUOM;
        WHEN 'BR'
        THEN FETCH CURPRODBRAND
        INTO V_PRODID, V_PRODUOM; END CASE;
    IF V_ATEND = 'Y'
    THEN LEAVE LOOP_LABEL1; END IF;
/* check avb Qty */ IF (SHOWSTKONLY = 'Y' OR V_GETQTY = 'Y')
THEN SET V_AVBQTY = 0;
    SET V_AVBQTY = WDITMAVQ1F(COMPANYID, V_PRODID, 0); END IF;
    IF SHOWSTKONLY = 'Y'
    THEN IF V_AVBQTY > 0
    THEN IF V_TOTSTK BETWEEN V_INDEXSTR AND V_INDEXEND
    THEN INSERT INTO QTEMP / WKPRDSRCH VALUES (COMPANYID, V_SEQID, V_PRODID, V_AVBQTY, V_PRODUOM, 0);
        SET V_INDEX = V_INDEX + 1;
        SET V_SEQID = V_SEQID + 1;
        SET V_TOTSTK = V_TOTSTK + 1;
    ELSE SET V_TOTSTK = V_TOTSTK + 1; END IF;
    ELSE SET V_INDEX = V_INDEX + 1; END IF;
    ELSE IF V_INDEX BETWEEN V_INDEXSTR AND V_INDEXEND
    THEN /* use wkprcuom to store qtyUom, later will store priceUom */ INSERT INTO QTEMP / WKPRDSRCH
        VALUES (COMPANYID, V_SEQID, V_PRODID, V_AVBQTY, V_PRODUOM, 0);
        SET V_INDEX = V_INDEX + 1;
        SET V_SEQID = V_SEQID + 1;
    ELSE SET V_INDEX = V_INDEX + 1; END IF; END IF;
-- if showStkOnly = 'Y'
END LOOP LOOP_LABEL1;
IF SHOWSTKONLY = 'Y'
THEN SET V_INDEX = V_TOTSTK; END IF;
CASE V_CALLFROM
    WHEN 'IDN'
    THEN CLOSE CURPRODID;
    WHEN 'IDY'
    THEN CLOSE CURPRODIDLK;
    WHEN 'CPN'
    THEN CLOSE CURPRODCSTPRT;
    WHEN 'CPY'
    THEN CLOSE CURPRODCSTPRTLK;
    WHEN 'KWN'
    THEN CLOSE CURKEYWORD;
    WHEN 'KWY'
    THEN CLOSE CURKEYWORD;
    WHEN 'CT'
    THEN CLOSE CURPRODCATEGORY;
    WHEN 'BR'
    THEN CLOSE CURPRODBRAND; END CASE;
IF V_GETPRC = 'Y'
THEN SET V_DOCDATE = CURRENT_DATE;
-- get customer assigned storeId
    SELECT BRDFLOGUNT
    INTO V_STOREID
    FROM PECCUST
        JOIN PARCSTINF ON (CMCOM# = CICOMPANY AND CMCUS# = CICUSTOMID)
        JOIN PWDBRANCH ON (CMCOM# = BRCOMPANY AND BRBRANCHID = CIASSBRNCH)
    WHERE CMCOM# = COMPANYID AND CMCUSEID = CUSTEID;
-- loop through qtemp file to get price and avbQty
    LOOP_LABEL2 :
    FOR V_PR AS CURPRDLINE CURSOR FOR SELECT
                                          WKPRODID,
                                          WKPRCUOM
                                      FROM QTEMP / WKPRDSRCH WHERE WKCOMPANY = COMPANYID DO
    IF V_GETPRC = 'Y'
    THEN SET V_ORGPRICE = 0;
        SET V_PRICE = 0;
        SET V_BRKMINAMT = 0;
        SET V_BRKMINQTY = 0;
        SET V_BRKPCT = 0;
        SET V_BRKAMT = 0;
        SET V_PRICEUOM = 0;
        SET V_SPAID = 0;
        SET V_SELLTOPRC = 0;
        SET V_SPAPRICE = 0;
        SET V_SYSGM = 0;
        SET V_LINEGM = 0;
        SET V_PRODCOST = 0;
        SET V_PURCHCOST = 0;
        SET V_COSTTYPE = '';
        SET V_LOCKPRC = '';
/* Calculate Price for Lines to be processed, pass soId = 0 */
        CALL WDGTUNTPRR ( COMPANYID, V_ZEROID, V_STOREID, V_PR.WKPRODID, V_DOCDATE, V_QTYORD, V_PR.WKPRCUOM, CUSTEID, V_ZEROID, V_DIRSHIP, V_ORGPRICE, V_PRICE, V_BRKMINAMT, V_BRKMINQTY, V_BRKPCT, V_BRKAMT, V_PRICEUOM, V_PRICEORG, V_SPAID, V_HASPRCBRK, V_SPAPRICE, V_SELLTOPRC, V_SYSGM, V_PRODCOST, V_PURCHCOST, V_COSTTYPE, V_FORMULAID, V_BRKFROM, V_PARAMID, V_WHMEMO, V_LOCKPRC, V_OPRICE, P_LANG, FLAG, V_ERRMSG );
    END IF;
    UPDATE QTEMP / WKPRDSRCH SET WKPRCUOM = V_PRICEUOM, WKPRICE = V_PRICE WHERE WKCOMPANY = COMPANYID AND WKPRODID = V_PR.WKPRODID;
END FOR;
END IF;
/* get default image multimedia setup */ SELECT SUBSTRING(CODEMISC, 7, 2)
                                         INTO V_MMTYPEIDC
                                         FROM UNCODESL32
                                         WHERE CODE = 'DEFAULT IMAGE MULTIMEDIA TYPE' AND OWNEREID = COMPANYEID;
IF V_MMTYPEIDC <> ''
THEN SET V_MMTYPEID = DEC(V_MMTYPEIDC, 9, 0); END IF;
OPEN CURLIST;
OPEN CURINFO;
OPEN CURORDER;
END