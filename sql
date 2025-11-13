CREATE DATABASE logging_db;
USE logging_db;

CREATE TABLE in_memory_logs (
log_id INT AUTO_INCREMENT PRIMARY KEY,
log_message TEXT,
created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=MEMORY;

SHOW TABLE STATUS LIKE 'in_memory_logs';



CREATE TABLE archived_logs (
log_id INT AUTO_INCREMENT PRIMARY KEY,
log_message VARCHAR(1000),
created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

SHOW TABLE STATUS LIKE 'archived_logs';


DELIMITER $$
CREATE PROCEDURE archive_logs()
BEGIN
INSERT INTO archived_logs (log_message, created_at)
SELECT log_message, created_at FROM in_memory_logs;
DELETE FROM in_memory_logs;
END $$
DELIMITER ;

SET GLOBAL event_scheduler = ON;



CREATE EVENT log_archiver
ON SCHEDULE EVERY 1 MINUTE
DO
CALL archive_logs();



CREATE EVENT log_archiver
ON SCHEDULE EVERY 1 MINUTE
DO
CALL archive_logs();


INSERT INTO in_memory_logs (log_message)
VALUES ('System started'),
('User login detected'),
('Payment processed'),
('Disk usage warning'),
('Backup completed');



CALL archive_logs();

select * from archived_logs;
in_memory_logs;





