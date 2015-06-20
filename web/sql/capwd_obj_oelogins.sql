BEGIN --declare v_debug       varchar(2000)   default '';
  DECLARE V_COMPID CHAR(5) DEFAULT '';
  DECLARE V_COMPEID DEC(15, 0) DEFAULT 0;
  DECLARE V_COMPNAME CHAR(60) DEFAULT '';
  DECLARE V_CUSTID CHAR(15) DEFAULT '';
  DECLARE V_CUSTEID DEC(15, 0) DEFAULT 0;
  DECLARE V_CUSTNAME CHAR(120) DEFAULT '';
  DECLARE V_CONTACTID CHAR(3) DEFAULT '';
  DECLARE V_CONTACTEID DEC(15, 0) DEFAULT 0;
  DECLARE V_CONTACTNAME CHAR(50) DEFAULT '';
  DECLARE V_LANG CHAR(3) DEFAULT 'EN';
  DECLARE V_DFTCOUNTRY CHAR(3) DEFAULT '';
  DECLARE V_DEFCATEG DEC(9, 0) DEFAULT 0;
  DECLARE V_DFTCATETYPE DEC(9, 0) DEFAULT 0;
  DECLARE V_COMPTIMEZONE DEC(6, 0) DEFAULT 0;
  DECLARE V_PREFCATEG DEC(9, 0) DEFAULT 0;
  DECLARE V_PREFCATETYPE DEC(9, 0) DEFAULT 0;
  DECLARE V_WHID DEC(15, 0) DEFAULT 0;
  DECLARE V_SECURESSL CHAR(1) DEFAULT '';
--Cursor to return all values
  DECLARE CURINFO INSENSITIVE CURSOR WITH RETURN FOR SELECT
                                                       V_COMPID,
                                                       V_COMPEID,
                                                       V_COMPNAME,
                                                       V_CUSTID,
                                                       V_CUSTEID,
                                                       V_CUSTNAME,
                                                       V_CONTACTID,
                                                       V_CONTACTEID,
                                                       V_CONTACTNAME,
                                                       V_LANG,
                                                       V_DFTCOUNTRY,
                                                       V_DEFCATEG,
                                                       V_COMPTIMEZONE,
                                                       V_DFTCATETYPE,
                                                       V_WHID,
                                                       V_SECURESSL
                                                     FROM SYSIBM/SYSDUMMY1;
  SET FLAG = '';
  SET ERRMSG = '';
  CALL PORTAL11 ( COMPID, CUSTNUMBER, LOGINNAME, PASSWD, V_COMPID, V_COMPEID, V_COMPNAME, V_CUSTID, V_CUSTNAME, V_CUSTEID, V_CONTACTID, V_CONTACTEID, V_CONTACTNAME, V_DFTCOUNTRY, V_LANG, V_COMPTIMEZONE, IP, FLAG );
  IF FLAG <> 'F'
  THEN
    INSERT INTO POELOGHIS (LGCOMPANY, LGCUSTNUM, LGCUSTID, LGCONTID, LGNEWDATE, LGERROR)
    VALUES (V_COMPID, CUSTNUMBER, V_CUSTEID, V_CONTACTEID, CURRENT_TIMESTAMP - P_TZONE, '');

    IF V_CUSTEID <> 0
    THEN
      SELECT
        CIDFCATGRY,
        COALESCE(CTGTYPID, 0)
      INTO V_PREFCATEG, V_PREFCATETYPE
      FROM PARCSTINF
        LEFT JOIN PWDCATGRY ON (CICOMPANY = CTCOMPANY AND CIDFCATGRY = CTCATGRYID)
      WHERE CICOMPANY = V_COMPID AND CICUSTOMID = V_CUSTID;
-- check if cust own any warehouse

      SELECT LGLOGUNTID
      INTO V_WHID
      FROM PWDLOGUNT
      WHERE LGCOMPANY = V_COMPID AND LGWHSETYPE = 'CI' AND LGCUSTEID = V_CUSTEID AND LGACTIVE = 'Y'
      FETCH FIRST 1 ROW ONLY;
    END IF;
    IF V_PREFCATEG <> 0
    THEN
      SET V_DEFCATEG = V_PREFCATEG;
      SET V_DFTCATETYPE = V_PREFCATETYPE;
    ELSE SELECT
           PTDEFCTGRY,
           COALESCE(CTGTYPID, 0)
         INTO V_DEFCATEG, V_DFTCATETYPE
         FROM PWDPRDTMPL
           LEFT JOIN PWDCATGRY ON (PTCOMPANY = CTCOMPANY AND PTDEFCTGRY = CTCATGRYID)
         WHERE PTCOMPANY = V_COMPID;
    END IF;
    SELECT TRIM(SUBSTRING(CODEMISC, 7, 1))
    INTO V_SECURESSL
    FROM UNCODESL32
    WHERE CODE = 'SECURE SSL' AND OWNEREID = V_COMPEID;
    OPEN CURINFO;
  ELSE SET ERRMSG = 'Login failed. usr=' || TRIM(LOGINNAME) || ' pw=' || TRIM(PASSWD);
    INSERT INTO POELOGHIS (LGCOMPANY, LGCUSTNUM, LGCUSTID, LGCONTID, LGNEWDATE, LGERROR)
    VALUES (V_COMPID, CUSTNUMBER, 0, 0, CURRENT_TIMESTAMP - P_TZONE, ERRMSG);
    SET ERRMSG = 'Login failed.';
    OPEN CURINFO;
  END IF;
END
