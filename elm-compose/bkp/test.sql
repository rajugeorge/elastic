CREATE DEFINER=`root`@`%` TRIGGER `item_AFTER_INSERT` AFTER INSERT ON `item` FOR EACH ROW BEGIN
	DECLARE done INT DEFAULT FALSE;
	DECLARE c1 INT;
	DECLARE c2 VARCHAR(255);
	DECLARE c3 LONGTEXT;
	DECLARE c4 INT;
	DECLARE c5 VARCHAR(255);
	DECLARE c6 INT;
	DECLARE c7 VARCHAR(255);
	DECLARE c8 VARCHAR(255);
	DECLARE c9 INT;
	DECLARE c10 VARCHAR(255);
	DECLARE cur CURSOR FOR SELECT item.id as item_id, 
		item.title as item_title, 
		item.description as item_description,
		city.id AS city_id,
		city.name AS city_name,
		spec.id as spec_id,
		spec.name as spec_name,
		ispec.value as spec_value,
		colour.id as color_id,
		colour.name as color_name
	FROM item 
	LEFT JOIN city ON city.id = item.city
	LEFT JOIN item_has_colour ic on ic.item = item.id
	LEFT JOIN item_has_specification as ispec on ispec.item = item.id
	LEFt JOIN colour on colour.id = ic.colour 
	LEFT JOIN specification as spec on spec.id = ispec.specification
	WHERE item.id = NEW.id;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
	OPEN cur;
		ins_loop: LOOP
			FETCH cur INTO c1,c2,c3,c4,c5,c6,c7,c8,c9,c10;
			IF done THEN
				LEAVE ins_loop;
			END IF;
			INSERT INTO item_journal_idea (item_id, item_title, item_description, city_id, city_name, spec_id, spec_name, spec_value, color_id, color_name) VALUES (c1,c2,c3,c4,c5,c6,c7,c8,c9,c10);
		END LOOP;
	CLOSE cur;
END