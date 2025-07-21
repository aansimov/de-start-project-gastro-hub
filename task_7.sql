BEGIN;
	
    LOCK TABLE cafe.managers IN ACCESS EXCLUSIVE MODE;
	
    ALTER TABLE cafe.managers ADD COLUMN manager_phones TEXT[];
	
    WITH new_phones AS (
        SELECT m.manager_uuid,
               m.manager_phone old_phone,
               '8-800-2500-'||(100 + ROW_NUMBER() OVER (ORDER BY m.manager_name))::text new_phone
	  FROM cafe.managers m)
    UPDATE cafe.managers m
       SET manager_phones = ARRAY[new_phone, old_phone]
      FROM new_phones n
     WHERE n.manager_uuid = m.manager_uuid;
	
    ALTER TABLE cafe.managers DROP COLUMN manager_phone;

COMMIT;