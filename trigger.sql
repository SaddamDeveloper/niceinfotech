--source: https://www.w3resource.com/mysql/mysql-triggers.php

DELIMITER 
$$
USE `hr`
$$
CREATE 
DEFINER=`root`@`127.0.0.1` 
TRIGGER `hr`.`emp_details_AINS` 
AFTER INSERT ON `hr`.`emp_details`
FOR EACH ROW
-- Edit trigger body code below this line. Do not edit lines above this one
BEGIN 
INSERT INTO log_emp_details 
VALUES(NEW.employee_id, NEW.salary, NOW());
END$$