USE [master]
GO
/****** Object:  Database [Hotel_Realta]    Script Date: 13/11/2023 17:39:52 ******/
CREATE DATABASE [Hotel_Realta]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Hotel_Realta', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\Hotel_Realta.mdf' , SIZE = 73728KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'Hotel_Realta_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\Hotel_Realta_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [Hotel_Realta] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Hotel_Realta].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [Hotel_Realta] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [Hotel_Realta] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [Hotel_Realta] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [Hotel_Realta] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [Hotel_Realta] SET ARITHABORT OFF 
GO
ALTER DATABASE [Hotel_Realta] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [Hotel_Realta] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [Hotel_Realta] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [Hotel_Realta] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [Hotel_Realta] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [Hotel_Realta] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [Hotel_Realta] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [Hotel_Realta] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [Hotel_Realta] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [Hotel_Realta] SET  ENABLE_BROKER 
GO
ALTER DATABASE [Hotel_Realta] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [Hotel_Realta] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [Hotel_Realta] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [Hotel_Realta] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [Hotel_Realta] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [Hotel_Realta] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [Hotel_Realta] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [Hotel_Realta] SET RECOVERY FULL 
GO
ALTER DATABASE [Hotel_Realta] SET  MULTI_USER 
GO
ALTER DATABASE [Hotel_Realta] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [Hotel_Realta] SET DB_CHAINING OFF 
GO
ALTER DATABASE [Hotel_Realta] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [Hotel_Realta] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [Hotel_Realta] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [Hotel_Realta] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'Hotel_Realta', N'ON'
GO
ALTER DATABASE [Hotel_Realta] SET QUERY_STORE = ON
GO
ALTER DATABASE [Hotel_Realta] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [Hotel_Realta]
GO
/****** Object:  Schema [Booking]    Script Date: 13/11/2023 17:39:52 ******/
CREATE SCHEMA [Booking]
GO
/****** Object:  Schema [Hotel]    Script Date: 13/11/2023 17:39:52 ******/
CREATE SCHEMA [Hotel]
GO
/****** Object:  Schema [HR]    Script Date: 13/11/2023 17:39:52 ******/
CREATE SCHEMA [HR]
GO
/****** Object:  Schema [Master]    Script Date: 13/11/2023 17:39:52 ******/
CREATE SCHEMA [Master]
GO
/****** Object:  Schema [Payment]    Script Date: 13/11/2023 17:39:52 ******/
CREATE SCHEMA [Payment]
GO
/****** Object:  Schema [Purchasing]    Script Date: 13/11/2023 17:39:52 ******/
CREATE SCHEMA [Purchasing]
GO
/****** Object:  Schema [Resto]    Script Date: 13/11/2023 17:39:52 ******/
CREATE SCHEMA [Resto]
GO
/****** Object:  Schema [Users]    Script Date: 13/11/2023 17:39:52 ******/
CREATE SCHEMA [Users]
GO
/****** Object:  UserDefinedFunction [Payment].[fnFormatedTransactionId]    Script Date: 13/11/2023 17:39:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Harpi
-- Create date: 13 Februari 2023
-- Description:	User defined function, formattedIdTransaction
-- =============================================
CREATE FUNCTION [Payment].[fnFormatedTransactionId](@transaction_id INT, @transaction_type NCHAR(5))
    RETURNS VARCHAR(55)
    AS BEGIN
        DECLARE @trx_number VARCHAR(55);
        SET @trx_number = CONCAT(TRIM(@transaction_type),'#',
                      CONVERT(varchar, GETDATE(), 12),'-',
                        RIGHT('0000' + CAST(@transaction_id AS NVARCHAR(4)), 4));
        RETURN @trx_number;
    END

GO
/****** Object:  UserDefinedFunction [Payment].[fnRefundAmount]    Script Date: 13/11/2023 17:39:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Harpi
-- Create date: 13 Februari 2023
-- Description:	User defined function, fnRefundAmount
-- =============================================
CREATE FUNCTION [Payment].[fnRefundAmount](@amount MONEY, @percentage FLOAT = 50.0)
    RETURNS MONEY
    BEGIN
        DECLARE @refund_amount MONEY
        DECLARE @refund_percentage FLOAT

        SET @refund_percentage = @percentage / 100.0;
        SET @refund_amount = @amount * @refund_percentage;

        RETURN @refund_amount
    END

GO
/****** Object:  Table [Payment].[entity]    Script Date: 13/11/2023 17:39:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Payment].[entity](
	[entity_id] [int] IDENTITY(1,1) NOT NULL,
 CONSTRAINT [PK_PaymentEntityId] PRIMARY KEY CLUSTERED 
(
	[entity_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Payment].[bank]    Script Date: 13/11/2023 17:39:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Payment].[bank](
	[bank_entity_id] [int] NOT NULL,
	[bank_code] [nvarchar](10) NOT NULL,
	[bank_name] [nvarchar](55) NOT NULL,
	[bank_modified_date] [datetime] NULL,
 CONSTRAINT [PK_PaymentBankEntityId] PRIMARY KEY CLUSTERED 
(
	[bank_entity_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Payment].[payment_gateway]    Script Date: 13/11/2023 17:39:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Payment].[payment_gateway](
	[paga_entity_id] [int] NOT NULL,
	[paga_code] [nvarchar](10) NOT NULL,
	[paga_name] [nvarchar](55) NOT NULL,
	[paga_modified_date] [datetime] NULL,
 CONSTRAINT [PK_PaymentGatewayEntityId] PRIMARY KEY CLUSTERED 
(
	[paga_entity_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [Payment].[fnGetAllPaymentType]    Script Date: 13/11/2023 17:39:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Harpi
-- Create date: 13 Februari 2023
-- Description:	User Defined Function, getAllPaymentType
-- =============================================
CREATE   FUNCTION [Payment].[fnGetAllPaymentType]()
    RETURNS TABLE
     AS
        RETURN
            SELECT en.entity_id Id,
                   CONCAT(ba.bank_code, pg.paga_code) Code,
                   CONCAT(bank_name, paga_name) Name
            FROM Payment.entity en
            LEFT JOIN Payment.bank ba
                ON en.entity_id = ba.bank_entity_id
            LEFT JOIN Payment.payment_gateway pg
                ON en.entity_id = pg.paga_entity_id
            WHERE pg.paga_code IS NOT NULL OR ba.bank_code IS NOT NULL;

GO
/****** Object:  Table [Users].[users]    Script Date: 13/11/2023 17:39:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Users].[users](
	[user_id] [int] IDENTITY(1,1) NOT NULL,
	[user_full_name] [nvarchar](55) NOT NULL,
	[user_type] [nvarchar](15) NULL,
	[user_company_name] [nvarchar](255) NULL,
	[user_email] [nvarchar](256) NULL,
	[user_phone_number] [nvarchar](25) NOT NULL,
	[user_modified_date] [datetime] NULL,
 CONSTRAINT [pk_user_id] PRIMARY KEY CLUSTERED 
(
	[user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Payment].[user_accounts]    Script Date: 13/11/2023 17:39:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Payment].[user_accounts](
	[usac_id] [int] IDENTITY(1,1) NOT NULL,
	[usac_entity_id] [int] NOT NULL,
	[usac_user_id] [int] NOT NULL,
	[usac_account_number] [varchar](25) NOT NULL,
	[usac_saldo] [money] NULL,
	[usac_type] [nvarchar](15) NULL,
	[usac_expmonth] [tinyint] NULL,
	[usac_expyear] [smallint] NULL,
	[usac_modified_date] [datetime] NULL,
 CONSTRAINT [PK_PaymentUserAccountsEntityId] PRIMARY KEY CLUSTERED 
(
	[usac_user_id] ASC,
	[usac_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [Payment].[fnGetUserBalance]    Script Date: 13/11/2023 17:39:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Harpi
-- Create date: 13 Februari 2023
-- Description:	User Defined Function, getUserBalance
-- =============================================
CREATE   FUNCTION [Payment].[fnGetUserBalance](@user_id INT)
    RETURNS TABLE
    AS
        RETURN
            SELECT user_id,
                   user_full_name,
                   usac.usac_type,
                   usac_account_number,
                   usac_saldo,
                   CONCAT(paga.paga_name, ba.bank_name) AS payment_name
            FROM users.users
            RIGHT JOIN payment.user_accounts usac
            ON users.user_id = usac.usac_user_id
            RIGHT JOIN payment.entity ent
            ON usac.usac_entity_id = ent.entity_id
            LEFT JOIN payment.payment_gateway paga
            ON ent.entity_id = paga.paga_entity_id
            LEFT JOIN Payment.bank ba
            ON ba.bank_entity_id = ent.entity_id
            WHERE usac_type IS NOT NULL AND usac_user_id = @user_id
;

GO
/****** Object:  Table [Booking].[booking_order_detail]    Script Date: 13/11/2023 17:39:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Booking].[booking_order_detail](
	[borde_boor_id] [int] NOT NULL,
	[borde_id] [int] IDENTITY(1,1) NOT NULL,
	[borde_checkin] [datetime] NOT NULL,
	[borde_checkout] [datetime] NOT NULL,
	[borde_adults] [int] NULL,
	[borde_kids] [int] NULL,
	[borde_price] [money] NULL,
	[borde_extra] [money] NULL,
	[borde_discount] [smallmoney] NULL,
	[borde_tax] [smallmoney] NULL,
	[borde_subtotal]  AS (([borde_price]+[borde_price]*[borde_tax])-[borde_price]*[borde_discount]),
	[borde_faci_id] [int] NULL,
 CONSTRAINT [pk_borde_id_boor_id] PRIMARY KEY CLUSTERED 
(
	[borde_id] ASC,
	[borde_boor_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Booking].[booking_order_detail_extra]    Script Date: 13/11/2023 17:39:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Booking].[booking_order_detail_extra](
	[boex_id] [int] IDENTITY(1,1) NOT NULL,
	[boex_price] [money] NULL,
	[boex_qty] [smallint] NULL,
	[boex_subtotal]  AS ([boex_price]*[boex_qty]),
	[boex_measure_unit] [nvarchar](50) NULL,
	[boex_borde_id] [int] NULL,
	[boex_prit_id] [int] NULL,
 CONSTRAINT [pk_boex_id] PRIMARY KEY CLUSTERED 
(
	[boex_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Booking].[booking_orders]    Script Date: 13/11/2023 17:39:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Booking].[booking_orders](
	[boor_id] [int] IDENTITY(1,1) NOT NULL,
	[boor_order_number] [nvarchar](55) NOT NULL,
	[boor_order_date] [datetime] NULL,
	[boor_arrival_date] [datetime] NULL,
	[boor_total_room] [smallint] NULL,
	[boor_total_guest] [smallint] NULL,
	[boor_discount] [money] NULL,
	[boor_total_tax] [money] NULL,
	[boor_total_ammount] [money] NULL,
	[boor_down_payment] [money] NULL,
	[boor_pay_type] [nchar](2) NOT NULL,
	[boor_is_paid] [nchar](2) NOT NULL,
	[boor_type] [nvarchar](15) NOT NULL,
	[boor_cardnumber] [nvarchar](25) NULL,
	[boor_member_type] [nvarchar](15) NULL,
	[boor_status] [nvarchar](15) NULL,
	[boor_user_id] [int] NULL,
	[boor_hotel_id] [int] NULL,
 CONSTRAINT [pk_boor_id] PRIMARY KEY CLUSTERED 
(
	[boor_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Booking].[special_offer_coupons]    Script Date: 13/11/2023 17:39:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Booking].[special_offer_coupons](
	[soco_id] [int] IDENTITY(1,1) NOT NULL,
	[soco_borde_id] [int] NULL,
	[soco_spof_id] [int] NULL,
 CONSTRAINT [pk_soco_id] PRIMARY KEY CLUSTERED 
(
	[soco_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Booking].[special_offers]    Script Date: 13/11/2023 17:39:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Booking].[special_offers](
	[spof_id] [int] IDENTITY(1,1) NOT NULL,
	[spof_name] [nvarchar](55) NOT NULL,
	[spof_description] [nvarchar](255) NOT NULL,
	[spof_type] [char](5) NOT NULL,
	[spof_discount] [smallmoney] NOT NULL,
	[spof_start_date] [datetime] NOT NULL,
	[spof_end_date] [datetime] NOT NULL,
	[spof_min_qty] [int] NULL,
	[spof_max_qty] [int] NULL,
	[spof_modified_date] [datetime] NULL,
 CONSTRAINT [pk_spof_id] PRIMARY KEY CLUSTERED 
(
	[spof_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Booking].[user_breakfast]    Script Date: 13/11/2023 17:39:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Booking].[user_breakfast](
	[usbr_borde_id] [int] NOT NULL,
	[usbr_modified_date] [date] NOT NULL,
	[usbr_total_vacant] [smallint] NOT NULL,
 CONSTRAINT [pk_usbr_borde_id_usbr_modified_date] PRIMARY KEY CLUSTERED 
(
	[usbr_borde_id] ASC,
	[usbr_modified_date] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Hotel].[Facilities]    Script Date: 13/11/2023 17:39:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Hotel].[Facilities](
	[faci_id] [int] IDENTITY(1,1) NOT NULL,
	[faci_name] [nvarchar](125) NOT NULL,
	[faci_description] [nvarchar](255) NULL,
	[faci_max_number] [int] NULL,
	[faci_measure_unit] [varchar](15) NULL,
	[faci_room_number] [nvarchar](15) NOT NULL,
	[faci_startdate] [datetime] NOT NULL,
	[faci_enddate] [datetime] NOT NULL,
	[faci_low_price] [money] NOT NULL,
	[faci_high_price] [money] NOT NULL,
	[faci_rate_price] [money] NULL,
	[faci_expose_price] [tinyint] NOT NULL,
	[faci_discount] [smallmoney] NULL,
	[faci_tax_rate] [smallmoney] NULL,
	[faci_modified_date] [datetime] NULL,
	[faci_cagro_id] [int] NOT NULL,
	[faci_hotel_id] [int] NOT NULL,
	[faci_user_id] [int] NOT NULL,
 CONSTRAINT [faci_id_pk] PRIMARY KEY CLUSTERED 
(
	[faci_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Hotel].[Facility_Photos]    Script Date: 13/11/2023 17:39:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Hotel].[Facility_Photos](
	[fapho_id] [int] IDENTITY(1,1) NOT NULL,
	[fapho_photo_filename] [nvarchar](150) NULL,
	[fapho_thumbnail_filename] [nvarchar](150) NOT NULL,
	[fapho_original_filename] [nvarchar](150) NULL,
	[fapho_file_size] [smallint] NULL,
	[fapho_file_type] [nvarchar](50) NULL,
	[fapho_primary] [bit] NULL,
	[fapho_url] [nvarchar](255) NULL,
	[fapho_modified_date] [datetime] NULL,
	[fapho_faci_id] [int] NOT NULL,
 CONSTRAINT [fapho_id_pk] PRIMARY KEY CLUSTERED 
(
	[fapho_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Hotel].[facility_price_history]    Script Date: 13/11/2023 17:39:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Hotel].[facility_price_history](
	[faph_id] [int] IDENTITY(1,1) NOT NULL,
	[faph_startdate] [datetime] NOT NULL,
	[faph_enddate] [datetime] NOT NULL,
	[faph_low_price] [money] NOT NULL,
	[faph_high_price] [money] NOT NULL,
	[faph_rate_price] [money] NOT NULL,
	[faph_discount] [smallmoney] NULL,
	[faph_tax_rate] [smallmoney] NULL,
	[faph_modified_date] [datetime] NULL,
	[faph_faci_id] [int] NOT NULL,
	[faph_user_id] [int] NOT NULL,
 CONSTRAINT [faph_id_pk] PRIMARY KEY CLUSTERED 
(
	[faph_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Hotel].[Hotel_Reviews]    Script Date: 13/11/2023 17:39:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Hotel].[Hotel_Reviews](
	[hore_id] [int] IDENTITY(1,1) NOT NULL,
	[hore_user_review] [nvarchar](125) NOT NULL,
	[hore_rating] [tinyint] NOT NULL,
	[hore_created_on] [datetime] NULL,
	[hore_user_id] [int] NOT NULL,
	[hore_hotel_id] [int] NOT NULL,
 CONSTRAINT [hore_id_pk] PRIMARY KEY CLUSTERED 
(
	[hore_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Hotel].[Hotels]    Script Date: 13/11/2023 17:39:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Hotel].[Hotels](
	[hotel_id] [int] IDENTITY(1,1) NOT NULL,
	[hotel_name] [nvarchar](85) NOT NULL,
	[hotel_description] [nvarchar](500) NULL,
	[hotel_status] [bit] NOT NULL,
	[hotel_reason_status] [nvarchar](500) NULL,
	[hotel_rating_star] [numeric](2, 1) NULL,
	[hotel_phonenumber] [nvarchar](25) NOT NULL,
	[hotel_modified_date] [datetime] NULL,
	[hotel_addr_id] [int] NOT NULL,
	[hotel_addr_description] [nvarchar](500) NULL,
 CONSTRAINT [hotel_id_pk] PRIMARY KEY CLUSTERED 
(
	[hotel_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [HR].[department]    Script Date: 13/11/2023 17:39:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [HR].[department](
	[dept_id] [int] IDENTITY(1,1) NOT NULL,
	[dept_name] [nvarchar](50) NOT NULL,
	[dept_modified_date] [datetime] NULL,
 CONSTRAINT [pk_dept_id] PRIMARY KEY CLUSTERED 
(
	[dept_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [HR].[employee]    Script Date: 13/11/2023 17:39:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [HR].[employee](
	[emp_id] [int] IDENTITY(1,1) NOT NULL,
	[emp_national_id] [nvarchar](25) NOT NULL,
	[emp_birth_date] [datetime] NOT NULL,
	[emp_marital_status] [nchar](1) NOT NULL,
	[emp_gender] [nchar](1) NOT NULL,
	[emp_hire_date] [datetime] NOT NULL,
	[emp_salaried_flag] [nchar](1) NOT NULL,
	[emp_vacation_hours] [int] NULL,
	[emp_sickleave_hourse] [int] NULL,
	[emp_current_flag] [int] NULL,
	[emp_emp_id] [int] NULL,
	[emp_photo] [nvarchar](255) NULL,
	[emp_modified_date] [datetime] NULL,
	[emp_joro_id] [int] NOT NULL,
 CONSTRAINT [pk_emp_id] PRIMARY KEY CLUSTERED 
(
	[emp_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [HR].[employee_department_history]    Script Date: 13/11/2023 17:39:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [HR].[employee_department_history](
	[edhi_id] [int] IDENTITY(1,1) NOT NULL,
	[edhi_emp_id] [int] NOT NULL,
	[edhi_start_date] [datetime] NULL,
	[edhi_end_date] [datetime] NULL,
	[edhi_modified_date] [datetime] NULL,
	[edhi_dept_id] [int] NOT NULL,
	[edhi_shift_id] [int] NOT NULL,
 CONSTRAINT [pk_edhi_id_edhi_emp_id] PRIMARY KEY CLUSTERED 
(
	[edhi_id] ASC,
	[edhi_emp_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [HR].[employee_pay_history]    Script Date: 13/11/2023 17:39:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [HR].[employee_pay_history](
	[ephi_emp_id] [int] NOT NULL,
	[ephi_rate_change_date] [datetime] NOT NULL,
	[ephi_rate_salary] [money] NULL,
	[ephi_pay_frequence] [int] NULL,
	[ephi_modified_date] [datetime] NULL,
 CONSTRAINT [pk_ephi_emp_id_ephi_rate_change_date] PRIMARY KEY CLUSTERED 
(
	[ephi_emp_id] ASC,
	[ephi_rate_change_date] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [HR].[job_role]    Script Date: 13/11/2023 17:39:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [HR].[job_role](
	[joro_id] [int] IDENTITY(1,1) NOT NULL,
	[joro_name] [nvarchar](55) NOT NULL,
	[joro_modified_date] [datetime] NULL,
 CONSTRAINT [pk_joro_id] PRIMARY KEY CLUSTERED 
(
	[joro_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [HR].[shift]    Script Date: 13/11/2023 17:39:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [HR].[shift](
	[shift_id] [int] IDENTITY(1,1) NOT NULL,
	[shift_name] [nvarchar](25) NOT NULL,
	[shift_start_time] [datetime] NOT NULL,
	[shift_end_time] [datetime] NOT NULL,
 CONSTRAINT [pk_shift_id] PRIMARY KEY CLUSTERED 
(
	[shift_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [HR].[work_order_detail]    Script Date: 13/11/2023 17:39:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [HR].[work_order_detail](
	[wode_id] [int] IDENTITY(1,1) NOT NULL,
	[wode_task_name] [nvarchar](255) NULL,
	[wode_status] [nvarchar](15) NULL,
	[wode_start_date] [datetime] NULL,
	[wode_end_date] [datetime] NULL,
	[wode_notes] [nvarchar](255) NULL,
	[wode_emp_id] [int] NULL,
	[wode_seta_id] [int] NULL,
	[wode_faci_id] [int] NULL,
	[wode_woro_id] [int] NULL,
 CONSTRAINT [pk_wode_id] PRIMARY KEY CLUSTERED 
(
	[wode_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [HR].[work_orders]    Script Date: 13/11/2023 17:39:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [HR].[work_orders](
	[woro_id] [int] IDENTITY(1,1) NOT NULL,
	[woro_date] [datetime] NOT NULL,
	[woro_status] [nvarchar](15) NOT NULL,
	[woro_user_id] [int] NULL,
 CONSTRAINT [pk_woro_id] PRIMARY KEY CLUSTERED 
(
	[woro_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Master].[address]    Script Date: 13/11/2023 17:39:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Master].[address](
	[addr_id] [int] IDENTITY(1,1) NOT NULL,
	[addr_line1] [nvarchar](255) NOT NULL,
	[addr_line2] [nvarchar](255) NULL,
	[addr_city] [nvarchar](25) NOT NULL,
	[addr_postal_code] [nvarchar](5) NULL,
	[addr_spatial_location] [nvarchar](100) NULL,
	[addr_prov_id] [int] NULL,
 CONSTRAINT [pk_addr_id] PRIMARY KEY CLUSTERED 
(
	[addr_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Master].[category_group]    Script Date: 13/11/2023 17:39:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Master].[category_group](
	[cagro_id] [int] IDENTITY(1,1) NOT NULL,
	[cagro_name] [nvarchar](25) NOT NULL,
	[cagro_description] [nvarchar](255) NULL,
	[cagro_type] [nvarchar](25) NOT NULL,
	[cagro_icon] [nvarchar](255) NULL,
	[cagro_icon_url] [nvarchar](255) NULL,
 CONSTRAINT [pk_cagro_id] PRIMARY KEY CLUSTERED 
(
	[cagro_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Master].[country]    Script Date: 13/11/2023 17:39:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Master].[country](
	[country_id] [int] IDENTITY(1,1) NOT NULL,
	[country_name] [nvarchar](55) NOT NULL,
	[country_region_id] [int] NULL,
 CONSTRAINT [pk_country_id] PRIMARY KEY CLUSTERED 
(
	[country_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Master].[members]    Script Date: 13/11/2023 17:39:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Master].[members](
	[memb_name] [nvarchar](15) NOT NULL,
	[memb_description] [nvarchar](255) NULL,
 CONSTRAINT [pk_memb_name] PRIMARY KEY CLUSTERED 
(
	[memb_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Master].[policy]    Script Date: 13/11/2023 17:39:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Master].[policy](
	[poli_id] [int] IDENTITY(1,1) NOT NULL,
	[poli_name] [nvarchar](55) NOT NULL,
	[poli_description] [nvarchar](255) NULL,
 CONSTRAINT [pk_poli_id] PRIMARY KEY CLUSTERED 
(
	[poli_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Master].[policy_category_group]    Script Date: 13/11/2023 17:39:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Master].[policy_category_group](
	[poca_poli_id] [int] NOT NULL,
	[poca_cagro_id] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [Master].[price_items]    Script Date: 13/11/2023 17:39:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Master].[price_items](
	[prit_id] [int] IDENTITY(1,1) NOT NULL,
	[prit_name] [nvarchar](55) NOT NULL,
	[prit_price] [money] NOT NULL,
	[prit_description] [nvarchar](255) NULL,
	[prit_type] [nvarchar](15) NOT NULL,
	[prit_icon_url] [nvarchar](255) NULL,
	[prit_modified_date] [datetime] NULL,
 CONSTRAINT [pk_prit_id] PRIMARY KEY CLUSTERED 
(
	[prit_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Master].[provinces]    Script Date: 13/11/2023 17:39:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Master].[provinces](
	[prov_id] [int] IDENTITY(1,1) NOT NULL,
	[prov_name] [nvarchar](85) NOT NULL,
	[prov_country_id] [int] NULL,
 CONSTRAINT [pk_prov_id] PRIMARY KEY CLUSTERED 
(
	[prov_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Master].[regions]    Script Date: 13/11/2023 17:39:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Master].[regions](
	[region_code] [int] IDENTITY(1,1) NOT NULL,
	[region_name] [nvarchar](35) NOT NULL,
 CONSTRAINT [pk_region_code] PRIMARY KEY CLUSTERED 
(
	[region_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Master].[service_task]    Script Date: 13/11/2023 17:39:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Master].[service_task](
	[seta_id] [int] IDENTITY(1,1) NOT NULL,
	[seta_name] [nvarchar](85) NOT NULL,
	[seta_seq] [smallint] NULL,
 CONSTRAINT [pk_set_id] PRIMARY KEY CLUSTERED 
(
	[seta_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Payment].[payment_transaction]    Script Date: 13/11/2023 17:39:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Payment].[payment_transaction](
	[patr_id] [int] IDENTITY(1,1) NOT NULL,
	[patr_trx_number] [nvarchar](55) NULL,
	[patr_debet] [money] NULL,
	[patr_credit] [money] NULL,
	[patr_type] [nchar](3) NOT NULL,
	[patr_note] [nvarchar](255) NULL,
	[patr_modified_date] [datetime] NULL,
	[patr_order_number] [nvarchar](55) NULL,
	[patr_source_id] [varchar](25) NULL,
	[patr_target_id] [varchar](25) NULL,
	[patr_trx_number_ref] [nvarchar](55) NULL,
	[patr_user_id] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[patr_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Purchasing].[cart]    Script Date: 13/11/2023 17:39:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Purchasing].[cart](
	[cart_id] [int] IDENTITY(1,1) NOT NULL,
	[cart_emp_id] [int] NULL,
	[cart_vepro_id] [int] NULL,
	[cart_order_qty] [smallint] NULL,
	[cart_modified_date] [datetime] NOT NULL,
 CONSTRAINT [pk_cart] PRIMARY KEY CLUSTERED 
(
	[cart_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Purchasing].[purchase_order_detail]    Script Date: 13/11/2023 17:39:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Purchasing].[purchase_order_detail](
	[pode_id] [int] IDENTITY(1,1) NOT NULL,
	[pode_pohe_id] [int] NULL,
	[pode_order_qty] [smallint] NOT NULL,
	[pode_price] [money] NOT NULL,
	[pode_line_total]  AS (isnull([pode_order_qty]*[pode_price],(0.00))),
	[pode_received_qty] [decimal](8, 2) NULL,
	[pode_rejected_qty] [decimal](8, 2) NULL,
	[pode_stocked_qty]  AS ([pode_received_qty]-[pode_rejected_qty]),
	[pode_modified_date] [datetime] NOT NULL,
	[pode_stock_id] [int] NULL,
 CONSTRAINT [pk_pode_id] PRIMARY KEY CLUSTERED 
(
	[pode_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Purchasing].[purchase_order_header]    Script Date: 13/11/2023 17:39:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Purchasing].[purchase_order_header](
	[pohe_id] [int] IDENTITY(1,1) NOT NULL,
	[pohe_number] [nvarchar](20) NULL,
	[pohe_status] [tinyint] NULL,
	[pohe_order_date] [datetime] NOT NULL,
	[pohe_subtotal] [money] NULL,
	[pohe_tax] [money] NOT NULL,
	[pohe_total_amount]  AS ([pohe_subtotal]+[pohe_tax]*[pohe_subtotal]),
	[pohe_refund] [money] NULL,
	[pohe_arrival_date] [datetime] NULL,
	[pohe_pay_type] [nchar](2) NOT NULL,
	[pohe_emp_id] [int] NULL,
	[pohe_vendor_id] [int] NULL,
 CONSTRAINT [pk_pohe_id] PRIMARY KEY CLUSTERED 
(
	[pohe_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Purchasing].[stock_detail]    Script Date: 13/11/2023 17:39:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Purchasing].[stock_detail](
	[stod_id] [int] IDENTITY(1,1) NOT NULL,
	[stod_stock_id] [int] NULL,
	[stod_barcode_number] [nvarchar](255) NULL,
	[stod_status] [nchar](2) NULL,
	[stod_notes] [nvarchar](1024) NULL,
	[stod_faci_id] [int] NULL,
	[stod_pohe_id] [int] NULL,
 CONSTRAINT [pk_stod_id] PRIMARY KEY CLUSTERED 
(
	[stod_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Purchasing].[stock_photo]    Script Date: 13/11/2023 17:39:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Purchasing].[stock_photo](
	[spho_id] [int] IDENTITY(1,1) NOT NULL,
	[spho_thumbnail_filename] [nvarchar](50) NOT NULL,
	[spho_photo_filename] [nvarchar](50) NOT NULL,
	[spho_primary] [bit] NOT NULL,
	[spho_url] [nvarchar](255) NOT NULL,
	[spho_stock_id] [int] NOT NULL,
 CONSTRAINT [pk_spho_id] PRIMARY KEY CLUSTERED 
(
	[spho_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Purchasing].[stocks]    Script Date: 13/11/2023 17:39:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Purchasing].[stocks](
	[stock_id] [int] IDENTITY(1,1) NOT NULL,
	[stock_name] [nvarchar](255) NOT NULL,
	[stock_description] [nvarchar](255) NULL,
	[stock_quantity] [smallint] NOT NULL,
	[stock_reorder_point] [smallint] NULL,
	[stock_used] [smallint] NULL,
	[stock_scrap] [smallint] NULL,
	[stock_price] [money] NULL,
	[stock_standar_cost] [money] NULL,
	[stock_size] [nvarchar](25) NULL,
	[stock_color] [nvarchar](15) NULL,
	[stock_modified_date] [datetime] NOT NULL,
 CONSTRAINT [pk_department_id] PRIMARY KEY CLUSTERED 
(
	[stock_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Purchasing].[vendor]    Script Date: 13/11/2023 17:39:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Purchasing].[vendor](
	[vendor_entity_id] [int] NOT NULL,
	[vendor_name] [nvarchar](55) NOT NULL,
	[vendor_active] [bit] NULL,
	[vendor_priority] [bit] NULL,
	[vendor_register_date] [datetime] NOT NULL,
	[vendor_weburl] [nvarchar](1025) NULL,
	[vendor_modified_date] [datetime] NOT NULL,
 CONSTRAINT [pk_vendor_entity_id] PRIMARY KEY CLUSTERED 
(
	[vendor_entity_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Purchasing].[vendor_product]    Script Date: 13/11/2023 17:39:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Purchasing].[vendor_product](
	[vepro_id] [int] IDENTITY(1,1) NOT NULL,
	[vepro_qty_stocked] [int] NOT NULL,
	[vepro_qty_remaining] [int] NOT NULL,
	[vepro_price] [money] NOT NULL,
	[venpro_stock_id] [int] NULL,
	[vepro_vendor_id] [int] NULL,
 CONSTRAINT [pk_vepro_id] PRIMARY KEY CLUSTERED 
(
	[vepro_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Resto].[order_menu_detail]    Script Date: 13/11/2023 17:39:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Resto].[order_menu_detail](
	[omde_id] [int] IDENTITY(1,1) NOT NULL,
	[orme_price] [money] NOT NULL,
	[orme_qty] [smallint] NOT NULL,
	[orme_subtotal]  AS ([orme_price]*[orme_qty]),
	[orme_discount] [smallmoney] NULL,
	[omde_orme_id] [int] NULL,
	[omde_reme_id] [int] NULL,
 CONSTRAINT [pk_omme_id] PRIMARY KEY CLUSTERED 
(
	[omde_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Resto].[order_menus]    Script Date: 13/11/2023 17:39:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Resto].[order_menus](
	[orme_id] [int] IDENTITY(1,1) NOT NULL,
	[orme_order_number] [nvarchar](55) NOT NULL,
	[orme_order_date] [datetime] NOT NULL,
	[orme_total_item] [smallint] NULL,
	[orme_total_discount] [smallmoney] NULL,
	[orme_total_amount] [money] NULL,
	[orme_pay_type] [nchar](2) NOT NULL,
	[orme_cardnumber] [nvarchar](25) NULL,
	[orme_is_paid] [nchar](2) NULL,
	[orme_modified_date] [datetime] NULL,
	[orme_user_id] [int] NULL,
	[orme_status] [nvarchar](20) NULL,
	[orme_invoice] [nvarchar](55) NULL,
 CONSTRAINT [pk_orme_id] PRIMARY KEY CLUSTERED 
(
	[orme_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Resto].[resto_menu_photos]    Script Date: 13/11/2023 17:39:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Resto].[resto_menu_photos](
	[remp_id] [int] IDENTITY(1,1) NOT NULL,
	[remp_thumbnail_filename] [nvarchar](50) NULL,
	[remp_photo_filename] [nvarchar](50) NULL,
	[remp_primary] [bit] NULL,
	[remp_url] [nvarchar](255) NULL,
	[remp_reme_id] [int] NULL,
 CONSTRAINT [pk_remp_id] PRIMARY KEY CLUSTERED 
(
	[remp_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Resto].[resto_menus]    Script Date: 13/11/2023 17:39:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Resto].[resto_menus](
	[reme_faci_id] [int] NULL,
	[reme_id] [int] IDENTITY(1,1) NOT NULL,
	[reme_name] [nvarchar](55) NOT NULL,
	[reme_description] [nvarchar](255) NULL,
	[reme_price] [money] NOT NULL,
	[reme_status] [nvarchar](15) NOT NULL,
	[reme_modified_date] [datetime] NULL,
	[reme_type] [nvarchar](20) NULL,
 CONSTRAINT [pk_reme_faci_id] PRIMARY KEY CLUSTERED 
(
	[reme_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Users].[bonus_points]    Script Date: 13/11/2023 17:39:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Users].[bonus_points](
	[ubpo_id] [int] IDENTITY(1,1) NOT NULL,
	[ubpo_user_id] [int] NULL,
	[ubpo_total_points] [smallint] NULL,
	[ubpo_bonus_type] [nchar](1) NULL,
	[ubpo_created_on] [datetime] NULL,
 CONSTRAINT [pk_ubpo_id] PRIMARY KEY CLUSTERED 
(
	[ubpo_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Users].[roles]    Script Date: 13/11/2023 17:39:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Users].[roles](
	[role_id] [int] IDENTITY(1,1) NOT NULL,
	[role_name] [nvarchar](35) NOT NULL,
 CONSTRAINT [pk_role_id] PRIMARY KEY CLUSTERED 
(
	[role_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Users].[user_members]    Script Date: 13/11/2023 17:39:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Users].[user_members](
	[usme_user_id] [int] NOT NULL,
	[usme_memb_name] [nvarchar](15) NULL,
	[usme_promote_date] [datetime] NULL,
	[usme_points] [smallint] NULL,
	[usme_type] [nvarchar](15) NULL,
 CONSTRAINT [pk_usme_user_id] PRIMARY KEY CLUSTERED 
(
	[usme_user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Users].[user_password]    Script Date: 13/11/2023 17:39:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Users].[user_password](
	[uspa_user_id] [int] IDENTITY(1,1) NOT NULL,
	[uspa_passwordHash] [varchar](128) NULL,
	[uspa_passwordSalt] [varchar](10) NULL,
 CONSTRAINT [pk_uspa_user_id] PRIMARY KEY CLUSTERED 
(
	[uspa_user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Users].[user_profiles]    Script Date: 13/11/2023 17:39:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Users].[user_profiles](
	[uspro_id] [int] IDENTITY(1,1) NOT NULL,
	[uspro_national_id] [nvarchar](20) NOT NULL,
	[uspro_birth_date] [date] NOT NULL,
	[uspro_job_title] [nvarchar](50) NULL,
	[uspro_marital_status] [nchar](1) NULL,
	[uspro_gender] [nchar](1) NULL,
	[uspro_addr_id] [int] NULL,
	[uspro_user_id] [int] NULL,
 CONSTRAINT [pk_usro_id] PRIMARY KEY CLUSTERED 
(
	[uspro_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Users].[user_roles]    Script Date: 13/11/2023 17:39:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Users].[user_roles](
	[usro_user_id] [int] NOT NULL,
	[usro_role_id] [int] NULL,
 CONSTRAINT [pk_usro_user_id] PRIMARY KEY CLUSTERED 
(
	[usro_user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [Booking].[booking_order_detail] ON 

INSERT [Booking].[booking_order_detail] ([borde_boor_id], [borde_id], [borde_checkin], [borde_checkout], [borde_adults], [borde_kids], [borde_price], [borde_extra], [borde_discount], [borde_tax], [borde_faci_id]) VALUES (1, 1, CAST(N'2023-01-27T00:00:00.000' AS DateTime), CAST(N'2023-01-28T00:00:00.000' AS DateTime), 2, 0, 200000.0000, 0.0000, 0.1000, 0.1100, 1)
INSERT [Booking].[booking_order_detail] ([borde_boor_id], [borde_id], [borde_checkin], [borde_checkout], [borde_adults], [borde_kids], [borde_price], [borde_extra], [borde_discount], [borde_tax], [borde_faci_id]) VALUES (1, 2, CAST(N'2023-01-27T00:00:00.000' AS DateTime), CAST(N'2023-01-28T00:00:00.000' AS DateTime), 2, 1, 200000.0000, 20.0000, 0.2000, 0.1100, 1)
INSERT [Booking].[booking_order_detail] ([borde_boor_id], [borde_id], [borde_checkin], [borde_checkout], [borde_adults], [borde_kids], [borde_price], [borde_extra], [borde_discount], [borde_tax], [borde_faci_id]) VALUES (2, 3, CAST(N'2023-01-27T00:00:00.000' AS DateTime), CAST(N'2023-01-28T00:00:00.000' AS DateTime), 3, 0, 100000.0000, 30.0000, 0.2000, 0.1100, 2)
INSERT [Booking].[booking_order_detail] ([borde_boor_id], [borde_id], [borde_checkin], [borde_checkout], [borde_adults], [borde_kids], [borde_price], [borde_extra], [borde_discount], [borde_tax], [borde_faci_id]) VALUES (2, 4, CAST(N'2023-01-27T00:00:00.000' AS DateTime), CAST(N'2023-01-28T00:00:00.000' AS DateTime), 2, 2, 100000.0000, 40.0000, 0.2000, 0.1100, 2)
INSERT [Booking].[booking_order_detail] ([borde_boor_id], [borde_id], [borde_checkin], [borde_checkout], [borde_adults], [borde_kids], [borde_price], [borde_extra], [borde_discount], [borde_tax], [borde_faci_id]) VALUES (3, 5, CAST(N'2023-01-27T00:00:00.000' AS DateTime), CAST(N'2023-01-28T00:00:00.000' AS DateTime), 1, 1, 50000.0000, 50.0000, 0.2000, 0.1100, 10)
INSERT [Booking].[booking_order_detail] ([borde_boor_id], [borde_id], [borde_checkin], [borde_checkout], [borde_adults], [borde_kids], [borde_price], [borde_extra], [borde_discount], [borde_tax], [borde_faci_id]) VALUES (3, 6, CAST(N'2023-01-27T00:00:00.000' AS DateTime), CAST(N'2023-01-28T00:00:00.000' AS DateTime), 4, 0, 50000.0000, 60.0000, 0.2000, 0.1100, 10)
INSERT [Booking].[booking_order_detail] ([borde_boor_id], [borde_id], [borde_checkin], [borde_checkout], [borde_adults], [borde_kids], [borde_price], [borde_extra], [borde_discount], [borde_tax], [borde_faci_id]) VALUES (4, 7, CAST(N'2023-01-01T00:00:00.000' AS DateTime), CAST(N'2023-01-02T00:00:00.000' AS DateTime), 2, 0, 200000.0000, 0.0000, 0.1000, 0.1100, 1)
INSERT [Booking].[booking_order_detail] ([borde_boor_id], [borde_id], [borde_checkin], [borde_checkout], [borde_adults], [borde_kids], [borde_price], [borde_extra], [borde_discount], [borde_tax], [borde_faci_id]) VALUES (4, 8, CAST(N'2023-01-01T00:00:00.000' AS DateTime), CAST(N'2023-01-02T00:00:00.000' AS DateTime), 2, 1, 200000.0000, 20.0000, 0.2000, 0.1100, 1)
INSERT [Booking].[booking_order_detail] ([borde_boor_id], [borde_id], [borde_checkin], [borde_checkout], [borde_adults], [borde_kids], [borde_price], [borde_extra], [borde_discount], [borde_tax], [borde_faci_id]) VALUES (5, 9, CAST(N'2023-01-15T00:00:00.000' AS DateTime), CAST(N'2023-01-17T00:00:00.000' AS DateTime), 3, 0, 100000.0000, 30.0000, 0.2000, 0.1100, 2)
INSERT [Booking].[booking_order_detail] ([borde_boor_id], [borde_id], [borde_checkin], [borde_checkout], [borde_adults], [borde_kids], [borde_price], [borde_extra], [borde_discount], [borde_tax], [borde_faci_id]) VALUES (5, 10, CAST(N'2023-01-18T00:00:00.000' AS DateTime), CAST(N'2023-01-22T00:00:00.000' AS DateTime), 2, 2, 100000.0000, 40.0000, 0.2000, 0.1100, 2)
INSERT [Booking].[booking_order_detail] ([borde_boor_id], [borde_id], [borde_checkin], [borde_checkout], [borde_adults], [borde_kids], [borde_price], [borde_extra], [borde_discount], [borde_tax], [borde_faci_id]) VALUES (6, 11, CAST(N'2023-02-01T00:00:00.000' AS DateTime), CAST(N'2023-02-04T00:00:00.000' AS DateTime), 1, 1, 50000.0000, 50.0000, 0.2000, 0.1100, 10)
INSERT [Booking].[booking_order_detail] ([borde_boor_id], [borde_id], [borde_checkin], [borde_checkout], [borde_adults], [borde_kids], [borde_price], [borde_extra], [borde_discount], [borde_tax], [borde_faci_id]) VALUES (6, 12, CAST(N'2023-02-01T00:00:00.000' AS DateTime), CAST(N'2023-02-05T00:00:00.000' AS DateTime), 4, 0, 50000.0000, 60.0000, 0.2000, 0.1100, 10)
INSERT [Booking].[booking_order_detail] ([borde_boor_id], [borde_id], [borde_checkin], [borde_checkout], [borde_adults], [borde_kids], [borde_price], [borde_extra], [borde_discount], [borde_tax], [borde_faci_id]) VALUES (7, 13, CAST(N'2023-02-01T00:00:00.000' AS DateTime), CAST(N'2023-02-02T00:00:00.000' AS DateTime), 2, 0, 200000.0000, 0.0000, 0.1000, 0.1100, 1)
INSERT [Booking].[booking_order_detail] ([borde_boor_id], [borde_id], [borde_checkin], [borde_checkout], [borde_adults], [borde_kids], [borde_price], [borde_extra], [borde_discount], [borde_tax], [borde_faci_id]) VALUES (7, 14, CAST(N'2023-02-03T00:00:00.000' AS DateTime), CAST(N'2023-02-07T00:00:00.000' AS DateTime), 2, 1, 200000.0000, 20.0000, 0.2000, 0.1100, 1)
INSERT [Booking].[booking_order_detail] ([borde_boor_id], [borde_id], [borde_checkin], [borde_checkout], [borde_adults], [borde_kids], [borde_price], [borde_extra], [borde_discount], [borde_tax], [borde_faci_id]) VALUES (8, 15, CAST(N'2023-02-01T00:00:00.000' AS DateTime), CAST(N'2023-02-02T00:00:00.000' AS DateTime), 3, 0, 100000.0000, 30.0000, 0.2000, 0.1100, 2)
INSERT [Booking].[booking_order_detail] ([borde_boor_id], [borde_id], [borde_checkin], [borde_checkout], [borde_adults], [borde_kids], [borde_price], [borde_extra], [borde_discount], [borde_tax], [borde_faci_id]) VALUES (8, 16, CAST(N'2023-02-01T00:00:00.000' AS DateTime), CAST(N'2023-02-02T00:00:00.000' AS DateTime), 2, 2, 100000.0000, 40.0000, 0.2000, 0.1100, 2)
INSERT [Booking].[booking_order_detail] ([borde_boor_id], [borde_id], [borde_checkin], [borde_checkout], [borde_adults], [borde_kids], [borde_price], [borde_extra], [borde_discount], [borde_tax], [borde_faci_id]) VALUES (9, 17, CAST(N'2023-02-15T00:00:00.000' AS DateTime), CAST(N'2023-02-18T00:00:00.000' AS DateTime), 1, 1, 50000.0000, 50.0000, 0.2000, 0.1100, 10)
INSERT [Booking].[booking_order_detail] ([borde_boor_id], [borde_id], [borde_checkin], [borde_checkout], [borde_adults], [borde_kids], [borde_price], [borde_extra], [borde_discount], [borde_tax], [borde_faci_id]) VALUES (9, 18, CAST(N'2023-02-15T00:00:00.000' AS DateTime), CAST(N'2023-02-20T00:00:00.000' AS DateTime), 4, 0, 50000.0000, 60.0000, 0.2000, 0.1100, 10)
INSERT [Booking].[booking_order_detail] ([borde_boor_id], [borde_id], [borde_checkin], [borde_checkout], [borde_adults], [borde_kids], [borde_price], [borde_extra], [borde_discount], [borde_tax], [borde_faci_id]) VALUES (10, 19, CAST(N'2023-02-20T00:00:00.000' AS DateTime), CAST(N'2023-02-22T00:00:00.000' AS DateTime), 2, 0, 200000.0000, 0.0000, 0.1000, 0.1100, 1)
INSERT [Booking].[booking_order_detail] ([borde_boor_id], [borde_id], [borde_checkin], [borde_checkout], [borde_adults], [borde_kids], [borde_price], [borde_extra], [borde_discount], [borde_tax], [borde_faci_id]) VALUES (10, 20, CAST(N'2023-02-20T00:00:00.000' AS DateTime), CAST(N'2023-02-24T00:00:00.000' AS DateTime), 2, 1, 200000.0000, 20.0000, 0.2000, 0.1100, 1)
INSERT [Booking].[booking_order_detail] ([borde_boor_id], [borde_id], [borde_checkin], [borde_checkout], [borde_adults], [borde_kids], [borde_price], [borde_extra], [borde_discount], [borde_tax], [borde_faci_id]) VALUES (11, 21, CAST(N'2023-03-01T00:00:00.000' AS DateTime), CAST(N'2023-03-02T00:00:00.000' AS DateTime), 1, 1, 50000.0000, 50.0000, 0.2000, 0.1100, 10)
INSERT [Booking].[booking_order_detail] ([borde_boor_id], [borde_id], [borde_checkin], [borde_checkout], [borde_adults], [borde_kids], [borde_price], [borde_extra], [borde_discount], [borde_tax], [borde_faci_id]) VALUES (11, 22, CAST(N'2023-03-01T00:00:00.000' AS DateTime), CAST(N'2023-03-02T00:00:00.000' AS DateTime), 4, 0, 50000.0000, 60.0000, 0.2000, 0.1100, 10)
INSERT [Booking].[booking_order_detail] ([borde_boor_id], [borde_id], [borde_checkin], [borde_checkout], [borde_adults], [borde_kids], [borde_price], [borde_extra], [borde_discount], [borde_tax], [borde_faci_id]) VALUES (12, 23, CAST(N'2023-03-05T00:00:00.000' AS DateTime), CAST(N'2023-03-07T00:00:00.000' AS DateTime), 2, 0, 200000.0000, 0.0000, 0.1000, 0.1100, 1)
INSERT [Booking].[booking_order_detail] ([borde_boor_id], [borde_id], [borde_checkin], [borde_checkout], [borde_adults], [borde_kids], [borde_price], [borde_extra], [borde_discount], [borde_tax], [borde_faci_id]) VALUES (12, 24, CAST(N'2023-03-06T00:00:00.000' AS DateTime), CAST(N'2023-03-10T00:00:00.000' AS DateTime), 2, 1, 200000.0000, 20.0000, 0.2000, 0.1100, 1)
INSERT [Booking].[booking_order_detail] ([borde_boor_id], [borde_id], [borde_checkin], [borde_checkout], [borde_adults], [borde_kids], [borde_price], [borde_extra], [borde_discount], [borde_tax], [borde_faci_id]) VALUES (13, 25, CAST(N'2023-03-07T00:00:00.000' AS DateTime), CAST(N'2023-03-12T00:00:00.000' AS DateTime), 3, 0, 100000.0000, 30.0000, 0.2000, 0.1100, 2)
INSERT [Booking].[booking_order_detail] ([borde_boor_id], [borde_id], [borde_checkin], [borde_checkout], [borde_adults], [borde_kids], [borde_price], [borde_extra], [borde_discount], [borde_tax], [borde_faci_id]) VALUES (13, 26, CAST(N'2023-03-07T00:00:00.000' AS DateTime), CAST(N'2023-03-12T00:00:00.000' AS DateTime), 2, 2, 100000.0000, 40.0000, 0.2000, 0.1100, 2)
INSERT [Booking].[booking_order_detail] ([borde_boor_id], [borde_id], [borde_checkin], [borde_checkout], [borde_adults], [borde_kids], [borde_price], [borde_extra], [borde_discount], [borde_tax], [borde_faci_id]) VALUES (14, 27, CAST(N'2023-03-10T00:00:00.000' AS DateTime), CAST(N'2023-03-15T00:00:00.000' AS DateTime), 1, 1, 50000.0000, 50.0000, 0.2000, 0.1100, 10)
INSERT [Booking].[booking_order_detail] ([borde_boor_id], [borde_id], [borde_checkin], [borde_checkout], [borde_adults], [borde_kids], [borde_price], [borde_extra], [borde_discount], [borde_tax], [borde_faci_id]) VALUES (14, 28, CAST(N'2023-03-10T00:00:00.000' AS DateTime), CAST(N'2023-03-18T00:00:00.000' AS DateTime), 4, 0, 50000.0000, 60.0000, 0.2000, 0.1100, 10)
INSERT [Booking].[booking_order_detail] ([borde_boor_id], [borde_id], [borde_checkin], [borde_checkout], [borde_adults], [borde_kids], [borde_price], [borde_extra], [borde_discount], [borde_tax], [borde_faci_id]) VALUES (15, 29, CAST(N'2023-03-20T00:00:00.000' AS DateTime), CAST(N'2023-03-30T00:00:00.000' AS DateTime), 2, 0, 200000.0000, 0.0000, 0.1000, 0.1100, 1)
INSERT [Booking].[booking_order_detail] ([borde_boor_id], [borde_id], [borde_checkin], [borde_checkout], [borde_adults], [borde_kids], [borde_price], [borde_extra], [borde_discount], [borde_tax], [borde_faci_id]) VALUES (15, 30, CAST(N'2023-03-21T00:00:00.000' AS DateTime), CAST(N'2023-03-30T00:00:00.000' AS DateTime), 2, 1, 200000.0000, 20.0000, 0.2000, 0.1100, 1)
SET IDENTITY_INSERT [Booking].[booking_order_detail] OFF
GO
SET IDENTITY_INSERT [Booking].[booking_order_detail_extra] ON 

INSERT [Booking].[booking_order_detail_extra] ([boex_id], [boex_price], [boex_qty], [boex_measure_unit], [boex_borde_id], [boex_prit_id]) VALUES (1, 10.0000, 2, N'people', 1, 1)
INSERT [Booking].[booking_order_detail_extra] ([boex_id], [boex_price], [boex_qty], [boex_measure_unit], [boex_borde_id], [boex_prit_id]) VALUES (2, 15.0000, 3, N'unit', 2, 2)
INSERT [Booking].[booking_order_detail_extra] ([boex_id], [boex_price], [boex_qty], [boex_measure_unit], [boex_borde_id], [boex_prit_id]) VALUES (3, 20.0000, 4, N'kg', 3, 3)
INSERT [Booking].[booking_order_detail_extra] ([boex_id], [boex_price], [boex_qty], [boex_measure_unit], [boex_borde_id], [boex_prit_id]) VALUES (4, 25.0000, 5, N'people', 4, 4)
INSERT [Booking].[booking_order_detail_extra] ([boex_id], [boex_price], [boex_qty], [boex_measure_unit], [boex_borde_id], [boex_prit_id]) VALUES (5, 30.0000, 6, N'unit', 5, 5)
INSERT [Booking].[booking_order_detail_extra] ([boex_id], [boex_price], [boex_qty], [boex_measure_unit], [boex_borde_id], [boex_prit_id]) VALUES (6, 35.0000, 7, N'kg', 6, 5)
INSERT [Booking].[booking_order_detail_extra] ([boex_id], [boex_price], [boex_qty], [boex_measure_unit], [boex_borde_id], [boex_prit_id]) VALUES (7, 40.0000, 8, N'people', 7, 3)
INSERT [Booking].[booking_order_detail_extra] ([boex_id], [boex_price], [boex_qty], [boex_measure_unit], [boex_borde_id], [boex_prit_id]) VALUES (8, 45.0000, 9, N'unit', 8, 4)
INSERT [Booking].[booking_order_detail_extra] ([boex_id], [boex_price], [boex_qty], [boex_measure_unit], [boex_borde_id], [boex_prit_id]) VALUES (9, 50.0000, 10, N'kg', 9, 3)
INSERT [Booking].[booking_order_detail_extra] ([boex_id], [boex_price], [boex_qty], [boex_measure_unit], [boex_borde_id], [boex_prit_id]) VALUES (10, 55.0000, 11, N'people', 10, 2)
SET IDENTITY_INSERT [Booking].[booking_order_detail_extra] OFF
GO
SET IDENTITY_INSERT [Booking].[booking_orders] ON 

INSERT [Booking].[booking_orders] ([boor_id], [boor_order_number], [boor_order_date], [boor_arrival_date], [boor_total_room], [boor_total_guest], [boor_discount], [boor_total_tax], [boor_total_ammount], [boor_down_payment], [boor_pay_type], [boor_is_paid], [boor_type], [boor_cardnumber], [boor_member_type], [boor_status], [boor_user_id], [boor_hotel_id]) VALUES (1, N'BO#20221127-0001', CAST(N'2023-01-27T00:00:00.000' AS DateTime), NULL, 3, NULL, NULL, NULL, 500000.0000, 200000.0000, N'D ', N'DP', N'T', N'431-2388-93', NULL, NULL, 1, 1)
INSERT [Booking].[booking_orders] ([boor_id], [boor_order_number], [boor_order_date], [boor_arrival_date], [boor_total_room], [boor_total_guest], [boor_discount], [boor_total_tax], [boor_total_ammount], [boor_down_payment], [boor_pay_type], [boor_is_paid], [boor_type], [boor_cardnumber], [boor_member_type], [boor_status], [boor_user_id], [boor_hotel_id]) VALUES (2, N'BO#20221127-0002', CAST(N'2023-01-27T00:00:00.000' AS DateTime), NULL, 4, NULL, NULL, NULL, 300000.0000, 0.0000, N'CR', N'P ', N'C', N'123-2993-32', NULL, NULL, 2, 2)
INSERT [Booking].[booking_orders] ([boor_id], [boor_order_number], [boor_order_date], [boor_arrival_date], [boor_total_room], [boor_total_guest], [boor_discount], [boor_total_tax], [boor_total_ammount], [boor_down_payment], [boor_pay_type], [boor_is_paid], [boor_type], [boor_cardnumber], [boor_member_type], [boor_status], [boor_user_id], [boor_hotel_id]) VALUES (3, N'BO#20221127-0004', CAST(N'2023-01-27T00:00:00.000' AS DateTime), NULL, 4, NULL, NULL, NULL, 150000.0000, 50000.0000, N'PG', N'DP', N'C', N'11-1111-1111', NULL, NULL, 8, 3)
INSERT [Booking].[booking_orders] ([boor_id], [boor_order_number], [boor_order_date], [boor_arrival_date], [boor_total_room], [boor_total_guest], [boor_discount], [boor_total_tax], [boor_total_ammount], [boor_down_payment], [boor_pay_type], [boor_is_paid], [boor_type], [boor_cardnumber], [boor_member_type], [boor_status], [boor_user_id], [boor_hotel_id]) VALUES (4, N'BO#20230101-0001', CAST(N'2023-01-01T00:00:00.000' AS DateTime), NULL, 3, NULL, NULL, NULL, 500000.0000, 200000.0000, N'D ', N'DP', N'T', N'431-2388-93', NULL, NULL, 1, 1)
INSERT [Booking].[booking_orders] ([boor_id], [boor_order_number], [boor_order_date], [boor_arrival_date], [boor_total_room], [boor_total_guest], [boor_discount], [boor_total_tax], [boor_total_ammount], [boor_down_payment], [boor_pay_type], [boor_is_paid], [boor_type], [boor_cardnumber], [boor_member_type], [boor_status], [boor_user_id], [boor_hotel_id]) VALUES (5, N'BO#20230201-0002', CAST(N'2023-02-01T00:00:00.000' AS DateTime), NULL, 4, NULL, NULL, NULL, 300000.0000, 0.0000, N'CR', N'P ', N'C', N'123-2993-32', NULL, NULL, 2, 2)
INSERT [Booking].[booking_orders] ([boor_id], [boor_order_number], [boor_order_date], [boor_arrival_date], [boor_total_room], [boor_total_guest], [boor_discount], [boor_total_tax], [boor_total_ammount], [boor_down_payment], [boor_pay_type], [boor_is_paid], [boor_type], [boor_cardnumber], [boor_member_type], [boor_status], [boor_user_id], [boor_hotel_id]) VALUES (6, N'BO#20230301-0003', CAST(N'2023-03-01T00:00:00.000' AS DateTime), NULL, 4, NULL, NULL, NULL, 150000.0000, 50000.0000, N'PG', N'DP', N'C', N'11-1111-1111', NULL, NULL, 3, 3)
INSERT [Booking].[booking_orders] ([boor_id], [boor_order_number], [boor_order_date], [boor_arrival_date], [boor_total_room], [boor_total_guest], [boor_discount], [boor_total_tax], [boor_total_ammount], [boor_down_payment], [boor_pay_type], [boor_is_paid], [boor_type], [boor_cardnumber], [boor_member_type], [boor_status], [boor_user_id], [boor_hotel_id]) VALUES (7, N'BO#20230401-0004', CAST(N'2023-04-01T00:00:00.000' AS DateTime), NULL, 2, NULL, NULL, NULL, 200000.0000, 100000.0000, N'D ', N'DP', N'T', N'431-2388-94', NULL, NULL, 2, 1)
INSERT [Booking].[booking_orders] ([boor_id], [boor_order_number], [boor_order_date], [boor_arrival_date], [boor_total_room], [boor_total_guest], [boor_discount], [boor_total_tax], [boor_total_ammount], [boor_down_payment], [boor_pay_type], [boor_is_paid], [boor_type], [boor_cardnumber], [boor_member_type], [boor_status], [boor_user_id], [boor_hotel_id]) VALUES (8, N'BO#20230501-0005', CAST(N'2023-05-01T00:00:00.000' AS DateTime), NULL, 3, NULL, NULL, NULL, 300000.0000, 150000.0000, N'CR', N'P ', N'C', N'123-2993-33', NULL, NULL, 3, 2)
INSERT [Booking].[booking_orders] ([boor_id], [boor_order_number], [boor_order_date], [boor_arrival_date], [boor_total_room], [boor_total_guest], [boor_discount], [boor_total_tax], [boor_total_ammount], [boor_down_payment], [boor_pay_type], [boor_is_paid], [boor_type], [boor_cardnumber], [boor_member_type], [boor_status], [boor_user_id], [boor_hotel_id]) VALUES (9, N'BO#20230601-0006', CAST(N'2023-06-01T00:00:00.000' AS DateTime), NULL, 4, NULL, NULL, NULL, 400000.0000, 200000.0000, N'PG', N'DP', N'C', N'11-1111-1112', NULL, NULL, 4, 3)
INSERT [Booking].[booking_orders] ([boor_id], [boor_order_number], [boor_order_date], [boor_arrival_date], [boor_total_room], [boor_total_guest], [boor_discount], [boor_total_tax], [boor_total_ammount], [boor_down_payment], [boor_pay_type], [boor_is_paid], [boor_type], [boor_cardnumber], [boor_member_type], [boor_status], [boor_user_id], [boor_hotel_id]) VALUES (10, N'BO#20230701-0007', CAST(N'2023-07-01T00:00:00.000' AS DateTime), NULL, 1, NULL, NULL, NULL, 100000.0000, 50000.0000, N'D ', N'DP', N'T', N'431-2388-95', NULL, NULL, 5, 1)
INSERT [Booking].[booking_orders] ([boor_id], [boor_order_number], [boor_order_date], [boor_arrival_date], [boor_total_room], [boor_total_guest], [boor_discount], [boor_total_tax], [boor_total_ammount], [boor_down_payment], [boor_pay_type], [boor_is_paid], [boor_type], [boor_cardnumber], [boor_member_type], [boor_status], [boor_user_id], [boor_hotel_id]) VALUES (11, N'BO#20230801-0008', CAST(N'2023-08-01T00:00:00.000' AS DateTime), NULL, 2, NULL, NULL, NULL, 200000.0000, 100000.0000, N'CR', N'P ', N'C', N'123-2993-34', NULL, NULL, 6, 2)
INSERT [Booking].[booking_orders] ([boor_id], [boor_order_number], [boor_order_date], [boor_arrival_date], [boor_total_room], [boor_total_guest], [boor_discount], [boor_total_tax], [boor_total_ammount], [boor_down_payment], [boor_pay_type], [boor_is_paid], [boor_type], [boor_cardnumber], [boor_member_type], [boor_status], [boor_user_id], [boor_hotel_id]) VALUES (12, N'BO#20230901-0009', CAST(N'2023-09-01T00:00:00.000' AS DateTime), NULL, 3, NULL, NULL, NULL, 300000.0000, 150000.0000, N'PG', N'DP', N'C', N'11-1111-1113', NULL, NULL, 7, 3)
INSERT [Booking].[booking_orders] ([boor_id], [boor_order_number], [boor_order_date], [boor_arrival_date], [boor_total_room], [boor_total_guest], [boor_discount], [boor_total_tax], [boor_total_ammount], [boor_down_payment], [boor_pay_type], [boor_is_paid], [boor_type], [boor_cardnumber], [boor_member_type], [boor_status], [boor_user_id], [boor_hotel_id]) VALUES (13, N'BO#20231001-0010', CAST(N'2023-10-01T00:00:00.000' AS DateTime), NULL, 4, NULL, NULL, NULL, 400000.0000, 200000.0000, N'D ', N'DP', N'T', N'431-2388-96', NULL, NULL, 8, 1)
INSERT [Booking].[booking_orders] ([boor_id], [boor_order_number], [boor_order_date], [boor_arrival_date], [boor_total_room], [boor_total_guest], [boor_discount], [boor_total_tax], [boor_total_ammount], [boor_down_payment], [boor_pay_type], [boor_is_paid], [boor_type], [boor_cardnumber], [boor_member_type], [boor_status], [boor_user_id], [boor_hotel_id]) VALUES (14, N'BO#20231101-0011', CAST(N'2023-11-01T00:00:00.000' AS DateTime), NULL, 1, NULL, NULL, NULL, 100000.0000, 50000.0000, N'CR', N'P ', N'C', N'123-2993-35', NULL, NULL, 9, 2)
INSERT [Booking].[booking_orders] ([boor_id], [boor_order_number], [boor_order_date], [boor_arrival_date], [boor_total_room], [boor_total_guest], [boor_discount], [boor_total_tax], [boor_total_ammount], [boor_down_payment], [boor_pay_type], [boor_is_paid], [boor_type], [boor_cardnumber], [boor_member_type], [boor_status], [boor_user_id], [boor_hotel_id]) VALUES (15, N'BO#20231201-0012', CAST(N'2023-12-01T00:00:00.000' AS DateTime), NULL, 2, NULL, NULL, NULL, 200000.0000, 100000.0000, N'PG', N'DP', N'C', N'11-1111-1114', NULL, NULL, 10, 3)
SET IDENTITY_INSERT [Booking].[booking_orders] OFF
GO
SET IDENTITY_INSERT [Booking].[special_offer_coupons] ON 

INSERT [Booking].[special_offer_coupons] ([soco_id], [soco_borde_id], [soco_spof_id]) VALUES (1, 1, 1)
INSERT [Booking].[special_offer_coupons] ([soco_id], [soco_borde_id], [soco_spof_id]) VALUES (2, 2, 2)
INSERT [Booking].[special_offer_coupons] ([soco_id], [soco_borde_id], [soco_spof_id]) VALUES (3, 3, 3)
INSERT [Booking].[special_offer_coupons] ([soco_id], [soco_borde_id], [soco_spof_id]) VALUES (4, 4, 4)
INSERT [Booking].[special_offer_coupons] ([soco_id], [soco_borde_id], [soco_spof_id]) VALUES (5, 5, 5)
INSERT [Booking].[special_offer_coupons] ([soco_id], [soco_borde_id], [soco_spof_id]) VALUES (6, 6, 6)
INSERT [Booking].[special_offer_coupons] ([soco_id], [soco_borde_id], [soco_spof_id]) VALUES (7, 7, 7)
INSERT [Booking].[special_offer_coupons] ([soco_id], [soco_borde_id], [soco_spof_id]) VALUES (8, 8, 8)
SET IDENTITY_INSERT [Booking].[special_offer_coupons] OFF
GO
SET IDENTITY_INSERT [Booking].[special_offers] ON 

INSERT [Booking].[special_offers] ([spof_id], [spof_name], [spof_description], [spof_type], [spof_discount], [spof_start_date], [spof_end_date], [spof_min_qty], [spof_max_qty], [spof_modified_date]) VALUES (1, N'Winter Sale', N'Get 20% off your stay when you book a room during the winter months', N'T    ', 0.2000, CAST(N'2022-12-01T00:00:00.000' AS DateTime), CAST(N'2023-03-31T00:00:00.000' AS DateTime), 1, 3, CAST(N'2023-11-13T03:35:02.473' AS DateTime))
INSERT [Booking].[special_offers] ([spof_id], [spof_name], [spof_description], [spof_type], [spof_discount], [spof_start_date], [spof_end_date], [spof_min_qty], [spof_max_qty], [spof_modified_date]) VALUES (2, N'Weekend Getaway Deal', N'Stay two nights on the weekend and get 20% for the next night', N'C    ', 0.2000, CAST(N'2022-12-01T00:00:00.000' AS DateTime), CAST(N'2023-03-31T00:00:00.000' AS DateTime), 3, 5, CAST(N'2023-11-13T03:35:02.473' AS DateTime))
INSERT [Booking].[special_offers] ([spof_id], [spof_name], [spof_description], [spof_type], [spof_discount], [spof_start_date], [spof_end_date], [spof_min_qty], [spof_max_qty], [spof_modified_date]) VALUES (3, N'Early Bird Special', N'Book at least 30 days in advance and save 15% on your stay', N'I    ', 0.1500, CAST(N'2022-12-01T00:00:00.000' AS DateTime), CAST(N'2023-03-31T00:00:00.000' AS DateTime), 1, 2, CAST(N'2023-11-13T03:35:02.473' AS DateTime))
INSERT [Booking].[special_offers] ([spof_id], [spof_name], [spof_description], [spof_type], [spof_discount], [spof_start_date], [spof_end_date], [spof_min_qty], [spof_max_qty], [spof_modified_date]) VALUES (4, N'Family Fun Package', N'Book a family room and get free breakfast for the kids', N'T    ', 0.0000, CAST(N'2022-12-01T00:00:00.000' AS DateTime), CAST(N'2023-03-31T00:00:00.000' AS DateTime), 4, 6, CAST(N'2023-11-13T03:35:02.473' AS DateTime))
INSERT [Booking].[special_offers] ([spof_id], [spof_name], [spof_description], [spof_type], [spof_discount], [spof_start_date], [spof_end_date], [spof_min_qty], [spof_max_qty], [spof_modified_date]) VALUES (5, N'Romance Package', N'Book a romantic getaway for two and get a bottle of champagne upon arrival', N'C    ', 0.0000, CAST(N'2022-12-01T00:00:00.000' AS DateTime), CAST(N'2023-03-31T00:00:00.000' AS DateTime), 2, 5, CAST(N'2023-11-13T03:35:02.473' AS DateTime))
INSERT [Booking].[special_offers] ([spof_id], [spof_name], [spof_description], [spof_type], [spof_discount], [spof_start_date], [spof_end_date], [spof_min_qty], [spof_max_qty], [spof_modified_date]) VALUES (6, N'Last Minute Deal', N'Book within 48 hours of arrival and save 20% on your stay', N'I    ', 0.2000, CAST(N'2022-12-01T00:00:00.000' AS DateTime), CAST(N'2023-03-31T00:00:00.000' AS DateTime), 1, 3, CAST(N'2023-11-13T03:35:02.473' AS DateTime))
INSERT [Booking].[special_offers] ([spof_id], [spof_name], [spof_description], [spof_type], [spof_discount], [spof_start_date], [spof_end_date], [spof_min_qty], [spof_max_qty], [spof_modified_date]) VALUES (7, N'AAA/CAA Discount', N'Show your AAA or CAA membership card and get 10% off your stay', N'T    ', 0.2000, CAST(N'2022-12-01T00:00:00.000' AS DateTime), CAST(N'2023-03-31T00:00:00.000' AS DateTime), 1, 3, CAST(N'2023-11-13T03:35:02.473' AS DateTime))
INSERT [Booking].[special_offers] ([spof_id], [spof_name], [spof_description], [spof_type], [spof_discount], [spof_start_date], [spof_end_date], [spof_min_qty], [spof_max_qty], [spof_modified_date]) VALUES (8, N'Senior Discount', N'Guests 65 and over receive 10% off their stay', N'C    ', 0.1000, CAST(N'2022-12-01T00:00:00.000' AS DateTime), CAST(N'2022-03-31T00:00:00.000' AS DateTime), 1, 3, CAST(N'2023-11-13T03:35:02.473' AS DateTime))
INSERT [Booking].[special_offers] ([spof_id], [spof_name], [spof_description], [spof_type], [spof_discount], [spof_start_date], [spof_end_date], [spof_min_qty], [spof_max_qty], [spof_modified_date]) VALUES (9, N'Military Discount', N'Active duty military personnel receive 15% off their stay', N'I    ', 0.1500, CAST(N'2022-12-01T00:00:00.000' AS DateTime), CAST(N'2023-03-31T00:00:00.000' AS DateTime), 1, 3, CAST(N'2023-11-13T03:35:02.473' AS DateTime))
SET IDENTITY_INSERT [Booking].[special_offers] OFF
GO
INSERT [Booking].[user_breakfast] ([usbr_borde_id], [usbr_modified_date], [usbr_total_vacant]) VALUES (1, CAST(N'2022-11-27' AS Date), 1)
INSERT [Booking].[user_breakfast] ([usbr_borde_id], [usbr_modified_date], [usbr_total_vacant]) VALUES (2, CAST(N'2022-11-27' AS Date), 2)
INSERT [Booking].[user_breakfast] ([usbr_borde_id], [usbr_modified_date], [usbr_total_vacant]) VALUES (3, CAST(N'2022-11-27' AS Date), 3)
INSERT [Booking].[user_breakfast] ([usbr_borde_id], [usbr_modified_date], [usbr_total_vacant]) VALUES (4, CAST(N'2022-11-27' AS Date), 2)
INSERT [Booking].[user_breakfast] ([usbr_borde_id], [usbr_modified_date], [usbr_total_vacant]) VALUES (5, CAST(N'2022-11-27' AS Date), 1)
INSERT [Booking].[user_breakfast] ([usbr_borde_id], [usbr_modified_date], [usbr_total_vacant]) VALUES (6, CAST(N'2022-11-27' AS Date), 4)
INSERT [Booking].[user_breakfast] ([usbr_borde_id], [usbr_modified_date], [usbr_total_vacant]) VALUES (7, CAST(N'2022-11-27' AS Date), 2)
INSERT [Booking].[user_breakfast] ([usbr_borde_id], [usbr_modified_date], [usbr_total_vacant]) VALUES (8, CAST(N'2022-11-27' AS Date), 3)
INSERT [Booking].[user_breakfast] ([usbr_borde_id], [usbr_modified_date], [usbr_total_vacant]) VALUES (9, CAST(N'2022-11-27' AS Date), 1)
INSERT [Booking].[user_breakfast] ([usbr_borde_id], [usbr_modified_date], [usbr_total_vacant]) VALUES (10, CAST(N'2022-11-27' AS Date), 4)
GO
SET IDENTITY_INSERT [Hotel].[Facilities] ON 

INSERT [Hotel].[Facilities] ([faci_id], [faci_name], [faci_description], [faci_max_number], [faci_measure_unit], [faci_room_number], [faci_startdate], [faci_enddate], [faci_low_price], [faci_high_price], [faci_rate_price], [faci_expose_price], [faci_discount], [faci_tax_rate], [faci_modified_date], [faci_cagro_id], [faci_hotel_id], [faci_user_id]) VALUES (1, N'Single Room', N'Cozy and comfortable room with a single bed', 1, N'beds', N'101', CAST(N'2023-03-14T14:00:00.000' AS DateTime), CAST(N'2023-03-16T12:00:00.000' AS DateTime), 500000.0000, 700000.0000, NULL, 1, NULL, 10.0000, CAST(N'2023-11-13T03:35:02.453' AS DateTime), 1, 1, 2)
INSERT [Hotel].[Facilities] ([faci_id], [faci_name], [faci_description], [faci_max_number], [faci_measure_unit], [faci_room_number], [faci_startdate], [faci_enddate], [faci_low_price], [faci_high_price], [faci_rate_price], [faci_expose_price], [faci_discount], [faci_tax_rate], [faci_modified_date], [faci_cagro_id], [faci_hotel_id], [faci_user_id]) VALUES (2, N'Double Room', N'Spacious room with a double bed', 2, N'beds', N'102', CAST(N'2023-03-14T14:00:00.000' AS DateTime), CAST(N'2023-03-16T12:00:00.000' AS DateTime), 700000.0000, 900000.0000, NULL, 1, NULL, 10.0000, CAST(N'2023-11-13T03:35:02.453' AS DateTime), 1, 1, 2)
INSERT [Hotel].[Facilities] ([faci_id], [faci_name], [faci_description], [faci_max_number], [faci_measure_unit], [faci_room_number], [faci_startdate], [faci_enddate], [faci_low_price], [faci_high_price], [faci_rate_price], [faci_expose_price], [faci_discount], [faci_tax_rate], [faci_modified_date], [faci_cagro_id], [faci_hotel_id], [faci_user_id]) VALUES (3, N'Twin Room', N'Room with two single beds', 2, N'beds', N'103', CAST(N'2023-03-14T14:00:00.000' AS DateTime), CAST(N'2023-03-16T12:00:00.000' AS DateTime), 600000.0000, 800000.0000, NULL, 1, NULL, 10.0000, CAST(N'2023-11-13T03:35:02.453' AS DateTime), 1, 1, 2)
INSERT [Hotel].[Facilities] ([faci_id], [faci_name], [faci_description], [faci_max_number], [faci_measure_unit], [faci_room_number], [faci_startdate], [faci_enddate], [faci_low_price], [faci_high_price], [faci_rate_price], [faci_expose_price], [faci_discount], [faci_tax_rate], [faci_modified_date], [faci_cagro_id], [faci_hotel_id], [faci_user_id]) VALUES (4, N'Deluxe Room', N'Luxurious room with a king-size bed and a sofa', 3, N'beds', N'104', CAST(N'2023-03-14T14:00:00.000' AS DateTime), CAST(N'2023-03-16T12:00:00.000' AS DateTime), 1000000.0000, 1500000.0000, NULL, 1, NULL, 10.0000, CAST(N'2023-11-13T03:35:02.453' AS DateTime), 1, 1, 2)
INSERT [Hotel].[Facilities] ([faci_id], [faci_name], [faci_description], [faci_max_number], [faci_measure_unit], [faci_room_number], [faci_startdate], [faci_enddate], [faci_low_price], [faci_high_price], [faci_rate_price], [faci_expose_price], [faci_discount], [faci_tax_rate], [faci_modified_date], [faci_cagro_id], [faci_hotel_id], [faci_user_id]) VALUES (5, N'Restaurant', N'Fine dining restaurant with a wide selection of menu', 50, N'people', N'R101', CAST(N'2023-03-14T08:00:00.000' AS DateTime), CAST(N'2023-03-15T22:00:00.000' AS DateTime), 500000.0000, 1000000.0000, NULL, 2, NULL, 10.0000, CAST(N'2023-11-13T03:35:02.453' AS DateTime), 2, 1, 2)
INSERT [Hotel].[Facilities] ([faci_id], [faci_name], [faci_description], [faci_max_number], [faci_measure_unit], [faci_room_number], [faci_startdate], [faci_enddate], [faci_low_price], [faci_high_price], [faci_rate_price], [faci_expose_price], [faci_discount], [faci_tax_rate], [faci_modified_date], [faci_cagro_id], [faci_hotel_id], [faci_user_id]) VALUES (6, N'Meeting Room', N'Meeting room with modern facilities and equipment', 30, N'people', N'M101', CAST(N'2023-03-14T08:00:00.000' AS DateTime), CAST(N'2023-03-15T18:00:00.000' AS DateTime), 750000.0000, 1250000.0000, NULL, 2, NULL, 10.0000, CAST(N'2023-11-13T03:35:02.453' AS DateTime), 3, 1, 2)
INSERT [Hotel].[Facilities] ([faci_id], [faci_name], [faci_description], [faci_max_number], [faci_measure_unit], [faci_room_number], [faci_startdate], [faci_enddate], [faci_low_price], [faci_high_price], [faci_rate_price], [faci_expose_price], [faci_discount], [faci_tax_rate], [faci_modified_date], [faci_cagro_id], [faci_hotel_id], [faci_user_id]) VALUES (7, N'Gym', N'Fitness center with state-of-the-art equipment', NULL, N'people', N'G101', CAST(N'2023-03-14T06:00:00.000' AS DateTime), CAST(N'2023-03-16T22:00:00.000' AS DateTime), 100000.0000, 150000.0000, NULL, 3, NULL, 10.0000, CAST(N'2023-11-13T03:35:02.453' AS DateTime), 4, 1, 2)
INSERT [Hotel].[Facilities] ([faci_id], [faci_name], [faci_description], [faci_max_number], [faci_measure_unit], [faci_room_number], [faci_startdate], [faci_enddate], [faci_low_price], [faci_high_price], [faci_rate_price], [faci_expose_price], [faci_discount], [faci_tax_rate], [faci_modified_date], [faci_cagro_id], [faci_hotel_id], [faci_user_id]) VALUES (8, N'Swimming Pool', N'Outdoor swimming pool with a view of the city', NULL, N'people', N'SP101', CAST(N'2023-03-14T08:00:00.000' AS DateTime), CAST(N'2023-03-16T18:00:00.000' AS DateTime), 200000.0000, 300000.0000, NULL, 3, NULL, 10.0000, CAST(N'2023-11-13T03:35:02.457' AS DateTime), 6, 1, 2)
INSERT [Hotel].[Facilities] ([faci_id], [faci_name], [faci_description], [faci_max_number], [faci_measure_unit], [faci_room_number], [faci_startdate], [faci_enddate], [faci_low_price], [faci_high_price], [faci_rate_price], [faci_expose_price], [faci_discount], [faci_tax_rate], [faci_modified_date], [faci_cagro_id], [faci_hotel_id], [faci_user_id]) VALUES (9, N'Deluxe Room', N'A comfortable room with a king-size bed and a balcony', 2, N'beds', N'DR-101', CAST(N'2023-04-01T00:00:00.000' AS DateTime), CAST(N'2023-04-07T00:00:00.000' AS DateTime), 900000.0000, 1000000.0000, NULL, 1, NULL, NULL, CAST(N'2023-11-13T03:35:02.457' AS DateTime), 1, 2, 4)
INSERT [Hotel].[Facilities] ([faci_id], [faci_name], [faci_description], [faci_max_number], [faci_measure_unit], [faci_room_number], [faci_startdate], [faci_enddate], [faci_low_price], [faci_high_price], [faci_rate_price], [faci_expose_price], [faci_discount], [faci_tax_rate], [faci_modified_date], [faci_cagro_id], [faci_hotel_id], [faci_user_id]) VALUES (10, N'Twin Room', N'A cozy room with two twin-size beds', 2, N'beds', N'TR-201', CAST(N'2023-04-01T00:00:00.000' AS DateTime), CAST(N'2023-04-07T00:00:00.000' AS DateTime), 700000.0000, 800000.0000, NULL, 1, NULL, NULL, CAST(N'2023-11-13T03:35:02.457' AS DateTime), 1, 2, 4)
INSERT [Hotel].[Facilities] ([faci_id], [faci_name], [faci_description], [faci_max_number], [faci_measure_unit], [faci_room_number], [faci_startdate], [faci_enddate], [faci_low_price], [faci_high_price], [faci_rate_price], [faci_expose_price], [faci_discount], [faci_tax_rate], [faci_modified_date], [faci_cagro_id], [faci_hotel_id], [faci_user_id]) VALUES (11, N'Family Room', N'A spacious room with a king-size bed and two twin-size beds', 4, N'beds', N'FR-301', CAST(N'2023-04-01T00:00:00.000' AS DateTime), CAST(N'2023-04-07T00:00:00.000' AS DateTime), 1200000.0000, 1400000.0000, NULL, 1, NULL, NULL, CAST(N'2023-11-13T03:35:02.457' AS DateTime), 1, 2, 4)
INSERT [Hotel].[Facilities] ([faci_id], [faci_name], [faci_description], [faci_max_number], [faci_measure_unit], [faci_room_number], [faci_startdate], [faci_enddate], [faci_low_price], [faci_high_price], [faci_rate_price], [faci_expose_price], [faci_discount], [faci_tax_rate], [faci_modified_date], [faci_cagro_id], [faci_hotel_id], [faci_user_id]) VALUES (12, N'Standard Room', N'A basic room with a queen-size bed', 2, N'beds', N'SR-401', CAST(N'2023-04-01T00:00:00.000' AS DateTime), CAST(N'2023-04-07T00:00:00.000' AS DateTime), 500000.0000, 600000.0000, NULL, 1, NULL, NULL, CAST(N'2023-11-13T03:35:02.457' AS DateTime), 1, 2, 4)
INSERT [Hotel].[Facilities] ([faci_id], [faci_name], [faci_description], [faci_max_number], [faci_measure_unit], [faci_room_number], [faci_startdate], [faci_enddate], [faci_low_price], [faci_high_price], [faci_rate_price], [faci_expose_price], [faci_discount], [faci_tax_rate], [faci_modified_date], [faci_cagro_id], [faci_hotel_id], [faci_user_id]) VALUES (13, N'The Garden', N'A cozy restaurant with a beautiful garden view', 60, N'people', N'GDN-101', CAST(N'2023-04-01T00:00:00.000' AS DateTime), CAST(N'2023-04-07T00:00:00.000' AS DateTime), 5000000.0000, 6000000.0000, NULL, 1, NULL, NULL, CAST(N'2023-11-13T03:35:02.457' AS DateTime), 2, 2, 4)
INSERT [Hotel].[Facilities] ([faci_id], [faci_name], [faci_description], [faci_max_number], [faci_measure_unit], [faci_room_number], [faci_startdate], [faci_enddate], [faci_low_price], [faci_high_price], [faci_rate_price], [faci_expose_price], [faci_discount], [faci_tax_rate], [faci_modified_date], [faci_cagro_id], [faci_hotel_id], [faci_user_id]) VALUES (14, N'The Spa', N'A relaxing spa with various treatments and facilities', 10, N'people', N'SPA-201', CAST(N'2023-04-01T00:00:00.000' AS DateTime), CAST(N'2023-04-07T00:00:00.000' AS DateTime), 15000000.0000, 18000000.0000, NULL, 1, NULL, NULL, CAST(N'2023-11-13T03:35:02.457' AS DateTime), 5, 2, 4)
INSERT [Hotel].[Facilities] ([faci_id], [faci_name], [faci_description], [faci_max_number], [faci_measure_unit], [faci_room_number], [faci_startdate], [faci_enddate], [faci_low_price], [faci_high_price], [faci_rate_price], [faci_expose_price], [faci_discount], [faci_tax_rate], [faci_modified_date], [faci_cagro_id], [faci_hotel_id], [faci_user_id]) VALUES (15, N'The Meeting Room', N'A functional meeting room with modern amenities', 25, N'people', N'MTG-301', CAST(N'2023-04-01T00:00:00.000' AS DateTime), CAST(N'2023-04-07T00:00:00.000' AS DateTime), 3000000.0000, 3500000.0000, NULL, 1, NULL, NULL, CAST(N'2023-11-13T03:35:02.457' AS DateTime), 3, 2, 4)
INSERT [Hotel].[Facilities] ([faci_id], [faci_name], [faci_description], [faci_max_number], [faci_measure_unit], [faci_room_number], [faci_startdate], [faci_enddate], [faci_low_price], [faci_high_price], [faci_rate_price], [faci_expose_price], [faci_discount], [faci_tax_rate], [faci_modified_date], [faci_cagro_id], [faci_hotel_id], [faci_user_id]) VALUES (16, N'Deluxe Room', N'Spacious room with modern amenities', 2, N'beds', N'D01', CAST(N'2023-03-14T00:00:00.000' AS DateTime), CAST(N'2023-03-16T00:00:00.000' AS DateTime), 1000000.0000, 1500000.0000, NULL, 1, 10.0000, 10.0000, CAST(N'2023-11-13T03:35:02.457' AS DateTime), 1, 3, 9)
INSERT [Hotel].[Facilities] ([faci_id], [faci_name], [faci_description], [faci_max_number], [faci_measure_unit], [faci_room_number], [faci_startdate], [faci_enddate], [faci_low_price], [faci_high_price], [faci_rate_price], [faci_expose_price], [faci_discount], [faci_tax_rate], [faci_modified_date], [faci_cagro_id], [faci_hotel_id], [faci_user_id]) VALUES (17, N'Superior Room', N'Cozy room with city view', 2, N'beds', N'D02', CAST(N'2023-03-14T00:00:00.000' AS DateTime), CAST(N'2023-03-16T00:00:00.000' AS DateTime), 900000.0000, 1200000.0000, NULL, 1, NULL, NULL, CAST(N'2023-11-13T03:35:02.457' AS DateTime), 1, 3, 9)
INSERT [Hotel].[Facilities] ([faci_id], [faci_name], [faci_description], [faci_max_number], [faci_measure_unit], [faci_room_number], [faci_startdate], [faci_enddate], [faci_low_price], [faci_high_price], [faci_rate_price], [faci_expose_price], [faci_discount], [faci_tax_rate], [faci_modified_date], [faci_cagro_id], [faci_hotel_id], [faci_user_id]) VALUES (18, N'Pool Villa', N'Private villa with pool access', 2, N'people', N'PV01', CAST(N'2023-03-14T00:00:00.000' AS DateTime), CAST(N'2023-03-16T00:00:00.000' AS DateTime), 3000000.0000, 3500000.0000, NULL, 1, NULL, NULL, CAST(N'2023-11-13T03:35:02.457' AS DateTime), 1, 3, 9)
INSERT [Hotel].[Facilities] ([faci_id], [faci_name], [faci_description], [faci_max_number], [faci_measure_unit], [faci_room_number], [faci_startdate], [faci_enddate], [faci_low_price], [faci_high_price], [faci_rate_price], [faci_expose_price], [faci_discount], [faci_tax_rate], [faci_modified_date], [faci_cagro_id], [faci_hotel_id], [faci_user_id]) VALUES (19, N'Meeting Room 1', N'Suitable for small meetings', 20, N'people', N'M01', CAST(N'2023-03-14T00:00:00.000' AS DateTime), CAST(N'2023-03-16T00:00:00.000' AS DateTime), 1500000.0000, 2000000.0000, NULL, 1, NULL, NULL, CAST(N'2023-11-13T03:35:02.457' AS DateTime), 3, 3, 9)
INSERT [Hotel].[Facilities] ([faci_id], [faci_name], [faci_description], [faci_max_number], [faci_measure_unit], [faci_room_number], [faci_startdate], [faci_enddate], [faci_low_price], [faci_high_price], [faci_rate_price], [faci_expose_price], [faci_discount], [faci_tax_rate], [faci_modified_date], [faci_cagro_id], [faci_hotel_id], [faci_user_id]) VALUES (20, N'Gym', N'Fully equipped gym with personal trainer', 50, N'people', N'G01', CAST(N'2023-03-14T00:00:00.000' AS DateTime), CAST(N'2023-03-16T00:00:00.000' AS DateTime), 750000.0000, 1000000.0000, NULL, 1, 20.0000, 10.0000, CAST(N'2023-11-13T03:35:02.457' AS DateTime), 4, 3, 9)
INSERT [Hotel].[Facilities] ([faci_id], [faci_name], [faci_description], [faci_max_number], [faci_measure_unit], [faci_room_number], [faci_startdate], [faci_enddate], [faci_low_price], [faci_high_price], [faci_rate_price], [faci_expose_price], [faci_discount], [faci_tax_rate], [faci_modified_date], [faci_cagro_id], [faci_hotel_id], [faci_user_id]) VALUES (21, N'Sauna', N'Relaxing sauna for your wellness', 10, N'people', N'S01', CAST(N'2023-03-14T00:00:00.000' AS DateTime), CAST(N'2023-03-16T00:00:00.000' AS DateTime), 300000.0000, 400000.0000, NULL, 1, NULL, NULL, CAST(N'2023-11-13T03:35:02.457' AS DateTime), 6, 3, 9)
INSERT [Hotel].[Facilities] ([faci_id], [faci_name], [faci_description], [faci_max_number], [faci_measure_unit], [faci_room_number], [faci_startdate], [faci_enddate], [faci_low_price], [faci_high_price], [faci_rate_price], [faci_expose_price], [faci_discount], [faci_tax_rate], [faci_modified_date], [faci_cagro_id], [faci_hotel_id], [faci_user_id]) VALUES (22, N'Ballroom', N'Elegant ballroom for your event', 100, N'people', N'B01', CAST(N'2023-03-14T00:00:00.000' AS DateTime), CAST(N'2023-03-16T00:00:00.000' AS DateTime), 10000000.0000, 15000000.0000, NULL, 1, 10.0000, 10.0000, CAST(N'2023-11-13T03:35:02.457' AS DateTime), 7, 3, 9)
SET IDENTITY_INSERT [Hotel].[Facilities] OFF
GO
SET IDENTITY_INSERT [Hotel].[Facility_Photos] ON 

INSERT [Hotel].[Facility_Photos] ([fapho_id], [fapho_photo_filename], [fapho_thumbnail_filename], [fapho_original_filename], [fapho_file_size], [fapho_file_type], [fapho_primary], [fapho_url], [fapho_modified_date], [fapho_faci_id]) VALUES (1, N'photo1.jpg', N'thumb1.jpg', N'orig1.jpg', 1024, N'jpg', 0, N'https://example.com/photo1.jpg', CAST(N'2023-11-13T03:35:02.460' AS DateTime), 1)
INSERT [Hotel].[Facility_Photos] ([fapho_id], [fapho_photo_filename], [fapho_thumbnail_filename], [fapho_original_filename], [fapho_file_size], [fapho_file_type], [fapho_primary], [fapho_url], [fapho_modified_date], [fapho_faci_id]) VALUES (2, N'photo1.jpg', N'thumb1.jpg', N'orig1.jpg', 1024, N'jpg', 0, N'https://example.com/photo1.jpg', CAST(N'2023-11-13T03:35:02.460' AS DateTime), 2)
INSERT [Hotel].[Facility_Photos] ([fapho_id], [fapho_photo_filename], [fapho_thumbnail_filename], [fapho_original_filename], [fapho_file_size], [fapho_file_type], [fapho_primary], [fapho_url], [fapho_modified_date], [fapho_faci_id]) VALUES (3, N'photo1.jpg', N'thumb1.jpg', N'orig1.jpg', 1024, N'jpg', 0, N'https://example.com/photo1.jpg', CAST(N'2023-11-13T03:35:02.460' AS DateTime), 3)
INSERT [Hotel].[Facility_Photos] ([fapho_id], [fapho_photo_filename], [fapho_thumbnail_filename], [fapho_original_filename], [fapho_file_size], [fapho_file_type], [fapho_primary], [fapho_url], [fapho_modified_date], [fapho_faci_id]) VALUES (4, N'photo1.jpg', N'thumb1.jpg', N'orig1.jpg', 1024, N'jpg', 0, N'https://example.com/photo1.jpg', CAST(N'2023-11-13T03:35:02.460' AS DateTime), 4)
INSERT [Hotel].[Facility_Photos] ([fapho_id], [fapho_photo_filename], [fapho_thumbnail_filename], [fapho_original_filename], [fapho_file_size], [fapho_file_type], [fapho_primary], [fapho_url], [fapho_modified_date], [fapho_faci_id]) VALUES (5, N'photo1.jpg', N'thumb1.jpg', N'orig1.jpg', 1024, N'jpg', 0, N'https://example.com/photo1.jpg', CAST(N'2023-11-13T03:35:02.460' AS DateTime), 22)
INSERT [Hotel].[Facility_Photos] ([fapho_id], [fapho_photo_filename], [fapho_thumbnail_filename], [fapho_original_filename], [fapho_file_size], [fapho_file_type], [fapho_primary], [fapho_url], [fapho_modified_date], [fapho_faci_id]) VALUES (6, N'photo1.jpg', N'thumb1.jpg', N'orig1.jpg', 1024, N'jpg', 0, N'https://example.com/photo1.jpg', CAST(N'2023-11-13T03:35:02.460' AS DateTime), 16)
INSERT [Hotel].[Facility_Photos] ([fapho_id], [fapho_photo_filename], [fapho_thumbnail_filename], [fapho_original_filename], [fapho_file_size], [fapho_file_type], [fapho_primary], [fapho_url], [fapho_modified_date], [fapho_faci_id]) VALUES (7, N'photo1.jpg', N'thumb1.jpg', N'orig1.jpg', 1024, N'jpg', 0, N'https://example.com/photo1.jpg', CAST(N'2023-11-13T03:35:02.460' AS DateTime), 17)
INSERT [Hotel].[Facility_Photos] ([fapho_id], [fapho_photo_filename], [fapho_thumbnail_filename], [fapho_original_filename], [fapho_file_size], [fapho_file_type], [fapho_primary], [fapho_url], [fapho_modified_date], [fapho_faci_id]) VALUES (8, N'photo1.jpg', N'thumb1.jpg', N'orig1.jpg', 1024, N'jpg', 0, N'https://example.com/photo1.jpg', CAST(N'2023-11-13T03:35:02.460' AS DateTime), 9)
INSERT [Hotel].[Facility_Photos] ([fapho_id], [fapho_photo_filename], [fapho_thumbnail_filename], [fapho_original_filename], [fapho_file_size], [fapho_file_type], [fapho_primary], [fapho_url], [fapho_modified_date], [fapho_faci_id]) VALUES (9, N'photo1.jpg', N'thumb1.jpg', N'orig1.jpg', 1024, N'jpg', 0, N'https://example.com/photo1.jpg', CAST(N'2023-11-13T03:35:02.460' AS DateTime), 11)
INSERT [Hotel].[Facility_Photos] ([fapho_id], [fapho_photo_filename], [fapho_thumbnail_filename], [fapho_original_filename], [fapho_file_size], [fapho_file_type], [fapho_primary], [fapho_url], [fapho_modified_date], [fapho_faci_id]) VALUES (10, N'photo1.jpg', N'thumb1.jpg', N'orig1.jpg', 1024, N'jpg', 0, N'https://example.com/photo1.jpg', CAST(N'2023-11-13T03:35:02.460' AS DateTime), 20)
INSERT [Hotel].[Facility_Photos] ([fapho_id], [fapho_photo_filename], [fapho_thumbnail_filename], [fapho_original_filename], [fapho_file_size], [fapho_file_type], [fapho_primary], [fapho_url], [fapho_modified_date], [fapho_faci_id]) VALUES (11, N'photo1.jpg', N'thumb1.jpg', N'orig1.jpg', 1024, N'jpg', 0, N'https://example.com/photo1.jpg', CAST(N'2023-11-13T03:35:02.460' AS DateTime), 7)
INSERT [Hotel].[Facility_Photos] ([fapho_id], [fapho_photo_filename], [fapho_thumbnail_filename], [fapho_original_filename], [fapho_file_size], [fapho_file_type], [fapho_primary], [fapho_url], [fapho_modified_date], [fapho_faci_id]) VALUES (12, N'photo1.jpg', N'thumb1.jpg', N'orig1.jpg', 1024, N'jpg', 0, N'https://example.com/photo1.jpg', CAST(N'2023-11-13T03:35:02.460' AS DateTime), 13)
INSERT [Hotel].[Facility_Photos] ([fapho_id], [fapho_photo_filename], [fapho_thumbnail_filename], [fapho_original_filename], [fapho_file_size], [fapho_file_type], [fapho_primary], [fapho_url], [fapho_modified_date], [fapho_faci_id]) VALUES (13, N'photo1.jpg', N'thumb1.jpg', N'orig1.jpg', 1024, N'jpg', 0, N'https://example.com/photo1.jpg', CAST(N'2023-11-13T03:35:02.460' AS DateTime), 19)
INSERT [Hotel].[Facility_Photos] ([fapho_id], [fapho_photo_filename], [fapho_thumbnail_filename], [fapho_original_filename], [fapho_file_size], [fapho_file_type], [fapho_primary], [fapho_url], [fapho_modified_date], [fapho_faci_id]) VALUES (14, N'photo1.jpg', N'thumb1.jpg', N'orig1.jpg', 1024, N'jpg', 0, N'https://example.com/photo1.jpg', CAST(N'2023-11-13T03:35:02.460' AS DateTime), 6)
INSERT [Hotel].[Facility_Photos] ([fapho_id], [fapho_photo_filename], [fapho_thumbnail_filename], [fapho_original_filename], [fapho_file_size], [fapho_file_type], [fapho_primary], [fapho_url], [fapho_modified_date], [fapho_faci_id]) VALUES (15, N'photo1.jpg', N'thumb1.jpg', N'orig1.jpg', 1024, N'jpg', 0, N'https://example.com/photo1.jpg', CAST(N'2023-11-13T03:35:02.460' AS DateTime), 15)
INSERT [Hotel].[Facility_Photos] ([fapho_id], [fapho_photo_filename], [fapho_thumbnail_filename], [fapho_original_filename], [fapho_file_size], [fapho_file_type], [fapho_primary], [fapho_url], [fapho_modified_date], [fapho_faci_id]) VALUES (16, N'photo1.jpg', N'thumb1.jpg', N'orig1.jpg', 1024, N'jpg', 0, N'https://example.com/photo1.jpg', CAST(N'2023-11-13T03:35:02.460' AS DateTime), 18)
INSERT [Hotel].[Facility_Photos] ([fapho_id], [fapho_photo_filename], [fapho_thumbnail_filename], [fapho_original_filename], [fapho_file_size], [fapho_file_type], [fapho_primary], [fapho_url], [fapho_modified_date], [fapho_faci_id]) VALUES (17, N'photo1.jpg', N'thumb1.jpg', N'orig1.jpg', 1024, N'jpg', 0, N'https://example.com/photo1.jpg', CAST(N'2023-11-13T03:35:02.460' AS DateTime), 5)
INSERT [Hotel].[Facility_Photos] ([fapho_id], [fapho_photo_filename], [fapho_thumbnail_filename], [fapho_original_filename], [fapho_file_size], [fapho_file_type], [fapho_primary], [fapho_url], [fapho_modified_date], [fapho_faci_id]) VALUES (18, N'photo1.jpg', N'thumb1.jpg', N'orig1.jpg', 1024, N'jpg', 0, N'https://example.com/photo1.jpg', CAST(N'2023-11-13T03:35:02.460' AS DateTime), 21)
INSERT [Hotel].[Facility_Photos] ([fapho_id], [fapho_photo_filename], [fapho_thumbnail_filename], [fapho_original_filename], [fapho_file_size], [fapho_file_type], [fapho_primary], [fapho_url], [fapho_modified_date], [fapho_faci_id]) VALUES (19, N'photo1.jpg', N'thumb1.jpg', N'orig1.jpg', 1024, N'jpg', 0, N'https://example.com/photo1.jpg', CAST(N'2023-11-13T03:35:02.460' AS DateTime), 8)
INSERT [Hotel].[Facility_Photos] ([fapho_id], [fapho_photo_filename], [fapho_thumbnail_filename], [fapho_original_filename], [fapho_file_size], [fapho_file_type], [fapho_primary], [fapho_url], [fapho_modified_date], [fapho_faci_id]) VALUES (20, N'photo1.jpg', N'thumb1.jpg', N'orig1.jpg', 1024, N'jpg', 0, N'https://example.com/photo1.jpg', CAST(N'2023-11-13T03:35:02.460' AS DateTime), 14)
INSERT [Hotel].[Facility_Photos] ([fapho_id], [fapho_photo_filename], [fapho_thumbnail_filename], [fapho_original_filename], [fapho_file_size], [fapho_file_type], [fapho_primary], [fapho_url], [fapho_modified_date], [fapho_faci_id]) VALUES (21, N'photo1.jpg', N'thumb1.jpg', N'orig1.jpg', 1024, N'jpg', 0, N'https://example.com/photo1.jpg', CAST(N'2023-11-13T03:35:02.460' AS DateTime), 12)
INSERT [Hotel].[Facility_Photos] ([fapho_id], [fapho_photo_filename], [fapho_thumbnail_filename], [fapho_original_filename], [fapho_file_size], [fapho_file_type], [fapho_primary], [fapho_url], [fapho_modified_date], [fapho_faci_id]) VALUES (22, N'photo1.jpg', N'thumb1.jpg', N'orig1.jpg', 1024, N'jpg', 0, N'https://example.com/photo1.jpg', CAST(N'2023-11-13T03:35:02.460' AS DateTime), 10)
INSERT [Hotel].[Facility_Photos] ([fapho_id], [fapho_photo_filename], [fapho_thumbnail_filename], [fapho_original_filename], [fapho_file_size], [fapho_file_type], [fapho_primary], [fapho_url], [fapho_modified_date], [fapho_faci_id]) VALUES (23, N'photo2.jpg', N'thumb2.jpg', N'orig2.jpg', 2048, N'jpg', 0, N'https://example.com/photo2.jpg', CAST(N'2023-11-13T03:35:02.460' AS DateTime), 1)
INSERT [Hotel].[Facility_Photos] ([fapho_id], [fapho_photo_filename], [fapho_thumbnail_filename], [fapho_original_filename], [fapho_file_size], [fapho_file_type], [fapho_primary], [fapho_url], [fapho_modified_date], [fapho_faci_id]) VALUES (24, N'photo2.jpg', N'thumb2.jpg', N'orig2.jpg', 2048, N'jpg', 0, N'https://example.com/photo2.jpg', CAST(N'2023-11-13T03:35:02.460' AS DateTime), 2)
INSERT [Hotel].[Facility_Photos] ([fapho_id], [fapho_photo_filename], [fapho_thumbnail_filename], [fapho_original_filename], [fapho_file_size], [fapho_file_type], [fapho_primary], [fapho_url], [fapho_modified_date], [fapho_faci_id]) VALUES (25, N'photo2.jpg', N'thumb2.jpg', N'orig2.jpg', 2048, N'jpg', 0, N'https://example.com/photo2.jpg', CAST(N'2023-11-13T03:35:02.460' AS DateTime), 3)
INSERT [Hotel].[Facility_Photos] ([fapho_id], [fapho_photo_filename], [fapho_thumbnail_filename], [fapho_original_filename], [fapho_file_size], [fapho_file_type], [fapho_primary], [fapho_url], [fapho_modified_date], [fapho_faci_id]) VALUES (26, N'photo2.jpg', N'thumb2.jpg', N'orig2.jpg', 2048, N'jpg', 0, N'https://example.com/photo2.jpg', CAST(N'2023-11-13T03:35:02.460' AS DateTime), 4)
INSERT [Hotel].[Facility_Photos] ([fapho_id], [fapho_photo_filename], [fapho_thumbnail_filename], [fapho_original_filename], [fapho_file_size], [fapho_file_type], [fapho_primary], [fapho_url], [fapho_modified_date], [fapho_faci_id]) VALUES (27, N'photo2.jpg', N'thumb2.jpg', N'orig2.jpg', 2048, N'jpg', 0, N'https://example.com/photo2.jpg', CAST(N'2023-11-13T03:35:02.460' AS DateTime), 22)
INSERT [Hotel].[Facility_Photos] ([fapho_id], [fapho_photo_filename], [fapho_thumbnail_filename], [fapho_original_filename], [fapho_file_size], [fapho_file_type], [fapho_primary], [fapho_url], [fapho_modified_date], [fapho_faci_id]) VALUES (28, N'photo2.jpg', N'thumb2.jpg', N'orig2.jpg', 2048, N'jpg', 0, N'https://example.com/photo2.jpg', CAST(N'2023-11-13T03:35:02.460' AS DateTime), 16)
INSERT [Hotel].[Facility_Photos] ([fapho_id], [fapho_photo_filename], [fapho_thumbnail_filename], [fapho_original_filename], [fapho_file_size], [fapho_file_type], [fapho_primary], [fapho_url], [fapho_modified_date], [fapho_faci_id]) VALUES (29, N'photo2.jpg', N'thumb2.jpg', N'orig2.jpg', 2048, N'jpg', 0, N'https://example.com/photo2.jpg', CAST(N'2023-11-13T03:35:02.460' AS DateTime), 17)
INSERT [Hotel].[Facility_Photos] ([fapho_id], [fapho_photo_filename], [fapho_thumbnail_filename], [fapho_original_filename], [fapho_file_size], [fapho_file_type], [fapho_primary], [fapho_url], [fapho_modified_date], [fapho_faci_id]) VALUES (30, N'photo2.jpg', N'thumb2.jpg', N'orig2.jpg', 2048, N'jpg', 0, N'https://example.com/photo2.jpg', CAST(N'2023-11-13T03:35:02.460' AS DateTime), 9)
INSERT [Hotel].[Facility_Photos] ([fapho_id], [fapho_photo_filename], [fapho_thumbnail_filename], [fapho_original_filename], [fapho_file_size], [fapho_file_type], [fapho_primary], [fapho_url], [fapho_modified_date], [fapho_faci_id]) VALUES (31, N'photo2.jpg', N'thumb2.jpg', N'orig2.jpg', 2048, N'jpg', 0, N'https://example.com/photo2.jpg', CAST(N'2023-11-13T03:35:02.460' AS DateTime), 11)
INSERT [Hotel].[Facility_Photos] ([fapho_id], [fapho_photo_filename], [fapho_thumbnail_filename], [fapho_original_filename], [fapho_file_size], [fapho_file_type], [fapho_primary], [fapho_url], [fapho_modified_date], [fapho_faci_id]) VALUES (32, N'photo2.jpg', N'thumb2.jpg', N'orig2.jpg', 2048, N'jpg', 0, N'https://example.com/photo2.jpg', CAST(N'2023-11-13T03:35:02.460' AS DateTime), 20)
INSERT [Hotel].[Facility_Photos] ([fapho_id], [fapho_photo_filename], [fapho_thumbnail_filename], [fapho_original_filename], [fapho_file_size], [fapho_file_type], [fapho_primary], [fapho_url], [fapho_modified_date], [fapho_faci_id]) VALUES (33, N'photo2.jpg', N'thumb2.jpg', N'orig2.jpg', 2048, N'jpg', 0, N'https://example.com/photo2.jpg', CAST(N'2023-11-13T03:35:02.460' AS DateTime), 7)
INSERT [Hotel].[Facility_Photos] ([fapho_id], [fapho_photo_filename], [fapho_thumbnail_filename], [fapho_original_filename], [fapho_file_size], [fapho_file_type], [fapho_primary], [fapho_url], [fapho_modified_date], [fapho_faci_id]) VALUES (34, N'photo2.jpg', N'thumb2.jpg', N'orig2.jpg', 2048, N'jpg', 0, N'https://example.com/photo2.jpg', CAST(N'2023-11-13T03:35:02.460' AS DateTime), 13)
INSERT [Hotel].[Facility_Photos] ([fapho_id], [fapho_photo_filename], [fapho_thumbnail_filename], [fapho_original_filename], [fapho_file_size], [fapho_file_type], [fapho_primary], [fapho_url], [fapho_modified_date], [fapho_faci_id]) VALUES (35, N'photo2.jpg', N'thumb2.jpg', N'orig2.jpg', 2048, N'jpg', 0, N'https://example.com/photo2.jpg', CAST(N'2023-11-13T03:35:02.460' AS DateTime), 19)
INSERT [Hotel].[Facility_Photos] ([fapho_id], [fapho_photo_filename], [fapho_thumbnail_filename], [fapho_original_filename], [fapho_file_size], [fapho_file_type], [fapho_primary], [fapho_url], [fapho_modified_date], [fapho_faci_id]) VALUES (36, N'photo2.jpg', N'thumb2.jpg', N'orig2.jpg', 2048, N'jpg', 0, N'https://example.com/photo2.jpg', CAST(N'2023-11-13T03:35:02.460' AS DateTime), 6)
INSERT [Hotel].[Facility_Photos] ([fapho_id], [fapho_photo_filename], [fapho_thumbnail_filename], [fapho_original_filename], [fapho_file_size], [fapho_file_type], [fapho_primary], [fapho_url], [fapho_modified_date], [fapho_faci_id]) VALUES (37, N'photo2.jpg', N'thumb2.jpg', N'orig2.jpg', 2048, N'jpg', 0, N'https://example.com/photo2.jpg', CAST(N'2023-11-13T03:35:02.460' AS DateTime), 15)
INSERT [Hotel].[Facility_Photos] ([fapho_id], [fapho_photo_filename], [fapho_thumbnail_filename], [fapho_original_filename], [fapho_file_size], [fapho_file_type], [fapho_primary], [fapho_url], [fapho_modified_date], [fapho_faci_id]) VALUES (38, N'photo2.jpg', N'thumb2.jpg', N'orig2.jpg', 2048, N'jpg', 0, N'https://example.com/photo2.jpg', CAST(N'2023-11-13T03:35:02.460' AS DateTime), 18)
INSERT [Hotel].[Facility_Photos] ([fapho_id], [fapho_photo_filename], [fapho_thumbnail_filename], [fapho_original_filename], [fapho_file_size], [fapho_file_type], [fapho_primary], [fapho_url], [fapho_modified_date], [fapho_faci_id]) VALUES (39, N'photo2.jpg', N'thumb2.jpg', N'orig2.jpg', 2048, N'jpg', 0, N'https://example.com/photo2.jpg', CAST(N'2023-11-13T03:35:02.460' AS DateTime), 5)
INSERT [Hotel].[Facility_Photos] ([fapho_id], [fapho_photo_filename], [fapho_thumbnail_filename], [fapho_original_filename], [fapho_file_size], [fapho_file_type], [fapho_primary], [fapho_url], [fapho_modified_date], [fapho_faci_id]) VALUES (40, N'photo2.jpg', N'thumb2.jpg', N'orig2.jpg', 2048, N'jpg', 0, N'https://example.com/photo2.jpg', CAST(N'2023-11-13T03:35:02.460' AS DateTime), 21)
INSERT [Hotel].[Facility_Photos] ([fapho_id], [fapho_photo_filename], [fapho_thumbnail_filename], [fapho_original_filename], [fapho_file_size], [fapho_file_type], [fapho_primary], [fapho_url], [fapho_modified_date], [fapho_faci_id]) VALUES (41, N'photo2.jpg', N'thumb2.jpg', N'orig2.jpg', 2048, N'jpg', 0, N'https://example.com/photo2.jpg', CAST(N'2023-11-13T03:35:02.460' AS DateTime), 8)
INSERT [Hotel].[Facility_Photos] ([fapho_id], [fapho_photo_filename], [fapho_thumbnail_filename], [fapho_original_filename], [fapho_file_size], [fapho_file_type], [fapho_primary], [fapho_url], [fapho_modified_date], [fapho_faci_id]) VALUES (42, N'photo2.jpg', N'thumb2.jpg', N'orig2.jpg', 2048, N'jpg', 0, N'https://example.com/photo2.jpg', CAST(N'2023-11-13T03:35:02.460' AS DateTime), 14)
INSERT [Hotel].[Facility_Photos] ([fapho_id], [fapho_photo_filename], [fapho_thumbnail_filename], [fapho_original_filename], [fapho_file_size], [fapho_file_type], [fapho_primary], [fapho_url], [fapho_modified_date], [fapho_faci_id]) VALUES (43, N'photo2.jpg', N'thumb2.jpg', N'orig2.jpg', 2048, N'jpg', 0, N'https://example.com/photo2.jpg', CAST(N'2023-11-13T03:35:02.460' AS DateTime), 12)
INSERT [Hotel].[Facility_Photos] ([fapho_id], [fapho_photo_filename], [fapho_thumbnail_filename], [fapho_original_filename], [fapho_file_size], [fapho_file_type], [fapho_primary], [fapho_url], [fapho_modified_date], [fapho_faci_id]) VALUES (44, N'photo2.jpg', N'thumb2.jpg', N'orig2.jpg', 2048, N'jpg', 0, N'https://example.com/photo2.jpg', CAST(N'2023-11-13T03:35:02.460' AS DateTime), 10)
INSERT [Hotel].[Facility_Photos] ([fapho_id], [fapho_photo_filename], [fapho_thumbnail_filename], [fapho_original_filename], [fapho_file_size], [fapho_file_type], [fapho_primary], [fapho_url], [fapho_modified_date], [fapho_faci_id]) VALUES (45, N'photo3.jpg', N'thumb3.jpg', N'orig3.jpg', 3072, N'jpg', 0, N'https://example.com/photo3.jpg', CAST(N'2023-11-13T03:35:02.460' AS DateTime), 1)
INSERT [Hotel].[Facility_Photos] ([fapho_id], [fapho_photo_filename], [fapho_thumbnail_filename], [fapho_original_filename], [fapho_file_size], [fapho_file_type], [fapho_primary], [fapho_url], [fapho_modified_date], [fapho_faci_id]) VALUES (46, N'photo3.jpg', N'thumb3.jpg', N'orig3.jpg', 3072, N'jpg', 0, N'https://example.com/photo3.jpg', CAST(N'2023-11-13T03:35:02.460' AS DateTime), 2)
INSERT [Hotel].[Facility_Photos] ([fapho_id], [fapho_photo_filename], [fapho_thumbnail_filename], [fapho_original_filename], [fapho_file_size], [fapho_file_type], [fapho_primary], [fapho_url], [fapho_modified_date], [fapho_faci_id]) VALUES (47, N'photo3.jpg', N'thumb3.jpg', N'orig3.jpg', 3072, N'jpg', 0, N'https://example.com/photo3.jpg', CAST(N'2023-11-13T03:35:02.460' AS DateTime), 3)
INSERT [Hotel].[Facility_Photos] ([fapho_id], [fapho_photo_filename], [fapho_thumbnail_filename], [fapho_original_filename], [fapho_file_size], [fapho_file_type], [fapho_primary], [fapho_url], [fapho_modified_date], [fapho_faci_id]) VALUES (48, N'photo3.jpg', N'thumb3.jpg', N'orig3.jpg', 3072, N'jpg', 0, N'https://example.com/photo3.jpg', CAST(N'2023-11-13T03:35:02.460' AS DateTime), 4)
INSERT [Hotel].[Facility_Photos] ([fapho_id], [fapho_photo_filename], [fapho_thumbnail_filename], [fapho_original_filename], [fapho_file_size], [fapho_file_type], [fapho_primary], [fapho_url], [fapho_modified_date], [fapho_faci_id]) VALUES (49, N'photo3.jpg', N'thumb3.jpg', N'orig3.jpg', 3072, N'jpg', 0, N'https://example.com/photo3.jpg', CAST(N'2023-11-13T03:35:02.460' AS DateTime), 22)
INSERT [Hotel].[Facility_Photos] ([fapho_id], [fapho_photo_filename], [fapho_thumbnail_filename], [fapho_original_filename], [fapho_file_size], [fapho_file_type], [fapho_primary], [fapho_url], [fapho_modified_date], [fapho_faci_id]) VALUES (50, N'photo3.jpg', N'thumb3.jpg', N'orig3.jpg', 3072, N'jpg', 0, N'https://example.com/photo3.jpg', CAST(N'2023-11-13T03:35:02.460' AS DateTime), 16)
INSERT [Hotel].[Facility_Photos] ([fapho_id], [fapho_photo_filename], [fapho_thumbnail_filename], [fapho_original_filename], [fapho_file_size], [fapho_file_type], [fapho_primary], [fapho_url], [fapho_modified_date], [fapho_faci_id]) VALUES (51, N'photo3.jpg', N'thumb3.jpg', N'orig3.jpg', 3072, N'jpg', 0, N'https://example.com/photo3.jpg', CAST(N'2023-11-13T03:35:02.460' AS DateTime), 17)
INSERT [Hotel].[Facility_Photos] ([fapho_id], [fapho_photo_filename], [fapho_thumbnail_filename], [fapho_original_filename], [fapho_file_size], [fapho_file_type], [fapho_primary], [fapho_url], [fapho_modified_date], [fapho_faci_id]) VALUES (52, N'photo3.jpg', N'thumb3.jpg', N'orig3.jpg', 3072, N'jpg', 0, N'https://example.com/photo3.jpg', CAST(N'2023-11-13T03:35:02.460' AS DateTime), 9)
INSERT [Hotel].[Facility_Photos] ([fapho_id], [fapho_photo_filename], [fapho_thumbnail_filename], [fapho_original_filename], [fapho_file_size], [fapho_file_type], [fapho_primary], [fapho_url], [fapho_modified_date], [fapho_faci_id]) VALUES (53, N'photo3.jpg', N'thumb3.jpg', N'orig3.jpg', 3072, N'jpg', 0, N'https://example.com/photo3.jpg', CAST(N'2023-11-13T03:35:02.460' AS DateTime), 11)
INSERT [Hotel].[Facility_Photos] ([fapho_id], [fapho_photo_filename], [fapho_thumbnail_filename], [fapho_original_filename], [fapho_file_size], [fapho_file_type], [fapho_primary], [fapho_url], [fapho_modified_date], [fapho_faci_id]) VALUES (54, N'photo3.jpg', N'thumb3.jpg', N'orig3.jpg', 3072, N'jpg', 0, N'https://example.com/photo3.jpg', CAST(N'2023-11-13T03:35:02.460' AS DateTime), 20)
INSERT [Hotel].[Facility_Photos] ([fapho_id], [fapho_photo_filename], [fapho_thumbnail_filename], [fapho_original_filename], [fapho_file_size], [fapho_file_type], [fapho_primary], [fapho_url], [fapho_modified_date], [fapho_faci_id]) VALUES (55, N'photo3.jpg', N'thumb3.jpg', N'orig3.jpg', 3072, N'jpg', 0, N'https://example.com/photo3.jpg', CAST(N'2023-11-13T03:35:02.460' AS DateTime), 7)
INSERT [Hotel].[Facility_Photos] ([fapho_id], [fapho_photo_filename], [fapho_thumbnail_filename], [fapho_original_filename], [fapho_file_size], [fapho_file_type], [fapho_primary], [fapho_url], [fapho_modified_date], [fapho_faci_id]) VALUES (56, N'photo3.jpg', N'thumb3.jpg', N'orig3.jpg', 3072, N'jpg', 0, N'https://example.com/photo3.jpg', CAST(N'2023-11-13T03:35:02.460' AS DateTime), 13)
INSERT [Hotel].[Facility_Photos] ([fapho_id], [fapho_photo_filename], [fapho_thumbnail_filename], [fapho_original_filename], [fapho_file_size], [fapho_file_type], [fapho_primary], [fapho_url], [fapho_modified_date], [fapho_faci_id]) VALUES (57, N'photo3.jpg', N'thumb3.jpg', N'orig3.jpg', 3072, N'jpg', 0, N'https://example.com/photo3.jpg', CAST(N'2023-11-13T03:35:02.460' AS DateTime), 19)
INSERT [Hotel].[Facility_Photos] ([fapho_id], [fapho_photo_filename], [fapho_thumbnail_filename], [fapho_original_filename], [fapho_file_size], [fapho_file_type], [fapho_primary], [fapho_url], [fapho_modified_date], [fapho_faci_id]) VALUES (58, N'photo3.jpg', N'thumb3.jpg', N'orig3.jpg', 3072, N'jpg', 0, N'https://example.com/photo3.jpg', CAST(N'2023-11-13T03:35:02.460' AS DateTime), 6)
INSERT [Hotel].[Facility_Photos] ([fapho_id], [fapho_photo_filename], [fapho_thumbnail_filename], [fapho_original_filename], [fapho_file_size], [fapho_file_type], [fapho_primary], [fapho_url], [fapho_modified_date], [fapho_faci_id]) VALUES (59, N'photo3.jpg', N'thumb3.jpg', N'orig3.jpg', 3072, N'jpg', 0, N'https://example.com/photo3.jpg', CAST(N'2023-11-13T03:35:02.460' AS DateTime), 15)
INSERT [Hotel].[Facility_Photos] ([fapho_id], [fapho_photo_filename], [fapho_thumbnail_filename], [fapho_original_filename], [fapho_file_size], [fapho_file_type], [fapho_primary], [fapho_url], [fapho_modified_date], [fapho_faci_id]) VALUES (60, N'photo3.jpg', N'thumb3.jpg', N'orig3.jpg', 3072, N'jpg', 0, N'https://example.com/photo3.jpg', CAST(N'2023-11-13T03:35:02.460' AS DateTime), 18)
INSERT [Hotel].[Facility_Photos] ([fapho_id], [fapho_photo_filename], [fapho_thumbnail_filename], [fapho_original_filename], [fapho_file_size], [fapho_file_type], [fapho_primary], [fapho_url], [fapho_modified_date], [fapho_faci_id]) VALUES (61, N'photo3.jpg', N'thumb3.jpg', N'orig3.jpg', 3072, N'jpg', 0, N'https://example.com/photo3.jpg', CAST(N'2023-11-13T03:35:02.460' AS DateTime), 5)
INSERT [Hotel].[Facility_Photos] ([fapho_id], [fapho_photo_filename], [fapho_thumbnail_filename], [fapho_original_filename], [fapho_file_size], [fapho_file_type], [fapho_primary], [fapho_url], [fapho_modified_date], [fapho_faci_id]) VALUES (62, N'photo3.jpg', N'thumb3.jpg', N'orig3.jpg', 3072, N'jpg', 0, N'https://example.com/photo3.jpg', CAST(N'2023-11-13T03:35:02.460' AS DateTime), 21)
INSERT [Hotel].[Facility_Photos] ([fapho_id], [fapho_photo_filename], [fapho_thumbnail_filename], [fapho_original_filename], [fapho_file_size], [fapho_file_type], [fapho_primary], [fapho_url], [fapho_modified_date], [fapho_faci_id]) VALUES (63, N'photo3.jpg', N'thumb3.jpg', N'orig3.jpg', 3072, N'jpg', 0, N'https://example.com/photo3.jpg', CAST(N'2023-11-13T03:35:02.460' AS DateTime), 8)
INSERT [Hotel].[Facility_Photos] ([fapho_id], [fapho_photo_filename], [fapho_thumbnail_filename], [fapho_original_filename], [fapho_file_size], [fapho_file_type], [fapho_primary], [fapho_url], [fapho_modified_date], [fapho_faci_id]) VALUES (64, N'photo3.jpg', N'thumb3.jpg', N'orig3.jpg', 3072, N'jpg', 0, N'https://example.com/photo3.jpg', CAST(N'2023-11-13T03:35:02.460' AS DateTime), 14)
INSERT [Hotel].[Facility_Photos] ([fapho_id], [fapho_photo_filename], [fapho_thumbnail_filename], [fapho_original_filename], [fapho_file_size], [fapho_file_type], [fapho_primary], [fapho_url], [fapho_modified_date], [fapho_faci_id]) VALUES (65, N'photo3.jpg', N'thumb3.jpg', N'orig3.jpg', 3072, N'jpg', 0, N'https://example.com/photo3.jpg', CAST(N'2023-11-13T03:35:02.460' AS DateTime), 12)
INSERT [Hotel].[Facility_Photos] ([fapho_id], [fapho_photo_filename], [fapho_thumbnail_filename], [fapho_original_filename], [fapho_file_size], [fapho_file_type], [fapho_primary], [fapho_url], [fapho_modified_date], [fapho_faci_id]) VALUES (66, N'photo3.jpg', N'thumb3.jpg', N'orig3.jpg', 3072, N'jpg', 0, N'https://example.com/photo3.jpg', CAST(N'2023-11-13T03:35:02.460' AS DateTime), 10)
INSERT [Hotel].[Facility_Photos] ([fapho_id], [fapho_photo_filename], [fapho_thumbnail_filename], [fapho_original_filename], [fapho_file_size], [fapho_file_type], [fapho_primary], [fapho_url], [fapho_modified_date], [fapho_faci_id]) VALUES (67, N'photo7.jpg', N'thumbnail7.jpg', NULL, NULL, NULL, 0, N'https://example.com/thumbnail7', CAST(N'2023-11-13T03:35:02.460' AS DateTime), 3)
SET IDENTITY_INSERT [Hotel].[Facility_Photos] OFF
GO
SET IDENTITY_INSERT [Hotel].[Hotel_Reviews] ON 

INSERT [Hotel].[Hotel_Reviews] ([hore_id], [hore_user_review], [hore_rating], [hore_created_on], [hore_user_id], [hore_hotel_id]) VALUES (1, N'Hotel ini sangat menyenangkan!', 5, CAST(N'2023-11-13T03:35:02.450' AS DateTime), 1, 1)
INSERT [Hotel].[Hotel_Reviews] ([hore_id], [hore_user_review], [hore_rating], [hore_created_on], [hore_user_id], [hore_hotel_id]) VALUES (2, N'Pelayanan hotel sangat baik', 4, CAST(N'2023-11-13T03:35:02.450' AS DateTime), 5, 1)
INSERT [Hotel].[Hotel_Reviews] ([hore_id], [hore_user_review], [hore_rating], [hore_created_on], [hore_user_id], [hore_hotel_id]) VALUES (3, N'Kamar hotel sangat bersih dan nyaman', 5, CAST(N'2023-11-13T03:35:02.453' AS DateTime), 6, 1)
INSERT [Hotel].[Hotel_Reviews] ([hore_id], [hore_user_review], [hore_rating], [hore_created_on], [hore_user_id], [hore_hotel_id]) VALUES (4, N'Sangat puas dengan penginapan ini', 1, CAST(N'2023-11-13T03:35:02.453' AS DateTime), 10, 1)
INSERT [Hotel].[Hotel_Reviews] ([hore_id], [hore_user_review], [hore_rating], [hore_created_on], [hore_user_id], [hore_hotel_id]) VALUES (5, N'Sarapan paginya enak dan bervariasi', 1, CAST(N'2023-11-13T03:35:02.453' AS DateTime), 11, 1)
INSERT [Hotel].[Hotel_Reviews] ([hore_id], [hore_user_review], [hore_rating], [hore_created_on], [hore_user_id], [hore_hotel_id]) VALUES (6, N'Saya suka kamar mandinya yang luas', 4, CAST(N'2023-11-13T03:35:02.453' AS DateTime), 1, 2)
INSERT [Hotel].[Hotel_Reviews] ([hore_id], [hore_user_review], [hore_rating], [hore_created_on], [hore_user_id], [hore_hotel_id]) VALUES (7, N'Lokasi hotelnya sangat dekat dengan pusat kota', 4, CAST(N'2023-11-13T03:35:02.453' AS DateTime), 5, 2)
INSERT [Hotel].[Hotel_Reviews] ([hore_id], [hore_user_review], [hore_rating], [hore_created_on], [hore_user_id], [hore_hotel_id]) VALUES (8, N'Makanan di restoran hotelnya enak', 5, CAST(N'2023-11-13T03:35:02.453' AS DateTime), 6, 2)
INSERT [Hotel].[Hotel_Reviews] ([hore_id], [hore_user_review], [hore_rating], [hore_created_on], [hore_user_id], [hore_hotel_id]) VALUES (9, N'Pengalaman menginap yang menyenangkan', 5, CAST(N'2023-11-13T03:35:02.453' AS DateTime), 10, 2)
INSERT [Hotel].[Hotel_Reviews] ([hore_id], [hore_user_review], [hore_rating], [hore_created_on], [hore_user_id], [hore_hotel_id]) VALUES (10, N'Pelayanan receptionistnya ramah dan cepat', 5, CAST(N'2023-11-13T03:35:02.453' AS DateTime), 11, 2)
INSERT [Hotel].[Hotel_Reviews] ([hore_id], [hore_user_review], [hore_rating], [hore_created_on], [hore_user_id], [hore_hotel_id]) VALUES (11, N'Hotel yang direkomendasikan', 5, CAST(N'2023-11-13T03:35:02.453' AS DateTime), 15, 2)
INSERT [Hotel].[Hotel_Reviews] ([hore_id], [hore_user_review], [hore_rating], [hore_created_on], [hore_user_id], [hore_hotel_id]) VALUES (12, N'Kamar hotelnya luas dan bersih', 5, CAST(N'2023-11-13T03:35:02.453' AS DateTime), 1, 3)
INSERT [Hotel].[Hotel_Reviews] ([hore_id], [hore_user_review], [hore_rating], [hore_created_on], [hore_user_id], [hore_hotel_id]) VALUES (13, N'Sarapan paginya enak dan bergizi', 4, CAST(N'2023-11-13T03:35:02.453' AS DateTime), 5, 3)
INSERT [Hotel].[Hotel_Reviews] ([hore_id], [hore_user_review], [hore_rating], [hore_created_on], [hore_user_id], [hore_hotel_id]) VALUES (14, N'Fasilitas hotelnya lengkap', 5, CAST(N'2023-11-13T03:35:02.453' AS DateTime), 6, 3)
INSERT [Hotel].[Hotel_Reviews] ([hore_id], [hore_user_review], [hore_rating], [hore_created_on], [hore_user_id], [hore_hotel_id]) VALUES (15, N'Sangat puas dengan pelayanan hotelnya', 5, CAST(N'2023-11-13T03:35:02.453' AS DateTime), 10, 3)
INSERT [Hotel].[Hotel_Reviews] ([hore_id], [hore_user_review], [hore_rating], [hore_created_on], [hore_user_id], [hore_hotel_id]) VALUES (16, N'Harga yang sangat terjangkau', 5, CAST(N'2023-11-13T03:35:02.453' AS DateTime), 11, 3)
INSERT [Hotel].[Hotel_Reviews] ([hore_id], [hore_user_review], [hore_rating], [hore_created_on], [hore_user_id], [hore_hotel_id]) VALUES (17, N'Saya suka dengan suasana hotelnya yang tenang', 5, CAST(N'2023-11-13T03:35:02.453' AS DateTime), 15, 3)
INSERT [Hotel].[Hotel_Reviews] ([hore_id], [hore_user_review], [hore_rating], [hore_created_on], [hore_user_id], [hore_hotel_id]) VALUES (18, N'Hotel yang bagus untuk staycation', 5, CAST(N'2023-11-13T03:35:02.453' AS DateTime), 1, 4)
INSERT [Hotel].[Hotel_Reviews] ([hore_id], [hore_user_review], [hore_rating], [hore_created_on], [hore_user_id], [hore_hotel_id]) VALUES (19, N'Pemandangannya indah dari kamar', 4, CAST(N'2023-11-13T03:35:02.453' AS DateTime), 5, 4)
INSERT [Hotel].[Hotel_Reviews] ([hore_id], [hore_user_review], [hore_rating], [hore_created_on], [hore_user_id], [hore_hotel_id]) VALUES (20, N'Tempat yang pas untuk liburan keluarga', 5, CAST(N'2023-11-13T03:35:02.453' AS DateTime), 6, 4)
INSERT [Hotel].[Hotel_Reviews] ([hore_id], [hore_user_review], [hore_rating], [hore_created_on], [hore_user_id], [hore_hotel_id]) VALUES (21, N'Saya akan merekomendasikan hotel ini ke teman', 5, CAST(N'2023-11-13T03:35:02.453' AS DateTime), 10, 4)
INSERT [Hotel].[Hotel_Reviews] ([hore_id], [hore_user_review], [hore_rating], [hore_created_on], [hore_user_id], [hore_hotel_id]) VALUES (22, N'Sangat menyenangkan menginap di hotel ini', 5, CAST(N'2023-11-13T03:35:02.453' AS DateTime), 11, 4)
INSERT [Hotel].[Hotel_Reviews] ([hore_id], [hore_user_review], [hore_rating], [hore_created_on], [hore_user_id], [hore_hotel_id]) VALUES (23, N'Layanan hotelnya memuaskan', 5, CAST(N'2023-11-13T03:35:02.453' AS DateTime), 15, 4)
INSERT [Hotel].[Hotel_Reviews] ([hore_id], [hore_user_review], [hore_rating], [hore_created_on], [hore_user_id], [hore_hotel_id]) VALUES (24, N'Kamar hotelnya bersih dan nyaman', 5, CAST(N'2023-11-13T03:35:02.453' AS DateTime), 1, 5)
INSERT [Hotel].[Hotel_Reviews] ([hore_id], [hore_user_review], [hore_rating], [hore_created_on], [hore_user_id], [hore_hotel_id]) VALUES (25, N'Lokasi hotelnya sangat dekat dengan pusat kota', 4, CAST(N'2023-11-13T03:35:02.453' AS DateTime), 5, 5)
INSERT [Hotel].[Hotel_Reviews] ([hore_id], [hore_user_review], [hore_rating], [hore_created_on], [hore_user_id], [hore_hotel_id]) VALUES (26, N'Pelayanan yang sangat baik', 5, CAST(N'2023-11-13T03:35:02.453' AS DateTime), 6, 5)
INSERT [Hotel].[Hotel_Reviews] ([hore_id], [hore_user_review], [hore_rating], [hore_created_on], [hore_user_id], [hore_hotel_id]) VALUES (27, N'Hotel yang cocok untuk perjalanan bisnis', 5, CAST(N'2023-11-13T03:35:02.453' AS DateTime), 10, 5)
INSERT [Hotel].[Hotel_Reviews] ([hore_id], [hore_user_review], [hore_rating], [hore_created_on], [hore_user_id], [hore_hotel_id]) VALUES (28, N'Saya suka kolam renangnya yang besar', 4, CAST(N'2023-11-13T03:35:02.453' AS DateTime), 11, 5)
INSERT [Hotel].[Hotel_Reviews] ([hore_id], [hore_user_review], [hore_rating], [hore_created_on], [hore_user_id], [hore_hotel_id]) VALUES (29, N'Hotelnya direkomendasikan untuk liburan keluarga', 5, CAST(N'2023-11-13T03:35:02.453' AS DateTime), 15, 5)
SET IDENTITY_INSERT [Hotel].[Hotel_Reviews] OFF
GO
SET IDENTITY_INSERT [Hotel].[Hotels] ON 

INSERT [Hotel].[Hotels] ([hotel_id], [hotel_name], [hotel_description], [hotel_status], [hotel_reason_status], [hotel_rating_star], [hotel_phonenumber], [hotel_modified_date], [hotel_addr_id], [hotel_addr_description]) VALUES (1, N'Grand Hyatt Jakarta', N'Luxury hotel in the heart of Jakarta', 1, NULL, NULL, N'+62 21 29921234', CAST(N'2023-11-13T03:35:02.450' AS DateTime), 4, N'Jl. M. H. Thamrin No.30, Jakarta Pusat')
INSERT [Hotel].[Hotels] ([hotel_id], [hotel_name], [hotel_description], [hotel_status], [hotel_reason_status], [hotel_rating_star], [hotel_phonenumber], [hotel_modified_date], [hotel_addr_id], [hotel_addr_description]) VALUES (2, N'Aston Priority Simatupang Hotel & Conference Center', N'Contemporary hotel in South Jakarta', 0, NULL, NULL, N'+62 21 78838777', CAST(N'2023-11-13T03:35:02.450' AS DateTime), 5, N'Jl. Let. Jend. T.B. Simatupang Kav. 9 Kebagusan Pasar Minggu, Jakarta Selatan')
INSERT [Hotel].[Hotels] ([hotel_id], [hotel_name], [hotel_description], [hotel_status], [hotel_reason_status], [hotel_rating_star], [hotel_phonenumber], [hotel_modified_date], [hotel_addr_id], [hotel_addr_description]) VALUES (3, N'The Trans Luxury Hotel Bandung', N'Luxury hotel in Bandung', 0, NULL, NULL, N'+62 22 87348888', CAST(N'2023-11-13T03:35:02.450' AS DateTime), 6, N'Jl. Gatot Subroto No. 289, Bandung, Jawa Barat')
INSERT [Hotel].[Hotels] ([hotel_id], [hotel_name], [hotel_description], [hotel_status], [hotel_reason_status], [hotel_rating_star], [hotel_phonenumber], [hotel_modified_date], [hotel_addr_id], [hotel_addr_description]) VALUES (4, N'Padma Resort Ubud', N'Resort with rice field views in Ubud', 1, NULL, NULL, N'+62 361 3011111', CAST(N'2023-11-13T03:35:02.450' AS DateTime), 7, N'Banjar Carik, Desa Puhu, Payangan, Gianyar, Bali')
INSERT [Hotel].[Hotels] ([hotel_id], [hotel_name], [hotel_description], [hotel_status], [hotel_reason_status], [hotel_rating_star], [hotel_phonenumber], [hotel_modified_date], [hotel_addr_id], [hotel_addr_description]) VALUES (5, N'Four Seasons Resort Bali at Sayan', N'Luxury resort in the heart of Bali', 0, NULL, NULL, N'+62 361 977577', CAST(N'2023-11-13T03:35:02.450' AS DateTime), 8, N'Sayan, Ubud, Bali')
INSERT [Hotel].[Hotels] ([hotel_id], [hotel_name], [hotel_description], [hotel_status], [hotel_reason_status], [hotel_rating_star], [hotel_phonenumber], [hotel_modified_date], [hotel_addr_id], [hotel_addr_description]) VALUES (6, N'The Stones - Legian, Bali', N'Beachfront hotel in Legian, Bali', 1, NULL, NULL, N'+62 361 3005888', CAST(N'2023-11-13T03:35:02.450' AS DateTime), 9, N'Jl. Raya Pantai Kuta, Banjar Legian Kelod, Legian, Bali')
INSERT [Hotel].[Hotels] ([hotel_id], [hotel_name], [hotel_description], [hotel_status], [hotel_reason_status], [hotel_rating_star], [hotel_phonenumber], [hotel_modified_date], [hotel_addr_id], [hotel_addr_description]) VALUES (7, N'Aryaduta Makassar', N'City hotel in Makassar', 1, NULL, NULL, N'+62 411 871111', CAST(N'2023-11-13T03:35:02.450' AS DateTime), 4, N'Jl. Somba Opu No. 297, Makassar, Sulawesi Selatan')
INSERT [Hotel].[Hotels] ([hotel_id], [hotel_name], [hotel_description], [hotel_status], [hotel_reason_status], [hotel_rating_star], [hotel_phonenumber], [hotel_modified_date], [hotel_addr_id], [hotel_addr_description]) VALUES (8, N'Hotel Tugu Malang', N'Hotel mewah dengan desain klasik Indonesia', 0, NULL, NULL, N'(0341) 363891', CAST(N'2023-11-13T03:35:02.450' AS DateTime), 5, N'Jl. Tugu No. 3, Klojen, Malang')
INSERT [Hotel].[Hotels] ([hotel_id], [hotel_name], [hotel_description], [hotel_status], [hotel_reason_status], [hotel_rating_star], [hotel_phonenumber], [hotel_modified_date], [hotel_addr_id], [hotel_addr_description]) VALUES (9, N'The Shalimar Boutique Hotel', N'Hotel butik bintang 4 dengan taman tropis', 0, NULL, NULL, N'(0341) 550888', CAST(N'2023-11-13T03:35:02.450' AS DateTime), 5, N'Jalan Salak No. 38-42, Oro Oro Dowo, Klojen, Malang')
INSERT [Hotel].[Hotels] ([hotel_id], [hotel_name], [hotel_description], [hotel_status], [hotel_reason_status], [hotel_rating_star], [hotel_phonenumber], [hotel_modified_date], [hotel_addr_id], [hotel_addr_description]) VALUES (10, N'Hotel Santika Premiere Malang', N'Hotel bintang 4 dengan restoran dan kolam renang', 1, NULL, NULL, N'(0341) 405405', CAST(N'2023-11-13T03:35:02.450' AS DateTime), 5, N'Jl. Letjen S. Parman No. 60, Malang')
INSERT [Hotel].[Hotels] ([hotel_id], [hotel_name], [hotel_description], [hotel_status], [hotel_reason_status], [hotel_rating_star], [hotel_phonenumber], [hotel_modified_date], [hotel_addr_id], [hotel_addr_description]) VALUES (11, N'Ijen Suites Resort & Convention', N'Hotel mewah dengan kolam renang dan spa', 1, NULL, NULL, N'(0341) 404888', CAST(N'2023-11-13T03:35:02.450' AS DateTime), 5, N'Jalan Raya Kahuripan No. 16, Tlogomas, Malang')
INSERT [Hotel].[Hotels] ([hotel_id], [hotel_name], [hotel_description], [hotel_status], [hotel_reason_status], [hotel_rating_star], [hotel_phonenumber], [hotel_modified_date], [hotel_addr_id], [hotel_addr_description]) VALUES (12, N'Atria Hotel Malang', N'Hotel mewah dengan pemandangan pegunungan', 0, NULL, NULL, N'(0341) 402888', CAST(N'2023-11-13T03:35:02.450' AS DateTime), 5, N'Jl. Letjen Sutoyo No.79, Klojen, Malang')
INSERT [Hotel].[Hotels] ([hotel_id], [hotel_name], [hotel_description], [hotel_status], [hotel_reason_status], [hotel_rating_star], [hotel_phonenumber], [hotel_modified_date], [hotel_addr_id], [hotel_addr_description]) VALUES (13, N'Jambuluwuk Batu Resort', N'Resor bintang 4 dengan taman dan kolam renang', 0, NULL, NULL, N'(0341) 596333', CAST(N'2023-11-13T03:35:02.450' AS DateTime), 5, N'Jl. Trunojoyo No.99, Oro Oro Ombo, Batu, Malang')
INSERT [Hotel].[Hotels] ([hotel_id], [hotel_name], [hotel_description], [hotel_status], [hotel_reason_status], [hotel_rating_star], [hotel_phonenumber], [hotel_modified_date], [hotel_addr_id], [hotel_addr_description]) VALUES (14, N'Aria Gajayana Hotel', N'Hotel mewah dengan pemandangan pegunungan', 0, NULL, NULL, N'(0341) 320188', CAST(N'2023-11-13T03:35:02.450' AS DateTime), 5, N'Jl. Hayam Wuruk No. 5, Klojen, Malang')
INSERT [Hotel].[Hotels] ([hotel_id], [hotel_name], [hotel_description], [hotel_status], [hotel_reason_status], [hotel_rating_star], [hotel_phonenumber], [hotel_modified_date], [hotel_addr_id], [hotel_addr_description]) VALUES (15, N'The Batu Hotel & Villas', N'Hotel mewah dengan kolam renang dan restoran', 1, NULL, NULL, N'(0341) 512555', CAST(N'2023-11-13T03:35:02.450' AS DateTime), 5, N'Jalan Raya Selecta No.1')
INSERT [Hotel].[Hotels] ([hotel_id], [hotel_name], [hotel_description], [hotel_status], [hotel_reason_status], [hotel_rating_star], [hotel_phonenumber], [hotel_modified_date], [hotel_addr_id], [hotel_addr_description]) VALUES (16, N'The Batu Hotel Hola', N'Hotel mewah dengan kolam renang dan restoran', 1, NULL, NULL, N'(0341) 512555', CAST(N'2023-11-13T03:35:02.450' AS DateTime), 5, N'Jalan Raya Selecta No.1')
INSERT [Hotel].[Hotels] ([hotel_id], [hotel_name], [hotel_description], [hotel_status], [hotel_reason_status], [hotel_rating_star], [hotel_phonenumber], [hotel_modified_date], [hotel_addr_id], [hotel_addr_description]) VALUES (17, N'TApple PenHouse', N'Hotel mewah dengan kolam renang dan restoran', 1, NULL, NULL, N'(0341) 512335', CAST(N'2023-11-13T03:35:02.450' AS DateTime), 5, N'Jalan Raya Selecta No.1')
SET IDENTITY_INSERT [Hotel].[Hotels] OFF
GO
SET IDENTITY_INSERT [HR].[department] ON 

INSERT [HR].[department] ([dept_id], [dept_name], [dept_modified_date]) VALUES (1, N'Front Office', CAST(N'2023-11-13T03:35:02.470' AS DateTime))
INSERT [HR].[department] ([dept_id], [dept_name], [dept_modified_date]) VALUES (2, N'Security', CAST(N'2023-11-13T03:35:02.470' AS DateTime))
INSERT [HR].[department] ([dept_id], [dept_name], [dept_modified_date]) VALUES (3, N'Marketing', CAST(N'2023-11-13T03:35:02.470' AS DateTime))
INSERT [HR].[department] ([dept_id], [dept_name], [dept_modified_date]) VALUES (4, N'Accounting', CAST(N'2023-11-13T03:35:02.470' AS DateTime))
INSERT [HR].[department] ([dept_id], [dept_name], [dept_modified_date]) VALUES (5, N'Food and Beverage', CAST(N'2023-11-13T03:35:02.470' AS DateTime))
INSERT [HR].[department] ([dept_id], [dept_name], [dept_modified_date]) VALUES (6, N'Housekeeping', CAST(N'2023-11-13T03:35:02.470' AS DateTime))
INSERT [HR].[department] ([dept_id], [dept_name], [dept_modified_date]) VALUES (7, N'Purchasing', CAST(N'2023-11-13T03:35:02.470' AS DateTime))
INSERT [HR].[department] ([dept_id], [dept_name], [dept_modified_date]) VALUES (8, N'Engineering', CAST(N'2023-11-13T03:35:02.470' AS DateTime))
INSERT [HR].[department] ([dept_id], [dept_name], [dept_modified_date]) VALUES (9, N'Personalia (HRD)', CAST(N'2023-11-13T03:35:02.470' AS DateTime))
SET IDENTITY_INSERT [HR].[department] OFF
GO
SET IDENTITY_INSERT [HR].[employee] ON 

INSERT [HR].[employee] ([emp_id], [emp_national_id], [emp_birth_date], [emp_marital_status], [emp_gender], [emp_hire_date], [emp_salaried_flag], [emp_vacation_hours], [emp_sickleave_hourse], [emp_current_flag], [emp_emp_id], [emp_photo], [emp_modified_date], [emp_joro_id]) VALUES (1, N'a123123123456456456789789', CAST(N'2001-01-01T00:00:00.000' AS DateTime), N'S', N'M', CAST(N'2023-11-13T03:35:02.470' AS DateTime), N'1', NULL, NULL, NULL, NULL, NULL, NULL, 1)
INSERT [HR].[employee] ([emp_id], [emp_national_id], [emp_birth_date], [emp_marital_status], [emp_gender], [emp_hire_date], [emp_salaried_flag], [emp_vacation_hours], [emp_sickleave_hourse], [emp_current_flag], [emp_emp_id], [emp_photo], [emp_modified_date], [emp_joro_id]) VALUES (2, N'b456456456123123123789789', CAST(N'2002-02-01T00:00:00.000' AS DateTime), N'M', N'F', CAST(N'2023-11-13T03:35:02.470' AS DateTime), N'0', NULL, NULL, NULL, NULL, NULL, NULL, 2)
INSERT [HR].[employee] ([emp_id], [emp_national_id], [emp_birth_date], [emp_marital_status], [emp_gender], [emp_hire_date], [emp_salaried_flag], [emp_vacation_hours], [emp_sickleave_hourse], [emp_current_flag], [emp_emp_id], [emp_photo], [emp_modified_date], [emp_joro_id]) VALUES (3, N'c231231231339339339013013', CAST(N'2003-03-01T00:00:00.000' AS DateTime), N'M', N'M', CAST(N'2023-11-13T03:35:02.470' AS DateTime), N'1', NULL, NULL, NULL, NULL, NULL, NULL, 3)
INSERT [HR].[employee] ([emp_id], [emp_national_id], [emp_birth_date], [emp_marital_status], [emp_gender], [emp_hire_date], [emp_salaried_flag], [emp_vacation_hours], [emp_sickleave_hourse], [emp_current_flag], [emp_emp_id], [emp_photo], [emp_modified_date], [emp_joro_id]) VALUES (4, N'd524524524621621621832832', CAST(N'1999-04-01T00:00:00.000' AS DateTime), N'S', N'F', CAST(N'2023-11-13T03:35:02.470' AS DateTime), N'0', NULL, NULL, NULL, NULL, NULL, NULL, 4)
INSERT [HR].[employee] ([emp_id], [emp_national_id], [emp_birth_date], [emp_marital_status], [emp_gender], [emp_hire_date], [emp_salaried_flag], [emp_vacation_hours], [emp_sickleave_hourse], [emp_current_flag], [emp_emp_id], [emp_photo], [emp_modified_date], [emp_joro_id]) VALUES (5, N'e122122122322322322494944', CAST(N'1997-05-01T00:00:00.000' AS DateTime), N'S', N'M', CAST(N'2023-11-13T03:35:02.470' AS DateTime), N'1', NULL, NULL, NULL, NULL, NULL, NULL, 5)
INSERT [HR].[employee] ([emp_id], [emp_national_id], [emp_birth_date], [emp_marital_status], [emp_gender], [emp_hire_date], [emp_salaried_flag], [emp_vacation_hours], [emp_sickleave_hourse], [emp_current_flag], [emp_emp_id], [emp_photo], [emp_modified_date], [emp_joro_id]) VALUES (6, N'f090285082940243284423853', CAST(N'1999-06-01T00:00:00.000' AS DateTime), N'M', N'F', CAST(N'2023-11-13T03:35:02.470' AS DateTime), N'0', NULL, NULL, NULL, NULL, NULL, NULL, 6)
INSERT [HR].[employee] ([emp_id], [emp_national_id], [emp_birth_date], [emp_marital_status], [emp_gender], [emp_hire_date], [emp_salaried_flag], [emp_vacation_hours], [emp_sickleave_hourse], [emp_current_flag], [emp_emp_id], [emp_photo], [emp_modified_date], [emp_joro_id]) VALUES (7, N'g122932483892095343534255', CAST(N'1998-07-01T00:00:00.000' AS DateTime), N'M', N'M', CAST(N'2023-11-13T03:35:02.470' AS DateTime), N'1', NULL, NULL, NULL, NULL, NULL, NULL, 7)
INSERT [HR].[employee] ([emp_id], [emp_national_id], [emp_birth_date], [emp_marital_status], [emp_gender], [emp_hire_date], [emp_salaried_flag], [emp_vacation_hours], [emp_sickleave_hourse], [emp_current_flag], [emp_emp_id], [emp_photo], [emp_modified_date], [emp_joro_id]) VALUES (8, N'h214392573294812743928523', CAST(N'2002-08-01T00:00:00.000' AS DateTime), N'S', N'F', CAST(N'2023-11-13T03:35:02.470' AS DateTime), N'0', NULL, NULL, NULL, NULL, NULL, NULL, 8)
INSERT [HR].[employee] ([emp_id], [emp_national_id], [emp_birth_date], [emp_marital_status], [emp_gender], [emp_hire_date], [emp_salaried_flag], [emp_vacation_hours], [emp_sickleave_hourse], [emp_current_flag], [emp_emp_id], [emp_photo], [emp_modified_date], [emp_joro_id]) VALUES (9, N'i217473298498378988932754', CAST(N'1999-09-01T00:00:00.000' AS DateTime), N'S', N'M', CAST(N'2023-11-13T03:35:02.470' AS DateTime), N'1', NULL, NULL, NULL, NULL, NULL, NULL, 9)
INSERT [HR].[employee] ([emp_id], [emp_national_id], [emp_birth_date], [emp_marital_status], [emp_gender], [emp_hire_date], [emp_salaried_flag], [emp_vacation_hours], [emp_sickleave_hourse], [emp_current_flag], [emp_emp_id], [emp_photo], [emp_modified_date], [emp_joro_id]) VALUES (10, N'j219483945782893873249573', CAST(N'2001-10-01T00:00:00.000' AS DateTime), N'M', N'F', CAST(N'2023-11-13T03:35:02.470' AS DateTime), N'0', NULL, NULL, NULL, NULL, NULL, NULL, 10)
SET IDENTITY_INSERT [HR].[employee] OFF
GO
SET IDENTITY_INSERT [HR].[employee_department_history] ON 

INSERT [HR].[employee_department_history] ([edhi_id], [edhi_emp_id], [edhi_start_date], [edhi_end_date], [edhi_modified_date], [edhi_dept_id], [edhi_shift_id]) VALUES (1, 1, NULL, NULL, NULL, 1, 1)
INSERT [HR].[employee_department_history] ([edhi_id], [edhi_emp_id], [edhi_start_date], [edhi_end_date], [edhi_modified_date], [edhi_dept_id], [edhi_shift_id]) VALUES (2, 2, NULL, NULL, NULL, 2, 2)
INSERT [HR].[employee_department_history] ([edhi_id], [edhi_emp_id], [edhi_start_date], [edhi_end_date], [edhi_modified_date], [edhi_dept_id], [edhi_shift_id]) VALUES (3, 3, NULL, NULL, NULL, 3, 3)
INSERT [HR].[employee_department_history] ([edhi_id], [edhi_emp_id], [edhi_start_date], [edhi_end_date], [edhi_modified_date], [edhi_dept_id], [edhi_shift_id]) VALUES (4, 4, NULL, NULL, NULL, 4, 1)
INSERT [HR].[employee_department_history] ([edhi_id], [edhi_emp_id], [edhi_start_date], [edhi_end_date], [edhi_modified_date], [edhi_dept_id], [edhi_shift_id]) VALUES (5, 5, NULL, NULL, NULL, 5, 2)
INSERT [HR].[employee_department_history] ([edhi_id], [edhi_emp_id], [edhi_start_date], [edhi_end_date], [edhi_modified_date], [edhi_dept_id], [edhi_shift_id]) VALUES (6, 6, NULL, NULL, NULL, 6, 3)
INSERT [HR].[employee_department_history] ([edhi_id], [edhi_emp_id], [edhi_start_date], [edhi_end_date], [edhi_modified_date], [edhi_dept_id], [edhi_shift_id]) VALUES (7, 7, NULL, NULL, NULL, 7, 1)
INSERT [HR].[employee_department_history] ([edhi_id], [edhi_emp_id], [edhi_start_date], [edhi_end_date], [edhi_modified_date], [edhi_dept_id], [edhi_shift_id]) VALUES (8, 8, NULL, NULL, NULL, 8, 2)
INSERT [HR].[employee_department_history] ([edhi_id], [edhi_emp_id], [edhi_start_date], [edhi_end_date], [edhi_modified_date], [edhi_dept_id], [edhi_shift_id]) VALUES (9, 9, NULL, NULL, NULL, 9, 3)
INSERT [HR].[employee_department_history] ([edhi_id], [edhi_emp_id], [edhi_start_date], [edhi_end_date], [edhi_modified_date], [edhi_dept_id], [edhi_shift_id]) VALUES (10, 10, NULL, NULL, NULL, 2, 1)
SET IDENTITY_INSERT [HR].[employee_department_history] OFF
GO
INSERT [HR].[employee_pay_history] ([ephi_emp_id], [ephi_rate_change_date], [ephi_rate_salary], [ephi_pay_frequence], [ephi_modified_date]) VALUES (1, CAST(N'2023-11-13T03:35:02.470' AS DateTime), NULL, NULL, NULL)
INSERT [HR].[employee_pay_history] ([ephi_emp_id], [ephi_rate_change_date], [ephi_rate_salary], [ephi_pay_frequence], [ephi_modified_date]) VALUES (2, CAST(N'2023-11-13T03:35:02.470' AS DateTime), NULL, NULL, NULL)
INSERT [HR].[employee_pay_history] ([ephi_emp_id], [ephi_rate_change_date], [ephi_rate_salary], [ephi_pay_frequence], [ephi_modified_date]) VALUES (3, CAST(N'2023-11-13T03:35:02.470' AS DateTime), NULL, NULL, NULL)
INSERT [HR].[employee_pay_history] ([ephi_emp_id], [ephi_rate_change_date], [ephi_rate_salary], [ephi_pay_frequence], [ephi_modified_date]) VALUES (4, CAST(N'2023-11-13T03:35:02.470' AS DateTime), NULL, NULL, NULL)
INSERT [HR].[employee_pay_history] ([ephi_emp_id], [ephi_rate_change_date], [ephi_rate_salary], [ephi_pay_frequence], [ephi_modified_date]) VALUES (5, CAST(N'2023-11-13T03:35:02.470' AS DateTime), NULL, NULL, NULL)
INSERT [HR].[employee_pay_history] ([ephi_emp_id], [ephi_rate_change_date], [ephi_rate_salary], [ephi_pay_frequence], [ephi_modified_date]) VALUES (6, CAST(N'2023-11-13T03:35:02.470' AS DateTime), NULL, NULL, NULL)
INSERT [HR].[employee_pay_history] ([ephi_emp_id], [ephi_rate_change_date], [ephi_rate_salary], [ephi_pay_frequence], [ephi_modified_date]) VALUES (7, CAST(N'2023-11-13T03:35:02.470' AS DateTime), NULL, NULL, NULL)
INSERT [HR].[employee_pay_history] ([ephi_emp_id], [ephi_rate_change_date], [ephi_rate_salary], [ephi_pay_frequence], [ephi_modified_date]) VALUES (8, CAST(N'2023-11-13T03:35:02.470' AS DateTime), NULL, NULL, NULL)
INSERT [HR].[employee_pay_history] ([ephi_emp_id], [ephi_rate_change_date], [ephi_rate_salary], [ephi_pay_frequence], [ephi_modified_date]) VALUES (9, CAST(N'2023-11-13T03:35:02.470' AS DateTime), NULL, NULL, NULL)
INSERT [HR].[employee_pay_history] ([ephi_emp_id], [ephi_rate_change_date], [ephi_rate_salary], [ephi_pay_frequence], [ephi_modified_date]) VALUES (10, CAST(N'2023-11-13T03:35:02.470' AS DateTime), NULL, NULL, NULL)
GO
SET IDENTITY_INSERT [HR].[job_role] ON 

INSERT [HR].[job_role] ([joro_id], [joro_name], [joro_modified_date]) VALUES (1, N'Resepsionis', CAST(N'2023-11-13T03:35:02.470' AS DateTime))
INSERT [HR].[job_role] ([joro_id], [joro_name], [joro_modified_date]) VALUES (2, N'Porter', CAST(N'2023-11-13T03:35:02.470' AS DateTime))
INSERT [HR].[job_role] ([joro_id], [joro_name], [joro_modified_date]) VALUES (3, N'Concierge', CAST(N'2023-11-13T03:35:02.470' AS DateTime))
INSERT [HR].[job_role] ([joro_id], [joro_name], [joro_modified_date]) VALUES (4, N'Room Service', CAST(N'2023-11-13T03:35:02.470' AS DateTime))
INSERT [HR].[job_role] ([joro_id], [joro_name], [joro_modified_date]) VALUES (5, N'Waiter', CAST(N'2023-11-13T03:35:02.470' AS DateTime))
INSERT [HR].[job_role] ([joro_id], [joro_name], [joro_modified_date]) VALUES (6, N'Staff Dapur', CAST(N'2023-11-13T03:35:02.470' AS DateTime))
INSERT [HR].[job_role] ([joro_id], [joro_name], [joro_modified_date]) VALUES (7, N'Housekeeper', CAST(N'2023-11-13T03:35:02.470' AS DateTime))
INSERT [HR].[job_role] ([joro_id], [joro_name], [joro_modified_date]) VALUES (8, N'Room Division Manager', CAST(N'2023-11-13T03:35:02.470' AS DateTime))
INSERT [HR].[job_role] ([joro_id], [joro_name], [joro_modified_date]) VALUES (9, N'Maintenance Staff', CAST(N'2023-11-13T03:35:02.470' AS DateTime))
INSERT [HR].[job_role] ([joro_id], [joro_name], [joro_modified_date]) VALUES (10, N'Hotel Manager', CAST(N'2023-11-13T03:35:02.470' AS DateTime))
INSERT [HR].[job_role] ([joro_id], [joro_name], [joro_modified_date]) VALUES (11, N'Purchasing', CAST(N'2023-11-13T03:35:02.470' AS DateTime))
INSERT [HR].[job_role] ([joro_id], [joro_name], [joro_modified_date]) VALUES (12, N'Sales & Marketing', CAST(N'2023-11-13T03:35:02.470' AS DateTime))
INSERT [HR].[job_role] ([joro_id], [joro_name], [joro_modified_date]) VALUES (13, N'Event Planner', CAST(N'2023-11-13T03:35:02.470' AS DateTime))
INSERT [HR].[job_role] ([joro_id], [joro_name], [joro_modified_date]) VALUES (14, N'Akuntan', CAST(N'2023-11-13T03:35:02.470' AS DateTime))
SET IDENTITY_INSERT [HR].[job_role] OFF
GO
SET IDENTITY_INSERT [HR].[shift] ON 

INSERT [HR].[shift] ([shift_id], [shift_name], [shift_start_time], [shift_end_time]) VALUES (1, N'Shift 1', CAST(N'1900-01-01T08:00:00.000' AS DateTime), CAST(N'1900-01-01T16:00:00.000' AS DateTime))
INSERT [HR].[shift] ([shift_id], [shift_name], [shift_start_time], [shift_end_time]) VALUES (2, N'Shift 2', CAST(N'1900-01-01T16:00:00.000' AS DateTime), CAST(N'1900-01-01T00:00:00.000' AS DateTime))
INSERT [HR].[shift] ([shift_id], [shift_name], [shift_start_time], [shift_end_time]) VALUES (3, N'Shift 3', CAST(N'1900-01-01T00:00:00.000' AS DateTime), CAST(N'1900-01-01T08:00:00.000' AS DateTime))
SET IDENTITY_INSERT [HR].[shift] OFF
GO
SET IDENTITY_INSERT [HR].[work_order_detail] ON 

INSERT [HR].[work_order_detail] ([wode_id], [wode_task_name], [wode_status], [wode_start_date], [wode_end_date], [wode_notes], [wode_emp_id], [wode_seta_id], [wode_faci_id], [wode_woro_id]) VALUES (1, N'work detail 1', N'INPROGRESS', CAST(N'1995-01-14T00:00:00.000' AS DateTime), CAST(N'1995-03-14T00:00:00.000' AS DateTime), N'Masih Bekerja', 2, 2, 1, 2)
INSERT [HR].[work_order_detail] ([wode_id], [wode_task_name], [wode_status], [wode_start_date], [wode_end_date], [wode_notes], [wode_emp_id], [wode_seta_id], [wode_faci_id], [wode_woro_id]) VALUES (2, N'work detail 2', N'COMPLETED', CAST(N'1995-01-14T00:00:00.000' AS DateTime), CAST(N'1995-03-14T00:00:00.000' AS DateTime), N'Selesai', 3, 1, 2, 1)
INSERT [HR].[work_order_detail] ([wode_id], [wode_task_name], [wode_status], [wode_start_date], [wode_end_date], [wode_notes], [wode_emp_id], [wode_seta_id], [wode_faci_id], [wode_woro_id]) VALUES (3, N'work detail 3', N'CANCELLED', CAST(N'1995-01-14T00:00:00.000' AS DateTime), CAST(N'1995-03-14T00:00:00.000' AS DateTime), N'Ada Kenadala', 4, 1, 5, 3)
INSERT [HR].[work_order_detail] ([wode_id], [wode_task_name], [wode_status], [wode_start_date], [wode_end_date], [wode_notes], [wode_emp_id], [wode_seta_id], [wode_faci_id], [wode_woro_id]) VALUES (4, N'work detail 4', N'INPROGRESS', CAST(N'1995-01-14T00:00:00.000' AS DateTime), CAST(N'1995-03-14T00:00:00.000' AS DateTime), N'Masih Bekerja', 6, 3, 9, 5)
INSERT [HR].[work_order_detail] ([wode_id], [wode_task_name], [wode_status], [wode_start_date], [wode_end_date], [wode_notes], [wode_emp_id], [wode_seta_id], [wode_faci_id], [wode_woro_id]) VALUES (5, N'work detail 5', N'COMPLETED', CAST(N'1995-01-14T00:00:00.000' AS DateTime), CAST(N'1995-03-14T00:00:00.000' AS DateTime), N'Selesai', 5, 4, 8, 6)
INSERT [HR].[work_order_detail] ([wode_id], [wode_task_name], [wode_status], [wode_start_date], [wode_end_date], [wode_notes], [wode_emp_id], [wode_seta_id], [wode_faci_id], [wode_woro_id]) VALUES (6, N'work detail 6', N'CANCELLED', CAST(N'1995-01-14T00:00:00.000' AS DateTime), CAST(N'1995-03-14T00:00:00.000' AS DateTime), N'Ada Kenadala', 5, 5, 7, 7)
INSERT [HR].[work_order_detail] ([wode_id], [wode_task_name], [wode_status], [wode_start_date], [wode_end_date], [wode_notes], [wode_emp_id], [wode_seta_id], [wode_faci_id], [wode_woro_id]) VALUES (7, N'work detail 7', N'COMPLETED', CAST(N'1995-01-14T00:00:00.000' AS DateTime), CAST(N'1995-03-14T00:00:00.000' AS DateTime), N'Selesai', 10, 4, 1, 10)
INSERT [HR].[work_order_detail] ([wode_id], [wode_task_name], [wode_status], [wode_start_date], [wode_end_date], [wode_notes], [wode_emp_id], [wode_seta_id], [wode_faci_id], [wode_woro_id]) VALUES (8, N'work detail 8', N'CANCELLED', CAST(N'1995-01-14T00:00:00.000' AS DateTime), CAST(N'1995-03-14T00:00:00.000' AS DateTime), N'Ada Kenadala', 10, 1, 2, 1)
INSERT [HR].[work_order_detail] ([wode_id], [wode_task_name], [wode_status], [wode_start_date], [wode_end_date], [wode_notes], [wode_emp_id], [wode_seta_id], [wode_faci_id], [wode_woro_id]) VALUES (9, N'work detail 9', N'COMPLETED', CAST(N'1995-01-14T00:00:00.000' AS DateTime), CAST(N'1995-03-14T00:00:00.000' AS DateTime), N'Selesai', 4, 3, 2, 5)
INSERT [HR].[work_order_detail] ([wode_id], [wode_task_name], [wode_status], [wode_start_date], [wode_end_date], [wode_notes], [wode_emp_id], [wode_seta_id], [wode_faci_id], [wode_woro_id]) VALUES (10, N'work detail 10', N'INPROGRESS', CAST(N'1995-01-14T00:00:00.000' AS DateTime), CAST(N'1995-03-14T00:00:00.000' AS DateTime), N'Masih Bekerja', 4, 5, 6, 4)
INSERT [HR].[work_order_detail] ([wode_id], [wode_task_name], [wode_status], [wode_start_date], [wode_end_date], [wode_notes], [wode_emp_id], [wode_seta_id], [wode_faci_id], [wode_woro_id]) VALUES (11, N'work detail 11', N'INPROGRESS', CAST(N'1995-01-14T00:00:00.000' AS DateTime), CAST(N'1995-03-14T00:00:00.000' AS DateTime), N'Masih Bekerja', 2, 2, 1, 11)
INSERT [HR].[work_order_detail] ([wode_id], [wode_task_name], [wode_status], [wode_start_date], [wode_end_date], [wode_notes], [wode_emp_id], [wode_seta_id], [wode_faci_id], [wode_woro_id]) VALUES (12, N'work detail 12', N'COMPLETED', CAST(N'1995-01-14T00:00:00.000' AS DateTime), CAST(N'1995-03-14T00:00:00.000' AS DateTime), N'Selesai', 3, 1, 2, 12)
INSERT [HR].[work_order_detail] ([wode_id], [wode_task_name], [wode_status], [wode_start_date], [wode_end_date], [wode_notes], [wode_emp_id], [wode_seta_id], [wode_faci_id], [wode_woro_id]) VALUES (13, N'work detail 13', N'CANCELLED', CAST(N'1995-01-14T00:00:00.000' AS DateTime), CAST(N'1995-03-14T00:00:00.000' AS DateTime), N'Ada Kenadala', 4, 1, 5, 13)
INSERT [HR].[work_order_detail] ([wode_id], [wode_task_name], [wode_status], [wode_start_date], [wode_end_date], [wode_notes], [wode_emp_id], [wode_seta_id], [wode_faci_id], [wode_woro_id]) VALUES (14, N'work detail 14', N'INPROGRESS', CAST(N'1995-01-14T00:00:00.000' AS DateTime), CAST(N'1995-03-14T00:00:00.000' AS DateTime), N'Masih Bekerja', 6, 3, 9, 14)
INSERT [HR].[work_order_detail] ([wode_id], [wode_task_name], [wode_status], [wode_start_date], [wode_end_date], [wode_notes], [wode_emp_id], [wode_seta_id], [wode_faci_id], [wode_woro_id]) VALUES (15, N'work detail 15', N'COMPLETED', CAST(N'1995-01-14T00:00:00.000' AS DateTime), CAST(N'1995-03-14T00:00:00.000' AS DateTime), N'Selesai', 5, 4, 8, 15)
SET IDENTITY_INSERT [HR].[work_order_detail] OFF
GO
SET IDENTITY_INSERT [HR].[work_orders] ON 

INSERT [HR].[work_orders] ([woro_id], [woro_date], [woro_status], [woro_user_id]) VALUES (1, CAST(N'1995-01-14T00:00:00.000' AS DateTime), N'OPEN', 2)
INSERT [HR].[work_orders] ([woro_id], [woro_date], [woro_status], [woro_user_id]) VALUES (2, CAST(N'1995-02-09T00:00:00.000' AS DateTime), N'CLOSED', 2)
INSERT [HR].[work_orders] ([woro_id], [woro_date], [woro_status], [woro_user_id]) VALUES (3, CAST(N'1995-03-17T00:00:00.000' AS DateTime), N'CANCELLED', 2)
INSERT [HR].[work_orders] ([woro_id], [woro_date], [woro_status], [woro_user_id]) VALUES (4, CAST(N'1995-04-03T00:00:00.000' AS DateTime), N'CLOSED', 3)
INSERT [HR].[work_orders] ([woro_id], [woro_date], [woro_status], [woro_user_id]) VALUES (5, CAST(N'1995-07-12T00:00:00.000' AS DateTime), N'OPEN', 2)
INSERT [HR].[work_orders] ([woro_id], [woro_date], [woro_status], [woro_user_id]) VALUES (6, CAST(N'1995-08-19T00:00:00.000' AS DateTime), N'CANCELLED', 5)
INSERT [HR].[work_orders] ([woro_id], [woro_date], [woro_status], [woro_user_id]) VALUES (7, CAST(N'1995-09-17T00:00:00.000' AS DateTime), N'CLOSED', 4)
INSERT [HR].[work_orders] ([woro_id], [woro_date], [woro_status], [woro_user_id]) VALUES (8, CAST(N'1995-11-20T00:00:00.000' AS DateTime), N'OPEN', 5)
INSERT [HR].[work_orders] ([woro_id], [woro_date], [woro_status], [woro_user_id]) VALUES (9, CAST(N'1995-12-23T00:00:00.000' AS DateTime), N'CANCELLED', 5)
INSERT [HR].[work_orders] ([woro_id], [woro_date], [woro_status], [woro_user_id]) VALUES (10, CAST(N'1995-12-27T00:00:00.000' AS DateTime), N'CLOSED', 4)
INSERT [HR].[work_orders] ([woro_id], [woro_date], [woro_status], [woro_user_id]) VALUES (11, CAST(N'1996-01-14T00:00:00.000' AS DateTime), N'OPEN', 16)
INSERT [HR].[work_orders] ([woro_id], [woro_date], [woro_status], [woro_user_id]) VALUES (12, CAST(N'1996-02-09T00:00:00.000' AS DateTime), N'CLOSED', 17)
INSERT [HR].[work_orders] ([woro_id], [woro_date], [woro_status], [woro_user_id]) VALUES (13, CAST(N'1996-03-17T00:00:00.000' AS DateTime), N'CANCELLED', 18)
INSERT [HR].[work_orders] ([woro_id], [woro_date], [woro_status], [woro_user_id]) VALUES (14, CAST(N'1996-04-03T00:00:00.000' AS DateTime), N'CLOSED', 19)
INSERT [HR].[work_orders] ([woro_id], [woro_date], [woro_status], [woro_user_id]) VALUES (15, CAST(N'1996-07-12T00:00:00.000' AS DateTime), N'OPEN', 20)
SET IDENTITY_INSERT [HR].[work_orders] OFF
GO
SET IDENTITY_INSERT [Master].[address] ON 

INSERT [Master].[address] ([addr_id], [addr_line1], [addr_line2], [addr_city], [addr_postal_code], [addr_spatial_location], [addr_prov_id]) VALUES (1, N'Jl. Sudirman No.1', NULL, N'Jakarta', N'12345', N'POINT(-6.2146 106.8451)', 1)
INSERT [Master].[address] ([addr_id], [addr_line1], [addr_line2], [addr_city], [addr_postal_code], [addr_spatial_location], [addr_prov_id]) VALUES (2, N'Jl. Raya Kuta No.25', NULL, N'Bali', N'54321', N'POINT(-8.7158 115.1702)', 2)
INSERT [Master].[address] ([addr_id], [addr_line1], [addr_line2], [addr_city], [addr_postal_code], [addr_spatial_location], [addr_prov_id]) VALUES (3, N'123 Moo 4, Tambon San Sai Noi', NULL, N'Chiang Mai', N'67890', N'POINT(18.8408 98.9611)', 3)
INSERT [Master].[address] ([addr_id], [addr_line1], [addr_line2], [addr_city], [addr_postal_code], [addr_spatial_location], [addr_prov_id]) VALUES (4, N'1-1-1 Shibuya', NULL, N'Tokyo', N'01234', N'POINT(35.6581 139.7414)', 4)
INSERT [Master].[address] ([addr_id], [addr_line1], [addr_line2], [addr_city], [addr_postal_code], [addr_spatial_location], [addr_prov_id]) VALUES (5, N'10 Unter den Linden', NULL, N'Berlin', N'23456', N'POINT(52.5166 13.3833)', 5)
INSERT [Master].[address] ([addr_id], [addr_line1], [addr_line2], [addr_city], [addr_postal_code], [addr_spatial_location], [addr_prov_id]) VALUES (6, N'55 Rue du Faubourg Saint-Honoré', NULL, N'Paris', N'34567', N'POINT(48.8714 2.3074)', 6)
INSERT [Master].[address] ([addr_id], [addr_line1], [addr_line2], [addr_city], [addr_postal_code], [addr_spatial_location], [addr_prov_id]) VALUES (7, N'123 Main St', NULL, N'Los Angeles', N'45678', N'POINT(34.0522 -118.2437)', 7)
INSERT [Master].[address] ([addr_id], [addr_line1], [addr_line2], [addr_city], [addr_postal_code], [addr_spatial_location], [addr_prov_id]) VALUES (8, N'456 Park Ave', NULL, N'New York', N'56789', N'POINT(40.7711 -73.9742)', 8)
INSERT [Master].[address] ([addr_id], [addr_line1], [addr_line2], [addr_city], [addr_postal_code], [addr_spatial_location], [addr_prov_id]) VALUES (9, N'789 King St W', NULL, N'Toronto', N'67890', N'POINT(43.6468 -79.3933)', 9)
INSERT [Master].[address] ([addr_id], [addr_line1], [addr_line2], [addr_city], [addr_postal_code], [addr_spatial_location], [addr_prov_id]) VALUES (10, N'123 Avenida Paulista', NULL, N'Sao Paulo', N'78901', N'POINT(-23.5674 -46.6476)', 10)
INSERT [Master].[address] ([addr_id], [addr_line1], [addr_line2], [addr_city], [addr_postal_code], [addr_spatial_location], [addr_prov_id]) VALUES (11, N'456 Calle Florida', NULL, N'Buenos Aires', N'89012', N'POINT(-34.6037 -58.3816)', 11)
INSERT [Master].[address] ([addr_id], [addr_line1], [addr_line2], [addr_city], [addr_postal_code], [addr_spatial_location], [addr_prov_id]) VALUES (12, N'123 Long St', NULL, N'Cape Town', N'90123', N'POINT(-33.9189 18.4232)', 12)
INSERT [Master].[address] ([addr_id], [addr_line1], [addr_line2], [addr_city], [addr_postal_code], [addr_spatial_location], [addr_prov_id]) VALUES (13, N'456 Durban Rd', NULL, N'Durban', N'01234', N'POINT(-29.8587 31.0218)', 13)
INSERT [Master].[address] ([addr_id], [addr_line1], [addr_line2], [addr_city], [addr_postal_code], [addr_spatial_location], [addr_prov_id]) VALUES (14, N'789 Oxford Rd', NULL, N'Johannesburg', N'12345', N'POINT(-26.2041 28.0473)', 14)
INSERT [Master].[address] ([addr_id], [addr_line1], [addr_line2], [addr_city], [addr_postal_code], [addr_spatial_location], [addr_prov_id]) VALUES (15, N'123 Uhuru Hwy', NULL, N'Nairobi', N'23456', N'POINT(-1.2921 36.8219)', 15)
SET IDENTITY_INSERT [Master].[address] OFF
GO
SET IDENTITY_INSERT [Master].[category_group] ON 

INSERT [Master].[category_group] ([cagro_id], [cagro_name], [cagro_description], [cagro_type], [cagro_icon], [cagro_icon_url]) VALUES (1, N'ROOM', N'Rooms for guests to stay in', N'category', N'room.png', N'https://example.com/room.png')
INSERT [Master].[category_group] ([cagro_id], [cagro_name], [cagro_description], [cagro_type], [cagro_icon], [cagro_icon_url]) VALUES (2, N'RESTAURANT', N'On-site restaurant for guests to dine in', N'service', N'restaurant.png', N'https://example.com/restaurant.png')
INSERT [Master].[category_group] ([cagro_id], [cagro_name], [cagro_description], [cagro_type], [cagro_icon], [cagro_icon_url]) VALUES (3, N'MEETING ROOM', N'Rooms for meetings and events', N'facility', N'meeting_room.png', N'https://example.com/meeting_room.png')
INSERT [Master].[category_group] ([cagro_id], [cagro_name], [cagro_description], [cagro_type], [cagro_icon], [cagro_icon_url]) VALUES (4, N'GYM', N'Fitness center for guests to use', N'facility', N'gym.png', N'https://example.com/gym.png')
INSERT [Master].[category_group] ([cagro_id], [cagro_name], [cagro_description], [cagro_type], [cagro_icon], [cagro_icon_url]) VALUES (5, N'AULA', N'Multipurpose room for events', N'facility', N'aula.png', N'https://example.com/aula.png')
INSERT [Master].[category_group] ([cagro_id], [cagro_name], [cagro_description], [cagro_type], [cagro_icon], [cagro_icon_url]) VALUES (6, N'SWIMMING POOL', N'Outdoor swimming pool for guests to use', N'facility', N'swimming_pool.png', N'https://example.com/swimming_pool.png')
INSERT [Master].[category_group] ([cagro_id], [cagro_name], [cagro_description], [cagro_type], [cagro_icon], [cagro_icon_url]) VALUES (7, N'BALROOM', N'Ballroom for events and parties', N'facility', N'balroom.png', N'https://example.com/balroom.png')
SET IDENTITY_INSERT [Master].[category_group] OFF
GO
SET IDENTITY_INSERT [Master].[country] ON 

INSERT [Master].[country] ([country_id], [country_name], [country_region_id]) VALUES (1, N'Indonesia', 1)
INSERT [Master].[country] ([country_id], [country_name], [country_region_id]) VALUES (2, N'Thailand', 1)
INSERT [Master].[country] ([country_id], [country_name], [country_region_id]) VALUES (3, N'Japan', 1)
INSERT [Master].[country] ([country_id], [country_name], [country_region_id]) VALUES (4, N'Germany', 2)
INSERT [Master].[country] ([country_id], [country_name], [country_region_id]) VALUES (5, N'France', 2)
INSERT [Master].[country] ([country_id], [country_name], [country_region_id]) VALUES (6, N'United States', 3)
INSERT [Master].[country] ([country_id], [country_name], [country_region_id]) VALUES (7, N'Canada', 3)
INSERT [Master].[country] ([country_id], [country_name], [country_region_id]) VALUES (8, N'Brazil', 4)
INSERT [Master].[country] ([country_id], [country_name], [country_region_id]) VALUES (9, N'Argentina', 4)
INSERT [Master].[country] ([country_id], [country_name], [country_region_id]) VALUES (10, N'South Africa', 5)
SET IDENTITY_INSERT [Master].[country] OFF
GO
INSERT [Master].[members] ([memb_name], [memb_description]) VALUES (N'GOLD', N'Keanggotaan GOLD memberikan diskon 20% pada semua layanan hotel dan fasilitas gratis late check-out hingga pukul 12 siang')
INSERT [Master].[members] ([memb_name], [memb_description]) VALUES (N'SILVER', N'Keanggotaan SILVER memberikan diskon 10% pada semua layanan hotel')
INSERT [Master].[members] ([memb_name], [memb_description]) VALUES (N'VIP', N'Keanggotaan VIP memberikan diskon 30% pada semua layanan hotel, fasilitas gratis late check-out hingga pukul 12 siang, dan akses ke VIP lounge')
INSERT [Master].[members] ([memb_name], [memb_description]) VALUES (N'WIZARD', N'Keanggotaan WIZARD memberikan diskon 50% pada semua layanan hotel, fasilitas gratis late check-out hingga pukul 12 siang, akses ke VIP lounge, dan fasilitas gratis upgrade kamar')
GO
SET IDENTITY_INSERT [Master].[policy] ON 

INSERT [Master].[policy] ([poli_id], [poli_name], [poli_description]) VALUES (1, N'Early Check-In Policy', N'Policy related to early check-in requests')
INSERT [Master].[policy] ([poli_id], [poli_name], [poli_description]) VALUES (2, N'Late Check-Out Policy', N'Policy related to late check-out requests')
INSERT [Master].[policy] ([poli_id], [poli_name], [poli_description]) VALUES (3, N'Extra Person Policy', N'Policy related to additional guests in the room')
INSERT [Master].[policy] ([poli_id], [poli_name], [poli_description]) VALUES (4, N'Parking Policy', N'Policy related to parking facilities')
INSERT [Master].[policy] ([poli_id], [poli_name], [poli_description]) VALUES (5, N'Room Service Policy', N'Policy related to room service requests')
SET IDENTITY_INSERT [Master].[policy] OFF
GO
INSERT [Master].[policy_category_group] ([poca_poli_id], [poca_cagro_id]) VALUES (4, 1)
INSERT [Master].[policy_category_group] ([poca_poli_id], [poca_cagro_id]) VALUES (2, 2)
INSERT [Master].[policy_category_group] ([poca_poli_id], [poca_cagro_id]) VALUES (5, 2)
INSERT [Master].[policy_category_group] ([poca_poli_id], [poca_cagro_id]) VALUES (3, 3)
INSERT [Master].[policy_category_group] ([poca_poli_id], [poca_cagro_id]) VALUES (1, 4)
INSERT [Master].[policy_category_group] ([poca_poli_id], [poca_cagro_id]) VALUES (2, 4)
INSERT [Master].[policy_category_group] ([poca_poli_id], [poca_cagro_id]) VALUES (4, 4)
INSERT [Master].[policy_category_group] ([poca_poli_id], [poca_cagro_id]) VALUES (5, 4)
INSERT [Master].[policy_category_group] ([poca_poli_id], [poca_cagro_id]) VALUES (1, 5)
INSERT [Master].[policy_category_group] ([poca_poli_id], [poca_cagro_id]) VALUES (3, 5)
INSERT [Master].[policy_category_group] ([poca_poli_id], [poca_cagro_id]) VALUES (4, 5)
INSERT [Master].[policy_category_group] ([poca_poli_id], [poca_cagro_id]) VALUES (5, 5)
INSERT [Master].[policy_category_group] ([poca_poli_id], [poca_cagro_id]) VALUES (2, 6)
INSERT [Master].[policy_category_group] ([poca_poli_id], [poca_cagro_id]) VALUES (4, 6)
INSERT [Master].[policy_category_group] ([poca_poli_id], [poca_cagro_id]) VALUES (5, 6)
INSERT [Master].[policy_category_group] ([poca_poli_id], [poca_cagro_id]) VALUES (1, 7)
INSERT [Master].[policy_category_group] ([poca_poli_id], [poca_cagro_id]) VALUES (3, 7)
INSERT [Master].[policy_category_group] ([poca_poli_id], [poca_cagro_id]) VALUES (5, 7)
GO
SET IDENTITY_INSERT [Master].[price_items] ON 

INSERT [Master].[price_items] ([prit_id], [prit_name], [prit_price], [prit_description], [prit_type], [prit_icon_url], [prit_modified_date]) VALUES (1, N'Minuman Soda', 15000.0000, N'Minuman soda dingin dalam kaleng', N'SOFTDRINK', N'https://example.com/soda.png', NULL)
INSERT [Master].[price_items] ([prit_id], [prit_name], [prit_price], [prit_description], [prit_type], [prit_icon_url], [prit_modified_date]) VALUES (2, N'Coklat Panas', 25000.0000, N'Coklat panas dengan marshmallow di atasnya', N'SNACK', N'https://example.com/chocolate.png', NULL)
INSERT [Master].[price_items] ([prit_id], [prit_name], [prit_price], [prit_description], [prit_type], [prit_icon_url], [prit_modified_date]) VALUES (3, N'Layanan Pijat Kepala', 120000.0000, N'Layanan pijat kepala selama 30 menit', N'SERVICE', N'https://example.com/head-massage.png', NULL)
INSERT [Master].[price_items] ([prit_id], [prit_name], [prit_price], [prit_description], [prit_type], [prit_icon_url], [prit_modified_date]) VALUES (4, N'Makanan Ringan', 20000.0000, N'Kemasan makanan ringan berisi keripik, kacang, dan kacang tanah', N'SNACK', N'https://example.com/snacks.png', NULL)
INSERT [Master].[price_items] ([prit_id], [prit_name], [prit_price], [prit_description], [prit_type], [prit_icon_url], [prit_modified_date]) VALUES (5, N'Kamar Mandi Bersih', 50000.0000, N'Layanan kebersihan kamar mandi', N'SERVICE', N'https://example.com/clean-bathroom.png', NULL)
INSERT [Master].[price_items] ([prit_id], [prit_name], [prit_price], [prit_description], [prit_type], [prit_icon_url], [prit_modified_date]) VALUES (6, N'Sepatu Boot Bercahaya', 100000.0000, N'Sepatu boot bercahaya untuk di malam hari', N'FACILITY', N'https://example.com/light-up-boots.png', NULL)
INSERT [Master].[price_items] ([prit_id], [prit_name], [prit_price], [prit_description], [prit_type], [prit_icon_url], [prit_modified_date]) VALUES (7, N'Paket Sarapan', 75000.0000, N'Paket sarapan berisi roti panggang, telur, dan jus jeruk', N'FOOD', N'https://example.com/breakfast.png', NULL)
INSERT [Master].[price_items] ([prit_id], [prit_name], [prit_price], [prit_description], [prit_type], [prit_icon_url], [prit_modified_date]) VALUES (8, N'Layanan Laundry', 80000.0000, N'Layanan laundry untuk satu set pakaian', N'SERVICE', N'https://example.com/laundry.png', NULL)
INSERT [Master].[price_items] ([prit_id], [prit_name], [prit_price], [prit_description], [prit_type], [prit_icon_url], [prit_modified_date]) VALUES (9, N'Sarapan Ala Inggris', 120000.0000, N'Sarapan ala Inggris dengan telur dadar, sosis, dan kentang goreng', N'FOOD', N'https://example.com/english-breakfast.png', NULL)
INSERT [Master].[price_items] ([prit_id], [prit_name], [prit_price], [prit_description], [prit_type], [prit_icon_url], [prit_modified_date]) VALUES (10, N'Minuman Es', 20000.0000, N'Minuman es yang menyegarkan dengan potongan buah-buahan', N'SOFTDRINK', N'https://example.com/iced-drink.png', NULL)
INSERT [Master].[price_items] ([prit_id], [prit_name], [prit_price], [prit_description], [prit_type], [prit_icon_url], [prit_modified_date]) VALUES (11, N'Pijat Badan', 200000.0000, N'Layanan pijat badan selama 60 menit', N'SERVICE', N'https://example.com/full-body-massage.png', NULL)
INSERT [Master].[price_items] ([prit_id], [prit_name], [prit_price], [prit_description], [prit_type], [prit_icon_url], [prit_modified_date]) VALUES (12, N'Makanan Penutup', 35000.0000, N'Pilihan berbagai makanan penutup lezat', N'FOOD', N'https://example.com/dessert.png', NULL)
INSERT [Master].[price_items] ([prit_id], [prit_name], [prit_price], [prit_description], [prit_type], [prit_icon_url], [prit_modified_date]) VALUES (13, N'Sepatu Pantai', 50000.0000, N'Sepatu pantai yang nyaman dan anti selip', N'FACILITY', N'https://example.com/beach-shoes.png', NULL)
INSERT [Master].[price_items] ([prit_id], [prit_name], [prit_price], [prit_description], [prit_type], [prit_icon_url], [prit_modified_date]) VALUES (14, N'Layanan Kebersihan Kamar', 100000.0000, N'Layanan kebersihan kamar untuk satu kali kunjungan', N'SERVICE', N'https://example.com/clean-room.png', NULL)
INSERT [Master].[price_items] ([prit_id], [prit_name], [prit_price], [prit_description], [prit_type], [prit_icon_url], [prit_modified_date]) VALUES (15, N'Minuman Kemasan', 10000.0000, N'Berbagai pilihan minuman dalam kemasan praktis', N'SOFTDRINK', N'https://example.com/packaged-drink.png', NULL)
SET IDENTITY_INSERT [Master].[price_items] OFF
GO
SET IDENTITY_INSERT [Master].[provinces] ON 

INSERT [Master].[provinces] ([prov_id], [prov_name], [prov_country_id]) VALUES (1, N'Jakarta', 1)
INSERT [Master].[provinces] ([prov_id], [prov_name], [prov_country_id]) VALUES (2, N'Bali', 1)
INSERT [Master].[provinces] ([prov_id], [prov_name], [prov_country_id]) VALUES (3, N'Chiang Mai', 2)
INSERT [Master].[provinces] ([prov_id], [prov_name], [prov_country_id]) VALUES (4, N'Tokyo', 3)
INSERT [Master].[provinces] ([prov_id], [prov_name], [prov_country_id]) VALUES (5, N'Berlin', 4)
INSERT [Master].[provinces] ([prov_id], [prov_name], [prov_country_id]) VALUES (6, N'Paris', 5)
INSERT [Master].[provinces] ([prov_id], [prov_name], [prov_country_id]) VALUES (7, N'California', 6)
INSERT [Master].[provinces] ([prov_id], [prov_name], [prov_country_id]) VALUES (8, N'New York', 6)
INSERT [Master].[provinces] ([prov_id], [prov_name], [prov_country_id]) VALUES (9, N'Ontario', 7)
INSERT [Master].[provinces] ([prov_id], [prov_name], [prov_country_id]) VALUES (10, N'Sao Paulo', 8)
INSERT [Master].[provinces] ([prov_id], [prov_name], [prov_country_id]) VALUES (11, N'Buenos Aires', 9)
INSERT [Master].[provinces] ([prov_id], [prov_name], [prov_country_id]) VALUES (12, N'Cape Town', 10)
INSERT [Master].[provinces] ([prov_id], [prov_name], [prov_country_id]) VALUES (13, N'Durban', 10)
INSERT [Master].[provinces] ([prov_id], [prov_name], [prov_country_id]) VALUES (14, N'Gauteng', 10)
INSERT [Master].[provinces] ([prov_id], [prov_name], [prov_country_id]) VALUES (15, N'Nairobi', 3)
SET IDENTITY_INSERT [Master].[provinces] OFF
GO
SET IDENTITY_INSERT [Master].[regions] ON 

INSERT [Master].[regions] ([region_code], [region_name]) VALUES (5, N'Africa')
INSERT [Master].[regions] ([region_code], [region_name]) VALUES (1, N'Asia')
INSERT [Master].[regions] ([region_code], [region_name]) VALUES (2, N'Europe')
INSERT [Master].[regions] ([region_code], [region_name]) VALUES (3, N'North America')
INSERT [Master].[regions] ([region_code], [region_name]) VALUES (4, N'South America')
SET IDENTITY_INSERT [Master].[regions] OFF
GO
SET IDENTITY_INSERT [Master].[service_task] ON 

INSERT [Master].[service_task] ([seta_id], [seta_name], [seta_seq]) VALUES (1, N'Receptionist', 1)
INSERT [Master].[service_task] ([seta_id], [seta_name], [seta_seq]) VALUES (2, N'Housekeeping', 2)
INSERT [Master].[service_task] ([seta_id], [seta_name], [seta_seq]) VALUES (3, N'Chef', 3)
INSERT [Master].[service_task] ([seta_id], [seta_name], [seta_seq]) VALUES (4, N'Security', 4)
INSERT [Master].[service_task] ([seta_id], [seta_name], [seta_seq]) VALUES (5, N'Manager', 5)
SET IDENTITY_INSERT [Master].[service_task] OFF
GO
INSERT [Payment].[bank] ([bank_entity_id], [bank_code], [bank_name], [bank_modified_date]) VALUES (1, N'002', N'BRI', CAST(N'2023-11-13T14:28:48.410' AS DateTime))
INSERT [Payment].[bank] ([bank_entity_id], [bank_code], [bank_name], [bank_modified_date]) VALUES (2, N'009', N'BNI', CAST(N'2023-11-13T14:28:48.410' AS DateTime))
INSERT [Payment].[bank] ([bank_entity_id], [bank_code], [bank_name], [bank_modified_date]) VALUES (3, N'014', N'BCA', CAST(N'2023-11-13T14:28:48.410' AS DateTime))
INSERT [Payment].[bank] ([bank_entity_id], [bank_code], [bank_name], [bank_modified_date]) VALUES (4, N'427', N'BSI', CAST(N'2023-11-13T14:28:48.410' AS DateTime))
INSERT [Payment].[bank] ([bank_entity_id], [bank_code], [bank_name], [bank_modified_date]) VALUES (5, N'200', N'BTN', CAST(N'2023-11-13T14:28:48.410' AS DateTime))
INSERT [Payment].[bank] ([bank_entity_id], [bank_code], [bank_name], [bank_modified_date]) VALUES (6, N'008', N'MANDIRI', CAST(N'2023-11-13T14:28:48.410' AS DateTime))
INSERT [Payment].[bank] ([bank_entity_id], [bank_code], [bank_name], [bank_modified_date]) VALUES (7, N'147', N'MUAMALAT', CAST(N'2023-11-13T14:28:48.410' AS DateTime))
GO
SET IDENTITY_INSERT [Payment].[entity] ON 

INSERT [Payment].[entity] ([entity_id]) VALUES (1)
INSERT [Payment].[entity] ([entity_id]) VALUES (2)
INSERT [Payment].[entity] ([entity_id]) VALUES (3)
INSERT [Payment].[entity] ([entity_id]) VALUES (4)
INSERT [Payment].[entity] ([entity_id]) VALUES (5)
INSERT [Payment].[entity] ([entity_id]) VALUES (6)
INSERT [Payment].[entity] ([entity_id]) VALUES (7)
INSERT [Payment].[entity] ([entity_id]) VALUES (8)
INSERT [Payment].[entity] ([entity_id]) VALUES (9)
INSERT [Payment].[entity] ([entity_id]) VALUES (10)
INSERT [Payment].[entity] ([entity_id]) VALUES (11)
INSERT [Payment].[entity] ([entity_id]) VALUES (12)
INSERT [Payment].[entity] ([entity_id]) VALUES (13)
INSERT [Payment].[entity] ([entity_id]) VALUES (14)
INSERT [Payment].[entity] ([entity_id]) VALUES (15)
INSERT [Payment].[entity] ([entity_id]) VALUES (16)
INSERT [Payment].[entity] ([entity_id]) VALUES (17)
INSERT [Payment].[entity] ([entity_id]) VALUES (18)
INSERT [Payment].[entity] ([entity_id]) VALUES (19)
INSERT [Payment].[entity] ([entity_id]) VALUES (20)
INSERT [Payment].[entity] ([entity_id]) VALUES (21)
INSERT [Payment].[entity] ([entity_id]) VALUES (22)
INSERT [Payment].[entity] ([entity_id]) VALUES (23)
INSERT [Payment].[entity] ([entity_id]) VALUES (24)
INSERT [Payment].[entity] ([entity_id]) VALUES (25)
SET IDENTITY_INSERT [Payment].[entity] OFF
GO
INSERT [Payment].[payment_gateway] ([paga_entity_id], [paga_code], [paga_name], [paga_modified_date]) VALUES (8, N'GOTO', N'PT. Dompet Anak Bangsa', CAST(N'2023-11-13T14:28:48.413' AS DateTime))
INSERT [Payment].[payment_gateway] ([paga_entity_id], [paga_code], [paga_name], [paga_modified_date]) VALUES (9, N'OVO', N'PT. Visionet Internasional', CAST(N'2023-11-13T14:28:48.413' AS DateTime))
INSERT [Payment].[payment_gateway] ([paga_entity_id], [paga_code], [paga_name], [paga_modified_date]) VALUES (10, N'DANA', N'PT. Espay Debit Indonesia', CAST(N'2023-11-13T14:28:48.413' AS DateTime))
INSERT [Payment].[payment_gateway] ([paga_entity_id], [paga_code], [paga_name], [paga_modified_date]) VALUES (11, N'SHOPEEPAY', N'Shopee', CAST(N'2023-11-13T14:28:48.413' AS DateTime))
INSERT [Payment].[payment_gateway] ([paga_entity_id], [paga_code], [paga_name], [paga_modified_date]) VALUES (12, N'FLIP', N'Fintek Karya Nusantara', CAST(N'2023-11-13T14:28:48.413' AS DateTime))
INSERT [Payment].[payment_gateway] ([paga_entity_id], [paga_code], [paga_name], [paga_modified_date]) VALUES (13, N'JENIUS', N'PT. Bank BTPN Tbk', CAST(N'2023-11-13T14:28:48.413' AS DateTime))
INSERT [Payment].[payment_gateway] ([paga_entity_id], [paga_code], [paga_name], [paga_modified_date]) VALUES (14, N'JAGO', N'PT. Bank Jago Tbk', CAST(N'2023-11-13T14:28:48.413' AS DateTime))
INSERT [Payment].[payment_gateway] ([paga_entity_id], [paga_code], [paga_name], [paga_modified_date]) VALUES (15, N'SAKUKU', N'PT. Bank Central Asia Tbk', CAST(N'2023-11-13T14:28:48.413' AS DateTime))
GO
SET IDENTITY_INSERT [Payment].[payment_transaction] ON 

INSERT [Payment].[payment_transaction] ([patr_id], [patr_trx_number], [patr_debet], [patr_credit], [patr_type], [patr_note], [patr_modified_date], [patr_order_number], [patr_source_id], [patr_target_id], [patr_trx_number_ref], [patr_user_id]) VALUES (1, N'TRB#231113-0001', 0.0000, 200000.0000, N'TRB', N'Transfer Booking Note', CAST(N'2023-11-13T14:15:41.960' AS DateTime), N'BO#20221127-0001', N'431-2388-93', N'131-3456-78', NULL, 1)
INSERT [Payment].[payment_transaction] ([patr_id], [patr_trx_number], [patr_debet], [patr_credit], [patr_type], [patr_note], [patr_modified_date], [patr_order_number], [patr_source_id], [patr_target_id], [patr_trx_number_ref], [patr_user_id]) VALUES (2, N'TRB#231113-0002', 200000.0000, 0.0000, N'TRB', N'Transfer Booking Note', CAST(N'2023-11-13T14:15:41.960' AS DateTime), N'BO#20221127-0001', N'431-2388-93', N'131-3456-78', NULL, NULL)
INSERT [Payment].[payment_transaction] ([patr_id], [patr_trx_number], [patr_debet], [patr_credit], [patr_type], [patr_note], [patr_modified_date], [patr_order_number], [patr_source_id], [patr_target_id], [patr_trx_number_ref], [patr_user_id]) VALUES (3, N'ORM#231113-0003', 0.0000, 40000.0000, N'ORM', N'Transfer Order Menu Note', CAST(N'2023-11-13T14:15:41.973' AS DateTime), N'MENUS#20220101-00001', N'431-2388-93', N'131-3456-78', NULL, 1)
INSERT [Payment].[payment_transaction] ([patr_id], [patr_trx_number], [patr_debet], [patr_credit], [patr_type], [patr_note], [patr_modified_date], [patr_order_number], [patr_source_id], [patr_target_id], [patr_trx_number_ref], [patr_user_id]) VALUES (4, N'ORM#231113-0004', 40000.0000, 0.0000, N'ORM', N'Transfer Order Menu Note', CAST(N'2023-11-13T14:15:41.973' AS DateTime), N'MENUS#20220101-00001', N'431-2388-93', N'131-3456-78', NULL, NULL)
INSERT [Payment].[payment_transaction] ([patr_id], [patr_trx_number], [patr_debet], [patr_credit], [patr_type], [patr_note], [patr_modified_date], [patr_order_number], [patr_source_id], [patr_target_id], [patr_trx_number_ref], [patr_user_id]) VALUES (5, N'RF#231113-0005', 0.0000, 100000.0000, N'RF ', N'*Refund Booking Order', CAST(N'2023-11-13T14:15:41.990' AS DateTime), NULL, N'131-3456-78', N'431-2388-93', N'TRB#231113-0001', 1)
INSERT [Payment].[payment_transaction] ([patr_id], [patr_trx_number], [patr_debet], [patr_credit], [patr_type], [patr_note], [patr_modified_date], [patr_order_number], [patr_source_id], [patr_target_id], [patr_trx_number_ref], [patr_user_id]) VALUES (6, N'RF#231113-0006', 100000.0000, 0.0000, N'RF ', N'*Refund Booking Order', CAST(N'2023-11-13T14:15:41.990' AS DateTime), NULL, N'131-3456-78', N'431-2388-93', N'TRB#231113-0001', NULL)
INSERT [Payment].[payment_transaction] ([patr_id], [patr_trx_number], [patr_debet], [patr_credit], [patr_type], [patr_note], [patr_modified_date], [patr_order_number], [patr_source_id], [patr_target_id], [patr_trx_number_ref], [patr_user_id]) VALUES (7, N'TP#231113-0007', 0.0000, 20000.0000, N'TP ', N'Top Up Note', CAST(N'2023-11-13T14:15:42.010' AS DateTime), NULL, N'992-1923-39', N'087363155421', NULL, 4)
INSERT [Payment].[payment_transaction] ([patr_id], [patr_trx_number], [patr_debet], [patr_credit], [patr_type], [patr_note], [patr_modified_date], [patr_order_number], [patr_source_id], [patr_target_id], [patr_trx_number_ref], [patr_user_id]) VALUES (8, N'TP#231113-0008', 20000.0000, 0.0000, N'TP ', N'Top Up Note', CAST(N'2023-11-13T14:15:42.010' AS DateTime), NULL, N'992-1923-39', N'087363155421', NULL, NULL)
INSERT [Payment].[payment_transaction] ([patr_id], [patr_trx_number], [patr_debet], [patr_credit], [patr_type], [patr_note], [patr_modified_date], [patr_order_number], [patr_source_id], [patr_target_id], [patr_trx_number_ref], [patr_user_id]) VALUES (9, N'RPY#231113-0009', 0.0000, 300000.0000, N'RPY', N'Repayment', CAST(N'2023-11-13T14:15:42.023' AS DateTime), N'BO#20221127-0001', N'431-2388-93', N'131-3456-78', N'TRB#231113-0001', 1)
INSERT [Payment].[payment_transaction] ([patr_id], [patr_trx_number], [patr_debet], [patr_credit], [patr_type], [patr_note], [patr_modified_date], [patr_order_number], [patr_source_id], [patr_target_id], [patr_trx_number_ref], [patr_user_id]) VALUES (10, N'RPY#231113-0010', 300000.0000, 0.0000, N'RPY', N'Repayment', CAST(N'2023-11-13T14:15:42.023' AS DateTime), N'BO#20221127-0001', N'431-2388-93', N'131-3456-78', N'TRB#231113-0001', NULL)
SET IDENTITY_INSERT [Payment].[payment_transaction] OFF
GO
SET IDENTITY_INSERT [Payment].[user_accounts] ON 

INSERT [Payment].[user_accounts] ([usac_id], [usac_entity_id], [usac_user_id], [usac_account_number], [usac_saldo], [usac_type], [usac_expmonth], [usac_expyear], [usac_modified_date]) VALUES (1, 1, 1, N'431-2388-93', 1000000.0000, N'debet', 11, 22, CAST(N'2023-11-13T14:28:48.417' AS DateTime))
INSERT [Payment].[user_accounts] ([usac_id], [usac_entity_id], [usac_user_id], [usac_account_number], [usac_saldo], [usac_type], [usac_expmonth], [usac_expyear], [usac_modified_date]) VALUES (2, 1, 2, N'123-2993-32', 0.0000, N'credit_card', 12, 27, CAST(N'2023-11-13T14:28:48.417' AS DateTime))
INSERT [Payment].[user_accounts] ([usac_id], [usac_entity_id], [usac_user_id], [usac_account_number], [usac_saldo], [usac_type], [usac_expmonth], [usac_expyear], [usac_modified_date]) VALUES (3, 3, 3, N'131-3456-78', 0.0000, N'debet', 5, 25, CAST(N'2023-11-13T14:28:48.417' AS DateTime))
INSERT [Payment].[user_accounts] ([usac_id], [usac_entity_id], [usac_user_id], [usac_account_number], [usac_saldo], [usac_type], [usac_expmonth], [usac_expyear], [usac_modified_date]) VALUES (4, 4, 4, N'992-1923-39', 1000000.0000, N'debet', 8, 24, CAST(N'2023-11-13T14:28:48.417' AS DateTime))
INSERT [Payment].[user_accounts] ([usac_id], [usac_entity_id], [usac_user_id], [usac_account_number], [usac_saldo], [usac_type], [usac_expmonth], [usac_expyear], [usac_modified_date]) VALUES (11, 11, 4, N'087363155421', 500000.0000, N'payment', NULL, NULL, CAST(N'2023-11-13T14:28:48.417' AS DateTime))
INSERT [Payment].[user_accounts] ([usac_id], [usac_entity_id], [usac_user_id], [usac_account_number], [usac_saldo], [usac_type], [usac_expmonth], [usac_expyear], [usac_modified_date]) VALUES (5, 5, 5, N'727-1931-34', 0.0000, N'debet', 9, 28, CAST(N'2023-11-13T14:28:48.417' AS DateTime))
INSERT [Payment].[user_accounts] ([usac_id], [usac_entity_id], [usac_user_id], [usac_account_number], [usac_saldo], [usac_type], [usac_expmonth], [usac_expyear], [usac_modified_date]) VALUES (6, 6, 6, N'889-3921-22', 0.0000, N'credit_card', 2, 25, CAST(N'2023-11-13T14:28:48.417' AS DateTime))
INSERT [Payment].[user_accounts] ([usac_id], [usac_entity_id], [usac_user_id], [usac_account_number], [usac_saldo], [usac_type], [usac_expmonth], [usac_expyear], [usac_modified_date]) VALUES (7, 7, 7, N'571-2939-23', 1000000.0000, N'debet', 1, 26, CAST(N'2023-11-13T14:28:48.417' AS DateTime))
INSERT [Payment].[user_accounts] ([usac_id], [usac_entity_id], [usac_user_id], [usac_account_number], [usac_saldo], [usac_type], [usac_expmonth], [usac_expyear], [usac_modified_date]) VALUES (8, 8, 8, N'11-1111-1111', 500000.0000, N'payment', NULL, NULL, CAST(N'2023-11-13T14:28:48.417' AS DateTime))
INSERT [Payment].[user_accounts] ([usac_id], [usac_entity_id], [usac_user_id], [usac_account_number], [usac_saldo], [usac_type], [usac_expmonth], [usac_expyear], [usac_modified_date]) VALUES (9, 9, 9, N'0873635251525', 500000.0000, N'payment', NULL, NULL, CAST(N'2023-11-13T14:28:48.417' AS DateTime))
INSERT [Payment].[user_accounts] ([usac_id], [usac_entity_id], [usac_user_id], [usac_account_number], [usac_saldo], [usac_type], [usac_expmonth], [usac_expyear], [usac_modified_date]) VALUES (10, 10, 10, N'081289389126', 500000.0000, N'payment', NULL, NULL, CAST(N'2023-11-13T14:28:48.417' AS DateTime))
INSERT [Payment].[user_accounts] ([usac_id], [usac_entity_id], [usac_user_id], [usac_account_number], [usac_saldo], [usac_type], [usac_expmonth], [usac_expyear], [usac_modified_date]) VALUES (12, 12, 12, N'087365291212', 500000.0000, N'payment', NULL, NULL, CAST(N'2023-11-13T14:28:48.417' AS DateTime))
INSERT [Payment].[user_accounts] ([usac_id], [usac_entity_id], [usac_user_id], [usac_account_number], [usac_saldo], [usac_type], [usac_expmonth], [usac_expyear], [usac_modified_date]) VALUES (13, 13, 13, N'081928222364', 500000.0000, N'payment', NULL, NULL, CAST(N'2023-11-13T14:28:48.417' AS DateTime))
INSERT [Payment].[user_accounts] ([usac_id], [usac_entity_id], [usac_user_id], [usac_account_number], [usac_saldo], [usac_type], [usac_expmonth], [usac_expyear], [usac_modified_date]) VALUES (14, 14, 14, N'089012852546', 500000.0000, N'payment', NULL, NULL, CAST(N'2023-11-13T14:28:48.417' AS DateTime))
INSERT [Payment].[user_accounts] ([usac_id], [usac_entity_id], [usac_user_id], [usac_account_number], [usac_saldo], [usac_type], [usac_expmonth], [usac_expyear], [usac_modified_date]) VALUES (15, 15, 15, N'085627287172', 500000.0000, N'payment', NULL, NULL, CAST(N'2023-11-13T14:28:48.417' AS DateTime))
INSERT [Payment].[user_accounts] ([usac_id], [usac_entity_id], [usac_user_id], [usac_account_number], [usac_saldo], [usac_type], [usac_expmonth], [usac_expyear], [usac_modified_date]) VALUES (16, 16, 16, N'555-9876-123', 2000000.0000, N'credit_card', 10, 23, CAST(N'2023-11-13T15:50:28.833' AS DateTime))
INSERT [Payment].[user_accounts] ([usac_id], [usac_entity_id], [usac_user_id], [usac_account_number], [usac_saldo], [usac_type], [usac_expmonth], [usac_expyear], [usac_modified_date]) VALUES (17, 17, 17, N'777-2345-678', 0.0000, N'debet', 6, 26, CAST(N'2023-11-13T15:50:28.833' AS DateTime))
INSERT [Payment].[user_accounts] ([usac_id], [usac_entity_id], [usac_user_id], [usac_account_number], [usac_saldo], [usac_type], [usac_expmonth], [usac_expyear], [usac_modified_date]) VALUES (18, 18, 18, N'999-3456-789', 500000.0000, N'payment', NULL, NULL, CAST(N'2023-11-13T15:50:28.833' AS DateTime))
INSERT [Payment].[user_accounts] ([usac_id], [usac_entity_id], [usac_user_id], [usac_account_number], [usac_saldo], [usac_type], [usac_expmonth], [usac_expyear], [usac_modified_date]) VALUES (19, 19, 19, N'123-4567-890', 1500000.0000, N'debet', 7, 24, CAST(N'2023-11-13T15:50:28.833' AS DateTime))
INSERT [Payment].[user_accounts] ([usac_id], [usac_entity_id], [usac_user_id], [usac_account_number], [usac_saldo], [usac_type], [usac_expmonth], [usac_expyear], [usac_modified_date]) VALUES (20, 20, 20, N'111-2222-333', 0.0000, N'credit_card', 3, 25, CAST(N'2023-11-13T15:50:28.833' AS DateTime))
INSERT [Payment].[user_accounts] ([usac_id], [usac_entity_id], [usac_user_id], [usac_account_number], [usac_saldo], [usac_type], [usac_expmonth], [usac_expyear], [usac_modified_date]) VALUES (21, 21, 21, N'444-5678-901', 1000000.0000, N'debet', 9, 27, CAST(N'2023-11-13T15:50:28.833' AS DateTime))
INSERT [Payment].[user_accounts] ([usac_id], [usac_entity_id], [usac_user_id], [usac_account_number], [usac_saldo], [usac_type], [usac_expmonth], [usac_expyear], [usac_modified_date]) VALUES (22, 22, 22, N'888-9999-111', 0.0000, N'debet', 11, 23, CAST(N'2023-11-13T15:50:28.833' AS DateTime))
INSERT [Payment].[user_accounts] ([usac_id], [usac_entity_id], [usac_user_id], [usac_account_number], [usac_saldo], [usac_type], [usac_expmonth], [usac_expyear], [usac_modified_date]) VALUES (23, 23, 23, N'123-9876-543', 500000.0000, N'credit_card', 5, 28, CAST(N'2023-11-13T15:50:28.833' AS DateTime))
INSERT [Payment].[user_accounts] ([usac_id], [usac_entity_id], [usac_user_id], [usac_account_number], [usac_saldo], [usac_type], [usac_expmonth], [usac_expyear], [usac_modified_date]) VALUES (24, 24, 24, N'987-6543-210', 0.0000, N'debet', 2, 24, CAST(N'2023-11-13T15:50:28.833' AS DateTime))
INSERT [Payment].[user_accounts] ([usac_id], [usac_entity_id], [usac_user_id], [usac_account_number], [usac_saldo], [usac_type], [usac_expmonth], [usac_expyear], [usac_modified_date]) VALUES (25, 25, 25, N'555-1234-567', 2000000.0000, N'debet', 12, 26, CAST(N'2023-11-13T15:50:28.833' AS DateTime))
SET IDENTITY_INSERT [Payment].[user_accounts] OFF
GO
SET IDENTITY_INSERT [Purchasing].[cart] ON 

INSERT [Purchasing].[cart] ([cart_id], [cart_emp_id], [cart_vepro_id], [cart_order_qty], [cart_modified_date]) VALUES (1, 1, 1, 2, CAST(N'2023-11-13T14:15:42.093' AS DateTime))
INSERT [Purchasing].[cart] ([cart_id], [cart_emp_id], [cart_vepro_id], [cart_order_qty], [cart_modified_date]) VALUES (2, 1, 2, 1, CAST(N'2023-11-13T14:15:42.093' AS DateTime))
INSERT [Purchasing].[cart] ([cart_id], [cart_emp_id], [cart_vepro_id], [cart_order_qty], [cart_modified_date]) VALUES (3, 3, 3, 3, CAST(N'2023-11-13T14:15:42.093' AS DateTime))
INSERT [Purchasing].[cart] ([cart_id], [cart_emp_id], [cart_vepro_id], [cart_order_qty], [cart_modified_date]) VALUES (4, 4, 4, 2, CAST(N'2023-11-13T14:15:42.093' AS DateTime))
INSERT [Purchasing].[cart] ([cart_id], [cart_emp_id], [cart_vepro_id], [cart_order_qty], [cart_modified_date]) VALUES (5, 5, 5, 1, CAST(N'2023-11-13T14:15:42.093' AS DateTime))
SET IDENTITY_INSERT [Purchasing].[cart] OFF
GO
SET IDENTITY_INSERT [Purchasing].[purchase_order_detail] ON 

INSERT [Purchasing].[purchase_order_detail] ([pode_id], [pode_pohe_id], [pode_order_qty], [pode_price], [pode_received_qty], [pode_rejected_qty], [pode_modified_date], [pode_stock_id]) VALUES (1, 1, 10, 100000.0000, CAST(9.00 AS Decimal(8, 2)), CAST(1.00 AS Decimal(8, 2)), CAST(N'2023-11-13T14:15:42.070' AS DateTime), 1)
INSERT [Purchasing].[purchase_order_detail] ([pode_id], [pode_pohe_id], [pode_order_qty], [pode_price], [pode_received_qty], [pode_rejected_qty], [pode_modified_date], [pode_stock_id]) VALUES (2, 2, 50, 300000.0000, CAST(48.00 AS Decimal(8, 2)), CAST(2.00 AS Decimal(8, 2)), CAST(N'2023-11-13T14:15:42.070' AS DateTime), 5)
INSERT [Purchasing].[purchase_order_detail] ([pode_id], [pode_pohe_id], [pode_order_qty], [pode_price], [pode_received_qty], [pode_rejected_qty], [pode_modified_date], [pode_stock_id]) VALUES (3, 3, 60, 350000.0000, CAST(57.00 AS Decimal(8, 2)), CAST(3.00 AS Decimal(8, 2)), CAST(N'2023-11-13T14:15:42.070' AS DateTime), 1)
INSERT [Purchasing].[purchase_order_detail] ([pode_id], [pode_pohe_id], [pode_order_qty], [pode_price], [pode_received_qty], [pode_rejected_qty], [pode_modified_date], [pode_stock_id]) VALUES (4, 4, 100, 550000.0000, CAST(97.00 AS Decimal(8, 2)), CAST(3.00 AS Decimal(8, 2)), CAST(N'2023-11-13T14:15:42.070' AS DateTime), 5)
INSERT [Purchasing].[purchase_order_detail] ([pode_id], [pode_pohe_id], [pode_order_qty], [pode_price], [pode_received_qty], [pode_rejected_qty], [pode_modified_date], [pode_stock_id]) VALUES (5, 5, 110, 600000.0000, CAST(107.00 AS Decimal(8, 2)), CAST(3.00 AS Decimal(8, 2)), CAST(N'2023-11-13T14:15:42.070' AS DateTime), 1)
SET IDENTITY_INSERT [Purchasing].[purchase_order_detail] OFF
GO
SET IDENTITY_INSERT [Purchasing].[purchase_order_header] ON 

INSERT [Purchasing].[purchase_order_header] ([pohe_id], [pohe_number], [pohe_status], [pohe_order_date], [pohe_subtotal], [pohe_tax], [pohe_refund], [pohe_arrival_date], [pohe_pay_type], [pohe_emp_id], [pohe_vendor_id]) VALUES (1, N'PO-20230115-001', 1, CAST(N'2023-11-13T14:15:42.070' AS DateTime), 1000000.0000, 0.1000, 0.0000, NULL, N'CA', 1, 16)
INSERT [Purchasing].[purchase_order_header] ([pohe_id], [pohe_number], [pohe_status], [pohe_order_date], [pohe_subtotal], [pohe_tax], [pohe_refund], [pohe_arrival_date], [pohe_pay_type], [pohe_emp_id], [pohe_vendor_id]) VALUES (2, N'PO-20230115-002', 1, CAST(N'2023-11-13T14:15:42.070' AS DateTime), 15000000.0000, 0.1000, 0.0000, NULL, N'CA', 1, 17)
INSERT [Purchasing].[purchase_order_header] ([pohe_id], [pohe_number], [pohe_status], [pohe_order_date], [pohe_subtotal], [pohe_tax], [pohe_refund], [pohe_arrival_date], [pohe_pay_type], [pohe_emp_id], [pohe_vendor_id]) VALUES (3, N'PO-20230115-003', 1, CAST(N'2023-11-13T14:15:42.070' AS DateTime), 21000000.0000, 0.1000, 0.0000, NULL, N'TR', 1, 18)
INSERT [Purchasing].[purchase_order_header] ([pohe_id], [pohe_number], [pohe_status], [pohe_order_date], [pohe_subtotal], [pohe_tax], [pohe_refund], [pohe_arrival_date], [pohe_pay_type], [pohe_emp_id], [pohe_vendor_id]) VALUES (4, N'PO-20230115-004', 1, CAST(N'2023-11-15T14:15:42.070' AS DateTime), 55000000.0000, 0.1000, 0.0000, NULL, N'TR', 1, 19)
INSERT [Purchasing].[purchase_order_header] ([pohe_id], [pohe_number], [pohe_status], [pohe_order_date], [pohe_subtotal], [pohe_tax], [pohe_refund], [pohe_arrival_date], [pohe_pay_type], [pohe_emp_id], [pohe_vendor_id]) VALUES (5, N'PO-20230115-005', 1, CAST(N'2023-11-20T14:15:42.070' AS DateTime), 66000000.0000, 0.1000, 0.0000, NULL, N'CA', 1, 20)
SET IDENTITY_INSERT [Purchasing].[purchase_order_header] OFF
GO
SET IDENTITY_INSERT [Purchasing].[stock_detail] ON 

INSERT [Purchasing].[stock_detail] ([stod_id], [stod_stock_id], [stod_barcode_number], [stod_status], [stod_notes], [stod_faci_id], [stod_pohe_id]) VALUES (1, 1, N'Barcode Sprei 1', N'2 ', N'Sprei di kamar 101', 1, 1)
INSERT [Purchasing].[stock_detail] ([stod_id], [stod_stock_id], [stod_barcode_number], [stod_status], [stod_notes], [stod_faci_id], [stod_pohe_id]) VALUES (2, 2, N'Barcode Bantal 1', N'3 ', N'Bantal di kamar 106', 2, 2)
INSERT [Purchasing].[stock_detail] ([stod_id], [stod_stock_id], [stod_barcode_number], [stod_status], [stod_notes], [stod_faci_id], [stod_pohe_id]) VALUES (3, 3, N'Barcode Handuk 10', N'1 ', N'Handuk di kamar 115', 3, 3)
INSERT [Purchasing].[stock_detail] ([stod_id], [stod_stock_id], [stod_barcode_number], [stod_status], [stod_notes], [stod_faci_id], [stod_pohe_id]) VALUES (4, 4, N'Barcode Gorden 5', N'1 ', N'Gorden di kamar 120', 4, 4)
INSERT [Purchasing].[stock_detail] ([stod_id], [stod_stock_id], [stod_barcode_number], [stod_status], [stod_notes], [stod_faci_id], [stod_pohe_id]) VALUES (5, 5, N'Barcode Gelas 5', N'1 ', N'Gelas di kamar 125', 5, 5)
SET IDENTITY_INSERT [Purchasing].[stock_detail] OFF
GO
SET IDENTITY_INSERT [Purchasing].[stock_photo] ON 

INSERT [Purchasing].[stock_photo] ([spho_id], [spho_thumbnail_filename], [spho_photo_filename], [spho_primary], [spho_url], [spho_stock_id]) VALUES (1, N'thumbnail-1.jpg', N'photo-1.jpg', 1, N'https://stock-photos.com/thumbnail-1.jpg', 1)
INSERT [Purchasing].[stock_photo] ([spho_id], [spho_thumbnail_filename], [spho_photo_filename], [spho_primary], [spho_url], [spho_stock_id]) VALUES (2, N'thumbnail-2.jpg', N'photo-2.jpg', 0, N'https://stock-photos.com/thumbnail-2.jpg', 2)
INSERT [Purchasing].[stock_photo] ([spho_id], [spho_thumbnail_filename], [spho_photo_filename], [spho_primary], [spho_url], [spho_stock_id]) VALUES (3, N'thumbnail-3.jpg', N'photo-3.jpg', 0, N'https://stock-photos.com/thumbnail-3.jpg', 3)
INSERT [Purchasing].[stock_photo] ([spho_id], [spho_thumbnail_filename], [spho_photo_filename], [spho_primary], [spho_url], [spho_stock_id]) VALUES (4, N'thumbnail-4.jpg', N'photo-4.jpg', 1, N'https://stock-photos.com/thumbnail-4.jpg', 4)
INSERT [Purchasing].[stock_photo] ([spho_id], [spho_thumbnail_filename], [spho_photo_filename], [spho_primary], [spho_url], [spho_stock_id]) VALUES (5, N'thumbnail-5.jpg', N'photo-5.jpg', 0, N'https://stock-photos.com/thumbnail-5.jpg', 5)
SET IDENTITY_INSERT [Purchasing].[stock_photo] OFF
GO
SET IDENTITY_INSERT [Purchasing].[stocks] ON 

INSERT [Purchasing].[stocks] ([stock_id], [stock_name], [stock_description], [stock_quantity], [stock_reorder_point], [stock_used], [stock_scrap], [stock_price], [stock_standar_cost], [stock_size], [stock_color], [stock_modified_date]) VALUES (1, N'Sprei Hotel', N'Sprei dengan bahan yang nyaman dan tahan lama', 0, 0, 0, 0, 0.0000, 0.0000, N'King', N'Putih', CAST(N'2023-11-13T14:15:42.060' AS DateTime))
INSERT [Purchasing].[stocks] ([stock_id], [stock_name], [stock_description], [stock_quantity], [stock_reorder_point], [stock_used], [stock_scrap], [stock_price], [stock_standar_cost], [stock_size], [stock_color], [stock_modified_date]) VALUES (2, N'Bantal Hotel', N'Bantal dengan bahan yang nyaman dan tahan lama', 0, 0, 0, 0, 0.0000, 0.0000, N'Standard', N'Putih', CAST(N'2023-11-13T14:15:42.060' AS DateTime))
INSERT [Purchasing].[stocks] ([stock_id], [stock_name], [stock_description], [stock_quantity], [stock_reorder_point], [stock_used], [stock_scrap], [stock_price], [stock_standar_cost], [stock_size], [stock_color], [stock_modified_date]) VALUES (3, N'Handuk Hotel', N'Handuk dengan bahan yang nyaman dan tahan lama', 0, 0, 0, 0, 0.0000, 0.0000, N'Standard', N'Putih', CAST(N'2023-11-13T14:15:42.060' AS DateTime))
INSERT [Purchasing].[stocks] ([stock_id], [stock_name], [stock_description], [stock_quantity], [stock_reorder_point], [stock_used], [stock_scrap], [stock_price], [stock_standar_cost], [stock_size], [stock_color], [stock_modified_date]) VALUES (4, N'Gorden Hotel', N'Gorden dengan bahan yang tahan lama dan mudah dicuci', 0, 0, 0, 0, 0.0000, 0.0000, N'Standard', N'Putih', CAST(N'2023-11-13T14:15:42.060' AS DateTime))
INSERT [Purchasing].[stocks] ([stock_id], [stock_name], [stock_description], [stock_quantity], [stock_reorder_point], [stock_used], [stock_scrap], [stock_price], [stock_standar_cost], [stock_size], [stock_color], [stock_modified_date]) VALUES (5, N'Gelas Hotel', N'Gelas dengan bahan yang tahan lama dan mudah dicuci', 0, 0, 0, 0, 0.0000, 0.0000, N'Standard', N'Transparan', CAST(N'2023-11-13T14:15:42.060' AS DateTime))
SET IDENTITY_INSERT [Purchasing].[stocks] OFF
GO
INSERT [Purchasing].[vendor] ([vendor_entity_id], [vendor_name], [vendor_active], [vendor_priority], [vendor_register_date], [vendor_weburl], [vendor_modified_date]) VALUES (16, N'Global Equipment Co.', 1, 0, CAST(N'2023-11-13T14:15:42.060' AS DateTime), N'www.globalequipment.com', CAST(N'2023-11-13T14:15:42.060' AS DateTime))
INSERT [Purchasing].[vendor] ([vendor_entity_id], [vendor_name], [vendor_active], [vendor_priority], [vendor_register_date], [vendor_weburl], [vendor_modified_date]) VALUES (17, N'Sustainable Solutions Inc.', 1, 1, CAST(N'2023-11-13T14:15:42.060' AS DateTime), N'www.sustainablesolutions.com', CAST(N'2023-11-13T14:15:42.060' AS DateTime))
INSERT [Purchasing].[vendor] ([vendor_entity_id], [vendor_name], [vendor_active], [vendor_priority], [vendor_register_date], [vendor_weburl], [vendor_modified_date]) VALUES (18, N'Quality Parts LLC', 1, 0, CAST(N'2023-11-13T14:15:42.060' AS DateTime), N'www.qualityparts.com', CAST(N'2023-11-13T14:15:42.060' AS DateTime))
INSERT [Purchasing].[vendor] ([vendor_entity_id], [vendor_name], [vendor_active], [vendor_priority], [vendor_register_date], [vendor_weburl], [vendor_modified_date]) VALUES (19, N'Innovative Technologies Corp.', 0, 1, CAST(N'2023-11-13T14:15:42.060' AS DateTime), N'www.innovativetechnologies.com', CAST(N'2023-11-13T14:15:42.060' AS DateTime))
INSERT [Purchasing].[vendor] ([vendor_entity_id], [vendor_name], [vendor_active], [vendor_priority], [vendor_register_date], [vendor_weburl], [vendor_modified_date]) VALUES (20, N'Dynamic Enterprises Inc.', 1, 0, CAST(N'2023-11-13T14:15:42.060' AS DateTime), N'www.dynamicenterprises.com', CAST(N'2023-11-13T14:15:42.060' AS DateTime))
INSERT [Purchasing].[vendor] ([vendor_entity_id], [vendor_name], [vendor_active], [vendor_priority], [vendor_register_date], [vendor_weburl], [vendor_modified_date]) VALUES (21, N'Elite Supplies Co.', 1, 1, CAST(N'2023-11-13T14:15:42.060' AS DateTime), N'www.elitesupplies.com', CAST(N'2023-11-13T14:15:42.060' AS DateTime))
INSERT [Purchasing].[vendor] ([vendor_entity_id], [vendor_name], [vendor_active], [vendor_priority], [vendor_register_date], [vendor_weburl], [vendor_modified_date]) VALUES (22, N'Superior Products LLC', 0, 0, CAST(N'2023-11-13T14:15:42.060' AS DateTime), N'www.superiorproducts.com', CAST(N'2023-11-13T14:15:42.060' AS DateTime))
INSERT [Purchasing].[vendor] ([vendor_entity_id], [vendor_name], [vendor_active], [vendor_priority], [vendor_register_date], [vendor_weburl], [vendor_modified_date]) VALUES (23, N'Advanced Materials Inc.', 1, 1, CAST(N'2023-11-13T14:15:42.060' AS DateTime), N'www.advancedmaterials.com', CAST(N'2023-11-13T14:15:42.060' AS DateTime))
INSERT [Purchasing].[vendor] ([vendor_entity_id], [vendor_name], [vendor_active], [vendor_priority], [vendor_register_date], [vendor_weburl], [vendor_modified_date]) VALUES (24, N'Bright Ideas Inc.', 1, 0, CAST(N'2023-11-13T14:15:42.060' AS DateTime), N'www.brightideas.com', CAST(N'2023-11-13T14:15:42.060' AS DateTime))
INSERT [Purchasing].[vendor] ([vendor_entity_id], [vendor_name], [vendor_active], [vendor_priority], [vendor_register_date], [vendor_weburl], [vendor_modified_date]) VALUES (25, N'Progressive Solutions Inc.', 0, 1, CAST(N'2023-11-13T14:15:42.060' AS DateTime), N'www.progressivesolutions.com', CAST(N'2023-11-13T14:15:42.060' AS DateTime))
GO
SET IDENTITY_INSERT [Purchasing].[vendor_product] ON 

INSERT [Purchasing].[vendor_product] ([vepro_id], [vepro_qty_stocked], [vepro_qty_remaining], [vepro_price], [venpro_stock_id], [vepro_vendor_id]) VALUES (1, 3, 2, 1000000.0000, 1, 25)
INSERT [Purchasing].[vendor_product] ([vepro_id], [vepro_qty_stocked], [vepro_qty_remaining], [vepro_price], [venpro_stock_id], [vepro_vendor_id]) VALUES (2, 5, 6, 2000000.0000, 2, 24)
INSERT [Purchasing].[vendor_product] ([vepro_id], [vepro_qty_stocked], [vepro_qty_remaining], [vepro_price], [venpro_stock_id], [vepro_vendor_id]) VALUES (3, 2, 2, 3000000.0000, 3, 23)
INSERT [Purchasing].[vendor_product] ([vepro_id], [vepro_qty_stocked], [vepro_qty_remaining], [vepro_price], [venpro_stock_id], [vepro_vendor_id]) VALUES (4, 4, 4, 4000000.0000, 4, 22)
INSERT [Purchasing].[vendor_product] ([vepro_id], [vepro_qty_stocked], [vepro_qty_remaining], [vepro_price], [venpro_stock_id], [vepro_vendor_id]) VALUES (5, 8, 9, 5000000.0000, 5, 21)
INSERT [Purchasing].[vendor_product] ([vepro_id], [vepro_qty_stocked], [vepro_qty_remaining], [vepro_price], [venpro_stock_id], [vepro_vendor_id]) VALUES (6, 1, 9, 5000000.0000, 5, 20)
INSERT [Purchasing].[vendor_product] ([vepro_id], [vepro_qty_stocked], [vepro_qty_remaining], [vepro_price], [venpro_stock_id], [vepro_vendor_id]) VALUES (7, 6, 7, 7000000.0000, 4, 19)
INSERT [Purchasing].[vendor_product] ([vepro_id], [vepro_qty_stocked], [vepro_qty_remaining], [vepro_price], [venpro_stock_id], [vepro_vendor_id]) VALUES (8, 1, 5, 8000000.0000, 3, 18)
INSERT [Purchasing].[vendor_product] ([vepro_id], [vepro_qty_stocked], [vepro_qty_remaining], [vepro_price], [venpro_stock_id], [vepro_vendor_id]) VALUES (9, 4, 5, 9000000.0000, 2, 17)
INSERT [Purchasing].[vendor_product] ([vepro_id], [vepro_qty_stocked], [vepro_qty_remaining], [vepro_price], [venpro_stock_id], [vepro_vendor_id]) VALUES (10, 2, 3, 10000000.0000, 1, 16)
SET IDENTITY_INSERT [Purchasing].[vendor_product] OFF
GO
SET IDENTITY_INSERT [Resto].[order_menu_detail] ON 

INSERT [Resto].[order_menu_detail] ([omde_id], [orme_price], [orme_qty], [orme_discount], [omde_orme_id], [omde_reme_id]) VALUES (1, 10000.0000, 2, 0.0000, 1, 1)
INSERT [Resto].[order_menu_detail] ([omde_id], [orme_price], [orme_qty], [orme_discount], [omde_orme_id], [omde_reme_id]) VALUES (2, 12000.0000, 3, 0.0000, 1, 2)
INSERT [Resto].[order_menu_detail] ([omde_id], [orme_price], [orme_qty], [orme_discount], [omde_orme_id], [omde_reme_id]) VALUES (3, 15000.0000, 2, 0.0000, 2, 3)
INSERT [Resto].[order_menu_detail] ([omde_id], [orme_price], [orme_qty], [orme_discount], [omde_orme_id], [omde_reme_id]) VALUES (4, 20000.0000, 4, 0.0000, 2, 4)
INSERT [Resto].[order_menu_detail] ([omde_id], [orme_price], [orme_qty], [orme_discount], [omde_orme_id], [omde_reme_id]) VALUES (5, 10000.0000, 3, 0.0000, 3, 5)
INSERT [Resto].[order_menu_detail] ([omde_id], [orme_price], [orme_qty], [orme_discount], [omde_orme_id], [omde_reme_id]) VALUES (6, 15000.0000, 1, 0.0000, 3, 6)
INSERT [Resto].[order_menu_detail] ([omde_id], [orme_price], [orme_qty], [orme_discount], [omde_orme_id], [omde_reme_id]) VALUES (7, 20000.0000, 3, 0.0000, 4, 11)
INSERT [Resto].[order_menu_detail] ([omde_id], [orme_price], [orme_qty], [orme_discount], [omde_orme_id], [omde_reme_id]) VALUES (8, 12000.0000, 2, 0.0000, 4, 2)
INSERT [Resto].[order_menu_detail] ([omde_id], [orme_price], [orme_qty], [orme_discount], [omde_orme_id], [omde_reme_id]) VALUES (9, 10000.0000, 4, 0.0000, 5, 3)
INSERT [Resto].[order_menu_detail] ([omde_id], [orme_price], [orme_qty], [orme_discount], [omde_orme_id], [omde_reme_id]) VALUES (10, 15000.0000, 2, 0.0000, 5, 4)
SET IDENTITY_INSERT [Resto].[order_menu_detail] OFF
GO
SET IDENTITY_INSERT [Resto].[order_menus] ON 

INSERT [Resto].[order_menus] ([orme_id], [orme_order_number], [orme_order_date], [orme_total_item], [orme_total_discount], [orme_total_amount], [orme_pay_type], [orme_cardnumber], [orme_is_paid], [orme_modified_date], [orme_user_id], [orme_status], [orme_invoice]) VALUES (1, N'MENUS#20220101-00001', CAST(N'2022-01-01T00:00:00.000' AS DateTime), 2, 0.0000, 40000.0000, N'D ', N'431-2388-93', N'P ', CAST(N'2023-11-13T03:35:02.477' AS DateTime), 1, NULL, NULL)
INSERT [Resto].[order_menus] ([orme_id], [orme_order_number], [orme_order_date], [orme_total_item], [orme_total_discount], [orme_total_amount], [orme_pay_type], [orme_cardnumber], [orme_is_paid], [orme_modified_date], [orme_user_id], [orme_status], [orme_invoice]) VALUES (2, N'MENUS#20220101-00002', CAST(N'2022-01-01T00:00:00.000' AS DateTime), 3, 5000.0000, 75000.0000, N'CR', N'123-2993-32', N'P ', CAST(N'2023-11-13T03:35:02.477' AS DateTime), 2, NULL, NULL)
INSERT [Resto].[order_menus] ([orme_id], [orme_order_number], [orme_order_date], [orme_total_item], [orme_total_discount], [orme_total_amount], [orme_pay_type], [orme_cardnumber], [orme_is_paid], [orme_modified_date], [orme_user_id], [orme_status], [orme_invoice]) VALUES (3, N'MENUS#20220101-00003', CAST(N'2022-01-01T00:00:00.000' AS DateTime), 4, 0.0000, 80000.0000, N'PG', N'11-1111-1111', N'P ', CAST(N'2023-11-13T03:35:02.477' AS DateTime), 8, NULL, NULL)
INSERT [Resto].[order_menus] ([orme_id], [orme_order_number], [orme_order_date], [orme_total_item], [orme_total_discount], [orme_total_amount], [orme_pay_type], [orme_cardnumber], [orme_is_paid], [orme_modified_date], [orme_user_id], [orme_status], [orme_invoice]) VALUES (4, N'MENUS#20220101-00004', CAST(N'2022-01-01T00:00:00.000' AS DateTime), 5, 0.0000, 100000.0000, N'C ', NULL, N'B ', CAST(N'2023-11-13T03:35:02.477' AS DateTime), 4, NULL, NULL)
INSERT [Resto].[order_menus] ([orme_id], [orme_order_number], [orme_order_date], [orme_total_item], [orme_total_discount], [orme_total_amount], [orme_pay_type], [orme_cardnumber], [orme_is_paid], [orme_modified_date], [orme_user_id], [orme_status], [orme_invoice]) VALUES (5, N'MENUS#20220101-00005', CAST(N'2022-01-01T00:00:00.000' AS DateTime), 6, 0.0000, 120000.0000, N'CR', N'889-3921-22', N'P ', CAST(N'2023-11-13T03:35:02.477' AS DateTime), 6, NULL, NULL)
INSERT [Resto].[order_menus] ([orme_id], [orme_order_number], [orme_order_date], [orme_total_item], [orme_total_discount], [orme_total_amount], [orme_pay_type], [orme_cardnumber], [orme_is_paid], [orme_modified_date], [orme_user_id], [orme_status], [orme_invoice]) VALUES (6, N'MENUS#20220101-00006', CAST(N'2022-01-01T00:00:00.000' AS DateTime), 7, 0.0000, 140000.0000, N'PG', N'0873635251525', N'P ', CAST(N'2023-11-13T03:35:02.477' AS DateTime), 9, NULL, NULL)
SET IDENTITY_INSERT [Resto].[order_menus] OFF
GO
SET IDENTITY_INSERT [Resto].[resto_menu_photos] ON 

INSERT [Resto].[resto_menu_photos] ([remp_id], [remp_thumbnail_filename], [remp_photo_filename], [remp_primary], [remp_url], [remp_reme_id]) VALUES (1, N'thumbnail1.jpg', N'photo1.jpg', 1, N'http://localhost/resto/menu/photo1.jpg', 1)
INSERT [Resto].[resto_menu_photos] ([remp_id], [remp_thumbnail_filename], [remp_photo_filename], [remp_primary], [remp_url], [remp_reme_id]) VALUES (2, N'thumbnail2.jpg', N'photo2.jpg', 0, N'http://localhost/resto/menu/photo2.jpg', 1)
INSERT [Resto].[resto_menu_photos] ([remp_id], [remp_thumbnail_filename], [remp_photo_filename], [remp_primary], [remp_url], [remp_reme_id]) VALUES (3, N'thumbnail3.jpg', N'photo3.jpg', 0, N'http://localhost/resto/menu/photo3.jpg', 1)
INSERT [Resto].[resto_menu_photos] ([remp_id], [remp_thumbnail_filename], [remp_photo_filename], [remp_primary], [remp_url], [remp_reme_id]) VALUES (4, N'thumbnail4.jpg', N'photo4.jpg', 1, N'http://localhost/resto/menu/photo4.jpg', 2)
INSERT [Resto].[resto_menu_photos] ([remp_id], [remp_thumbnail_filename], [remp_photo_filename], [remp_primary], [remp_url], [remp_reme_id]) VALUES (5, N'thumbnail5.jpg', N'photo5.jpg', 0, N'http://localhost/resto/menu/photo5.jpg', 2)
INSERT [Resto].[resto_menu_photos] ([remp_id], [remp_thumbnail_filename], [remp_photo_filename], [remp_primary], [remp_url], [remp_reme_id]) VALUES (6, N'thumbnail6.jpg', N'photo6.jpg', 0, N'http://localhost/resto/menu/photo6.jpg', 2)
INSERT [Resto].[resto_menu_photos] ([remp_id], [remp_thumbnail_filename], [remp_photo_filename], [remp_primary], [remp_url], [remp_reme_id]) VALUES (7, N'thumbnail7.jpg', N'photo7.jpg', 1, N'http://localhost/resto/menu/photo7.jpg', 3)
INSERT [Resto].[resto_menu_photos] ([remp_id], [remp_thumbnail_filename], [remp_photo_filename], [remp_primary], [remp_url], [remp_reme_id]) VALUES (8, N'thumbnail8.jpg', N'photo8.jpg', 0, N'http://localhost/resto/menu/photo8.jpg', 3)
INSERT [Resto].[resto_menu_photos] ([remp_id], [remp_thumbnail_filename], [remp_photo_filename], [remp_primary], [remp_url], [remp_reme_id]) VALUES (9, N'thumbnail9.jpg', N'photo9.jpg', 0, N'http://localhost/resto/menu/photo9.jpg', 3)
INSERT [Resto].[resto_menu_photos] ([remp_id], [remp_thumbnail_filename], [remp_photo_filename], [remp_primary], [remp_url], [remp_reme_id]) VALUES (10, N'thumbnail10.jpg', N'photo10.jpg', 1, N'http://localhost/resto/menu/photo10.jpg', 4)
SET IDENTITY_INSERT [Resto].[resto_menu_photos] OFF
GO
SET IDENTITY_INSERT [Resto].[resto_menus] ON 

INSERT [Resto].[resto_menus] ([reme_faci_id], [reme_id], [reme_name], [reme_description], [reme_price], [reme_status], [reme_modified_date], [reme_type]) VALUES (2, 1, N'Nasi Goreng', N'Nasi goreng dengan bahan dasar nasi yang ditumis bersama telur dan sayuran', 15000.0000, N'Available', CAST(N'2023-11-13T03:35:02.477' AS DateTime), NULL)
INSERT [Resto].[resto_menus] ([reme_faci_id], [reme_id], [reme_name], [reme_description], [reme_price], [reme_status], [reme_modified_date], [reme_type]) VALUES (2, 2, N'Soto Ayam', N'Soto ayam dengan kuah yang gurih dan daging ayam yang empuk', 20000.0000, N'Available', CAST(N'2023-11-13T03:35:02.477' AS DateTime), NULL)
INSERT [Resto].[resto_menus] ([reme_faci_id], [reme_id], [reme_name], [reme_description], [reme_price], [reme_status], [reme_modified_date], [reme_type]) VALUES (2, 3, N'Gado-gado', N'Gado-gado dengan bahan dasar lontong dan sayuran-sayuran segar', 10000.0000, N'Available', CAST(N'2023-11-13T03:35:02.477' AS DateTime), NULL)
INSERT [Resto].[resto_menus] ([reme_faci_id], [reme_id], [reme_name], [reme_description], [reme_price], [reme_status], [reme_modified_date], [reme_type]) VALUES (2, 4, N'Bakso', N'Bakso dengan daging sapi yang dipotong-potong dan dimasak dengan bumbu khusus', 15000.0000, N'Available', CAST(N'2023-11-13T03:35:02.477' AS DateTime), NULL)
INSERT [Resto].[resto_menus] ([reme_faci_id], [reme_id], [reme_name], [reme_description], [reme_price], [reme_status], [reme_modified_date], [reme_type]) VALUES (2, 5, N'Ayam Goreng', N'Ayam goreng dengan tepung yang renyah dan daging ayam yang empuk', 25000.0000, N'Available', CAST(N'2023-11-13T03:35:02.477' AS DateTime), NULL)
INSERT [Resto].[resto_menus] ([reme_faci_id], [reme_id], [reme_name], [reme_description], [reme_price], [reme_status], [reme_modified_date], [reme_type]) VALUES (2, 6, N'Sate Ayam', N'Sate ayam dengan bumbu kacang yang lezat', 20000.0000, N'Available', CAST(N'2023-11-13T03:35:02.477' AS DateTime), NULL)
INSERT [Resto].[resto_menus] ([reme_faci_id], [reme_id], [reme_name], [reme_description], [reme_price], [reme_status], [reme_modified_date], [reme_type]) VALUES (2, 7, N'Nasi Kuning', N'Nasi kuning dengan bahan dasar nasi yang dicampur dengan telur dan kecap', 10000.0000, N'Available', CAST(N'2023-11-13T03:35:02.477' AS DateTime), NULL)
INSERT [Resto].[resto_menus] ([reme_faci_id], [reme_id], [reme_name], [reme_description], [reme_price], [reme_status], [reme_modified_date], [reme_type]) VALUES (2, 8, N'Sop Buntut', N'Sop buntut dengan bahan dasar daging buntut yang empuk dan kuah yang gurih', 30000.0000, N'Available', CAST(N'2023-11-13T03:35:02.477' AS DateTime), NULL)
INSERT [Resto].[resto_menus] ([reme_faci_id], [reme_id], [reme_name], [reme_description], [reme_price], [reme_status], [reme_modified_date], [reme_type]) VALUES (2, 9, N'Bubur Ayam', N'Bubur ayam dengan bahan dasar nasi yang dicampur dengan daging ayam dan sayuran', 10000.0000, N'Available', CAST(N'2023-11-13T03:35:02.477' AS DateTime), NULL)
INSERT [Resto].[resto_menus] ([reme_faci_id], [reme_id], [reme_name], [reme_description], [reme_price], [reme_status], [reme_modified_date], [reme_type]) VALUES (2, 10, N'Mie Goreng', N'Mie goreng dengan bahan dasar mie yang ditumis bersama telur dan sayuran', 15000.0000, N'Available', CAST(N'2023-11-13T03:35:02.477' AS DateTime), NULL)
INSERT [Resto].[resto_menus] ([reme_faci_id], [reme_id], [reme_name], [reme_description], [reme_price], [reme_status], [reme_modified_date], [reme_type]) VALUES (2, 11, N'Cap Cay', N'Cap cay dengan bahan dasar sayuran yang dicampur dengan daging sapi dan kuah kaldu', 20000.0000, N'Available', CAST(N'2023-11-13T03:35:02.477' AS DateTime), NULL)
SET IDENTITY_INSERT [Resto].[resto_menus] OFF
GO
SET IDENTITY_INSERT [Users].[bonus_points] ON 

INSERT [Users].[bonus_points] ([ubpo_id], [ubpo_user_id], [ubpo_total_points], [ubpo_bonus_type], [ubpo_created_on]) VALUES (1, 1, 1000, N'R', CAST(N'2022-01-01T00:00:00.000' AS DateTime))
INSERT [Users].[bonus_points] ([ubpo_id], [ubpo_user_id], [ubpo_total_points], [ubpo_bonus_type], [ubpo_created_on]) VALUES (2, 2, 2000, N'P', CAST(N'2022-02-02T00:00:00.000' AS DateTime))
INSERT [Users].[bonus_points] ([ubpo_id], [ubpo_user_id], [ubpo_total_points], [ubpo_bonus_type], [ubpo_created_on]) VALUES (3, 3, 3000, N'P', CAST(N'2022-03-03T00:00:00.000' AS DateTime))
INSERT [Users].[bonus_points] ([ubpo_id], [ubpo_user_id], [ubpo_total_points], [ubpo_bonus_type], [ubpo_created_on]) VALUES (4, 4, 4000, N'R', CAST(N'2022-04-04T00:00:00.000' AS DateTime))
INSERT [Users].[bonus_points] ([ubpo_id], [ubpo_user_id], [ubpo_total_points], [ubpo_bonus_type], [ubpo_created_on]) VALUES (5, 5, 5000, N'P', CAST(N'2022-05-05T00:00:00.000' AS DateTime))
INSERT [Users].[bonus_points] ([ubpo_id], [ubpo_user_id], [ubpo_total_points], [ubpo_bonus_type], [ubpo_created_on]) VALUES (6, 6, 6000, N'P', CAST(N'2022-06-06T00:00:00.000' AS DateTime))
INSERT [Users].[bonus_points] ([ubpo_id], [ubpo_user_id], [ubpo_total_points], [ubpo_bonus_type], [ubpo_created_on]) VALUES (7, 7, 7000, N'R', CAST(N'2022-07-07T00:00:00.000' AS DateTime))
INSERT [Users].[bonus_points] ([ubpo_id], [ubpo_user_id], [ubpo_total_points], [ubpo_bonus_type], [ubpo_created_on]) VALUES (8, 8, 8000, N'P', CAST(N'2022-08-08T00:00:00.000' AS DateTime))
INSERT [Users].[bonus_points] ([ubpo_id], [ubpo_user_id], [ubpo_total_points], [ubpo_bonus_type], [ubpo_created_on]) VALUES (9, 9, 9000, N'P', CAST(N'2022-09-09T00:00:00.000' AS DateTime))
INSERT [Users].[bonus_points] ([ubpo_id], [ubpo_user_id], [ubpo_total_points], [ubpo_bonus_type], [ubpo_created_on]) VALUES (10, 10, 10000, N'R', CAST(N'2022-10-10T00:00:00.000' AS DateTime))
INSERT [Users].[bonus_points] ([ubpo_id], [ubpo_user_id], [ubpo_total_points], [ubpo_bonus_type], [ubpo_created_on]) VALUES (11, 11, 10000, N'P', CAST(N'2022-11-11T00:00:00.000' AS DateTime))
INSERT [Users].[bonus_points] ([ubpo_id], [ubpo_user_id], [ubpo_total_points], [ubpo_bonus_type], [ubpo_created_on]) VALUES (12, 12, 10000, N'R', CAST(N'2022-12-12T00:00:00.000' AS DateTime))
INSERT [Users].[bonus_points] ([ubpo_id], [ubpo_user_id], [ubpo_total_points], [ubpo_bonus_type], [ubpo_created_on]) VALUES (13, 13, 10000, N'P', CAST(N'2022-01-01T00:00:00.000' AS DateTime))
INSERT [Users].[bonus_points] ([ubpo_id], [ubpo_user_id], [ubpo_total_points], [ubpo_bonus_type], [ubpo_created_on]) VALUES (14, 14, 10000, N'R', CAST(N'2022-02-02T00:00:00.000' AS DateTime))
INSERT [Users].[bonus_points] ([ubpo_id], [ubpo_user_id], [ubpo_total_points], [ubpo_bonus_type], [ubpo_created_on]) VALUES (15, 15, 10000, N'P', CAST(N'2022-03-03T00:00:00.000' AS DateTime))
SET IDENTITY_INSERT [Users].[bonus_points] OFF
GO
SET IDENTITY_INSERT [Users].[roles] ON 

INSERT [Users].[roles] ([role_id], [role_name]) VALUES (1, N'Guest')
INSERT [Users].[roles] ([role_id], [role_name]) VALUES (2, N'Manager')
INSERT [Users].[roles] ([role_id], [role_name]) VALUES (3, N'OfficeBoy')
INSERT [Users].[roles] ([role_id], [role_name]) VALUES (4, N'Admin')
INSERT [Users].[roles] ([role_id], [role_name]) VALUES (5, N'User')
SET IDENTITY_INSERT [Users].[roles] OFF
GO
INSERT [Users].[user_members] ([usme_user_id], [usme_memb_name], [usme_promote_date], [usme_points], [usme_type]) VALUES (1, N'SILVER', CAST(N'2022-01-01T00:00:00.000' AS DateTime), 100, N'Active')
INSERT [Users].[user_members] ([usme_user_id], [usme_memb_name], [usme_promote_date], [usme_points], [usme_type]) VALUES (2, N'GOLD', CAST(N'2022-02-01T00:00:00.000' AS DateTime), 200, N'Active')
INSERT [Users].[user_members] ([usme_user_id], [usme_memb_name], [usme_promote_date], [usme_points], [usme_type]) VALUES (3, N'VIP', CAST(N'2022-03-01T00:00:00.000' AS DateTime), 300, N'Active')
INSERT [Users].[user_members] ([usme_user_id], [usme_memb_name], [usme_promote_date], [usme_points], [usme_type]) VALUES (4, N'WIZARD', CAST(N'2022-04-01T00:00:00.000' AS DateTime), 400, N'Active')
INSERT [Users].[user_members] ([usme_user_id], [usme_memb_name], [usme_promote_date], [usme_points], [usme_type]) VALUES (5, N'SILVER', CAST(N'2022-05-01T00:00:00.000' AS DateTime), 500, N'Active')
INSERT [Users].[user_members] ([usme_user_id], [usme_memb_name], [usme_promote_date], [usme_points], [usme_type]) VALUES (6, N'GOLD', CAST(N'2022-06-01T00:00:00.000' AS DateTime), 600, N'Active')
INSERT [Users].[user_members] ([usme_user_id], [usme_memb_name], [usme_promote_date], [usme_points], [usme_type]) VALUES (7, N'VIP', CAST(N'2022-07-01T00:00:00.000' AS DateTime), 700, N'Active')
INSERT [Users].[user_members] ([usme_user_id], [usme_memb_name], [usme_promote_date], [usme_points], [usme_type]) VALUES (8, N'WIZARD', CAST(N'2022-08-01T00:00:00.000' AS DateTime), 800, N'Active')
INSERT [Users].[user_members] ([usme_user_id], [usme_memb_name], [usme_promote_date], [usme_points], [usme_type]) VALUES (9, N'SILVER', CAST(N'2022-09-01T00:00:00.000' AS DateTime), 900, N'Active')
INSERT [Users].[user_members] ([usme_user_id], [usme_memb_name], [usme_promote_date], [usme_points], [usme_type]) VALUES (10, N'GOLD', CAST(N'2022-10-01T00:00:00.000' AS DateTime), 1000, N'Active')
INSERT [Users].[user_members] ([usme_user_id], [usme_memb_name], [usme_promote_date], [usme_points], [usme_type]) VALUES (11, N'SILVER', CAST(N'2022-11-01T00:00:00.000' AS DateTime), 1000, N'Expired')
INSERT [Users].[user_members] ([usme_user_id], [usme_memb_name], [usme_promote_date], [usme_points], [usme_type]) VALUES (12, N'GOLD', CAST(N'2022-12-01T00:00:00.000' AS DateTime), 1000, N'Expired')
INSERT [Users].[user_members] ([usme_user_id], [usme_memb_name], [usme_promote_date], [usme_points], [usme_type]) VALUES (13, N'VIP', CAST(N'2022-01-01T00:00:00.000' AS DateTime), 1000, N'Expired')
INSERT [Users].[user_members] ([usme_user_id], [usme_memb_name], [usme_promote_date], [usme_points], [usme_type]) VALUES (14, N'WIZARD', CAST(N'2022-02-01T00:00:00.000' AS DateTime), 1000, N'Expired')
INSERT [Users].[user_members] ([usme_user_id], [usme_memb_name], [usme_promote_date], [usme_points], [usme_type]) VALUES (15, N'GOLD', CAST(N'2022-03-01T00:00:00.000' AS DateTime), 1000, N'Expired')
GO
SET IDENTITY_INSERT [Users].[user_password] ON 

INSERT [Users].[user_password] ([uspa_user_id], [uspa_passwordHash], [uspa_passwordSalt]) VALUES (1, N'123456', N'abcdef')
INSERT [Users].[user_password] ([uspa_user_id], [uspa_passwordHash], [uspa_passwordSalt]) VALUES (2, N'password', N'ghijkl')
INSERT [Users].[user_password] ([uspa_user_id], [uspa_passwordHash], [uspa_passwordSalt]) VALUES (3, N'qwerty', N'mnopqr')
INSERT [Users].[user_password] ([uspa_user_id], [uspa_passwordHash], [uspa_passwordSalt]) VALUES (4, N'letmein', N'stuvwx')
INSERT [Users].[user_password] ([uspa_user_id], [uspa_passwordHash], [uspa_passwordSalt]) VALUES (5, N'trustno1', N'yzabcd')
INSERT [Users].[user_password] ([uspa_user_id], [uspa_passwordHash], [uspa_passwordSalt]) VALUES (6, N'sunshine', N'efghij')
INSERT [Users].[user_password] ([uspa_user_id], [uspa_passwordHash], [uspa_passwordSalt]) VALUES (7, N'iloveyou', N'klmnop')
INSERT [Users].[user_password] ([uspa_user_id], [uspa_passwordHash], [uspa_passwordSalt]) VALUES (8, N'monkey', N'qrstuv')
INSERT [Users].[user_password] ([uspa_user_id], [uspa_passwordHash], [uspa_passwordSalt]) VALUES (9, N'starwars', N'wxyzab')
INSERT [Users].[user_password] ([uspa_user_id], [uspa_passwordHash], [uspa_passwordSalt]) VALUES (10, N'master', N'cdefgh')
INSERT [Users].[user_password] ([uspa_user_id], [uspa_passwordHash], [uspa_passwordSalt]) VALUES (11, N'abc123', N'ijklmn')
INSERT [Users].[user_password] ([uspa_user_id], [uspa_passwordHash], [uspa_passwordSalt]) VALUES (12, N'123abc', N'opqrst')
INSERT [Users].[user_password] ([uspa_user_id], [uspa_passwordHash], [uspa_passwordSalt]) VALUES (13, N'welcome', N'uvwxyz')
INSERT [Users].[user_password] ([uspa_user_id], [uspa_passwordHash], [uspa_passwordSalt]) VALUES (14, N'monkey1', N'abcdefg')
INSERT [Users].[user_password] ([uspa_user_id], [uspa_passwordHash], [uspa_passwordSalt]) VALUES (15, N'password1', N'hijklmn')
SET IDENTITY_INSERT [Users].[user_password] OFF
GO
SET IDENTITY_INSERT [Users].[user_profiles] ON 

INSERT [Users].[user_profiles] ([uspro_id], [uspro_national_id], [uspro_birth_date], [uspro_job_title], [uspro_marital_status], [uspro_gender], [uspro_addr_id], [uspro_user_id]) VALUES (1, N'123-45-6789', CAST(N'1980-01-01' AS Date), N'Manager', N'S', N'M', 1, 1)
INSERT [Users].[user_profiles] ([uspro_id], [uspro_national_id], [uspro_birth_date], [uspro_job_title], [uspro_marital_status], [uspro_gender], [uspro_addr_id], [uspro_user_id]) VALUES (2, N'234-56-7890', CAST(N'1985-02-02' AS Date), N'Developer', N'M', N'F', 2, 2)
INSERT [Users].[user_profiles] ([uspro_id], [uspro_national_id], [uspro_birth_date], [uspro_job_title], [uspro_marital_status], [uspro_gender], [uspro_addr_id], [uspro_user_id]) VALUES (3, N'345-67-8901', CAST(N'1990-03-03' AS Date), N'Designer', N'S', N'M', 3, 3)
INSERT [Users].[user_profiles] ([uspro_id], [uspro_national_id], [uspro_birth_date], [uspro_job_title], [uspro_marital_status], [uspro_gender], [uspro_addr_id], [uspro_user_id]) VALUES (4, N'456-78-9012', CAST(N'1995-04-04' AS Date), N'Tester', N'M', N'F', 4, 4)
INSERT [Users].[user_profiles] ([uspro_id], [uspro_national_id], [uspro_birth_date], [uspro_job_title], [uspro_marital_status], [uspro_gender], [uspro_addr_id], [uspro_user_id]) VALUES (5, N'567-89-0123', CAST(N'2000-05-05' AS Date), N'Analyst', N'S', N'M', 5, 5)
INSERT [Users].[user_profiles] ([uspro_id], [uspro_national_id], [uspro_birth_date], [uspro_job_title], [uspro_marital_status], [uspro_gender], [uspro_addr_id], [uspro_user_id]) VALUES (6, N'678-90-1234', CAST(N'2005-06-06' AS Date), N'Consultant', N'M', N'F', 6, 6)
INSERT [Users].[user_profiles] ([uspro_id], [uspro_national_id], [uspro_birth_date], [uspro_job_title], [uspro_marital_status], [uspro_gender], [uspro_addr_id], [uspro_user_id]) VALUES (7, N'789-01-2345', CAST(N'2010-07-07' AS Date), N'Salesperson', N'S', N'M', 7, 7)
INSERT [Users].[user_profiles] ([uspro_id], [uspro_national_id], [uspro_birth_date], [uspro_job_title], [uspro_marital_status], [uspro_gender], [uspro_addr_id], [uspro_user_id]) VALUES (8, N'890-12-3456', CAST(N'2015-08-08' AS Date), N'HR Manager', N'M', N'F', 8, 8)
INSERT [Users].[user_profiles] ([uspro_id], [uspro_national_id], [uspro_birth_date], [uspro_job_title], [uspro_marital_status], [uspro_gender], [uspro_addr_id], [uspro_user_id]) VALUES (9, N'901-23-4567', CAST(N'2020-09-09' AS Date), N'Project Manager', N'S', N'M', 9, 9)
INSERT [Users].[user_profiles] ([uspro_id], [uspro_national_id], [uspro_birth_date], [uspro_job_title], [uspro_marital_status], [uspro_gender], [uspro_addr_id], [uspro_user_id]) VALUES (10, N'012-34-5678', CAST(N'2025-10-10' AS Date), N'Marketing Manager', N'M', N'F', 10, 10)
INSERT [Users].[user_profiles] ([uspro_id], [uspro_national_id], [uspro_birth_date], [uspro_job_title], [uspro_marital_status], [uspro_gender], [uspro_addr_id], [uspro_user_id]) VALUES (11, N'123-45-6789', CAST(N'1985-01-01' AS Date), N'Engineer', N'S', N'M', 11, 11)
INSERT [Users].[user_profiles] ([uspro_id], [uspro_national_id], [uspro_birth_date], [uspro_job_title], [uspro_marital_status], [uspro_gender], [uspro_addr_id], [uspro_user_id]) VALUES (12, N'234-56-7890', CAST(N'1990-01-01' AS Date), N'Designer', N'S', N'F', 12, 12)
INSERT [Users].[user_profiles] ([uspro_id], [uspro_national_id], [uspro_birth_date], [uspro_job_title], [uspro_marital_status], [uspro_gender], [uspro_addr_id], [uspro_user_id]) VALUES (13, N'345-67-8901', CAST(N'1995-01-01' AS Date), N'Journalist', N'S', N'M', 13, 13)
INSERT [Users].[user_profiles] ([uspro_id], [uspro_national_id], [uspro_birth_date], [uspro_job_title], [uspro_marital_status], [uspro_gender], [uspro_addr_id], [uspro_user_id]) VALUES (14, N'456-78-9012', CAST(N'1980-01-01' AS Date), N'Teacher', N'M', N'F', 14, 14)
INSERT [Users].[user_profiles] ([uspro_id], [uspro_national_id], [uspro_birth_date], [uspro_job_title], [uspro_marital_status], [uspro_gender], [uspro_addr_id], [uspro_user_id]) VALUES (15, N'567-89-0123', CAST(N'1985-01-01' AS Date), N'Writer', N'S', N'M', 15, 15)
INSERT [Users].[user_profiles] ([uspro_id], [uspro_national_id], [uspro_birth_date], [uspro_job_title], [uspro_marital_status], [uspro_gender], [uspro_addr_id], [uspro_user_id]) VALUES (16, N'678-90-1234', CAST(N'1995-11-11' AS Date), N'Software Engineer', N'S', N'M', 1, 16)
INSERT [Users].[user_profiles] ([uspro_id], [uspro_national_id], [uspro_birth_date], [uspro_job_title], [uspro_marital_status], [uspro_gender], [uspro_addr_id], [uspro_user_id]) VALUES (17, N'789-01-2345', CAST(N'2000-12-12' AS Date), N'Data Scientist', N'M', N'F', 2, 17)
INSERT [Users].[user_profiles] ([uspro_id], [uspro_national_id], [uspro_birth_date], [uspro_job_title], [uspro_marital_status], [uspro_gender], [uspro_addr_id], [uspro_user_id]) VALUES (18, N'890-12-3456', CAST(N'2005-02-13' AS Date), N'Financial Analyst', N'S', N'M', 3, 18)
INSERT [Users].[user_profiles] ([uspro_id], [uspro_national_id], [uspro_birth_date], [uspro_job_title], [uspro_marital_status], [uspro_gender], [uspro_addr_id], [uspro_user_id]) VALUES (19, N'901-23-4567', CAST(N'2010-03-14' AS Date), N'Marketing Specialist', N'M', N'F', 4, 19)
INSERT [Users].[user_profiles] ([uspro_id], [uspro_national_id], [uspro_birth_date], [uspro_job_title], [uspro_marital_status], [uspro_gender], [uspro_addr_id], [uspro_user_id]) VALUES (20, N'012-34-5678', CAST(N'2015-04-15' AS Date), N'Product Manager', N'S', N'M', 5, 20)
INSERT [Users].[user_profiles] ([uspro_id], [uspro_national_id], [uspro_birth_date], [uspro_job_title], [uspro_marital_status], [uspro_gender], [uspro_addr_id], [uspro_user_id]) VALUES (21, N'123-45-6789', CAST(N'1988-05-16' AS Date), N'Architect', N'S', N'M', 6, 21)
INSERT [Users].[user_profiles] ([uspro_id], [uspro_national_id], [uspro_birth_date], [uspro_job_title], [uspro_marital_status], [uspro_gender], [uspro_addr_id], [uspro_user_id]) VALUES (22, N'234-56-7890', CAST(N'1993-06-17' AS Date), N'UX/UI Designer', N'S', N'F', 7, 22)
INSERT [Users].[user_profiles] ([uspro_id], [uspro_national_id], [uspro_birth_date], [uspro_job_title], [uspro_marital_status], [uspro_gender], [uspro_addr_id], [uspro_user_id]) VALUES (23, N'345-67-8901', CAST(N'1998-07-18' AS Date), N'Journalist', N'S', N'M', 8, 23)
INSERT [Users].[user_profiles] ([uspro_id], [uspro_national_id], [uspro_birth_date], [uspro_job_title], [uspro_marital_status], [uspro_gender], [uspro_addr_id], [uspro_user_id]) VALUES (24, N'456-78-9012', CAST(N'2003-08-19' AS Date), N'Teacher', N'M', N'F', 9, 24)
INSERT [Users].[user_profiles] ([uspro_id], [uspro_national_id], [uspro_birth_date], [uspro_job_title], [uspro_marital_status], [uspro_gender], [uspro_addr_id], [uspro_user_id]) VALUES (25, N'567-89-0123', CAST(N'2008-09-20' AS Date), N'Writer', N'S', N'M', 10, 25)
SET IDENTITY_INSERT [Users].[user_profiles] OFF
GO
INSERT [Users].[user_roles] ([usro_user_id], [usro_role_id]) VALUES (1, 1)
INSERT [Users].[user_roles] ([usro_user_id], [usro_role_id]) VALUES (2, 2)
INSERT [Users].[user_roles] ([usro_user_id], [usro_role_id]) VALUES (3, 3)
INSERT [Users].[user_roles] ([usro_user_id], [usro_role_id]) VALUES (4, 4)
INSERT [Users].[user_roles] ([usro_user_id], [usro_role_id]) VALUES (5, 5)
INSERT [Users].[user_roles] ([usro_user_id], [usro_role_id]) VALUES (6, 1)
INSERT [Users].[user_roles] ([usro_user_id], [usro_role_id]) VALUES (7, 2)
INSERT [Users].[user_roles] ([usro_user_id], [usro_role_id]) VALUES (8, 3)
INSERT [Users].[user_roles] ([usro_user_id], [usro_role_id]) VALUES (9, 4)
INSERT [Users].[user_roles] ([usro_user_id], [usro_role_id]) VALUES (10, 2)
INSERT [Users].[user_roles] ([usro_user_id], [usro_role_id]) VALUES (11, 1)
INSERT [Users].[user_roles] ([usro_user_id], [usro_role_id]) VALUES (12, 2)
INSERT [Users].[user_roles] ([usro_user_id], [usro_role_id]) VALUES (13, 3)
INSERT [Users].[user_roles] ([usro_user_id], [usro_role_id]) VALUES (14, 4)
INSERT [Users].[user_roles] ([usro_user_id], [usro_role_id]) VALUES (15, 5)
GO
SET IDENTITY_INSERT [Users].[users] ON 

INSERT [Users].[users] ([user_id], [user_full_name], [user_type], [user_company_name], [user_email], [user_phone_number], [user_modified_date]) VALUES (1, N'John Smith', N'T', N'Acme Inc.', N'john.smith@acme.com', N'123-456-7890', CAST(N'2023-11-13T03:35:02.447' AS DateTime))
INSERT [Users].[users] ([user_id], [user_full_name], [user_type], [user_company_name], [user_email], [user_phone_number], [user_modified_date]) VALUES (2, N'Jane Doe', N'C', N'XYZ Corp.', N'jane.doe@xyz.com', N'123-456-7891', CAST(N'2023-11-13T03:35:02.447' AS DateTime))
INSERT [Users].[users] ([user_id], [user_full_name], [user_type], [user_company_name], [user_email], [user_phone_number], [user_modified_date]) VALUES (3, N'Account Realta', N'C', N'Hotel Realta.', N'realta@hotel.com', N'033-456-7899', CAST(N'2023-11-13T03:35:02.447' AS DateTime))
INSERT [Users].[users] ([user_id], [user_full_name], [user_type], [user_company_name], [user_email], [user_phone_number], [user_modified_date]) VALUES (4, N'Samantha Williams', N'T', N'Def Corp.', N'samantha.williams@def.com', N'123-456-7893', CAST(N'2023-11-13T03:35:02.447' AS DateTime))
INSERT [Users].[users] ([user_id], [user_full_name], [user_type], [user_company_name], [user_email], [user_phone_number], [user_modified_date]) VALUES (5, N'Michael Brown', N'C', N'Ghi Inc.', N'michael.brown@ghi.com', N'123-456-7894', CAST(N'2023-11-13T03:35:02.447' AS DateTime))
INSERT [Users].[users] ([user_id], [user_full_name], [user_type], [user_company_name], [user_email], [user_phone_number], [user_modified_date]) VALUES (6, N'Emily Davis', N'I', N'Jkl Ltd.', N'emily.davis@jkl.com', N'123-456-7895', CAST(N'2023-11-13T03:35:02.447' AS DateTime))
INSERT [Users].[users] ([user_id], [user_full_name], [user_type], [user_company_name], [user_email], [user_phone_number], [user_modified_date]) VALUES (7, N'William Thompson', N'T', N'Mno Inc.', N'william.thompson@mno.com', N'123-456-7896', CAST(N'2023-11-13T03:35:02.447' AS DateTime))
INSERT [Users].[users] ([user_id], [user_full_name], [user_type], [user_company_name], [user_email], [user_phone_number], [user_modified_date]) VALUES (8, N'Ashley Johnson', N'C', N'Pqr Corp.', N'ashley.johnson@pqr.com', N'123-456-7897', CAST(N'2023-11-13T03:35:02.447' AS DateTime))
INSERT [Users].[users] ([user_id], [user_full_name], [user_type], [user_company_name], [user_email], [user_phone_number], [user_modified_date]) VALUES (9, N'David Anderson', N'I', N'Stu Inc.', N'david.anderson@stu.com', N'123-456-7898', CAST(N'2023-11-13T03:35:02.447' AS DateTime))
INSERT [Users].[users] ([user_id], [user_full_name], [user_type], [user_company_name], [user_email], [user_phone_number], [user_modified_date]) VALUES (10, N'Bob Johnson', N'I', N'ABC Inc.', N'bob.johnson@abc.com', N'123-456-7892', CAST(N'2023-11-13T03:35:02.447' AS DateTime))
INSERT [Users].[users] ([user_id], [user_full_name], [user_type], [user_company_name], [user_email], [user_phone_number], [user_modified_date]) VALUES (11, N'David Brown', N'T', N'Example Co', N'david.brown@example.com', N'555-555-1222', CAST(N'2023-11-13T03:35:02.447' AS DateTime))
INSERT [Users].[users] ([user_id], [user_full_name], [user_type], [user_company_name], [user_email], [user_phone_number], [user_modified_date]) VALUES (12, N'Jessica Smith', N'C', N'Test Inc', N'jessica.smith@test.com', N'555-555-1223', CAST(N'2023-11-13T03:35:02.447' AS DateTime))
INSERT [Users].[users] ([user_id], [user_full_name], [user_type], [user_company_name], [user_email], [user_phone_number], [user_modified_date]) VALUES (13, N'James Johnson', N'I', N'Acme Inc', N'james.johnson@acme.com', N'555-555-1224', CAST(N'2023-11-13T03:35:02.447' AS DateTime))
INSERT [Users].[users] ([user_id], [user_full_name], [user_type], [user_company_name], [user_email], [user_phone_number], [user_modified_date]) VALUES (14, N'Samantha Williams', N'C', N'XYZ Corp', N'samantha.williams@xyz.com', N'555-555-1225', CAST(N'2023-11-13T03:35:02.447' AS DateTime))
INSERT [Users].[users] ([user_id], [user_full_name], [user_type], [user_company_name], [user_email], [user_phone_number], [user_modified_date]) VALUES (15, N'Robert Davis', N'T', N'Example Co', N'robert.davis@example.com', N'555-555-1226', CAST(N'2023-11-13T03:35:02.447' AS DateTime))
INSERT [Users].[users] ([user_id], [user_full_name], [user_type], [user_company_name], [user_email], [user_phone_number], [user_modified_date]) VALUES (16, N'Laura Rodriguez', N'C', N'LMN Ltd.', N'laura.rodriguez@lmn.com', N'555-555-1227', CAST(N'2023-11-13T15:48:48.360' AS DateTime))
INSERT [Users].[users] ([user_id], [user_full_name], [user_type], [user_company_name], [user_email], [user_phone_number], [user_modified_date]) VALUES (17, N'Carlos Martinez', N'T', N'OPQ Inc.', N'carlos.martinez@opq.com', N'555-555-1228', CAST(N'2023-11-13T15:48:48.360' AS DateTime))
INSERT [Users].[users] ([user_id], [user_full_name], [user_type], [user_company_name], [user_email], [user_phone_number], [user_modified_date]) VALUES (18, N'Amanda White', N'I', N'RST Corp.', N'amanda.white@rst.com', N'555-555-1229', CAST(N'2023-11-13T15:48:48.360' AS DateTime))
INSERT [Users].[users] ([user_id], [user_full_name], [user_type], [user_company_name], [user_email], [user_phone_number], [user_modified_date]) VALUES (19, N'Daniel Garcia', N'C', N'UVW Inc.', N'daniel.garcia@uvw.com', N'555-555-1230', CAST(N'2023-11-13T15:48:48.360' AS DateTime))
INSERT [Users].[users] ([user_id], [user_full_name], [user_type], [user_company_name], [user_email], [user_phone_number], [user_modified_date]) VALUES (20, N'Elena Perez', N'I', N'XYZ Corp.', N'elena.perez@xyz.com', N'555-555-1231', CAST(N'2023-11-13T15:48:48.360' AS DateTime))
INSERT [Users].[users] ([user_id], [user_full_name], [user_type], [user_company_name], [user_email], [user_phone_number], [user_modified_date]) VALUES (21, N'Fernando Lopez', N'T', N'123 Company', N'fernando.lopez@123.com', N'555-555-1232', CAST(N'2023-11-13T15:48:48.360' AS DateTime))
INSERT [Users].[users] ([user_id], [user_full_name], [user_type], [user_company_name], [user_email], [user_phone_number], [user_modified_date]) VALUES (22, N'Sophia Taylor', N'C', N'456 Corp.', N'sophia.taylor@456.com', N'555-555-1233', CAST(N'2023-11-13T15:48:48.360' AS DateTime))
INSERT [Users].[users] ([user_id], [user_full_name], [user_type], [user_company_name], [user_email], [user_phone_number], [user_modified_date]) VALUES (23, N'Isaac Clark', N'I', N'789 Inc.', N'isaac.clark@789.com', N'555-555-1234', CAST(N'2023-11-13T15:48:48.360' AS DateTime))
INSERT [Users].[users] ([user_id], [user_full_name], [user_type], [user_company_name], [user_email], [user_phone_number], [user_modified_date]) VALUES (24, N'Olivia Miller', N'T', N'ABC Corp.', N'olivia.miller@abc.com', N'555-555-1235', CAST(N'2023-11-13T15:48:48.360' AS DateTime))
INSERT [Users].[users] ([user_id], [user_full_name], [user_type], [user_company_name], [user_email], [user_phone_number], [user_modified_date]) VALUES (25, N'Lucas Wilson', N'C', N'DEF Inc.', N'lucas.wilson@def.com', N'555-555-1236', CAST(N'2023-11-13T15:48:48.360' AS DateTime))
SET IDENTITY_INSERT [Users].[users] OFF
GO
/****** Object:  Index [UQ__booking___B786B239FA25EE7E]    Script Date: 13/11/2023 17:39:53 ******/
ALTER TABLE [Booking].[booking_order_detail] ADD UNIQUE NONCLUSTERED 
(
	[borde_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [unique_boor_order_number]    Script Date: 13/11/2023 17:39:53 ******/
ALTER TABLE [Booking].[booking_orders] ADD  CONSTRAINT [unique_boor_order_number] UNIQUE NONCLUSTERED 
(
	[boor_order_number] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [faci_room_number_uq]    Script Date: 13/11/2023 17:39:53 ******/
ALTER TABLE [Hotel].[Facilities] ADD  CONSTRAINT [faci_room_number_uq] UNIQUE NONCLUSTERED 
(
	[faci_room_number] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [uq_emp_national_id]    Script Date: 13/11/2023 17:39:53 ******/
ALTER TABLE [HR].[employee] ADD  CONSTRAINT [uq_emp_national_id] UNIQUE NONCLUSTERED 
(
	[emp_national_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [uq_joro_name]    Script Date: 13/11/2023 17:39:53 ******/
ALTER TABLE [HR].[job_role] ADD  CONSTRAINT [uq_joro_name] UNIQUE NONCLUSTERED 
(
	[joro_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [uq_shift_end_time]    Script Date: 13/11/2023 17:39:53 ******/
ALTER TABLE [HR].[shift] ADD  CONSTRAINT [uq_shift_end_time] UNIQUE NONCLUSTERED 
(
	[shift_end_time] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [uq_shift_name]    Script Date: 13/11/2023 17:39:53 ******/
ALTER TABLE [HR].[shift] ADD  CONSTRAINT [uq_shift_name] UNIQUE NONCLUSTERED 
(
	[shift_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [uq_shift_start_time]    Script Date: 13/11/2023 17:39:53 ******/
ALTER TABLE [HR].[shift] ADD  CONSTRAINT [uq_shift_start_time] UNIQUE NONCLUSTERED 
(
	[shift_start_time] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__category__CDAEE235E3500D6D]    Script Date: 13/11/2023 17:39:53 ******/
ALTER TABLE [Master].[category_group] ADD UNIQUE NONCLUSTERED 
(
	[cagro_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__country__F701889442C9A8BA]    Script Date: 13/11/2023 17:39:53 ******/
ALTER TABLE [Master].[country] ADD UNIQUE NONCLUSTERED 
(
	[country_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__price_it__4ED0885480320B3C]    Script Date: 13/11/2023 17:39:53 ******/
ALTER TABLE [Master].[price_items] ADD UNIQUE NONCLUSTERED 
(
	[prit_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__regions__4BB31B03FC7C719C]    Script Date: 13/11/2023 17:39:53 ******/
ALTER TABLE [Master].[regions] ADD UNIQUE NONCLUSTERED 
(
	[region_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__service___AAA2784C2DFA47F0]    Script Date: 13/11/2023 17:39:53 ******/
ALTER TABLE [Master].[service_task] ADD UNIQUE NONCLUSTERED 
(
	[seta_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__bank__AEBE0980E751996A]    Script Date: 13/11/2023 17:39:53 ******/
ALTER TABLE [Payment].[bank] ADD UNIQUE NONCLUSTERED 
(
	[bank_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__bank__C5B9224298FE1958]    Script Date: 13/11/2023 17:39:53 ******/
ALTER TABLE [Payment].[bank] ADD UNIQUE NONCLUSTERED 
(
	[bank_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__payment___419923D8581A55F4]    Script Date: 13/11/2023 17:39:53 ******/
ALTER TABLE [Payment].[payment_gateway] ADD UNIQUE NONCLUSTERED 
(
	[paga_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__payment___50E86DBEAC469B43]    Script Date: 13/11/2023 17:39:53 ******/
ALTER TABLE [Payment].[payment_gateway] ADD UNIQUE NONCLUSTERED 
(
	[paga_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__payment___18318CF5454C01B0]    Script Date: 13/11/2023 17:39:53 ******/
ALTER TABLE [Payment].[payment_transaction] ADD UNIQUE NONCLUSTERED 
(
	[patr_trx_number] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__user_acc__864493F6F1E708FE]    Script Date: 13/11/2023 17:39:53 ******/
ALTER TABLE [Payment].[user_accounts] ADD UNIQUE NONCLUSTERED 
(
	[usac_account_number] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [uq_pohe_number]    Script Date: 13/11/2023 17:39:53 ******/
ALTER TABLE [Purchasing].[purchase_order_header] ADD  CONSTRAINT [uq_pohe_number] UNIQUE NONCLUSTERED 
(
	[pohe_number] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [uq_stod_barcode_number]    Script Date: 13/11/2023 17:39:53 ******/
ALTER TABLE [Purchasing].[stock_detail] ADD  CONSTRAINT [uq_stod_barcode_number] UNIQUE NONCLUSTERED 
(
	[stod_barcode_number] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__order_me__A228891002BADE6F]    Script Date: 13/11/2023 17:39:53 ******/
ALTER TABLE [Resto].[order_menus] ADD UNIQUE NONCLUSTERED 
(
	[orme_order_number] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__users__D5D775E8D1E63584]    Script Date: 13/11/2023 17:39:53 ******/
ALTER TABLE [Users].[users] ADD UNIQUE NONCLUSTERED 
(
	[user_phone_number] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [Booking].[booking_orders] ADD  DEFAULT (getdate()) FOR [boor_order_date]
GO
ALTER TABLE [Booking].[special_offers] ADD  DEFAULT (getdate()) FOR [spof_modified_date]
GO
ALTER TABLE [Hotel].[Hotel_Reviews] ADD  DEFAULT ((5)) FOR [hore_rating]
GO
ALTER TABLE [Payment].[bank] ADD  DEFAULT (getdate()) FOR [bank_modified_date]
GO
ALTER TABLE [Payment].[payment_gateway] ADD  DEFAULT (getdate()) FOR [paga_modified_date]
GO
ALTER TABLE [Payment].[payment_transaction] ADD  DEFAULT ((0.0)) FOR [patr_debet]
GO
ALTER TABLE [Payment].[payment_transaction] ADD  DEFAULT ((0.0)) FOR [patr_credit]
GO
ALTER TABLE [Payment].[payment_transaction] ADD  DEFAULT (getdate()) FOR [patr_modified_date]
GO
ALTER TABLE [Payment].[user_accounts] ADD  DEFAULT (NULL) FOR [usac_expmonth]
GO
ALTER TABLE [Payment].[user_accounts] ADD  DEFAULT (NULL) FOR [usac_expyear]
GO
ALTER TABLE [Payment].[user_accounts] ADD  DEFAULT (getdate()) FOR [usac_modified_date]
GO
ALTER TABLE [Purchasing].[cart] ADD  DEFAULT (getdate()) FOR [cart_modified_date]
GO
ALTER TABLE [Purchasing].[purchase_order_detail] ADD  DEFAULT (getdate()) FOR [pode_modified_date]
GO
ALTER TABLE [Purchasing].[purchase_order_header] ADD  DEFAULT ((1)) FOR [pohe_status]
GO
ALTER TABLE [Purchasing].[purchase_order_header] ADD  DEFAULT (getdate()) FOR [pohe_order_date]
GO
ALTER TABLE [Purchasing].[purchase_order_header] ADD  DEFAULT ((0.1)) FOR [pohe_tax]
GO
ALTER TABLE [Purchasing].[purchase_order_header] ADD  DEFAULT ((0)) FOR [pohe_refund]
GO
ALTER TABLE [Purchasing].[stock_detail] ADD  DEFAULT ((1)) FOR [stod_status]
GO
ALTER TABLE [Purchasing].[stock_photo] ADD  DEFAULT ((0)) FOR [spho_primary]
GO
ALTER TABLE [Purchasing].[stocks] ADD  DEFAULT ((0)) FOR [stock_quantity]
GO
ALTER TABLE [Purchasing].[stocks] ADD  DEFAULT ((0)) FOR [stock_reorder_point]
GO
ALTER TABLE [Purchasing].[stocks] ADD  DEFAULT ((0)) FOR [stock_used]
GO
ALTER TABLE [Purchasing].[stocks] ADD  DEFAULT ((0)) FOR [stock_scrap]
GO
ALTER TABLE [Purchasing].[stocks] ADD  DEFAULT ((0)) FOR [stock_price]
GO
ALTER TABLE [Purchasing].[stocks] ADD  DEFAULT ((0)) FOR [stock_standar_cost]
GO
ALTER TABLE [Purchasing].[stocks] ADD  DEFAULT (getdate()) FOR [stock_modified_date]
GO
ALTER TABLE [Purchasing].[vendor] ADD  DEFAULT ((1)) FOR [vendor_active]
GO
ALTER TABLE [Purchasing].[vendor] ADD  DEFAULT ((0)) FOR [vendor_priority]
GO
ALTER TABLE [Purchasing].[vendor] ADD  DEFAULT (getdate()) FOR [vendor_register_date]
GO
ALTER TABLE [Purchasing].[vendor] ADD  DEFAULT (getdate()) FOR [vendor_modified_date]
GO
ALTER TABLE [Users].[user_members] ADD  DEFAULT ('Expired') FOR [usme_type]
GO
ALTER TABLE [Users].[users] ADD  DEFAULT ('guest') FOR [user_full_name]
GO
ALTER TABLE [Booking].[booking_order_detail]  WITH CHECK ADD  CONSTRAINT [fk_borde_faci_id] FOREIGN KEY([borde_faci_id])
REFERENCES [Hotel].[Facilities] ([faci_id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [Booking].[booking_order_detail] CHECK CONSTRAINT [fk_borde_faci_id]
GO
ALTER TABLE [Booking].[booking_order_detail]  WITH CHECK ADD  CONSTRAINT [fk_border_boor_id] FOREIGN KEY([borde_boor_id])
REFERENCES [Booking].[booking_orders] ([boor_id])
GO
ALTER TABLE [Booking].[booking_order_detail] CHECK CONSTRAINT [fk_border_boor_id]
GO
ALTER TABLE [Booking].[booking_order_detail_extra]  WITH CHECK ADD  CONSTRAINT [fk_boex_borde_id] FOREIGN KEY([boex_borde_id])
REFERENCES [Booking].[booking_order_detail] ([borde_id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [Booking].[booking_order_detail_extra] CHECK CONSTRAINT [fk_boex_borde_id]
GO
ALTER TABLE [Booking].[booking_order_detail_extra]  WITH CHECK ADD  CONSTRAINT [fk_boex_prit_id] FOREIGN KEY([boex_prit_id])
REFERENCES [Master].[price_items] ([prit_id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [Booking].[booking_order_detail_extra] CHECK CONSTRAINT [fk_boex_prit_id]
GO
ALTER TABLE [Booking].[booking_orders]  WITH CHECK ADD  CONSTRAINT [fk_boor_hotel_id] FOREIGN KEY([boor_hotel_id])
REFERENCES [Hotel].[Hotels] ([hotel_id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [Booking].[booking_orders] CHECK CONSTRAINT [fk_boor_hotel_id]
GO
ALTER TABLE [Booking].[booking_orders]  WITH CHECK ADD  CONSTRAINT [fk_boor_user_id] FOREIGN KEY([boor_user_id])
REFERENCES [Users].[users] ([user_id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [Booking].[booking_orders] CHECK CONSTRAINT [fk_boor_user_id]
GO
ALTER TABLE [Booking].[special_offer_coupons]  WITH CHECK ADD  CONSTRAINT [fk_soco_borde_id] FOREIGN KEY([soco_borde_id])
REFERENCES [Booking].[booking_order_detail] ([borde_id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [Booking].[special_offer_coupons] CHECK CONSTRAINT [fk_soco_borde_id]
GO
ALTER TABLE [Booking].[special_offer_coupons]  WITH CHECK ADD  CONSTRAINT [fk_soco_spof_id] FOREIGN KEY([soco_spof_id])
REFERENCES [Booking].[special_offers] ([spof_id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [Booking].[special_offer_coupons] CHECK CONSTRAINT [fk_soco_spof_id]
GO
ALTER TABLE [Booking].[user_breakfast]  WITH CHECK ADD  CONSTRAINT [fk_usbr_borde_id] FOREIGN KEY([usbr_borde_id])
REFERENCES [Booking].[booking_order_detail] ([borde_id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [Booking].[user_breakfast] CHECK CONSTRAINT [fk_usbr_borde_id]
GO
ALTER TABLE [Hotel].[Facilities]  WITH CHECK ADD  CONSTRAINT [faci_cagro_id_fk] FOREIGN KEY([faci_cagro_id])
REFERENCES [Master].[category_group] ([cagro_id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [Hotel].[Facilities] CHECK CONSTRAINT [faci_cagro_id_fk]
GO
ALTER TABLE [Hotel].[Facilities]  WITH CHECK ADD  CONSTRAINT [faci_hotel_id_fk] FOREIGN KEY([faci_hotel_id])
REFERENCES [Hotel].[Hotels] ([hotel_id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [Hotel].[Facilities] CHECK CONSTRAINT [faci_hotel_id_fk]
GO
ALTER TABLE [Hotel].[Facilities]  WITH CHECK ADD  CONSTRAINT [faci_user_id_fk] FOREIGN KEY([faci_user_id])
REFERENCES [Users].[users] ([user_id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [Hotel].[Facilities] CHECK CONSTRAINT [faci_user_id_fk]
GO
ALTER TABLE [Hotel].[Facility_Photos]  WITH CHECK ADD  CONSTRAINT [fapho_faci_id_fk] FOREIGN KEY([fapho_faci_id])
REFERENCES [Hotel].[Facilities] ([faci_id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [Hotel].[Facility_Photos] CHECK CONSTRAINT [fapho_faci_id_fk]
GO
ALTER TABLE [Hotel].[facility_price_history]  WITH CHECK ADD  CONSTRAINT [faph_faci_id_fk] FOREIGN KEY([faph_faci_id])
REFERENCES [Hotel].[Facilities] ([faci_id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [Hotel].[facility_price_history] CHECK CONSTRAINT [faph_faci_id_fk]
GO
ALTER TABLE [Hotel].[Hotel_Reviews]  WITH CHECK ADD  CONSTRAINT [hore_hotel_id_fk] FOREIGN KEY([hore_hotel_id])
REFERENCES [Hotel].[Hotels] ([hotel_id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [Hotel].[Hotel_Reviews] CHECK CONSTRAINT [hore_hotel_id_fk]
GO
ALTER TABLE [Hotel].[Hotel_Reviews]  WITH CHECK ADD  CONSTRAINT [hore_user_id_pk] FOREIGN KEY([hore_user_id])
REFERENCES [Users].[users] ([user_id])
GO
ALTER TABLE [Hotel].[Hotel_Reviews] CHECK CONSTRAINT [hore_user_id_pk]
GO
ALTER TABLE [Hotel].[Hotels]  WITH CHECK ADD  CONSTRAINT [hotel_addr_id_fk] FOREIGN KEY([hotel_addr_id])
REFERENCES [Master].[address] ([addr_id])
GO
ALTER TABLE [Hotel].[Hotels] CHECK CONSTRAINT [hotel_addr_id_fk]
GO
ALTER TABLE [HR].[employee]  WITH CHECK ADD  CONSTRAINT [fk_emp_id] FOREIGN KEY([emp_emp_id])
REFERENCES [HR].[employee] ([emp_id])
GO
ALTER TABLE [HR].[employee] CHECK CONSTRAINT [fk_emp_id]
GO
ALTER TABLE [HR].[employee]  WITH CHECK ADD  CONSTRAINT [fk_emp_joro_id] FOREIGN KEY([emp_joro_id])
REFERENCES [HR].[job_role] ([joro_id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [HR].[employee] CHECK CONSTRAINT [fk_emp_joro_id]
GO
ALTER TABLE [HR].[employee_department_history]  WITH CHECK ADD  CONSTRAINT [fk_edhi_dept_id] FOREIGN KEY([edhi_dept_id])
REFERENCES [HR].[department] ([dept_id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [HR].[employee_department_history] CHECK CONSTRAINT [fk_edhi_dept_id]
GO
ALTER TABLE [HR].[employee_department_history]  WITH CHECK ADD  CONSTRAINT [fk_edhi_emp_id] FOREIGN KEY([edhi_emp_id])
REFERENCES [HR].[employee] ([emp_id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [HR].[employee_department_history] CHECK CONSTRAINT [fk_edhi_emp_id]
GO
ALTER TABLE [HR].[employee_department_history]  WITH CHECK ADD  CONSTRAINT [fk_shift_id] FOREIGN KEY([edhi_shift_id])
REFERENCES [HR].[shift] ([shift_id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [HR].[employee_department_history] CHECK CONSTRAINT [fk_shift_id]
GO
ALTER TABLE [HR].[employee_pay_history]  WITH CHECK ADD  CONSTRAINT [fk_ephi_emp_id] FOREIGN KEY([ephi_emp_id])
REFERENCES [HR].[employee] ([emp_id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [HR].[employee_pay_history] CHECK CONSTRAINT [fk_ephi_emp_id]
GO
ALTER TABLE [HR].[work_order_detail]  WITH CHECK ADD  CONSTRAINT [fk_faci_id] FOREIGN KEY([wode_faci_id])
REFERENCES [Hotel].[Facilities] ([faci_id])
GO
ALTER TABLE [HR].[work_order_detail] CHECK CONSTRAINT [fk_faci_id]
GO
ALTER TABLE [HR].[work_order_detail]  WITH CHECK ADD  CONSTRAINT [fk_wode_emp_id] FOREIGN KEY([wode_emp_id])
REFERENCES [HR].[employee] ([emp_id])
GO
ALTER TABLE [HR].[work_order_detail] CHECK CONSTRAINT [fk_wode_emp_id]
GO
ALTER TABLE [HR].[work_order_detail]  WITH CHECK ADD  CONSTRAINT [fk_wode_seta_id] FOREIGN KEY([wode_seta_id])
REFERENCES [Master].[service_task] ([seta_id])
GO
ALTER TABLE [HR].[work_order_detail] CHECK CONSTRAINT [fk_wode_seta_id]
GO
ALTER TABLE [HR].[work_order_detail]  WITH CHECK ADD  CONSTRAINT [fk_woro_wode_id] FOREIGN KEY([wode_woro_id])
REFERENCES [HR].[work_orders] ([woro_id])
GO
ALTER TABLE [HR].[work_order_detail] CHECK CONSTRAINT [fk_woro_wode_id]
GO
ALTER TABLE [HR].[work_orders]  WITH CHECK ADD  CONSTRAINT [fk_woro_user_id] FOREIGN KEY([woro_user_id])
REFERENCES [Users].[users] ([user_id])
GO
ALTER TABLE [HR].[work_orders] CHECK CONSTRAINT [fk_woro_user_id]
GO
ALTER TABLE [Master].[address]  WITH CHECK ADD  CONSTRAINT [fk_addr_prov_id] FOREIGN KEY([addr_prov_id])
REFERENCES [Master].[provinces] ([prov_id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [Master].[address] CHECK CONSTRAINT [fk_addr_prov_id]
GO
ALTER TABLE [Master].[country]  WITH CHECK ADD  CONSTRAINT [fk_country_region_id] FOREIGN KEY([country_region_id])
REFERENCES [Master].[regions] ([region_code])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [Master].[country] CHECK CONSTRAINT [fk_country_region_id]
GO
ALTER TABLE [Master].[policy_category_group]  WITH CHECK ADD  CONSTRAINT [fk_poca_cagro_id] FOREIGN KEY([poca_cagro_id])
REFERENCES [Master].[category_group] ([cagro_id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [Master].[policy_category_group] CHECK CONSTRAINT [fk_poca_cagro_id]
GO
ALTER TABLE [Master].[policy_category_group]  WITH CHECK ADD  CONSTRAINT [fk_poca_poli_id] FOREIGN KEY([poca_poli_id])
REFERENCES [Master].[policy] ([poli_id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [Master].[policy_category_group] CHECK CONSTRAINT [fk_poca_poli_id]
GO
ALTER TABLE [Master].[provinces]  WITH CHECK ADD  CONSTRAINT [fk_prov_country_id] FOREIGN KEY([prov_country_id])
REFERENCES [Master].[country] ([country_id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [Master].[provinces] CHECK CONSTRAINT [fk_prov_country_id]
GO
ALTER TABLE [Payment].[bank]  WITH CHECK ADD  CONSTRAINT [FK_PaymentBankEntityId] FOREIGN KEY([bank_entity_id])
REFERENCES [Payment].[entity] ([entity_id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [Payment].[bank] CHECK CONSTRAINT [FK_PaymentBankEntityId]
GO
ALTER TABLE [Payment].[payment_gateway]  WITH CHECK ADD  CONSTRAINT [FK_PaymentGatewayEntityId] FOREIGN KEY([paga_entity_id])
REFERENCES [Payment].[entity] ([entity_id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [Payment].[payment_gateway] CHECK CONSTRAINT [FK_PaymentGatewayEntityId]
GO
ALTER TABLE [Payment].[payment_transaction]  WITH CHECK ADD  CONSTRAINT [FK_PaymentPaymentTransactionUserId] FOREIGN KEY([patr_user_id])
REFERENCES [Users].[users] ([user_id])
ON UPDATE CASCADE
ON DELETE SET NULL
GO
ALTER TABLE [Payment].[payment_transaction] CHECK CONSTRAINT [FK_PaymentPaymentTransactionUserId]
GO
ALTER TABLE [Payment].[user_accounts]  WITH CHECK ADD  CONSTRAINT [FK_PaymentUserAccountsEntityPaymentGateway_Bank] FOREIGN KEY([usac_entity_id])
REFERENCES [Payment].[entity] ([entity_id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [Payment].[user_accounts] CHECK CONSTRAINT [FK_PaymentUserAccountsEntityPaymentGateway_Bank]
GO
ALTER TABLE [Payment].[user_accounts]  WITH CHECK ADD  CONSTRAINT [FK_PaymentUserAccountsUserId] FOREIGN KEY([usac_user_id])
REFERENCES [Users].[users] ([user_id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [Payment].[user_accounts] CHECK CONSTRAINT [FK_PaymentUserAccountsUserId]
GO
ALTER TABLE [Purchasing].[cart]  WITH CHECK ADD  CONSTRAINT [fk_cart_employee] FOREIGN KEY([cart_emp_id])
REFERENCES [HR].[employee] ([emp_id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [Purchasing].[cart] CHECK CONSTRAINT [fk_cart_employee]
GO
ALTER TABLE [Purchasing].[cart]  WITH CHECK ADD  CONSTRAINT [fk_cart_vepro] FOREIGN KEY([cart_vepro_id])
REFERENCES [Purchasing].[vendor_product] ([vepro_id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [Purchasing].[cart] CHECK CONSTRAINT [fk_cart_vepro]
GO
ALTER TABLE [Purchasing].[purchase_order_detail]  WITH CHECK ADD  CONSTRAINT [fk_pode_pohe_id] FOREIGN KEY([pode_pohe_id])
REFERENCES [Purchasing].[purchase_order_header] ([pohe_id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [Purchasing].[purchase_order_detail] CHECK CONSTRAINT [fk_pode_pohe_id]
GO
ALTER TABLE [Purchasing].[purchase_order_detail]  WITH CHECK ADD  CONSTRAINT [fk_pode_stock_id] FOREIGN KEY([pode_stock_id])
REFERENCES [Purchasing].[stocks] ([stock_id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [Purchasing].[purchase_order_detail] CHECK CONSTRAINT [fk_pode_stock_id]
GO
ALTER TABLE [Purchasing].[purchase_order_header]  WITH CHECK ADD  CONSTRAINT [fk_pohe_emp_id] FOREIGN KEY([pohe_emp_id])
REFERENCES [HR].[employee] ([emp_id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [Purchasing].[purchase_order_header] CHECK CONSTRAINT [fk_pohe_emp_id]
GO
ALTER TABLE [Purchasing].[purchase_order_header]  WITH CHECK ADD  CONSTRAINT [fk_pohe_vendor_id] FOREIGN KEY([pohe_vendor_id])
REFERENCES [Purchasing].[vendor] ([vendor_entity_id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [Purchasing].[purchase_order_header] CHECK CONSTRAINT [fk_pohe_vendor_id]
GO
ALTER TABLE [Purchasing].[stock_detail]  WITH CHECK ADD  CONSTRAINT [fk_stod_faci_id] FOREIGN KEY([stod_faci_id])
REFERENCES [Hotel].[Facilities] ([faci_id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [Purchasing].[stock_detail] CHECK CONSTRAINT [fk_stod_faci_id]
GO
ALTER TABLE [Purchasing].[stock_detail]  WITH CHECK ADD  CONSTRAINT [fk_stod_pohe_id] FOREIGN KEY([stod_pohe_id])
REFERENCES [Purchasing].[purchase_order_header] ([pohe_id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [Purchasing].[stock_detail] CHECK CONSTRAINT [fk_stod_pohe_id]
GO
ALTER TABLE [Purchasing].[stock_detail]  WITH CHECK ADD  CONSTRAINT [fk_stod_stock_id] FOREIGN KEY([stod_stock_id])
REFERENCES [Purchasing].[stocks] ([stock_id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [Purchasing].[stock_detail] CHECK CONSTRAINT [fk_stod_stock_id]
GO
ALTER TABLE [Purchasing].[stock_photo]  WITH CHECK ADD  CONSTRAINT [fk_spho_stock_id] FOREIGN KEY([spho_stock_id])
REFERENCES [Purchasing].[stocks] ([stock_id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [Purchasing].[stock_photo] CHECK CONSTRAINT [fk_spho_stock_id]
GO
ALTER TABLE [Purchasing].[vendor]  WITH CHECK ADD  CONSTRAINT [fk_vendor_entity_id] FOREIGN KEY([vendor_entity_id])
REFERENCES [Payment].[entity] ([entity_id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [Purchasing].[vendor] CHECK CONSTRAINT [fk_vendor_entity_id]
GO
ALTER TABLE [Purchasing].[vendor_product]  WITH CHECK ADD  CONSTRAINT [fk_venpro_stock_id] FOREIGN KEY([venpro_stock_id])
REFERENCES [Purchasing].[stocks] ([stock_id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [Purchasing].[vendor_product] CHECK CONSTRAINT [fk_venpro_stock_id]
GO
ALTER TABLE [Purchasing].[vendor_product]  WITH CHECK ADD  CONSTRAINT [fk_vepro_vendor_id] FOREIGN KEY([vepro_vendor_id])
REFERENCES [Purchasing].[vendor] ([vendor_entity_id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [Purchasing].[vendor_product] CHECK CONSTRAINT [fk_vepro_vendor_id]
GO
ALTER TABLE [Resto].[order_menu_detail]  WITH CHECK ADD  CONSTRAINT [fk_omde_orme_id] FOREIGN KEY([omde_orme_id])
REFERENCES [Resto].[order_menus] ([orme_id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [Resto].[order_menu_detail] CHECK CONSTRAINT [fk_omde_orme_id]
GO
ALTER TABLE [Resto].[order_menu_detail]  WITH CHECK ADD  CONSTRAINT [fk_omde_reme_id] FOREIGN KEY([omde_reme_id])
REFERENCES [Resto].[resto_menus] ([reme_id])
GO
ALTER TABLE [Resto].[order_menu_detail] CHECK CONSTRAINT [fk_omde_reme_id]
GO
ALTER TABLE [Resto].[order_menus]  WITH CHECK ADD  CONSTRAINT [fk_orme_user_id] FOREIGN KEY([orme_user_id])
REFERENCES [Users].[users] ([user_id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [Resto].[order_menus] CHECK CONSTRAINT [fk_orme_user_id]
GO
ALTER TABLE [Resto].[resto_menu_photos]  WITH CHECK ADD  CONSTRAINT [fk_remp_reme_id] FOREIGN KEY([remp_reme_id])
REFERENCES [Resto].[resto_menus] ([reme_id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [Resto].[resto_menu_photos] CHECK CONSTRAINT [fk_remp_reme_id]
GO
ALTER TABLE [Resto].[resto_menus]  WITH CHECK ADD  CONSTRAINT [reme_faci_id] FOREIGN KEY([reme_faci_id])
REFERENCES [Hotel].[Facilities] ([faci_id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [Resto].[resto_menus] CHECK CONSTRAINT [reme_faci_id]
GO
ALTER TABLE [Users].[bonus_points]  WITH CHECK ADD  CONSTRAINT [fk_ubpo_user_id] FOREIGN KEY([ubpo_user_id])
REFERENCES [Users].[users] ([user_id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [Users].[bonus_points] CHECK CONSTRAINT [fk_ubpo_user_id]
GO
ALTER TABLE [Users].[user_members]  WITH CHECK ADD  CONSTRAINT [fk_usme_memb_name] FOREIGN KEY([usme_memb_name])
REFERENCES [Master].[members] ([memb_name])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [Users].[user_members] CHECK CONSTRAINT [fk_usme_memb_name]
GO
ALTER TABLE [Users].[user_members]  WITH CHECK ADD  CONSTRAINT [fk_usme_user_id] FOREIGN KEY([usme_user_id])
REFERENCES [Users].[users] ([user_id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [Users].[user_members] CHECK CONSTRAINT [fk_usme_user_id]
GO
ALTER TABLE [Users].[user_password]  WITH CHECK ADD  CONSTRAINT [fk_uspa_user_id] FOREIGN KEY([uspa_user_id])
REFERENCES [Users].[users] ([user_id])
GO
ALTER TABLE [Users].[user_password] CHECK CONSTRAINT [fk_uspa_user_id]
GO
ALTER TABLE [Users].[user_profiles]  WITH CHECK ADD  CONSTRAINT [fk_uspro_addr_id] FOREIGN KEY([uspro_addr_id])
REFERENCES [Master].[address] ([addr_id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [Users].[user_profiles] CHECK CONSTRAINT [fk_uspro_addr_id]
GO
ALTER TABLE [Users].[user_profiles]  WITH CHECK ADD  CONSTRAINT [fk_uspro_user_id] FOREIGN KEY([uspro_user_id])
REFERENCES [Users].[users] ([user_id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [Users].[user_profiles] CHECK CONSTRAINT [fk_uspro_user_id]
GO
ALTER TABLE [Users].[user_roles]  WITH CHECK ADD  CONSTRAINT [fk_usro_role_id] FOREIGN KEY([usro_role_id])
REFERENCES [Users].[roles] ([role_id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [Users].[user_roles] CHECK CONSTRAINT [fk_usro_role_id]
GO
ALTER TABLE [Users].[user_roles]  WITH CHECK ADD  CONSTRAINT [fk_usro_user_id] FOREIGN KEY([usro_user_id])
REFERENCES [Users].[users] ([user_id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [Users].[user_roles] CHECK CONSTRAINT [fk_usro_user_id]
GO
ALTER TABLE [Booking].[booking_order_detail_extra]  WITH CHECK ADD CHECK  (([boex_measure_unit]='kg' OR [boex_measure_unit]='unit' OR [boex_measure_unit]='people'))
GO
ALTER TABLE [Booking].[booking_orders]  WITH CHECK ADD CHECK  (([boor_pay_type]='PG' OR [boor_pay_type]='D' OR [boor_pay_type]='C' OR [boor_pay_type]='CR'))
GO
ALTER TABLE [Booking].[booking_orders]  WITH CHECK ADD CHECK  (([boor_is_paid]='R' OR [boor_is_paid]='P' OR [boor_is_paid]='DP'))
GO
ALTER TABLE [Booking].[booking_orders]  WITH CHECK ADD CHECK  (([boor_type]='I' OR [boor_type]='C' OR [boor_type]='T'))
GO
ALTER TABLE [Booking].[booking_orders]  WITH CHECK ADD CHECK  (([boor_status]='CANCELED' OR [boor_status]='CLEANING' OR [boor_status]='CHECKOUT' OR [boor_status]='CHECKIN' OR [boor_status]='BOOKING'))
GO
ALTER TABLE [Booking].[special_offers]  WITH CHECK ADD CHECK  (([spof_type]='I' OR [spof_type]='C' OR [spof_type]='T'))
GO
ALTER TABLE [Hotel].[Facilities]  WITH CHECK ADD CHECK  (([faci_measure_unit]='beds' OR [faci_measure_unit]='people'))
GO
ALTER TABLE [Hotel].[Facilities]  WITH CHECK ADD CHECK  (([faci_expose_price]=(3) OR [faci_expose_price]=(2) OR [faci_expose_price]=(1)))
GO
ALTER TABLE [Hotel].[Facility_Photos]  WITH CHECK ADD CHECK  (([fapho_primary]=(1) OR [fapho_primary]=(0)))
GO
ALTER TABLE [Hotel].[Hotel_Reviews]  WITH CHECK ADD CHECK  (([hore_rating]=(5) OR [hore_rating]=(4) OR [hore_rating]=(3) OR [hore_rating]=(2) OR [hore_rating]=(1)))
GO
ALTER TABLE [Hotel].[Hotels]  WITH CHECK ADD CHECK  (([hotel_status]=(1) OR [hotel_status]=(0)))
GO
ALTER TABLE [Master].[category_group]  WITH CHECK ADD CHECK  (([cagro_type]='facility' OR [cagro_type]='service' OR [cagro_type]='category'))
GO
ALTER TABLE [Master].[price_items]  WITH CHECK ADD CHECK  (([prit_type]='SERVICE' OR [prit_type]='FOOD' OR [prit_type]='SOFTDRINK' OR [prit_type]='FACILITY' OR [prit_type]='SNACK'))
GO
ALTER TABLE [Payment].[payment_transaction]  WITH CHECK ADD  CONSTRAINT [CK_PaymentPaymentTransactionType] CHECK  (([patr_type]='ORM' OR [patr_type]='RF' OR [patr_type]='RPY' OR [patr_type]='TRB' OR [patr_type]='TP'))
GO
ALTER TABLE [Payment].[payment_transaction] CHECK CONSTRAINT [CK_PaymentPaymentTransactionType]
GO
ALTER TABLE [Payment].[user_accounts]  WITH CHECK ADD  CONSTRAINT [CK_PaymentUserAccountsType] CHECK  (([usac_type]='payment' OR [usac_type]='credit_card' OR [usac_type]='debet'))
GO
ALTER TABLE [Payment].[user_accounts] CHECK CONSTRAINT [CK_PaymentUserAccountsType]
GO
ALTER TABLE [Purchasing].[cart]  WITH CHECK ADD  CONSTRAINT [ck_cart_modified_date] CHECK  (([cart_modified_date]<=getdate()))
GO
ALTER TABLE [Purchasing].[cart] CHECK CONSTRAINT [ck_cart_modified_date]
GO
ALTER TABLE [Purchasing].[purchase_order_header]  WITH CHECK ADD  CONSTRAINT [ck_pohe_pay_type] CHECK  (([pohe_pay_type]='CA' OR [pohe_pay_type]='TR'))
GO
ALTER TABLE [Purchasing].[purchase_order_header] CHECK CONSTRAINT [ck_pohe_pay_type]
GO
ALTER TABLE [Purchasing].[purchase_order_header]  WITH CHECK ADD  CONSTRAINT [ck_pohe_status] CHECK  (([pohe_status]=(5) OR [pohe_status]=(4) OR [pohe_status]=(3) OR [pohe_status]=(2) OR [pohe_status]=(1)))
GO
ALTER TABLE [Purchasing].[purchase_order_header] CHECK CONSTRAINT [ck_pohe_status]
GO
ALTER TABLE [Purchasing].[stock_detail]  WITH CHECK ADD  CONSTRAINT [ck_stod_status] CHECK  (([stod_status]=(4) OR [stod_status]=(3) OR [stod_status]=(2) OR [stod_status]=(1)))
GO
ALTER TABLE [Purchasing].[stock_detail] CHECK CONSTRAINT [ck_stod_status]
GO
ALTER TABLE [Purchasing].[stock_photo]  WITH CHECK ADD  CONSTRAINT [ck_spho_primary] CHECK  (([spho_primary]=(1) OR [spho_primary]=(0)))
GO
ALTER TABLE [Purchasing].[stock_photo] CHECK CONSTRAINT [ck_spho_primary]
GO
ALTER TABLE [Purchasing].[vendor]  WITH CHECK ADD  CONSTRAINT [ck_vendor_active] CHECK  (([vendor_active]=(1) OR [vendor_active]=(0)))
GO
ALTER TABLE [Purchasing].[vendor] CHECK CONSTRAINT [ck_vendor_active]
GO
ALTER TABLE [Purchasing].[vendor]  WITH CHECK ADD  CONSTRAINT [ck_vendor_priority] CHECK  (([vendor_priority]=(1) OR [vendor_priority]=(0)))
GO
ALTER TABLE [Purchasing].[vendor] CHECK CONSTRAINT [ck_vendor_priority]
GO
ALTER TABLE [Users].[user_members]  WITH CHECK ADD CHECK  (([usme_memb_name]='Wizard' OR [usme_memb_name]='VIP' OR [usme_memb_name]='Gold' OR [usme_memb_name]='Silver'))
GO
ALTER TABLE [Users].[user_profiles]  WITH CHECK ADD CHECK  (([uspro_marital_status]='S' OR [uspro_marital_status]='M'))
GO
ALTER TABLE [Users].[user_profiles]  WITH CHECK ADD CHECK  (([uspro_gender]='F' OR [uspro_gender]='M'))
GO
ALTER TABLE [Users].[users]  WITH CHECK ADD CHECK  (([user_type]='I' OR [user_type]='C' OR [user_type]='T'))
GO
/****** Object:  StoredProcedure [Booking].[sp_insert_booking_extra]    Script Date: 13/11/2023 17:39:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ============================================================
-- Author:		Gabriel
-- Create date: 14 March 2023
-- Description:	Procedure for insert booking_order_detail_extra
-- =============================================================

CREATE   PROCEDURE [Booking].[sp_insert_booking_extra]
	@boex_borde_id int,
	@boex_prit_id int,
	@boex_qty smallint,
	@boex_measure_unit nvarchar(50)
AS
BEGIN
	SET XACT_ABORT ON
	DECLARE @prit_price smallmoney=(select prit_price from Master.price_items where prit_id=@boex_prit_id);
	INSERT INTO Booking.booking_order_detail_extra
	(
		boex_borde_id,
		boex_prit_id,
		boex_price,
		boex_qty,
		boex_measure_unit
	)
	VALUES
	(
		@boex_borde_id,
		@boex_prit_id,
		@prit_price,
		@boex_qty,
		@boex_measure_unit
	)
    select SCOPE_IDENTITY();
END

GO
/****** Object:  StoredProcedure [Booking].[sp_insert_booking_order_detail]    Script Date: 13/11/2023 17:39:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   procedure [Booking].[sp_insert_booking_order_detail]
	@borde_boor_id int,
	@borde_faci_id int,
	@borde_checkin datetime,
	@borde_checkout datetime,
	@borde_discount smallmoney=NULL
AS
BEGIN
	SET XACT_ABORT ON
	DECLARE @faci_price money = (select faci_rate_price from Hotel.facilities where faci_id=@borde_faci_id)
	DECLARE @faci_tax smallmoney = (select faci_tax_rate/faci_rate_price from Hotel.facilities where faci_id=@borde_faci_id)

	-- Insert borde
	INSERT INTO Booking.booking_order_detail
	(
		borde_boor_id,
		borde_faci_id,
		borde_checkin,
		borde_checkout,
		borde_price,
		borde_adults,
		borde_kids,
		borde_extra,
		borde_discount,
		borde_tax
	)
    VALUES
	(
		@borde_boor_id,
		@borde_faci_id,
		@borde_checkin,
		@borde_checkout,
		@faci_price,
		0,--bordeAdults
		0,--bordeKids
		0,--bordeExtra
		0,--bordeDiscount,
		@faci_tax
	);
	-- get borde_id for insertion into booking_order_detail_extra
    select SCOPE_IDENTITY();
END

GO
/****** Object:  StoredProcedure [Booking].[sp_insert_booking_orders]    Script Date: 13/11/2023 17:39:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Gabriel
-- Create date: 14 March 2023
-- Description:	Procedure for insert booking_orders
-- =============================================

CREATE   procedure [Booking].[sp_insert_booking_orders]
	@boor_hotel_id as int,
	@boor_user_id as int,
	@boor_pay_type as nchar(2),
	@boor_is_paid as nchar(2),
	@boor_down_payment as money =0
AS
BEGIN
	-- declare abort on action
	SET XACT_ABORT ON;

	-- declare and retriving latest id,order_date and generate order_number
	DECLARE @boor_order_id INT = IDENT_CURRENT('Booking.booking_orders');
	DECLARE @boor_order_date DATE = GETDATE();
	DECLARE @boor_order_number VARCHAR(50);
	-- generate order number
	SET @boor_order_number =
		CONCAT
		(
			'BO#',
			CONVERT(VARCHAR(10), @boor_order_date, 112),
			'-',
			RIGHT('0000' + CAST(@boor_order_id+1 AS VARCHAR(4)), 4)
		);

	--retrive member type from users
	declare @member_type nvarchar(15) = COALESCE((select usme_memb_name from Users.user_members where usme_user_id=@boor_user_id),'');
	--retrive
	declare @boor_type nvarchar(15) = COALESCE((select user_type from Users.users where user_id=@boor_user_id),'I');

	INSERT INTO
		Booking.booking_orders
		(
			boor_hotel_id,
			boor_user_id,
			boor_order_number,
			boor_order_date,
			boor_pay_type,
			boor_is_paid,
			boor_type,
			boor_member_type
		)
		VALUES
		(
			@boor_hotel_id,
			@boor_user_id,
			@boor_order_number,
			@boor_order_date,
			@boor_pay_type,
			@boor_is_paid,
			@boor_type,
			@member_type
		);
	--insert to booking_orders
	select SCOPE_IDENTITY();

END

GO
/****** Object:  StoredProcedure [Hotel].[spSelectHotel]    Script Date: 13/11/2023 17:39:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ===========================================================
-- Author	  :	Alvan Ganteng
-- Create date: 7 March 2023
-- Description:	Store Procedure for SELECT Hotel.Hotels
-- ===========================================================

CREATE PROCEDURE [Hotel].[spSelectHotel]
AS
BEGIN
	SET NOCOUNT	ON;

	SELECT
		hotel_id AS HotelId
		,hotel_name AS HotelName
		,hotel_description AS HotelDescription
		,hotel_status AS HotelStatus
		,hotel_reason_status AS HotelReasonStatus
		,hotel_rating_star AS HotelRatingStar
		,hotel_phonenumber AS HotelPhonenumber
		,hotel_modified_date AS HotelModifiedDate
		,hotel_addr_id AS HotelAddrId
		,hotel_addr_description AS HotelAddrDescription
	FROM Hotel.Hotels
END;

GO
/****** Object:  StoredProcedure [Master].[AddOrUpdatePriceItem]    Script Date: 13/11/2023 17:39:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Alip
-- Create date: 14 March 2023
-- Description:	Store Procedure Price_items
-- =============================================

CREATE PROCEDURE [Master].[AddOrUpdatePriceItem]
    @pritid int = NULL,
    @pritname nvarchar(55),
    @prittype nvarchar(15),
    @pritprice money,
    @pritdescription nvarchar(255),
    @priticonurl nvarchar(255)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRAN

        IF @pritid IS NOT NULL -- Update existing price item
        BEGIN
            UPDATE [Master].[price_items]
            SET prit_name = @pritname,
                prit_type = @prittype,
                prit_price = @pritprice,
                prit_description = @pritdescription,
                prit_icon_url = @priticonurl,
                prit_modified_date = GETDATE()
            WHERE prit_id = @pritid
        END
        ELSE -- Insert new price item
        BEGIN
            INSERT INTO Master.price_items(prit_name, prit_type, prit_price, prit_description, prit_icon_url, prit_modified_date)
            VALUES (@pritname, @prittype, @pritprice, @pritdescription, @priticonurl, GETDATE())
        END

        COMMIT TRAN
    END TRY
    BEGIN CATCH
        ROLLBACK TRAN;
        THROW;
    END CATCH
END
GO
/****** Object:  StoredProcedure [Payment].[spCalculationTranferBooking]    Script Date: 13/11/2023 17:39:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Harpi
-- Create date: 8 January 2023
-- Description:	Store Procedure for transfer booking transaction
-- =============================================
CREATE   PROC [Payment].[spCalculationTranferBooking]
    @source_account AS NVARCHAR(50),
    @target_account AS NVARCHAR(50),
    @order_number AS NVARCHAR(50),
    @total_amount AS MONEY OUTPUT
    AS
    BEGIN
        SET NOCOUNT ON;
        BEGIN TRY
            BEGIN TRANSACTION
                DECLARE @user_payment_method varchar(10);
                DECLARE @user_current_saldo AS MONEY;
                DECLARE @total_down_payment AS MONEY;
                DECLARE @payment_option AS NCHAR(2);

                SELECT @total_amount = boor_total_ammount,
                       @total_down_payment = boor_down_payment,
                       @payment_option = TRIM(boor_is_paid),
                       @user_payment_method = boor_pay_type
                FROM Booking.booking_orders
                WHERE boor_order_number = @order_number

                -- set value @user_current_saldo
                SELECT @user_current_saldo = usac_saldo
                  FROM Payment.user_accounts
                 WHERE usac_account_number = @source_account

                -- check if the payment method is 'cash' just ignore it
                -- CR = credit_card
                -- D = debet
                -- PG = payment / payment_gateway
                IF (@user_payment_method IN ('D', 'CR', 'PG'))
                BEGIN
                    IF @user_payment_method = 'D' OR @user_payment_method = 'PG'
                    BEGIN
                        -- check if payment option is 'Down Payment'
                        IF (@payment_option = 'DP' AND (@user_current_saldo - @total_down_payment) < 0)
                            ROLLBACK -- TODO : Tambahkan feature untuk pemberitahuan bahwa saldo kurang utk dp!

                        -- check if payment options is 'Paid'
                        IF (@payment_option = 'P' AND (@user_current_saldo - @total_amount) < 0)
                            ROLLBACK -- TODO : Tambahkan feature untuk pemberitahuan bahwa saldo kurang!
                    ELSE
                    -- change total_amount if transaction is 'Down Payment'
                        SET @total_amount = @total_down_payment IF @payment_option = 'DP'

                        -- TODO : check apakah lunas atau tidak , jika lunas status paid jika tidak maka lainya!
                        -- paying booking order from user account to realta hotel account
                        EXECUTE [Payment].spTranferMoney
                                @source_account
                                ,@target_account
                                ,@total_amount
                    END


                END
                        -- IF (@@ROWCOUNT > 0)
--                     BEGIN
--                            UPDATE [Booking].[booking_orders]
--                             SET boor_is_paid = 'P'
--                             WHERE boor_order_number = @order_number;
--
--                            SELECT 'SUCCESS' AS STATUS
--                     END
            COMMIT TRANSACTION
        END TRY
        BEGIN CATCH
            ROLLBACK
        END CATCH
    END

GO
/****** Object:  StoredProcedure [Payment].[spCalculationTranferOrderMenu]    Script Date: 13/11/2023 17:39:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Harpi
-- Create date: 8 January 2023
-- Description:	Store Procedure for transfer booking transaction
-- =============================================
CREATE   PROC [Payment].[spCalculationTranferOrderMenu]
    @source_account AS NVARCHAR(50),
    @target_account AS NVARCHAR(50),
    @order_number AS NVARCHAR(50),
    @total_amount AS MONEY OUTPUT
    AS
    BEGIN
        SET NOCOUNT ON;
        BEGIN TRY
            BEGIN TRANSACTION
                DECLARE @user_payment_method varchar(10);
                DECLARE @user_current_saldo AS MONEY;
                DECLARE @payment_option AS NCHAR(2);

                SELECT @total_amount = orme_total_amount,
                       @payment_option = TRIM(orme_is_paid),
                       @user_payment_method = orme_pay_type
                FROM Resto.order_menus
                WHERE orme_order_number = @order_number

                -- set value @user_current_saldo
                SELECT @user_current_saldo = usac_saldo
                  FROM Payment.user_accounts
                 WHERE usac_account_number = @source_account

                -- check if the payment method is 'cash' just ignore it
                -- CR = credit_card
                -- D = debet
                -- PG = payment / payment_gateway
                IF (@user_payment_method IN ('D', 'CR', 'PG'))
                BEGIN
                    IF @user_payment_method = 'D' OR @user_payment_method = 'PG'
                    BEGIN
                        -- check if payment option is 'Down Payment'
--                         IF (@payment_option = 'DP' AND (@user_current_saldo - @total_down_payment) < 0)
--                             ROLLBACK -- TODO : Tambahkan feature untuk pemberitahuan bahwa saldo kurang utk dp!

                        -- check if payment options is 'Paid'
                       IF ((@user_current_saldo - @total_amount) < 0)
                            ROLLBACK

--                         IF (@payment_option = 'P' AND (@user_current_saldo - @total_amount) < 0)
--                             ROLLBACK -- TODO : Tambahkan feature untuk pemberitahuan bahwa saldo kurang!
                    ELSE
                        -- TODO : check apakah lunas atau tidak , jika lunas status paid jika tidak maka lainya!
                        -- paying booking order from user account to realta hotel account
                        EXECUTE [Payment].spTranferMoney
                                @source_account
                                ,@target_account
                                ,@total_amount
                    END
                END
            COMMIT TRANSACTION
        END TRY
        BEGIN CATCH
            ROLLBACK
        END CATCH
    END

GO
/****** Object:  StoredProcedure [Payment].[spCreatePaymentTransaction]    Script Date: 13/11/2023 17:39:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Harpi
-- Create date: 9 Januari 2023
-- Description:	Stored procedure for create payment_transaction (UNUSED)
-- =============================================
CREATE PROCEDURE [Payment].[spCreatePaymentTransaction]
	-- Add the parameters for the stored procedure here
    @debet money
    ,@credit money
    ,@type nchar(3)
    ,@note nvarchar(255)
    ,@order_number nvarchar(55)
    ,@source_id nvarchar(55)
    ,@target_id nvarchar(55)
    ,@trx_number_ref nvarchar(55)
    ,@user_id int
AS
BEGIN
    -- Generate transaction number
    DECLARE @trx_number nvarchar(55);
    SET @trx_number = CONCAT(TRIM(@type),'#',
                     CONVERT(varchar, GETDATE(), 12),'-',
                      RIGHT('0000' + CAST(IDENT_CURRENT('Payment.[payment_transaction]') AS NVARCHAR(4)), 4));

    -- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    BEGIN TRANSACTION
        INSERT INTO [Payment].[payment_transaction](
                    patr_trx_number, patr_debet, patr_credit, patr_type, patr_note,
                    patr_order_number, patr_source_id, patr_target_id, patr_trx_number_ref, patr_user_id)
            VALUES (@trx_number, @debet, @credit, @type, @note, @order_number, @source_id, @target_id, @trx_number_ref, @user_id)
    COMMIT TRANSACTION
    -- Insert statements for procedure here
END

GO
/****** Object:  StoredProcedure [Payment].[spCreateTransferBooking]    Script Date: 13/11/2023 17:39:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Harpi
-- Create date: 13 March 2023
-- Description:	Store Procedure for create transfer booking
-- =============================================
CREATE PROCEDURE [Payment].[spCreateTransferBooking]
       @boor_order_number VARCHAR(50)
       ,@boor_card_number VARCHAR(50)
       ,@boor_user_id INT
AS
BEGIN
    INSERT
      INTO Payment.payment_transaction(patr_type, patr_note, patr_order_number, patr_source_id, patr_target_id, patr_user_id)
    VALUES ('TRB', 'Transfer Booking Note', @boor_order_number, @boor_card_number, '131-3456-78', @boor_user_id);
END

GO
/****** Object:  StoredProcedure [Payment].[spCreateTransferOrderMenu]    Script Date: 13/11/2023 17:39:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Harpi
-- Create date: 13 March 2023
-- Description:	Store Procedure for create transfer orderMenu
-- =============================================
CREATE PROCEDURE [Payment].[spCreateTransferOrderMenu]
       @orme_order_number VARCHAR(50)
       ,@orme_card_number VARCHAR(50)
       ,@orme_user_id INT
AS
BEGIN
    INSERT
      INTO Payment.payment_transaction(patr_type, patr_note, patr_order_number, patr_source_id, patr_target_id, patr_user_id)
    VALUES ('ORM', 'Transfer Order Menu Note', @orme_order_number, @orme_card_number, '131-3456-78', @orme_user_id);
END

GO
/****** Object:  StoredProcedure [Payment].[spCreateTransferRefund]    Script Date: 13/11/2023 17:39:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Harpi
-- Create date: 13 March 2023
-- Description:	Store Procedure for create transfer refund money
-- =============================================
CREATE   PROCEDURE [Payment].[spCreateTransferRefund]
       @boor_order_number VARCHAR(50)
       ,@boor_user_id INT
AS
BEGIN
    INSERT
      INTO Payment.payment_transaction(patr_type, patr_note, patr_order_number, patr_user_id)
    VALUES ('RF', '*Refund Booking Order', @boor_order_number, @boor_user_id);
END

GO
/****** Object:  StoredProcedure [Payment].[spCreateTransferRepayment]    Script Date: 13/11/2023 17:39:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Harpi
-- Create date: 13 March 2023
-- Description:	Store Procedure for create transfer repayment
-- =============================================
CREATE   PROCEDURE [Payment].[spCreateTransferRepayment]
       @boor_order_number VARCHAR(50)
       ,@boor_card_number VARCHAR(50)
       ,@boor_user_id INT
AS
BEGIN
    INSERT
      INTO Payment.payment_transaction(patr_type, patr_note, patr_order_number, patr_source_id, patr_target_id, patr_user_id)
    VALUES ('RPY', 'Repayment', @boor_order_number, @boor_card_number, '131-3456-78', @boor_user_id);
END

GO
/****** Object:  StoredProcedure [Payment].[spCreateTransferTopUp]    Script Date: 13/11/2023 17:39:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Harpi
-- Create date: 13 March 2023
-- Description:	Store Procedure for create transfer booking
-- =============================================
CREATE   PROCEDURE [Payment].[spCreateTransferTopUp]
   @source_account VARCHAR(50)
   ,@target_account VARCHAR(50)
   ,@boor_user_id INT
   ,@amount AS MONEY
AS
BEGIN
    INSERT
      INTO Payment.payment_transaction(patr_credit, patr_type, patr_note,
                                      patr_source_id, patr_target_id, patr_user_id)
    VALUES (@amount, 'TP', 'Top Up Note', @source_account, @target_account, @boor_user_id);
END

GO
/****** Object:  StoredProcedure [Payment].[spRefundTransaction]    Script Date: 13/11/2023 17:39:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Harpi
-- Create date: 13 Februari 2023
-- Description:	Store Procedure for refund transfer
-- =============================================
CREATE   PROCEDURE [Payment].[spRefundTransaction]
    @trx_number AS VARCHAR(50),
    @refund_rate AS FLOAT = 50,
    @total_amount AS MONEY OUTPUT
    AS
    BEGIN
        BEGIN TRY
            BEGIN TRANSACTION
                DECLARE @source_account VARCHAR(55);
                DECLARE @target_account VARCHAR(55);
                DECLARE @refund_amount MONEY;
                DECLARE @refund_age INT;

                SET @source_account = '131-3456-78';

                SELECT @refund_amount = Payment.fnRefundAmount((patr_credit + patr_debet), @refund_rate),
                       @refund_age = DATEDIFF(day, patr_modified_date, GETDATE()),
                       @target_account = patr_source_id
                FROM Payment.payment_transaction
                WHERE patr_trx_number = @trx_number

--                 IF (@refund_amount > 0.0 AND @refund_age < 7)
--                 BEGIN
                    -- refund from realta bank account to customer user account
                    EXECUTE [Payment].spTranferMoney
                            @source_account
                            ,@target_account
                            ,@refund_amount
--
                    SET @total_amount = @refund_amount;
--                 END
            COMMIT TRANSACTION
        END TRY
        BEGIN CATCH
        END CATCH
    END

GO
/****** Object:  StoredProcedure [Payment].[spRepaymentTransaction]    Script Date: 13/11/2023 17:39:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Harpi
-- Create date: 8 January 2023
-- Description:	Store Procedure for transfer repayment transaction
-- =============================================
CREATE   PROC [Payment].[spRepaymentTransaction]
    @source_account AS NVARCHAR(50),
    @target_account AS NVARCHAR(50),
    @order_number AS NVARCHAR(50),
    @bill_total AS MONEY OUTPUT
    AS
    BEGIN
        SET NOCOUNT ON;
        BEGIN TRY
            BEGIN TRANSACTION
                DECLARE @user_payment_method varchar(10);
                DECLARE @user_current_saldo AS MONEY;
                DECLARE @payment_option AS NCHAR(2);

                SELECT @bill_total = (boor_total_ammount - boor_down_payment),
                       @payment_option = TRIM(boor_is_paid),
                       @user_payment_method = TRIM(boor_pay_type)
                FROM Booking.booking_orders
                WHERE boor_order_number = @order_number

                -- set value @user_current_saldo
                SELECT @user_current_saldo = usac_saldo
                  FROM Payment.user_accounts
                 WHERE usac_account_number = @source_account

                -- check if the payment method is 'cash' just ignore it
                -- CR = credit_card
                -- D = debet
                -- PG = payment / payment_gateway
                IF (@user_payment_method IN ('D', 'CR', 'PG'))
                BEGIN
                    IF @user_payment_method = 'D' OR @user_payment_method = 'PG'
                    BEGIN
                        -- check if payment option is 'Down Payment'
                        IF (@payment_option != 'DP' OR (@user_current_saldo - @bill_total) < 0)
                            ROLLBACK -- TODO : Tambahkan feature untuk pemberitahuan bahwa saldo kurang utk dp!
                    ELSE
                        -- TODO : check apakah lunas atau tidak , jika lunas status paid jika tidak maka lainya!
                        -- paying booking order from user account to realta hotel account
                        EXECUTE [Payment].spTranferMoney
                                @source_account
                                ,@target_account
                                ,@bill_total
                    END
                END
            COMMIT TRANSACTION
        END TRY
        BEGIN CATCH
            ROLLBACK
        END CATCH
    END

GO
/****** Object:  StoredProcedure [Payment].[spTopUpTransaction]    Script Date: 13/11/2023 17:39:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Harpi
-- Create date: 8 January 2023
-- Description:	Store Procedure for top up transaction
-- =============================================
CREATE PROCEDURE [Payment].[spTopUpTransaction]
	-- Add the parameters for the stored procedure here
	 @source_account As nvarchar(50),
	 @target_account As nvarchar(50),
	 @amount As money = 0
AS
BEGIN
    DECLARE @source_usac_type varchar(50);
    DECLARE @target_usac_type varchar(50);
    DECLARE @usac_current_saldo AS MONEY;
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	-- TOP UP
    BEGIN TRY
        BEGIN TRANSACTION

            -- set value @source_usac_type
            SELECT @source_usac_type = usac_type,
                   @usac_current_saldo = usac_saldo
              FROM Payment.user_accounts
             WHERE usac_account_number = @source_account

            -- set value @target_usac_type
            SELECT @target_usac_type = usac_type
              FROM Payment.user_accounts
             WHERE usac_account_number = @target_account

            -- top up from user bank account
            IF (@source_usac_type = 'debet' OR @source_usac_type = 'credit_card')
            BEGIN
                IF @source_usac_type = 'debet'
                BEGIN
                    IF @usac_current_saldo-@amount < 0
                        ROLLBACK
                ELSE
                    -- to fintech
                    IF (@target_usac_type = 'payment')
                    BEGIN
                        EXECUTE [Payment].spTranferMoney
                            @source_account
                            ,@target_account
                            ,@amount
                    END
                END
            END
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION
    END CATCH
END

GO
/****** Object:  StoredProcedure [Payment].[spTranferMoney]    Script Date: 13/11/2023 17:39:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Harpi
-- Create date: 13 March 2023
-- Description:	Store Procedure for tranfer money (manipulation)
-- =============================================
CREATE   PROCEDURE [Payment].[spTranferMoney]
    @source_account AS VARCHAR(50),
    @target_account AS VARCHAR(50),
    @amount AS MONEY
  AS BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
            -- from source account
           UPDATE Payment.user_accounts
              SET usac_saldo = usac_saldo - @amount,
                  usac_modified_date = GETDATE()
            WHERE usac_account_number = @source_account;

            -- to target account
            UPDATE Payment.user_accounts
               SET usac_saldo = usac_saldo + @amount,
                   usac_modified_date = GETDATE()
             WHERE usac_account_number = @target_account;
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        ROLLBACK;
    END CATCH
END

GO
/****** Object:  StoredProcedure [Payment].[spUpdateBank]    Script Date: 13/11/2023 17:39:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Harpi
-- Create date: 8 January 2023
-- Description:	Store Procedure for updating Bank
-- =============================================
CREATE PROCEDURE [Payment].[spUpdateBank] 
	-- Add the parameters for the stored procedure here
	@id int,
	@code nvarchar(10),
	@name nvarchar(55)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
		UPDATE [Payment].[bank] 
			 SET [bank_code] = @code,
					 [bank_name] = @name,
					 [bank_modified_date] = GETDATE()
		 WHERE [bank_entity_id] = @id
END

GO
/****** Object:  StoredProcedure [Payment].[spUpdatePaymentGateway]    Script Date: 13/11/2023 17:39:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Harpi
-- Create date: 8 January 2023
-- Description:	Store Procedure for updating PaymentGateway
-- =============================================
CREATE PROCEDURE [Payment].[spUpdatePaymentGateway]
	-- Add the parameters for the stored procedure here
	@id int,
	@code nvarchar(10),
	@name nvarchar(55)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- Insert statements for procedure here
		UPDATE [Payment].[payment_gateway] 
			 SET [paga_code] = @code,
					 [paga_name] = @name,
					 [paga_modified_date] = GETDATE()
		 WHERE [paga_entity_id] = @id
END

GO
/****** Object:  StoredProcedure [Payment].[spUpdatePaymentTransaction]    Script Date: 13/11/2023 17:39:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Harpi
-- Create date: 9 Januari 2023
-- Description:	Stored procedure for updating payment_transaction (UNUSED)
-- =============================================
CREATE PROCEDURE [Payment].[spUpdatePaymentTransaction]
	-- Add the parameters for the stored procedure here
	@id int
	,@trx_number nvarchar(55)
	,@debet money
	,@credit money
	,@type nchar(3)
	,@note nvarchar(255)
	,@order_number nvarchar(55)
	,@source_id int
	,@target_id int
	,@trx_number_ref nvarchar(55)
	,@user_id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
		UPDATE [Payment].[payment_transaction]
		 SET [patr_trx_number] = @trx_number
				,[patr_debet] = @debet
				,[patr_credit] = @credit
				,[patr_type] = @type
				,[patr_note] = @note
				,[patr_modified_date] = GETDATE()
				,[patr_order_number] = @order_number
				,[patr_source_id] = @source_id
				,[patr_target_id] = @target_id
				,[patr_trx_number_ref] = @trx_number_ref
				,[patr_user_id] = @user_id
	 WHERE [patr_id] = @id
END

GO
/****** Object:  StoredProcedure [Payment].[spUpdateUserAccount]    Script Date: 13/11/2023 17:39:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Harpi
-- Create date: 09 January 2023
-- Description:	Stored Procedure for update UserAccount
-- =============================================
CREATE PROCEDURE [Payment].[spUpdateUserAccount] 
	-- Add the parameters for the stored procedure here
	@find_entity_id As int,
	@find_user_id As int
	-- Parameters for update UserAccount
	,@set_entity_id As int
	,@set_user_id As int
	,@account_number As varchar(25)
	,@saldo As money
	,@type As nvarchar(15)
	,@expmonth As tinyint
	,@expyear As smallint
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
		
		DECLARE @modified As datetime
		SET @modified = GETDATE()
	-- Insert statements for procedure here
		UPDATE [Payment].[user_accounts]
			 SET [usac_entity_id] = @set_entity_id
					,[usac_user_id] = @set_user_id
					,[usac_account_number] = @account_number
					,[usac_saldo] = @saldo
					,[usac_type] = @type
					,[usac_expmonth] = @expmonth
					,[usac_expyear] = @expyear
					,[usac_modified_date] = @modified
		 WHERE usac_entity_id = @find_entity_id AND usac_user_id = @find_user_id
END

GO
/****** Object:  StoredProcedure [Purchasing].[GenerateBarcode]    Script Date: 13/11/2023 17:39:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Muh Fadel marzuki
-- Create date: 3 March 2023
-- Description:	Store Procedure Generate Barcode
-- =============================================
create    procedure [Purchasing].[GenerateBarcode]
(
-- Add the parameters for the stored procedure here
	@PodeId int,
	@PodeQyt int,
	@PodeReceivedQty int,
	@PodeRejectQty int
) as
	declare @i int = 1;
	declare @stockID int;
	declare @poheStatus int;
	declare @OldpodeReceivedQty decimal;
begin
	-- Declare status Purchasing.purchase_order_header and declare Purchasing.purchase_order_detail
	select @poheStatus=po.pohe_status, @OldpodeReceivedQty=FLOOR(pd.pode_received_qty) from Purchasing.purchase_order_detail pd 
	inner join Purchasing.purchase_order_header po on pd.pode_pohe_id=po.pohe_id
	where pd.pode_id = @PodeId
	begin try
		begin transaction
		-- Generate must check this all condition
		IF @PodeReceivedQty > 0 and @poheStatus = 4 
			and @PodeReceivedQty > @OldpodeReceivedQty 
			and @PodeQyt > @PodeReceivedQty
			and (@PodeReceivedQty + @PodeRejectQty) = @PodeQyt
		Begin
		-- loop insert statement procedure Here
			While @i <= @PodeReceivedQty
			Begin
				INSERT INTO purchasing.stock_detail (stod_stock_id, stod_barcode_number,
				 stod_pohe_id) select pode_stock_id, 
				CONCAT('BC' ,  substring(replace(convert(nvarchar(100), NEWID()), '-', ''), 1, 10) ),
				pode_pohe_id from Purchasing.purchase_order_detail where pode_id = @PodeId;
				set @i = @i +1;
			End
			begin
				-- declare stock id
				select @stockID=pode_stock_id from Purchasing.purchase_order_detail where pode_id = @PodeId;

				-- update after insert statement
				update Purchasing.stocks
					set 
						stock_quantity = (select count(stod_id) 
							from Purchasing.stock_detail where stod_stock_id =@stockID),
						stock_used = (select count(case when stod_status = N'2' then 1 else null end) 
							from Purchasing.stock_detail where stod_stock_id =@stockID),
						stock_scrap = (select count(case when stod_status = N'3' then 1 else null end) 
							from Purchasing.stock_detail where stod_stock_id =@stockID)
					where stock_id = @stockID;
			end
		End
		Print 'Generate Barcode successfully';
		commit transaction
	end try
	begin catch
		rollback;
		print 'Generate Barcode Is Failed';
		throw;
	end catch 
end

GO
/****** Object:  StoredProcedure [Purchasing].[spDeleteVendor]    Script Date: 13/11/2023 17:39:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Hafiz
-- Create date: 14 March 2023
-- Description:	Creata Store Procedure Delete Vendor by Id
-- =============================================
Create Procedure [Purchasing].[spDeleteVendor]
	@id int
	AS
	BEGIN
	SET NOCOUNT ON;

	BEGIN TRANSACTION;
		BEGIN TRY
			Delete From [Purchasing].[vendor]
			WHERE vendor_entity_id = @id;
		COMMIT TRANSACTION; -- commit transaction jika tidak ada error
    END TRY

    BEGIN CATCH
        ROLLBACK TRANSACTION; -- rollback transaction jika terjadi error
        THROW;
    END CATCH

END

GO
/****** Object:  StoredProcedure [Purchasing].[spFindById]    Script Date: 13/11/2023 17:39:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Hafiz
-- Create date: 14 March 2023
-- Description:	Creata Store Procedure Find Vendor by Id
-- =============================================
Create Procedure [Purchasing].[spFindById]
	@id int
	AS
	BEGIN
	SET NOCOUNT ON;

	BEGIN TRANSACTION;
	-- memulai transaction
	BEGIN TRY
		SELECT
			vendor_entity_id AS VendorEntityId,
			vendor_name AS VendorName,
			vendor_active AS VendorActive,
			vendor_priority AS VendorPriority,
			vendor_register_date AS VendorRegisterDate,
			vendor_weburl AS VendorWeburl,
			vendor_modified_date AS VendorModifiedDate
		From [Purchasing].[vendor]
		WHERE vendor_entity_id = @id;
    COMMIT TRANSACTION; -- commit transaction jika tidak ada error
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION; -- rollback transaction jika terjadi error
        THROW;
    END CATCH
END

GO
/****** Object:  StoredProcedure [Purchasing].[spUpdateStockDetail]    Script Date: 13/11/2023 17:39:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Muh Fadel marzuki
-- Create date: 3 March 2023
-- Description:	Store Procedure Update Stock Detail
-- =============================================
create   procedure [Purchasing].[spUpdateStockDetail]
(
	-- Add the parameters for the stored procedure here
	@stodId int,
	@stodStockId int, 
	@stodStatus nchar,
	@stodNotes text,
	@stodFaciId int
) as
	declare @updateStatus int;
	declare @stockID int;
begin
	begin try
		begin transaction
			-- updates statement 1 for procedure here
			begin
				UPDATE purchasing.stock_detail SET 
				stod_stock_id=@stodStockId, stod_status=@stodStatus,
				stod_notes=@stodNotes, stod_faci_id=@stodFaciId
				WHERE stod_id=@stodId;
			end

			begin
				select @stockID=stod_stock_id from Purchasing.stock_detail where stod_id = @stodId;
				-- updates statement 2 for procedure here
				update Purchasing.stocks
					set 
						stock_quantity = (select count(stod_id) 
							from Purchasing.stock_detail where stod_stock_id =@stockID),
						stock_used = (select count(case when stod_status = N'2' then 1 else null end) 
							from Purchasing.stock_detail where stod_stock_id =@stockID),
						stock_scrap = (select count(case when stod_status = N'3' then 1 else null end) 
							from Purchasing.stock_detail where stod_stock_id =@stockID)
				where stock_id = @stockID;
			end
			Print 'Update status for stod_id = '+ cast(@stodId as nvarchar(25))+' successfully';
		commit transaction
	end try
	begin catch
		rollback;
		print 'Transaction Rollback for stod_id = ' + cast(@stodId as nvarchar(25));
		throw;
	end catch 
end;

GO
/****** Object:  StoredProcedure [Resto].[create_order_menu_detail]    Script Date: 13/11/2023 17:39:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Hendri Praminiarto
-- Create date: 11 March 2023
-- Description:	Store Procedure Resto Menus
-- =============================================

CREATE PROCEDURE [Resto].[create_order_menu_detail]
	@omde_reme_id INT,
	@orme_price MONEY,
	@orme_qty SMALLINT,
	@orme_discount SMALLMONEY,
	@orme_pay_type NCHAR(2),
	@orme_cardnumber NVARCHAR(25),
	@orme_is_paid NCHAR(2),
	@orme_user_id INT,
	@orme_status NVARCHAR(20)
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
    BEGIN TRANSACTION;

    -- Check if user_id exists and order status is Open
    IF EXISTS (SELECT 1
		FROM Users.users
		WHERE user_id = @orme_user_id) AND @orme_status = 'Open'
    BEGIN
		DECLARE @orme_id INT;

		-- Get orme_id for reference in omde_orme_id
		SELECT @orme_id = orme_id
		FROM Resto.order_menus
		WHERE orme_user_id = @orme_user_id AND orme_status = 'Open';

		-- Check if omde_reme_id exists in order_menu_detail
		IF EXISTS (SELECT 1
		FROM Resto.order_menu_detail
		WHERE omde_orme_id = @orme_id AND omde_reme_id = @omde_reme_id)
      BEGIN
			-- Update orme_qty if omde_reme_id exists
			UPDATE Resto.order_menu_detail
        SET orme_qty = orme_qty + @orme_qty
        WHERE omde_orme_id = @orme_id AND omde_reme_id = @omde_reme_id;
		END
      ELSE
      BEGIN
			-- Insert new detail if omde_reme_id doesn't exist
			INSERT INTO Resto.order_menu_detail
				(orme_price, orme_qty, orme_discount, omde_orme_id, omde_reme_id)
			VALUES
				(@orme_price, @orme_qty, @orme_discount, @orme_id, @omde_reme_id);
		END
	END
    ELSE
    BEGIN
		DECLARE @orme_order_number NVARCHAR(55), @orme_id_2 INT;

		-- Generate order number
		SELECT @orme_order_number = CONCAT('Menus#', CONVERT(NVARCHAR(10), GETDATE(), 112), '-',
                                          RIGHT('0000' + CAST((SELECT COUNT(*)
			FROM Resto.order_menus) + 1 AS NVARCHAR(4)), 4));

		-- Insert new order_menu record
		INSERT INTO Resto.order_menus
			(orme_order_number, orme_order_date, orme_pay_type, orme_cardnumber,orme_is_paid, orme_user_id, orme_status, orme_invoice)
		VALUES
			(@orme_order_number, GETDATE(), @orme_pay_type, @orme_cardnumber, @orme_is_paid, @orme_user_id, @orme_status,
				CASE WHEN @orme_status = 'ordered' THEN CONCAT('INV-', @orme_order_number, '-001') ELSE NULL END);

		-- Get orme_id for reference in omde_orme_id
		SELECT @orme_id = SCOPE_IDENTITY();

		-- Insert new detail record
		INSERT INTO Resto.order_menu_detail
			(orme_price, orme_qty, orme_discount, omde_orme_id, omde_reme_id)
		VALUES
			(@orme_price, @orme_qty, @orme_discount, @orme_id, @omde_reme_id);
	END


    COMMIT TRANSACTION;
  END TRY
  BEGIN CATCH
    ROLLBACK TRANSACTION;
    THROW;
  END CATCH
END

GO
/****** Object:  StoredProcedure [Resto].[GetOrderMenusWithDetailsById]    Script Date: 13/11/2023 17:39:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Hendri Praminiarto
-- Create date: 11 March 2023
-- Description:	Store Procedure Resto Menus
-- =============================================

CREATE PROCEDURE [Resto].[GetOrderMenusWithDetailsById]
	@orme_id INT
AS
BEGIN
	SET NOCOUNT ON;
	SET XACT_ABORT ON;

	SELECT Resto.order_menus.orme_id, Resto.order_menus.orme_order_number,
		Resto.order_menus.orme_total_amount, Resto.order_menus.orme_total_discount,
		Resto.order_menu_detail.omde_id, Resto.order_menu_detail.orme_price,
		Resto.order_menu_detail.orme_qty, Resto.order_menu_detail.orme_subtotal,
		Resto.order_menu_detail.orme_discount, Resto.order_menu_detail.omde_orme_id,
		Resto.order_menu_detail.omde_reme_id, Resto.resto_menus.reme_name
	FROM Resto.order_menus
		JOIN Resto.order_menu_detail ON Resto.order_menus.orme_id = Resto.order_menu_detail.omde_orme_id
		JOIN Resto.resto_menus ON Resto.order_menu_detail.omde_reme_id = Resto.resto_menus.reme_id
	WHERE Resto.order_menus.orme_id = @orme_id OR @orme_id IS NULL;
END

GO
/****** Object:  StoredProcedure [Resto].[SpUpdateRestoMenus]    Script Date: 13/11/2023 17:39:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Hendri Praminiarto
-- Create date: 11 March 2023
-- Description:	Store Procedure Resto Menus
-- =============================================

CREATE PROCEDURE [Resto].[SpUpdateRestoMenus]
	@reme_id int,
	@reme_name varchar(50),
	@reme_desc varchar(100),
	@reme_price decimal(10,2),
	@reme_status bit,
	@reme_mod datetime
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRANSACTION;
	-- memulai transaction

	BEGIN TRY
        UPDATE Resto.resto_menus
        SET reme_name = @reme_name,
            reme_description = @reme_desc,
            reme_price = @reme_price,
            reme_status = @reme_status,
            reme_modified_date = @reme_mod
        WHERE reme_id = @reme_id;

        COMMIT TRANSACTION; -- commit transaction jika tidak ada error
    END TRY

    BEGIN CATCH
        ROLLBACK TRANSACTION; -- rollback transaction jika terjadi error
        THROW;
    END CATCH
END

GO
USE [master]
GO
ALTER DATABASE [Hotel_Realta] SET  READ_WRITE 
GO
