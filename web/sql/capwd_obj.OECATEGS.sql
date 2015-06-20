BEGIN
    DECLARE V_TYPEID DEC(9, 0) DEFAULT 0;
/* GET first level category list */
    DECLARE CURCATEGORY INSENSITIVE CURSOR WITH RETURN FOR
        SELECT
            CTCATGRYID,
            TRIM(CTNAME)
        FROM PWDCATGRY
        WHERE
            CTCOMPANY = COMPANYID AND
            CTACTIVE = 'Y' AND
            CTPARENTID = 0 AND
            CTGTYPID = V_TYPEID
        ORDER BY CTNAME;
-- Return search category typeId
    DECLARE CURINFO INSENSITIVE CURSOR WITH RETURN FOR
        SELECT V_TYPEID
        FROM SYSIBM / SYSDUMMY1;
    SET FLAG = '';
    SET ERRMSG = '';
/* get search category type */
    SELECT PCCTGTYPID
    INTO V_TYPEID
    FROM PWDCTGTYP
    WHERE PCCOMPANY = COMPANYID AND PCISDFSRCH = 'Y';
    OPEN CURCATEGORY;
    OPEN CURINFO;
END



