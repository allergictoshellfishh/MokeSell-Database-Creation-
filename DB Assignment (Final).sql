-- Create MokeSell Database 
CREATE DATABASE MokeSell;
GO

USE MokeSell;
GO


--Category Relation
CREATE TABLE Category 
(
	CatID				varchar(3)		NOT NULL,
	CatDesc				varchar(30)		NOT NULL,

	-- Constraints
	CONSTRAINT PK_Category PRIMARY KEY (CatID)
);

--SubCategory Relation
CREATE TABLE SubCategory 
(
	SubCatID			varchar(5)		NOT NULL,
	SubCatDesc			varchar(50)		NOT NULL,
	CatID				varchar(3)		NOT NULL,

	-- Constraints
	CONSTRAINT PK_SubCategory PRIMARY KEY (SubCatID),
	CONSTRAINT FK_SubCategory_CatID FOREIGN KEY (CatID) REFERENCES Category(CatID)
);

-- Member Relation
CREATE TABLE Member 
(
	MemberID			smallint		NOT NULL,
	MemberName			varchar(50)		NOT NULL,
	MemberDOB			smalldatetime	NOT NULL CHECK (MemberDOB <= GETDATE()),
	MemberEmail			varchar(100)	NOT NULL,
	MemberMobile		varchar(15)		NOT NULL CHECK (LEN(MemberMobile) BETWEEN 8 AND 15),
	MemberDateJoined	smalldatetime	NOT NULL CHECK (MemberDateJoined <= GETDATE()),
	City				varchar(50),		

	-- Constraints
	CONSTRAINT PK_Member PRIMARY KEY (MemberID)
);

-- Follower Relation
CREATE TABLE Follower 
(
    MemberID			smallint		NOT NULL,
    FollowerID			smallint		NOT NULL,
    DateStarted			smalldatetime	NOT NULL CHECK (DateStarted <= GETDATE()),

    -- Constraints
    CONSTRAINT PK_Follower PRIMARY KEY (MemberID, FollowerID),
    CONSTRAINT FK_Follower_MemberID FOREIGN KEY (MemberID) REFERENCES Member(MemberID),
    CONSTRAINT FK_Follower_FollowerID FOREIGN KEY (FollowerID) REFERENCES Member(MemberID)
);

-- Buyer Relation
CREATE TABLE Buyer 
(
    BuyerID				smallint		NOT NULL,

	-- Constraints
    CONSTRAINT PK_Buyer PRIMARY KEY (BuyerID),
    CONSTRAINT FK_Buyer_BuyerID FOREIGN KEY (BuyerID) REFERENCES Member (MemberID)
);

-- Seller Relation
CREATE TABLE Seller
(
	SellerID			smallint		NOT NULL,

	-- Constraints
	CONSTRAINT PK_Seller PRIMARY KEY (SellerID),
	CONSTRAINT FK_Seller_SellerID FOREIGN KEY (SellerID) REFERENCES Member(MemberID)
);

-- Listing Relation
CREATE TABLE Listing
(
	ListingID			varchar(6)		NOT NULL,
	ListDesc			varchar(150)	NOT NULL,
	ListDateTime		smalldatetime	NOT NULL CHECK (ListDateTime <= GETDATE()) ,
	ListPrice			smallmoney		NOT NULL CHECK (ListPrice >= 0),
	ListStatus			char(1)			NOT NULL CHECK (ListStatus IN ('A', 'S', 'I')),
	SellerID			smallint		NOT NULL,
	SubCatID			varchar(5)		NOT NULL,

	-- Constraints
	CONSTRAINT PK_Listing PRIMARY KEY (ListingID),
	CONSTRAINT FK_Listing_SellerID FOREIGN KEY (SellerID) REFERENCES Seller(SellerID),
	CONSTRAINT FK_Listing_SubCatID FOREIGN KEY (SubCatID) REFERENCES SubCategory(SubCatID)
);

-- ListingPhoto Relation
CREATE TABLE ListingPhoto
(
	ListingID			varchar(6)		NOT NULL, 
	Photo				varchar(50)		NOT NULL,

	-- Constraints
	CONSTRAINT PK_ListingPhoto PRIMARY KEY (ListingID, Photo),
	CONSTRAINT FK_ListingPhoto_ListingID FOREIGN KEY (ListingID) REFERENCES Listing(ListingID)
);

-- Likes Relation
CREATE TABLE Likes 
(
	BuyerID				smallint		NOT NULL,
	ListingID			varchar(6)		NOT NULL,
	DateLiked			smalldatetime	NOT NULL CHECK (DateLiked <= GETDATE()),

	-- Constraints
    CONSTRAINT PK_Likes PRIMARY KEY (BuyerID, ListingID),
	CONSTRAINT FK_Likes_BuyerID FOREIGN KEY (BuyerID) REFERENCES Buyer (BuyerID),
	CONSTRAINT FK_Likes_ListingID FOREIGN KEY (ListingID) REFERENCES Listing (ListingID)
);

-- Offer Relation
CREATE TABLE Offer 
(
	OfferID				varchar(6)		NOT NULL,
	BuyerID				smallint		NOT NULL,
	ListingID			varchar(6)		NOT NULL,
	OfferPrice			smallmoney		NOT NULL,
	OfferStatus			char(1)			NOT NULL CHECK (OfferStatus IN ('P', 'A' , 'R')),
	OfferDate			smalldatetime	NOT NULL CHECK (OfferDate <= GETDATE()),

	-- Constraints
	CONSTRAINT PK_Offer PRIMARY KEY (OfferID),
	CONSTRAINT FK_Offer_BuyerID FOREIGN KEY (BuyerID) REFERENCES Buyer (BuyerID),
	CONSTRAINT FK_Offer_ListingID FOREIGN KEY (ListingID) REFERENCES Listing (ListingID)
);

-- Review Relation
CREATE TABLE Review
(
	ReviewID			varchar(8)		NOT NULL,
	ReviewDate			smalldatetime	NOT NULL CHECK (ReviewDate <= GETDATE()),
	Comment				varchar(150),
	CommunicationRank	tinyint			NOT NULL CHECK (CommunicationRank BETWEEN 1 AND 5),
	DeliveryRank		tinyint			CHECK (DeliveryRank BETWEEN 1 AND 5),
	ItemRank			tinyint			CHECK (ItemRank BETWEEN 1 AND 5),
	MemberType			char(1)			NOT NULL CHECK (MemberType IN ('S', 'B')),
	OfferID				varchar(6)		NOT NULL,

	-- Constraints
	CONSTRAINT PK_Review PRIMARY KEY (ReviewID),
	CONSTRAINT FK_Review_OfferID FOREIGN KEY (OfferID) REFERENCES Offer(OfferID)
);

-- Team Relation
CREATE TABLE Team
(
	TeamID				varchar(4)		NOT NULL,
	TeamName			varchar(30)		NOT NULL,
	TeamLeaderID		varchar(4),

	-- Constraints
	CONSTRAINT PK_Team PRIMARY KEY (TeamID),
);

-- Staff Relation
CREATE TABLE Staff 
(
    StaffID				varchar(4)		NOT NULL,
    StaffName			varchar(50)		NOT NULL,
    StaffMobile			varchar(15)		NOT NULL CHECK (LEN(StaffMobile) BETWEEN 8 AND 15),
    StaffDateJoined		smalldatetime	NOT NULL CHECK (StaffDateJoined <= GETDATE()),
    TeamID				varchar(4)		NOT NULL,

    -- Constraints
    CONSTRAINT PK_Staff PRIMARY KEY (StaffID),
);

-- Add FK to Team Table for TeamLeaderID --
ALTER TABLE Team
ADD CONSTRAINT FK_Team_TeamLeaderID FOREIGN KEY (TeamLeaderID) REFERENCES Staff(StaffID);

-- Add FK to Staff Table for TeamID --
ALTER TABLE Staff
ADD CONSTRAINT FK_Staff_TeamID FOREIGN KEY (TeamID) REFERENCES Team(TeamID);

-- Award Relation
CREATE TABLE Award
(
	AwardID				varchar(4)		NOT NULL,
	AwardName			varchar(30)		NOT NULL,
	AwardAmt			smallmoney		CHECK (AwardAmt >= 0)

	-- Constraints
	CONSTRAINT PK_Award PRIMARY KEY (AwardID)
);

-- Win Relation
CREATE TABLE Win
(
	AwardID				varchar(4)		NOT NULL,
	TeamID				varchar(4)		NOT NULL,
	DateAwarded			smalldatetime	NOT NULL CHECK (DateAwarded <= GETDATE()),

	-- Constraints
	CONSTRAINT PK_Win PRIMARY KEY (AwardID, TeamID, DateAwarded),
	CONSTRAINT FK_Win_AwardID FOREIGN KEY (AwardID) REFERENCES Award(AwardID),
	CONSTRAINT FK_Win_TeamID FOREIGN KEY (TeamID) REFERENCES Team(TeamID)
);

-- FeedbkCat Relation
CREATE TABLE FeedbkCat 
(
    FbkCatID			varchar(5)		NOT NULL,
    FbkCatDesc			varchar(100)    NOT NULL,

    -- Constraints
    CONSTRAINT PK_FeedbkCat PRIMARY KEY (FbkCatID)
);

-- Feedback Relation
CREATE TABLE Feedback 
(
    FbkID				varchar(6)		NOT NULL,
    FbkDesc				varchar(250)	NOT NULL,
    FbkDateTime			smalldatetime	NOT NULL CHECK (FbkDateTime <= GETDATE()),
    FbkStatus			varchar(20)		NOT NULL CHECK (FbkStatus IN ('Pending', 'Receiving Attention', 'Completed')),
    SatisfactionRank	tinyint			NOT NULL CHECK (SatisfactionRank BETWEEN 1 AND 5),
    FbkCatID			varchar(5)		NOT NULL,
    OnMemberID			smallint,
    ByMemberID			smallint		NOT NULL,
    StaffID				varchar(4)		NOT NULL,

    -- Constraints
    CONSTRAINT PK_Feedback PRIMARY KEY (FbkID),
    CONSTRAINT FK_Feedback_FbkCatID FOREIGN KEY (FbkCatID) REFERENCES FeedbkCat(FbkCatID),
    CONSTRAINT FK_Feedback_OnMember FOREIGN KEY (OnMemberID) REFERENCES Member(MemberID),
    CONSTRAINT FK_Feedback_ByMember FOREIGN KEY (ByMemberID) REFERENCES Member(MemberID),
    CONSTRAINT FK_Feedback_Staff FOREIGN KEY (StaffID) REFERENCES Staff(StaffID)
);

-- Bump Relation
Create TABLE Bump 
(
	BumpID				varchar(2)		NOT NULL CHECK(BumpID in ('O','D3','T3','D7')),
	BumpDesc			varchar(50)		NOT NULL,
	BumpPrice			smallmoney		NOT NULL,

	--Constraints
	CONSTRAINT PK_Bump PRIMARY KEY (BumpID)
);

-- BumpOrder Relation
Create TABLE BumpOrder 
(
	BumpOrderID			varchar(6)		NOT NULL,
	PurchaseDate		smalldatetime	NOT NULL CHECK(PurchaseDate <= GETDATE()),
	BumpID				varchar(2)		NOT NULL,
	ListingID			varchar(6)		NOT NULL,
	SellerID			smallint		NOT NULL,

	--Constraints
	CONSTRAINT PK_BumpOrder PRIMARY KEY (BumpOrderID),
	CONSTRAINT FK_BumpOrder_BumpID FOREIGN KEY (BumpID) REFERENCES Bump(BumpID),
	CONSTRAINT FK_BumpOrder_Listing_ListingID FOREIGN KEY (ListingID) REFERENCES Listing(ListingID),
	CONSTRAINT FK_BumperOrder_SellerID FOREIGN KEY (SellerID) REFERENCES Seller(SellerID)
);

-- Chat Relation
CREATE TABLE Chat 
(
	ChatID				varchar(6)		NOT NULL,
	BuyerID				smallint		NOT NULL,
	ListingID			varchar(6)		NOT NULL,

	-- Constraints
	CONSTRAINT PK_Chat PRIMARY KEY (ChatID),
	CONSTRAINT FK_Chat_BuyerID FOREIGN KEY (BuyerID) REFERENCES Buyer (BuyerID),
	CONSTRAINT FK_Chat_ListingID FOREIGN KEY (ListingID) REFERENCES Listing (ListingID)
);

-- ChatMsg Relation
CREATE TABLE ChatMsg 
(
	ChatID				varchar(6)		NOT NULL,
	MsgSN				char(3)			NOT NULL,
	MsgDateTime			smalldatetime	NOT NULL CHECK (MsgDateTime <= GETDATE()),
	Originator			char(1)			NOT NULL CHECK (Originator IN ('S', 'B')),
	Msg					varchar(250),

	-- Constraints
    CONSTRAINT PK_ChatMsg PRIMARY KEY (ChatID, MsgSN),
	CONSTRAINT FK_ChatMsg_ChatID FOREIGN KEY (ChatID) REFERENCES Chat (ChatID)
);


--Category Relation Data
INSERT INTO Category (CatID, CatDesc)
VALUES
('C01','Product Condition'),
('C02','Product Category'),
('C03','Collection Method'),
('C04','Payment Type'),
('C05','Listing Status');

--SubCategory Relation Data
INSERT INTO SubCategory (SubCatID, SubCatDesc, CatID)
VALUES
('SC001', 'New', 'C01'),
('SC002', 'Used', 'C01'),
('SC003', 'Refurbished', 'C01'),
('SC004', 'Like New', 'C01'),
('SC005', 'Electronics','C02'),
('SC006', 'Clothing & Accessories', 'C02'),
('SC007', 'Home & Living', 'C02'),
('SC008', 'Sports & Outdoors', 'C02'),
('SC009', 'Books & Media', 'C02'),
('SC010', 'Toys & Games', 'C02'),
('SC011', 'Meet Up', 'C03'),
('SC012', 'Mailing', 'C03'),
('SC013', 'Pick Up', 'C03'),
('SC014', 'Cash On Delivery', 'C04'),
('SC015', 'Bank Transfer', 'C04'),
('SC016', 'New Listing', 'C05'),
('SC017', 'Bump Once', 'C05'),
('SC018', 'Bump Daily', 'C05'),
('SC019', 'Bump Twice A Day', 'C05');

-- Member Relation Data
INSERT INTO Member (MemberID, MemberName, MemberDOB, MemberEmail, MemberMobile, MemberDateJoined, City) 
VALUES
('00001', 'John Doe', '1990-01-15', 'john.doe@gmail.com', '1234567890', '2023-01-10', 'New York'),
('00002', 'Jane Smith', '1985-03-20', 'jane.smith@ymail.com', '9876543210', '2022-05-15', 'Los Angeles'),
('00003', 'Michael Brown', '1992-07-11', 'michael.brown@hotmail.com', '1231231234', '2021-09-01', 'Chicago'),
('00004', 'Emily Davis', '1998-12-05', 'emily.davis@outlook.com', '4564564567', '2020-11-25', NULL),
('00005', 'Chris Wilson', '1995-04-18', 'chris.wilson@gmail.com', '7897897890', '2023-04-10', 'Houston'),
('00006', 'Sophia Johnson', '2000-08-21', 'sophia.johnson@ymail.com', '9876541230', '2023-07-20', 'Phoenix'),
('00007', 'David Garcia', '1994-09-30', 'david.garcia@hotmail.com', '1230984567', '2022-01-15', 'Philadelphia'),
('00008', 'Mia Martinez', '1988-11-14', 'mia.martinez@outlook.com', '7894561230', '2021-12-01', NULL),
('00009', 'James Anderson', '1982-06-23', 'james.anderson@gmail.com', '4567891234', '2020-08-10', 'San Antonio'),
('00010', 'Olivia Thompson', '1993-05-12', 'olivia.thompson@ymail.com', '3216549870', '2023-06-14', 'San Diego'),
('00011', 'Daniel Lee', '1996-02-27', 'daniel.lee@hotmail.com', '1472583690', '2023-02-15', 'Dallas'),
('00012', 'Isabella Harris', '1989-10-10', 'isabella.harris@outlook.com', '7891234560', '2021-05-20', 'Austin'),
('00013', 'Ethan Clark', '1991-01-07', 'ethan.clark@gmail.com', '2581473690', '2022-04-30', 'Jacksonville'),
('00014', 'Ava Lewis', '1997-03-25', 'ava.lewis@ymail.com', '1237894560', '2023-08-01', 'San Francisco'),
('00015', 'Alexander Young', '1984-12-18', 'alexander.young@hotmail.com', '4561237890', '2020-07-05', 'Indianapolis'),
('00016', 'Charlotte King', '1999-07-19', 'charlotte.king@outlook.com', '7896543210', '2023-03-22', 'Seattle'),
('00017', 'Henry Wright', '1987-08-03', 'henry.wright@gmail.com', '3217896540', '2021-10-30', NULL),
('00018', 'Amelia Scott', '1990-05-09', 'amelia.scott@ymail.com', '6549873210', '2022-12-11', 'Denver'),
('00019', 'Lucas Hall', '1993-09-28', 'lucas.hall@hotmail.com', '7893216540', '2023-01-18', 'Washington'),
('00020', 'Lily Allen', '1992-04-13', 'lily.allen@outlook.com', '1236547890', '2020-03-05', 'Boston');

-- Follower Relation Data
INSERT INTO Follower 
VALUES 
('00001', '00002', '2023-01-01 10:00:00'),
('00003', '00004', '2023-02-15 11:30:00'),
('00005', '00006', '2023-03-12 09:15:00'),
('00007', '00008', '2023-04-25 14:00:00'),
('00009', '00010', '2023-05-05 16:45:00'),
('00011', '00012', '2023-06-20 18:20:00'),
('00013', '00014', '2023-07-10 08:00:00'),
('00015', '00016', '2023-08-30 12:10:00'),
('00017', '00018', '2023-09-14 13:30:00'),
('00019', '00020', '2023-10-01 15:45:00'),
('00002', '00003', '2023-01-01 10:00:00'),
('00004', '00005', '2023-02-15 11:30:00'),
('00006', '00007', '2023-03-12 09:15:00'),
('00008', '00009', '2023-04-25 14:00:00'),
('00010', '00011', '2023-05-05 16:45:00'),
('00012', '00013', '2023-06-20 18:20:00'),
('00014', '00015', '2023-07-10 08:00:00'),
('00016', '00017', '2023-08-30 12:10:00'),
('00018', '00019', '2023-09-14 13:30:00'),
('00020', '00001', '2023-10-01 15:45:00');

-- Buyer Relation Data
INSERT INTO Buyer (BuyerID)
VALUES
('00001'),
('00003'),
('00005'),
('00007'),
('00009'),
('00010'),
('00011'),
('00013'),
('00015'),
('00017'),
('00019'),
('00020');

-- Seller Relation Data
INSERT INTO Seller (SellerID)
VALUES
('00002'),
('00004'),
('00005'),
('00006'),
('00008'),
('00010'),
('00012'),
('00014'),
('00015'),
('00016'),
('00018'),
('00020');

-- Listing Relation Data
INSERT INTO Listing (ListingID, ListDesc, ListDateTime, ListPrice, ListStatus, SellerID, SubCatID)
VALUES
('L00001', 'Harry Potter Book Series', '2024-01-01 10:00:00', 150.00, 'S', '00002', 'SC009'), 
('L00002', 'Linen Couch', '2024-01-15 13:36:00', 450.00, 'I', '00005', 'SC007'), 
('L00003', 'GoPro Hero 10', '2024-02-01 09:10:00', 400.00, 'S', '00002', 'SC005'), 
('L00004', 'Ferrari 2022 Team Shirt', '2024-02-25 07:01:00', 140.00, 'S', '00010', 'SC006'),
('L00005', '#16 Leclerc 2022 SF75 1:18 Model', '2024-02-25 07:10:00', 500.00, 'A', '00010', 'SC010'), 
('L00006', 'Singaporean Dream', '2024-03-01 05:05:00', 15.00,	'S', '00004', 'SC010'), 
('L00007', 'Rotating Book Shelf', '2024-03-18 17:37:00', 120.00, 'A', '00002', 'SC004'), 
('L00008', 'SIA Mahjong Tiles Gold Batik', '2024-03-20 09:41:00', 700.00, 'A', '00008', 'SC011'), 
('L00009', 'Lewis Hamilton Trucker Cap Signed', '2024-04-01 14:00:00', 200.00, 'A', '00010', 'SC006'), 
('L00010', 'Fried Chicken Keychain', '2024-04-14 12:15:00', 5.00, 'I', '00005', 'SC009'), 
('L00011', 'Nike Air Max Ltd 3', '2024-05-02 11:20:00', 100.00, 'S', '00012', 'SC006'), 
('L00012', 'Nintendo Switch OLED', '2024-05-11 10:36:00', 169.00, 'A', '00006', 'SC005'), 
('L00013', 'Mercedes 2024 Softshell Jacket', '2024-06-01 03:50:00', 256.00, 'A', '00010', 'SC009'), 
('L00014', 'MUJI Gel Black Pen Bundle of 10', '2024-06-22 08:04:00', 6.00, 'S', '00012', 'SC001'), 
('L00015', 'Type C Cable', '2024-07-07 09:57:00', 16.00, 'I', '00016', 'SC005'), 
('L00016', '9000 Lumens XHP90 LED Flashlight', '2024-07-29 18:48:00', 75.00, 'S', '00014', 'SC008'), 
('L00017', 'Disney Mickey Mouse Soft Toys', '2024-08-01 15:46:00', 150.00, 'S', '00018', 'SC010'), 
('L00018', 'National Geographic Kids Series', '2024-08-18 10:27:00', 80.00, 'A', '00015', 'SC009'), 
('L00019', 'LED Table Lamp', '2024-09-25 19:38:00', 7.00, 'A', '00006', 'SC007'), 
('L00020', 'Laptop Sleeve Protector', '2024-09-26 12:54:00', 150.00, 'I', '00016', 'SC004'), 
('L00021', 'Formula 1 2024 Backpack', '2024-10-02 02:39:00', 115.00, 'A', '00010', 'SC001'), 
('L00022', 'Printed Wet Tissue', '2024-10-07 12:33:00', 10.00, 'A', '00004', 'SC007'), 
('L00023', 'EpoMaker TH80', '2024-10-11 06:18:00', 200.00, 'S', '00012', 'SC005'), 
('L00024', 'Hunger Games Book Series', '2024-10-30 15:12:00', 30.00, 'S', '00008', 'SC009'), 
('L00025', 'A4 Foolscap Paper 500 Piece', '2024-11-01 13:51:00', 10.00, 'I', '00005', 'SC001'), 
('L00026', 'LEGO 42083 Technic Bugatti Chiron', '2024-11-04 19:26:00', 500.00, 'A', '00020', 'SC010'), 
('L00027', 'Premium Luxury Hotel Pillow', '2024-11-18 21:38:00', 25.00, 'S', '00015', 'SC007'), 
('L00028', 'Owala Water Bottle FreeSip', '2024-11-22 08:39:00', 27.00, 'S', '00006', 'SC007'), 
('L00029', 'Unisex Short Pants', '2024-11-27 14:42:00', 5.00, 'I', '00016', 'SC006'), 
('L00030', 'MAH Black Backpack Outdoor', '2024-12-05 03:46:00', 58.00, 'A', '00014', 'SC008'), 
('L00031', 'Stain Remover Pen Bundle of 5', '2024-12-13 04:52:00', 15.00,	'I', '00005', 'SC007'), 
('L00032', 'LEGO 42171 Technic Mercedes F1', '2024-12-19 16:37:00', 339.00, 'S', '00020', 'SC010'), 
('L00033', 'Audio Technica Headphones', '2024-12-23 02:29:00', 115.00, 'S', '00002', 'SC005'), 
('L00034', 'Non-Slip Clothes Hanger 50 Piece', '2024-12-26 04:11:00', 50.00, 'A', '00015', 'SC009'), 
('L00035', 'Jellycat Croissant', '2025-01-01 17:28:00', 60.00, 'I', '00016', 'SC004'), 
('L00036', 'Foldable Storage Cabinet', '2025-01-07 23:20:00', 25.00, 'S', '00004', 'SC007'), 
('L00037', 'Mario Themed Socks Pack of 5', '2025-01-10 01:17:00', 10.00, 'A', '00018', 'SC006'), 
('L00038', 'Bottass 2025 Calender', '2025-01-15 20:16:00', 300.00, 'S', '00010', 'SC007'), 
('L00039', 'Primary 6 Mathematics Textbook', '2025-01-24 21:15:00', 8.00, 'A', '00008', 'SC002'), 
('L00040', 'LEGO 42143 Ferrari Daytona SP3', '2025-01-25 18:28:00', 150.00, 'A', '00020', 'SC010');

-- ListingPhoto Relation Data
INSERT INTO ListingPhoto (ListingID, Photo)
VALUES
('L00001', 'harrypotter.jpg'),
('L00001', 'harrypotter1.jpg'),
('L00002', 'couch.jpg'),
('L00002', 'couch1.jpg'),
('L00002', 'couch2.jpg'),
('L00003', 'gopro.jpg'),
('L00003', 'gopro2.jpg'),
('L00004', 'ferrarishirt.jpg'),
('L00005', 'ferraricar.jpg'),
('L00005', 'ferraricar1.jpg'),
('L00005', 'ferraricar2.jpg'),
('L00006', 'singaporeandream.jpg'),
('L00007', 'bookshelf.jpg'),
('L00007', 'bookshelf1.jpg'),
('L00007', 'bookshelf2.jpg'),
('L00007', 'bookshelf3.jpg'),
('L00007', 'bookshelf4.jpg'),
('L00008', 'mahjongtiles.jpg'),
('L00008', 'mahjongtiles1.jpg'),
('L00008', 'mahjongtiles2.jpg'),
('L00009', 'lewiscap.jpg'),
('L00010', 'chickenkeychain.jpg'),
('L00011', 'nikeltd.jpg'),
('L00011', 'nikeltd1.jpg'),
('L00011', 'nikeltd2.jpg'),
('L00012', 'nintendo.jpg'),
('L00012', 'nintendo1.jpg'),
('L00013', 'mercedesjacket.jpg'),
('L00014', 'mujipen.jpg'),
('L00015', 'typeccable.jpg'),
('L00016', 'flashlight.jpg'),
('L00016', 'flashlight1.jpg'),
('L00017', 'mickeymouse.jpg'),
('L00018', 'nationalgeographic.jpg'),
('L00018', 'nationalgeographic1.jpg'),
('L00018', 'nationalgeographic2.jpg'),
('L00019', 'tablelamp.jpg'),
('L00019', 'tablelamp1.jpg'),
('L00020', 'laptopsleeve.jpg'),
('L00020', 'laptopsleeve1.jpg');

-- Likes Relation Data
INSERT INTO Likes (BuyerID, ListingID, DateLiked)
VALUES
('00015', 'L00018', '2024-08-29'),
('00011', 'L00030', '2024-12-08'),
('00001', 'L00026', '2024-11-06'),
('00020', 'L00019', '2024-09-30'),
('00003', 'L00040', '2025-01-27'),
('00007', 'L00008', '2024-03-23'),
('00017', 'L00013', '2024-06-15'),
('00013', 'L00009', '2024-04-06'),
('00005', 'L00026', '2024-11-14'),
('00009', 'L00037', '2025-01-16'),
('00010', 'L00025', '2024-11-05'),
('00019', 'L00021', '2024-10-21'),
('00003', 'L00032', '2024-12-31'),
('00015', 'L00011', '2024-05-29'),
('00009', 'L00009', '2024-04-08'),
('00017', 'L00014', '2024-06-29'),
('00003', 'L00018', '2024-08-20'),
('00020', 'L00028', '2024-11-27'),
('00007', 'L00007', '2024-03-21'),
('00007', 'L00010', '2024-04-17'),
('00015', 'L00005', '2024-03-01'),
('00011', 'L00037', '2025-01-11'),
('00001', 'L00001', '2024-01-02'),
('00020', 'L00007', '2024-03-20'),
('00003', 'L00019', '2024-09-26'),
('00007', 'L00004', '2024-02-27'),
('00017', 'L00016', '2024-07-30'),
('00013', 'L00013', '2024-06-05'),
('00005', 'L00030', '2024-12-06'),
('00009', 'L00034', '2024-12-27');

-- Offer Relation Data
INSERT INTO Offer (OfferID, BuyerID, ListingID, OfferPrice, OfferStatus, OfferDate)
VALUES
('O00001', '00001', 'L00012', 130.00, 'R', '2024-05-11 19:00:00'),
('O00002', '00009', 'L00007', 89.00, 'R', '2024-03-20 07:03:00'),
('O00003', '00020', 'L00014', 6.00, 'A', '2024-06-25 22:15:00'),
('O00004', '00001', 'L00039', 5.00, 'P', '2025-01-25 23:59:00'),
('O00005', '00005', 'L00023', 188.00, 'A', '2024-10-17 15:09:00'),
('O00006', '00013', 'L00011', 97.00, 'R', '2024-05-02 11:21:00'),
('O00007', '00019', 'L00001', 120.00, 'A', '2024-01-05 12:44:00'),
('O00008', '00003', 'L00017', 144.00, 'A', '2024-08-09 14:09:00'),
('O00009', '00015', 'L00011', 99.00, 'A', '2024-05-03 16:34:00'),
('O00010', '00007', 'L00005', 368.00, 'R', '2024-02-28 15:54:00'),
('O00011', '00011', 'L00040', 99.00, 'R', '2025-01-27 17:50:00'),
('O00012', '00003', 'L00022', 7.00, 'P', '2024-10-12 04:31:00'),
('O00013', '00009', 'L00028', 25.00, 'A', '2024-12-04 11:43:00'),
('O00014', '00010', 'L00031', 5.00, 'R', '2024-12-15 19:21:00'),
('O00015', '00017', 'L00004', 128.00, 'A', '2024-02-29 16:02:00'),
('O00016', '00020', 'L00013', 241.00, 'P', '2024-06-03 13:09:00'),
('O00017', '00005', 'L00006', 13.00, 'A', '2024-03-22 18:52:00'),
('O00018', '00013', 'L00024', 25.00, 'A', '2024-10-31 15:00:00'),
('O00019', '00007', 'L00033', 114.90, 'A', '2024-12-23 02:30:00'),
('O00020', '00015', 'L00005', 399.00, 'R', '2024-02-29 20:57:00');

-- Review Relation Data
INSERT INTO Review (ReviewID, ReviewDate, Comment, CommunicationRank, DeliveryRank, ItemRank, MemberType, OfferID)
VALUES
('R00001', '2024-01-02 10:00:00', 'Very smooth process overall', 5,	NULL, NULL, 'S', 'O00001'),
('R00002', '2024-01-15 09:10:00', NULL, 3, 5, 4, 'B', 'O00002'),
('R00003', '2024-02-01 13:36:00', 'Item does not look like photo', 1, 3, 1, 'B', 'O00003'),
('R00004', '2024-02-02 18:28:00', 'Buyer texted to change collection time last minute',	1, NULL, NULL, 'S',	'O00004'),
('R00005', '2024-03-02 03:46:00', 'Seller was very helpful with answering questions', 5, 4, 5, 'B', 'O00005'),
('R00006', '2024-04-02 23:20:00', NULL, 5, NULL, NULL, 'S', 'O00006'),
('R00007', '2024-05-02 11:15:00', 'Slight defect in item but can be used', 4, 4, 3, 'B', 'O00007'),
('R00008', '2024-05-02 19:52:00', 'I LOVE IT', 5, 5, 5, 'B', 'O00008'),
('R00009', '2024-06-02 12:37:00', 'Buyer did not understand english', 1, NULL, NULL, 'S', 'O00009'),
('R00010', '2024-06-02 17:04:00', 'Would buy from seller again', 4, 4, 4, 'B', 'O00010'),
('R00011', '2024-07-02 08:49:00', 'Everything was okay except delivery time', 5, 3, 5, 'B', 'O00011'),
('R00012', '2024-08-02 13:51:00', 'Seller took long to reply message', 2, 5, 5, 'B', 'O00012'),
('R00013', '2024-08-02 20:22:00', 'Best buyer I have ever sold to', 5, NULL, NULL, 'S', 'O00013'),
('R00014', '2024-09-02 07:59:00', 'Battery life of item is not good', 3, 5, 2, 'B', 'O00014'),
('R00015', '2024-10-02 14:21:00', 'Extensive features which is very good useful', 4, 4, 5, 'B', 'O00015'),
('R00016', '2024-11-02 06:17:00', 'Colour of item could be brighter', 5, 4, 4, 'B', 'O00016'),
('R00017', '2024-11-02 15:14:00', 'Really friendly buyer and we became friends', 5, NULL, NULL, 'S', 'O00017'),
('R00018', '2024-12-02 02:23:00', 'Item took 5 months to come', 2, 1, 3, 'B', 'O00018'),
('R00019', '2024-12-02 21:38:00', NULL, 4, 4, 4, 'B', 'O00019'),
('R00020', '2025-01-02 01:29:00', 'Bad attitude and foul language used', 1, NULL, NULL, 'S', 'O00020');

-- Team Relation Data
INSERT INTO Team (TeamID, TeamName, TeamLeaderID) 
VALUES
('T001', 'Technical Support', NULL),
('T002', 'User Complaints', NULL),
('T003', 'General Enquiries', NULL),
('T004', 'Payment Support', NULL),
('T005', 'Other Enquiries', NULL);

-- Staff Relation Data
INSERT INTO Staff (StaffID, StaffName, StaffMobile, StaffDateJoined, TeamID)
VALUES 
('S001', 'Alice Johnson', '12345678', '2022-01-01 09:00', 'T001'),
('S002', 'Bob Smith', '87654321', '2022-02-15 10:30', 'T002'),
('S003', 'Charlie Brown', '98765432', '2022-03-10 11:15', 'T003'),
('S004', 'David Lee', '65432109', '2022-04-20 14:00', 'T004'),
('S005', 'Eve Adams', '32165498', '2022-05-05 16:45', 'T005'),
('S006', 'Frank White', '78901234', '2022-06-25 08:20', 'T001'),
('S007', 'Grace Kim', '56789012', '2022-07-12 18:00', 'T002'),
('S008', 'Henry Ford', '43210987', '2022-08-30 12:10', 'T003'),
('S009', 'Ivy Green', '21098765', '2022-09-14 13:30', 'T004'),
('S010', 'Jack Black', '10987654', '2022-10-01 15:45', 'T005'),
('S011', 'Karen Scott', '87654321', '2022-01-01 09:00', 'T001'),
('S012', 'Leo Turner', '65432109', '2022-02-15 10:30', 'T002'),
('S013', 'Mia Walker', '32165498', '2022-03-10 11:15', 'T003'),
('S014', 'Noah Hall', '78901234', '2022-04-20 14:00', 'T004'),
('S015', 'Olivia Adams', '56789012', '2022-05-05 16:45', 'T005'),
('S016', 'Peter King', '43210987', '2022-06-25 08:20', 'T001'),
('S017', 'Quinn Foster', '21098765', '2022-07-12 18:00', 'T002'),
('S018', 'Rachel Brown', '10987654', '2022-08-30 12:10', 'T003'),
('S019', 'Steve Martin', '98765432', '2022-09-14 13:30', 'T004'),
('S020', 'Tom Hardy', '12345678', '2022-10-01 15:45', 'T005');

-- Update Team Relation Date to set TeamLeaderID
UPDATE Team
SET TeamLeaderID = 'S001'
WHERE TeamID = 'T001';

UPDATE Team
SET TeamLeaderID = 'S002'
WHERE TeamID = 'T002';

UPDATE Team
SET TeamLeaderID = 'S003'
WHERE TeamID = 'T003';

UPDATE Team
SET TeamLeaderID = 'S004'
WHERE TeamID = 'T004';

UPDATE Team
SET TeamLeaderID = 'S005'
WHERE TeamID = 'T005';

-- Award Relation Data
INSERT INTO Award (AwardID, AwardName, AwardAmt) 
VALUES
('A001', 'Best Technical Support', 500.00),
('A002', 'Outstanding Customer Service', 500.00),
('A003', 'Team Excellence', 250.00);

-- Win Relation Data
INSERT INTO Win (AwardID, TeamID, DateAwarded) 
VALUES
('A001', 'T001', '2024-12-30'), 
('A002', 'T003', '2024-12-30'), 
('A003', 'T005', '2024-12-30'),
('A001', 'T002', '2023-12-30'), 
('A002', 'T003', '2023-12-30'),
('A003', 'T004', '2023-12-30'), 
('A001', 'T002', '2022-12-30'), 
('A002', 'T004', '2022-12-30'),
('A003', 'T005', '2022-12-30'); 

-- FeedbkCat Relation Data
INSERT INTO FeedbkCat (FbkCatID, FbkCatDesc)
VALUES 
('FC001', 'Technical Problem'),
('FC002', 'Problem with another User'),
('FC003', 'Problem with Listing'),
('FC004', 'Suggestion'),
('FC005', 'Billing Issue'),
('FC006', 'Delivery Delay'),
('FC007', 'Feedback on Product Quality'),
('FC008', 'App Performance Issue'),
('FC009', 'Payment Gateway Issue'),
('FC010', 'Feature Request'),
('FC011', 'Account Security Concern'),
('FC012', 'Inquiry about Orders'),
('FC013', 'Request for Refund'),
('FC014', 'App Crash Report'),
('FC015', 'Customer Service Feedback'),
('FC016', 'Order Cancellation Request'),
('FC017', 'Spam or Abuse Report'),
('FC018', 'Discount or Coupon Inquiry'),
('FC019', 'Complaint about Staff Behavior'),
('FC020', 'User Experience Enhancement');

-- Feedback Relation Data
INSERT INTO Feedback (FbkID, FbkDesc, FbkDateTime, FbkStatus, SatisfactionRank, FbkCatID, OnMemberID, ByMemberID, StaffID)
VALUES 
('F00001', 'Login failure issue', '2024-01-01 10:00:00', 'Pending', 4, 'FC001', NULL, '00002', 'S001'),
('F00002', 'Checkout page freezing', '2024-01-02 11:30:00', 'Receiving Attention', 3, 'FC002', NULL, '00004', 'S002'),
('F00003', 'Suggestion to improve UI', '2024-01-03 09:15:00', 'Completed', 5, 'FC004', NULL, '00006', 'S003'),
('F00004', 'Unable to reset password', '2024-01-04 14:00:00', 'Pending', 2, 'FC001', NULL, '00008', 'S004'),
('F00005', 'Payment not processing', '2024-01-05 16:45:00', 'Receiving Attention', 3, 'FC002', NULL, '00010', 'S005'),
('F00006', 'Product description not clear', '2024-01-06 18:20:00', 'Completed', 5, 'FC004', '00011', '00012', 'S006'),
('F00007', 'Report user for misconduct', '2024-01-07 08:00:00', 'Pending', 1, 'FC003', '00013', '00014', 'S007'),
('F00008', 'Refund request delay', '2024-01-08 12:10:00', 'Receiving Attention', 4, 'FC002', NULL, '00016', 'S008'),
('F00009', 'Slow loading time', '2024-01-09 13:30:00', 'Completed', 5, 'FC001', NULL, '00018', 'S009'),
('F00010', 'Duplicate listing issue', '2024-01-10 15:45:00', 'Pending', 2, 'FC003', '00019', '00020', 'S010'),
('F00011', 'Login timeout error', '2024-01-11 09:00:00', 'Receiving Attention', 3, 'FC001', NULL, '00001', 'S001'),
('F00012', 'Recommendation for delivery options', '2024-01-12 11:20:00', 'Completed', 5, 'FC004', NULL, '00002', 'S002'),
('F00013', 'Wrong product delivered', '2024-01-13 16:10:00', 'Pending', 3, 'FC002', '00018', '00003', 'S003'),
('F00014', 'Profile update issue', '2024-01-14 14:25:00', 'Receiving Attention', 4, 'FC001', NULL, '00004', 'S004'),
('F00015', 'Spam messages received', '2024-01-15 18:45:00', 'Completed', 5, 'FC003', '00016', '00005', 'S005'),
('F00016', 'Inquiry about promotions', '2024-01-16 08:50:00', 'Pending', 2, 'FC004', NULL, '00006', 'S006'),
('F00017', 'App crashing frequently', '2024-01-17 10:35:00', 'Receiving Attention', 3, 'FC001', NULL, '00007', 'S007'),
('F00018', 'Late delivery complaint', '2024-01-18 12:40:00', 'Completed', 4, 'FC002', '00013', '00008', 'S008'),
('F00019', 'Dark mode feature request', '2024-01-19 15:30:00', 'Pending', 5, 'FC004', NULL, '00009', 'S009'),
('F00020', 'Payment gateway error', '2024-01-20 17:15:00', 'Receiving Attention', 3, 'FC002', NULL, '00010', 'S010');

--Bump Relation Content
INSERT INTO Bump (BumpID, BumpDesc, BumpPrice)
VALUES
('O','One time bump', 3.00),
('D3','Daily Bump for 3 Days', 8.00),
('T3','Twice a Day Bump for 3 Days', 15.00),
('D7', 'Daily Bump for 7 Days', 12.50);

--BumpOrder Relation Content
INSERT INTO BumpOrder (BumpOrderID, PurchaseDate, BumpID, ListingID, SellerID)
VALUES
('B00001', '2024-01-14 10:00:00', 'D7', 'L00001', '00002'),
('B00002', '2024-02-15 14:30:00', 'O', 'L00002', '00005'),
('B00003', '2024-02-25 17:20:00', 'O', 'L00003', '00002'),
('B00004', '2024-03-05 09:50:00', 'T3', 'L00004', '00010'),
('B00005', '2024-03-12 10:00:00', 'T3', 'L00005', '00010'),
('B00006', '2024-03-22 12:15:00', 'D3', 'L00006', '00004'),
('B00007', '2024-04-08 11:30:00', 'D3', 'L00007', '00002'),
('B00008', '2024-04-19 11:05:00', 'D7', 'L00008', '00008'),
('B00009', '2024-05-01 14:10:00', 'D7', 'L00009', '00010'),
('B00010', '2024-05-22 12:15:00', 'D3', 'L00010', '00005'),
('B00011', '2024-06-03 13:05:00', 'O', 'L00011', '00012'),
('B00012', '2024-06-10 16:00:00', 'D7', 'L00012', '00006'),
('B00013', '2024-07-17 16:50:00', 'T3', 'L00013', '00010'),
('B00014', '2024-07-21 14:30:00', 'D3', 'L00014', '00012'),
('B00015', '2024-08-18 18:45:00', 'O', 'L00015', '00016'),
('B00016', '2024-08-22 18:25:00', 'D3', 'L00016', '00014'),
('B00017', '2024-09-18 10:45:00', 'O', 'L00017', '00018'),
('B00018', '2024-09-22 09:30:00', 'T3', 'L00018', '00015'),
('B00019', '2024-10-23 08:25:00', 'O', 'L00019', '00006'),
('B00020', '2024-10-30 12:35:00', 'D7', 'L00020', '00016');

-- Chat Relation Data
INSERT INTO Chat (ChatID, BuyerID, ListingID)
VALUES
('C00001', '00001', 'L00012'),
('C00002', '00009', 'L00007'),
('C00003', '00020', 'L00014'),
('C00004', '00001', 'L00039'),
('C00005', '00005', 'L00023'),
('C00006', '00013', 'L00011'),
('C00007', '00019', 'L00001'),
('C00008', '00003', 'L00017'),
('C00009', '00015', 'L00011'),
('C00010', '00007', 'L00005'),
('C00011', '00011', 'L00040'),
('C00012', '00003', 'L00022'),
('C00013', '00009', 'L00028'),
('C00014', '00010', 'L00031'),
('C00015', '00017', 'L00004'),
('C00016', '00020', 'L00013'),
('C00017', '00005', 'L00006'),
('C00018', '00013', 'L00024'),
('C00019', '00007', 'L00033'),
('C00020', '00015', 'L00005');

-- ChatMsg Relation Data
INSERT INTO ChatMsg (ChatID, MsgSN, MsgDateTime, Originator, Msg)
VALUES
('C00001', '1', '2024-05-11 19:40:00', 'B', 'How long the warranty?'),
('C00001', '2', '2024-05-11 19:53:00', 'S', 'Very long still have one month.'),
('C00001', '3', '2024-05-11 19:57:00', 'B', 'One month only too short.'),
('C00001', '4', '2024-05-11 19:57:00', 'B', 'Sorry I do not want the Nintendo Switch OLED anymore.'),
('C00001', '5', '2024-05-11 19:59:00', 'S', 'No problem.'),
('C00002', '1', '2024-03-19 09:00:00', 'B', 'Is this still available?'),
('C00002', '2', '2024-03-19 09:05:00', 'S', 'Yes, it’s available.'),
('C00002', '3', '2024-03-19 09:10:00', 'B', 'Can I negotiate the price? $100?'),
('C00002', '4', '2024-03-19 09:15:00', 'S', 'I can lower it to $110.'),
('C00002', '5', '2024-03-19 09:20:00', 'B', 'Sorry, nevermind.'),
('C00003', '1', '2024-06-22 09:00:00', 'B', 'Hello! Are these pens still available?'),
('C00003', '2', '2024-06-22 09:05:00', 'S', 'Yes, they are.'),
('C00003', '3', '2024-06-22 09:10:00', 'B', 'How much is the shipping cost?'),
('C00003', '4', '2024-06-22 09:15:00', 'S', 'Shipping is $3 within Singapore.'),
('C00003', '5', '2024-06-22 09:20:00', 'B', 'Alright, I’ll order. How can I pay?'),
('C00004', '1', '2025-01-24 22:00:00', 'B', 'Hi! Is the textbook still available?'),
('C00004', '2', '2025-01-24 22:05:00', 'S', 'Yes, it is.'),
('C00004', '3', '2025-01-24 22:10:00', 'B', 'Is it in good condition?'),
('C00004', '4', '2025-01-24 22:15:00', 'S', 'Yes, no torn pages or markings.'),
('C00005', '1', '2025-01-25 20:30:00', 'B', 'Is this set brand new?'),
('C00005', '2', '2025-01-25 20:35:00', 'S', 'Yes, it’s brand new and sealed.'),
('C00005', '3', '2025-01-25 20:40:00', 'B', 'Can you deliver it to Tampines?'),
('C00005', '4', '2025-01-25 20:45:00', 'S', 'Yes, I can deliver for an additional $10.'),
('C00005', '5', '2025-01-25 20:50:00', 'B', 'Alright, $10 is fine. Let’s confirm the delivery time.'),
('C00005', '6', '2025-01-25 20:55:00', 'S', 'Okay, let’s do it tomorrow afternoon.'),
('C00006', '1', '2024-05-02 12:00:00', 'B', 'Hi! Is the shoe still available?'),
('C00006', '2', '2024-05-02 12:05:00', 'S', 'Yes, it is.'),
('C00006', '3', '2024-05-02 12:10:00', 'B', 'What size is it?'),
('C00006', '4', '2024-05-02 12:15:00', 'S', 'It’s size US 10.'),
('C00006', '5', '2024-05-02 12:20:00', 'B', 'Perfect. Let’s meet to complete the deal.'),
('C00006', '6', '2024-05-02 12:25:00', 'S', 'Sure. How about tomorrow at noon?'),
('C00007', '1', '2024-01-01 12:00:00', 'B', 'Is this set complete with all the books?'),
('C00007', '2', '2024-01-01 12:05:00', 'S', 'Yes, all seven books are included.'),
('C00008', '1', '2024-08-01 16:00:00', 'B', 'Are these toys authentic Disney products?'),
('C00008', '2', '2024-08-01 16:05:00', 'S', 'Yes, they are official merchandise.'),
('C00009', '1', '2024-05-02 13:00:00', 'B', 'Can I get this at $90?'),
('C00009', '2', '2024-05-02 13:05:00', 'S', 'Sorry, the price is fixed at $100.'),
('C00010', '1', '2024-02-25 08:00:00', 'B', 'Is this still available?'),
('C00010', '2', '2024-02-25 08:05:00', 'S', 'Yes, it’s available.'),
('C00010', '3', '2024-02-25 08:10:00', 'B', 'Alright, I’ll take it.'),
('C00011', '1', '2025-01-25 19:00:00', 'B', 'Can you lower the price to $140?'),
('C00011', '2', '2025-01-25 19:05:00', 'S', 'Sorry, it’s firm at $150.'),
('C00012', '1', '2024-10-07 13:00:00', 'B', 'How many packs are included in this price?'),
('C00012', '2', '2024-10-07 13:05:00', 'S', 'The price is for 5 packs.'),
('C00013', '1', '2024-11-22 09:00:00', 'B', 'Is the colour as shown in the photo?'),
('C00013', '2', '2024-11-22 09:05:00', 'S', 'Yes, it’s the same.'),
('C00014', '1', '2024-12-13 05:00:00', 'B', 'Are these pens suitable for all fabric types?'),
('C00014', '2', '2024-12-13 05:05:00', 'S', 'Yes, they are safe for all fabrics.'),
('C00015', '1', '2024-02-25 08:00:00', 'B', 'What size is this shirt?'),
('C00015', '2', '2024-02-25 08:05:00', 'S', 'It’s size L.'),
('C00016', '1', '2024-06-01 04:00:00', 'B', 'Hi! Is the jacket still available?'),
('C00016', '2', '2024-06-01 04:05:00', 'S', 'Yes, it’s available.'),
('C00017', '1', '2024-03-01 06:00:00', 'B', 'Is this a complete set of the game?'),
('C00017', '2', '2024-03-01 06:05:00', 'S', 'Yes, it includes all the cards.'),
('C00018', '1', '2024-10-30 16:00:00', 'B', 'Are these books in good condition?'),
('C00018', '2', '2024-10-30 16:05:00', 'S', 'Yes, no damages or marks.'),
('C00019', '1', '2024-12-23 03:00:00', 'B', 'Are the headphones wireless or wired?'),
('C00019', '2', '2024-12-23 03:05:00', 'S', 'They are wired headphones.'),
('C00020', '1', '2024-02-25 08:15:00', 'B', 'Can I confirm the dimensions of the model?'),
('C00020', '2', '2024-02-25 08:20:00', 'S', 'It’s 10 inches long.'),
('C00020', '3', '2024-02-25 08:25:00', 'B', 'Alright, thanks.');

-- 1 -- 
SELECT * FROM Category
-- 2 --
SELECT * FROM SubCategory
-- 3 -- 
SELECT * FROM Member
-- 4 -- 
SELECT * FROM Follower
-- 5 -- 
SELECT * FROM Buyer
-- 6 -- 
SELECT * FROM Seller
-- 7 -- 
SELECT * FROM Listing
-- 8 -- 
SELECT * FROM ListingPhoto
-- 9 -- 
SELECT * FROM Likes
-- 10 -- 
SELECT * FROM Offer
-- 11 -- 
SELECT * FROM Review
-- 12 -- 
SELECT * FROM Team
-- 13 -- 
SELECT * FROM Staff
-- 14 -- 
SELECT * FROM Award
-- 15 -- 
SELECT * FROM Win
-- 16 -- 
SELECT * FROM FeedbkCat
-- 17 -- 
SELECT * FROM Feedback
-- 18 -- 
SELECT * FROM Bump
-- 19 -- 
SELECT * FROM BumpOrder
-- 20 -- 
SELECT * FROM Chat
-- 21 -- 
SELECT * FROM ChatMsg


