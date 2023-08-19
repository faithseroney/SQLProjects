
--create the members table
use sports_booking
CREATE TABLE members (
    id NVARCHAR(255) PRIMARY KEY,
    password NVARCHAR(255) NOT NULL,
    email NVARCHAR(255) NOT NULL,
    member_since DATETIME NOT NULL DEFAULT GETDATE(),
    payment_due DECIMAL(10, 2) NOT NULL DEFAULT 0.00
);

--create the bookings table
use sports_booking
CREATE TABLE Bookings (
    id INT PRIMARY KEY identity(1,1),
    room_id VARCHAR(20) NOT NULL,
    booked_date DATE NOT NULL,
    booked_time TIME NOT NULL,
    member_id VARCHAR(255) NOT NULL,
    datetime_of_booking DATETIME NOT NULL DEFAULT GETDATE(),
    payment_status VARCHAR(50) NOT NULL DEFAULT 'Unpaid',
    UNIQUE (room_id, booked_date, booked_time)
);

ALTER TABLE Bookings
ALTER COLUMN member_id NVARCHAR(255);

--Create the rooms table
CREATE TABLE rooms (
    id NVARCHAR(255) PRIMARY KEY,
    room_type NVARCHAR(255) NOT NULL,
    price DECIMAL(10, 2) NOT NULL
);

CREATE TABLE rooms (
    id NVARCHAR(255) PRIMARY KEY,
    room_type VARCHAR(20) NOT NULL,
    price DECIMAL(10, 2) NOT NULL
);

--change the room_type data type
ALTER TABLE rooms
ALTER COLUMN room_type NVARCHAR(255)

--while creating a relationship between the rooms and booking tables, the room_id col seems to have a 
--constraint
--we first drop the constraint
ALTER TABLE Bookings
DROP CONSTRAINT UQ__Bookings__916B17DDDB2B8747;

--then change the data type of the room_id column
ALTER TABLE Bookings
ALTER COLUMN room_id NVARCHAR(255);

--then recreate the constraint
ALTER TABLE Bookings
ADD CONSTRAINT UQ__Bookings__916B17DDDB2B8747 UNIQUE (room_id, booked_date, booked_time);

--create a foreign key f1 between the bookings and members table
ALTER TABLE BOOKINGS
ADD CONSTRAINT fk1 FOREIGN KEY (member_id) REFERENCES members(id)
ON UPDATE CASCADE
ON DELETE CASCADE

--create a foreign key f1 between the bookings and rooms table
ALTER TABLE BOOKINGS
ADD CONSTRAINT fk2 FOREIGN KEY (room_id) REFERENCES rooms(id)
ON UPDATE CASCADE
ON DELETE CASCADE

--inserting data into the tables:
--members table:
use sports_booking
INSERT INTO [dbo].[members] (id, password, email, member_since, payment_due) 
VALUES
('afeil', 'feil1988<3', 'Abdul.Feil@hotmail.com', '2017-04-15 12:10:13', 0),
('amely_18', 'loseweightin18', 'Amely.Bauch91@yahoo.com', '2018-02-06 16:48:43', 0),
('bbahringer', 'iambeau17', 'Beaulah_Bahringer@yahoo.com', '2017-12-28 05:36:50', 0),
('little31', 'whocares31', 'Anthony_Little31@gmail.com', '2017-06-01 21:12:11', 10),
('macejkovic73', 'jadajeda12', 'Jada.Macejkovic73@gmail.com', '2017-05-30 17:30:22', 0),
('marvin1', 'if0909mar', 'Marvin_Schulist@gmail.com', '2017-09-09 02:30:49', 10),
('nitzsche77', 'bret77@#', 'Bret_Nitzsche77@gmail.com', '2018-01-09 17:36:49', 0),
('noah51', '18Oct1976#51', 'Noah51@gmail.com', '2017-12-16 22:59:46', 0),
('oreillys', 'reallycool#1', 'Martine_OReilly@yahoo.com', '2017-10-12 05:39:20', 0),
('wyattgreat', 'wyatt111', 'Wyatt_Wisozk2@gmail.com', '2017-07-18 16:28:35', 0);

--rooms table
use sports_booking
INSERT INTO rooms (id, room_type, price) 
VALUES
('AR', 'Archery Range', 120),
('B1', 'Badminton Court', 8),
('B2', 'Badminton Court', 8),
('MPF1', 'Multi Purpose Field', 50),
('MPF2', 'Multi Purpose Field', 60),
('T1', 'Tennis Court', 10),
('T2', 'Tennis Court', 10);--bookings tableuse sports_booking
INSERT INTO bookings (room_id, booked_date, booked_time, member_id, 
datetime_of_booking, payment_status) 
VALUES
('AR', '2017-12-26', '13:00:00', 'oreillys', '2017-12-20 20:31:27', 'Paid'),
('MPF1', '2017-12-30', '17:00:00', 'noah51', '2017-12-22 05:22:10', 'Paid'),
('T2', '2017-12-31', '16:00:00', 'macejkovic73', '2017-12-28 18:14:23', 'Paid'),
('T1', '2018-03-05', '08:00:00', 'little31', '2018-02-22 20:19:17', 'Unpaid'),
('MPF2', '2018-03-02', '11:00:00', 'marvin1', '2018-03-01 16:13:45', 'Paid'),
('B1', '2018-03-28', '16:00:00', 'marvin1', '2018-03-23 22:46:36', 'Paid'),
('B1', '2018-04-15', '14:00:00', 'macejkovic73', '2018-04-12 22:23:20', 'Cancelled'),
('T2', '2018-04-23', '13:00:00', 'macejkovic73', '2018-04-19 10:49:00', 'Cancelled'),
('T1', '2018-05-25', '10:00:00', 'marvin1', '2018-05-21 11:20:46', 'Unpaid'),
('B2', '2018-06-12', '15:00:00', 'bbahringer', '2018-05-30 14:40:23', 'Paid');
--create view to know the room name, id and price
CREATE VIEW BookingDetails
AS
SELECT 
	b.room_id,
	b.booked_date,
	b.booked_time,
	b.id,
	b.payment_status,
	b.datetime_of_booking,
	r.room_type,
	r.price
FROM Bookings b
JOIN rooms r
ON b.room_id = r.id

--create stored procedures for the tables
--sproc to insert a new member into the members table
CREATE PROCEDURE insert_new_member
	@p_id NVARCHAR(255),
	@p_password NVARCHAR(255),
	@p_email NVARCHAR(255)
AS
BEGIN
	INSERT INTO [dbo].[members](id, password, email)
	VALUES (@p_id, @p_password, @p_email)
END


--SPROC to delete member
CREATE PROCEDURE delete_member
	@p_id NVARCHAR(255)
AS
BEGIN
	DELETE members WHERE id = @p_id
END

--sproc to update member password and update member email
CREATE PROCEDURE update_member_password
	@p_id NVARCHAR(255),
	@p_password NVARCHAR(255)
AS
BEGIN
	UPDATE members SET password = @p_password WHERE id=@p_id
END


CREATE PROCEDURE update_member_email
	@p_id NVARCHAR(255),
	@p_email NVARCHAR(255)
AS
BEGIN
	UPDATE members SET email = @p_email WHERE id = @p_id
END

--sproc to create new bookings
CREATE PROCEDURE make_booking
    @p_room_id VARCHAR(20),
    @p_booked_date DATE,
    @p_booked_time TIME,
    @p_member_id NVARCHAR(255)
AS
BEGIN
    DECLARE @v_price DECIMAL(10, 2);
    DECLARE @v_payment_due DECIMAL(10, 2);

    -- Get the price of the room
    SELECT @v_price = price FROM rooms WHERE id = @p_room_id;

    -- Insert the booking into the bookings table
    INSERT INTO bookings (room_id, booked_date, booked_time, member_id)
    VALUES (@p_room_id, @p_booked_date, @p_booked_time, @p_member_id);

    -- Update payment_due in members table
    SELECT @v_payment_due = payment_due FROM members WHERE id = @p_member_id;
    UPDATE members
    SET payment_due = @v_payment_due + @v_price
    WHERE id = @p_member_id;
END;

--update payment sproc
CREATE PROCEDURE update_payment
    @p_id INT
AS
BEGIN
    DECLARE @v_member_id NVARCHAR(255);
    DECLARE @v_payment_due DECIMAL(10, 2);
    DECLARE @v_price DECIMAL(10, 2);

    -- Update payment_status in bookings table
    UPDATE bookings
    SET payment_status = 'Paid'
    WHERE id = @p_id;

    -- Get member_id and price from member_bookings view
    SELECT @v_member_id = member_id, @v_price = price
    FROM member_bookings
    WHERE id = @p_id;

    -- Get current payment_due from members table
    SELECT @v_payment_due = payment_due
    FROM members
    WHERE id = @v_member_id;

    -- Update payment_due in members table
    UPDATE members
    SET payment_due = @v_payment_due - @v_price
    WHERE id = @v_member_id;
END;

--view_bookings procedure
CREATE PROCEDURE view_bookings
	@p_id int
AS
BEGIN
	SELECT *
	from member_booking
	WHERE id = @p_id 
END

--search room  proc
CREATE PROCEDURE search_room
    @p_room_type VARCHAR(50),
    @p_booked_date DATE,
    @p_booked_time TIME
AS
BEGIN
    SELECT room_id
    FROM rooms
    WHERE room_id NOT IN (
        SELECT room_id
        FROM bookings
        WHERE booked_date = @p_booked_date
          AND booked_time = @p_booked_time
          AND payment_status != 'Cancelled'
    )
    AND room_type = @p_room_type;
END;

--search room procedure
CREATE PROCEDURE search_room
	@p_booking_id NVARCHAR(255),
	@p_message VARCHAR(255) OUT
AS 
BEGIN
	--Declare variables
	DECLARE @v_cancellation INT;
	DECLARE @v_member_id NVARCHAR(255);
	DECLARE @v_payment_status DECIMAL(10,2);
	DECLARE @v_booked_date DATE;
	DECLARE @v_price DECIMAL(10,2);
	DECLARE @v_payment_due DECIMAL(10,2);

	--set v_cancellation to 0
	SET @v_cancellation = 0;

	--select from member bookins view
	SELECT 
	@v_member_id = member_id, 
	@v_booked_date = booked_date, 
	@v_price = price,
	@v_payment_status = payment_status 
	from member_bookings
	where id = @p_booking_id;

	--select from members table
	SELECT @v_payment_due = payment_due
	from members
	where id = @v_member_id;

	--create an IF statement to check dates that allow cancellation. cancellation is valid a day prior
	IF GETDATE() >= @v_booked_date
	BEGIN
		SET @p_message = 'Cancellation cannot be done on/after the booked date';
	END
	ELSE IF @v_payment_status = 'Cancelled' OR @v_payment_status = 'Paid'
	BEGIN
		SET @p_message = 'Booking has already been cancelled or paid';
	END
	ELSE
	BEGIN
		--code to handle the cancellation
		UPDATE bookings 
		SET payment_status = 'Cancelled' 
		WHERE id = @p_booking_id;

		--how much does the member owe?
		SET @v_payment_due = @v_payment_due - @v_price;

		--check for concecutive cancellations
		SET @v_cancellation = dbo.check_cancellation(@p_booking_id);
		IF @v_cancellation >=2
			BEGIN
				SET @v_payment_due = @v_payment_due + 10
			END;
		--update the members table
		UPDATE members
		SET payment_due = @v_payment_due
		WHERE id = @v_member_id;

		--SET booking cancelled
		SET @p_message = 'Booking Cancelled)';
	END;
END

--create trigger that checks the outstanding balance for members
CREATE TRIGGER payment_check
ON [dbo].[members]
AFTER DELETE
AS
BEGIN
    DECLARE @v_payment_due DECIMAL(6, 2);
    
    SELECT @v_payment_due = payment_due
    FROM deleted;
    
    IF @v_payment_due > 0
    BEGIN
        INSERT INTO pending_terminations (id, email, payment_due)
        SELECT d.id, d.email, d.payment_due
        FROM deleted AS d;
    END;
END;

--create function
CREATE FUNCTION check_cancellation (@p_booking_id INT)
RETURNS INT
AS
BEGIN
    DECLARE @v_done INT;
    DECLARE @v_cancellation INT;
    DECLARE @v_current_payment_status VARCHAR(255);
    
    DECLARE cur CURSOR FOR
    SELECT payment_status
    FROM bookings
    WHERE member_id = (SELECT member_id FROM bookings WHERE id = @p_booking_id)
    ORDER BY datetime_of_booking DESC;
    
    SET @v_done = 0;
    SET @v_cancellation = 0;
    
    OPEN cur;
    FETCH NEXT FROM cur INTO @v_current_payment_status;
    
    WHILE @@FETCH_STATUS = 0 AND @v_done = 0
    BEGIN
        IF @v_current_payment_status <> 'Cancelled' OR @v_done = 1
            SET @v_done = 1;
        ELSE
            SET @v_cancellation = @v_cancellation + 1;
        
        FETCH NEXT FROM cur INTO @v_current_payment_status;
    END;
    
    CLOSE cur;
    DEALLOCATE cur;
    
    RETURN @v_cancellation;
END;

---THIS MARKS THE END OF THE CODING OF THE DATABASE. A NEW QUERY WINDOW WILL BE USED TO TEST THE DB 





























END































































