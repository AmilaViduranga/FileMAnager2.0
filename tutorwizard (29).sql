-- phpMyAdmin SQL Dump
-- version 4.0.10deb1
-- http://www.phpmyadmin.net
--
-- Host: 127.0.0.1:3306
-- Generation Time: Jan 28, 2017 at 04:47 PM
-- Server version: 5.5.54-0ubuntu0.14.04.1
-- PHP Version: 5.5.9-1ubuntu4.20

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `tutorwizard`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `addPayment`(IN `Amount` VARCHAR(20), IN `Expire` VARCHAR(20), IN `Status` VARCHAR(5), IN `Payee_id` INT(5), IN `Payment_type_id` INT(5))
BEGIN 
INSERT INTO payment( amount , expire , status ,payee_id ,payment_type_id ) VALUES ( Amount ,  Expire ,   Status ,  Payee_id  , Payment_type_id) ;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `checkCountry`(IN `cid` INT)
BEGIN 
SELECT allowed  FROM country WHERE id=cid ;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `checkEmail`(IN `mail` VARCHAR(60))
BEGIN 
SELECT id  FROM users WHERE email=mail ;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `checkEmailTempStd`(IN `mail` VARCHAR(100))
BEGIN 
SELECT COUNT(*)  
FROM temp_students 
WHERE email=mail ;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `checkSession`(IN `sid` VARCHAR(100))
BEGIN 
SELECT user_id  FROM temp_users  WHERE token=sid ;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `checkValidSignupTokenForPayment`(IN `Email` VARCHAR(50))
BEGIN 
SELECT   token  FROM signup_tokens  WHERE email=Email ;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `fnInsertPromotion`(IN `code` VARCHAR(15), IN `amount` DOUBLE, OUT `msg` VARCHAR(1))
    NO SQL
BEGIN
DECLARE `_rollback` BOOL DEFAULT 0;
DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET `_rollback` = 1;

START TRANSACTION;

	INSERT INTO `promotion`(`code`, `amount`) VALUES (code, amount);

	IF `_rollback` THEN
					SET msg ='F';
        			ROLLBACK;
    			ELSE
					SET msg ='T';
					COMMIT;
				END IF;



END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `fnInsertUserPromotion`(IN `studentID` INT, IN `promotionID` INT, OUT `msg` VARCHAR(1))
    NO SQL
BEGIN
DECLARE `_rollback` BOOL DEFAULT 0;
DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET `_rollback` = 1;

START TRANSACTION;


INSERT INTO `user_promotion`(`student_id`, `promotion_id`) VALUES (studentID,promotionID);

IF `_rollback` THEN
					SET msg ='F';
        			ROLLBACK;
    			ELSE
					SET msg ='T';
					COMMIT;
				END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `fnUploadProfilePicture`(IN `userID` INT, IN `filename` VARCHAR(50), IN `exten` VARCHAR(10), OUT `st` VARCHAR(1))
    NO SQL
begin
declare rw int default 0;
declare rw2 int default 0;
DECLARE fileID INT DEFAULT 0;

INSERT INTO `file`(`name`, `extension`, `createAt`) VALUES (filename, exten, NOW());

SELECT ROW_COUNT() INTO rw;

if(rw>0)
then
	SELECT LAST_INSERT_ID() into fileID;

	UPDATE `users` SET `file_id`=fileID WHERE `id`=userID;

	SELECT ROW_COUNT() INTO rw2;

	
	if(rw2>0)
	THEN
		set st= "T";
	ELSE
		SET st="F";
	END IF;

else
	set st= 'F';
end if;


end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetAllProducts`()
BEGIN
   SELECT *  FROM  users ;
   END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getEmailFromUID`(IN `uid` INT)
BEGIN 
SELECT email  FROM users WHERE id=uid ;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getPaymentTermType`(IN `pid` INT)
BEGIN
SELECT 	name  FROM	package_type WHERE id=pid ; 
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetPriceList`(IN `pid` INT(9))
BEGIN
   SELECT *  FROM package_price WHERE package_id=pid ;
   END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getStdDetails`(IN `sid` INT)
BEGIN
SELECT full_name, grade,package_id FROM students WHERE std_id=sid ;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getStdPaymentDetails`(IN `sid` INT)
BEGIN
SELECT * FROM transaction WHERE student_id=sid ;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetUsername`(IN `uid` INT(10))
BEGIN 

	SELECT	email 
    FROM	users WHERE id=uid ;
      
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `InsertFolder`(IN `Name` VARCHAR(40), IN `Color` VARCHAR(7), IN `Std_id` INT(10), IN `Container_id` INT(10))
BEGIN 
INSERT INTO folder(name, color,std_id,container_id) VALUES(Name,Color, Std_id, Container_id) ;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `InsertPayment`(IN `studentID` INT, IN `paytype_id` INT, IN `expdt` VARCHAR(20), IN `amnt` VARCHAR(20), OUT `st` VARCHAR(1))
BEGIN  
DECLARE num int DEFAULT 0;
DECLARE rw	int Default 0;
DECLARE payID	int Default 0;
DECLARE invc	varchar(15) Default 0;

SELECT `months` INTO num
FROM `package_type` WHERE id= paytype_id;



INSERT INTO payment(expire,status,payment_type_id,std_id,amount) VALUES (expdt,0,paytype_id,studentID,amnt);
SELECT ROW_COUNT() INTO rw;
IF(rw>0)
	THEN
		SELECT LAST_INSERT_ID() into payID;
		SET invc = CONCAT ('TWI',payID);

		UPDATE payment
		SET inovice = invc
		WHERE id= payID;
    	
		SET st ='T';

	ELSE
		SET st ='F';
	END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insertTempUsers`(IN `User_id` INT(10), IN `Token` VARCHAR(100))
BEGIN 
INSERT INTO temp_users( user_id, token) VALUES(User_id, Token ) ;
END$$

CREATE DEFINER=`tester`@`%` PROCEDURE `new_procedure`(IN `studentID` INT, IN `title` VARCHAR(250), IN `startDate` DATE, IN `endDate` DATE, IN `startTime` TIME, IN `endTime` TIME, IN `repTypeID` INT, IN `cDate` DATETIME, IN `createBy` INT, IN `lastModify` INT, IN `color` VARCHAR(20), IN `note` TEXT, OUT `plannerID` INT, OUT `st` VARCHAR(1))
BEGIN
	DECLARE rw	int;
    
    INSERT INTO `planner`(`std_id`, `title`, `start_date`, `end_date`, `start_time`, `end_time`, `repeat_type_id`, `created_date`, `created_by`, `last_mod_by`, `event_color`) 
    VALUES (studentID, title, startDate, endDate,  startTime, endTime, repTypeID, cDate, createBy , lastModify , color);
    
    SELECT ROW_COUNT() INTO rw;
    IF(rw>0)
	THEN
		SELECT LAST_INSERT_ID() into plannerID;
        
        if(note <> '')
        then
        		INSERT INTO `planner_notes`(`note`, `planner_id`) VALUES (note, plannerID);
				SELECT ROW_COUNT() INTO rw;
                
				IF(rw>0)
				THEN
					SET st= 'T';
				else
					SET st= 'F';
				end if;
		else
				SET st= 'T';
		end if;
		
	ELSE
		SET st ='F';
	END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp`(IN `studentID` INT, IN `year` YEAR)
    NO SQL
BEGIN
	DECLARE finished INTEGER DEFAULT 0;
    DECLARE units INTEGER DEFAULT 0;
	DECLARE unitID INTEGER DEFAULT 0;



	DEClARE module_cursor CURSOR FOR 
SELECT P.id
FROM planner P
WHERE P.std_id =studentID
AND YEAR( P.end_date ) >=year
AND year >= YEAR( P.start_date ) ;
	



	 DECLARE CONTINUE HANDLER 
        FOR NOT FOUND SET finished = 1;

	OPEN module_cursor;

	get_units: LOOP
 
 	FETCH module_cursor INTO units;
	IF finished = 1 THEN 
 		LEAVE get_units;
 	END IF;

		SELECT id as planner_id, note from planner_notes where planner_id= units;
		SELECT  id as reminderID , reminder_date,reminder_time from planner_reminder where planner_id= units;

	END LOOP get_units;
 
 	CLOSE module_cursor;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spAddStudent`(IN `countryID` INT, IN `mobile` VARCHAR(9), IN `fullname` VARCHAR(60), IN `uid` INT, IN `packID` INT, IN `priceTypeID` INT, OUT `st` VARCHAR(11), IN `payTypeID` INT, IN `amount` DOUBLE)
BEGIN

DECLARE ref varchar(12);
DECLARE sid	int (6) default 0;
DECLARE `_rollback` BOOL DEFAULT 0;
DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET `_rollback` = 1;

START TRANSACTION;
SET st ='F';
        
        
    INSERT INTO students(country,full_name,user_id,package_id,date_joined) VALUES(countryID,fullname,uid,packID,NOW());
        
	IF `_rollback` THEN
		SET st =ST_F;
        ROLLBACK;
    ELSE
      
     	SELECT std_id INTO sid
		FROM	students
		WHERE	user_id= uid;
		
	
 		IF(sid> 0)
		THEN
			CALL `spCreateStudentID`(sid,ref);
			IF `_rollback` THEN
				SET st='S_F';
				ROLLBACK;
			ELSE

				CALL spInsertPayment(sid,payTypeID,st,amount);
				IF `_rollback` THEN
					SET st='P_F';
					ROLLBACK;
				ELSE

					SELECT fnInsertStudentMobile(mobile,sid,1);
					IF `_rollback` THEN
						SET st='M_F';
						ROLLBACK;
					ELSE
						SELECT  `fnInsertStudentPakcagePrice` (sid , priceTypeID); 
						IF `_rollback` THEN
							SET st='PP_F';
							ROLLBACK;
						ELSE
						
							UPDATE	students
							SET		reference = ref
							WHERE	std_id= sid;

							IF `_rollback` THEN
								SET st='R_F';
								ROLLBACK;
							ELSE
								SET st= 'T';
								COMMIT;
								
							END IF;
							
						END IF;
					
					END IF;
				
				END IF;
			
			END IF;
			
 		
		ELSE

			SET st='ID_F';
		
		END IF;
	
	END IF;
        

     
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spAddTempStudent`(IN `countryID` INT, IN `Email` VARCHAR(100), IN `mobile` VARCHAR(12), IN `name` VARCHAR(100), OUT `st` VARCHAR(1))
BEGIN
DECLARE rw	int;

        
        INSERT INTO temp_students( country ,email, phone ,full_name) VALUES
        (countryID,Email ,mobile,name) ;
        SELECT ROW_COUNT() INTO rw;

    IF(rw>0)
	THEN
    	SET st ='T';	

	ELSE
		SET st ='F';
	END IF;
  
     
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spCheckUserPromotion`(IN `studentID` INT, IN `promo_code` VARCHAR(15), OUT `discount` DOUBLE, OUT `msg` VARCHAR(1))
    NO SQL
BEGIN
DECLARE promotion_id int DEFAULT 0;
DECLARE	promo_amount double;
DECLARE user_promotion_id int DEFAULT 0;
DECLARE `_rollback` BOOL DEFAULT 0;
DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET `_rollback` = 1;

START TRANSACTION;

SELECT  id , `amount` into promotion_id, promo_amount  
FROM `promotion` 
WHERE code =promo_code;

SELECT 	id into user_promotion_id
FROM 	`user_promotion` 
WHERE	`student_id` =studentID AND `promotion_id`=promotion_id AND `expired`=0;

IF(user_promotion_id>0)
THEN

	SET discount = promo_amount;
	
	UPDATE `user_promotion` SET `expired`=1 
	WHERE `id`=user_promotion_id;
	
	IF `_rollback` THEN
			SET msg ='F';
        	ROLLBACK;
    ELSE
			SET msg ='T';
			COMMIT;
	END IF;

ELSE
	SET discount = 0;

END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spCreateStudentID`(IN `stdID` INT(6), OUT `id` VARCHAR(12))
BEGIN
	
    DECLARE temp int(6) zerofill;
    DECLARE ref varchar(6);
	DECLARE temp1 varchar(3);
    DECLARE temp2 varchar(3);
    
    SET temp1= 'TWS';
    SET temp2=DATE_FORMAT(CURDATE(), '%y');

	SET ref = CONCAT(temp1,temp2);
   	SET temp = CAST(stdID AS CHAR);
       
    
    SET id = CONCAT(ref,temp);
    
	IF (id IS NOT NULL)
	THEN
		SET id = id;
	ELSE
		SET id = 'F';
	END IF;
       
    
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spDailyPlannerCursor`(IN `studentID` INT, IN `date` DATE)
    NO SQL
BEGIN

	

	SELECT  id as reminderID , reminder_date,reminder_time,planner_id from planner_reminder 
where planner_id IN(
		SELECT P.id 
		FROM planner P
		WHERE P.std_id =studentID AND P.end_date >= date AND date >= P.start_date);



	 
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spDeleteMessage`(IN `msgID` INT, OUT `st` VARCHAR(1))
BEGIN
DECLARE cnt	int;
DECLARE `_rollback` BOOL DEFAULT 0;
DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET `_rollback` = 1;

START TRANSACTION;

	UPDATE `message` 
	SET		msg_delete =1
	WHERE 	id =msgID;

	IF `_rollback` THEN
		SET st ='F';
        ROLLBACK;
    ELSE
		SELECT reply_count into cnt
		FROM 	message
		WHERE	id =msgID;

		IF(cnt>0)
		THEN
			UPDATE reply
			SET 	msg_delete = 1
			WHERE	message_id= msgID;
			
			IF `_rollback` THEN
				SET st ='F';
        		ROLLBACK;
    		ELSE
				SET st ='T';
				COMMIT;
			END IF;
	
		ELSE
			SET st ='T';
				COMMIT;
		END IF;
			

    END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spDeleteTutorHelperMessage`(IN `msgID` INT, OUT `st` VARCHAR(1))
    NO SQL
BEGIN
DECLARE cnt	int;
DECLARE `_rollback` BOOL DEFAULT 0;
DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET `_rollback` = 1;

START TRANSACTION;
	UPDATE `tutor_help_message` SET delete_msg=1  WHERE `id`=msgID;

	IF `_rollback` THEN
		SET st ='F';
        ROLLBACK;
    ELSE
		SELECT reply_count into cnt
		FROM 	tutor_help_message
		WHERE	id =msgID;
	
		
		IF(cnt>0)
		THEN

			UPDATE `tutor_help_reply` SET `msg_delete`= 1 WHERE `message_id`= msgID;

			IF `_rollback` THEN
				SET st ='F';
        		ROLLBACK;
    		ELSE
				SET st ='T';
				COMMIT;
			END IF;
	
		ELSE
			SET st ='T';
				COMMIT;
		END IF;
			

    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spForgotPassword`(IN `pwd` VARCHAR(255), IN `mail` VARCHAR(100), OUT `st` VARCHAR(1))
BEGIN
DECLARE rw	int;


	UPDATE	users
    SET	password= pwd
    WHERE	email= mail;

	SELECT ROW_COUNT()into rw;

 	IF(rw >0 ) THEN
		SET st = 'T';
	ELSE
		SET st= 'F';
	END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spGetAFolder`(IN `fID` INT)
BEGIN
	
    SELECT	name,color,container_id
    FROM	folder
    WHERE	id = fID and status=1 ;
           
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spGetAllStaff`()
BEGIN
	
    SELECT 	*
    FROM	users
    WHERE	type <> 2;
        
    
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spGetANote`(IN `noteID` INT)
BEGIN
	
    SELECT	text,color
    FROM	notes
    WHERE	id = noteID and status=1;
       
    
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spGetAvailablePackageType`(IN `packID` INT)
    NO SQL
BEGIN

	SELECT	id as package_type_id ,name
	FROM	package_type
	WHERE	id IN (
	
	SELECT	package_type_id
	FROM	package_price
	WHERE	package_id= packID);

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spGetCountryList`()
BEGIN
 
    SELECT	*
    FROM	country    
    ORDER BY country_name;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spGetCurriculum`()
BEGIN
	
    SELECT 	id as curriculumn_id,name as curriculumn_name
    FROM	curriculum;
        
    
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spGetDailyPlanner`(IN `date` DATE, IN `studentID` INT)
BEGIN

	SELECT P.id as plannerID,N.id as noteID, N.note, P.title, P.start_date, P.end_date, P.start_time, P.end_time, P.event_color
	FROM planner P, planner_notes N
	WHERE P.std_id =studentID AND P.end_date>=date AND date >= P.start_date AND P.id=N.planner_id;
	
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spGetFaqs`()
BEGIN

  SELECT * 
  From faqs;
 END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spGetFolder`(IN `parent` INT, IN `s_id` INT)
BEGIN

IF(parent =0)
THEN

    SELECT 	name as folder_name, color as folder_color, id as folder_id 
    FROM	folder
    WHERE	std_id=s_id and status=1 ;

ELSE

    SELECT 	name as folder_name, color as folder_color, id as folder_id 
    FROM	folder
    WHERE	container_id= parent and std_id=s_id and status=1 ;

END IF;
	

        
    
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spGetFolderResource`(IN `fold_id` INT)
BEGIN
	
    SELECT 	name as resource_name, file_id, id as resource_id ,resource_type_id
    FROM	resources
    WHERE	id IN
	(SELECT 	resource_id
	FROM	folder_resource
    WHERE	folder_id= fold_id and status=1);
        
    
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spGetGlossaryByUnit`(IN `unitid` INT)
BEGIN

  SELECT * 
  From glossary
  WHERE	unit_id = unitid;
 END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spGetGrade`()
    NO SQL
BEGIN
	SELect 	*
	FROM	grade;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spGetGradeSubject`(IN `packID` INT)
BEGIN

DECLARE currID int DEFAULT 0;
DECLARE grdID int DEFAULT 0;

SELECT grade_id,curriculum_id into grdID,currID
FROM 	package
where	id= packID;

SELECT	*
FROM	subject
Where	id IN(

SELECT DISTINCT subject_id
FROM	package_subject
WHERE package_id IN(
	SELECT  `id` 
	FROM  `package` 
	WHERE  `curriculum_id` = currID AND  `grade_id` =grdID));



END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spGetGroups`()
    NO SQL
BEGIN

SELECT * FROM `group`;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spGetHeading`()
BEGIN

  SELECT id as heading_id, name as headingName
  From  headings;
  
  END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spGetHelperMessages`(IN `userID` INT)
    NO SQL
BEGIN


	SELECT  id, `subject`, `content`, `date_time`, `user_id` ,helper_id, stars
	FROM `message` 
	WHERE msg_delete = 0 AND reply_count =0 AND helper_id IN (

		SELECT `helper_id` FROM `user_helpers` WHERE user_id =userID)
	ORDER BY date_time DESC;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spGetMarksMessageId`(IN `marks` INT)
BEGIN
if(marks>40)
then 
SELECT	id  FROM	star_system  where min_marks=marks or max_marks=marks;
else 
SELECT	id  FROM	star_system  where max_marks <=40 ;
end if;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spGetMessage`(IN `msgID` INT)
    NO SQL
BEGIN


SELECT `subject`, `content`, `status`, `date_time`, `user_id`,`stars`,`id`
FROM `message` 
WHERE id= msgID and msg_delete =0;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spGetMessageAttachment`(IN `msgID` INT)
    NO SQL
BEGIN

SELECT `id` as file_id, `name`, `extension`
FROM `file` 
WHERE id IN(

	SELECT  `file_id` 
    FROM `message_attachment` 
    WHERE message_id = msgID);


END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spGetMessageReply`(IN `msgID` INT)
    NO SQL
BEGIN

SELECT R.`user_id` as replierID, R.`message_id`, R.`date_time` as reply_date, R.`content` reply_content, M. subject as msg_subject, M.content as msg_content, M.date_time as msg_date,M.user_id as senderID , M.stars 
FROM `reply` R, message M
WHERE R.message_id =msgID and R.msg_delete =0 and M.msg_delete =0 and M.id= R.message_id;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spGetMobile`(IN `mail` VARCHAR(100), OUT `tel` VARCHAR(20))
BEGIN


DECLARE temp2 varchar(9);
DECLARE temp3 varchar(10);
DECLARE cntry int DEFAULT 0;
DECLARE uid int DEFAULT 0;
DECLARE sid int DEFAULT 0;

SELECT `id` into uid
FROM `users` 
WHERE email=mail;



if(uid =0)
THEN
	SET tel ='invalid';
ELSE

	SELECT	country,std_id INTO cntry,sid 
    FROM	students
    WHERE	user_id= uid;
    

    SELECT	mobile INTO temp2
    FROM	student_mobile
    WHERE	std_id= sid and status =1;

	SELECT 	code INTO temp3
    FROM	country
    WHERE	id= cntry;	
    
 
    SET tel = CONCAT(temp3,temp2);
    

	END IF;    
    
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spGetModule`(IN `packID` INT, IN `subID` INT)
BEGIN
DECLARE psid int;

SELECT `id` into psid
FROM `package_subject` 
WHERE package_id= packID AND subject_id= subID;
	
 

  SELECT 	id as module_id, name as module_name, description
  From 		module
  WHERE		id IN(
	SELECT module_id
  	From 	package_subject_module
  	WHERE	package_subject_id= psid);
		
  END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spGetModuleById`(IN `mID` INT)
BEGIN
SELECT * FROM module WHERE id = mID;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spGetModuleDetails`(IN `moduleID` INT)
    NO SQL
BEGIN

SELECT M.`id`AS module_id, M.`name`, M.`description` ,S.`id`as subject_id, S.`name`
FROM `module` M, subject S
WHERE	M.id= moduleID AND 	S.id IN(
	
    SELECT `subject_id` 
	FROM `package_subject` 
	WHERE	id IN
	
	(
    	SELECT `package_subject_id` 
        FROM `package_subject_module` 
        WHERE module_id= moduleID
    ));
	

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spGetModuleFromSubGrdCurri`(IN `gradeID` INT, IN `curriculumnID` INT, IN `subjectID` INT)
    NO SQL
BEGIN
DECLARE package_subejctID int Default 0;


	SELECT *
	FROM	module
	WHERE	id IN(

		SELECT module_id
		FROM	package_subject_module
		WHERE	 package_subject_id IN (
            
            SELECT 	id
			FROM	package_subject
			WHERE	subject_id = subjectID AND package_id IN(
		
    		    SELECT  `id` 
				FROM  `package` 
				WHERE  `curriculum_id` = curriculumnID AND  `grade_id` =gradeID)));
	


END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spGetModuleQuizConfig`(IN `gradeID` INT, IN `curriculumID` INT, IN `subjectID` INT, IN `moduleID` INT, IN `testType` VARCHAR(20))
BEGIN

SELECT *
FROM 
	quiz_config 
WHERE 
	curriculum_id = curriculumID 
	AND 
		grade_id 	= gradeID 
	AND
		subject_id = subjectID
	AND
		test_type  =testType
	AND
		module_id = moduleID;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spGetMonthlyPlanner`(IN `searchDate` DATE, IN `studentID` INT)
BEGIN
DECLARE temp varchar(10);
DECLARE dt varchar(10);


SET dt = EXTRACT(YEAR_MONTH FROM searchDate);

	SELECT P.id as plannerID,N.id as noteID, N.note, P.title, P.start_date, P.end_date, P.start_time, P.end_time, P.event_color, P.repeat_type_id
	FROM planner P, planner_notes N
	WHERE P.std_id =studentID  AND EXTRACT(YEAR_MONTH FROM P.end_date)>=dt AND dt >= EXTRACT(YEAR_MONTH FROM P.start_date) AND P.id=N.planner_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spGetNotConfrimStaff`()
BEGIN
	
    SELECT 	id, email, type
    FROM	users
    WHERE	status=0 and type <> 2;
        
    
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spGetNoteByPlanId`(IN `planID` INT)
BEGIN

SELECT note FROM planner_notes WHERE planner_id = planID;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spGetNotes`(IN `fold_id` INT)
BEGIN
	
    SELECT id ,	text,color
    FROM	notes
    WHERE	folder_id= fold_id and status=1;
        
    
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spGetNotification`(IN `userID` INT)
    NO SQL
BEGIN
	
	

SELECT DISTINCT feed.id as feed_id,feed_user.user_id as userID,feed_links.link, feed.notification, feed.createdAt
FROM feed
INNER JOIN feed_user ON feed.id = feed_user.notification_id AND feed_user.user_id =userID 

LEFT OUTER JOIN feed_links
ON feed.id = feed_links.notification_id ;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spGetNotificationCount`(INOUT `userID` INT, OUT `num` INT)
    NO SQL
BEGIN

	SELECT COUNT(`notification_id`) into num FROM `feed_user` WHERE user_id =userID;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spGetPackage`(IN `gid` INT, IN `currid` INT)
BEGIN
	
    SELECT 	id as package_id,name as package_name
    FROM	package
    WHERE	grade_id= gid and curriculum_id= currid;
        
    
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spGetPackageCurriculum`()
BEGIN
	
    SELECT	name ,id
    FROM	curriculum 
    WHERE	id IN(
    SELECT	DISTINCT (curriculum_id)
    FROM	package);
    
        
    
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spGetPackageDetails`(IN `packageID` INT)
    NO SQL
BEGIN
	
	SELECT 	P.`id` as packageID, P.`name`, P.`curriculum_id`, P.`grade_id`, PS.subject_id, PP.`price`, PP.`package_type_id`
	FROM 	`package`P , package_subject PS,package_price PP
	WHERE	P.id= packageID AND PS.package_id= P.id AND PS.package_id= packageID AND PP.package_id=packageID AND PP.package_id= P.id; 
	
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spGetPackageGrade`(IN `cid` INT)
BEGIN
	
    SELECT	 id,grade
    FROM	grade 
    WHERE	id IN(
    SELECT	DISTINCT (grade_id)
    FROM	package
    WHERE	curriculum_id = cid);
    
        
    
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spGetPackagePrice`(IN `packTypeID` INT, IN `packid` INT)
BEGIN

	
SELECT 	id as package_price_id,price 
FROM	package_price
WHERE	package_id= packid and package_type_id= packTypeID;


END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spGetPackageResource`(IN `packID` INT, OUT `resID` INT)
    NO SQL
BEGIN

	SELECT	DISTINCT resource_id
	FROM	unit_resources
	WHERE	unit_id IN	

		(SELECT	id
		FROM	unit
		WHERE	module_id IN

			(SELECT	module_id
			FROM	package_subject_module
			WHERE	package_subject_id IN

				(SELECT	id
				FROM	package_subject
				WHERE	package_id=packID)));
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spGetPackageSubject`(IN `pid` INT)
BEGIN

	SELECT	 id as subject_id,name as subject_name,color
    FROM	subject
    WHERE	id IN(
    
	SELECT subject_id 
    FROM	package_subject
    WHERE	package_id = pid);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spGetPackageSubjectId`(IN `pkid` INT, IN `subjd` INT)
BEGIN
	
    SELECT id 
    FROM	package_subject 
    WHERE	package_id= pkid and subject_id= subjd;       
    
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spGetPackageType`()
BEGIN
	
    SELECT 	* 
    FROM	package_type;
        
    
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spGetPaymentDetail`(IN `studentID` INT)
    NO SQL
BEGIN
	SELECT *
	FROM	payment
	WHERE	std_id= studentID;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spGetPaymentType`()
BEGIN 
SELECT * FROM payment_type;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spGetPlanById`(IN `planID` INT)
BEGIN

SELECT * FROM planner WHERE id = planID;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spGetProfilePic`(IN `userID` INT)
    NO SQL
BEGIN

	SELECT	*
	FROM	file
	WHERE	id IN (

		SELECT	file_id
		FROM	users
		WHERE	id= userID);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spGetReference`(IN `sid` INT, OUT `ref` VARCHAR(12), OUT `mail` VARCHAR(100))
    NO SQL
BEGIN
DECLARE uid int default 0;

SELECT	user_id,reference into uid,ref
FROM	students
WHERE	std_id= sid;

SELECT	email into mail
FROM	users
WHERE	id= uid;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spGetReply`(IN `ReplyID` INT)
    NO SQL
BEGIN

SELECT `user_id`, `message_id`,`date_time`, `status`, `content` 
FROM `reply` 
WHERE  id =ReplyID and msg_delete =0
ORDER BY date_time DESC;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spGetReplyAttachment`(IN `replyID` INT)
    NO SQL
BEGIN

SELECT `id` as file_id, `name`, `extension`
FROM `file` 
WHERE id IN(

	SELECT  `file_id` 
    FROM `reply_attachment` 
    WHERE reply_id = replyID );


END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spGetResourceData`(IN `resid` INT)
BEGIN
	
    SELECT  *
    FROM	resources
    WHERE	id = resid;       
    
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spGetResourceFile`(IN `resid` INT)
BEGIN
	
SELECT F.`name`, F.`extension`,RT.name as Type
FROM `file` F,  resources R,resource_types RT
WHERE F.id = R.file_id AND R.id= resid AND R.resource_type_id= RT.id ;     
    
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spGetResourcesTypes`()
BEGIN
	
    SELECT * 
    FROM resource_types ; 
   
    
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spGetResourceTags`(IN `rid` INT)
BEGIN

	SELECT	name as tag, id as tag_id
    FROM	tags
    WHERE	id IN(
    
	SELECT 	tag_id 
    FROM	resource_headings
    WHERE	resource_id = hid);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spGetSendMessage`(IN `userID` INT, IN `startLimit` INT, IN `endLimit` INT)
    NO SQL
BEGIN

SELECT `id`, `subject`, `content`, `status`, `date_time` ,stars
FROM `message` 
WHERE user_id =userID AND msg_delete= 0
ORDER BY date_time DESC 
LIMIT startLimit,endLimit;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spGetSnapDetails`(IN `snap_id` INT, OUT `snap_name` VARCHAR(100), OUT `file_extension` VARCHAR(10), OUT `file_name` VARCHAR(50))
    NO SQL
BEGIN
DECLARE fielID int;

	SELECT	`file_id`, `name` into fielID,snap_name
	FROM	snap
	WHERE	id= snap_id;

	SELECT `name`, `extension` into file_name,file_extension
	FROM `file` 
	WHERE	id=fielID;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spGetSnapFile`(IN `snapID` INT)
    NO SQL
BEGIN

	select name,extension
	from	file
	where	id in (
    
    	SELECT `file_id` FROM `snap` WHERE id=snapID
    );
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spGetSnapsByStudentIdle`(IN `stuID` INT)
    NO SQL
BEGIN
	SELECT  * FROM  snap  WHERE  student_id = stuID;	
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spGetStarPrizeConfig`(IN `curID` INT, IN `gradeID` INT)
BEGIN
	SELECT  *  FROM star_prize_config WHERE curriculum_id = curID AND grade_id =  gradeID;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spGetStudent`(IN `u_id` INT(10))
BEGIN 
SELECT std_id FROM students WHERE user_id=u_id ;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spGetStudentFromMail`(IN `mail` VARCHAR(100), OUT `studentID` VARCHAR(20), OUT `name` VARCHAR(100), OUT `curriculumn` VARCHAR(20), OUT `gradeName` VARCHAR(20), OUT `package` VARCHAR(50), OUT `packageType` VARCHAR(50), OUT `ExDate` DATE, OUT `packAmount` DOUBLE, OUT `nextAmount` DOUBLE)
    NO SQL
BEGIN

DECLARE packageID int default 0;
DECLARE curriculumnID int default 0;
DECLARE gradeID int default 0;


SELECT `reference`, `full_name`,  `package_id` into studentID,name,packageID
FROM `students` 
WHERE user_id IN(
	SELECT `id` FROM `users` WHERE email =mail);


SELECT `curriculum_id`, `grade_id` ,package.name into curriculumnID,gradeID,package
FROM `package` 
WHERE id =packageID;

SELECT curriculum.`name` into curriculumn
FROM `curriculum` 
WHERE id =curriculumnID;

SELECT `grade` into gradeName
FROM `grade` 
WHERE id = gradeID;


SELECT  P.`price`,T.name into packAmount,packageType
FROM `package_price` P, package_type T
WHERE P.`package_id`=packageID AND P.package_type_id = T.id AND P.id IN(


SELECT `package_price_id` 
FROM `student_package_price` 
WHERE student_id =studentID);


SELECT`expire_date`, `balance` into ExDate,nextAmount
FROM `transaction` 
WHERE student_id=studentID;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spGetStudentFromStatus`(IN `st` INT)
    NO SQL
BEGIN

SELECT U.`id` as user_id, U.`email`,S.reference, S.std_id, S.full_name,S.date_joined  
FROM `users` U, students S
WHERE U.type= 2 AND U.status =st AND U.id = S.user_id;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spGetStudentFromStdID`(IN `studentID` INT, OUT `userID` INT, OUT `packID` INT, OUT `countryID` INT, OUT `gradeID` INT, OUT `curriculumID` INT)
    NO SQL
begin
	

	select 	user_id,package_id,country into userID,packID,countryID
	from	students
	where	std_id= studentID;

	select	grade_id,curriculum_id into gradeID,curriculumID
	from	package
	where	id=packID;


end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spGetStudentFromToken`(IN `tokn` VARCHAR(100), OUT `userID` INT, OUT `stdID` INT, OUT `packID` INT, OUT `countryID` INT, OUT `gradeID` INT, OUT `role` INT)
    NO SQL
begin
	select user_id into userID
	from	temp_users
	where	token= tokn;

	select std_id,package_id,country into stdID,packID,countryID
	from	students
	where	user_id= userID;

	select	grade_id into gradeID
	from	package
	where	id=packID;

	select	type into role
	from	users
	where	id= userID;

end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spGetStudentIDFormRef`(IN `ref` VARCHAR(12))
    NO SQL
BEGIN
	SELECT	std_id
	FROM	students
	WHERE	reference=ref;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spGetStudentInterests`(IN `sid` INT)
    NO SQL
BEGIN

SELECT		
interests,
fav_subject,
topic,
ambition,
quote
FROM	interest
WHERE	std_id= sid ;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spGetStudentPackage`(IN `studentID` INT)
BEGIN
	
    SELECT 	package_id
    FROM	students
    WHERE	std_id= studentID;
        
    
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spGetStudentParentFolder`(IN `studentID` INT)
    NO SQL
BEGIN

SELECT id as folder_id ,`name` as folder_name , `color` as folder_color 
FROM `folder` 
WHERE std_id =studentID AND container_id IS NULL and status=1 ;



END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spGetStudentParentNotes`(IN `studentID` INT)
    NO SQL
BEGIN

SELECT id , `text` , `color`
FROM `notes` 
WHERE student_id =studentID AND folder_id IS NULL and status=1 ;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spGetStudentPriceType`(IN `stdID` INT)
    NO SQL
BEGIN

SELECT `name` ,id
FROM `package_type` 
WHERE id IN (

	SELECT `package_price_id` 
	FROM `student_package_price` 
	WHERE student_id = stdID);

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spGetStudentProfile`(IN `sid` INT)
BEGIN 

DECLARE id int DEFAULT 0;


SELECT nick_name, full_name, grade, school,date_joined,reference
FROM `students` 
WHERE std_id= sid;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spGetStudentSnapsID`(IN `stdID` INT)
    NO SQL
BEGIN

	SELECT `id`
	FROM `snap` 
	WHERE student_id =stdID;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spGetStudentStars`(IN `sid` INT)
BEGIN
	SELECT	*  FROM student_stars where student_id =  sid;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spGetSubcription`()
    NO SQL
BEGIN

SELECT *
FROM `subscription`
WHERE id <= 12;


END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spGetSubject`()
BEGIN 

	SELECT	id as sid , name as sname	
    FROM	subject;
    
    
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spGetSubjectById`(IN `subjID` INT)
BEGIN

SELECT * FROM subject WHERE id = subjID;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spGetSubjectFromCurriGrade`(IN `gradeID` INT, IN `curriculumnID` INT)
    NO SQL
BEGIN

SELECT	*
FROM	subject
Where	id IN(

SELECT DISTINCT subject_id
FROM	package_subject
WHERE package_id IN(
	SELECT  `id` 
	FROM  `package` 
	WHERE  `curriculum_id` = curriculumnID AND  `grade_id` =gradeID));



END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spGetSubjectQuizConfig`(IN `gradeID` INT, IN `curriculumID` INT, IN `subjectID` INT, IN `testType` VARCHAR(20))
BEGIN

SELECT *
FROM 
	quiz_config 
WHERE 
	curriculum_id = curriculumID 
	AND 
		grade_id 	= gradeID 
	AND
		subject_id = subjectID
	AND
		test_type  =testType;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spGetTag`()
BEGIN

  SELECT id as tag_id, name as tagName
  From  tags;
  
  END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spGetTempStudent`(IN `countryID` INT)
BEGIN 

SELECT	*
FROM  temp_students 
WHERE country =countryID;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spGetTestType`()
BEGIN
SELECT 	* FROM	quiz_type ;         
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spGetTopStudents`()
BEGIN 
SELECT * 
FROM  `quiz_marks` 
ORDER BY marks DESC 
LIMIT 5 ; 
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spGetTransactionDetails`(IN `stdID` INT)
    NO SQL
BEGIN

	SELECT *
	FROM  transaction  
	WHERE student_id = stdID;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spGetUnit`(IN `mid` INT)
BEGIN

  SELECT id as unit_id ,name as unit_name, module_id, description
  From unit
  WHERE	module_id= mid;
  END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spGetUnitDetails`(IN `unitID` INT)
    NO SQL
BEGIN

	SELECT * FROM `unit` WHERE id =unitID;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spGetunitResource`(IN `uid` INT)
BEGIN

	SELECT	name as unit_name, id as resource_id,file_id, 
			resource_type_id, description 
    FROM	resources
    WHERE	id IN(
    
	SELECT 	resource_id 
    FROM	unit_resources
    WHERE	unit_id = uid);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spGetunitResourcesByType`(IN `uid` INT, IN `typeId` INT)
BEGIN
SELECT 
	h.name AS heading_name,h.id as heading_id, r.id AS res_id, r.name AS res_name, r.description, r.file_id
FROM 
	headings h, resources r, unit_resources u
WHERE 
	u.resource_id = r.id
AND 
	r.heading_id = h.id
AND 
	r.resource_type_id = typeId
AND 
	u.unit_id = uid;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spGetUserFromSID`(IN `sid` INT)
BEGIN
SELECT  user_id from students WHERE std_id=sid ;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spGetUserGroup`(IN `groupID` INT)
    NO SQL
BEGIN

	SELECT `user_id` FROM `user_group` WHERE group_id =groupID;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spGetUserMessageID`(IN `userID` INT)
    NO SQL
BEGIN

SELECT `id`
FROM `message` 
WHERE	user_id= userID and msg_delete=0;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spGetUserReplyID`(IN `userID` INT)
    NO SQL
BEGIN 

SELECT `id`
FROM `reply` 
WHERE	user_id=userID and msg_delete =0;
	
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spGetUsersFromRole`(IN `role` INT)
    NO SQL
BEGIN

SELECT	id as userID
FROM	users
WHERE	type = role;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spGetUserToken`(IN `tokn` VARCHAR(100), OUT `userID` INT, OUT `role` INT)
    NO SQL
begin
	select user_id into userID
	from	temp_users
	where	token= tokn;

	SELECT `type` into role
	FROM `users` WHERE id =userID;

end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spGetYearPlanner`(IN `year` YEAR, IN `studentID` INT)
    NO SQL
BEGIN

	SELECT P.id as plannerID,N.id as noteID, N.note, P.title, P.start_date, P.end_date, P.start_time, P.end_time, P.event_color
	FROM planner P, planner_notes N
	WHERE P.std_id =studentID AND YEAR( P.end_date ) >=year AND year >= YEAR( P.start_date ) AND P.id=N.planner_id;


END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spGeUnreadtNotification`(IN `userID` INT)
    NO SQL
BEGIN
	
	

SELECT DISTINCT feed.id as feed_id ,feed_links.link, feed.notification, feed.createdAt
FROM feed
INNER JOIN feed_user ON feed.id = feed_user.notification_id AND feed_user.user_id =userID AND feed_user.status=0

LEFT OUTER JOIN feed_links
ON feed.id = feed_links.notification_id;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spInsertAdmin`(IN `uname` VARCHAR(50), IN `admin_name` VARCHAR(100), IN `type` CHAR(1), IN `st` CHAR(1), IN `pwd` VARCHAR(255))
BEGIN
	
    DECLARE uid int DEFAULT 0;
	INSERT INTO users(username,type,status,password) VALUES(uname,type,st,pwd);
    
     SELECT LAST_INSERT_ID() into uid;
    
    INSERT INTO admin(user_id,name) VALUES (uid,admin_name);
    
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spInsertAssignTutor`(INOUT `userID` INT, IN `packageID` INT, OUT `st` VARCHAR(1), IN `subjectID` INT)
    NO SQL
BEGIN

DECLARE packageSubjectID int DEFAULT 0;
DECLARE rw	int;
DECLARE tutorID int DEFAULT 0;
DECLARE `_rollback` BOOL DEFAULT 0;
DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET `_rollback` = 1;

START TRANSACTION;
	

		SELECT `id` into tutorID
		FROM `tutor` WHERE user_id =userID;

		SELECT  id into packageSubjectID
		FROM `package_subject` 
		WHERE subject_id=subjectID AND `package_id`= packageID;

		if(tutorID >0 AND packageSubjectID>0 )
		THEN

			

			INSERT INTO `tutor_assign`(`tutor_id`, `package_subject_id`) VALUES (tutorID,packageSubjectID);
			
			IF `_rollback` THEN
					SET st ='F';
        			ROLLBACK;
    		ELSE
					SET st ='T';
					COMMIT;
			END IF;
		
		ELSE
			SET st ='F';
		END IF;


 END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spInsertFolder`(IN `foldname` VARCHAR(100), IN `stdID` INT, IN `color` VARCHAR(7), IN `parentID` INT, OUT `st` VARCHAR(1))
BEGIN
	DECLARE rw	int DEFAULT 0;

	
    
    if(parentID =0 )
    THEN
    	INSERT INTO `folder`(`name`, `color`, `std_id`,status) VALUES  (foldname,color,stdID,1);
    	SELECT ROW_COUNT() INTO rw;

		IF(rw>0)
	THEN
		SET st ='T';
	ELSE
		SET st ='F';
	END IF;

    else
  SELect parentID;
     	INSERT INTO folder(name,color,std_id,container_id,status) VALUES (foldname,color,stdID, parentID,1);
		SELECT ROW_COUNT() INTO rw;   

		IF(rw>0)
	THEN
		SET st ='T';
	ELSE
		SET st ='F';
	END IF;
END IF; 
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spInsertHeading`(INOUT `hname` VARCHAR(300), OUT `st` VARCHAR(11))
BEGIN
DECLARE rw	int;

SET st ='F';

   INSERT INTO headings(name) VALUES (hname);

SELECT ROW_COUNT() INTO rw;
	
 	IF(rw>0)
	THEN
		SELECT LAST_INSERT_ID() into st;
	ELSE
		SET st ='F';
	END IF;


   END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spInsertModule`(IN `mname` VARCHAR(200), IN `packSubid` INT, IN `descrip` VARCHAR(250), OUT `st` VARCHAR(1))
BEGIN
DECLARE rw	int;
DECLARE modID	int;
DECLARE `_rollback` BOOL DEFAULT 0;
DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET `_rollback` = 1;

START TRANSACTION;

   INSERT INTO module(name,description) VALUES(mname,descrip);

	IF `_rollback` THEN
        ROLLBACK;
    ELSE

		SELECT LAST_INSERT_ID() into modID;
		INSERT INTO `package_subject_module`(`module_id`, `package_subject_id`) VALUES (modID,packSubid);
 		
		IF `_rollback` THEN
				SET st='F';
				ROLLBACK;
		ELSE
			SET st= 'T';
				COMMIT;
				
		END IF;
		
END IF;
	
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spInsertNotification`(INOUT `notification` VARCHAR(250), INOUT `link` VARCHAR(100), OUT `feedID` VARCHAR(11), INOUT `createDate` DATETIME)
BEGIN
DECLARE rw	int;
DECLARE nid	int;
DECLARE `_rollback` BOOL DEFAULT 0;
DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET `_rollback` = 1;

START TRANSACTION;

	INSERT INTO `feed`(`notification`,createdAt) VALUES (notification,createDate);

	IF `_rollback` THEN
		SET feedID ='ERROR';
        ROLLBACK;
    ELSE
      
		SELECT LAST_INSERT_ID() into nid;
		SET feedID= nid;

    	IF(link = 'No link')
    	THEN
    		INSERT INTO `feed_links`( `notification_id`, `link`) VALUES (nid,link);
			IF `_rollback` THEN
				SET feedID ='ERROR';
        		ROLLBACK;
			ELSE
				COMMIT;
			END IF;

    	ELSE
      			COMMIT;
		END IF;

    
    END IF;

  END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spInsertNotificationUser`(INOUT `userID` INT, INOUT `notificationID` INT, OUT `content` VARCHAR(250), OUT `date` DATETIME)
    NO SQL
BEGIN

DECLARE rw	int;
DECLARE `_rollback` BOOL DEFAULT 0;
DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET `_rollback` = 1;

START TRANSACTION;

	INSERT INTO `feed_user`(`notification_id`, `user_id`, `status`) VALUES (notificationID,userID,0);
	
	IF `_rollback` THEN
		 ROLLBACK;
    ELSE
		SELECT `notification`, `createdAt` into content, date
		FROM `feed` 
		WHERE id=notificationID;
		COMMIT;

	END IF;

  END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spInsertPackage`(IN `pname` VARCHAR(50), IN `gid` INT, IN `cid` INT, OUT `st` VARCHAR(1))
BEGIN
	
DECLARE rw	int;
    
    INSERT INTO package(name,grade_id, curriculum_id) VALUES (pname,gid,cid);
    
    
    
    SELECT ROW_COUNT() INTO rw;

 	IF(rw>0)
	THEN
		SELECT LAST_INSERT_ID() AS pid;

		SET st ='T';
	ELSE
		SET st ='F';
	END IF;

    
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spInsertPackagePrice`(IN `packID` INT, IN `price` DOUBLE, IN `packType` INT, OUT `st` VARCHAR(1))
BEGIN  
DECLARE rw	int;


   INSERT INTO `package_price`(`price`, `package_type_id`, `package_id`) VALUES (price, packType, packID);

SELECT ROW_COUNT() INTO rw;

 	IF(rw>0)
	THEN
		SET st ='T';
	ELSE
		SET st ='F';
	END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spInsertPackageSubject`(IN `pid` INT, IN `subid` INT)
BEGIN  
   INSERT INTO `package_subject`(`package_id`, `subject_id`) VALUES (pid,subid);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spInsertPackageType`(IN `type` VARCHAR(50), IN `month` INT)
BEGIN
	
    INSERT INTO package_type(name,months) VALUES (type,month);
    
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spInsertPayment`(IN `studentID` INT, IN `paytype_id` INT, OUT `st` VARCHAR(11), IN `price` DOUBLE)
BEGIN  
DECLARE rw	int Default 0;

	SET st= 'F';
	
   	INSERT INTO payment(amount,status,payment_type_id,std_id,date) VALUES (price,0,paytype_id,studentID,CURDATE());
	SELECT ROW_COUNT() INTO rw;

    
 	IF(rw>0)
	THEN
     	SELECT  LAST_INSERT_ID() into st;
    	
	ELSE
		SET st ='F';
	END IF;
	

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spInsertPlanner`(IN studentID INT, IN title VARCHAR(250), IN startDate DATE, IN endDate DATE, IN startTime TIME, IN endTime TIME, IN repTypeID INT, IN cDate DATETIME, IN createBy INT, IN lastModify INT, IN color VARCHAR(20), IN note TEXT, OUT plannerID INT, OUT st VARCHAR(1))
BEGIN
	DECLARE rw	int;
    
    INSERT INTO planner(std_id, title, start_date, end_date, start_time, end_time, repeat_type_id, created_date, created_by, last_mod_by, event_color) 
    VALUES (studentID, title, startDate, endDate,  startTime, endTime, repTypeID, cDate, createBy , lastModify , color);
    
    SELECT ROW_COUNT() INTO rw;
    IF(rw>0)
	THEN
		SELECT LAST_INSERT_ID() into plannerID;
        
        if(note <> '')
        then
        		INSERT INTO planner_notes(note, planner_id) VALUES (note, plannerID);
				SELECT ROW_COUNT() INTO rw;
                
				IF(rw>0)
				THEN
					SET st= 'T';
				else
					SET st= 'F';
				end if;
		else
				SET st= 'T';
		end if;
		
	ELSE
		SET st ='F';
	END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spInsertReply`(IN `replyerID` INT, IN `messageID` INT, IN `content` TEXT, OUT `st` VARCHAR(1))
    NO SQL
BEGIN
DECLARE rw	int;
DECLARE fn	varchar(11);
DECLARE msgID	int;
DECLARE `_rollback` BOOL DEFAULT 0;
DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET `_rollback` = 1;

START TRANSACTION;

	INSERT INTO `reply`(`user_id`, `message_id`, `date_time`, `content`)
	VALUES (replyerID,messageID,NOW(),content);

	IF `_rollback` THEN
		SET st ='F';
        ROLLBACK;
    ELSE
		Update 	message
		SET 	reply_count =1
		WHERE	id =messageID;

		IF `_rollback` THEN
					SET st ='F';
        			ROLLBACK;
    			ELSE
					SET st ='T';
					COMMIT;
				END IF;

	END IF;


END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spInsertReportResources`(IN `studentID` INT(11), IN `resourcesID` INT(11), IN `cDate` DATE, IN `reportMessage` TEXT)
BEGIN	
DECLARE rid int DEFAULT 0;

INSERT INTO report_resource
	( student_id, resources_id, report_message, created_date ) 
VALUES 
	(studentID, resourcesID, reportMessage, cDate ); 
    
SELECT LAST_INSERT_ID() AS rid;    
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spInsertResource`(IN `fileName` VARCHAR(50), IN `exten` VARCHAR(10), IN `rname` VARCHAR(100), IN `resTypeID` INT, OUT `st` VARCHAR(1), OUT `resourceID` INT, IN `descrip` VARCHAR(255), IN `headingID` INT, IN `unitID` INT)
BEGIN
DECLARE rw int DEFAULT 0;
DECLARE fid int DEFAULT 0;
DECLARE `_rollback` BOOL DEFAULT 0;
DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET `_rollback` = 1;

START TRANSACTION;

	SET st = 'F';
	SET resourceID = 0;

	INSERT INTO `file`(`name`, `extension`, `createAt`) VALUES (fileName,exten,NOW());
	
	IF `_rollback` THEN
		SET st='F';
        ROLLBACK;
    ELSE
		
		SELECT LAST_INSERT_ID() into fid;
		INSERT INTO resources(name,resource_type_id,file_id,description,heading_id) 
		VALUES (rname,resTypeID,fid,descrip,headingID);
		
		IF `_rollback` THEN
			SET st='F';
        	ROLLBACK;
    	ELSE
			
			SELECT LAST_INSERT_ID() into resourceID;
			CALL spInsertResourceUnit(unitID,resourceID,st);
			
			IF `_rollback` THEN
				SET st='F';
        		ROLLBACK;
    		ELSE
				SET st='T';
				COMMIT;
			END IF;

		END IF;

	END IF;

  	
  
    
   END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spInsertResourceTags`(IN `r_id` INT, IN `t_id` INT, OUT `st` VARCHAR(1))
BEGIN
declare rw int default 0;

  INSERT INTO resource_tags (tag_id, resource_id) VALUES (t_id, r_id);
SELECT ROW_COUNT() INTO rw;

IF(rw>0)
	THEN
		SET st ='T';
	ELSE
		SET st ='F';
	END IF;

  END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spInsertResourceType`(IN `tname` VARCHAR(300))
BEGIN
   INSERT into resource_types(name) VALUES(tname);
   END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spInsertResourceUnit`(IN `uid` INT, IN `rid` INT, OUT `st` VARCHAR(1))
BEGIN

DECLARE rw int DEFAULT 0;
SET st ='F';


  INSERT INTO unit_resources (unit_id, resource_id) VALUES (uid, rid);
  
SELECT ROW_COUNT() INTO rw;

	if(rw > 0)
	THEN
		set st= 'T';
	ELSE
		SET st='F';
	END IF;

  END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spInsertStudentPakage`(IN `stid` INT, IN `pid` INT, IN `ptype` CHAR(1))
BEGIN
    
    UPDATE students 
    SET		package_id= pid, pack_price_type =ptype
    WHERE	std_id= stid;
    
   END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spInsertTags`(INOUT `tname` VARCHAR(100), OUT `st` VARCHAR(11))
BEGIN  
DECLARE rw	int;
SET st ='F';


	INSERT INTO `tags`(`name`) VALUES (tname);

SELECT ROW_COUNT() INTO rw;
	
 	IF(rw>0)
	THEN
		SELECT LAST_INSERT_ID() into st;

	ELSE
		SET st ='F';
	END IF;


   
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spInsertTutorHelpReply`(IN `replyerID` INT, IN `messageID` INT, IN `content` TEXT, OUT `st` VARCHAR(1))
    NO SQL
BEGIN
DECLARE rw	int;
DECLARE fn	varchar(11);
DECLARE msgID	int;
DECLARE `_rollback` BOOL DEFAULT 0;
DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET `_rollback` = 1;

START TRANSACTION;
	
	INSERT INTO `tutor_help_reply`( `content`, `replier_id`, `message_id`,`date_time`)
    VALUES (content,replyerID,messageID,NOW());

    IF `_rollback` THEN
		SET st ='F';
        ROLLBACK;
    ELSE
                                   
        UPDATE `tutor_help_message` SET `reply_count`=1 WHERE `id` =messageID;
                                   
      	
		IF `_rollback` THEN
					SET st ='F';
        			ROLLBACK;
    			ELSE
					SET st ='T';
					COMMIT;
				END IF;

	END IF;


END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spInsertUnit`(IN `uname` VARCHAR(300), IN `mod_id` INT, IN `des` TEXT, OUT `st` VARCHAR(1))
BEGIN  
DECLARE rw	int;

   INSERT INTO unit(module_id,name,description) VALUES(mod_id,uname,des);

SELECT ROW_COUNT() INTO rw;
	
 	IF(rw>0)
	THEN
		SET st ='T';
	ELSE
		SET st ='F';
	END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spInsertUser`(IN `pwd` VARCHAR(255), IN `name` VARCHAR(100), IN `mail` VARCHAR(100), IN `user_type` INT, IN `tel` INT(9), OUT `msg` VARCHAR(1), IN `countryID` INT)
BEGIN
   
DECLARE temp int DEFAULT 0;
DECLARE uid int DEFAULT 0;
DECLARE `_rollback` BOOL DEFAULT 0;
DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET `_rollback` = 1;

START TRANSACTION;

    SET temp = user_type;
    
    INSERT INTO `users`( `email`, `password`, `type`, `status`) VALUES (mail, pwd,user_type,0);
    
	IF `_rollback` THEN
		SET msg ='F';
        ROLLBACK;
    ELSE

		SELECT id into uid
		FROM	users
		WHERE	email= mail;
        
		IF (uid>0) THEN
			
			
			
			IF temp = 1
    		THEN
    			INSERT INTO `admin`( `user_id`, `name`, `telephone`, `country_id`) Values (uid,name,tel,countryID);
        		
				IF `_rollback` THEN
					SET msg ='F';
        			ROLLBACK;
    			ELSE
					SET msg ='T';
					COMMIT;
				END IF;


    		ELSEIF temp=3
    		THEN
    			INSERT INTO `tutor`(`user_id`, `name`, `telephone`,country_id) VALUES(uid,name,tel,countryID);
    
				IF `_rollback` THEN
					SET msg ='F';
        			ROLLBACK;
    			ELSE
					SET msg ='T';
					COMMIT;
				END IF;

    		ELSEIF temp= 4
    		THEN

				INSERT INTO `system_user`(`user_id`, `name`, `telephone`, `country_id`) VALUES(uid,name,tel,countryID);
    		
				IF `_rollback` THEN
					SET msg ='F';
        			ROLLBACK;
    			ELSE
					SET msg ='T';
					COMMIT;
				END IF;

			ELSE
    			SEt msg= 'F';
        
    		END IF;

		ELSE
			SET msg ='F';
        	ROLLBACK;
			
		END IF;
	
	END IF;

  
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spLearningZoneSearchModule`(IN `word` VARCHAR(25), IN `SubID` INT, IN `packID` INT)
    NO SQL
BEGIN

    DECLARE packSubID INT DEFAULT 0;


SELECT `id` into packSubID
FROM `package_subject` 
WHERE `package_id`=packID  AND`subject_id`= SubID;


IF(packSubID >0)
THEN
		SELECT `id` as moduleID, name as moduleName 
		FROM `module` 
		WHERE 	 name LIKE CONCAT('%',word,'%') AND id IN ( 
			SELECT	module_id
    		FROM	package_subject_module
    		WHERE	package_subject_id= packSubID);

END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spLearningZoneSearchResource`(IN `subID` INT, IN `packID` INT, IN `word` VARCHAR(25))
    NO SQL
BEGIN
DECLARE packSubID INT DEFAULT 0;


SELECT `id` into packSubID
FROM `package_subject` 
WHERE `package_id`=packID  AND`subject_id`= SubID;


IF(packSubID >0)
THEN
SELECT Distinct R.id,U.module_id,UR.unit_id, R.name,R.resource_type_id,R.file_id 
FROM	resources R, unit_resources UR, unit U
WHERE	R.name LIKE CONCAT('%',word,'%') AND R.id = UR.resource_id AND UR.unit_id= U.id AND U. module_id IN
 (

		SELECT `id`
		FROM `module` WHERE id IN ( 
			SELECT	DISTINCT module_id
    		FROM	package_subject_module
    		WHERE	package_subject_id= packSubID));

END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spLearningZoneSearchUnit`(IN `packID` INT, IN `subID` INT, IN `word` VARCHAR(25))
    NO SQL
BEGIN
DECLARE packSubID INT DEFAULT 0;


SELECT `id` into packSubID
FROM `package_subject` 
WHERE `package_id`=packID  AND`subject_id`= SubID;


IF(packSubID >0)
THEN

	SELECT	id as unitID, name as unitName, module_id
    FROM	unit
    WHERE	name LIKE CONCAT('%',word,'%') AND module_id IN (

		SELECT `id`
		FROM `module` WHERE id IN ( 
			SELECT	module_id
    		FROM	package_subject_module
    		WHERE	package_subject_id= packSubID ));

END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spMonthlyPlannerCursor`(IN `studentID` INT, IN `searchDate` DATE)
BEGIN
DECLARE dt varchar (10);

  SET dt = EXTRACT(YEAR_MONTH FROM searchDate);

		SELECT  id as reminderID , reminder_date,reminder_time,planner_id 
		from planner_reminder 
		where planner_id IN( 
			SELECT P.id
			FROM planner P
			WHERE P.std_id =studentID AND EXTRACT(YEAR_MONTH FROM P.end_date)>=dt AND dt >= EXTRACT(YEAR_MONTH FROM P.start_date)) ;
	



END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spQuizById`(IN `quizzID` INT)
BEGIN

SELECT * FROM quiz WHERE id = quizzID;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spReadNotification`(IN `notiID` INT)
BEGIN

 UPDATE feed_user
 SET 	status =1  
 WHERE  notification_id= notiID;
  
  END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spResetPassword`(IN `mail` VARCHAR(100), IN `oldpwd` VARCHAR(255), IN `newpwd` VARCHAR(255), OUT `st` VARCHAR(1))
    NO SQL
BEGIN
DECLARE rw	int;
DECLARE available int default 0;
	
SELECT count(*) INTO available
FROM `users` 
WHERE email= mail AND password= oldpwd;

IF(available>0)
THEN
	UPDATE users
	SET password= newpwd
	WHERE	email= mail;

	SELECT ROW_COUNT() INTO rw;

	IF(rw>0)
	THEN
		SET st ='T';
	ELSE
		SET st ='F';
	END IF;

END IF;
 	
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spSearchFolders`(IN `stdID` INT, IN `parent` INT, IN `word` VARCHAR(20))
    NO SQL
BEGIN

IF(parent =0 )
THEN
	SELECT 	`id` as folder_id, folder.`name` as folder_name, `color`  
	FROM 	`folder` 
	WHERE 	`std_id` =stdID AND folder. name LIKE CONCAT('%',word,'%') AND status =1;

ELSE
	SELECT 	`id` as folder_id, folder.`name` as folder_name, `color`  
	FROM 	`folder` 
	WHERE 	`std_id` =stdID AND `container_id` =parent AND status =1 AND folder.name LIKE CONCAT('%',word,'%') ;

END IF;
  
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spSearchNote`(IN `stdID` INT, IN `parent` INT, IN `word` VARCHAR(20))
    NO SQL
BEGIN

IF(parent = 0)
THEN
	SELECT 	`id` as note_id, `text`, `color` 
	FROM 	`notes` 
	WHERE 	text LIKE CONCAT('%',word,'%') AND status =1 AND student_id=stdID ;

ELSE
	SELECT 	`id` as note_id, `text`, `color` 
	FROM 	`notes` 
	WHERE 	folder_id =parent AND text LIKE CONCAT('%',word,'%') AND status =1  AND student_id=stdID;
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spSearchResources`(IN `stdID` INT, IN `parent` INT, IN `word` VARCHAR(20))
    NO SQL
BEGIN
SELECT 	`name`, `resource_type_id`, `file_id` 
FROM 	`resources` 
WHERE 	name LIKE CONCAT('%',word,'%') AND id IN (
	SELECT 	`resource_id` 
	FROM 	`folder_resource` 
	WHERE 	folder_id =parent);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spStudentInbox`(IN `userID` INT, IN `startLimit` INT, IN `endLimit` INT)
    NO SQL
BEGIN

	
SELECT DISTINCT message.id, message.`subject`, message.`content`,message.`date_time`
FROM message ,reply
where message.user_id =userID AND message.id = reply.message_id AND reply.`status` = 0 AND message.`msg_delete`= 0
ORDER BY message.date_time
LIMIT startLimit,endLimit;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spUpdateCountryPermission`(IN `c_id` INT, IN `perm` CHAR(1))
BEGIN
	UPDATE 	`country` 
    SET		allowed= perm 
    WHERE	id = c_id;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spUpdatecurriculum`(IN `cid` INT, IN `cname` VARCHAR(20))
BEGIN
	UPDATE 	curriculum 
    SET		name= cname 
    WHERE	id = cid;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spUpdateFolder`(IN `f_name` VARCHAR(100), IN `color_code` VARCHAR(7), IN `f_id` INT)
BEGIN
	
    UPDATE    folder
    SET		name =f_name,color=color_code
    WHERE	 id= f_id;
    
     
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spUpdateFolderResource`(IN `fr_id` INT, IN `fold_id` INT, IN `f_name` VARCHAR(50), IN `link` VARCHAR(200))
BEGIN

  UPDATE folder_resource
  SET	name=f_name,url=link,folder_id=fold_id
  WHERE	id = fr_id;
  
  END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spUpdateGrade`(IN `gid` INT, IN `name` CHAR(3))
BEGIN
	UPDATE 	grade
    SET		grade=name 
    WHERE	id = gid;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spUpdateHeading`(IN `hname` VARCHAR(300), IN `hid` INT)
BEGIN
   UPDATE headings
   SET name=hname
   WHERE id= hid;
   END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spUpdateModule`(IN `moduleID` INT, IN `modName` VARCHAR(200), IN `descrip` VARCHAR(250))
BEGIN
	UPDATE 	module
    SET		name=modName,description=descrip
    WHERE	id = moduleID;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spUpdateNotes`(IN `note` VARCHAR(500), IN `fold_id` INT, IN `n_id` INT, OUT `st` CHAR(1), IN `n_color` VARCHAR(10))
BEGIN
DECLARE rw	int;
    
    if(fold_id =0 )
    THEN
    	 UPDATE notes
  		SET	text = note,color=n_color   WHERE	id = n_id;
		SELECT ROW_COUNT() INTO rw;	
 	
		IF(rw>0)
		THEN
			SET st ='T';
		ELSE
			SET st ='F';
		END IF;

    else
  
		SELect fold_id;
     	 
		UPDATE notes
  		SET	text = note, folder_id= fold_id,color=n_color   
		WHERE	id = n_id;


		SELECT ROW_COUNT() INTO rw;	
 	
		IF(rw>0)
		THEN
			SET st ='T';
		ELSE
			SET st ='F';
		END IF;   
	

	END IF; 

 
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spUpdatePackage`(IN `pid` INT, IN `pname` VARCHAR(50), IN `gid` INT, IN `cid` INT)
BEGIN
	UPDATE 	package
    SET		name= pname, grade_id=gid, curriculum_id=cid
    WHERE	id = pid;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spUpdatePackagePrice`(IN `pp_id` INT, IN `p_price` DOUBLE, IN `pck_id` INT, IN `p_type` INT)
BEGIN
	UPDATE 	package_price
    SET		price =p_price, package_type_id= p_type, package_id= pck_id
    WHERE	id = pp_id;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spUpdatePackageSubject`(IN `pid` INT, IN `pckid` INT, IN `sid` INT)
BEGIN
	UPDATE 	package_subject
    SET		package_id=pckid,subject_id= sid
    WHERE	id = pid;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spUpdatePackageType`(IN `type` VARCHAR(50), IN `month` INT, IN `packType_id` INT)
BEGIN
	
    UPDATE package_type
    SET name=type,months= month
    WHERE id =packType_id;
    
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spUpdatePaying`(IN `p_id` INT, IN `sid` INT, IN `titl` CHAR(3), IN `f_name` VARCHAR(100), IN `l_name` VARCHAR(100), IN `nic` VARCHAR(15), IN `addr` VARCHAR(500), IN `tel` VARCHAR(15), IN `mobile` VARCHAR(15), IN `email` VARCHAR(50), IN `rel` VARCHAR(10))
BEGIN
   	UPDATE `payee` SET `title`=titl,`fname`=f_name,`lname`=l_name,`nic_passport`=nic,`address`=addr,`tel`=tel,`mobile`=mobile,`email`=email,`student_id`=sid,`relationship`=rel 
    WHERE id= p_id;
   END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spUpdateResource`(IN `rname` VARCHAR(300), IN `rurl` VARCHAR(1000), IN `rtid` INT, IN `rid` INT)
BEGIN
   UPDATE resources
   SET url =rurl,name = rname,resource_type_id=rid
  WHERE id= rid;
  
  END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spUpdateResourceType`(IN `tname` VARCHAR(300), IN `tid` INT)
BEGIN
   UPDATE resource_types
   SET name=tname
   WHERE id= tid;
   END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spUpdateStudent`(IN `id` INT, IN `fname` VARCHAR(30), IN `gender` CHAR(1), IN `dob` VARCHAR(50), IN `nationality` VARCHAR(20), IN `country` INT(3), IN `school` VARCHAR(50), IN `grade` INT, IN `intake` VARCHAR(25), IN `type` INT, IN `aboutUs` VARCHAR(50), OUT `st` CHAR(1))
BEGIN
    
    
    UPDATE 	students
    SET		full_name=fname,gender= gender, dob= dob, nation=nationality,country =country, school=school, grade= grade, intake_month= intake, 
    school_type= type, found_through= aboutUs
    WHERE std_id = id;
   
     
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spUpdateSubject`(IN `sid` INT, IN `sname` VARCHAR(50))
BEGIN
	UPDATE 	subject
    SET		name=sname
    WHERE	id = sid;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spUpdateTag`(IN `tname` VARCHAR(300), IN `tid` INT)
BEGIN
   UPDATE tags
   SET name=tname
   WHERE id= tid;
   END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spUpdateUnit`(IN `uid` INT, IN `uname` VARCHAR(300), IN `mid` INT)
BEGIN
	UPDATE 	unit
    SET		name=uname, module_id= mid
    WHERE	id = uid;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spValidateCountry`(IN `cid` INT, OUT `st` CHAR(1))
BEGIN
	SELECT 	allowed into st
    FROM	country
    WHERE	id= cid;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spValidateEmail`(IN `mail` VARCHAR(100), OUT `mobile` VARCHAR(15))
BEGIN
	SELECT	mobile
    FROM	users
    WHERE	email= mail;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spValidateLogin`(IN `mail` VARCHAR(100), IN `pwd` VARCHAR(255), OUT `uid` INT, OUT `role` INT, OUT `userName` VARCHAR(100), OUT `com_status` INT)
BEGIN

	SELECT 	id,type,comp_status INTO uid,role,com_status
    FROM	users
    WHERE	email= mail and password= pwd and status=1;

IF role =1
THEN
	SELECT name into userName
	FROM 	admin
	WHERE	user_id = uid;
	

ELSEIF role =2
THEN
	SELECT full_name into userName
	FROM 	students
	WHERE	user_id = uid;

ELSEIF role=3
THEN

	SELECT name into userName
	FROM 	tutor
	WHERE	user_id = uid;

ELSEIF role =4
THEN

	SELECT name into userName
	FROM 	system_user
	WHERE	user_id = uid;

ELSE 
	SET userName ='no name';
END IF;
    
		
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spValidateTempStudentMail`(IN `mail` VARCHAR(100))
BEGIN

 SELECT std_id FROM `temp_students` WHERE email= mail;

  END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spValidateUserStatus`(IN `u_id` INT, IN `st` INT(1))
BEGIN
	UPDATE users
    SET		status= st
    WHERE	id = u_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spYearPlannerCursor`(IN `studentID` INT, IN `year` YEAR)
    NO SQL
BEGIN


		SELECT  id as reminderID , reminder_date,reminder_time,planner_id 
		from planner_reminder 
		where planner_id IN( 
			SELECT P.id
			FROM planner P
			WHERE P.std_id =studentID AND YEAR( P.end_date ) >=year AND year >= YEAR( P.start_date )) ;
	



END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `updatePaymentMethod`(IN `Uid` INT(10), IN `Paymet_method` VARCHAR(50))
BEGIN 
UPDATE payee SET payment_method=Paymet_method  WHERE student_id=uid ;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `waste`(IN `countryID` INT, IN `mobile` VARCHAR(9), IN `fullname` VARCHAR(60), IN `uid` INT, IN `packID` INT, IN `priceTypeID` INT, OUT `st` VARCHAR(11), IN `payTypeID` INT, IN `amount` DOUBLE)
BEGIN

DECLARE ref varchar(12);
DECLARE sid	int (6);
DECLARE `_rollback` BOOL DEFAULT 0;
DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET `_rollback` = 1;

START TRANSACTION;
SET st ='F';
        
        
    INSERT INTO students(country,full_name,user_id,package_id) VALUES(countryID,fullname,uid,packID);
        
	IF `_rollback` THEN
        ROLLBACK;
    ELSE
      
     	SELECT std_id INTO sid
		FROM	students
		WHERE	user_id= uid;
	
 		IF(sid='')
		THEN
			SET st='F';
 		
		ELSE

			CALL `spCreateStudentID`(sid,ref);
			IF `_rollback` THEN
				SET st='F';
				ROLLBACK;
			ELSE

				CALL spInsertPayment(sid,payTypeID,st,amount);
				IF `_rollback` THEN
					SET st='F';
					ROLLBACK;
				ELSE

					SELECT fnInsertStudentMobile(mobile,sid,1);
					IF `_rollback` THEN
						SET st='F';
						ROLLBACK;
					ELSE
						SELECT  `fnInsertStudentPakcagePrice` (sid , priceTypeID); 
						IF `_rollback` THEN
							SET st='F';
							ROLLBACK;
						ELSE
						
							UPDATE	students
							SET		reference = ref
							WHERE	std_id= sid;

							IF `_rollback` THEN
								SET st='F';
								ROLLBACK;
							ELSE
								SET st= 'T';
								COMMIT;
								
							END IF;
							
						END IF;
					
					END IF;
				
				END IF;
			
			END IF;
		
		END IF;
	
	END IF;
        

     
END$$

--
-- Functions
--
CREATE DEFINER=`root`@`localhost` FUNCTION `fnaddToDoubt`(`qzId` INT, `questionId` INT) RETURNS varchar(1) CHARSET latin1
BEGIN
DECLARE rw	int;
DECLARE st	varchar(1);

 UPDATE quiz_question SET doubt = 1 WHERE quiz_id = qzId AND question_id = questionId;
 
 SELECT ROW_COUNT() INTO rw;	
 	IF( rw>0 )	
	THEN	
		SET st ='T';		
	ELSE
		SET st ='F';		
	END IF;	
RETURN st;
END$$

CREATE DEFINER=`tester`@`%` FUNCTION `fnDeleteAllPlanner`(`plannerID` INT, `titl` VARCHAR(250), `startDate` DATE, `endDate` DATE, `startTime` TIME, `endTime` TIME, `repTypeID` INT, `color` VARCHAR(20)) RETURNS varchar(1) CHARSET latin1
BEGIN
DECLARE rw	int;
DECLARE st	varchar(1);

DELETE FROM `planner` WHERE std_id= studentID;
   
   SELECT ROW_COUNT() INTO rw;

IF(rw>0)
THEN
	SET st ='T';
ELSE
	SET st ='F';
END IF;
   
RETURN st;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `fnDeleteCountry`(`cid` INT) RETURNS varchar(1) CHARSET latin1
BEGIN
DECLARE st	varchar(1);
DECLARE rw	int;

DELETE FROM country WHERE id= cid;


SELECT ROW_COUNT() INTO rw;
	
 	IF(rw>0)
	THEN
		SET st ='T';
	ELSE
		SET st ='F';
	END IF;
RETURN st;

END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `fnDeleteCurriculum`(`cid` INT) RETURNS varchar(1) CHARSET latin1
BEGIN
DECLARE rw	int;
DECLARE st	varchar(1);

	DELETE FROM curriculum WHERE id = cid;

SELECT ROW_COUNT() INTO rw;
	
 	IF(rw>0)
	THEN
		SET st ='T';
	ELSE
		SET st ='F';
	END IF;
RETURN st;

END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `fnDeleteFolder`(`fold_id` INT) RETURNS varchar(1) CHARSET latin1
BEGIN
DECLARE rw	int;
DECLARE st	varchar(1);

  update  folder set status=0
  WHERE id = fold_id;

  SELECT ROW_COUNT() INTO rw;
	
 	IF(rw>0)
	THEN
		SET st ='T';
	ELSE
		SET st ='F';
	END IF;
RETURN st;

  END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `fnDeleteFolderResource`(`foldRes_id` INT) RETURNS varchar(1) CHARSET latin1
BEGIN
DECLARE rw	int;
DECLARE st	varchar(1);

  DELETE FROM folder_resource
  WHERE id = foldRes_id;

  SELECT ROW_COUNT() INTO rw;
	
 	IF(rw>0)
	THEN
		SET st ='T';
	ELSE
		SET st ='F';
	END IF;
RETURN st;


  END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `fnDeleteGrade`(`gid` INT) RETURNS varchar(1) CHARSET latin1
BEGIN
DECLARE rw	int;
DECLARE st	varchar(1);

DELETE FROM grade WHERE ID= GID;

SELECT ROW_COUNT() INTO rw;
	
 	IF(rw>0)
	THEN
		SET st ='T';
	ELSE
		SET st ='F';
	END IF;
RETURN st;

END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `fnDeleteGroup`(`groupID` INT) RETURNS varchar(1) CHARSET latin1
    NO SQL
BEGIN

DECLARE rw	int;
DECLARE st	varchar(1) DEFAULT 'F';

DELETE FROM `group` WHERE id= groupID;
 
SELECT ROW_COUNT() INTO rw;
	
 	IF(rw>0)
	THEN
		SET st ='T';
	ELSE
		SET st ='F';
	END IF;
RETURN st;

  END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `fnDeleteHeadings`(`hid` INT) RETURNS varchar(1) CHARSET latin1
BEGIN
DECLARE rw	int;
DECLARE st	varchar(1);

DELETE FROM headings WHERE id= hid;

SELECT ROW_COUNT() INTO rw;
	
 	IF(rw>0)
	THEN
		SET st ='T';
	ELSE
		SET st ='F';
	END IF;
RETURN st;

END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `fnDeleteMessageAttachment`(`attchmentID` INT) RETURNS varchar(1) CHARSET latin1
    NO SQL
BEGIN
DECLARE st	varchar(1);
DECLARE rw	int;

DELETE FROM `message_attachment` WHERE id = attchmentID;


SELECT ROW_COUNT() INTO rw;
	
 	IF(rw>0)
	THEN
		SET st ='T';
	ELSE
		SET st ='F';
	END IF;
RETURN st;

END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `fnDeleteModule`(`mid` INT) RETURNS varchar(1) CHARSET latin1
BEGIN
DECLARE rw	int;
DECLARE st	varchar(1);

DELETE FROM module WHERE id= mid;

SELECT ROW_COUNT() INTO rw;
	
 	IF(rw>0)
	THEN
		SET st ='T';
	ELSE
		SET st ='F';
	END IF;
RETURN s;


END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `fnDeleteNotes`(`note_id` INT) RETURNS varchar(1) CHARSET latin1
BEGIN
DECLARE rw	int;
DECLARE st	varchar(1);

update  notes set status=0 
  WHERE id = note_id;
  
SELECT ROW_COUNT() INTO rw;
	
 	IF(rw>0)
	THEN
		SET st ='T';
	ELSE
		SET st ='F';
	END IF;
RETURN st;

  END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `fnDeleteOnePlanner`(`plannerID` INT) RETURNS varchar(1) CHARSET latin1
BEGIN
DECLARE rw	int;
DECLARE st	varchar(1);

DELETE FROM `planner` WHERE id= plannerID;
   
   SELECT ROW_COUNT() INTO rw;
IF(rw>0)
THEN
SET st ='T';
ELSE
SET st ='F';
END IF;
   
RETURN st;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `fnDeletePackage`(`pid` INT) RETURNS varchar(1) CHARSET latin1
BEGIN
DECLARE rw	int;
DECLARE st	varchar(1);

    	delete from package WHERE id= pid;

SELECT ROW_COUNT() INTO rw;
	
 	IF(rw>0)
	THEN
		SET st ='T';
	ELSE
		SET st ='F';
	END IF;
RETURN st;

    END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `fnDeletePackagePrice`(`pid` INT) RETURNS varchar(1) CHARSET latin1
BEGIN
DECLARE rw	int;
DECLARE st	varchar(1);

DELETE FROM package_price WHERE id= pid;

SELECT ROW_COUNT() INTO rw;
	
 	IF(rw>0)
	THEN
		SET st ='T';
	ELSE
		SET st ='F';
	END IF;
RETURN st;

END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `fnDeletePackageSubject`(`pid` INT) RETURNS varchar(1) CHARSET latin1
BEGIN
DECLARE rw	int;
DECLARE st	varchar(1);

DELETE FROM package_subject WHERE id= pid;
SELECT ROW_COUNT() INTO rw;
	
 	IF(rw>0)
	THEN
		SET st ='T';
	ELSE
		SET st ='F';
	END IF;
RETURN st;

END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `fnDeletePayment`(`pid` INT) RETURNS varchar(1) CHARSET latin1
BEGIN

DECLARE rw	int;
DECLARE st	varchar(1);

DELETE FROM payment WHERE id= pid;
SELECT ROW_COUNT() INTO rw;
	
 	IF(rw>0)
	THEN
		SET st ='T';
	ELSE
		SET st ='F';
	END IF;
RETURN st;

END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `fnDeletePaymentType`(`pid` INT) RETURNS varchar(1) CHARSET latin1
BEGIN
DECLARE rw	int;
DECLARE st	varchar(1);

DELETE FROM payment_type WHERE id= pid;

SELECT ROW_COUNT() INTO rw;
	
 	IF(rw>0)
	THEN
		SET st ='T';
	ELSE
		SET st ='F';
	END IF;
RETURN st;

END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `fnDeleteQuiz`(`quizID` INT) RETURNS varchar(1) CHARSET latin1
    NO SQL
BEGIN

DECLARE rw	int;
DECLARE st	varchar(1) DEFAULT 'F';

DELETE FROM `quiz` WHERE id= quizID;

SELECT ROW_COUNT() INTO rw;
	
 	IF(rw>0)
	THEN
		SET st ='T';
	ELSE
		SET st ='F';
	END IF;
RETURN st;

  END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `fnDeleteReply`(`replyID` INT) RETURNS varchar(1) CHARSET latin1
BEGIN
DECLARE rw	int;
DECLARE st	varchar(1);

UPDATE reply
SET msg_delete =1
WHERE id =replyID;

SELECT ROW_COUNT() INTO rw;

 	IF(rw>0)
	THEN
		SET st ='T';
	ELSE
		SET st ='F';
	END IF;
    
RETURN st;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `fnDeleteReplyAttachment`(`attchmentID` INT) RETURNS varchar(1) CHARSET latin1
    NO SQL
BEGIN
DECLARE st	varchar(1);
DECLARE rw	int;

DELETE FROM reply_attachment WHERE id= attchmentID;


SELECT ROW_COUNT() INTO rw;
	
 	IF(rw>0)
	THEN
		SET st ='T';
	ELSE
		SET st ='F';
	END IF;
RETURN st;

END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `fnDeleteResource`(`rid` INT) RETURNS varchar(1) CHARSET latin1
BEGIN
DECLARE rw	int;
DECLARE st	varchar(1);

DELETE FROM resources WHERE id= rid;
SELECT ROW_COUNT() INTO rw;
	
 	IF(rw>0)
	THEN
		SET st ='T';
	ELSE
		SET st ='F';
	END IF;
RETURN st;

END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `fnDeleteResourceTags`(`rid` INT) RETURNS varchar(1) CHARSET latin1
BEGIN
DECLARE rw	int;
DECLARE st	varchar(1);

DELETE FROM resource_tags WHERE id= rid;

SELECT ROW_COUNT() INTO rw;
	
 	IF(rw>0)
	THEN
		SET st ='T';
	ELSE
		SET st ='F';
	END IF;
RETURN st;

END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `fnDeleteResourceType`(`rid` INT) RETURNS varchar(1) CHARSET latin1
BEGIN
DECLARE rw	int;
DECLARE st	varchar(1);

DELETE FROM resource_types WHERE id= rid;

SELECT ROW_COUNT() INTO rw;
	
 	IF(rw>0)
	THEN
		SET st ='T';
	ELSE
		SET st ='F';
	END IF;
RETURN st;


END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `fnDeleteReviewMail`(`ID` INT) RETURNS varchar(1) CHARSET latin1
BEGIN

DECLARE rw	int;
DECLARE st	varchar(1);

 DELETE FROM `review_email` WHERE id= ID;

SELECT ROW_COUNT() INTO rw;
	
 	IF(rw>0)
	THEN
		SET st ='T';
	ELSE
		SET st ='F';
	END IF;
RETURN st;

  END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `fnDeleteStudentMobile`(`ID` INT) RETURNS varchar(1) CHARSET latin1
    NO SQL
BEGIN

DECLARE rw	int;
DECLARE st	varchar(1);

DELETE FROM `student_mobile` WHERE id=ID; 
 
SELECT ROW_COUNT() INTO rw;
	
 	IF(rw>0)
	THEN
		SET st ='T';
	ELSE
		SET st ='F';
	END IF;
RETURN st;

  END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `fnDeleteSubject`(`sid` INT) RETURNS varchar(1) CHARSET latin1
BEGIN
DECLARE rw	int;
DECLARE st	varchar(1);

    	delete from subject WHERE id= sid;
SELECT ROW_COUNT() INTO rw;
	
 	IF(rw>0)
	THEN
		SET st ='T';
	ELSE
		SET st ='F';
	END IF;
RETURN st;

    END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `fnDeleteTags`(`tid` INT) RETURNS varchar(1) CHARSET latin1
BEGIN
DECLARE rw	int;
DECLARE st	varchar(1);

DELETE FROM tags WHERE id= tid;
SELECT ROW_COUNT() INTO rw;
	
 	IF(rw>0)
	THEN
		SET st ='T';
	ELSE
		SET st ='F';
	END IF;
RETURN st;


END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `fnDeletetemp_students`(`sid` INT) RETURNS varchar(1) CHARSET latin1
BEGIN
DECLARE rw	int;
DECLARE st	varchar(1);

    	delete from temp_students WHERE std_id= sid;
SELECT ROW_COUNT() INTO rw;
	
 	IF(rw>0)
	THEN
		SET st ='T';
	ELSE
		SET st ='F';
	END IF;
RETURN st;

    END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `fnDeletetem_code`(`userID` INT) RETURNS varchar(1) CHARSET latin1
    NO SQL
BEGIN

DECLARE rw	int;
DECLARE st	varchar(1);

DELETE FROM `temp_codes` WHERE user_id =userID;

SELECT ROW_COUNT() INTO rw;

 	IF(rw>0)
	THEN
		SET st ='T';
	ELSE
		SET st ='F';
	END IF;
RETURN st;

END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `fnDeleteTutorHelpReply`(`replyID` INT) RETURNS varchar(1) CHARSET latin1
    NO SQL
BEGIN
DECLARE rw	int;
DECLARE st	varchar(1);

UPDATE `tutor_help_reply` SET `msg_delete`=1 WHERE `id`=replyID;

SELECT ROW_COUNT() INTO rw;

 	IF(rw>0)
	THEN
		SET st ='T';
	ELSE
		SET st ='F';
	END IF;
    
RETURN st;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `fnDeleteUnit`(`uid` INT) RETURNS varchar(1) CHARSET latin1
BEGIN

DECLARE rw	int;
DECLARE st	varchar(1);

    	delete from unit WHERE id= uid;

SELECT ROW_COUNT() INTO rw;
	
 	IF(rw>0)
	THEN
		SET st ='T';
	ELSE
		SET st ='F';
	END IF;
RETURN st;

    END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `fnDeleteUnitResource`(`uid` INT) RETURNS varchar(1) CHARSET latin1
BEGIN
DECLARE rw	int;
DECLARE st	varchar(1);

DELETE FROM unit_resources WHERE id= uid;
SELECT ROW_COUNT() INTO rw;
	
 	IF(rw>0)
	THEN
		SET st ='T';
	ELSE
		SET st ='F';
	END IF;
RETURN st;

END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `fnDeleteUser`(`uid` INT) RETURNS varchar(1) CHARSET latin1
BEGIN
DECLARE rw	int;
DECLARE st	varchar(1);

	DELETE FROM users WHERE id= uid;
SELECT ROW_COUNT() INTO rw;
	
 	IF(rw>0)
	THEN
		SET st ='T';
	ELSE
		SET st ='F';
	END IF;
RETURN st;

END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `fnGetStudentID`(`userID` INT) RETURNS int(11)
    NO SQL
BEGIN
DECLARE sudentID int default 0;

	SELECT std_id into sudentID
	FROM	students
	WHERE	user_id= userID;

RETURN sudentID;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `fnInsertAnswer`(`answer` TEXT, `correct` VARCHAR(100), `date` DATETIME, `questionID` INT, `questionTypeID` INT) RETURNS varchar(1) CHARSET latin1
    NO SQL
BEGIN

DECLARE rw	int;
DECLARE st	varchar(1);

INSERT INTO `answer`(`answer`, `correct`, `created_date`, `question_id`, `question_type_id`)
VALUES(answer,correct,date,questionID,questionTypeID);

SELECT ROW_COUNT() INTO rw;
	
 	IF(rw>0)
	THEN
		SET st ='T';
	ELSE
		SET st ='F';
	END IF;
RETURN st;

  END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `fnInsertCurriculum`(`cname` VARCHAR(50)) RETURNS varchar(1) CHARSET latin1
BEGIN
DECLARE rw	int;
DECLARE st	varchar(1);
	
    INSERT INTO curriculum(name) VALUES (cname);

   SELECT ROW_COUNT() INTO rw;
	
 	IF(rw>0)
	THEN
		SET st ='T';
	ELSE
		SET st ='F';
	END IF;
RETURN st; 
END$$

CREATE DEFINER=`tester`@`%` FUNCTION `fnInsertFile`(`exten` VARCHAR(10), `fileName` VARCHAR(50)) RETURNS varchar(11) CHARSET latin1
BEGIN
DECLARE rw	int;
DECLARE st	varchar(11);
DECLARE fileID	int;

	INSERT INTO `file`(`name`, `extension`, `createAt`) VALUES (fileName,exten,NOW());
    
    SELECT ROW_COUNT() INTO rw;
 	IF(rw>0)
	THEN
		SELECT LAST_INSERT_ID() into fileID;
		SET st =fileID;
	ELSE
		SET st ='F';
	END IF;
RETURN st;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `fnInsertFolderResource`(`resourceID` INT, `foldID` INT) RETURNS varchar(1) CHARSET latin1
BEGIN
DECLARE rw	int;
DECLARE st	varchar(1);

  INSERT INTO folder_resource (resource_id,folder_id) VALUES ( resourceID,foldID);
 
SELECT ROW_COUNT() INTO rw;
	
 	IF(rw>0)
	THEN
		SET st ='T';
	ELSE
		SET st ='F';
	END IF;
RETURN st;
  END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `fnInsertGrade`(`grade` VARCHAR(50)) RETURNS varchar(1) CHARSET latin1
BEGIN
	DECLARE rw	int;
DECLARE st	varchar(1);

    INSERT INTO grade(grade) VALUES (grade);

SELECT ROW_COUNT() INTO rw;
	
 	IF(rw>0)
	THEN
		SET st ='T';
	ELSE
		SET st ='F';
	END IF;
RETURN st;

END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `fnInsertGroup`(`groupName` VARCHAR(100)) RETURNS varchar(1) CHARSET latin1
    NO SQL
BEGIN

DECLARE rw	int;
DECLARE st	varchar(1) DEFAULT 'F';

INSERT INTO `group`(`name`) VALUES (groupName);

SELECT ROW_COUNT() INTO rw;
	
 	IF(rw>0)
	THEN
		SET st ='T';
	ELSE
		SET st ='F';
	END IF;
RETURN st;

  END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `fnInsertHelper`(`hname` VARCHAR(15), `hcolor` VARCHAR(15)) RETURNS varchar(1) CHARSET latin1
BEGIN
DECLARE rw	int;
DECLARE st	varchar(1);

  INSERT INTO `helpers`(`name`, `color`) VALUES (hname,hcolor);
 
SELECT ROW_COUNT() INTO rw;
	
 	IF(rw>0)
	THEN
		SET st ='T';
	ELSE
		SET st ='F';
	END IF;
RETURN st;

  END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `fnInsertInterest`(`interest` VARCHAR(500), `subject` VARCHAR(100), `interestTopic` VARCHAR(100), `ambitions` VARCHAR(200), `qut` TEXT, `studentID` INT) RETURNS varchar(1) CHARSET latin1
    NO SQL
BEGIN
DECLARE rw	int;
DECLARE st	varchar(1);

INSERT INTO `interest`(`interests`, `fav_subject`, `topic`, `ambition`, `quote`, `std_id`) VALUES(interest,subject, interestTopic, ambitions,qut, studentID );

SELECT ROW_COUNT() INTO rw;

 	IF(rw>0)
	THEN
		SET st ='T';
	ELSE
		SET st ='F';
	END IF;
    
RETURN st;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `fnInsertMessage`(`senderid` INT, `subject` VARCHAR(20), `content` TEXT, `helperID` INT) RETURNS varchar(11) CHARSET latin1
BEGIN
DECLARE rw	int;
DECLARE st	varchar(11);

  INSERT INTO message(`subject`, `content`, `date_time`, `user_id`,helper_id) 
VALUES (subject, content, NOW(), senderid,helperID);
 
SELECT ROW_COUNT() INTO rw;
	
 	IF(rw>0)
	THEN
		SELECT LAST_INSERT_ID() into st;
	ELSE
		SET st ='F';
	END IF;
RETURN st;

  END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `fnInsertMessageAttachment`(`msgID` INT, `fileName` VARCHAR(50), `exten` VARCHAR(10)) RETURNS varchar(1) CHARSET latin1
    NO SQL
BEGIN
DECLARE rw int DEFAULT 0;
DECLARE fileID int DEFAULT 0;
DECLARE st varchar(1);

	INSERT INTO `file`(`name`, `extension`, `createAt`) VALUES (fileName,exten,NOW());
	SELECT ROW_COUNT() into rw;
	
	IF(rw>0)
	THEN
		SELECT LAST_INSERT_ID() into fileID;

		INSERT INTO `message_attachment`(`message_id`, `file_id`) VALUES (msgID,fileID);
	SELECT ROW_COUNT() INTO rw;
	
	if(rw > 0)
	THEN
		set st= 'T';
	ELSE
		SET st='F';
	END IF;

	ELSE

		SET st='F';

	END IF;

  	Return st;
  
    
   END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `fnInsertNotes`(`note` VARCHAR(500), `folderID` INT, `color` VARCHAR(10), `studentID` INT) RETURNS varchar(5) CHARSET latin1
BEGIN
DECLARE rw	int;
DECLARE st	varchar(1);

IF(folderID=0)
THEN
	INSERT INTO `notes`(`text`, `color`, `student_id`,status) 
  VALUES (note, color, studentID,1);

	SELECT ROW_COUNT() INTO rw;
	
 	IF(rw>0)
	THEN
		SET st ='T';
	ELSE
		SET st ='F';
	END IF;

ELSE

INSERT INTO `notes`(`text`, `folder_id`, `color`, `student_id`,status) 
  VALUES (note, folderID, color, studentID,1);

SELECT ROW_COUNT() INTO rw;
	
 	IF(rw>0)
	THEN
		SET st ='T';
	ELSE
		SET st ='F';
	END IF;
END IF;
RETURN st;

  
  END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `fnInsertPaymentType`(`tname` VARCHAR(200), `url` VARCHAR(500), `acc` VARCHAR(15)) RETURNS varchar(1) CHARSET latin1
BEGIN
DECLARE rw	int;
DECLARE st	varchar(1);

    INSERT INTO payment_type(name,image_url,accNo) VALUES (tname,url,acc);

SELECT ROW_COUNT() INTO rw;
	
 	IF(rw>0)
	THEN
		SET st ='T';
	ELSE
		SET st ='F';
	END IF;
RETURN st;

   END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `fnInsertPlannerReminder`(plannerID int, remDate date, remTime time) RETURNS varchar(1) CHARSET latin1
BEGIN
DECLARE rw	int;
DECLARE st	varchar(1);

INSERT INTO planner_reminder(planner_id, reminder_date, reminder_time) VALUES  (plannerID,remDate,remTime);
  
  SELECT ROW_COUNT() INTO rw;
IF(rw>0)
THEN
SET st ='T';
ELSE
SET st ='F';
END IF;
  
RETURN st;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `fnInsertQuestion`(`question` TEXT, `description` VARCHAR(255), `gradeID` INT, `curriculumID` INT, `unitID` INT, `subjectID` INT, `moduleID` INT, `date` DATETIME) RETURNS varchar(11) CHARSET latin1
    NO SQL
BEGIN

DECLARE rw	int;
DECLARE st	varchar(11);

INSERT INTO `question`(`question`, `description`, `created_date`, `grade_id`, `curriculum_id`, `unit_id`, `subject_id`, `module_id`) 
VALUES(question,description,date, gradeID, curriculumID, unitID, subjectID, moduleID);

SELECT ROW_COUNT() INTO rw;
	
 	IF(rw>0)
	THEN
		SELECT LAST_INSERT_ID() into st;

	ELSE
		SET st ='F';
	END IF;

RETURN st;

  END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `fnInsertQuestionLog`(`userID` INT, `date` INT, `questionID` INT, `answerID` INT) RETURNS varchar(1) CHARSET latin1
    NO SQL
BEGIN

DECLARE rw	int;
DECLARE st	varchar(1);

INSERT INTO `question_log`(`user_id`, `updated_date`, `question_id`, `answer_id`) 
VALUES(userID,date, questionID,answerID );

SELECT ROW_COUNT() INTO rw;
	
 	IF(rw>0)
	THEN
		SET st ='T';
	ELSE
		SET st ='F';
	END IF;
RETURN st;

  END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `fnInsertQuestionType`(`description` VARCHAR(255), `name` VARCHAR(100)) RETURNS varchar(1) CHARSET latin1
    NO SQL
BEGIN

DECLARE rw	int;
DECLARE st	varchar(1);

INSERT INTO `question_type`(`name`, `description`) 
VALUES (name, description);

SELECT ROW_COUNT() INTO rw;
	
 	IF(rw>0)
	THEN
		SET st ='T';
	ELSE
		SET st ='F';
	END IF;
RETURN st;

  END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `fnInsertQuiz`(`studentID` INT, `subjectID` INT, `gradeID` INT, `moduleID` INT, `test_type` VARCHAR(20), `noOfQuz` INT, `timeShedule` TIME, `timeTaken` TIME, `speedBonus` INT, `startTime` TIME, `endTime` TIME, `star` INT, `name` VARCHAR(100), `marks` INT, `cDate` DATETIME) RETURNS varchar(1) CHARSET latin1
BEGIN DECLARE rw int;

DECLARE st varchar( 1 ) ;


INSERT INTO quiz(


student_id,  subject_id,  grade_id, 
module_id, type , questions,
schedule_time, time_taken, speed_bonus, 
start_time, end_time, stars, 
quiz_name, full_marks, created_date,
last_mod_date

)
VALUES (

studentID, subjectID, gradeID, 
moduleID, test_type, noOfQuz,
timeShedule, timeTaken, speedBonus,
startTime, endTime, star, 
name, marks, cDate, 
cDate
);

SELECT ROW_COUNT( )
INTO rw;

IF( rw >0 ) THEN SET st = 'T';

ELSE SET st = 'F';

END IF ;

RETURN st;

END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `fnInsertQuizHeader`(`studentID` INT, `subjectID` INT, `gradeID` INT, `moduleID` INT, `test_type` VARCHAR(20), `noOfQuz` INT, `timeShedule` TIME, `timeTaken` TIME, `speedBonus` INT, `startTime` DATETIME, `endTime` DATETIME, `star` INT, `name` VARCHAR(100), `marks` INT, `cDate` DATETIME) RETURNS int(11)
BEGIN 
DECLARE quiz_id int;

INSERT INTO quiz(
student_id,  subject_id,  grade_id, 
module_id, type , questions,
schedule_time, time_taken, speed_bonus, 
start_time, end_time, stars, 
quiz_name, full_marks, created_date,
last_mod_date
)
VALUES (
studentID, subjectID, gradeID, 
moduleID, test_type, noOfQuz,
timeShedule, timeTaken, speedBonus,
startTime, endTime, star, 
name, marks, cDate, 
cDate
);

SET quiz_id = LAST_INSERT_ID();
RETURN quiz_id;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `fnInsertQuizQuestion`(`quizID` INT, `questionID` INT, `qOrder` INT, `answer` VARCHAR(500), `doubt` BOOLEAN, `stat` VARCHAR(10)) RETURNS varchar(1) CHARSET latin1
    NO SQL
BEGIN

DECLARE rw	int;
DECLARE st	varchar(1);

INSERT INTO quiz_question(quiz_id, question_id, question_order, submit_answer, doubt, status)
VALUES	(quizID,questionID, qOrder,answer,doubt,stat);

SELECT ROW_COUNT() INTO rw;
	
 	IF(rw>0)
	THEN
		SET st ='T';
	ELSE
		SET st ='F';
	END IF;
RETURN st;

  END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `fnInsertReplyAttchment`(`replyID` INT, `fileName` VARCHAR(50), `exten` VARCHAR(10)) RETURNS varchar(1) CHARSET latin1
BEGIN

DECLARE rw int DEFAULT 0;
DECLARE fileID int DEFAULT 0;
DECLARE st varchar(1) DEFAULT 'F';

	INSERT INTO `file`(`name`, `extension`, `createAt`) VALUES (fileName,exten,NOW());
	SELECT ROW_COUNT() into rw;
	
	IF(rw>0)
	THEN
		SELECT LAST_INSERT_ID() into fileID;

		INSERT INTO `reply_attachment`(`reply_id`, `file_id`) VALUES (replyID,fileID);
	SELECT ROW_COUNT() INTO rw;
	
	if(rw > 0)
	THEN
		set st= 'T';
	ELSE
		SET st='F';
	END IF;

	ELSE

		SET st='F';

	END IF;

  	Return st;
  
    
   END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `fnInsertReportQuestion`(`studentID` INT, `questionID` INT, `reason` VARCHAR(200)) RETURNS varchar(1) CHARSET latin1
    NO SQL
BEGIN

DECLARE rw	int;
DECLARE st	varchar(1) DEFAULT 'F';

INSERT INTO `report_question`(`student_id`, `question_id`, `reason`) 
VALUES (studentID,questionID,reason);

SELECT ROW_COUNT() INTO rw;
	
 	IF(rw>0)
	THEN
		SET st ='T';
	ELSE
		SET st ='F';
	END IF;
RETURN st;

  END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `fnInsertReviewMail`(`email` VARCHAR(100), `stdID` INT) RETURNS varchar(1) CHARSET latin1
BEGIN

DECLARE rw	int;
DECLARE st	varchar(1);

 INSERT INTO `review_email`(`email`, `status`, `std_id`) VALUES (email,0,stdID); 
 
SELECT ROW_COUNT() INTO rw;
	
 	IF(rw>0)
	THEN
		SET st ='T';
	ELSE
		SET st ='F';
	END IF;
RETURN st;

  END$$

CREATE DEFINER=`tester`@`%` FUNCTION `fnInsertSnap`(`snapName` VARCHAR(100), `studentID` INT, `fileName` VARCHAR(50), `exten` VARCHAR(10)) RETURNS varchar(1) CHARSET latin1
BEGIN
DECLARE rw	int;
DECLARE st	varchar(1);
DECLARE fileID	int;

	INSERT INTO `file`(`name`, `extension`, `createAt`) VALUES (fileName,exten, NOW());
	
    
    SELECT ROW_COUNT() INTO rw;
 	IF(rw>0)
	THEN
		SELECT LAST_INSERT_ID() into fileID;
		INSERT INTO `snap`( `file_id`, `name`, `student_id`) VALUES (fileID,snapName,studentID);
        SELECT ROW_COUNT() INTO rw;
        
        IF(rw>0)
		THEN
			SET st ='T';
		ELSE
			SET st ='F';
		END IF;
        
		
	ELSE
		SET st ='F';
	END IF;
RETURN st;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `fnInsertStudentMobile`(`tel` VARCHAR(9), `stdID` INT, `prime` INT) RETURNS varchar(1) CHARSET latin1
BEGIN

DECLARE rw	int;
DECLARE st	varchar(1);

 INSERT INTO `student_mobile`(`mobile`, `status`, `std_id`) VALUES (tel,prime,stdID);
 
SELECT ROW_COUNT() INTO rw;
	
 	IF(rw>0)
	THEN
		SET st ='T';
	ELSE
		SET st ='F';
	END IF;
RETURN st;

  END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `fnInsertStudentPakcagePrice`(`studentID` INT, `packPriceID` INT) RETURNS varchar(1) CHARSET latin1
BEGIN
DECLARE st VARCHAR(1);
DECLARE rw int default 0;

	INSERT INTO `student_package_price`(`student_id`, `package_price_id`) VALUES(studentID, packPriceID);
    Select ROW_COUNT() into rw;

IF(rw>0)
THEN
	SET st ='T';
ELSE
	
	SET st ='F';
END IF;

return st;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `fnInsertSubcription`(`subcription` VARCHAR(100)) RETURNS varchar(11) CHARSET latin1
    NO SQL
BEGIN

DECLARE rw	int;
DECLARE st	varchar(11);

INSERT INTO `subscription`(`name`) VALUES (subcription);

SELECT ROW_COUNT() INTO rw;


    
IF(rw>0)
	THEN
		SELECT LAST_INSERT_ID() into st ;

	ELSE
		SET st ='F';
	END IF;
RETURN st;



END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `fnInsertSubject`(`sub` VARCHAR(50)) RETURNS varchar(1) CHARSET latin1
BEGIN
	
DECLARE rw	int;
DECLARE st	varchar(1);

    INSERT INTO subject(name) VALUES (sub);

SELECT ROW_COUNT() INTO rw;
	
 	IF(rw>0)
	THEN
		SET st ='T';
	ELSE
		SET st ='F';
	END IF;
RETURN st;

END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `fnInsertTempCode`(`userID` INT, `code` VARCHAR(200)) RETURNS varchar(1) CHARSET latin1
BEGIN 
DECLARE st	varchar(1);
DECLARE rw	int default 0;
       
	INSERT INTO `temp_codes`(`user_id`, `temp-code`) VALUES ( userID,code);

SELECT ROW_COUNT() INTO rw;
	
 	IF(rw>0)
	THEN
		SET st ='T';
	ELSE
		SET st ='F';
	END IF;
RETURN st;
 END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `fnInsertTransaction`(`payment_meth` VARCHAR(30), `studentID` INT, `paid` DOUBLE) RETURNS varchar(1) CHARSET latin1
BEGIN

DECLARE rw int default 0;
DECLARE	exdate date;
DECLARE st varchar(1);
DECLARE num int DEFAULT 0;
DECLARE invoice varchar(15);
DECLARE transID int DEFAULT 0;
DECLARE cnt int DEFAULT 0;
DECLARE expire date;
DECLARE balance double DEFAULT 0;
DECLARE amount double DEFAULT 0;


SELECT `months` into num 
FROM `package_type` 
WHERE id IN(

	SELECT `package_type_id`
    FROM `package_price` 
    WHERE id IN(
	
		SELECT 	DISTINCT package_price_id
		FROM 	`student_package_price` 
		WHERE 	student_id =studentID)); 




SELECT COUNT( id ) into cnt
FROM  `transaction` 
WHERE student_id =studentID;



IF (cnt >0)
THEN

	SELECT expire_date into expire 
	FROM `transaction` 
	WHERE student_id =studentID 
	ORDER BY id DESC  LIMIT 1;

	SET exdate = DATE_ADD(expire,INTERVAL num MONTH);
		
ELSE

	SET exdate = DATE_ADD(CURDATE(),INTERVAL num MONTH);
END IF;


SELECT  payment.`amount`, payment.balance into amount, balance
FROM  `payment` 
WHERE  `std_id` = studentID;

SET balance =(amount+ balance)- paid  ;

UPDATE `payment` 
SET payment.`balance`= balance
WHERE std_id= studentID;




INSERT INTO `transaction`( `date`, `expire_date`, `paid_amount`, `balance`, `student_id`,payment_method) 
VALUES (CURDATE(),exdate,paid,balance,studentID,payment_meth);



Select ROW_COUNT() into rw;

if(rw>0)
then
	
	SELECT LAST_INSERT_ID() into transID;
	
	
	SET invoice =CONCAT('TWI', transID);
	
	UPDATE	transaction
	SET		invoiceNo =invoice
	WHERE	id = transID;
	set st= 'T';

else
	set st= 'F';
end if;

RETURN st;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `fnInsertTutorHelpMessage`(`userID` INT, `subjectID` INT, `moduleID` INT, `unitID` INT, `title` VARCHAR(50), `message` TEXT, `heplerID` INT) RETURNS varchar(11) CHARSET latin1
    NO SQL
BEGIN
DECLARE rw	int;
DECLARE st	varchar(11);


INSERT INTO `tutor_help_message`(`sender_id`, `subject_id`, `module_id`, `unit_id`, `title`, `content`, `date_time`, `helper_id`) 
VALUES(userID,subjectID, moduleID, unitID, title, message,NOW(),heplerID );

SELECT ROW_COUNT() INTO rw;

IF(rw>0)
THEN
SELECT LAST_INSERT_ID() into st;
ELSE
SET st ='F';
END IF;

RETURN st;


END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `fnInsertUnsubcription`(`userID` INT, `subcriptionID` INT) RETURNS varchar(11) CHARSET latin1
BEGIN
DECLARE rw	int;
DECLARE msg	varchar(1);

	INSERT INTO `unsubscription`(`user_id`, `subcription_id`) VALUES (userID,subcriptionID);
    
    SELECT ROW_COUNT() INTO rw;
 	IF(rw>0)
	THEN
		SET msg ='T';
	ELSE
		SET msg ='F';
	END IF;
RETURN msg;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `fnInsertUserHelper`(`userID` INT, `helperID` INT) RETURNS varchar(1) CHARSET latin1
BEGIN
DECLARE rw	int;
DECLARE st	varchar(1);

  INSERT INTO `user_helpers`(`user_id`, `helper_id`) VALUES (userID,helperID);
 
SELECT ROW_COUNT() INTO rw;
	
 	IF(rw>0)
	THEN
		SET st ='T';
	ELSE
		SET st ='F';
	END IF;
RETURN st;

  END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `fnQuitQuiz`(`quizzID` INT, `stat` VARCHAR(10), `endTime` DATETIME) RETURNS varchar(1) CHARSET latin1
    NO SQL
BEGIN
DECLARE rw	int;
DECLARE st	varchar(1);

UPDATE quiz 
SET 
	end_time = endTime , 
	status 		= stat  
WHERE 
	id = quizzID;

SELECT ROW_COUNT() INTO rw;

IF(rw>0)
THEN
SET st ='T';
ELSE
SET st ='F';
END IF;

RETURN st;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `fnStarsForMessage`(`msgID` INT, `star` INT) RETURNS varchar(1) CHARSET latin1
    NO SQL
BEGIN
DECLARE rw	int;
DECLARE st	varchar(1);

UPDATE message
SET		stars = star
WHERE	id= msgID;

SELECT ROW_COUNT() INTO rw;

 	IF(rw>0)
	THEN
		SET st ='T';
	ELSE
		SET st ='F';
	END IF;
    
RETURN st;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `fnUpdateAnswer`(`answr` TEXT, `corrct` VARCHAR(100), `quzID` INT, `quzTypeID` INT, `answrID` INT) RETURNS varchar(1) CHARSET latin1
    NO SQL
BEGIN

DECLARE rw	int;
DECLARE st	varchar(1);

UPDATE `answer` 
SET 	`answer`= answr,`correct`= corrct,`question_id`=quzID,`question_type_id`=quzTypeID 
WHERE	id = answrID;

SELECT ROW_COUNT() INTO rw;
	
 	IF(rw>0)
	THEN
		SET st ='T';
	ELSE
		SET st ='F';
	END IF;
RETURN st;

  END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `fnUpdateGroup`(`groupID` INT, `groupName` VARCHAR(100)) RETURNS varchar(1) CHARSET latin1
    NO SQL
BEGIN

DECLARE rw	int;
DECLARE st	varchar(1) DEFAULT 'F';

UPDATE `group` SET `name`=groupName WHERE id= groupID;

SELECT ROW_COUNT() INTO rw;
	
 	IF(rw>0)
	THEN
		SET st ='T';
	ELSE
		SET st ='F';
	END IF;
RETURN st;

  END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `fnUpdateHelper`(`hname` VARCHAR(15), `hcolor` VARCHAR(15), `helper_id` INT) RETURNS varchar(1) CHARSET latin1
BEGIN
DECLARE rw	int;
DECLARE st	varchar(1);

  UPDATE `helpers` SET `name`=hname,`color`=hcolor WHERE id = helper_id;
 
SELECT ROW_COUNT() INTO rw;
	
 	IF(rw>0)
	THEN
		SET st ='T';
	ELSE
		SET st ='F';
	END IF;
RETURN st;

  END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `fnUpdateInterest`(`studentID` INT, `stdInterest` VARCHAR(500), `subject` VARCHAR(100), `topc` VARCHAR(100), `ambtn` VARCHAR(200), `qute` TEXT) RETURNS varchar(1) CHARSET latin1
    NO SQL
BEGIN
DECLARE rw	int;
DECLARE st	varchar(1);

UPDATE	 `interest` 
SET 	interests= stdInterest,`fav_subject`= subject,`topic`=topc,`ambition`=ambtn,`quote`=qute 
WHERE	std_id= studentID;

SELECT ROW_COUNT() INTO rw;

 	IF(rw>0)
	THEN
		SET st ='T';
	ELSE
		SET st ='F';
	END IF;
    
RETURN st;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `fnUpdateMessage`(`sub` VARCHAR(20), `msg` TEXT, `msgID` INT, `star` INT) RETURNS varchar(1) CHARSET latin1
    NO SQL
BEGIN
DECLARE rw	int;
DECLARE st	varchar(1);

UPDATE `message` SET `subject`=sub,`content`=msg , stars =star WHERE id= msgID;

SELECT ROW_COUNT() INTO rw;

 	IF(rw>0)
	THEN
		SET st ='T';
	ELSE
		SET st ='F';
	END IF;
    
RETURN st;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `fnUpdateMessageStatus`(`msgID` INT, `stat` INT) RETURNS varchar(1) CHARSET latin1
    NO SQL
BEGIN
DECLARE rw	int;
DECLARE st	varchar(1);

UPDATE message
SET status = stat WHERE id=  msgID;

SELECT ROW_COUNT() INTO rw;

 	IF(rw>0)
	THEN
		SET st ='T';
	ELSE
		SET st ='F';
	END IF;
    
RETURN st;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `fnUpdatePlanner`(`plannerID` INT, `tit` VARCHAR(250), `stDate` DATE, `endDate` DATE, `stTime` TIME, `endTime` TIME, `repTypeID` INT, `color` VARCHAR(20)) RETURNS varchar(1) CHARSET latin1
    NO SQL
BEGIN
DECLARE rw	int;
DECLARE st	varchar(1);

UPDATE `planner` 
SET `title`=tit,`start_date`=stDate,`end_date`=endDate,`start_time`=stTime,`end_time`=endTime,`repeat_type_id`=repTypeID,`event_color`=color 
WHERE id =plannerID;

SELECT ROW_COUNT() INTO rw;

 	IF(rw>0)
	THEN
		SET st ='T';
	ELSE
		SET st ='F';
	END IF;


RETURN st;
END$$

CREATE DEFINER=`tester`@`%` FUNCTION `fnUpdatePlannerNote`(`plannerNoteID` INT, `notes` TEXT) RETURNS varchar(1) CHARSET latin1
BEGIN
DECLARE rw	int;
DECLARE st	varchar(1);

	UPDATE `planner_notes` 
    SET `note`=notes 
    WHERE id= plannerNoteID;
    
    SELECT ROW_COUNT() INTO rw;
 	IF(rw>0)
	THEN
		SET st ='T';
	ELSE
		SET st ='F';
	END IF;
    
RETURN st;
END$$

CREATE DEFINER=`tester`@`%` FUNCTION `fnUpdatePlannerReminder`(`plnReminderID` INT, `remDate` DATE, `remTime` TIME) RETURNS varchar(1) CHARSET latin1
BEGIN
DECLARE rw	int;
DECLARE st	varchar(1);

	UPDATE `planner_reminder` SET `reminder_date`=remDate,`reminder_time`=remTime
    WHERE id= plnReminderID;
    
    SELECT ROW_COUNT() INTO rw;
 	IF(rw>0)
	THEN
		SET st ='T';
	ELSE
		SET st ='F';
	END IF;
    
RETURN st;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `fnUpdateQuestion`(`quz` TEXT, `descibe` VARCHAR(255), `date` INT, `gradeID` INT, `curriculumID` INT, `unitID` INT, `subjectID` INT, `moduleID` INT, `quzID` INT) RETURNS varchar(1) CHARSET latin1
    NO SQL
BEGIN

DECLARE rw	int;
DECLARE st	varchar(1);


UPDATE `question` 
SET		`question`=quz,`description`=descibe,`created_date`=date,`grade_id`=gradeID,`curriculum_id`=curriculumID,`unit_id`=unitID,`subject_id`=subjectID,`module_id`=moduleID 
WHERE	id = quzID;

SELECT ROW_COUNT() INTO rw;
	
 	IF(rw>0)
	THEN
		SET st ='T';
	ELSE
		SET st ='F';
	END IF;
RETURN st;

  END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `fnUpdateQuestionType`(`des` VARCHAR(255), `typeName` VARCHAR(100), `quzTypeID` INT) RETURNS varchar(1) CHARSET latin1
    NO SQL
BEGIN

DECLARE rw	int;
DECLARE st	varchar(1);

UPDATE `question_type` 
SET 	`name`=typeName,`description`=des
WHERE	id= quzTypeID;


SELECT ROW_COUNT() INTO rw;
	
 	IF(rw>0)
	THEN
		SET st ='T';
	ELSE
		SET st ='F';
	END IF;
RETURN st;

  END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `fnUpdateReplyStatus`(`replyID` INT, `stat` INT) RETURNS varchar(1) CHARSET latin1
BEGIN
DECLARE rw	int;
DECLARE st	varchar(1);

UPDATE reply
SET status = stat WHERE id=  replyID;

SELECT ROW_COUNT() INTO rw;

 	IF(rw>0)
	THEN
		SET st ='T';
	ELSE
		SET st ='F';
	END IF;
    
RETURN st;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `fnUpdateReviewMail`(`mailID` INT) RETURNS varchar(1) CHARSET latin1
BEGIN

DECLARE rw	int;
DECLARE st	varchar(1);

 UPDATE `review_email` 
SET `status`=1
WHERE id= mailID;

 
SELECT ROW_COUNT() INTO rw;
	
 	IF(rw>0)
	THEN
		SET st ='T';
	ELSE
		SET st ='F';
	END IF;
RETURN st;

  END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `fnUpdateStudentMobile`(`ID` INT) RETURNS varchar(1) CHARSET latin1
BEGIN

DECLARE rw	int;
DECLARE st	varchar(1);

 UPDATE `student_mobile` SET `status`=1 WHERE id=ID;
 
SELECT ROW_COUNT() INTO rw;
	
 	IF(rw>0)
	THEN
		SET st ='T';
	ELSE
		SET st ='F';
	END IF;
RETURN st;

  END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `fnUpdateStudentPackage`(`studentID` INT, `packID` INT) RETURNS varchar(1) CHARSET latin1
    NO SQL
BEGIN
	DECLARE rw	int;
DECLARE st	varchar(1);

    UPDATE students
	SET 	package_id= packID
	WHERE	std_id = studentID;

SELECT ROW_COUNT() INTO rw;
	
 	IF(rw>0)
	THEN
		SET st ='T';
	ELSE
		SET st ='F';
	END IF;
RETURN st;

END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `fnUpdateTutorHelpMessageStatus`(`msgID` INT, `stat` INT) RETURNS varchar(1) CHARSET latin1
    NO SQL
BEGIN
DECLARE rw	int;
DECLARE st	varchar(1);

UPDATE tutor_help_reply  
SET status = stat WHERE message_id = msgID;

SELECT ROW_COUNT() INTO rw;

 	IF(rw>0)
	THEN
		SET st ='T';
	ELSE
		SET st ='F';
	END IF;
    
RETURN st;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `fnUpdateTutorHelpReplyStatus`(`replyID` INT, `stat` INT) RETURNS varchar(1) CHARSET latin1
    NO SQL
BEGIN
DECLARE rw	int;
DECLARE st	varchar(1);

UPDATE tutor_help_reply
SET status = stat WHERE id=  replyID;

SELECT ROW_COUNT() INTO rw;

 	IF(rw>0)
	THEN
		SET st ='T';
	ELSE
		SET st ='F';
	END IF;
    
RETURN st;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `fnValidateTempCode`(`code` VARCHAR(200)) RETURNS int(11)
    NO SQL
BEGIN
DECLARE userID int default 0;

	SELECT  `user_id` into userID
	FROM `temp_codes` WHERE temp_code =code;

RETURN userID; 
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `spInsertGroupUsers`(`groupID` INT, `userID` INT) RETURNS varchar(1) CHARSET latin1
    NO SQL
BEGIN

DECLARE rw	int;
DECLARE st	varchar(1) DEFAULT 'F';

INSERT INTO `user_group`(`user_id`, `group_id`) VALUES (userID,groupID);

SELECT ROW_COUNT() INTO rw;
	
 	IF(rw>0)
	THEN
		SET st ='T';
	ELSE
		SET st ='F';
	END IF;
RETURN st;

  END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `admin`
--

CREATE TABLE IF NOT EXISTS `admin` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `telephone` int(9) NOT NULL,
  `country_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id` (`user_id`),
  KEY `fk_admin` (`user_id`),
  KEY `country_id` (`country_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=13 ;

--
-- Dumping data for table `admin`
--

INSERT INTO `admin` (`id`, `user_id`, `name`, `telephone`, `country_id`) VALUES
(1, 3, 'Tutor_admin', 113129907, 44),
(2, 11, 'FileManager', 113129907, 44),
(3, 12, 'FileManager', 113129907, 44),
(4, 13, 'My App', 123456789, 1),
(5, 14, 'online notificationj', 123456789, 2),
(6, 18, 'Hello', 113129907, 1),
(7, 19, 'Tutor_admin', 111312990, 2),
(8, 20, 'Tutor_admin', 111312990, 2),
(9, 21, 'Tutor_admin(Angular1)', 113129907, 44),
(10, 22, 'Tutor_admin', 113129907, 44),
(11, 24, 'Tutor_admin', 123456789, 44),
(12, 25, 'FileManager123', 113129907, 44);

-- --------------------------------------------------------

--
-- Table structure for table `answer`
--

CREATE TABLE IF NOT EXISTS `answer` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `answer` text NOT NULL,
  `correct` varchar(100) NOT NULL,
  `question_id` int(11) NOT NULL,
  `question_type_id` int(11) NOT NULL,
  `created_by` int(11) NOT NULL,
  `created_date` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `question_id` (`question_id`,`question_type_id`),
  KEY `type_id` (`question_type_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=35 ;

--
-- Dumping data for table `answer`
--

INSERT INTO `answer` (`id`, `answer`, `correct`, `question_id`, `question_type_id`, `created_by`, `created_date`) VALUES
(1, 'sublimation', 'sublimation', 10, 5, 0, '0000-00-00 00:00:00'),
(2, 'condensation', 'condensation', 10, 5, 0, '0000-00-00 00:00:00'),
(3, 'evaporation', 'evaporation', 10, 5, 0, '0000-00-00 00:00:00'),
(4, 'freezing', 'freezing', 10, 5, 0, '0000-00-00 00:00:00'),
(5, 'melting', 'melting', 10, 5, 0, '0000-00-00 00:00:00'),
(6, 'sublimation', 'sublimation', 10, 5, 0, '0000-00-00 00:00:00'),
(7, '44.44', '1', 4, 4, 0, '0000-00-00 00:00:00'),
(8, '400', '0', 4, 4, 0, '0000-00-00 00:00:00'),
(9, '4', '0.4', 4, 4, 0, '2016-12-14 00:00:00'),
(10, '0.4', '0.4', 4, 4, 0, '2016-12-14 00:00:00'),
(11, '444', 'T', 2, 2, 0, '2016-12-14 00:00:00'),
(12, '4', 'T', 2, 2, 0, '2016-12-14 00:00:00'),
(13, '1/4', 'F', 2, 2, 0, '2016-12-14 00:00:00'),
(14, '20', 'F', 2, 2, 0, '2016-12-14 00:00:00'),
(17, '444', '0', 3, 3, 0, '2016-12-14 00:00:00'),
(18, '4', '0', 3, 3, 0, '2016-12-14 00:00:00'),
(19, '1/4', '0', 3, 3, 0, '2016-12-14 00:00:00'),
(20, '20', '1', 3, 3, 0, '2016-12-14 00:00:00'),
(21, '444', 'a:2:{i:0;s:3:"GAS";i:1;s:3:"AIR";}\r\n', 5, 1, 0, '2016-12-14 00:00:00'),
(22, '4', 'a:2:{i:0;s:6:"LIQUID";i:1;s:5:"WATER";}', 5, 1, 0, '2016-12-14 00:00:00'),
(23, '1/4', 'a:2:{i:0;s:3:"ICE";i:1;s:7:"MELTTIG";}', 5, 1, 0, '2016-12-14 00:00:00'),
(24, '20', 'a:4:{i:0;s:3:"GAS";i:1;s:6:"LIQUID";i:2;s:5:"WATER";i:3;s:3:"ICE";}', 5, 1, 0, '2016-12-14 00:00:00'),
(25, 'b. Using saline solution for contact lenses', 'N', 7, 6, 0, '0000-00-00 00:00:00'),
(26, 'Uptake of glucose in the intestines\r\n', 'Y', 7, 6, 0, '0000-00-00 00:00:00'),
(27, 'b. Using saline solution for contact lenses', 'N', 7, 6, 0, '0000-00-00 00:00:00'),
(28, 'The odor of perfume spreading throughout the room', 'N', 7, 6, 0, '0000-00-00 00:00:00'),
(29, 'a. Mixing of bromine vapor or air', 'Y', 7, 6, 0, '0000-00-00 00:00:00'),
(30, '', 'Metals', 1, 8, 0, '0000-00-00 00:00:00'),
(31, '', 'Nonmetals', 1, 8, 0, '0000-00-00 00:00:00'),
(32, '', 'Ionic Compounds', 1, 8, 0, '0000-00-00 00:00:00'),
(33, '', 'Positive Ions', 1, 8, 0, '0000-00-00 00:00:00'),
(34, '', 'Negative Ions', 1, 8, 0, '0000-00-00 00:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `competition_answers`
--

CREATE TABLE IF NOT EXISTS `competition_answers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `x1` int(11) NOT NULL,
  `x2` int(11) NOT NULL,
  `y1` int(11) NOT NULL,
  `y2` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=13 ;

--
-- Dumping data for table `competition_answers`
--

INSERT INTO `competition_answers` (`id`, `x1`, `x2`, `y1`, `y2`) VALUES
(1, 656, 666, 25, 44),
(2, 845, 898, 53, 56),
(3, 855, 877, 151, 179),
(4, 977, 984, 152, 159),
(5, 715, 747, 181, 214),
(6, 893, 905, 242, 243),
(7, 1025, 1027, 267, 270),
(8, 982, 1022, 303, 320),
(9, 901, 918, 365, 372),
(10, 977, 996, 373, 376),
(11, 850, 954, 404, 487),
(12, 780, 865, 432, 493);

-- --------------------------------------------------------

--
-- Table structure for table `competition_marks`
--

CREATE TABLE IF NOT EXISTS `competition_marks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `marks` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `country`
--

CREATE TABLE IF NOT EXISTS `country` (
  `id` int(3) NOT NULL AUTO_INCREMENT,
  `country_name` varchar(50) NOT NULL,
  `allowed` char(1) NOT NULL,
  `code` varchar(10) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=270 ;

--
-- Dumping data for table `country`
--

INSERT INTO `country` (`id`, `country_name`, `allowed`, `code`) VALUES
(1, 'Aruba', 'F', '+297'),
(2, 'Antigua and Barbuda', 'F', '+1-268'),
(3, 'United Arab Emirates', 'F', '+971'),
(4, 'Afghanistan', 'F', '+93'),
(5, 'Algeria', 'F', '+213'),
(6, 'Azerbaijan', 'F', '+994'),
(7, 'Albania', 'F', '+355'),
(8, 'Armenia', 'F', '+374'),
(9, 'Andorra', 'F', '+376'),
(10, 'Angola', 'F', '+244'),
(11, 'American Samoa', 'F', '+1-684'),
(12, 'Argentina', 'F', '+54'),
(13, 'Australia', 'F', '+61'),
(14, 'Ashmore and Cartier Islands', 'F', '+1-264'),
(15, 'Austria', 'F', '+43'),
(16, 'Anguilla', 'F', '+1-264'),
(17, 'Åland Islands', 'F', '+358'),
(18, 'Antarctica', 'F', '+672'),
(19, 'Bahrain', 'F', '+973'),
(20, 'Barbados', 'F', '+1-246'),
(21, 'Botswana', 'F', '+267'),
(22, 'Bermuda', 'F', '+1-441'),
(23, 'Belgium', 'F', '+32'),
(24, 'Bahamas, The', 'F', '+1-242'),
(25, 'Bangladesh', 'F', '+880'),
(26, 'Belize', 'F', '+501'),
(27, 'Bosnia and Herzegovina', 'F', '+387'),
(28, 'Bolivia', 'F', '+591'),
(29, 'Myanmar', 'F', '+95'),
(30, 'Benin', 'F', '+229'),
(31, 'Belarus', 'F', '+375'),
(32, 'Solomon Islands', 'F', '+677'),
(33, 'Navassa Island', 'F', '+1'),
(34, 'Brazil', 'F', '+55'),
(35, 'Bassas da India', 'F', '+1'),
(36, 'Bhutan', 'F', '+975'),
(37, 'Bulgaria', 'F', '+359'),
(38, 'Bouvet Island', 'F', '+1'),
(39, 'Brunei', 'F', '+673'),
(40, 'Burundi', 'F', '+257'),
(41, 'Canada', 'F', '+1'),
(42, 'Cambodia', 'F', '+855'),
(43, 'Chad', 'F', '+235'),
(44, 'Sri Lanka', 'T', '+94'),
(45, 'Congo, Republic of the', 'F', '+242'),
(46, 'Congo, Democratic Republic of the', 'F', '+243'),
(47, 'China', 'F', '+86'),
(48, 'Chile', 'F', '+56'),
(49, 'Cayman Islands', 'F', '+1-345'),
(50, 'Cocos (Keeling) Islands', 'F', '+61'),
(51, 'Cameroon', 'F', '+237'),
(52, 'Comoros', 'F', '+269'),
(53, 'Colombia', 'F', '+57'),
(54, 'Northern Mariana Islands', 'F', '+1-670'),
(55, 'Coral Sea Islands', 'F', '+1'),
(56, 'Costa Rica', 'F', '+506'),
(57, 'Central African Republic', 'F', '+236'),
(58, 'Cuba', 'F', '+53'),
(59, 'Cape Verde', 'F', '+238'),
(60, 'Cook Islands', 'F', '+682'),
(61, 'Cyprus', 'F', '+357'),
(62, 'Denmark', 'F', '+45'),
(63, 'Djibouti', 'F', '+253'),
(64, 'Dominica', 'F', '+1-767'),
(65, 'Jarvis Island', 'F', '+1'),
(66, 'Dominican Republic', 'F', '+1-809'),
(67, 'Dhekelia Sovereign Base Area', 'F', '+1'),
(68, 'Ecuador', 'F', '+593'),
(69, 'Egypt', 'F', '+20'),
(70, 'Ireland', 'F', '+353'),
(71, 'Equatorial Guinea', 'F', '+240'),
(72, 'Estonia', 'F', '+372'),
(73, 'Eritrea', 'F', '+291'),
(74, 'El Salvador', 'F', '+503'),
(75, 'Ethiopia', 'F', '+251'),
(76, 'Europa Island', 'F', '+1'),
(77, 'Czech Republic', 'F', '+420'),
(78, 'French Guiana', 'F', '+594'),
(79, 'Finland', 'F', '+358'),
(80, 'Fiji', 'F', '+679'),
(81, 'Falkland Islands (Islas Malvinas)', 'F', '+500'),
(82, 'Micronesia, Federated States of', 'F', '+691'),
(83, 'Faroe Islands', 'F', '+298'),
(84, 'French Polynesia', 'F', '+689'),
(85, 'Baker Island', 'F', '+1'),
(86, 'France', 'F', '+33'),
(87, 'French Southern and Antarctic Lands', 'F', '+1'),
(88, 'Gambia, The', 'F', '+220'),
(89, 'Gabon', 'F', '+241'),
(90, 'Georgia', 'F', '+995'),
(91, 'Ghana', 'F', '+233'),
(92, 'Gibraltar', 'F', '+350'),
(93, 'Grenada', 'F', '+1-473'),
(94, 'Guernsey', 'F', '+44-14'),
(95, 'Greenland', 'F', '+299'),
(96, 'Germany', 'F', '+49'),
(97, 'Glorioso Islands', 'F', '+1'),
(98, 'Guadeloupe', 'F', '+590'),
(99, 'Guam', 'F', '+1-671'),
(100, 'Greece', 'F', '+30'),
(101, 'Guatemala', 'F', '+502'),
(102, 'Guinea', 'F', '+224'),
(103, 'Guyana', 'F', '+592'),
(104, 'Gaza Strip', 'F', '+970'),
(105, 'Haiti', 'F', '+509'),
(106, 'Hong Kong', 'F', '+852'),
(107, 'Heard Island and McDonald Islands', 'F', '+1'),
(108, 'Honduras', 'F', '+504'),
(109, 'Howland Island', 'F', '+1'),
(110, 'Croatia', 'F', '+385'),
(111, 'Hungary', 'F', '+36'),
(112, 'Iceland', 'F', '+354'),
(113, 'Indonesia', 'F', '+62'),
(114, 'Isle of Man', 'F', '+44-162'),
(115, 'India', 'F', '+91'),
(116, 'British Indian Ocean Territory', 'F', '+246'),
(117, 'Clipperton Island', 'F', '+1'),
(118, 'Iran', 'F', '+353'),
(119, 'Israel', 'F', '+972'),
(120, 'Italy', 'F', '+39'),
(121, 'Cote d''Ivoire', 'F', '+225'),
(122, 'Iraq', 'F', '+964'),
(123, 'Japan', 'F', '+81'),
(124, 'Jersey', 'F', '+44-1534'),
(125, 'Jamaica', 'F', '+1-876'),
(126, 'Jan Mayen', 'F', '+47'),
(127, 'Jordan', 'F', '+962'),
(128, 'Johnston Atoll', 'F', '+1'),
(129, 'Juan de Nova Island', 'F', '+1'),
(130, 'Kenya', 'F', '+254'),
(131, 'Kyrgyzstan', 'F', '+996'),
(132, 'Korea, North', 'F', '+850'),
(133, 'Kingman Reef', 'F', '+1'),
(134, 'Kiribati', 'F', '+686'),
(135, 'Korea, South', 'F', '+82'),
(136, 'Christmas Island', 'F', '+61'),
(137, 'Kuwait', 'F', '+965'),
(138, 'Kosovo', 'F', '+383'),
(139, 'Kazakhstan', 'F', '+7'),
(140, 'Laos', 'F', '+856'),
(141, 'Lebanon', 'F', '+961'),
(142, 'Latvia', 'F', '+371'),
(143, 'Lithuania', 'F', '+370'),
(144, 'Liberia', 'F', '+231'),
(145, 'Slovakia', 'F', '+421'),
(146, 'Palmyra Atoll', 'F', '+1'),
(147, 'Liechtenstein', 'F', '+423'),
(148, 'Lesotho', 'F', '+266'),
(149, 'Luxembourg', 'F', '+352'),
(150, 'Libyan Arab', 'F', '+218'),
(151, 'Madagascar', 'F', '+261'),
(152, 'Martinique', 'F', '+596'),
(153, 'Macau', 'F', '+853'),
(154, 'Moldova, Republic of', 'F', '+373'),
(155, 'Mayotte', 'F', '+262'),
(156, 'Mongolia', 'F', '+976'),
(157, 'Montserrat', 'F', '+1-664'),
(158, 'Malawi', 'F', '+262'),
(159, 'Montenegro', 'F', '+382'),
(160, 'The Former Yugoslav Republic of Macedonia', 'F', '+389'),
(161, 'Mali', 'F', '+223'),
(162, 'Monaco', 'F', '+377'),
(163, 'Morocco', 'F', '+212'),
(164, 'Mauritius', 'F', '+230'),
(165, 'Midway Islands', 'F', '+1'),
(166, 'Mauritania', 'F', '+222'),
(167, 'Malta', 'F', '+356'),
(168, 'Oman', 'F', '+968'),
(169, 'Maldives', 'T', '+960'),
(170, 'Mexico', 'F', '+52'),
(171, 'Malaysia', 'F', '+60'),
(172, 'Mozambique', 'F', '+258'),
(173, 'New Caledonia', 'F', '+687'),
(174, 'Niue', 'F', '+683'),
(175, 'Norfolk Island', 'F', '+672'),
(176, 'Niger', 'F', '+227'),
(177, 'Vanuatu', 'F', '+678'),
(178, 'Nigeria', 'F', '+234'),
(179, 'Netherlands', 'F', '+31'),
(180, 'No Man''s Land', 'F', '+1'),
(181, 'Norway', 'F', '+47'),
(182, 'Nepal', 'F', '+977'),
(183, 'Nauru', 'F', '+674'),
(184, 'Suriname', 'F', '+597'),
(185, 'Netherlands Antilles', 'F', '+599'),
(186, 'Nicaragua', 'F', '+505'),
(187, 'New Zealand', 'F', '+64'),
(188, 'Paraguay', 'F', '+595'),
(189, 'Pitcairn Islands', 'F', '+64'),
(190, 'Peru', 'F', '+51'),
(191, 'Paracel Islands', 'F', '+1'),
(192, 'Spratly Islands', 'F', '+10-4'),
(193, 'Pakistan', 'F', '+92'),
(194, 'Poland', 'F', '+48'),
(195, 'Panama', 'F', '+507'),
(196, 'Portugal', 'F', '+351'),
(197, 'Papua New Guinea', 'F', '+675'),
(198, 'Palau', 'F', '+680'),
(199, 'Guinea-Bissau', 'F', '+245'),
(200, 'Qatar', 'F', '+974'),
(201, 'Reunion', 'F', '+262'),
(202, 'Serbia', 'F', '+381'),
(203, 'Marshall Islands', 'F', '+692'),
(204, 'Saint Martin', 'F', '+590'),
(205, 'Romania', 'F', '+40'),
(206, 'Philippines', 'F', '+63'),
(207, 'Puerto Rico', 'F', '+1-787'),
(208, 'Russia', 'F', '+7'),
(209, 'Rwanda', 'F', '+250'),
(210, 'Saudi Arabia', 'F', '+966'),
(211, 'Saint Pierre and Miquelon', 'F', '+508'),
(212, 'Saint Kitts and Nevis', 'F', '+1-869'),
(213, 'Seychelles', 'F', '+248'),
(214, 'South Africa', 'F', '+27'),
(215, 'Senegal', 'F', '+221'),
(216, 'Saint Helena', 'F', '+290'),
(217, 'Slovenia', 'F', '+386'),
(218, 'Sierra Leone', 'F', '+232'),
(219, 'San Marino', 'F', '+378'),
(220, 'Singapore', 'F', '+65'),
(221, 'Somalia', 'F', '+252'),
(222, 'Spain', 'F', '+34'),
(223, 'Saint Lucia', 'F', '+1-758'),
(224, 'Sudan', 'F', '+249'),
(225, 'Svalbard', 'F', '+47'),
(226, 'Sweden', 'F', '+46'),
(227, 'South Georgia and the Islands', 'F', '+500'),
(228, 'Syrian Arab Republic', 'F', '+963'),
(229, 'Switzerland', 'F', '+268'),
(230, 'Trinidad and Tobago', 'F', '+1-868'),
(231, 'Tromelin Island', 'F', '+1'),
(232, 'Thailand', 'F', '+66'),
(233, 'Tajikistan', 'F', '+992'),
(234, 'Turks and Caicos Islands', 'F', '+1-649'),
(235, 'Tokelau', 'F', '+690'),
(236, 'Tonga', 'F', '+676'),
(237, 'Togo', 'F', '+228'),
(238, 'Sao Tome and Principe', 'F', '+239'),
(239, 'Tunisia', 'F', '+216'),
(240, 'East Timor', 'F', '+670'),
(241, 'Turkey', 'F', '+90'),
(242, 'Tuvalu', 'F', '+688'),
(243, 'Taiwan', 'F', '+886'),
(244, 'Turkmenistan', 'F', '+993'),
(245, 'Tanzania, United Republic of', 'F', '+255'),
(246, 'Uganda', 'F', '+256'),
(247, 'United Kingdom', 'F', '+44'),
(248, 'Ukraine', 'F', '+380'),
(249, 'United States', 'F', '+1'),
(250, 'Burkina Faso', 'F', '+226'),
(251, 'Uruguay', 'F', '+598'),
(252, 'Uzbekistan', 'F', '+998'),
(253, 'Saint Vincent and the Grenadines', 'F', '+1-784'),
(254, 'Venezuela', 'F', '+58'),
(255, 'British Virgin Islands', 'F', '+1'),
(256, 'Vietnam', 'F', '+84'),
(257, 'Virgin Islands (US)', 'F', '+1-284'),
(258, 'Holy See (Vatican City)', 'F', '+1'),
(259, 'Namibia', 'F', '+264'),
(260, 'West Bank', 'F', '+970'),
(261, 'Wallis and Futuna', 'F', '+681'),
(262, 'Western Sahara', 'F', '+212'),
(263, 'Wake Island', 'F', '+808'),
(264, 'Samoa', 'F', '+685'),
(265, 'Swaziland', 'F', '+268'),
(266, 'Serbia and Montenegro', 'F', '+381'),
(267, 'Yemen', 'F', '+967'),
(268, 'Zambia', 'F', '+260'),
(269, 'Zimbabwe', 'F', '+263');

-- --------------------------------------------------------

--
-- Table structure for table `curriculum`
--

CREATE TABLE IF NOT EXISTS `curriculum` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(20) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=4 ;

--
-- Dumping data for table `curriculum`
--

INSERT INTO `curriculum` (`id`, `name`) VALUES
(1, 'Edexcel'),
(2, 'Cambridge'),
(3, 'National');

-- --------------------------------------------------------

--
-- Table structure for table `faqs`
--

CREATE TABLE IF NOT EXISTS `faqs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `question` text NOT NULL,
  `answer` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=6 ;

--
-- Dumping data for table `faqs`
--

INSERT INTO `faqs` (`id`, `question`, `answer`) VALUES
(1, 'What is module?', 'This is'),
(2, 'How do I apply for a new or replacement Social Security number card?', 'yes'),
(3, 'How do I change or correct my name on my Social Security number card?', 'yes'),
(4, 'How do I apply for Social Security retirement benefits?', 'You should apply for retirement benefits three months before you want your payments to start. The easiest and most convenient way to apply for retirement benefits is by using our online application.'),
(5, 'How long will it take to get a Social Security card?', 'We will mail your Social Security card as soon as we have all of the necessary information and have verified the appropriate documents. Generally, you will get your card within 10 business days from the date your application is processed.\r\n\r\n ');

-- --------------------------------------------------------

--
-- Table structure for table `feed`
--

CREATE TABLE IF NOT EXISTS `feed` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `notification` varchar(250) NOT NULL,
  `createdAt` datetime DEFAULT NULL,
  `updatedAt` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=48 ;

--
-- Dumping data for table `feed`
--

INSERT INTO `feed` (`id`, `notification`, `createdAt`, `updatedAt`) VALUES
(1, 'Add New Tutor by Admin', '2017-01-24 16:55:46', '2017-01-24 11:25:46'),
(2, 'Add New Tutor by Admin', '2017-01-24 16:57:42', '2017-01-24 11:27:42'),
(3, 'New User Register bimantha', '2017-01-25 16:48:06', '2017-01-25 11:18:06'),
(4, 'New User Register Super Admin', '2017-01-26 11:30:32', '2017-01-26 06:00:32'),
(5, 'New User Register Tutor_admin', '2017-01-27 10:47:12', '2017-01-27 05:17:12'),
(6, 'New User Register Tutor_admin', '2017-01-27 11:12:05', '2017-01-27 05:42:05'),
(7, 'New User Register Tutor_admin', '2017-01-27 11:15:24', '2017-01-27 05:45:24'),
(8, 'New User Register Tutor_admin', '2017-01-27 11:17:33', '2017-01-27 05:47:33'),
(9, 'New User Register Tutor_admin', '2017-01-27 11:18:32', '2017-01-27 05:48:32'),
(10, 'New User Register Tutor_admin', '2017-01-27 11:21:08', '2017-01-27 05:51:08'),
(11, 'New User Register Tutor_admin', '2017-01-27 11:52:20', '2017-01-27 06:22:20'),
(12, 'New User Register Tutor_admin', '2017-01-27 11:55:14', '2017-01-27 06:25:14'),
(13, 'New User Register Lakmi Muthumala', '2017-01-27 11:57:14', '2017-01-27 06:27:14'),
(14, 'Add New Tutor by Admin', '2017-01-27 11:57:53', '2017-01-27 06:27:53'),
(15, 'New User Register Lakmi Muthumala', '2017-01-27 12:07:33', '2017-01-27 06:37:33'),
(16, 'New User Register lakmi', '2017-01-27 12:56:41', '2017-01-27 07:26:41'),
(17, 'Add New User by Admin Tutor_admin', '2017-01-27 12:57:17', '2017-01-27 07:27:17'),
(18, 'New User Register Tutor_admin(Angular)', '2017-01-28 10:42:07', '2017-01-28 05:12:07'),
(19, 'Add New Tutor by Admin', '2017-01-28 10:42:32', '2017-01-28 05:12:32'),
(20, 'New User Register FileManager', '2017-01-28 10:48:15', '2017-01-28 05:18:15'),
(21, 'New User Register FileManager', '2017-01-28 10:53:33', '2017-01-28 05:23:33'),
(22, 'New User Register My App', '2017-01-28 10:55:00', '2017-01-28 05:25:00'),
(23, 'New User Register online notificationj', '2017-01-28 10:58:29', '2017-01-28 05:28:29'),
(24, 'New User Register Test User', '2017-01-28 11:16:27', '2017-01-28 05:46:27'),
(25, 'New User Register Test User', '2017-01-28 11:17:37', '2017-01-28 05:47:37'),
(26, 'New User Register Test User', '2017-01-28 11:27:31', '2017-01-28 05:57:31'),
(27, 'New User Register Hello', '2017-01-28 12:11:05', '2017-01-28 06:41:05'),
(28, 'Add New User by Admin Tutor_admin', '2017-01-28 12:11:47', '2017-01-28 06:41:48'),
(29, 'Add New User by Admin Tutor_admin', '2017-01-28 12:12:06', '2017-01-28 06:42:06'),
(30, 'Add New User by Admin Tutor_admin', '2017-01-28 12:12:23', '2017-01-28 06:42:23'),
(31, 'Add New User by Admin Tutor_admin', '2017-01-28 12:12:27', '2017-01-28 06:42:27'),
(32, 'Add New User by Admin Tutor_admin', '2017-01-28 12:12:36', '2017-01-28 06:42:36'),
(33, 'Add New Tutor by Admin', '2017-01-28 13:20:24', '2017-01-28 07:50:24'),
(34, 'New User Register Tutor_admin', '2017-01-28 13:22:43', '2017-01-28 07:52:43'),
(35, 'New User Register Tutor_admin', '2017-01-28 13:23:21', '2017-01-28 07:53:21'),
(36, 'Add New User by Admin Tutor_admin', '2017-01-28 13:23:56', '2017-01-28 07:53:56'),
(37, 'Add New User by Admin Tutor_admin', '2017-01-28 13:28:31', '2017-01-28 07:58:31'),
(38, 'Add New Tutor by Admin', '2017-01-28 13:31:50', '2017-01-28 08:01:50'),
(39, 'Add New Tutor by Admin', '2017-01-28 13:33:34', '2017-01-28 08:03:34'),
(40, 'New User Register Tutor_admin(Angular1)', '2017-01-28 13:36:01', '2017-01-28 08:06:01'),
(41, 'Add New User by Admin Tutor_admin', '2017-01-28 13:37:10', '2017-01-28 08:07:10'),
(42, 'New User Register Tutor_admin', '2017-01-28 13:38:33', '2017-01-28 08:08:33'),
(43, 'Add New User by Admin Tutor_admin', '2017-01-28 13:39:23', '2017-01-28 08:09:23'),
(44, 'New User Register Tutor_admin', '2017-01-28 14:13:05', '2017-01-28 08:43:05'),
(45, 'Add New User by Admin Tutor_admin', '2017-01-28 14:15:24', '2017-01-28 08:45:24'),
(46, 'New User Register FileManager123', '2017-01-28 14:26:07', '2017-01-28 08:56:07'),
(47, 'Add New User by Admin Tutor_admin', '2017-01-28 14:28:31', '2017-01-28 08:58:31');

-- --------------------------------------------------------

--
-- Table structure for table `feed_links`
--

CREATE TABLE IF NOT EXISTS `feed_links` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `notification_id` int(11) NOT NULL,
  `link` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk2_notification_links` (`notification_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=33 ;

--
-- Dumping data for table `feed_links`
--

INSERT INTO `feed_links` (`id`, `notification_id`, `link`) VALUES
(1, 16, 'No link'),
(2, 17, 'No link'),
(3, 18, 'No link'),
(4, 19, 'No link'),
(5, 20, 'No link'),
(6, 21, 'No link'),
(7, 22, 'No link'),
(8, 23, 'No link'),
(9, 24, 'No link'),
(10, 25, 'No link'),
(11, 26, 'No link'),
(12, 27, 'No link'),
(13, 28, 'No link'),
(14, 29, 'No link'),
(15, 30, 'No link'),
(16, 31, 'No link'),
(17, 32, 'No link'),
(18, 33, 'No link'),
(19, 34, 'No link'),
(20, 35, 'No link'),
(21, 36, 'No link'),
(22, 37, 'No link'),
(23, 38, 'No link'),
(24, 39, 'No link'),
(25, 40, 'No link'),
(26, 41, 'No link'),
(27, 42, 'No link'),
(28, 43, 'No link'),
(29, 44, 'No link'),
(30, 45, 'No link'),
(31, 46, 'No link'),
(32, 47, 'No link');

-- --------------------------------------------------------

--
-- Table structure for table `feed_user`
--

CREATE TABLE IF NOT EXISTS `feed_user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `notification_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `status` int(1) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uc_notification_user` (`user_id`,`notification_id`),
  KEY `fk2_notification_user` (`user_id`),
  KEY `fk_notification_user` (`notification_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=166 ;

--
-- Dumping data for table `feed_user`
--

INSERT INTO `feed_user` (`id`, `notification_id`, `user_id`, `status`) VALUES
(1, 13, 3, 0),
(2, 14, 3, 0),
(3, 15, 3, 0),
(4, 16, 3, 0),
(6, 17, 3, 0),
(7, 18, 3, 0),
(8, 19, 3, 0),
(9, 20, 3, 0),
(10, 21, 3, 0),
(11, 22, 3, 0),
(12, 23, 3, 0),
(13, 24, 3, 0),
(14, 25, 3, 0),
(15, 26, 3, 0),
(16, 27, 3, 0),
(17, 28, 3, 0),
(18, 28, 18, 0),
(19, 29, 3, 0),
(20, 29, 11, 0),
(21, 29, 18, 0),
(22, 30, 3, 0),
(23, 30, 11, 0),
(24, 30, 12, 0),
(25, 30, 18, 0),
(26, 31, 3, 0),
(27, 31, 11, 0),
(28, 31, 12, 0),
(29, 31, 13, 0),
(30, 31, 18, 0),
(31, 32, 3, 0),
(32, 32, 11, 0),
(33, 32, 12, 0),
(34, 32, 13, 0),
(35, 32, 14, 0),
(36, 32, 18, 0),
(37, 33, 3, 0),
(38, 33, 11, 0),
(39, 33, 12, 0),
(40, 33, 14, 0),
(41, 33, 13, 0),
(42, 33, 18, 0),
(43, 34, 3, 0),
(44, 34, 11, 0),
(45, 34, 12, 0),
(46, 34, 13, 0),
(47, 34, 14, 0),
(48, 34, 18, 0),
(49, 35, 3, 0),
(50, 35, 11, 0),
(51, 35, 12, 0),
(52, 35, 13, 0),
(53, 35, 14, 0),
(54, 35, 18, 0),
(55, 36, 3, 0),
(56, 36, 11, 0),
(57, 36, 12, 0),
(58, 36, 13, 0),
(59, 36, 14, 0),
(60, 36, 18, 0),
(61, 36, 19, 0),
(62, 37, 3, 0),
(63, 37, 11, 0),
(64, 37, 12, 0),
(65, 37, 13, 0),
(66, 37, 14, 0),
(67, 37, 18, 0),
(68, 37, 19, 0),
(69, 37, 20, 0),
(70, 38, 3, 0),
(71, 38, 11, 0),
(72, 38, 12, 0),
(73, 38, 13, 0),
(74, 38, 14, 0),
(75, 38, 18, 0),
(76, 38, 19, 0),
(77, 38, 20, 0),
(78, 39, 3, 0),
(79, 39, 11, 0),
(80, 39, 12, 0),
(81, 39, 13, 0),
(82, 39, 14, 0),
(83, 39, 18, 0),
(84, 39, 19, 0),
(85, 39, 20, 0),
(86, 40, 3, 0),
(87, 40, 11, 0),
(88, 40, 12, 0),
(89, 40, 13, 0),
(90, 40, 14, 0),
(91, 40, 18, 0),
(92, 40, 19, 0),
(93, 40, 20, 0),
(94, 41, 3, 0),
(95, 41, 11, 0),
(96, 41, 12, 0),
(97, 41, 13, 0),
(98, 41, 14, 0),
(99, 41, 18, 0),
(100, 41, 19, 0),
(101, 41, 20, 0),
(102, 41, 21, 0),
(103, 42, 11, 0),
(104, 42, 3, 0),
(105, 42, 12, 0),
(106, 42, 13, 0),
(107, 42, 14, 0),
(108, 42, 18, 0),
(109, 42, 19, 0),
(110, 42, 20, 0),
(111, 42, 21, 0),
(112, 43, 3, 0),
(113, 43, 11, 0),
(114, 43, 12, 0),
(115, 43, 13, 0),
(116, 43, 14, 0),
(117, 43, 18, 0),
(118, 43, 19, 0),
(119, 43, 20, 0),
(120, 43, 22, 0),
(121, 43, 21, 0),
(122, 44, 11, 0),
(123, 44, 3, 0),
(124, 44, 12, 0),
(125, 44, 13, 0),
(126, 44, 14, 0),
(127, 44, 18, 0),
(128, 44, 19, 0),
(129, 44, 20, 0),
(130, 44, 22, 0),
(131, 44, 21, 0),
(132, 45, 3, 0),
(133, 45, 14, 0),
(134, 45, 11, 0),
(135, 45, 12, 0),
(136, 45, 13, 0),
(137, 45, 18, 0),
(138, 45, 19, 0),
(139, 45, 21, 0),
(140, 45, 20, 0),
(141, 45, 22, 0),
(142, 45, 24, 0),
(143, 46, 11, 0),
(144, 46, 3, 0),
(145, 46, 12, 0),
(146, 46, 13, 0),
(147, 46, 14, 0),
(148, 46, 18, 0),
(149, 46, 19, 0),
(150, 46, 20, 0),
(151, 46, 21, 0),
(152, 46, 22, 0),
(153, 46, 24, 0),
(154, 47, 3, 0),
(155, 47, 11, 0),
(156, 47, 12, 0),
(157, 47, 13, 0),
(158, 47, 14, 0),
(159, 47, 18, 0),
(160, 47, 19, 0),
(161, 47, 20, 0),
(162, 47, 21, 0),
(163, 47, 22, 0),
(164, 47, 24, 0),
(165, 47, 25, 0);

-- --------------------------------------------------------

--
-- Table structure for table `file`
--

CREATE TABLE IF NOT EXISTS `file` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `extension` varchar(10) NOT NULL,
  `createAt` varchar(20) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=11 ;

--
-- Dumping data for table `file`
--

INSERT INTO `file` (`id`, `name`, `extension`, `createAt`) VALUES
(1, '15560214080', 'mp4', '2017-01-27 13:28:22'),
(2, '15647977030', 'mp4', '2017-01-27 13:29:49'),
(3, '15757510995', 'pdf', '2017-01-27 13:31:39'),
(4, '15797907489', 'pdf', '2017-01-27 13:32:19'),
(5, '15850190621', '.ppt', '2017-01-27 13:33:12'),
(6, '16040459081', 'octet-stre', '2017-01-27 13:36:22'),
(7, '16113946394', 'vnd.dlna.a', '2017-01-27 13:37:35'),
(8, '16202884157', 'jpeg', '2017-01-27 13:39:04'),
(9, '20683559800', 'jpeg', '2017-01-27 14:53:45'),
(10, '23511199902', 'jpg', '2017-01-27 15:40:53');

-- --------------------------------------------------------

--
-- Table structure for table `folder`
--

CREATE TABLE IF NOT EXISTS `folder` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `color` varchar(7) NOT NULL,
  `std_id` int(11) NOT NULL,
  `container_id` int(11) DEFAULT NULL,
  `status` int(11) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `fk_folder` (`std_id`),
  KEY `container_id` (`container_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=24 ;

--
-- Dumping data for table `folder`
--

INSERT INTO `folder` (`id`, `name`, `color`, `std_id`, `container_id`, `status`) VALUES
(5, '1st year', '#00aced', 7, NULL, 1),
(6, '2nd year', '#ed4598', 7, NULL, 1),
(7, '3rd year', '#44b649', 7, NULL, 1),
(8, 'AAF', '#ec4a49', 7, 7, 1),
(9, 'Project', '#00aced', 7, 7, 1),
(10, 'CSSD', '#fbb712', 7, 7, 1),
(11, 'MITP', '#ed4598', 7, 7, 1),
(12, 'ADB', '#44b649', 7, 7, 1),
(13, '$wer', '#00ab8a', 7, 8, 0),
(14, 'ggg&jki', '#fbb712', 7, 8, 0),
(15, 'dddddd', '#fbb712', 7, 8, 0),
(16, 'edasgdgggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggg', '#ed4b49', 7, 8, 0),
(17, '', '', 7, 11, 0),
(18, 'assigment', '#00aced', 7, 8, 1),
(19, 'lectures', '#00aced', 7, 8, 1),
(20, 'fdgd', '#00aced', 8, NULL, 1),
(21, 'amila', '#ed4598', 6, NULL, 1),
(22, 'fd', '#00ab8a', 8, NULL, 0),
(23, 'dsf', '#00ab8a', 8, NULL, 1);

-- --------------------------------------------------------

--
-- Table structure for table `folder_resource`
--

CREATE TABLE IF NOT EXISTS `folder_resource` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `resource_id` int(11) NOT NULL,
  `folder_id` int(11) NOT NULL,
  `status` int(11) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uc_folder_resource` (`resource_id`,`folder_id`),
  KEY `resource_id` (`resource_id`),
  KEY `folder_id` (`folder_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `glossary`
--

CREATE TABLE IF NOT EXISTS `glossary` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `unit_id` int(11) NOT NULL,
  `word` varchar(255) NOT NULL,
  `meaning_text` text NOT NULL,
  PRIMARY KEY (`id`),
  KEY `unit_id` (`unit_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=6 ;

--
-- Dumping data for table `glossary`
--

INSERT INTO `glossary` (`id`, `unit_id`, `word`, `meaning_text`) VALUES
(1, 1, 'Cell', 'Cell is a cell'),
(2, 3, 'Prokaryotic cells', 'Prokaryotic cells were the first form of life on Earth, characterised by having vital biological processes including cell signaling and being self-sustaining. They are simpler and smaller than eukaryotic cells, and lack membrane-bound organelles such as the nucleus. Prokaryotes include two of the domains of life, bacteria and archaea. The DNA of a prokaryotic cell consists of a single chromosome that is in direct contact with the cytoplasm. The nuclear region in the cytoplasm is called the nucleoid. Most prokaryotes are the smallest of all organisms ranging from 0.5 to 2.0 µm in diameter.[12]'),
(3, 3, 'Eukaryotic cells', 'Plants, animals, fungi, slime moulds, protozoa, and algae are all eukaryotic. These cells are about fifteen times wider than a typical prokaryote and can be as much as a thousand times greater in volume. The main distinguishing feature of eukaryotes as compared to prokaryotes is compartmentalization: the presence of membrane-bound organelles (compartments) in which specific metabolic activities take place. Most important among these is a cell nucleus, an organelle that houses the cell''s DNA. This nucleus gives the eukaryote its name, which means "true kernel (nucleus)". Other differences include:'),
(4, 3, 'Subcellular components', 'All cells, whether prokaryotic or eukaryotic, have a membrane that envelops the cell, regulates what moves in and out (selectively permeable), and maintains the electric potential of the cell. Inside the membrane, the cytoplasm takes up most of the cell''s volume. All cells (except red blood cells which lack a cell nucleus and most organelles to accommodate maximum space for hemoglobin) possess DNA, the hereditary material of genes, and RNA, containing the information necessary to build various proteins such as enzymes, the cell''s primary machinery. There are also other kinds of biomolecules in cells. This article lists these primary components of the cell, then briefly describes their function.'),
(5, 3, 'Membrane', 'The cell membrane, or plasma membrane, is a biological membrane that surrounds the cytoplasm of a cell. In animals, the plasma membrane is the outer boundary of the cell, while in plants and prokaryotes it is usually covered by a cell wall. This membrane serves to separate and protect a cell from its surrounding environment and is made mostly from a double layer of phospholipids, which are amphiphilic (partly hydrophobic and partly hydrophilic). Hence, the layer is called a phospholipid bilayer, or sometimes a fluid mosaic membrane. Embedded within this membrane is a variety of protein molecules that act as channels and pumps that move different molecules into and out of the cell. The membrane is said to be ''semi-permeable'', in that it can either let a substance (molecule or ion) pass through freely, pass through to a limited extent or not pass through at all. Cell surface membranes also contain receptor proteins that allow cells to detect external signaling molecules such as hormones.');

-- --------------------------------------------------------

--
-- Table structure for table `grade`
--

CREATE TABLE IF NOT EXISTS `grade` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `grade` varchar(20) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=7 ;

--
-- Dumping data for table `grade`
--

INSERT INTO `grade` (`id`, `grade`) VALUES
(1, 'Year 6'),
(2, 'Year 7'),
(3, 'Year 8'),
(4, 'Year 9'),
(5, 'Year 10 (GCSE/IGCSE)'),
(6, 'Year 11 (GCSE/IGCSE)');

-- --------------------------------------------------------

--
-- Table structure for table `group`
--

CREATE TABLE IF NOT EXISTS `group` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=4 ;

--
-- Dumping data for table `group`
--

INSERT INTO `group` (`id`, `name`) VALUES
(1, 'Maths'),
(2, 'Physics'),
(3, 'Chemistry');

-- --------------------------------------------------------

--
-- Table structure for table `headings`
--

CREATE TABLE IF NOT EXISTS `headings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(300) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=7 ;

--
-- Dumping data for table `headings`
--

INSERT INTO `headings` (`id`, `name`) VALUES
(1, 'cell'),
(2, 'algebra'),
(3, 'calculus'),
(4, 'cell stucture'),
(5, 'organic'),
(6, 'circle');

-- --------------------------------------------------------

--
-- Table structure for table `helpers`
--

CREATE TABLE IF NOT EXISTS `helpers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(15) NOT NULL,
  `color` varchar(15) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=8 ;

--
-- Dumping data for table `helpers`
--

INSERT INTO `helpers` (`id`, `name`, `color`) VALUES
(1, 'Maths Help', ' #00aced'),
(2, 'Biology Help', '#00ab8a'),
(3, 'Physics Help', '#ec4a49'),
(4, 'Chemistry Help', '#fbb712'),
(5, 'Technical Help', '#01c971'),
(6, 'General Help', '#fa841a'),
(7, 'Payments Help', '#067193');

-- --------------------------------------------------------

--
-- Table structure for table `interest`
--

CREATE TABLE IF NOT EXISTS `interest` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `interests` varchar(500) NOT NULL,
  `fav_subject` varchar(100) NOT NULL,
  `topic` varchar(100) NOT NULL,
  `ambition` varchar(200) NOT NULL,
  `quote` text NOT NULL,
  `std_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `std_id` (`std_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=2 ;

--
-- Dumping data for table `interest`
--

INSERT INTO `interest` (`id`, `interests`, `fav_subject`, `topic`, `ambition`, `quote`, `std_id`) VALUES
(1, 'learning new things', 'mathematic', 'calculus', 'be a software enigineer', 'I am not a geek', 7);

-- --------------------------------------------------------

--
-- Table structure for table `message`
--

CREATE TABLE IF NOT EXISTS `message` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `subject` varchar(20) NOT NULL,
  `content` text NOT NULL,
  `status` int(1) DEFAULT '0',
  `msg_delete` int(1) DEFAULT '0',
  `date_time` varchar(50) NOT NULL,
  `user_id` int(11) NOT NULL,
  `helper_id` int(11) NOT NULL,
  `stars` int(11) NOT NULL DEFAULT '1',
  `reply_count` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `fk_message` (`user_id`),
  KEY `helper_id` (`helper_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=3 ;

--
-- Dumping data for table `message`
--

INSERT INTO `message` (`id`, `subject`, `content`, `status`, `msg_delete`, `date_time`, `user_id`, `helper_id`, `stars`, `reply_count`) VALUES
(1, 'Need Help', 'I want to know more about algebra', 0, 1, '2017-01-27 15:40:51', 7, 1, 1, 1),
(2, 'Test message', 'without attachment', 0, 0, '2017-01-27 15:42:55', 7, 1, 1, 0);

-- --------------------------------------------------------

--
-- Table structure for table `message_attachment`
--

CREATE TABLE IF NOT EXISTS `message_attachment` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `message_id` int(11) NOT NULL,
  `file_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uc_message_attachment` (`message_id`,`file_id`),
  KEY `message_id` (`message_id`),
  KEY `file_id` (`file_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=2 ;

--
-- Dumping data for table `message_attachment`
--

INSERT INTO `message_attachment` (`id`, `message_id`, `file_id`) VALUES
(1, 1, 10);

-- --------------------------------------------------------

--
-- Table structure for table `module`
--

CREATE TABLE IF NOT EXISTS `module` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(200) NOT NULL,
  `description` varchar(250) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=6 ;

--
-- Dumping data for table `module`
--

INSERT INTO `module` (`id`, `name`, `description`) VALUES
(1, 'Cell Stucture', 'cell stucture of the plants  cell stucture of the plants cell stucture of the plants cell stucture of the plants cell stucture of the plants'),
(2, 'Calculus', 'cell stucture of the plants  cell stucture of the plants cell stucture of the plants cell stucture of the plants cell stucture of the plants'),
(3, 'Human Body', 'cell stucture of the plants  cell stucture of the plants cell stucture of the plants cell stucture of the plants cell stucture of the plants'),
(4, 'Geometry', 'circle, triangle'),
(5, 'Vector', 'Vector unit of applied mathematics');

-- --------------------------------------------------------

--
-- Table structure for table `notes`
--

CREATE TABLE IF NOT EXISTS `notes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `text` varchar(500) NOT NULL,
  `folder_id` int(11) DEFAULT NULL,
  `color` varchar(10) NOT NULL,
  `student_id` int(11) NOT NULL,
  `status` int(11) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `fk_notes` (`folder_id`),
  KEY `student_id` (`student_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=9 ;

--
-- Dumping data for table `notes`
--

INSERT INTO `notes` (`id`, `text`, `folder_id`, `color`, `student_id`, `status`) VALUES
(3, 'My Note***Course content of 3 years..', NULL, '#999999', 7, 1),
(4, 'zzzzzz***zzzzzzzz', 8, '#999999', 7, 0),
(5, 'ccccc***cccc', 8, '#999999', 7, 0),
(6, 'conetnt***AFF assignment test', 8, '#999999', 7, 1),
(7, 'rrr***ppp', NULL, '#999999', 6, 1),
(8, 'yyt***ttt', NULL, '#999999', 6, 1);

-- --------------------------------------------------------

--
-- Table structure for table `package`
--

CREATE TABLE IF NOT EXISTS `package` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `curriculum_id` int(11) NOT NULL,
  `grade_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk2_package` (`curriculum_id`),
  KEY `fk_package` (`grade_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=11 ;

--
-- Dumping data for table `package`
--

INSERT INTO `package` (`id`, `name`, `curriculum_id`, `grade_id`) VALUES
(1, 'Maths', 1, 1),
(2, 'Maths', 2, 2),
(3, 'Maths', 3, 1),
(4, 'Maths', 3, 2),
(6, 'Maths', 1, 2),
(7, 'Maths', 1, 3),
(8, 'Science', 1, 1),
(9, 'Science', 1, 2),
(10, 'Maths_Science', 1, 1);

-- --------------------------------------------------------

--
-- Table structure for table `package_price`
--

CREATE TABLE IF NOT EXISTS `package_price` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `package_type_id` int(11) NOT NULL,
  `package_id` int(11) NOT NULL,
  `price` double NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uc_package_price` (`package_type_id`,`package_id`),
  KEY `fk_package_price` (`package_id`),
  KEY `fk2_package_price` (`package_type_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=4 ;

--
-- Dumping data for table `package_price`
--

INSERT INTO `package_price` (`id`, `package_type_id`, `package_id`, `price`) VALUES
(1, 1, 1, 5000),
(2, 2, 1, 10000),
(3, 3, 1, 20000);

-- --------------------------------------------------------

--
-- Table structure for table `package_subject`
--

CREATE TABLE IF NOT EXISTS `package_subject` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `package_id` int(11) NOT NULL,
  `subject_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uc_package_subject` (`package_id`,`subject_id`),
  KEY `fk2_package_subject` (`subject_id`),
  KEY `fk1_package_subject` (`package_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=23 ;

--
-- Dumping data for table `package_subject`
--

INSERT INTO `package_subject` (`id`, `package_id`, `subject_id`) VALUES
(1, 1, 1),
(4, 1, 2),
(5, 1, 3),
(6, 2, 1),
(8, 2, 2),
(9, 2, 3),
(10, 3, 1),
(11, 3, 2),
(12, 3, 3),
(13, 4, 1),
(15, 6, 1),
(16, 7, 1),
(21, 7, 2),
(22, 7, 3),
(17, 8, 2),
(19, 8, 3),
(18, 9, 2),
(20, 9, 3);

-- --------------------------------------------------------

--
-- Table structure for table `package_subject_module`
--

CREATE TABLE IF NOT EXISTS `package_subject_module` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `module_id` int(11) NOT NULL,
  `package_subject_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uc_package_subject_module` (`module_id`,`package_subject_id`),
  KEY `fk2_package_subject_module` (`package_subject_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=7 ;

--
-- Dumping data for table `package_subject_module`
--

INSERT INTO `package_subject_module` (`id`, `module_id`, `package_subject_id`) VALUES
(1, 1, 1),
(4, 1, 5),
(2, 2, 1),
(3, 3, 1),
(5, 4, 10),
(6, 5, 1);

-- --------------------------------------------------------

--
-- Table structure for table `package_type`
--

CREATE TABLE IF NOT EXISTS `package_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `months` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=4 ;

--
-- Dumping data for table `package_type`
--

INSERT INTO `package_type` (`id`, `name`, `months`) VALUES
(1, 'Monthly', 1),
(2, 'Termly', 4),
(3, 'Annually', 12);

-- --------------------------------------------------------

--
-- Table structure for table `payment`
--

CREATE TABLE IF NOT EXISTS `payment` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `amount` double DEFAULT NULL,
  `status` int(1) NOT NULL DEFAULT '0',
  `payment_type_id` int(11) NOT NULL,
  `std_id` int(11) NOT NULL,
  `date` date DEFAULT NULL,
  `first_paid` int(11) NOT NULL DEFAULT '0',
  `balance` double DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `fk_payment` (`payment_type_id`),
  KEY `std_id` (`std_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=6 ;

--
-- Dumping data for table `payment`
--

INSERT INTO `payment` (`id`, `amount`, `status`, `payment_type_id`, `std_id`, `date`, `first_paid`, `balance`) VALUES
(1, 5000, 0, 6, 5, '2017-01-27', 0, 0),
(2, 0, 0, 5, 6, '2017-01-27', 0, 0),
(3, 20000, 0, 1, 7, '2017-01-27', 0, 0),
(4, 5000, 0, 2, 8, '2017-01-28', 0, 0),
(5, 5000, 0, 5, 9, '2017-01-28', 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `payment_type`
--

CREATE TABLE IF NOT EXISTS `payment_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(200) NOT NULL,
  `image_url` varchar(500) NOT NULL,
  `accNo` varchar(15) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=7 ;

--
-- Dumping data for table `payment_type`
--

INSERT INTO `payment_type` (`id`, `name`, `image_url`, `accNo`) VALUES
(1, 'Credit Card-AMEX/Visa/MasterCard', 'images/img1', ''),
(2, 'Debit Card-Visa/MasterCard Only', 'images/img2', ''),
(3, 'Dialog Ez-Cash', 'images/img3', ''),
(4, 'Mobitel M-Cash', 'images/img4', ''),
(5, 'Direct Debit', '', ''),
(6, 'Standing Order', '', '');

-- --------------------------------------------------------

--
-- Table structure for table `planner`
--

CREATE TABLE IF NOT EXISTS `planner` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `std_id` int(11) NOT NULL,
  `title` varchar(250) NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `start_time` time NOT NULL,
  `end_time` time NOT NULL,
  `repeat_type_id` int(11) NOT NULL,
  `created_date` datetime NOT NULL,
  `last_mod_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` int(11) NOT NULL,
  `last_mod_by` int(11) NOT NULL,
  `event_color` varchar(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `std_id` (`std_id`),
  KEY `repeat_type_id` (`repeat_type_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=65 ;

--
-- Dumping data for table `planner`
--

INSERT INTO `planner` (`id`, `std_id`, `title`, `start_date`, `end_date`, `start_time`, `end_time`, `repeat_type_id`, `created_date`, `last_mod_date`, `created_by`, `last_mod_by`, `event_color`) VALUES
(55, 8, 'try', '2017-01-17', '2017-01-17', '13:45:00', '13:45:00', 4, '2017-01-28 08:01:15', '2017-01-28 08:01:15', 8, 8, '44b649'),
(56, 8, 'sdfs', '2017-01-17', '2017-01-17', '13:45:00', '13:45:00', 4, '2017-01-28 08:01:33', '2017-01-28 08:01:33', 8, 8, 'ed4598'),
(61, 8, 'ew', '2017-01-24', '2017-01-24', '14:15:00', '14:15:00', 4, '2017-01-28 08:41:54', '2017-01-28 08:41:54', 8, 8, '00ab8a'),
(62, 8, 'ew', '2017-01-24', '2017-01-24', '14:15:00', '14:15:00', 4, '2017-01-28 08:42:47', '2017-01-28 08:42:47', 8, 8, '00ab8a');

-- --------------------------------------------------------

--
-- Table structure for table `planner_notes`
--

CREATE TABLE IF NOT EXISTS `planner_notes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `note` text NOT NULL,
  `planner_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `planner_id` (`planner_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=28 ;

-- --------------------------------------------------------

--
-- Table structure for table `planner_reminder`
--

CREATE TABLE IF NOT EXISTS `planner_reminder` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `planner_id` int(11) NOT NULL,
  `reminder_date` date NOT NULL,
  `reminder_time` time NOT NULL,
  PRIMARY KEY (`id`),
  KEY `planner_id` (`planner_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=27 ;

--
-- Dumping data for table `planner_reminder`
--

INSERT INTO `planner_reminder` (`id`, `planner_id`, `reminder_date`, `reminder_time`) VALUES
(17, 55, '0000-00-00', '00:00:00'),
(18, 56, '0000-00-00', '00:00:00'),
(23, 61, '0000-00-00', '00:00:00'),
(24, 62, '0000-00-00', '00:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `promotion`
--

CREATE TABLE IF NOT EXISTS `promotion` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(15) NOT NULL,
  `amount` double NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=3 ;

--
-- Dumping data for table `promotion`
--

INSERT INTO `promotion` (`id`, `code`, `amount`) VALUES
(1, 'TW001', 500),
(2, 'cost00012', 1000);

-- --------------------------------------------------------

--
-- Table structure for table `question`
--

CREATE TABLE IF NOT EXISTS `question` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `question` text NOT NULL,
  `question_type_id` int(11) NOT NULL,
  `description` varchar(255) NOT NULL,
  `grade_id` int(11) NOT NULL,
  `curriculum_id` int(11) NOT NULL,
  `unit_id` int(11) NOT NULL,
  `subject_id` int(11) NOT NULL,
  `module_id` int(11) NOT NULL,
  `status` varchar(20) NOT NULL DEFAULT 'NEW',
  `created_date` datetime NOT NULL,
  `created_by` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=11 ;

--
-- Dumping data for table `question`
--

INSERT INTO `question` (`id`, `question`, `question_type_id`, `description`, `grade_id`, `curriculum_id`, `unit_id`, `subject_id`, `module_id`, `status`, `created_date`, `created_by`) VALUES
(1, 'If Logx (1 / 8) = - 3 / 2, then x is equal to ', 0, 'use rules of logarithms', 1, 1, 1, 1, 1, 'NEW', '2016-12-23 00:00:00', 0),
(2, '20 % of 2 is equal to ', 0, '2*20%', 1, 1, 1, 1, 1, 'NEW', '2016-12-24 00:00:00', 0),
(3, 'If Log 4 (x) = 12, then log 2 (x / 4) is equal to ', 0, 'log 4()', 1, 1, 1, 1, 1, 'NEW', '2016-12-22 00:00:00', 0),
(4, 'fffffffffff', 4, 'ffffffffffff', 1, 1, 1, 1, 1, 'NEW', '0000-00-00 00:00:00', 0),
(5, 'gfghbfg', 5, 'dfgdfg', 1, 1, 1, 1, 1, 'NEW', '0000-00-00 00:00:00', 0),
(6, 'fgsdgfdsfvbdsv ', 2, 'rretgre', 1, 1, 1, 1, 1, 'NEW', '0000-00-00 00:00:00', 0),
(7, 'nfg  fgnb fg  b fr   b rbrt', 3, 'kkuik', 1, 1, 1, 1, 1, 'NEW', '0000-00-00 00:00:00', 0),
(8, 'fsdfsdfsd', 1, 'fsdfsd', 1, 1, 1, 1, 1, 'NEW', '0000-00-00 00:00:00', 0),
(9, 'sdfsdfsdf ', 2, 'fsdfdsfsdfsd', 1, 1, 1, 1, 1, 'NEW', '0000-00-00 00:00:00', 0),
(10, 'hfdghdfghdfgh', 2, 'ggdfg', 1, 1, 1, 1, 1, 'NEW', '0000-00-00 00:00:00', 0);

-- --------------------------------------------------------

--
-- Table structure for table `question_log`
--

CREATE TABLE IF NOT EXISTS `question_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `question_id` int(11) NOT NULL,
  `answer_id` int(11) NOT NULL,
  `updated_date` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `question_id` (`question_id`),
  KEY `answer_id` (`answer_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `question_type`
--

CREATE TABLE IF NOT EXISTS `question_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `description` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=9 ;

--
-- Dumping data for table `question_type`
--

INSERT INTO `question_type` (`id`, `name`, `description`) VALUES
(1, 'Style 1', 'Images with boxes underneath drop down arrow with answer options (2/3/4/5/6)'),
(2, 'Style 2', 'State whether below sentences are True (T) or False (F) in the boxes List of sentences with box next to it with drop down for true or false (3/4/5/6/7/8)'),
(3, 'Stlle 3', ''),
(4, 'Style 4', 'MCQ'),
(5, 'style 5', 'dragging'),
(6, 'Style 6', 'Yes/No'),
(7, 'Style 7', 'MCQ Type 2'),
(8, 'Style 8', 'Filling Blanks');

-- --------------------------------------------------------

--
-- Table structure for table `quiz`
--

CREATE TABLE IF NOT EXISTS `quiz` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `student_id` int(11) NOT NULL,
  `subject_id` int(11) NOT NULL,
  `module_id` int(11) NOT NULL,
  `grade_id` int(11) NOT NULL,
  `curriculum_id` int(11) NOT NULL,
  `type` varchar(20) NOT NULL,
  `questions` int(11) NOT NULL,
  `schedule_time` time NOT NULL,
  `time_taken` time NOT NULL,
  `speed_bonus` time NOT NULL,
  `start_time` datetime NOT NULL,
  `end_time` datetime NOT NULL,
  `stars` int(11) NOT NULL,
  `quiz_name` varchar(100) NOT NULL,
  `full_marks` float NOT NULL,
  `status` varchar(10) NOT NULL DEFAULT 'NEW',
  `created_date` datetime NOT NULL,
  `last_mod_date` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `student_id` (`student_id`),
  KEY `student_id_2` (`student_id`),
  KEY `student_id_3` (`student_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=34 ;

--
-- Dumping data for table `quiz`
--

INSERT INTO `quiz` (`id`, `student_id`, `subject_id`, `module_id`, `grade_id`, `curriculum_id`, `type`, `questions`, `schedule_time`, `time_taken`, `speed_bonus`, `start_time`, `end_time`, `stars`, `quiz_name`, `full_marks`, `status`, `created_date`, `last_mod_date`) VALUES
(8, 8, 1, 0, 0, 0, 'SUBJECT_TEST', 9, '00:45:00', '00:00:00', '00:00:00', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 0, '', 0, 'COMPLETED', '0000-00-00 00:00:00', '2017-01-22 19:43:27'),
(9, 8, 1, 0, 0, 0, 'SUBJECT_TEST', 10, '00:45:00', '00:00:00', '00:00:00', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 0, '', 0, 'COMPLETED', '0000-00-00 00:00:00', '2017-01-22 19:43:27'),
(10, 8, 1, 0, 0, 0, 'SUBJECT_TEST', 10, '00:45:00', '00:00:00', '00:00:00', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 0, '', 0, 'COMPLETED', '2017-01-05 04:19:35', '2017-01-22 19:43:27'),
(11, 8, 2, 1, 0, 0, 'SUBJECT_TYPE', 10, '00:00:45', '00:00:00', '00:00:00', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 0, '', 0, 'COMPLETED', '0000-00-00 00:00:00', '2017-01-22 19:43:27'),
(14, 8, 1, 0, 1, 0, 'SUBJECT_TEST', 10, '00:45:00', '00:00:00', '00:00:00', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 0, 'Maths Test', 0, 'COMPLETED', '2017-01-05 06:11:04', '2017-01-22 19:43:27'),
(15, 8, 1, 0, 1, 0, 'SUBJECT_TEST', 10, '00:45:00', '00:00:00', '00:00:00', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 0, 'Maths Test', 0, 'COMPLETED', '2017-01-05 06:37:29', '2017-01-22 19:43:27'),
(16, 8, 1, 0, 1, 0, 'SUBJECT_TEST', 10, '00:45:00', '00:00:00', '00:00:00', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 0, 'Maths Test', 0, 'COMPLETED', '2017-01-05 06:52:52', '2017-01-22 19:43:27'),
(17, 8, 1, 0, 1, 0, 'SUBJECT_TEST', 10, '00:45:00', '00:00:00', '00:00:00', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 0, 'Maths Test', 0, 'COMPLETED', '2017-01-05 06:52:54', '2017-01-22 19:43:27'),
(18, 8, 1, 0, 1, 0, 'SUBJECT_TEST', 10, '00:45:00', '00:00:00', '00:00:00', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 0, 'Maths Test', 0, 'COMPLETED', '2017-01-05 06:53:09', '2017-01-22 19:43:27'),
(19, 8, 1, 2, 1, 1, 'MODULE_TEST', 1, '00:45:00', '17:23:05', '00:00:00', '2017-01-25 16:45:51', '2017-01-27 10:08:56', 0, 'Maths Test', 5, 'COMPLETED', '2017-01-05 06:53:50', '2017-01-28 10:26:30'),
(21, 8, 1, 2, 1, 1, 'MODULE_TEST', 10, '00:45:00', '00:00:00', '00:00:25', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 69, 'Maths cells Test', 89, 'COMPLETED', '2017-01-05 09:12:55', '2017-01-28 10:25:33'),
(22, 8, 1, 1, 1, 1, 'MODULE_TEST', 10, '00:45:00', '00:00:00', '00:00:00', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 0, 'Maths cells Test', 98, 'COMPLETED', '2017-01-05 09:53:16', '2017-01-28 11:13:37'),
(23, 8, 1, 0, 1, 0, 'SUBJECT_TEST', 10, '00:45:00', '00:00:00', '00:00:00', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 0, 'Maths Test', 0, 'NEW', '2017-01-25 04:48:34', '2017-01-24 17:48:34'),
(24, 8, 1, 0, 1, 0, 'SUBJECT_TEST', 10, '00:45:00', '00:00:00', '00:00:00', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 0, 'Maths Test', 0, 'NEW', '2017-01-25 04:54:38', '2017-01-24 17:54:38'),
(25, 8, 1, 0, 1, 0, 'SUBJECT_TEST', 10, '00:45:00', '00:00:00', '00:00:00', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 0, 'Maths Test', 0, 'NEW', '2017-01-25 05:10:59', '2017-01-24 18:10:59'),
(26, 8, 1, 0, 1, 0, 'SUBJECT_TEST', 10, '00:45:00', '00:00:00', '00:00:00', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 0, 'Maths Test', 0, 'NEW', '2017-01-25 05:25:11', '2017-01-24 18:25:11'),
(27, 8, 1, 0, 1, 0, 'SUBJECT_TEST', 10, '00:45:00', '00:00:00', '00:00:00', '2017-01-25 05:29:22', '0000-00-00 00:00:00', 0, 'Maths Test', 0, 'NEW', '2017-01-25 05:29:22', '2017-01-24 18:29:22'),
(28, 8, 1, 0, 1, 0, 'SUBJECT_TEST', 10, '00:45:00', '00:00:00', '00:00:00', '2017-01-25 07:11:58', '0000-00-00 00:00:00', 0, 'Maths Test', 0, 'NEW', '2017-01-25 07:11:58', '2017-01-24 20:11:58'),
(29, 8, 1, 1, 1, 0, 'MODULE_TEST', 10, '00:45:00', '00:00:00', '00:00:00', '0000-00-00 00:00:00', '0000-00-00 00:00:08', 0, 'Maths Cell Stucture Test', 0, 'NEW', '2017-01-25 07:55:06', '2017-01-24 20:55:06'),
(30, 8, 1, 1, 1, 0, 'MODULE_TEST', 10, '00:45:00', '00:00:00', '00:00:00', '2017-01-25 08:58:15', '0000-00-00 00:00:00', 0, 'Maths Cell Stucture Test', 0, 'NEW', '2017-01-25 08:58:15', '2017-01-24 21:58:15'),
(31, 8, 1, 1, 1, 0, 'MODULE_TEST', 10, '00:45:00', '00:00:00', '00:00:00', '2017-01-25 09:12:24', '0000-00-00 00:00:00', 0, 'Maths Cell Stucture Test', 0, 'NEW', '2017-01-25 09:12:24', '2017-01-24 22:12:24'),
(32, 8, 1, 1, 1, 0, 'MODULE_TEST', 10, '00:45:00', '00:00:00', '00:00:00', '2017-01-25 09:25:07', '0000-00-00 00:00:00', 0, 'Maths Cell Stucture Test', 0, 'NEW', '2017-01-25 09:25:07', '2017-01-24 22:25:07'),
(33, 8, 1, 1, 1, 0, 'MODULE_TEST', 10, '00:45:00', '00:00:00', '00:00:00', '2017-01-25 09:26:40', '0000-00-00 00:00:00', 0, 'Maths Cell Stucture Test', 0, 'NEW', '2017-01-25 09:26:40', '2017-01-24 22:26:40');

-- --------------------------------------------------------

--
-- Table structure for table `quiz_config`
--

CREATE TABLE IF NOT EXISTS `quiz_config` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `curriculum_id` int(11) NOT NULL,
  `grade_id` int(11) NOT NULL,
  `subject_id` int(11) NOT NULL,
  `module_id` int(11) NOT NULL,
  `test_type` varchar(20) NOT NULL,
  `num_of_ques` int(5) NOT NULL,
  `schedule_time` time NOT NULL,
  `time_bonus` varchar(250) NOT NULL,
  `created_by` int(11) NOT NULL,
  `created_date` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `curriculum_id` (`curriculum_id`),
  KEY `grade_id` (`grade_id`),
  KEY `subject_id` (`subject_id`),
  KEY `module_id` (`module_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=3 ;

--
-- Dumping data for table `quiz_config`
--

INSERT INTO `quiz_config` (`id`, `curriculum_id`, `grade_id`, `subject_id`, `module_id`, `test_type`, `num_of_ques`, `schedule_time`, `time_bonus`, `created_by`, `created_date`) VALUES
(1, 1, 1, 1, 1, 'MODULE_TEST', 10, '01:30:00', '01:15:05', 0, '0000-00-00 00:00:00'),
(2, 1, 1, 1, 0, 'SUBJECT_TEST', 10, '01:30:00', '01:15:00', 0, '0000-00-00 00:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `quiz_question`
--

CREATE TABLE IF NOT EXISTS `quiz_question` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `quiz_id` int(11) NOT NULL,
  `question_id` int(11) NOT NULL,
  `question_order` int(11) NOT NULL,
  `submit_answer` varchar(500) NOT NULL,
  `doubt` tinyint(1) NOT NULL,
  `status` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `quiz_id` (`quiz_id`),
  KEY `question_id` (`question_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `repeat_type`
--

CREATE TABLE IF NOT EXISTS `repeat_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=5 ;

--
-- Dumping data for table `repeat_type`
--

INSERT INTO `repeat_type` (`id`, `name`) VALUES
(1, 'daily'),
(2, 'weekly'),
(3, 'monthly'),
(4, 'No Repeat');

-- --------------------------------------------------------

--
-- Table structure for table `reply`
--

CREATE TABLE IF NOT EXISTS `reply` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `message_id` int(11) NOT NULL,
  `date_time` varchar(50) NOT NULL,
  `msg_delete` int(11) DEFAULT '0',
  `status` int(11) DEFAULT '0',
  `content` text NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_reply` (`user_id`),
  KEY `fk2_reply` (`message_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=3 ;

--
-- Dumping data for table `reply`
--

INSERT INTO `reply` (`id`, `user_id`, `message_id`, `date_time`, `msg_delete`, `status`, `content`) VALUES
(1, 4, 2, '2017-01-27', 0, 0, 'Hi \nI will send attchment'),
(2, 1, 1, '2017-01-27 15:50:14', 1, 0, 'thnx');

-- --------------------------------------------------------

--
-- Table structure for table `reply_attachment`
--

CREATE TABLE IF NOT EXISTS `reply_attachment` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `reply_id` int(11) NOT NULL,
  `file_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uc_reply_attachment` (`reply_id`,`file_id`),
  KEY `reply_id` (`reply_id`),
  KEY `file_id` (`file_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `report_question`
--

CREATE TABLE IF NOT EXISTS `report_question` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `student_id` int(11) NOT NULL,
  `question_id` int(11) NOT NULL,
  `reason` varchar(200) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `student_id` (`student_id`,`question_id`),
  KEY `question_id` (`question_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `report_resource`
--

CREATE TABLE IF NOT EXISTS `report_resource` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `student_id` int(11) NOT NULL,
  `resources_id` int(11) NOT NULL,
  `report_message` text NOT NULL,
  `created_date` date NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=5 ;

--
-- Dumping data for table `report_resource`
--

INSERT INTO `report_resource` (`id`, `student_id`, `resources_id`, `report_message`, `created_date`) VALUES
(1, 7, 1, 'Does not match present curriculum', '2017-01-27'),
(2, 7, 1, 'Incorrect information', '2017-01-28'),
(3, 7, 1, 'Resource is indecent or upsetting', '2017-01-28'),
(4, 8, 2, 'Information not useful', '2017-01-28');

-- --------------------------------------------------------

--
-- Table structure for table `resources`
--

CREATE TABLE IF NOT EXISTS `resources` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `resource_type_id` int(11) NOT NULL,
  `file_id` int(11) NOT NULL,
  `description` varchar(255) NOT NULL,
  `heading_id` int(11) NOT NULL,
  `confirm` int(11) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `fk_resources` (`resource_type_id`),
  KEY `fk2_resources` (`file_id`),
  KEY `heading_id` (`heading_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=9 ;

--
-- Dumping data for table `resources`
--

INSERT INTO `resources` (`id`, `name`, `resource_type_id`, `file_id`, `description`, `heading_id`, `confirm`) VALUES
(1, 'mini clip', 2, 1, 'testing', 3, 0),
(2, 'mini clip2', 2, 2, 'testing', 3, 0),
(3, 'pdf file1', 7, 3, 'testing pdf', 3, 0),
(4, 'pdf file2', 8, 4, 'testing pdf', 3, 0),
(5, 'ppt file 1', 4, 5, 'testing ppt', 3, 0),
(6, 'doc file 1', 8, 6, 'testing doc', 2, 0),
(7, 'audio test', 3, 7, 'audio test', 2, 0),
(8, 'image test', 6, 8, 'image test', 6, 0);

-- --------------------------------------------------------

--
-- Table structure for table `resource_tags`
--

CREATE TABLE IF NOT EXISTS `resource_tags` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `resource_id` int(11) NOT NULL,
  `tag_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uc_resource_tags` (`resource_id`,`tag_id`),
  KEY `fk_resource_tags` (`resource_id`),
  KEY `fk2_resource_tags` (`tag_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=9 ;

--
-- Dumping data for table `resource_tags`
--

INSERT INTO `resource_tags` (`id`, `resource_id`, `tag_id`) VALUES
(1, 1, 1),
(2, 2, 1),
(3, 3, 1),
(4, 4, 1),
(5, 5, 1),
(6, 6, 1),
(7, 7, 1),
(8, 8, 5);

-- --------------------------------------------------------

--
-- Table structure for table `resource_types`
--

CREATE TABLE IF NOT EXISTS `resource_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `icon` varchar(20) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=9 ;

--
-- Dumping data for table `resource_types`
--

INSERT INTO `resource_types` (`id`, `name`, `icon`) VALUES
(1, 'Tutor Challenge', 'pe-7f-study'),
(2, 'Video', 'pe-7f-film'),
(3, 'Animation', 'pe-7f-play'),
(4, 'Presetnation', 'pe-7f-display1'),
(5, 'Interactive Activity\r\n', 'pe-7f-mouse'),
(6, 'Knowledge Nugget\r\n', 'pe-7f-rocket'),
(7, 'Revision Notes\r\n', 'pe-7f-notebook'),
(8, 'Worksheets', 'pe-7f-news-paper');

-- --------------------------------------------------------

--
-- Table structure for table `review_email`
--

CREATE TABLE IF NOT EXISTS `review_email` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(100) NOT NULL,
  `status` int(11) NOT NULL,
  `std_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `std_id` (`std_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `signup_tokens`
--

CREATE TABLE IF NOT EXISTS `signup_tokens` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(60) NOT NULL,
  `token` varchar(200) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=7 ;

--
-- Dumping data for table `signup_tokens`
--

INSERT INTO `signup_tokens` (`id`, `email`, `token`) VALUES
(1, 'amilavidurangawelikala@gmail.com', 'c75b6f114c23a4d7ea11331e7c00e73c6820'),
(2, 'lakshikasur@gmail.com', '123'),
(3, 'ashikamrf71@gmail.com', '1679091c5a880faf6fb5e6087eb1b2dc3489'),
(4, 'lakmi@tutorwizard.lk', '8f14e45fceea167a5a36dedd4bea25432335'),
(5, 'nipunann0710@gmail.com', 'c9f0f895fb98ab9159f51fd0297e236d8656'),
(6, 'amilavidurangawelikala@gmail.com', '45c48cce2e2d7fbdea1afc51c7c6ad266229');

-- --------------------------------------------------------

--
-- Table structure for table `snap`
--

CREATE TABLE IF NOT EXISTS `snap` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `file_id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `student_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `file_id` (`file_id`),
  KEY `student_id_2` (`student_id`),
  KEY `student_id_3` (`student_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `star_messages`
--

CREATE TABLE IF NOT EXISTS `star_messages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `message` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=14 ;

--
-- Dumping data for table `star_messages`
--

INSERT INTO `star_messages` (`id`, `message`) VALUES
(1, 'Boom!'),
(2, 'Excellent Work!'),
(3, 'Genius Level!'),
(4, 'Nailed It!'),
(5, 'Super Star!'),
(6, 'Nearly at the Top!'),
(7, 'You Got This!'),
(8, 'Good Work!'),
(9, 'Well Done!'),
(10, 'Have Hope, Try Again!'),
(11, 'Keep Practising!'),
(12, 'Stay Positive! One test at a time!'),
(13, 'Study Hard, you can Improve!');

-- --------------------------------------------------------

--
-- Table structure for table `star_message_mapping`
--

CREATE TABLE IF NOT EXISTS `star_message_mapping` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `star_message_id` int(11) NOT NULL,
  `star_system_id` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=41 ;

--
-- Dumping data for table `star_message_mapping`
--

INSERT INTO `star_message_mapping` (`id`, `star_message_id`, `star_system_id`) VALUES
(1, 1, 1),
(2, 1, 2),
(3, 1, 3),
(4, 2, 1),
(5, 2, 2),
(6, 2, 3),
(7, 3, 1),
(8, 3, 2),
(9, 3, 3),
(10, 4, 1),
(11, 4, 2),
(12, 4, 3),
(13, 5, 1),
(14, 5, 2),
(15, 5, 3),
(16, 6, 4),
(17, 6, 5),
(18, 7, 4),
(19, 7, 5),
(20, 8, 4),
(21, 8, 5),
(22, 9, 4),
(23, 9, 5),
(24, 10, 6),
(25, 10, 7),
(29, 11, 6),
(30, 11, 7),
(34, 12, 6),
(35, 12, 7),
(39, 13, 6),
(40, 13, 7);

-- --------------------------------------------------------

--
-- Table structure for table `star_prize_config`
--

CREATE TABLE IF NOT EXISTS `star_prize_config` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `curriculum_id` int(11) NOT NULL,
  `grade_id` int(11) NOT NULL,
  `subject_id` int(11) NOT NULL,
  `prize_type` varchar(20) NOT NULL,
  `price_start_date` date NOT NULL,
  `price_end_date` date NOT NULL,
  `status` varchar(25) NOT NULL,
  `created_date` datetime NOT NULL,
  `created_by` int(11) NOT NULL,
  `last_mod_by` int(11) NOT NULL,
  `last_mod_date` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=4 ;

--
-- Dumping data for table `star_prize_config`
--

INSERT INTO `star_prize_config` (`id`, `curriculum_id`, `grade_id`, `subject_id`, `prize_type`, `price_start_date`, `price_end_date`, `status`, `created_date`, `created_by`, `last_mod_by`, `last_mod_date`) VALUES
(1, 1, 1, 1, 'SUBJECT_PRIZE', '2017-01-01', '2017-01-31', 'ACTIVE', '0000-00-00 00:00:00', 0, 0, '2017-01-06 10:04:26'),
(2, 1, 1, 0, 'GRADE_PRIZE', '2017-01-01', '2017-01-31', 'ACTIVE', '0000-00-00 00:00:00', 0, 0, '2017-01-06 10:04:27'),
(3, 1, 1, 2, 'SUBJECT_PRIZE', '2017-01-01', '2017-01-26', 'ACTIVE', '0000-00-00 00:00:00', 0, 0, '0000-00-00 00:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `star_system`
--

CREATE TABLE IF NOT EXISTS `star_system` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `subject_test_star` int(11) NOT NULL,
  `module_test_star` int(11) NOT NULL,
  `min_marks` int(11) NOT NULL,
  `max_marks` int(11) NOT NULL,
  `time_bonus` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=8 ;

--
-- Dumping data for table `star_system`
--

INSERT INTO `star_system` (`id`, `subject_test_star`, `module_test_star`, `min_marks`, `max_marks`, `time_bonus`) VALUES
(1, 600, 300, 90, 100, 200),
(2, 500, 250, 80, 90, 180),
(3, 400, 200, 70, 80, 160),
(4, 300, 150, 60, 70, 140),
(5, 200, 100, 50, 60, 120),
(6, 50, 20, 40, 50, 100),
(7, 0, 0, 0, 40, 0);

-- --------------------------------------------------------

--
-- Table structure for table `students`
--

CREATE TABLE IF NOT EXISTS `students` (
  `reference` varchar(12) COLLATE utf8_unicode_ci NOT NULL,
  `std_id` int(6) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `full_name` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `gender` char(1) COLLATE utf8_unicode_ci DEFAULT NULL,
  `dob` varchar(20) COLLATE utf8_unicode_ci DEFAULT NULL,
  `nation` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `country` int(11) NOT NULL,
  `grade` int(3) DEFAULT NULL,
  `school` varchar(80) COLLATE utf8_unicode_ci DEFAULT NULL,
  `intake_month` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `school_type` varchar(20) COLLATE utf8_unicode_ci DEFAULT NULL,
  `found_through` varchar(200) COLLATE utf8_unicode_ci DEFAULT NULL,
  `package_id` int(11) DEFAULT NULL,
  `nick_name` varchar(15) COLLATE utf8_unicode_ci NOT NULL,
  `date_joined` date NOT NULL,
  PRIMARY KEY (`std_id`),
  UNIQUE KEY `id` (`user_id`),
  KEY `fk2_student` (`country`),
  KEY `fk3_student` (`package_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=10 ;

--
-- Dumping data for table `students`
--

INSERT INTO `students` (`reference`, `std_id`, `user_id`, `full_name`, `gender`, `dob`, `nation`, `country`, `grade`, `school`, `intake_month`, `school_type`, `found_through`, `package_id`, `nick_name`, `date_joined`) VALUES
('', 2, 1, '0758097664', NULL, NULL, NULL, 44, NULL, NULL, NULL, NULL, NULL, 8, 'Ruwan', '0000-00-00'),
('TWS17000005', 5, 5, 'Lakshika De Silva', NULL, NULL, NULL, 44, NULL, NULL, NULL, NULL, NULL, 1, 'Lakshika', '2017-01-27'),
('TWS17000006', 6, 6, 'ashikaMRF', NULL, NULL, NULL, 44, NULL, NULL, NULL, NULL, NULL, 8, '', '2017-01-27'),
('TWS17000007', 7, 7, 'Lakmi Muthumala', 'F', '1992-06-26', 'Sinhala', 44, 6, 'Sangamitta B.V.', 'january', 'national', 'google', 1, 'Lakmi', '2017-01-27'),
('TWS17000008', 8, 8, 'Nipuna', NULL, NULL, NULL, 44, NULL, NULL, NULL, NULL, NULL, 1, '', '2017-01-28'),
('TWS17000009', 9, 9, 'amila viduranga welikala', NULL, NULL, NULL, 44, NULL, NULL, NULL, NULL, NULL, 1, '', '2017-01-28');

-- --------------------------------------------------------

--
-- Table structure for table `student_mobile`
--

CREATE TABLE IF NOT EXISTS `student_mobile` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `mobile` varchar(9) NOT NULL,
  `status` int(11) NOT NULL DEFAULT '0',
  `std_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `std_id` (`std_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=9 ;

--
-- Dumping data for table `student_mobile`
--

INSERT INTO `student_mobile` (`id`, `mobile`, `status`, `std_id`) VALUES
(1, 'ruwan', 1, 2),
(4, '077907772', 1, 5),
(5, '077771234', 1, 6),
(6, '071143381', 1, 7),
(7, '716378515', 1, 8),
(8, '077437647', 1, 9);

-- --------------------------------------------------------

--
-- Table structure for table `student_package_price`
--

CREATE TABLE IF NOT EXISTS `student_package_price` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `student_id` int(11) NOT NULL,
  `package_price_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uc_student_package_price` (`student_id`,`package_price_id`),
  KEY `package_price_id` (`package_price_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=7 ;

--
-- Dumping data for table `student_package_price`
--

INSERT INTO `student_package_price` (`id`, `student_id`, `package_price_id`) VALUES
(1, 5, 1),
(3, 6, 2),
(4, 7, 3),
(5, 8, 1),
(6, 9, 1);

-- --------------------------------------------------------

--
-- Table structure for table `student_stars`
--

CREATE TABLE IF NOT EXISTS `student_stars` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `student_id` int(11) NOT NULL,
  `curriculum_id` int(11) NOT NULL,
  `grade_id` int(11) NOT NULL,
  `subject_id` int(11) NOT NULL,
  `module_id` int(11) NOT NULL,
  `stars` int(11) NOT NULL,
  `stars_add_type` varchar(30) NOT NULL,
  `star_add_date` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=9 ;

--
-- Dumping data for table `student_stars`
--

INSERT INTO `student_stars` (`id`, `student_id`, `curriculum_id`, `grade_id`, `subject_id`, `module_id`, `stars`, `stars_add_type`, `star_add_date`) VALUES
(1, 155, 1, 1, 1, 1, 50, 'SUBJECT_TEST', '2017-01-17 00:00:00'),
(2, 155, 1, 1, 1, 1, 855, 'MODULE_TEST', '2017-01-11 00:00:00'),
(3, 155, 1, 1, 2, 1, 25, 'MODULE_TEST', '2017-01-25 00:00:00'),
(4, 155, 1, 1, 2, 1, 70, 'MODULE_TEST', '2017-01-17 00:00:00'),
(5, 164, 1, 1, 1, 1, 50, 'SUBJECT_TEST', '2017-01-17 00:00:00'),
(6, 164, 1, 1, 1, 1, 855, 'MODULE_TEST', '2017-01-11 00:00:00'),
(7, 164, 1, 1, 2, 1, 25, 'MODULE_TEST', '2017-01-25 00:00:00'),
(8, 164, 1, 1, 2, 1, 70, 'MODULE_TEST', '2017-01-17 00:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `subject`
--

CREATE TABLE IF NOT EXISTS `subject` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `color` varchar(10) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=5 ;

--
-- Dumping data for table `subject`
--

INSERT INTO `subject` (`id`, `name`, `color`) VALUES
(1, 'Maths', ' #00aced'),
(2, 'Physics', '#ec4a49'),
(3, 'Chemistry', '#fbb712'),
(4, 'Biology', '#00ab8a');

-- --------------------------------------------------------

--
-- Table structure for table `subscription`
--

CREATE TABLE IF NOT EXISTS `subscription` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=16 ;

--
-- Dumping data for table `subscription`
--

INSERT INTO `subscription` (`id`, `name`) VALUES
(1, ' I no longer need to use TutorWizard for my studies'),
(2, 'Tutor Wizard does not have all the Features I want'),
(3, 'Contents not related to my present Curriculum'),
(4, ' Poor content resources'),
(5, 'Does not work correctly on my device'),
(6, ' Lack of Customer Service'),
(7, ' Lack of Technical Guidance'),
(8, ' Poor Online Tutoring Strategis'),
(9, 'I do not undersatand how to use it'),
(10, ' I can nott affrod this financially or I am trying to save money'),
(11, 'Tutor wizard is not right for my study plan'),
(13, 'No any reasons '),
(14, 'Mobitel M-Cash'),
(15, 'this is temp test');

-- --------------------------------------------------------

--
-- Table structure for table `system_user`
--

CREATE TABLE IF NOT EXISTS `system_user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `telephone` int(9) NOT NULL,
  `country_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id` (`user_id`),
  KEY `fk_system_user` (`user_id`),
  KEY `country_id` (`country_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `tags`
--

CREATE TABLE IF NOT EXISTS `tags` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=6 ;

--
-- Dumping data for table `tags`
--

INSERT INTO `tags` (`id`, `name`) VALUES
(1, 'maths'),
(2, 'integration'),
(3, 'Physics'),
(4, 'Chemistry'),
(5, 'circle');

-- --------------------------------------------------------

--
-- Table structure for table `temp_codes`
--

CREATE TABLE IF NOT EXISTS `temp_codes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `email` varchar(50) NOT NULL,
  `temp_code` varchar(200) NOT NULL,
  `recheck_code` varchar(200) NOT NULL,
  `created_date` datetime NOT NULL,
  `last_mod_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id` (`user_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=3 ;

--
-- Dumping data for table `temp_codes`
--

INSERT INTO `temp_codes` (`id`, `user_id`, `email`, `temp_code`, `recheck_code`, `created_date`, `last_mod_date`) VALUES
(1, 5, 'lakshikasur@gmail.com', '358654', 'efbf2663a0caf45c595e3d01be8747d6', '0000-00-00 00:00:00', '2017-01-27 05:30:53'),
(2, 8, 'nipunann0710@gmail.com', '751729', 'a51d8ef5fd29ab039c37c12a4efa93cf', '0000-00-00 00:00:00', '2017-01-28 04:24:14');

-- --------------------------------------------------------

--
-- Table structure for table `temp_package`
--

CREATE TABLE IF NOT EXISTS `temp_package` (
  `id` int(4) NOT NULL AUTO_INCREMENT,
  `signup_token` varchar(200) NOT NULL,
  `package_id` int(4) NOT NULL,
  `payment_method` varchar(20) NOT NULL,
  `student_id` int(4) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=6 ;

--
-- Dumping data for table `temp_package`
--

INSERT INTO `temp_package` (`id`, `signup_token`, `package_id`, `payment_method`, `student_id`) VALUES
(1, '2d6cc4b2d139a53512fb8cbb3086ae2e4935', 2, 'Visa', 5),
(2, '2d6cc4b2d139a53512fb8cbb3086ae2e4935', 2, 'Visa', 5),
(3, '2d6cc4b2d139a53512fb8cbb3086ae2e4935', 2, 'Visa', 5),
(4, '2d6cc4b2d139a53512fb8cbb3086ae2e4935', 2, 'Visa', 1),
(5, '2d6cc4b2d139a53512fb8cbb3086ae2e4935', 2, 'Visa', 1);

-- --------------------------------------------------------

--
-- Table structure for table `temp_students`
--

CREATE TABLE IF NOT EXISTS `temp_students` (
  `std_id` int(10) NOT NULL AUTO_INCREMENT,
  `full_name` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `country` int(11) NOT NULL,
  `email` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `phone` char(9) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`std_id`),
  KEY `fk2_temp_students` (`country`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=6 ;

--
-- Dumping data for table `temp_students`
--

INSERT INTO `temp_students` (`std_id`, `full_name`, `country`, `email`, `phone`) VALUES
(1, 'ckjjbszdfkjd', 139, 'a@gmail.com', '075809766'),
(2, 'hhhh', 1, 'aas@gmail.com', '3333333'),
(3, 'Ruwan', 222, 'lkfnhdsflks@dfkgh.vi', '075809766'),
(4, 'cvghfdg', 14, 'dsfdkk@dkf.v', '075809766'),
(5, 'cvghfdg', 14, 'dsfdkk@dkf.vh', '075809766');

-- --------------------------------------------------------

--
-- Table structure for table `temp_users`
--

CREATE TABLE IF NOT EXISTS `temp_users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `token` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=38 ;

--
-- Dumping data for table `temp_users`
--

INSERT INTO `temp_users` (`id`, `user_id`, `token`) VALUES
(1, 2, '66082a5af7e472e4b2d512dfaa089880'),
(2, 2, '58db298ee7673978e7261a8ed53c0c8e'),
(3, 5, '894841cd01f3304e50502889c7a709dc4762'),
(4, 4, 'cad25ea64aed22fd7e94c08e87a611aa8510'),
(5, 4, 'test_token'),
(8, 9, 'dd5eb5d15623ea49fd1b19c8416d194c6899'),
(13, 3, 'a198ac9862187538fc01b66340cebaf3'),
(17, 3, 'e0146951ae51692a86c61825b49bd449'),
(18, 8, 'ab4920e67aa516b0522e7949cab2a1f89208'),
(19, 7, '172e2dd55944c2039d8f7588ff34d45e9659'),
(21, 6, 'b587977e9052ad83fea358297f3fe8c86848'),
(25, 3, 'd681c56d1a1259f7c101703394973c20'),
(26, 3, 'a3c74dff0c0de4392366dda704d775dc'),
(30, 3, '7b48f9a451ede2ed2f887d7bbb67cbd5'),
(32, 3, '1ac97f7fec5c0fa2daa8dd06bd1779fc'),
(35, 3, 'c5c64096b7e33405f50b8700f57a76d1');

-- --------------------------------------------------------

--
-- Table structure for table `transaction`
--

CREATE TABLE IF NOT EXISTS `transaction` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `invoiceNo` varchar(15) NOT NULL,
  `date` date NOT NULL,
  `expire_date` date NOT NULL,
  `paid_amount` double NOT NULL,
  `balance` double NOT NULL,
  `student_id` int(11) NOT NULL,
  `payment_method` varchar(25) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `payment_id` (`student_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=3 ;

--
-- Dumping data for table `transaction`
--

INSERT INTO `transaction` (`id`, `invoiceNo`, `date`, `expire_date`, `paid_amount`, `balance`, `student_id`, `payment_method`) VALUES
(2, 'TW001', '2017-01-27', '2017-06-30', 1000, 500, 7, 'visa');

-- --------------------------------------------------------

--
-- Table structure for table `tutor`
--

CREATE TABLE IF NOT EXISTS `tutor` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `telephone` int(9) NOT NULL,
  `country_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_tutor` (`user_id`),
  KEY `country_id` (`country_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=6 ;

--
-- Dumping data for table `tutor`
--

INSERT INTO `tutor` (`id`, `user_id`, `name`, `telephone`, `country_id`) VALUES
(1, 4, 'Lakmi Muthumala', 711433815, 44),
(2, 10, 'Tutor_admin(Angular)', 113120099, 44),
(3, 15, 'Test User', 123456789, 44),
(4, 16, 'Test User', 123456789, 44),
(5, 17, 'Test User', 123456789, 44);

-- --------------------------------------------------------

--
-- Table structure for table `tutor_assign`
--

CREATE TABLE IF NOT EXISTS `tutor_assign` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tutor_id` int(11) NOT NULL,
  `package_subject_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uc_tutor_assign` (`package_subject_id`,`tutor_id`),
  KEY `package_subject_id` (`package_subject_id`),
  KEY `tutor_id` (`tutor_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=6 ;

--
-- Dumping data for table `tutor_assign`
--

INSERT INTO `tutor_assign` (`id`, `tutor_id`, `package_subject_id`) VALUES
(1, 1, 1),
(2, 2, 1),
(3, 3, 1),
(5, 5, 1),
(4, 4, 15);

-- --------------------------------------------------------

--
-- Table structure for table `tutor_help_message`
--

CREATE TABLE IF NOT EXISTS `tutor_help_message` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sender_id` int(11) NOT NULL,
  `subject_id` int(11) NOT NULL,
  `module_id` int(11) NOT NULL,
  `unit_id` int(11) NOT NULL,
  `title` varchar(50) NOT NULL,
  `content` text NOT NULL,
  `date_time` datetime NOT NULL,
  `status` int(11) NOT NULL DEFAULT '0',
  `delete_msg` int(11) NOT NULL DEFAULT '0',
  `reply_count` int(11) NOT NULL DEFAULT '0',
  `helper_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `sender_id` (`sender_id`),
  KEY `helper_id` (`helper_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `tutor_help_message_attchment`
--

CREATE TABLE IF NOT EXISTS `tutor_help_message_attchment` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `message_id` int(11) NOT NULL,
  `file_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uc_tutor_help_message_attchment` (`message_id`,`file_id`),
  KEY `message_id` (`message_id`,`file_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `tutor_help_reply`
--

CREATE TABLE IF NOT EXISTS `tutor_help_reply` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `content` text NOT NULL,
  `status` int(11) NOT NULL DEFAULT '0',
  `replier_id` int(11) NOT NULL,
  `message_id` int(11) NOT NULL,
  `msg_delete` int(11) NOT NULL DEFAULT '0',
  `date_time` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `replier_id` (`replier_id`),
  KEY `message_id` (`message_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `tutor_help_reply_attchment`
--

CREATE TABLE IF NOT EXISTS `tutor_help_reply_attchment` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `reply_id` int(11) NOT NULL,
  `file_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uc_tutor_help_reply_attchment` (`reply_id`,`file_id`),
  KEY `reply_id` (`reply_id`,`file_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `unit`
--

CREATE TABLE IF NOT EXISTS `unit` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(300) NOT NULL,
  `module_id` int(11) NOT NULL,
  `description` text,
  PRIMARY KEY (`id`),
  KEY `fk_unit` (`module_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=5 ;

--
-- Dumping data for table `unit`
--

INSERT INTO `unit` (`id`, `name`, `module_id`, `description`) VALUES
(1, 'Amimal cell ', 1, 'The cell is the basic unit of life. All organisms are made up of cells (or in some cases, a single cell). Most cells are very small; most are invisible without using a microscope. Cells are covered by a cell membrane and come in many different shapes. The contents of a cell are called the protoplasm.'),
(2, 'bone cell', 2, 'Jenrev TorreNia Profiles | Facebook\r\nhttps://www.facebook.com/public/Jenrev-TorreNia\r\nView the profiles of people named Jenrev TorreNia. Join Facebook to connect with Jenrev TorreNia and others you may know. Facebook gives people the ...\r\nDanilo Torrenia Profiles | Facebook\r\nhttps://www.facebook.com/public/Danilo-Torrenia\r\nView the profiles of people named Danilo Torrenia. Join Facebook to connect with Danilo Torrenia and others you may know. Facebook gives people the power.'),
(3, 'unit3', 1, 'Jenrev TorreNia Profiles | Facebook\r\nhttps://www.facebook.com/public/Jenrev-TorreNia\r\nView the profiles of people named Jenrev TorreNia. Join Facebook to connect with Jenrev TorreNia and others you may know. Facebook gives people the ...\r\nDanilo Torrenia Profiles | Facebook\r\nhttps://www.facebook.com/public/Danilo-Torrenia\r\nView the profiles of people named Danilo Torrenia. Join Facebook to connect with Danilo Torrenia and others you may know. Facebook gives people the power.'),
(4, 'unit 4', 1, 'Jenrev TorreNia Profiles | Facebook\r\nhttps://www.facebook.com/public/Jenrev-TorreNia\r\nView the profiles of people named Jenrev TorreNia. Join Facebook to connect with Jenrev TorreNia and others you may know. Facebook gives people the ...\r\nDanilo Torrenia Profiles | Facebook\r\nhttps://www.facebook.com/public/Danilo-Torrenia\r\nView the profiles of people named Danilo Torrenia. Join Facebook to connect with Danilo Torrenia and others you may know. Facebook gives people the power.');

-- --------------------------------------------------------

--
-- Table structure for table `unit_resources`
--

CREATE TABLE IF NOT EXISTS `unit_resources` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `unit_id` int(11) NOT NULL,
  `resource_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uc_unit_resources` (`unit_id`,`resource_id`),
  KEY `fk2_unit_resources` (`resource_id`),
  KEY `fk_unit_resources` (`unit_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=9 ;

--
-- Dumping data for table `unit_resources`
--

INSERT INTO `unit_resources` (`id`, `unit_id`, `resource_id`) VALUES
(1, 2, 1),
(2, 2, 2),
(3, 2, 3),
(4, 2, 4),
(5, 2, 5),
(6, 2, 6),
(7, 2, 7),
(8, 2, 8);

-- --------------------------------------------------------

--
-- Table structure for table `unsubscription`
--

CREATE TABLE IF NOT EXISTS `unsubscription` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `subcription_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `subcription` (`subcription_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE IF NOT EXISTS `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `type` int(1) NOT NULL,
  `status` int(1) NOT NULL DEFAULT '0',
  `file_id` int(11) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `comp_status` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`email`),
  KEY `fk_users` (`file_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=27 ;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `email`, `password`, `type`, `status`, `file_id`, `created_at`, `updated_at`, `comp_status`) VALUES
(1, 'ruwan@gmail.com', '827ccb0eea8a706c4c34a16891f84e7b', 2, 1, NULL, '2016-12-15 09:20:25', '2016-12-15 09:20:25', 0),
(3, 'lakshithaf@gmail.com', '928685e214fa387530cc8e14d09a1858', 1, 1, NULL, NULL, NULL, 0),
(4, 'lakmishehani@gmail.com', 'c1b44d13345b9706b3887204f2636954', 3, 1, NULL, NULL, NULL, 0),
(5, 'lakshikasur@gmail.com', '14fd072122dc8325ed61e2cc8efe6e67twWiZard', 2, 1, NULL, '2017-01-26 23:58:49', '2017-01-26 23:58:49', 0),
(6, 'ashikamrf71@gmail.com', '14fd072122dc8325ed61e2cc8efe6e67twWiZard', 2, 1, NULL, '2017-01-27 01:53:20', '2017-01-27 01:53:20', 0),
(7, 'lakmi@tutorwizard.lk', 'f726dde8852a214f1d4c371c89159bb7twWiZard', 2, 1, 9, '2017-01-27 02:54:04', '2017-01-27 02:54:04', 0),
(8, 'nipunann0710@gmail.com', '14fd072122dc8325ed61e2cc8efe6e67twWiZard', 2, 1, NULL, '2017-01-27 22:46:58', '2017-01-27 22:46:58', 0),
(9, 'amilavidurangawelikala@gmail.com', '14fd072122dc8325ed61e2cc8efe6e67twWiZard', 2, 1, NULL, '2017-01-27 23:13:59', '2017-01-27 23:13:59', 0),
(10, 'niranjan29nka@gmail.com', '827ccb0eea8a706c4c34a16891f84e7b', 3, 1, NULL, NULL, NULL, 0),
(11, 'lak@gmail.com', '827ccb0eea8a706c4c34a16891f84e7b', 1, 1, NULL, NULL, NULL, 0),
(12, 'lak1@gmail.com', '827ccb0eea8a706c4c34a16891f84e7b', 1, 1, NULL, NULL, NULL, 0),
(13, 'lak7767@gmail.com', '827ccb0eea8a706c4c34a16891f84e7b', 1, 1, NULL, NULL, NULL, 0),
(14, 'bogoniranjankumar@gmail.com', '827ccb0eea8a706c4c34a16891f84e7b', 1, 1, NULL, NULL, NULL, 0),
(15, 'lakshitha55@gmail.com', '827ccb0eea8a706c4c34a16891f84e7b', 3, 1, NULL, NULL, NULL, 0),
(16, 'lakshitha555@gmail.com', '827ccb0eea8a706c4c34a16891f84e7b', 3, 1, NULL, NULL, NULL, 0),
(17, 'lakshitha5554@gmail.com', '827ccb0eea8a706c4c34a16891f84e7b', 3, 1, NULL, NULL, NULL, 0),
(18, 'niranjan299nka@gmail.com', '827ccb0eea8a706c4c34a16891f84e7b', 1, 1, NULL, NULL, NULL, 0),
(19, 'lak77677@gmail.com', '827ccb0eea8a706c4c34a16891f84e7b', 1, 1, NULL, NULL, NULL, 0),
(20, 'lak776777@gmail.com', '827ccb0eea8a706c4c34a16891f84e7b', 1, 1, NULL, NULL, NULL, 0),
(21, 'lakshitha33@gmail.com', '827ccb0eea8a706c4c34a16891f84e7b', 1, 1, NULL, NULL, NULL, 0),
(22, 'lak7765@gmail.com', '827ccb0eea8a706c4c34a16891f84e7b', 1, 1, NULL, NULL, NULL, 0),
(24, 'lakshithaf1111@gmail.com', '827ccb0eea8a706c4c34a16891f84e7b', 1, 1, NULL, NULL, NULL, 0),
(25, 'lakth@gmail.com', '827ccb0eea8a706c4c34a16891f84e7b', 1, 1, NULL, NULL, NULL, 0);

-- --------------------------------------------------------

--
-- Table structure for table `user_group`
--

CREATE TABLE IF NOT EXISTS `user_group` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `group_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `group_id` (`group_id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `user_helpers`
--

CREATE TABLE IF NOT EXISTS `user_helpers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `helper_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`,`helper_id`),
  KEY `helper_id` (`helper_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=6 ;

--
-- Dumping data for table `user_helpers`
--

INSERT INTO `user_helpers` (`id`, `user_id`, `helper_id`) VALUES
(1, 4, 1),
(2, 10, 1),
(3, 15, 1),
(4, 16, 1),
(5, 17, 1);

-- --------------------------------------------------------

--
-- Table structure for table `user_promotion`
--

CREATE TABLE IF NOT EXISTS `user_promotion` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `student_id` int(11) NOT NULL,
  `promotion_id` int(11) NOT NULL,
  `expired` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `student_id` (`student_id`),
  KEY `code` (`promotion_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=3 ;

--
-- Dumping data for table `user_promotion`
--

INSERT INTO `user_promotion` (`id`, `student_id`, `promotion_id`, `expired`) VALUES
(2, 6, 1, 0);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `admin`
--
ALTER TABLE `admin`
  ADD CONSTRAINT `fk2_admin` FOREIGN KEY (`country_id`) REFERENCES `country` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_admin` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `answer`
--
ALTER TABLE `answer`
  ADD CONSTRAINT `fk1_answer` FOREIGN KEY (`question_id`) REFERENCES `question` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk2_answer` FOREIGN KEY (`question_type_id`) REFERENCES `question_type` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `feed_links`
--
ALTER TABLE `feed_links`
  ADD CONSTRAINT `fk2_notification_links` FOREIGN KEY (`notification_id`) REFERENCES `feed` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `feed_user`
--
ALTER TABLE `feed_user`
  ADD CONSTRAINT `fk2_notification_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_notification_user` FOREIGN KEY (`notification_id`) REFERENCES `feed` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `folder`
--
ALTER TABLE `folder`
  ADD CONSTRAINT `fk2_folder` FOREIGN KEY (`container_id`) REFERENCES `folder` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_folder` FOREIGN KEY (`std_id`) REFERENCES `students` (`std_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `folder_resource`
--
ALTER TABLE `folder_resource`
  ADD CONSTRAINT `fk2_folder_resource` FOREIGN KEY (`folder_id`) REFERENCES `folder` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_folder_resource` FOREIGN KEY (`resource_id`) REFERENCES `resources` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `glossary`
--
ALTER TABLE `glossary`
  ADD CONSTRAINT `fk_glossary` FOREIGN KEY (`unit_id`) REFERENCES `unit` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `interest`
--
ALTER TABLE `interest`
  ADD CONSTRAINT `fk_interest` FOREIGN KEY (`std_id`) REFERENCES `students` (`std_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `message`
--
ALTER TABLE `message`
  ADD CONSTRAINT `fk2_message` FOREIGN KEY (`helper_id`) REFERENCES `helpers` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_message` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `message_attachment`
--
ALTER TABLE `message_attachment`
  ADD CONSTRAINT `fk2_message_attachment` FOREIGN KEY (`file_id`) REFERENCES `file` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_message_attachment` FOREIGN KEY (`message_id`) REFERENCES `message` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `notes`
--
ALTER TABLE `notes`
  ADD CONSTRAINT `fk2_notes` FOREIGN KEY (`student_id`) REFERENCES `students` (`std_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_notes` FOREIGN KEY (`folder_id`) REFERENCES `folder` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `package`
--
ALTER TABLE `package`
  ADD CONSTRAINT `fk2_package` FOREIGN KEY (`curriculum_id`) REFERENCES `curriculum` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_package` FOREIGN KEY (`grade_id`) REFERENCES `grade` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `package_price`
--
ALTER TABLE `package_price`
  ADD CONSTRAINT `fk2_package_price` FOREIGN KEY (`package_id`) REFERENCES `package` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_package_price` FOREIGN KEY (`package_type_id`) REFERENCES `package_type` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `package_subject`
--
ALTER TABLE `package_subject`
  ADD CONSTRAINT `fk2_package_subject` FOREIGN KEY (`subject_id`) REFERENCES `subject` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_package_subject` FOREIGN KEY (`package_id`) REFERENCES `package` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `package_subject_module`
--
ALTER TABLE `package_subject_module`
  ADD CONSTRAINT `fk2_package_subject_module` FOREIGN KEY (`package_subject_id`) REFERENCES `package_subject` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_package_subject_module` FOREIGN KEY (`module_id`) REFERENCES `module` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `payment`
--
ALTER TABLE `payment`
  ADD CONSTRAINT `fk2_payment` FOREIGN KEY (`std_id`) REFERENCES `students` (`std_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_payment` FOREIGN KEY (`payment_type_id`) REFERENCES `payment_type` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `planner`
--
ALTER TABLE `planner`
  ADD CONSTRAINT `fk2_planner` FOREIGN KEY (`repeat_type_id`) REFERENCES `repeat_type` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_planner` FOREIGN KEY (`std_id`) REFERENCES `students` (`std_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `planner_notes`
--
ALTER TABLE `planner_notes`
  ADD CONSTRAINT `fk_planner_notes` FOREIGN KEY (`planner_id`) REFERENCES `planner` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `planner_reminder`
--
ALTER TABLE `planner_reminder`
  ADD CONSTRAINT `fk_planner_reminder` FOREIGN KEY (`planner_id`) REFERENCES `planner` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `question_log`
--
ALTER TABLE `question_log`
  ADD CONSTRAINT `fk2_question_log` FOREIGN KEY (`question_id`) REFERENCES `question` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk3_question_log` FOREIGN KEY (`answer_id`) REFERENCES `answer` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_question_log` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `quiz`
--
ALTER TABLE `quiz`
  ADD CONSTRAINT `fk_quiz` FOREIGN KEY (`student_id`) REFERENCES `students` (`std_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `quiz_question`
--
ALTER TABLE `quiz_question`
  ADD CONSTRAINT `fk2_quiz_question` FOREIGN KEY (`question_id`) REFERENCES `question` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_quiz_question` FOREIGN KEY (`quiz_id`) REFERENCES `quiz` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `reply`
--
ALTER TABLE `reply`
  ADD CONSTRAINT `fk2_reply` FOREIGN KEY (`message_id`) REFERENCES `message` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_reply` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `reply_attachment`
--
ALTER TABLE `reply_attachment`
  ADD CONSTRAINT `fk2_reply_attachment` FOREIGN KEY (`file_id`) REFERENCES `file` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_reply_attachment` FOREIGN KEY (`reply_id`) REFERENCES `reply` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `report_question`
--
ALTER TABLE `report_question`
  ADD CONSTRAINT `fk2_report_question` FOREIGN KEY (`question_id`) REFERENCES `question` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_report_question` FOREIGN KEY (`student_id`) REFERENCES `students` (`std_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `resources`
--
ALTER TABLE `resources`
  ADD CONSTRAINT `fk2_resources` FOREIGN KEY (`file_id`) REFERENCES `file` (`id`),
  ADD CONSTRAINT `fk_resources` FOREIGN KEY (`resource_type_id`) REFERENCES `resource_types` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `resource_tags`
--
ALTER TABLE `resource_tags`
  ADD CONSTRAINT `fk2_resource_tags` FOREIGN KEY (`tag_id`) REFERENCES `tags` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_resource_tags` FOREIGN KEY (`resource_id`) REFERENCES `resources` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `review_email`
--
ALTER TABLE `review_email`
  ADD CONSTRAINT `fk_review_email` FOREIGN KEY (`std_id`) REFERENCES `students` (`std_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `snap`
--
ALTER TABLE `snap`
  ADD CONSTRAINT `fk2_snap` FOREIGN KEY (`student_id`) REFERENCES `students` (`std_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_snap` FOREIGN KEY (`file_id`) REFERENCES `file` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `students`
--
ALTER TABLE `students`
  ADD CONSTRAINT `fk2_student` FOREIGN KEY (`country`) REFERENCES `country` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk3_student` FOREIGN KEY (`package_id`) REFERENCES `package` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_student` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `student_mobile`
--
ALTER TABLE `student_mobile`
  ADD CONSTRAINT `fk_student_mobile` FOREIGN KEY (`std_id`) REFERENCES `students` (`std_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `student_package_price`
--
ALTER TABLE `student_package_price`
  ADD CONSTRAINT `fk2_student_package_price` FOREIGN KEY (`package_price_id`) REFERENCES `package_price` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_student_package_price` FOREIGN KEY (`student_id`) REFERENCES `students` (`std_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `system_user`
--
ALTER TABLE `system_user`
  ADD CONSTRAINT `fk2_system_user` FOREIGN KEY (`country_id`) REFERENCES `country` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_system_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `temp_codes`
--
ALTER TABLE `temp_codes`
  ADD CONSTRAINT `fk_temp_codes` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `temp_students`
--
ALTER TABLE `temp_students`
  ADD CONSTRAINT `fk_temp_student` FOREIGN KEY (`country`) REFERENCES `country` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `transaction`
--
ALTER TABLE `transaction`
  ADD CONSTRAINT `fk_transaction` FOREIGN KEY (`student_id`) REFERENCES `students` (`std_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `tutor`
--
ALTER TABLE `tutor`
  ADD CONSTRAINT `fk2_tutor` FOREIGN KEY (`country_id`) REFERENCES `country` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_tutor` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `tutor_assign`
--
ALTER TABLE `tutor_assign`
  ADD CONSTRAINT `fk2_tutor_assign` FOREIGN KEY (`package_subject_id`) REFERENCES `package_subject` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_tutor_assign` FOREIGN KEY (`tutor_id`) REFERENCES `tutor` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `tutor_help_message`
--
ALTER TABLE `tutor_help_message`
  ADD CONSTRAINT `fk2_tutor_help_message` FOREIGN KEY (`helper_id`) REFERENCES `helpers` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_tutor_help_message` FOREIGN KEY (`sender_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `tutor_help_reply`
--
ALTER TABLE `tutor_help_reply`
  ADD CONSTRAINT `fk2_tutor_help_reply` FOREIGN KEY (`message_id`) REFERENCES `tutor_help_message` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_tutor_help_reply` FOREIGN KEY (`replier_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `unit`
--
ALTER TABLE `unit`
  ADD CONSTRAINT `fk_unit` FOREIGN KEY (`module_id`) REFERENCES `module` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `unit_resources`
--
ALTER TABLE `unit_resources`
  ADD CONSTRAINT `fk2_unit_resource` FOREIGN KEY (`resource_id`) REFERENCES `resources` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_unit_resource` FOREIGN KEY (`unit_id`) REFERENCES `unit` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `unsubscription`
--
ALTER TABLE `unsubscription`
  ADD CONSTRAINT `fk2_unsubcription` FOREIGN KEY (`subcription_id`) REFERENCES `subscription` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_unsubcription` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `fk_users` FOREIGN KEY (`file_id`) REFERENCES `file` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `user_group`
--
ALTER TABLE `user_group`
  ADD CONSTRAINT `fk2_user_group` FOREIGN KEY (`group_id`) REFERENCES `group` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_user_group` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `user_helpers`
--
ALTER TABLE `user_helpers`
  ADD CONSTRAINT `fk2_user_helpers` FOREIGN KEY (`helper_id`) REFERENCES `helpers` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_user_helpers` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `user_promotion`
--
ALTER TABLE `user_promotion`
  ADD CONSTRAINT `fk2_user_promotion` FOREIGN KEY (`promotion_id`) REFERENCES `promotion` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_user_promotion` FOREIGN KEY (`student_id`) REFERENCES `students` (`std_id`) ON DELETE CASCADE ON UPDATE CASCADE;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
