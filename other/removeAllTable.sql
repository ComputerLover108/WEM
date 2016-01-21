CREATE FUNCTION removeALLTable() RETURNS void AS $$
DECLARE
    tmp VARCHAR(512);
DECLARE names CURSOR FOR 
    select tablename from pg_tables where schemaname='public';
BEGIN
  FOR stmt IN names LOOP
    tmp := 'DROP TABLE '|| quote_ident(stmt.tablename) || ' CASCADE;';
RAISE NOTICE 'notice: %', tmp;
    EXECUTE 'DROP TABLE '|| quote_ident(stmt.tablename) || ' CASCADE;';
  END LOOP;
  RAISE NOTICE 'finished .....';
END;
$$ LANGUAGE plpgsql;

/*
如果想删除某个 schema下的所有表，一句话足以。
 DROP SCHEMA public CASCADE;
则会自动删除 public 下的所有表及函数。 之后再创建public；
CREATE SCHEMA public AUTHORIZATION "ComputerLover";
GRANT ALL ON SCHEMA public TO "ComputerLover";
GRANT ALL ON SCHEMA public TO public;
COMMENT ON SCHEMA public
  IS 'standard public schema';
*/