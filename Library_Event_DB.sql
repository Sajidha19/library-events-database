/*
===============================================================================
Library Event Management Database
===============================================================================
Purpose:
    A relational database for managing library events,
    bookings, members, staff, rooms, payments, and feedback.

Compatibility:
    MySQL / MariaDB

Usage:
    1. Run this entire script in MySQL or MariaDB.
    2. The database is created automatically if it does not already exist.
    3. The USE statement selects the database automatically.
    4. Tables, relationships, constraints, and sample data are created
       without requiring manual database setup.

===============================================================================
*/

-- ---------------------------------------------------------------------------
-- 1. Database setup
-- ---------------------------------------------------------------------------
-- IF NOT EXISTS makes the script safe to run when the database already exists.
CREATE DATABASE IF NOT EXISTS Library_Event_Management;

-- Select the project database so all following objects are created here.
USE Library_Event_Management;

-- ---------------------------------------------------------------------------
-- 2. EventType
-- ---------------------------------------------------------------------------
-- Stores the categories/types of events offered by the library.
CREATE TABLE EventType (
    EventTypeID INT NOT NULL,
    Description VARCHAR(100) NOT NULL,
    PRIMARY KEY (EventTypeID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ---------------------------------------------------------------------------
-- 3. Member
-- ---------------------------------------------------------------------------
-- Stores library member information used for event participation and bookings.
-- The sample records below use fictional names and contact details.
CREATE TABLE Member (
    MemberID INT NOT NULL AUTO_INCREMENT,
    Member_Fname VARCHAR(50) NOT NULL,
    Member_Lname VARCHAR(50) NOT NULL,
    Member_Email VARCHAR(100) NOT NULL,
    Member_Phone VARCHAR(30) NOT NULL,
    Member_Type VARCHAR(30) NOT NULL,
    PRIMARY KEY (MemberID),
    UNIQUE KEY UQ_Member_Email (Member_Email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ---------------------------------------------------------------------------
-- 4. Staff
-- ---------------------------------------------------------------------------
-- Stores staff members responsible for organising or managing events.
CREATE TABLE Staff (
    StaffID INT NOT NULL,
    Staff_Name VARCHAR(100) NOT NULL,
    Staff_Email VARCHAR(100) NOT NULL,
    PRIMARY KEY (StaffID),
    UNIQUE KEY UQ_Staff_Email (Staff_Email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ---------------------------------------------------------------------------
-- 5. Room
-- ---------------------------------------------------------------------------
-- Stores rooms available for library events, including capacity and facilities.
CREATE TABLE Room (
    RoomID INT NOT NULL,
    Room_Name VARCHAR(50) NOT NULL,
    Room_Capacity INT NOT NULL CHECK (Room_Capacity > 0),
    Hourly_Rate DECIMAL(10,2) NOT NULL CHECK (Hourly_Rate >= 0),
    Facilities VARCHAR(200),
    PRIMARY KEY (RoomID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ---------------------------------------------------------------------------
-- 6. Event
-- ---------------------------------------------------------------------------
-- Central table for library events.
-- Foreign keys connect each event to its type, room, staff member, and member.
CREATE TABLE Event (
    EventID INT NOT NULL,
    Event_Name VARCHAR(100) NOT NULL,
    EventTypeID INT,
    Event_Date DATE NOT NULL,
    Event_Duration INT NOT NULL CHECK (Event_Duration > 0),
    RoomID INT,
    StaffID INT,
    MemberID INT,
    Ticket_Cost DECIMAL(10,2) NOT NULL CHECK (Ticket_Cost >= 0),
    PRIMARY KEY (EventID),
    KEY IDX_Event_EventType (EventTypeID),
    KEY IDX_Event_Room (RoomID),
    KEY IDX_Event_Staff (StaffID),
    KEY IDX_Event_Member (MemberID),
    CONSTRAINT FK_Event_EventType
        FOREIGN KEY (EventTypeID) REFERENCES EventType(EventTypeID),
    CONSTRAINT FK_Event_Room
        FOREIGN KEY (RoomID) REFERENCES Room(RoomID),
    CONSTRAINT FK_Event_Staff
        FOREIGN KEY (StaffID) REFERENCES Staff(StaffID),
    CONSTRAINT FK_Event_Member
        FOREIGN KEY (MemberID) REFERENCES Member(MemberID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ---------------------------------------------------------------------------
-- 7. EventBooking
-- ---------------------------------------------------------------------------
-- Records members who book library events and tracks booking status.
CREATE TABLE EventBooking (
    BookingID INT NOT NULL,
    MemberID INT,
    EventID INT,
    Booking_Date DATE NOT NULL,
    Booking_Status VARCHAR(50) NOT NULL,
    PRIMARY KEY (BookingID),
    KEY IDX_Booking_Member (MemberID),
    KEY IDX_Booking_Event (EventID),
    CONSTRAINT FK_Booking_Member
        FOREIGN KEY (MemberID) REFERENCES Member(MemberID),
    CONSTRAINT FK_Booking_Event
        FOREIGN KEY (EventID) REFERENCES Event(EventID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ---------------------------------------------------------------------------
-- 8. Feedback
-- ---------------------------------------------------------------------------
-- Stores attendee feedback and ratings for completed events.
-- Rating is restricted to the range 1-5.
CREATE TABLE Feedback (
    FeedbackID INT NOT NULL AUTO_INCREMENT,
    EventID INT,
    Feedback_Date DATE DEFAULT (CURRENT_DATE),
    Feedback_Rating INT CHECK (Feedback_Rating BETWEEN 1 AND 5),
    Feedback_Comment TEXT,
    PRIMARY KEY (FeedbackID),
    KEY IDX_Feedback_Event (EventID),
    CONSTRAINT FK_Feedback_Event
        FOREIGN KEY (EventID) REFERENCES Event(EventID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ---------------------------------------------------------------------------
-- 9. RoomPayment
-- ---------------------------------------------------------------------------
-- Records payments associated with event bookings and room/event costs.
CREATE TABLE RoomPayment (
    PaymentID INT NOT NULL AUTO_INCREMENT,
    EventID INT,
    MemberID INT,
    Payment_Date DATE NOT NULL,
    Amount_Paid DECIMAL(10,2) NOT NULL CHECK (Amount_Paid >= 0),
    Payment_Method VARCHAR(30) NOT NULL,
    Payment_Status VARCHAR(30) NOT NULL,
    PRIMARY KEY (PaymentID),
    KEY IDX_Payment_Member (MemberID),
    KEY IDX_Payment_Event (EventID),
    CONSTRAINT FK_Payment_Member
        FOREIGN KEY (MemberID) REFERENCES Member(MemberID),
    CONSTRAINT FK_Payment_Event
        FOREIGN KEY (EventID) REFERENCES Event(EventID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ---------------------------------------------------------------------------
-- 10. Sample reference data: Event types
-- ---------------------------------------------------------------------------
INSERT INTO EventType (EventTypeID, Description) VALUES
(1, 'Talk'),
(2, 'Reading Session'),
(3, 'Performance'),
(4, 'Workshop'),
(5, 'Club'),
(6, 'Community Event'),
(7, 'Screening'),
(8, 'Drop-in Session'),
(9, 'Exhibition'),
(10, 'Wellness Session'),
(11, 'Seminar');

-- ---------------------------------------------------------------------------
-- 11. Sample reference data: Staff
-- ---------------------------------------------------------------------------
-- Fictional staff records are used for demonstration purposes.
INSERT INTO Staff (StaffID, Staff_Name, Staff_Email) VALUES
(1, 'Staff Member 01', 'staff01@example.com'),
(2, 'Staff Member 02', 'staff02@example.com'),
(3, 'Staff Member 03', 'staff03@example.com'),
(4, 'Staff Member 04', 'staff04@example.com'),
(5, 'Staff Member 05', 'staff05@example.com'),
(6, 'Staff Member 06', 'staff06@example.com'),
(7, 'Staff Member 07', 'staff07@example.com'),
(8, 'Staff Member 08', 'staff08@example.com'),
(9, 'Staff Member 09', 'staff09@example.com'),
(10, 'Staff Member 10', 'staff10@example.com'),
(11, 'Staff Member 11', 'staff11@example.com'),
(12, 'Staff Member 12', 'staff12@example.com'),
(13, 'Staff Member 13', 'staff13@example.com'),
(14, 'Staff Member 14', 'staff14@example.com'),
(15, 'Staff Member 15', 'staff15@example.com'),
(16, 'Staff Member 16', 'staff16@example.com');

-- ---------------------------------------------------------------------------
-- 12. Sample reference data: Members
-- ---------------------------------------------------------------------------
-- Fictional sample data replaces the original personal names/contact details.
INSERT INTO Member
    (MemberID, Member_Fname, Member_Lname, Member_Email, Member_Phone, Member_Type)
VALUES
(100, 'Member01', 'Example', 'member100@example.com', '000-000-0100', 'Student'),
(101, 'Member02', 'Example', 'member101@example.com', '000-000-0101', 'Adult'),
(102, 'Member03', 'Example', 'member102@example.com', '000-000-0102', 'Adult'),
(103, 'Member04', 'Example', 'member103@example.com', '000-000-0103', 'Student'),
(104, 'Member05', 'Example', 'member104@example.com', '000-000-0104', 'Adult'),
(105, 'Member06', 'Example', 'member105@example.com', '000-000-0105', 'Senior'),
(106, 'Member07', 'Example', 'member106@example.com', '000-000-0106', 'Student'),
(107, 'Member08', 'Example', 'member107@example.com', '000-000-0107', 'Adult'),
(108, 'Member09', 'Example', 'member108@example.com', '000-000-0108', 'Adult'),
(109, 'Member10', 'Example', 'member109@example.com', '000-000-0109', 'Student'),
(110, 'Member11', 'Example', 'member110@example.com', '000-000-0110', 'Senior'),
(111, 'Member12', 'Example', 'member111@example.com', '000-000-0111', 'Adult'),
(112, 'Member13', 'Example', 'member112@example.com', '000-000-0112', 'Adult'),
(113, 'Member14', 'Example', 'member113@example.com', '000-000-0113', 'Student'),
(114, 'Member15', 'Example', 'member114@example.com', '000-000-0114', 'Adult'),
(115, 'Member16', 'Example', 'member115@example.com', '000-000-0115', 'Senior');

-- ---------------------------------------------------------------------------
-- 13. Sample reference data: Rooms
-- ---------------------------------------------------------------------------
INSERT INTO Room
    (RoomID, Room_Name, Room_Capacity, Hourly_Rate, Facilities)
VALUES
(1, 'Author Talk Hall', 80, 50.00, 'Projector, Microphone, Stage'),
(2, 'Children Activity Room', 40, 30.00, 'Kids Furniture, Whiteboard, Toys'),
(3, 'Performance Stage Room', 120, 80.00, 'Stage, Lighting, Sound System'),
(4, 'Digital Learning Lab', 35, 45.00, 'Computers, Internet Access, Projector'),
(5, 'Manga & Youth Club Room', 30, 25.00, 'Seating Area, Whiteboard'),
(6, 'Creative Writing Studio', 25, 20.00, 'Desks, Whiteboard'),
(7, 'Book Launch Auditorium', 100, 70.00, 'Stage, Projector, Microphone'),
(8, 'Family Reading Garden', 150, 60.00, 'Outdoor Seating, Shade Area'),
(9, 'Cinema Screening Room', 90, 75.00, 'Screen, Surround Sound, Projector'),
(10, 'Book Club Meeting Room', 30, 25.00, 'Round Table, Chairs'),
(11, 'Career Support Room', 20, 15.00, 'Desks, Computers'),
(12, 'Wellness & Meditation Room', 25, 20.00, 'Mats, Soft Lighting'),
(13, 'Celebration Hall', 200, 100.00, 'Stage, Sound System, Seating'),
(14, 'Seminar Conference Room', 70, 55.00, 'Projector, Conference Table'),
(15, 'Language Exchange Room', 35, 30.00, 'Whiteboard, Seating'),
(16, 'Art Exhibition Studio', 85, 60.00, 'Display Panels, Lighting, Work Tables');

-- ---------------------------------------------------------------------------
-- 14. Sample transactional data: Events
-- ---------------------------------------------------------------------------
-- Event records reference the previously created event types, rooms,
-- staff members, and library members.
INSERT INTO Event
    (EventID, Event_Name, EventTypeID, Event_Date, Event_Duration,
     RoomID, StaffID, MemberID, Ticket_Cost)
VALUES
(1, 'Author Talk: Historical Fiction', 1, '2026-03-10', 2, 1, 1, 100, 6.00),
(2, 'Children''s Storytime', 2, '2026-03-11', 2, 2, 2, 101, 10.00),
(4, 'Poetry Open Mic Night', 3, '2026-03-13', 3, 3, 4, 103, 2.50),
(5, 'Digital Literacy Workshop', 4, '2026-03-14', 2, 4, 5, 104, 5.00),
(6, 'Teen Manga Club', 5, '2026-03-15', 2, 5, 6, 105, 2.00),
(7, 'Creative Writing Bootcamp', 4, '2026-03-16', 3, 6, 7, 106, 15.00),
(8, 'Book Launch', 1, '2026-03-17', 2, 7, 8, 107, 4.00),
(9, 'Community Reading Picnic', 6, '2026-03-18', 3, 8, 9, 108, 20.00),
(10, 'Coding for Beginners', 4, '2026-03-19', 2, 4, 10, 109, 6.00),
(11, 'Film Screening', 7, '2026-03-20', 3, 9, 11, 110, 10.00),
(12, 'Adult Book Club', 5, '2026-03-21', 2, 10, 12, 111, 5.00),
(13, 'Resume Help', 8, '2026-03-22', 1, 11, 13, 112, 2.00),
(14, 'Author Showcase', 9, '2026-03-23', 2, 16, 14, 113, 3.00),
(15, 'Meditation Hour', 10, '2026-03-24', 1, 12, 15, 114, 4.00),
(16, 'Library Celebration', 6, '2026-03-25', 4, 13, 16, 115, 10.00),
(17, 'Sci-fi Discussion', 5, '2026-03-26', 2, 10, 1, 100, 5.00),
(18, 'Environmental Talk', 11, '2026-03-27', 2, 14, 2, 101, 4.00),
(19, 'Language Meetup', 6, '2026-03-28', 2, 15, 3, 102, 4.00),
(20, 'Art Exhibition', 9, '2026-03-29', 3, 16, 4, 103, 8.00);

-- ---------------------------------------------------------------------------
-- 15. Sample transactional data: Event bookings
-- ---------------------------------------------------------------------------
INSERT INTO EventBooking
    (BookingID, MemberID, EventID, Booking_Date, Booking_Status)
VALUES
(1, 100, 1, '2026-02-19', 'Confirmed'),
(2, 101, 2, '2026-02-20', 'Cancelled'),
(4, 103, 4, '2026-02-22', 'Confirmed'),
(5, 104, 5, '2026-02-23', 'Confirmed'),
(6, 105, 6, '2026-02-24', 'Cancelled'),
(7, 106, 7, '2026-02-25', 'Confirmed'),
(8, 107, 8, '2026-02-26', 'Waitlisted'),
(9, 108, 9, '2026-02-27', 'Confirmed'),
(10, 109, 10, '2026-02-28', 'Confirmed'),
(11, 110, 11, '2026-03-01', 'Cancelled'),
(12, 111, 12, '2026-03-02', 'Confirmed'),
(13, 112, 13, '2026-03-03', 'Waitlisted'),
(14, 113, 14, '2026-03-04', 'Confirmed'),
(15, 114, 15, '2026-03-05', 'Confirmed'),
(16, 115, 16, '2026-03-06', 'Cancelled');

-- ---------------------------------------------------------------------------
-- 16. Sample transactional data: Feedback
-- ---------------------------------------------------------------------------
INSERT INTO Feedback
    (FeedbackID, EventID, Feedback_Date, Feedback_Rating, Feedback_Comment)
VALUES
(300, 1, '2026-03-10', 5, 'Excellent historical fiction talk'),
(301, 2, '2026-03-11', 5, 'Kids enjoyed storytime'),
(303, 4, '2026-03-13', 5, 'Amazing poetry performances'),
(304, 5, '2026-03-14', 4, 'Helpful digital skills workshop'),
(305, 6, '2026-03-15', 5, 'Great Teen Manga Club session'),
(306, 7, '2026-03-16', 5, 'Excellent writing bootcamp'),
(307, 8, '2026-03-17', 4, 'Good book launch event'),
(308, 9, '2026-03-18', 5, 'Lovely family reading picnic'),
(309, 10, '2026-03-19', 4, 'Useful coding introduction'),
(310, 11, '2026-03-20', 5, 'Enjoyable classic film screening'),
(311, 12, '2026-03-21', 4, 'Good book discussion'),
(312, 13, '2026-03-22', 5, 'Very helpful job search session'),
(313, 14, '2026-03-23', 4, 'Interesting author showcase'),
(314, 15, '2026-03-24', 5, 'Relaxing mindfulness session'),
(315, 16, '2026-03-25', 5, 'Great anniversary celebration'),
(316, 17, '2026-03-26', 4, 'Good sci-fi discussion group'),
(317, 18, '2026-03-27', 5, 'Very informative awareness talk'),
(318, 19, '2026-03-28', 4, 'Nice language exchange meetup'),
(319, 20, '2026-03-29', 5, 'Excellent local art exhibition');

-- ---------------------------------------------------------------------------
-- 17. Sample transactional data: Room payments
-- ---------------------------------------------------------------------------
INSERT INTO RoomPayment
    (PaymentID, EventID, MemberID, Payment_Date, Amount_Paid,
     Payment_Method, Payment_Status)
VALUES
(200, 1, 100, '2026-02-21', 100.00, 'Card', 'Paid'),
(201, 2, 101, '2026-02-22', 60.00, 'Cash', 'Paid'),
(203, 4, 103, '2026-02-24', 240.00, 'Online', 'Paid'),
(204, 5, 104, '2026-02-25', 90.00, 'Card', 'Paid'),
(205, 6, 105, '2026-02-26', 50.00, 'Cash', 'Pending'),
(206, 7, 106, '2026-02-27', 60.00, 'Card', 'Paid'),
(207, 8, 107, '2026-02-28', 140.00, 'Online', 'Paid'),
(208, 9, 108, '2026-03-01', 180.00, 'Card', 'Paid'),
(209, 10, 109, '2026-03-02', 90.00, 'Cash', 'Paid'),
(210, 11, 110, '2026-03-03', 225.00, 'Online', 'Pending'),
(211, 12, 111, '2026-03-04', 50.00, 'Card', 'Paid'),
(212, 13, 112, '2026-03-05', 15.00, 'Cash', 'Paid'),
(213, 14, 113, '2026-03-06', 120.00, 'Online', 'Paid'),
(214, 15, 114, '2026-03-07', 20.00, 'Card', 'Pending'),
(215, 16, 115, '2026-03-08', 400.00, 'Online', 'Paid');

-- ---------------------------------------------------------------------------
-- 18. Verification queries
-- ---------------------------------------------------------------------------
-- These optional queries can be used to quickly verify that the database
-- contains the expected tables and sample records after import.
-- Uncomment them when testing the project.

-- SHOW TABLES;
-- SELECT * FROM Event;
-- SELECT * FROM EventBooking;
-- SELECT * FROM Feedback;
-- SELECT * FROM Member;
-- SELECT * FROM Room;
-- SELECT * FROM RoomPayment;
-- SELECT * FROM Staff;
-- SELECT * FROM EventType;

-- End of Library Event Management Database.
