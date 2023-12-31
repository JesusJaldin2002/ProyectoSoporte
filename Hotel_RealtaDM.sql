USE [master]
GO
/****** Object:  Database [Hotel_RealtaDM]    Script Date: 13/11/2023 17:41:20 ******/
CREATE DATABASE [Hotel_RealtaDM]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Hotel_RealtaDM', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\Hotel_RealtaDM.mdf' , SIZE = 73728KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'Hotel_RealtaDM_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\Hotel_RealtaDM_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [Hotel_RealtaDM] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Hotel_RealtaDM].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [Hotel_RealtaDM] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [Hotel_RealtaDM] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [Hotel_RealtaDM] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [Hotel_RealtaDM] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [Hotel_RealtaDM] SET ARITHABORT OFF 
GO
ALTER DATABASE [Hotel_RealtaDM] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [Hotel_RealtaDM] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [Hotel_RealtaDM] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [Hotel_RealtaDM] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [Hotel_RealtaDM] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [Hotel_RealtaDM] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [Hotel_RealtaDM] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [Hotel_RealtaDM] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [Hotel_RealtaDM] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [Hotel_RealtaDM] SET  ENABLE_BROKER 
GO
ALTER DATABASE [Hotel_RealtaDM] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [Hotel_RealtaDM] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [Hotel_RealtaDM] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [Hotel_RealtaDM] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [Hotel_RealtaDM] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [Hotel_RealtaDM] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [Hotel_RealtaDM] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [Hotel_RealtaDM] SET RECOVERY FULL 
GO
ALTER DATABASE [Hotel_RealtaDM] SET  MULTI_USER 
GO
ALTER DATABASE [Hotel_RealtaDM] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [Hotel_RealtaDM] SET DB_CHAINING OFF 
GO
ALTER DATABASE [Hotel_RealtaDM] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [Hotel_RealtaDM] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [Hotel_RealtaDM] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [Hotel_RealtaDM] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'Hotel_RealtaDM', N'ON'
GO
ALTER DATABASE [Hotel_RealtaDM] SET QUERY_STORE = ON
GO
ALTER DATABASE [Hotel_RealtaDM] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [Hotel_RealtaDM]
GO
/****** Object:  Table [dbo].[Dim_Hotel]    Script Date: 13/11/2023 17:41:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Dim_Hotel](
	[idHotel] [int] NOT NULL,
	[hotel_name] [nvarchar](85) NULL,
	[hotel_addr_description] [nvarchar](500) NULL,
PRIMARY KEY CLUSTERED 
(
	[idHotel] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Dim_Huesped]    Script Date: 13/11/2023 17:41:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Dim_Huesped](
	[idHuesped] [int] NOT NULL,
	[fechanacimiento] [date] NULL,
	[edad] [int] NULL,
	[nacionalidad] [nvarchar](20) NULL,
	[genero] [nvarchar](1) NULL,
	[tipo] [nvarchar](15) NULL,
	[trabajo] [nvarchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[idHuesped] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Dim_Temporada]    Script Date: 13/11/2023 17:41:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Dim_Temporada](
	[idTemporada] [int] NOT NULL,
	[nameTemporada] [varchar](100) NULL,
	[trimestre] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[idTemporada] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Dim_Tiempo]    Script Date: 13/11/2023 17:41:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Dim_Tiempo](
	[idTiempo] [int] NOT NULL,
	[mes] [varchar](10) NULL,
	[trimestre] [int] NULL,
	[anio] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[idTiempo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Dim_Tiempo2]    Script Date: 13/11/2023 17:41:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Dim_Tiempo2](
	[idTiempo] [int] NOT NULL,
	[mes] [varchar](10) NULL,
	[trimestre] [int] NULL,
	[anio] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[idTiempo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Dim_Tiempo3]    Script Date: 13/11/2023 17:41:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Dim_Tiempo3](
	[idTiempo] [int] NOT NULL,
	[mes] [varchar](10) NULL,
	[trimestre] [int] NULL,
	[anio] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[idTiempo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Dim_TipoHabitacion]    Script Date: 13/11/2023 17:41:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Dim_TipoHabitacion](
	[idTipoHabitacion] [int] NOT NULL,
	[tipoHabitacion] [nvarchar](255) NULL,
PRIMARY KEY CLUSTERED 
(
	[idTipoHabitacion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Dim_TipoServicio]    Script Date: 13/11/2023 17:41:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Dim_TipoServicio](
	[idServicio] [int] NOT NULL,
	[nameServicio] [nvarchar](85) NULL,
PRIMARY KEY CLUSTERED 
(
	[idServicio] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Fact_Habitacion]    Script Date: 13/11/2023 17:41:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Fact_Habitacion](
	[idTiempo] [int] NULL,
	[idTipoHabitacion] [int] NULL,
	[Estadia] [int] NULL,
	[cantDemanda] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Fact_Huesped]    Script Date: 13/11/2023 17:41:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Fact_Huesped](
	[idTiempo] [int] NULL,
	[idTipoHabitacion] [int] NULL,
	[idHotel] [int] NULL,
	[cantidadDias] [int] NULL,
	[cantidadHuespedes] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Fact_Ingresos]    Script Date: 13/11/2023 17:41:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Fact_Ingresos](
	[idHotel] [int] NULL,
	[idTiempo] [int] NULL,
	[idHuesped] [int] NULL,
	[cantGenerada] [smallmoney] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Fact_Reservas]    Script Date: 13/11/2023 17:41:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Fact_Reservas](
	[idHotel] [int] NULL,
	[idTiempo] [int] NULL,
	[idHuesped] [int] NULL,
	[idTipoHabitacion] [int] NULL,
	[ingreReservas] [smallmoney] NULL,
	[promReservas] [smallmoney] NULL,
	[cantReservas] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Fact_Servicios]    Script Date: 13/11/2023 17:41:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Fact_Servicios](
	[idTiempo] [int] NULL,
	[idHuesped] [int] NULL,
	[idServicio] [int] NULL,
	[idHotel] [int] NULL,
	[cantConsumo] [int] NULL,
	[Ingresos] [money] NULL
) ON [PRIMARY]
GO
INSERT [dbo].[Dim_Hotel] ([idHotel], [hotel_name], [hotel_addr_description]) VALUES (1, N'Grand Hyatt Jakarta', N'Jl. M. H. Thamrin No.30, Jakarta Pusat')
INSERT [dbo].[Dim_Hotel] ([idHotel], [hotel_name], [hotel_addr_description]) VALUES (2, N'Aston Priority Simatupang Hotel & Conference Center', N'Jl. Let. Jend. T.B. Simatupang Kav. 9 Kebagusan Pasar Minggu, Jakarta Selatan')
INSERT [dbo].[Dim_Hotel] ([idHotel], [hotel_name], [hotel_addr_description]) VALUES (3, N'The Trans Luxury Hotel Bandung', N'Jl. Gatot Subroto No. 289, Bandung, Jawa Barat')
INSERT [dbo].[Dim_Hotel] ([idHotel], [hotel_name], [hotel_addr_description]) VALUES (4, N'Padma Resort Ubud', N'Banjar Carik, Desa Puhu, Payangan, Gianyar, Bali')
INSERT [dbo].[Dim_Hotel] ([idHotel], [hotel_name], [hotel_addr_description]) VALUES (5, N'Four Seasons Resort Bali at Sayan', N'Sayan, Ubud, Bali')
INSERT [dbo].[Dim_Hotel] ([idHotel], [hotel_name], [hotel_addr_description]) VALUES (6, N'The Stones - Legian, Bali', N'Jl. Raya Pantai Kuta, Banjar Legian Kelod, Legian, Bali')
INSERT [dbo].[Dim_Hotel] ([idHotel], [hotel_name], [hotel_addr_description]) VALUES (7, N'Aryaduta Makassar', N'Jl. Somba Opu No. 297, Makassar, Sulawesi Selatan')
INSERT [dbo].[Dim_Hotel] ([idHotel], [hotel_name], [hotel_addr_description]) VALUES (8, N'Hotel Tugu Malang', N'Jl. Tugu No. 3, Klojen, Malang')
INSERT [dbo].[Dim_Hotel] ([idHotel], [hotel_name], [hotel_addr_description]) VALUES (9, N'The Shalimar Boutique Hotel', N'Jalan Salak No. 38-42, Oro Oro Dowo, Klojen, Malang')
INSERT [dbo].[Dim_Hotel] ([idHotel], [hotel_name], [hotel_addr_description]) VALUES (10, N'Hotel Santika Premiere Malang', N'Jl. Letjen S. Parman No. 60, Malang')
INSERT [dbo].[Dim_Hotel] ([idHotel], [hotel_name], [hotel_addr_description]) VALUES (11, N'Ijen Suites Resort & Convention', N'Jalan Raya Kahuripan No. 16, Tlogomas, Malang')
INSERT [dbo].[Dim_Hotel] ([idHotel], [hotel_name], [hotel_addr_description]) VALUES (12, N'Atria Hotel Malang', N'Jl. Letjen Sutoyo No.79, Klojen, Malang')
INSERT [dbo].[Dim_Hotel] ([idHotel], [hotel_name], [hotel_addr_description]) VALUES (13, N'Jambuluwuk Batu Resort', N'Jl. Trunojoyo No.99, Oro Oro Ombo, Batu, Malang')
INSERT [dbo].[Dim_Hotel] ([idHotel], [hotel_name], [hotel_addr_description]) VALUES (14, N'Aria Gajayana Hotel', N'Jl. Hayam Wuruk No. 5, Klojen, Malang')
INSERT [dbo].[Dim_Hotel] ([idHotel], [hotel_name], [hotel_addr_description]) VALUES (15, N'The Batu Hotel & Villas', N'Jalan Raya Selecta No.1')
INSERT [dbo].[Dim_Hotel] ([idHotel], [hotel_name], [hotel_addr_description]) VALUES (16, N'The Batu Hotel Hola', N'Jalan Raya Selecta No.1')
INSERT [dbo].[Dim_Hotel] ([idHotel], [hotel_name], [hotel_addr_description]) VALUES (17, N'TApple PenHouse', N'Jalan Raya Selecta No.1')
GO
INSERT [dbo].[Dim_Huesped] ([idHuesped], [fechanacimiento], [edad], [nacionalidad], [genero], [tipo], [trabajo]) VALUES (1, CAST(N'1980-01-01' AS Date), 43, N'123-45-6789', N'M', N'T', N'Manager')
INSERT [dbo].[Dim_Huesped] ([idHuesped], [fechanacimiento], [edad], [nacionalidad], [genero], [tipo], [trabajo]) VALUES (2, CAST(N'1985-02-02' AS Date), 38, N'234-56-7890', N'F', N'C', N'Developer')
INSERT [dbo].[Dim_Huesped] ([idHuesped], [fechanacimiento], [edad], [nacionalidad], [genero], [tipo], [trabajo]) VALUES (3, CAST(N'1990-03-03' AS Date), 33, N'345-67-8901', N'M', N'C', N'Designer')
INSERT [dbo].[Dim_Huesped] ([idHuesped], [fechanacimiento], [edad], [nacionalidad], [genero], [tipo], [trabajo]) VALUES (4, CAST(N'1995-04-04' AS Date), 28, N'456-78-9012', N'F', N'T', N'Tester')
INSERT [dbo].[Dim_Huesped] ([idHuesped], [fechanacimiento], [edad], [nacionalidad], [genero], [tipo], [trabajo]) VALUES (5, CAST(N'2000-05-05' AS Date), 23, N'567-89-0123', N'M', N'C', N'Analyst')
INSERT [dbo].[Dim_Huesped] ([idHuesped], [fechanacimiento], [edad], [nacionalidad], [genero], [tipo], [trabajo]) VALUES (6, CAST(N'2005-06-06' AS Date), 18, N'678-90-1234', N'F', N'I', N'Consultant')
INSERT [dbo].[Dim_Huesped] ([idHuesped], [fechanacimiento], [edad], [nacionalidad], [genero], [tipo], [trabajo]) VALUES (7, CAST(N'2010-07-07' AS Date), 13, N'789-01-2345', N'M', N'T', N'Salesperson')
INSERT [dbo].[Dim_Huesped] ([idHuesped], [fechanacimiento], [edad], [nacionalidad], [genero], [tipo], [trabajo]) VALUES (8, CAST(N'2015-08-08' AS Date), 8, N'890-12-3456', N'F', N'C', N'HR Manager')
INSERT [dbo].[Dim_Huesped] ([idHuesped], [fechanacimiento], [edad], [nacionalidad], [genero], [tipo], [trabajo]) VALUES (9, CAST(N'2020-09-09' AS Date), 3, N'901-23-4567', N'M', N'I', N'Project Manager')
INSERT [dbo].[Dim_Huesped] ([idHuesped], [fechanacimiento], [edad], [nacionalidad], [genero], [tipo], [trabajo]) VALUES (10, CAST(N'2025-10-10' AS Date), -2, N'012-34-5678', N'F', N'I', N'Marketing Manager')
INSERT [dbo].[Dim_Huesped] ([idHuesped], [fechanacimiento], [edad], [nacionalidad], [genero], [tipo], [trabajo]) VALUES (11, CAST(N'1985-01-01' AS Date), 38, N'123-45-6789', N'M', N'T', N'Engineer')
INSERT [dbo].[Dim_Huesped] ([idHuesped], [fechanacimiento], [edad], [nacionalidad], [genero], [tipo], [trabajo]) VALUES (12, CAST(N'1990-01-01' AS Date), 33, N'234-56-7890', N'F', N'C', N'Designer')
INSERT [dbo].[Dim_Huesped] ([idHuesped], [fechanacimiento], [edad], [nacionalidad], [genero], [tipo], [trabajo]) VALUES (13, CAST(N'1995-01-01' AS Date), 28, N'345-67-8901', N'M', N'I', N'Journalist')
INSERT [dbo].[Dim_Huesped] ([idHuesped], [fechanacimiento], [edad], [nacionalidad], [genero], [tipo], [trabajo]) VALUES (14, CAST(N'1980-01-01' AS Date), 43, N'456-78-9012', N'F', N'C', N'Teacher')
INSERT [dbo].[Dim_Huesped] ([idHuesped], [fechanacimiento], [edad], [nacionalidad], [genero], [tipo], [trabajo]) VALUES (15, CAST(N'1985-01-01' AS Date), 38, N'567-89-0123', N'M', N'T', N'Writer')
INSERT [dbo].[Dim_Huesped] ([idHuesped], [fechanacimiento], [edad], [nacionalidad], [genero], [tipo], [trabajo]) VALUES (16, CAST(N'1995-11-11' AS Date), 28, N'678-90-1234', N'M', N'C', N'Software Engineer')
INSERT [dbo].[Dim_Huesped] ([idHuesped], [fechanacimiento], [edad], [nacionalidad], [genero], [tipo], [trabajo]) VALUES (17, CAST(N'2000-12-12' AS Date), 23, N'789-01-2345', N'F', N'T', N'Data Scientist')
INSERT [dbo].[Dim_Huesped] ([idHuesped], [fechanacimiento], [edad], [nacionalidad], [genero], [tipo], [trabajo]) VALUES (18, CAST(N'2005-02-13' AS Date), 18, N'890-12-3456', N'M', N'I', N'Financial Analyst')
INSERT [dbo].[Dim_Huesped] ([idHuesped], [fechanacimiento], [edad], [nacionalidad], [genero], [tipo], [trabajo]) VALUES (19, CAST(N'2010-03-14' AS Date), 13, N'901-23-4567', N'F', N'C', N'Marketing Specialist')
INSERT [dbo].[Dim_Huesped] ([idHuesped], [fechanacimiento], [edad], [nacionalidad], [genero], [tipo], [trabajo]) VALUES (20, CAST(N'2015-04-15' AS Date), 8, N'012-34-5678', N'M', N'I', N'Product Manager')
INSERT [dbo].[Dim_Huesped] ([idHuesped], [fechanacimiento], [edad], [nacionalidad], [genero], [tipo], [trabajo]) VALUES (21, CAST(N'1988-05-16' AS Date), 35, N'123-45-6789', N'M', N'T', N'Architect')
INSERT [dbo].[Dim_Huesped] ([idHuesped], [fechanacimiento], [edad], [nacionalidad], [genero], [tipo], [trabajo]) VALUES (22, CAST(N'1993-06-17' AS Date), 30, N'234-56-7890', N'F', N'C', N'UX/UI Designer')
INSERT [dbo].[Dim_Huesped] ([idHuesped], [fechanacimiento], [edad], [nacionalidad], [genero], [tipo], [trabajo]) VALUES (23, CAST(N'1998-07-18' AS Date), 25, N'345-67-8901', N'M', N'I', N'Journalist')
INSERT [dbo].[Dim_Huesped] ([idHuesped], [fechanacimiento], [edad], [nacionalidad], [genero], [tipo], [trabajo]) VALUES (24, CAST(N'2003-08-19' AS Date), 20, N'456-78-9012', N'F', N'T', N'Teacher')
INSERT [dbo].[Dim_Huesped] ([idHuesped], [fechanacimiento], [edad], [nacionalidad], [genero], [tipo], [trabajo]) VALUES (25, CAST(N'2008-09-20' AS Date), 15, N'567-89-0123', N'M', N'C', N'Writer')
GO
INSERT [dbo].[Dim_Tiempo] ([idTiempo], [mes], [trimestre], [anio]) VALUES (20230101, N'January', 1, 2023)
INSERT [dbo].[Dim_Tiempo] ([idTiempo], [mes], [trimestre], [anio]) VALUES (20230102, N'January', 1, 2023)
INSERT [dbo].[Dim_Tiempo] ([idTiempo], [mes], [trimestre], [anio]) VALUES (20230103, N'January', 1, 2023)
INSERT [dbo].[Dim_Tiempo] ([idTiempo], [mes], [trimestre], [anio]) VALUES (20230104, N'January', 1, 2023)
INSERT [dbo].[Dim_Tiempo] ([idTiempo], [mes], [trimestre], [anio]) VALUES (20230105, N'January', 1, 2023)
INSERT [dbo].[Dim_Tiempo] ([idTiempo], [mes], [trimestre], [anio]) VALUES (20230106, N'January', 1, 2023)
INSERT [dbo].[Dim_Tiempo] ([idTiempo], [mes], [trimestre], [anio]) VALUES (20230107, N'January', 1, 2023)
INSERT [dbo].[Dim_Tiempo] ([idTiempo], [mes], [trimestre], [anio]) VALUES (20230108, N'January', 1, 2023)
INSERT [dbo].[Dim_Tiempo] ([idTiempo], [mes], [trimestre], [anio]) VALUES (20230109, N'January', 1, 2023)
INSERT [dbo].[Dim_Tiempo] ([idTiempo], [mes], [trimestre], [anio]) VALUES (20230110, N'January', 1, 2023)
INSERT [dbo].[Dim_Tiempo] ([idTiempo], [mes], [trimestre], [anio]) VALUES (20230111, N'January', 1, 2023)
INSERT [dbo].[Dim_Tiempo] ([idTiempo], [mes], [trimestre], [anio]) VALUES (20230112, N'January', 1, 2023)
INSERT [dbo].[Dim_Tiempo] ([idTiempo], [mes], [trimestre], [anio]) VALUES (20230113, N'January', 1, 2023)
INSERT [dbo].[Dim_Tiempo] ([idTiempo], [mes], [trimestre], [anio]) VALUES (20230114, N'January', 1, 2023)
INSERT [dbo].[Dim_Tiempo] ([idTiempo], [mes], [trimestre], [anio]) VALUES (20230115, N'January', 1, 2023)
INSERT [dbo].[Dim_Tiempo] ([idTiempo], [mes], [trimestre], [anio]) VALUES (20230116, N'January', 1, 2023)
INSERT [dbo].[Dim_Tiempo] ([idTiempo], [mes], [trimestre], [anio]) VALUES (20230117, N'January', 1, 2023)
INSERT [dbo].[Dim_Tiempo] ([idTiempo], [mes], [trimestre], [anio]) VALUES (20230118, N'January', 1, 2023)
INSERT [dbo].[Dim_Tiempo] ([idTiempo], [mes], [trimestre], [anio]) VALUES (20230119, N'January', 1, 2023)
INSERT [dbo].[Dim_Tiempo] ([idTiempo], [mes], [trimestre], [anio]) VALUES (20230120, N'January', 1, 2023)
INSERT [dbo].[Dim_Tiempo] ([idTiempo], [mes], [trimestre], [anio]) VALUES (20230121, N'January', 1, 2023)
INSERT [dbo].[Dim_Tiempo] ([idTiempo], [mes], [trimestre], [anio]) VALUES (20230122, N'January', 1, 2023)
INSERT [dbo].[Dim_Tiempo] ([idTiempo], [mes], [trimestre], [anio]) VALUES (20230123, N'January', 1, 2023)
INSERT [dbo].[Dim_Tiempo] ([idTiempo], [mes], [trimestre], [anio]) VALUES (20230124, N'January', 1, 2023)
INSERT [dbo].[Dim_Tiempo] ([idTiempo], [mes], [trimestre], [anio]) VALUES (20230125, N'January', 1, 2023)
INSERT [dbo].[Dim_Tiempo] ([idTiempo], [mes], [trimestre], [anio]) VALUES (20230126, N'January', 1, 2023)
INSERT [dbo].[Dim_Tiempo] ([idTiempo], [mes], [trimestre], [anio]) VALUES (20230127, N'January', 1, 2023)
INSERT [dbo].[Dim_Tiempo] ([idTiempo], [mes], [trimestre], [anio]) VALUES (20230128, N'January', 1, 2023)
INSERT [dbo].[Dim_Tiempo] ([idTiempo], [mes], [trimestre], [anio]) VALUES (20230129, N'January', 1, 2023)
INSERT [dbo].[Dim_Tiempo] ([idTiempo], [mes], [trimestre], [anio]) VALUES (20230130, N'January', 1, 2023)
INSERT [dbo].[Dim_Tiempo] ([idTiempo], [mes], [trimestre], [anio]) VALUES (20230131, N'January', 1, 2023)
INSERT [dbo].[Dim_Tiempo] ([idTiempo], [mes], [trimestre], [anio]) VALUES (20230201, N'February', 1, 2023)
INSERT [dbo].[Dim_Tiempo] ([idTiempo], [mes], [trimestre], [anio]) VALUES (20230202, N'February', 1, 2023)
INSERT [dbo].[Dim_Tiempo] ([idTiempo], [mes], [trimestre], [anio]) VALUES (20230203, N'February', 1, 2023)
INSERT [dbo].[Dim_Tiempo] ([idTiempo], [mes], [trimestre], [anio]) VALUES (20230204, N'February', 1, 2023)
INSERT [dbo].[Dim_Tiempo] ([idTiempo], [mes], [trimestre], [anio]) VALUES (20230205, N'February', 1, 2023)
INSERT [dbo].[Dim_Tiempo] ([idTiempo], [mes], [trimestre], [anio]) VALUES (20230206, N'February', 1, 2023)
INSERT [dbo].[Dim_Tiempo] ([idTiempo], [mes], [trimestre], [anio]) VALUES (20230207, N'February', 1, 2023)
INSERT [dbo].[Dim_Tiempo] ([idTiempo], [mes], [trimestre], [anio]) VALUES (20230208, N'February', 1, 2023)
INSERT [dbo].[Dim_Tiempo] ([idTiempo], [mes], [trimestre], [anio]) VALUES (20230209, N'February', 1, 2023)
INSERT [dbo].[Dim_Tiempo] ([idTiempo], [mes], [trimestre], [anio]) VALUES (20230210, N'February', 1, 2023)
INSERT [dbo].[Dim_Tiempo] ([idTiempo], [mes], [trimestre], [anio]) VALUES (20230211, N'February', 1, 2023)
INSERT [dbo].[Dim_Tiempo] ([idTiempo], [mes], [trimestre], [anio]) VALUES (20230212, N'February', 1, 2023)
INSERT [dbo].[Dim_Tiempo] ([idTiempo], [mes], [trimestre], [anio]) VALUES (20230213, N'February', 1, 2023)
INSERT [dbo].[Dim_Tiempo] ([idTiempo], [mes], [trimestre], [anio]) VALUES (20230214, N'February', 1, 2023)
INSERT [dbo].[Dim_Tiempo] ([idTiempo], [mes], [trimestre], [anio]) VALUES (20230215, N'February', 1, 2023)
INSERT [dbo].[Dim_Tiempo] ([idTiempo], [mes], [trimestre], [anio]) VALUES (20230216, N'February', 1, 2023)
INSERT [dbo].[Dim_Tiempo] ([idTiempo], [mes], [trimestre], [anio]) VALUES (20230217, N'February', 1, 2023)
INSERT [dbo].[Dim_Tiempo] ([idTiempo], [mes], [trimestre], [anio]) VALUES (20230218, N'February', 1, 2023)
INSERT [dbo].[Dim_Tiempo] ([idTiempo], [mes], [trimestre], [anio]) VALUES (20230219, N'February', 1, 2023)
INSERT [dbo].[Dim_Tiempo] ([idTiempo], [mes], [trimestre], [anio]) VALUES (20230220, N'February', 1, 2023)
INSERT [dbo].[Dim_Tiempo] ([idTiempo], [mes], [trimestre], [anio]) VALUES (20230221, N'February', 1, 2023)
INSERT [dbo].[Dim_Tiempo] ([idTiempo], [mes], [trimestre], [anio]) VALUES (20230222, N'February', 1, 2023)
INSERT [dbo].[Dim_Tiempo] ([idTiempo], [mes], [trimestre], [anio]) VALUES (20230223, N'February', 1, 2023)
INSERT [dbo].[Dim_Tiempo] ([idTiempo], [mes], [trimestre], [anio]) VALUES (20230224, N'February', 1, 2023)
INSERT [dbo].[Dim_Tiempo] ([idTiempo], [mes], [trimestre], [anio]) VALUES (20230225, N'February', 1, 2023)
INSERT [dbo].[Dim_Tiempo] ([idTiempo], [mes], [trimestre], [anio]) VALUES (20230226, N'February', 1, 2023)
INSERT [dbo].[Dim_Tiempo] ([idTiempo], [mes], [trimestre], [anio]) VALUES (20230227, N'February', 1, 2023)
INSERT [dbo].[Dim_Tiempo] ([idTiempo], [mes], [trimestre], [anio]) VALUES (20230228, N'February', 1, 2023)
INSERT [dbo].[Dim_Tiempo] ([idTiempo], [mes], [trimestre], [anio]) VALUES (20230301, N'March', 1, 2023)
INSERT [dbo].[Dim_Tiempo] ([idTiempo], [mes], [trimestre], [anio]) VALUES (20230302, N'March', 1, 2023)
INSERT [dbo].[Dim_Tiempo] ([idTiempo], [mes], [trimestre], [anio]) VALUES (20230303, N'March', 1, 2023)
INSERT [dbo].[Dim_Tiempo] ([idTiempo], [mes], [trimestre], [anio]) VALUES (20230304, N'March', 1, 2023)
INSERT [dbo].[Dim_Tiempo] ([idTiempo], [mes], [trimestre], [anio]) VALUES (20230305, N'March', 1, 2023)
INSERT [dbo].[Dim_Tiempo] ([idTiempo], [mes], [trimestre], [anio]) VALUES (20230306, N'March', 1, 2023)
INSERT [dbo].[Dim_Tiempo] ([idTiempo], [mes], [trimestre], [anio]) VALUES (20230307, N'March', 1, 2023)
INSERT [dbo].[Dim_Tiempo] ([idTiempo], [mes], [trimestre], [anio]) VALUES (20230308, N'March', 1, 2023)
INSERT [dbo].[Dim_Tiempo] ([idTiempo], [mes], [trimestre], [anio]) VALUES (20230309, N'March', 1, 2023)
INSERT [dbo].[Dim_Tiempo] ([idTiempo], [mes], [trimestre], [anio]) VALUES (20230310, N'March', 1, 2023)
INSERT [dbo].[Dim_Tiempo] ([idTiempo], [mes], [trimestre], [anio]) VALUES (20230311, N'March', 1, 2023)
INSERT [dbo].[Dim_Tiempo] ([idTiempo], [mes], [trimestre], [anio]) VALUES (20230312, N'March', 1, 2023)
INSERT [dbo].[Dim_Tiempo] ([idTiempo], [mes], [trimestre], [anio]) VALUES (20230313, N'March', 1, 2023)
INSERT [dbo].[Dim_Tiempo] ([idTiempo], [mes], [trimestre], [anio]) VALUES (20230314, N'March', 1, 2023)
INSERT [dbo].[Dim_Tiempo] ([idTiempo], [mes], [trimestre], [anio]) VALUES (20230315, N'March', 1, 2023)
INSERT [dbo].[Dim_Tiempo] ([idTiempo], [mes], [trimestre], [anio]) VALUES (20230316, N'March', 1, 2023)
INSERT [dbo].[Dim_Tiempo] ([idTiempo], [mes], [trimestre], [anio]) VALUES (20230317, N'March', 1, 2023)
INSERT [dbo].[Dim_Tiempo] ([idTiempo], [mes], [trimestre], [anio]) VALUES (20230318, N'March', 1, 2023)
INSERT [dbo].[Dim_Tiempo] ([idTiempo], [mes], [trimestre], [anio]) VALUES (20230319, N'March', 1, 2023)
INSERT [dbo].[Dim_Tiempo] ([idTiempo], [mes], [trimestre], [anio]) VALUES (20230320, N'March', 1, 2023)
INSERT [dbo].[Dim_Tiempo] ([idTiempo], [mes], [trimestre], [anio]) VALUES (20230321, N'March', 1, 2023)
INSERT [dbo].[Dim_Tiempo] ([idTiempo], [mes], [trimestre], [anio]) VALUES (20230322, N'March', 1, 2023)
INSERT [dbo].[Dim_Tiempo] ([idTiempo], [mes], [trimestre], [anio]) VALUES (20230323, N'March', 1, 2023)
INSERT [dbo].[Dim_Tiempo] ([idTiempo], [mes], [trimestre], [anio]) VALUES (20230324, N'March', 1, 2023)
INSERT [dbo].[Dim_Tiempo] ([idTiempo], [mes], [trimestre], [anio]) VALUES (20230325, N'March', 1, 2023)
INSERT [dbo].[Dim_Tiempo] ([idTiempo], [mes], [trimestre], [anio]) VALUES (20230326, N'March', 1, 2023)
INSERT [dbo].[Dim_Tiempo] ([idTiempo], [mes], [trimestre], [anio]) VALUES (20230327, N'March', 1, 2023)
INSERT [dbo].[Dim_Tiempo] ([idTiempo], [mes], [trimestre], [anio]) VALUES (20230328, N'March', 1, 2023)
INSERT [dbo].[Dim_Tiempo] ([idTiempo], [mes], [trimestre], [anio]) VALUES (20230329, N'March', 1, 2023)
INSERT [dbo].[Dim_Tiempo] ([idTiempo], [mes], [trimestre], [anio]) VALUES (20230330, N'March', 1, 2023)
GO
INSERT [dbo].[Dim_Tiempo2] ([idTiempo], [mes], [trimestre], [anio]) VALUES (19950114, N'January', 1, 1995)
INSERT [dbo].[Dim_Tiempo2] ([idTiempo], [mes], [trimestre], [anio]) VALUES (19950115, N'January', 1, 1995)
INSERT [dbo].[Dim_Tiempo2] ([idTiempo], [mes], [trimestre], [anio]) VALUES (19950116, N'January', 1, 1995)
INSERT [dbo].[Dim_Tiempo2] ([idTiempo], [mes], [trimestre], [anio]) VALUES (19950117, N'January', 1, 1995)
INSERT [dbo].[Dim_Tiempo2] ([idTiempo], [mes], [trimestre], [anio]) VALUES (19950118, N'January', 1, 1995)
INSERT [dbo].[Dim_Tiempo2] ([idTiempo], [mes], [trimestre], [anio]) VALUES (19950119, N'January', 1, 1995)
INSERT [dbo].[Dim_Tiempo2] ([idTiempo], [mes], [trimestre], [anio]) VALUES (19950120, N'January', 1, 1995)
INSERT [dbo].[Dim_Tiempo2] ([idTiempo], [mes], [trimestre], [anio]) VALUES (19950121, N'January', 1, 1995)
INSERT [dbo].[Dim_Tiempo2] ([idTiempo], [mes], [trimestre], [anio]) VALUES (19950122, N'January', 1, 1995)
INSERT [dbo].[Dim_Tiempo2] ([idTiempo], [mes], [trimestre], [anio]) VALUES (19950123, N'January', 1, 1995)
INSERT [dbo].[Dim_Tiempo2] ([idTiempo], [mes], [trimestre], [anio]) VALUES (19950124, N'January', 1, 1995)
INSERT [dbo].[Dim_Tiempo2] ([idTiempo], [mes], [trimestre], [anio]) VALUES (19950125, N'January', 1, 1995)
INSERT [dbo].[Dim_Tiempo2] ([idTiempo], [mes], [trimestre], [anio]) VALUES (19950126, N'January', 1, 1995)
INSERT [dbo].[Dim_Tiempo2] ([idTiempo], [mes], [trimestre], [anio]) VALUES (19950127, N'January', 1, 1995)
INSERT [dbo].[Dim_Tiempo2] ([idTiempo], [mes], [trimestre], [anio]) VALUES (19950128, N'January', 1, 1995)
INSERT [dbo].[Dim_Tiempo2] ([idTiempo], [mes], [trimestre], [anio]) VALUES (19950129, N'January', 1, 1995)
INSERT [dbo].[Dim_Tiempo2] ([idTiempo], [mes], [trimestre], [anio]) VALUES (19950130, N'January', 1, 1995)
INSERT [dbo].[Dim_Tiempo2] ([idTiempo], [mes], [trimestre], [anio]) VALUES (19950131, N'January', 1, 1995)
INSERT [dbo].[Dim_Tiempo2] ([idTiempo], [mes], [trimestre], [anio]) VALUES (19950201, N'February', 1, 1995)
INSERT [dbo].[Dim_Tiempo2] ([idTiempo], [mes], [trimestre], [anio]) VALUES (19950202, N'February', 1, 1995)
INSERT [dbo].[Dim_Tiempo2] ([idTiempo], [mes], [trimestre], [anio]) VALUES (19950203, N'February', 1, 1995)
INSERT [dbo].[Dim_Tiempo2] ([idTiempo], [mes], [trimestre], [anio]) VALUES (19950204, N'February', 1, 1995)
INSERT [dbo].[Dim_Tiempo2] ([idTiempo], [mes], [trimestre], [anio]) VALUES (19950205, N'February', 1, 1995)
INSERT [dbo].[Dim_Tiempo2] ([idTiempo], [mes], [trimestre], [anio]) VALUES (19950206, N'February', 1, 1995)
INSERT [dbo].[Dim_Tiempo2] ([idTiempo], [mes], [trimestre], [anio]) VALUES (19950207, N'February', 1, 1995)
INSERT [dbo].[Dim_Tiempo2] ([idTiempo], [mes], [trimestre], [anio]) VALUES (19950208, N'February', 1, 1995)
INSERT [dbo].[Dim_Tiempo2] ([idTiempo], [mes], [trimestre], [anio]) VALUES (19950209, N'February', 1, 1995)
INSERT [dbo].[Dim_Tiempo2] ([idTiempo], [mes], [trimestre], [anio]) VALUES (19950210, N'February', 1, 1995)
INSERT [dbo].[Dim_Tiempo2] ([idTiempo], [mes], [trimestre], [anio]) VALUES (19950211, N'February', 1, 1995)
INSERT [dbo].[Dim_Tiempo2] ([idTiempo], [mes], [trimestre], [anio]) VALUES (19950212, N'February', 1, 1995)
INSERT [dbo].[Dim_Tiempo2] ([idTiempo], [mes], [trimestre], [anio]) VALUES (19950213, N'February', 1, 1995)
INSERT [dbo].[Dim_Tiempo2] ([idTiempo], [mes], [trimestre], [anio]) VALUES (19950214, N'February', 1, 1995)
INSERT [dbo].[Dim_Tiempo2] ([idTiempo], [mes], [trimestre], [anio]) VALUES (19950215, N'February', 1, 1995)
INSERT [dbo].[Dim_Tiempo2] ([idTiempo], [mes], [trimestre], [anio]) VALUES (19950216, N'February', 1, 1995)
INSERT [dbo].[Dim_Tiempo2] ([idTiempo], [mes], [trimestre], [anio]) VALUES (19950217, N'February', 1, 1995)
INSERT [dbo].[Dim_Tiempo2] ([idTiempo], [mes], [trimestre], [anio]) VALUES (19950218, N'February', 1, 1995)
INSERT [dbo].[Dim_Tiempo2] ([idTiempo], [mes], [trimestre], [anio]) VALUES (19950219, N'February', 1, 1995)
INSERT [dbo].[Dim_Tiempo2] ([idTiempo], [mes], [trimestre], [anio]) VALUES (19950220, N'February', 1, 1995)
INSERT [dbo].[Dim_Tiempo2] ([idTiempo], [mes], [trimestre], [anio]) VALUES (19950221, N'February', 1, 1995)
INSERT [dbo].[Dim_Tiempo2] ([idTiempo], [mes], [trimestre], [anio]) VALUES (19950222, N'February', 1, 1995)
INSERT [dbo].[Dim_Tiempo2] ([idTiempo], [mes], [trimestre], [anio]) VALUES (19950223, N'February', 1, 1995)
INSERT [dbo].[Dim_Tiempo2] ([idTiempo], [mes], [trimestre], [anio]) VALUES (19950224, N'February', 1, 1995)
INSERT [dbo].[Dim_Tiempo2] ([idTiempo], [mes], [trimestre], [anio]) VALUES (19950225, N'February', 1, 1995)
INSERT [dbo].[Dim_Tiempo2] ([idTiempo], [mes], [trimestre], [anio]) VALUES (19950226, N'February', 1, 1995)
INSERT [dbo].[Dim_Tiempo2] ([idTiempo], [mes], [trimestre], [anio]) VALUES (19950227, N'February', 1, 1995)
INSERT [dbo].[Dim_Tiempo2] ([idTiempo], [mes], [trimestre], [anio]) VALUES (19950228, N'February', 1, 1995)
INSERT [dbo].[Dim_Tiempo2] ([idTiempo], [mes], [trimestre], [anio]) VALUES (19950301, N'March', 1, 1995)
INSERT [dbo].[Dim_Tiempo2] ([idTiempo], [mes], [trimestre], [anio]) VALUES (19950302, N'March', 1, 1995)
INSERT [dbo].[Dim_Tiempo2] ([idTiempo], [mes], [trimestre], [anio]) VALUES (19950303, N'March', 1, 1995)
INSERT [dbo].[Dim_Tiempo2] ([idTiempo], [mes], [trimestre], [anio]) VALUES (19950304, N'March', 1, 1995)
INSERT [dbo].[Dim_Tiempo2] ([idTiempo], [mes], [trimestre], [anio]) VALUES (19950305, N'March', 1, 1995)
INSERT [dbo].[Dim_Tiempo2] ([idTiempo], [mes], [trimestre], [anio]) VALUES (19950306, N'March', 1, 1995)
INSERT [dbo].[Dim_Tiempo2] ([idTiempo], [mes], [trimestre], [anio]) VALUES (19950307, N'March', 1, 1995)
INSERT [dbo].[Dim_Tiempo2] ([idTiempo], [mes], [trimestre], [anio]) VALUES (19950308, N'March', 1, 1995)
INSERT [dbo].[Dim_Tiempo2] ([idTiempo], [mes], [trimestre], [anio]) VALUES (19950309, N'March', 1, 1995)
INSERT [dbo].[Dim_Tiempo2] ([idTiempo], [mes], [trimestre], [anio]) VALUES (19950310, N'March', 1, 1995)
INSERT [dbo].[Dim_Tiempo2] ([idTiempo], [mes], [trimestre], [anio]) VALUES (19950311, N'March', 1, 1995)
INSERT [dbo].[Dim_Tiempo2] ([idTiempo], [mes], [trimestre], [anio]) VALUES (19950312, N'March', 1, 1995)
INSERT [dbo].[Dim_Tiempo2] ([idTiempo], [mes], [trimestre], [anio]) VALUES (19950313, N'March', 1, 1995)
INSERT [dbo].[Dim_Tiempo2] ([idTiempo], [mes], [trimestre], [anio]) VALUES (19950314, N'March', 1, 1995)
GO
INSERT [dbo].[Dim_Tiempo3] ([idTiempo], [mes], [trimestre], [anio]) VALUES (20231113, N'November', 4, 2023)
INSERT [dbo].[Dim_Tiempo3] ([idTiempo], [mes], [trimestre], [anio]) VALUES (20231114, N'November', 4, 2023)
INSERT [dbo].[Dim_Tiempo3] ([idTiempo], [mes], [trimestre], [anio]) VALUES (20231115, N'November', 4, 2023)
INSERT [dbo].[Dim_Tiempo3] ([idTiempo], [mes], [trimestre], [anio]) VALUES (20231116, N'November', 4, 2023)
INSERT [dbo].[Dim_Tiempo3] ([idTiempo], [mes], [trimestre], [anio]) VALUES (20231117, N'November', 4, 2023)
INSERT [dbo].[Dim_Tiempo3] ([idTiempo], [mes], [trimestre], [anio]) VALUES (20231118, N'November', 4, 2023)
INSERT [dbo].[Dim_Tiempo3] ([idTiempo], [mes], [trimestre], [anio]) VALUES (20231119, N'November', 4, 2023)
INSERT [dbo].[Dim_Tiempo3] ([idTiempo], [mes], [trimestre], [anio]) VALUES (20231120, N'November', 4, 2023)
GO
INSERT [dbo].[Dim_TipoHabitacion] ([idTipoHabitacion], [tipoHabitacion]) VALUES (1, N'Single Room')
INSERT [dbo].[Dim_TipoHabitacion] ([idTipoHabitacion], [tipoHabitacion]) VALUES (2, N'Double Room')
INSERT [dbo].[Dim_TipoHabitacion] ([idTipoHabitacion], [tipoHabitacion]) VALUES (3, N'Twin Room')
INSERT [dbo].[Dim_TipoHabitacion] ([idTipoHabitacion], [tipoHabitacion]) VALUES (4, N'Deluxe Room')
INSERT [dbo].[Dim_TipoHabitacion] ([idTipoHabitacion], [tipoHabitacion]) VALUES (5, N'Restaurant')
INSERT [dbo].[Dim_TipoHabitacion] ([idTipoHabitacion], [tipoHabitacion]) VALUES (6, N'Meeting Room')
INSERT [dbo].[Dim_TipoHabitacion] ([idTipoHabitacion], [tipoHabitacion]) VALUES (7, N'Gym')
INSERT [dbo].[Dim_TipoHabitacion] ([idTipoHabitacion], [tipoHabitacion]) VALUES (8, N'Swimming Pool')
INSERT [dbo].[Dim_TipoHabitacion] ([idTipoHabitacion], [tipoHabitacion]) VALUES (9, N'Deluxe Room')
INSERT [dbo].[Dim_TipoHabitacion] ([idTipoHabitacion], [tipoHabitacion]) VALUES (10, N'Twin Room')
INSERT [dbo].[Dim_TipoHabitacion] ([idTipoHabitacion], [tipoHabitacion]) VALUES (11, N'Family Room')
INSERT [dbo].[Dim_TipoHabitacion] ([idTipoHabitacion], [tipoHabitacion]) VALUES (12, N'Standard Room')
INSERT [dbo].[Dim_TipoHabitacion] ([idTipoHabitacion], [tipoHabitacion]) VALUES (13, N'The Garden')
INSERT [dbo].[Dim_TipoHabitacion] ([idTipoHabitacion], [tipoHabitacion]) VALUES (14, N'The Spa')
INSERT [dbo].[Dim_TipoHabitacion] ([idTipoHabitacion], [tipoHabitacion]) VALUES (15, N'The Meeting Room')
INSERT [dbo].[Dim_TipoHabitacion] ([idTipoHabitacion], [tipoHabitacion]) VALUES (16, N'Deluxe Room')
INSERT [dbo].[Dim_TipoHabitacion] ([idTipoHabitacion], [tipoHabitacion]) VALUES (17, N'Superior Room')
INSERT [dbo].[Dim_TipoHabitacion] ([idTipoHabitacion], [tipoHabitacion]) VALUES (18, N'Pool Villa')
INSERT [dbo].[Dim_TipoHabitacion] ([idTipoHabitacion], [tipoHabitacion]) VALUES (19, N'Meeting Room 1')
INSERT [dbo].[Dim_TipoHabitacion] ([idTipoHabitacion], [tipoHabitacion]) VALUES (20, N'Gym')
INSERT [dbo].[Dim_TipoHabitacion] ([idTipoHabitacion], [tipoHabitacion]) VALUES (21, N'Sauna')
INSERT [dbo].[Dim_TipoHabitacion] ([idTipoHabitacion], [tipoHabitacion]) VALUES (22, N'Ballroom')
GO
INSERT [dbo].[Dim_TipoServicio] ([idServicio], [nameServicio]) VALUES (1, N'Receptionist')
INSERT [dbo].[Dim_TipoServicio] ([idServicio], [nameServicio]) VALUES (2, N'Housekeeping')
INSERT [dbo].[Dim_TipoServicio] ([idServicio], [nameServicio]) VALUES (3, N'Chef')
INSERT [dbo].[Dim_TipoServicio] ([idServicio], [nameServicio]) VALUES (4, N'Security')
INSERT [dbo].[Dim_TipoServicio] ([idServicio], [nameServicio]) VALUES (5, N'Manager')
GO
INSERT [dbo].[Fact_Habitacion] ([idTiempo], [idTipoHabitacion], [Estadia], [cantDemanda]) VALUES (20230127, 1, 1, 1)
INSERT [dbo].[Fact_Habitacion] ([idTiempo], [idTipoHabitacion], [Estadia], [cantDemanda]) VALUES (20230127, 2, 1, 2)
INSERT [dbo].[Fact_Habitacion] ([idTiempo], [idTipoHabitacion], [Estadia], [cantDemanda]) VALUES (20230127, 10, 1, 10)
INSERT [dbo].[Fact_Habitacion] ([idTiempo], [idTipoHabitacion], [Estadia], [cantDemanda]) VALUES (20230101, 1, 1, 1)
INSERT [dbo].[Fact_Habitacion] ([idTiempo], [idTipoHabitacion], [Estadia], [cantDemanda]) VALUES (20230115, 2, 2, 2)
INSERT [dbo].[Fact_Habitacion] ([idTiempo], [idTipoHabitacion], [Estadia], [cantDemanda]) VALUES (20230118, 2, 4, 2)
INSERT [dbo].[Fact_Habitacion] ([idTiempo], [idTipoHabitacion], [Estadia], [cantDemanda]) VALUES (20230201, 10, 3, 10)
INSERT [dbo].[Fact_Habitacion] ([idTiempo], [idTipoHabitacion], [Estadia], [cantDemanda]) VALUES (20230201, 10, 4, 10)
INSERT [dbo].[Fact_Habitacion] ([idTiempo], [idTipoHabitacion], [Estadia], [cantDemanda]) VALUES (20230201, 1, 1, 1)
INSERT [dbo].[Fact_Habitacion] ([idTiempo], [idTipoHabitacion], [Estadia], [cantDemanda]) VALUES (20230203, 1, 4, 1)
INSERT [dbo].[Fact_Habitacion] ([idTiempo], [idTipoHabitacion], [Estadia], [cantDemanda]) VALUES (20230201, 2, 1, 2)
INSERT [dbo].[Fact_Habitacion] ([idTiempo], [idTipoHabitacion], [Estadia], [cantDemanda]) VALUES (20230215, 10, 3, 10)
INSERT [dbo].[Fact_Habitacion] ([idTiempo], [idTipoHabitacion], [Estadia], [cantDemanda]) VALUES (20230215, 10, 5, 10)
INSERT [dbo].[Fact_Habitacion] ([idTiempo], [idTipoHabitacion], [Estadia], [cantDemanda]) VALUES (20230220, 1, 2, 1)
INSERT [dbo].[Fact_Habitacion] ([idTiempo], [idTipoHabitacion], [Estadia], [cantDemanda]) VALUES (20230220, 1, 4, 1)
INSERT [dbo].[Fact_Habitacion] ([idTiempo], [idTipoHabitacion], [Estadia], [cantDemanda]) VALUES (20230301, 10, 1, 10)
INSERT [dbo].[Fact_Habitacion] ([idTiempo], [idTipoHabitacion], [Estadia], [cantDemanda]) VALUES (20230305, 1, 2, 1)
INSERT [dbo].[Fact_Habitacion] ([idTiempo], [idTipoHabitacion], [Estadia], [cantDemanda]) VALUES (20230306, 1, 4, 1)
INSERT [dbo].[Fact_Habitacion] ([idTiempo], [idTipoHabitacion], [Estadia], [cantDemanda]) VALUES (20230307, 2, 5, 2)
INSERT [dbo].[Fact_Habitacion] ([idTiempo], [idTipoHabitacion], [Estadia], [cantDemanda]) VALUES (20230310, 10, 5, 10)
INSERT [dbo].[Fact_Habitacion] ([idTiempo], [idTipoHabitacion], [Estadia], [cantDemanda]) VALUES (20230310, 10, 8, 10)
INSERT [dbo].[Fact_Habitacion] ([idTiempo], [idTipoHabitacion], [Estadia], [cantDemanda]) VALUES (20230320, 1, 10, 1)
INSERT [dbo].[Fact_Habitacion] ([idTiempo], [idTipoHabitacion], [Estadia], [cantDemanda]) VALUES (20230321, 1, 9, 1)
GO
INSERT [dbo].[Fact_Huesped] ([idTiempo], [idTipoHabitacion], [idHotel], [cantidadDias], [cantidadHuespedes]) VALUES (20230127, 1, 1, 1, 2)
INSERT [dbo].[Fact_Huesped] ([idTiempo], [idTipoHabitacion], [idHotel], [cantidadDias], [cantidadHuespedes]) VALUES (20230127, 1, 1, 1, 3)
INSERT [dbo].[Fact_Huesped] ([idTiempo], [idTipoHabitacion], [idHotel], [cantidadDias], [cantidadHuespedes]) VALUES (20230127, 2, 2, 1, 3)
INSERT [dbo].[Fact_Huesped] ([idTiempo], [idTipoHabitacion], [idHotel], [cantidadDias], [cantidadHuespedes]) VALUES (20230127, 2, 2, 1, 4)
INSERT [dbo].[Fact_Huesped] ([idTiempo], [idTipoHabitacion], [idHotel], [cantidadDias], [cantidadHuespedes]) VALUES (20230127, 10, 3, 1, 2)
INSERT [dbo].[Fact_Huesped] ([idTiempo], [idTipoHabitacion], [idHotel], [cantidadDias], [cantidadHuespedes]) VALUES (20230127, 10, 3, 1, 4)
INSERT [dbo].[Fact_Huesped] ([idTiempo], [idTipoHabitacion], [idHotel], [cantidadDias], [cantidadHuespedes]) VALUES (20230101, 1, 1, 1, 2)
INSERT [dbo].[Fact_Huesped] ([idTiempo], [idTipoHabitacion], [idHotel], [cantidadDias], [cantidadHuespedes]) VALUES (20230101, 1, 1, 1, 3)
INSERT [dbo].[Fact_Huesped] ([idTiempo], [idTipoHabitacion], [idHotel], [cantidadDias], [cantidadHuespedes]) VALUES (20230115, 2, 2, 2, 3)
INSERT [dbo].[Fact_Huesped] ([idTiempo], [idTipoHabitacion], [idHotel], [cantidadDias], [cantidadHuespedes]) VALUES (20230118, 2, 2, 4, 4)
INSERT [dbo].[Fact_Huesped] ([idTiempo], [idTipoHabitacion], [idHotel], [cantidadDias], [cantidadHuespedes]) VALUES (20230201, 10, 3, 3, 2)
INSERT [dbo].[Fact_Huesped] ([idTiempo], [idTipoHabitacion], [idHotel], [cantidadDias], [cantidadHuespedes]) VALUES (20230201, 10, 3, 4, 4)
INSERT [dbo].[Fact_Huesped] ([idTiempo], [idTipoHabitacion], [idHotel], [cantidadDias], [cantidadHuespedes]) VALUES (20230201, 1, 1, 1, 2)
INSERT [dbo].[Fact_Huesped] ([idTiempo], [idTipoHabitacion], [idHotel], [cantidadDias], [cantidadHuespedes]) VALUES (20230203, 1, 1, 4, 3)
INSERT [dbo].[Fact_Huesped] ([idTiempo], [idTipoHabitacion], [idHotel], [cantidadDias], [cantidadHuespedes]) VALUES (20230201, 2, 2, 1, 3)
INSERT [dbo].[Fact_Huesped] ([idTiempo], [idTipoHabitacion], [idHotel], [cantidadDias], [cantidadHuespedes]) VALUES (20230201, 2, 2, 1, 4)
INSERT [dbo].[Fact_Huesped] ([idTiempo], [idTipoHabitacion], [idHotel], [cantidadDias], [cantidadHuespedes]) VALUES (20230215, 10, 3, 3, 2)
INSERT [dbo].[Fact_Huesped] ([idTiempo], [idTipoHabitacion], [idHotel], [cantidadDias], [cantidadHuespedes]) VALUES (20230215, 10, 3, 5, 4)
INSERT [dbo].[Fact_Huesped] ([idTiempo], [idTipoHabitacion], [idHotel], [cantidadDias], [cantidadHuespedes]) VALUES (20230220, 1, 1, 2, 2)
INSERT [dbo].[Fact_Huesped] ([idTiempo], [idTipoHabitacion], [idHotel], [cantidadDias], [cantidadHuespedes]) VALUES (20230220, 1, 1, 4, 3)
INSERT [dbo].[Fact_Huesped] ([idTiempo], [idTipoHabitacion], [idHotel], [cantidadDias], [cantidadHuespedes]) VALUES (20230301, 10, 2, 1, 2)
INSERT [dbo].[Fact_Huesped] ([idTiempo], [idTipoHabitacion], [idHotel], [cantidadDias], [cantidadHuespedes]) VALUES (20230301, 10, 2, 1, 4)
INSERT [dbo].[Fact_Huesped] ([idTiempo], [idTipoHabitacion], [idHotel], [cantidadDias], [cantidadHuespedes]) VALUES (20230305, 1, 3, 2, 2)
INSERT [dbo].[Fact_Huesped] ([idTiempo], [idTipoHabitacion], [idHotel], [cantidadDias], [cantidadHuespedes]) VALUES (20230306, 1, 3, 4, 3)
INSERT [dbo].[Fact_Huesped] ([idTiempo], [idTipoHabitacion], [idHotel], [cantidadDias], [cantidadHuespedes]) VALUES (20230307, 2, 1, 5, 3)
INSERT [dbo].[Fact_Huesped] ([idTiempo], [idTipoHabitacion], [idHotel], [cantidadDias], [cantidadHuespedes]) VALUES (20230307, 2, 1, 5, 4)
INSERT [dbo].[Fact_Huesped] ([idTiempo], [idTipoHabitacion], [idHotel], [cantidadDias], [cantidadHuespedes]) VALUES (20230310, 10, 2, 5, 2)
INSERT [dbo].[Fact_Huesped] ([idTiempo], [idTipoHabitacion], [idHotel], [cantidadDias], [cantidadHuespedes]) VALUES (20230310, 10, 2, 8, 4)
INSERT [dbo].[Fact_Huesped] ([idTiempo], [idTipoHabitacion], [idHotel], [cantidadDias], [cantidadHuespedes]) VALUES (20230320, 1, 3, 10, 2)
INSERT [dbo].[Fact_Huesped] ([idTiempo], [idTipoHabitacion], [idHotel], [cantidadDias], [cantidadHuespedes]) VALUES (20230321, 1, 3, 9, 3)
GO
INSERT [dbo].[Fact_Ingresos] ([idHotel], [idTiempo], [idHuesped], [cantGenerada]) VALUES (1, 20230127, 1, 202000.0000)
INSERT [dbo].[Fact_Ingresos] ([idHotel], [idTiempo], [idHuesped], [cantGenerada]) VALUES (1, 20230127, 1, 182000.0000)
INSERT [dbo].[Fact_Ingresos] ([idHotel], [idTiempo], [idHuesped], [cantGenerada]) VALUES (2, 20230127, 2, 91000.0000)
INSERT [dbo].[Fact_Ingresos] ([idHotel], [idTiempo], [idHuesped], [cantGenerada]) VALUES (3, 20230127, 8, 45500.0000)
INSERT [dbo].[Fact_Ingresos] ([idHotel], [idTiempo], [idHuesped], [cantGenerada]) VALUES (1, 20230101, 1, 202000.0000)
INSERT [dbo].[Fact_Ingresos] ([idHotel], [idTiempo], [idHuesped], [cantGenerada]) VALUES (1, 20230101, 1, 182000.0000)
INSERT [dbo].[Fact_Ingresos] ([idHotel], [idTiempo], [idHuesped], [cantGenerada]) VALUES (2, 20230115, 2, 91000.0000)
INSERT [dbo].[Fact_Ingresos] ([idHotel], [idTiempo], [idHuesped], [cantGenerada]) VALUES (2, 20230118, 2, 91000.0000)
INSERT [dbo].[Fact_Ingresos] ([idHotel], [idTiempo], [idHuesped], [cantGenerada]) VALUES (3, 20230201, 3, 45500.0000)
INSERT [dbo].[Fact_Ingresos] ([idHotel], [idTiempo], [idHuesped], [cantGenerada]) VALUES (1, 20230201, 2, 202000.0000)
INSERT [dbo].[Fact_Ingresos] ([idHotel], [idTiempo], [idHuesped], [cantGenerada]) VALUES (1, 20230203, 2, 182000.0000)
INSERT [dbo].[Fact_Ingresos] ([idHotel], [idTiempo], [idHuesped], [cantGenerada]) VALUES (2, 20230201, 3, 91000.0000)
INSERT [dbo].[Fact_Ingresos] ([idHotel], [idTiempo], [idHuesped], [cantGenerada]) VALUES (3, 20230215, 4, 45500.0000)
INSERT [dbo].[Fact_Ingresos] ([idHotel], [idTiempo], [idHuesped], [cantGenerada]) VALUES (1, 20230220, 5, 202000.0000)
INSERT [dbo].[Fact_Ingresos] ([idHotel], [idTiempo], [idHuesped], [cantGenerada]) VALUES (1, 20230220, 5, 182000.0000)
INSERT [dbo].[Fact_Ingresos] ([idHotel], [idTiempo], [idHuesped], [cantGenerada]) VALUES (2, 20230301, 6, 45500.0000)
INSERT [dbo].[Fact_Ingresos] ([idHotel], [idTiempo], [idHuesped], [cantGenerada]) VALUES (3, 20230305, 7, 202000.0000)
INSERT [dbo].[Fact_Ingresos] ([idHotel], [idTiempo], [idHuesped], [cantGenerada]) VALUES (3, 20230306, 7, 182000.0000)
INSERT [dbo].[Fact_Ingresos] ([idHotel], [idTiempo], [idHuesped], [cantGenerada]) VALUES (1, 20230307, 8, 91000.0000)
INSERT [dbo].[Fact_Ingresos] ([idHotel], [idTiempo], [idHuesped], [cantGenerada]) VALUES (2, 20230310, 9, 45500.0000)
INSERT [dbo].[Fact_Ingresos] ([idHotel], [idTiempo], [idHuesped], [cantGenerada]) VALUES (3, 20230320, 10, 202000.0000)
INSERT [dbo].[Fact_Ingresos] ([idHotel], [idTiempo], [idHuesped], [cantGenerada]) VALUES (3, 20230321, 10, 182000.0000)
GO
INSERT [dbo].[Fact_Reservas] ([idHotel], [idTiempo], [idHuesped], [idTipoHabitacion], [ingreReservas], [promReservas], [cantReservas]) VALUES (1, 20230127, 1, 1, 202000.0000, 202000.0000, 1)
INSERT [dbo].[Fact_Reservas] ([idHotel], [idTiempo], [idHuesped], [idTipoHabitacion], [ingreReservas], [promReservas], [cantReservas]) VALUES (1, 20230127, 1, 1, 182000.0000, 182000.0000, 1)
INSERT [dbo].[Fact_Reservas] ([idHotel], [idTiempo], [idHuesped], [idTipoHabitacion], [ingreReservas], [promReservas], [cantReservas]) VALUES (2, 20230127, 2, 2, 91000.0000, 91000.0000, 1)
INSERT [dbo].[Fact_Reservas] ([idHotel], [idTiempo], [idHuesped], [idTipoHabitacion], [ingreReservas], [promReservas], [cantReservas]) VALUES (3, 20230127, 8, 10, 45500.0000, 45500.0000, 1)
INSERT [dbo].[Fact_Reservas] ([idHotel], [idTiempo], [idHuesped], [idTipoHabitacion], [ingreReservas], [promReservas], [cantReservas]) VALUES (1, 20230101, 1, 1, 202000.0000, 202000.0000, 1)
INSERT [dbo].[Fact_Reservas] ([idHotel], [idTiempo], [idHuesped], [idTipoHabitacion], [ingreReservas], [promReservas], [cantReservas]) VALUES (1, 20230101, 1, 1, 182000.0000, 182000.0000, 1)
INSERT [dbo].[Fact_Reservas] ([idHotel], [idTiempo], [idHuesped], [idTipoHabitacion], [ingreReservas], [promReservas], [cantReservas]) VALUES (2, 20230115, 2, 2, 91000.0000, 91000.0000, 1)
INSERT [dbo].[Fact_Reservas] ([idHotel], [idTiempo], [idHuesped], [idTipoHabitacion], [ingreReservas], [promReservas], [cantReservas]) VALUES (2, 20230118, 2, 2, 91000.0000, 91000.0000, 1)
INSERT [dbo].[Fact_Reservas] ([idHotel], [idTiempo], [idHuesped], [idTipoHabitacion], [ingreReservas], [promReservas], [cantReservas]) VALUES (3, 20230201, 3, 10, 45500.0000, 45500.0000, 1)
INSERT [dbo].[Fact_Reservas] ([idHotel], [idTiempo], [idHuesped], [idTipoHabitacion], [ingreReservas], [promReservas], [cantReservas]) VALUES (1, 20230201, 2, 1, 202000.0000, 202000.0000, 1)
INSERT [dbo].[Fact_Reservas] ([idHotel], [idTiempo], [idHuesped], [idTipoHabitacion], [ingreReservas], [promReservas], [cantReservas]) VALUES (1, 20230203, 2, 1, 182000.0000, 182000.0000, 1)
INSERT [dbo].[Fact_Reservas] ([idHotel], [idTiempo], [idHuesped], [idTipoHabitacion], [ingreReservas], [promReservas], [cantReservas]) VALUES (2, 20230201, 3, 2, 91000.0000, 91000.0000, 1)
INSERT [dbo].[Fact_Reservas] ([idHotel], [idTiempo], [idHuesped], [idTipoHabitacion], [ingreReservas], [promReservas], [cantReservas]) VALUES (3, 20230215, 4, 10, 45500.0000, 45500.0000, 1)
INSERT [dbo].[Fact_Reservas] ([idHotel], [idTiempo], [idHuesped], [idTipoHabitacion], [ingreReservas], [promReservas], [cantReservas]) VALUES (1, 20230220, 5, 1, 202000.0000, 202000.0000, 1)
INSERT [dbo].[Fact_Reservas] ([idHotel], [idTiempo], [idHuesped], [idTipoHabitacion], [ingreReservas], [promReservas], [cantReservas]) VALUES (1, 20230220, 5, 1, 182000.0000, 182000.0000, 1)
INSERT [dbo].[Fact_Reservas] ([idHotel], [idTiempo], [idHuesped], [idTipoHabitacion], [ingreReservas], [promReservas], [cantReservas]) VALUES (2, 20230301, 6, 10, 45500.0000, 45500.0000, 1)
INSERT [dbo].[Fact_Reservas] ([idHotel], [idTiempo], [idHuesped], [idTipoHabitacion], [ingreReservas], [promReservas], [cantReservas]) VALUES (3, 20230305, 7, 1, 202000.0000, 202000.0000, 1)
INSERT [dbo].[Fact_Reservas] ([idHotel], [idTiempo], [idHuesped], [idTipoHabitacion], [ingreReservas], [promReservas], [cantReservas]) VALUES (3, 20230306, 7, 1, 182000.0000, 182000.0000, 1)
INSERT [dbo].[Fact_Reservas] ([idHotel], [idTiempo], [idHuesped], [idTipoHabitacion], [ingreReservas], [promReservas], [cantReservas]) VALUES (1, 20230307, 8, 2, 91000.0000, 91000.0000, 1)
INSERT [dbo].[Fact_Reservas] ([idHotel], [idTiempo], [idHuesped], [idTipoHabitacion], [ingreReservas], [promReservas], [cantReservas]) VALUES (2, 20230310, 9, 10, 45500.0000, 45500.0000, 1)
INSERT [dbo].[Fact_Reservas] ([idHotel], [idTiempo], [idHuesped], [idTipoHabitacion], [ingreReservas], [promReservas], [cantReservas]) VALUES (3, 20230320, 10, 1, 202000.0000, 202000.0000, 1)
INSERT [dbo].[Fact_Reservas] ([idHotel], [idTiempo], [idHuesped], [idTipoHabitacion], [ingreReservas], [promReservas], [cantReservas]) VALUES (3, 20230321, 10, 1, 182000.0000, 182000.0000, 1)
GO
INSERT [dbo].[Fact_Servicios] ([idTiempo], [idHuesped], [idServicio], [idHotel], [cantConsumo], [Ingresos]) VALUES (20231113, 16, 2, 1, 2, 1100000.0000)
INSERT [dbo].[Fact_Servicios] ([idTiempo], [idHuesped], [idServicio], [idHotel], [cantConsumo], [Ingresos]) VALUES (20231113, 17, 1, 1, 1, 16500000.0000)
INSERT [dbo].[Fact_Servicios] ([idTiempo], [idHuesped], [idServicio], [idHotel], [cantConsumo], [Ingresos]) VALUES (20231113, 18, 1, 1, 1, 23100000.0000)
INSERT [dbo].[Fact_Servicios] ([idTiempo], [idHuesped], [idServicio], [idHotel], [cantConsumo], [Ingresos]) VALUES (20231115, 19, 3, 2, 3, 60500000.0000)
INSERT [dbo].[Fact_Servicios] ([idTiempo], [idHuesped], [idServicio], [idHotel], [cantConsumo], [Ingresos]) VALUES (20231120, 20, 4, 1, 4, 72600000.0000)
GO
ALTER TABLE [dbo].[Fact_Habitacion]  WITH NOCHECK ADD FOREIGN KEY([idTiempo])
REFERENCES [dbo].[Dim_Tiempo] ([idTiempo])
GO
ALTER TABLE [dbo].[Fact_Habitacion]  WITH NOCHECK ADD FOREIGN KEY([idTipoHabitacion])
REFERENCES [dbo].[Dim_TipoHabitacion] ([idTipoHabitacion])
GO
ALTER TABLE [dbo].[Fact_Huesped]  WITH CHECK ADD FOREIGN KEY([idHotel])
REFERENCES [dbo].[Dim_Hotel] ([idHotel])
GO
ALTER TABLE [dbo].[Fact_Huesped]  WITH CHECK ADD FOREIGN KEY([idTiempo])
REFERENCES [dbo].[Dim_Tiempo] ([idTiempo])
GO
ALTER TABLE [dbo].[Fact_Huesped]  WITH CHECK ADD FOREIGN KEY([idTipoHabitacion])
REFERENCES [dbo].[Dim_TipoHabitacion] ([idTipoHabitacion])
GO
ALTER TABLE [dbo].[Fact_Ingresos]  WITH CHECK ADD FOREIGN KEY([idHotel])
REFERENCES [dbo].[Dim_Hotel] ([idHotel])
GO
ALTER TABLE [dbo].[Fact_Ingresos]  WITH CHECK ADD FOREIGN KEY([idHuesped])
REFERENCES [dbo].[Dim_Huesped] ([idHuesped])
GO
ALTER TABLE [dbo].[Fact_Ingresos]  WITH CHECK ADD FOREIGN KEY([idTiempo])
REFERENCES [dbo].[Dim_Tiempo] ([idTiempo])
GO
ALTER TABLE [dbo].[Fact_Reservas]  WITH CHECK ADD FOREIGN KEY([idHotel])
REFERENCES [dbo].[Dim_Hotel] ([idHotel])
GO
ALTER TABLE [dbo].[Fact_Reservas]  WITH CHECK ADD FOREIGN KEY([idHuesped])
REFERENCES [dbo].[Dim_Huesped] ([idHuesped])
GO
ALTER TABLE [dbo].[Fact_Reservas]  WITH CHECK ADD FOREIGN KEY([idTiempo])
REFERENCES [dbo].[Dim_Tiempo] ([idTiempo])
GO
ALTER TABLE [dbo].[Fact_Reservas]  WITH CHECK ADD FOREIGN KEY([idTipoHabitacion])
REFERENCES [dbo].[Dim_TipoHabitacion] ([idTipoHabitacion])
GO
ALTER TABLE [dbo].[Fact_Servicios]  WITH NOCHECK ADD FOREIGN KEY([idHotel])
REFERENCES [dbo].[Dim_Hotel] ([idHotel])
GO
ALTER TABLE [dbo].[Fact_Servicios]  WITH NOCHECK ADD FOREIGN KEY([idHuesped])
REFERENCES [dbo].[Dim_Huesped] ([idHuesped])
GO
ALTER TABLE [dbo].[Fact_Servicios]  WITH NOCHECK ADD FOREIGN KEY([idServicio])
REFERENCES [dbo].[Dim_TipoServicio] ([idServicio])
GO
ALTER TABLE [dbo].[Fact_Servicios]  WITH NOCHECK ADD FOREIGN KEY([idTiempo])
REFERENCES [dbo].[Dim_Tiempo] ([idTiempo])
GO
/****** Object:  StoredProcedure [dbo].[CalculateAge]    Script Date: 13/11/2023 17:41:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[CalculateAge]
AS
BEGIN
  UPDATE Dim_Huesped
  SET edad = FLOOR(DATEDIFF(YEAR, fechanacimiento, GETDATE() ))
END
GO
/****** Object:  StoredProcedure [dbo].[cargarDimTiempo]    Script Date: 13/11/2023 17:41:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[cargarDimTiempo]
AS
BEGIN
    DECLARE @inicio datetime, @fin datetime, @i datetime

    -- DD/MM/YY
    SET @inicio = (SELECT MIN(borde_checkin) FROM Hotel_Realta.Booking.booking_order_detail)
    SET @fin = (SELECT MAX(borde_checkout) FROM Hotel_Realta.Booking.booking_order_detail)
    SET @i = @inicio

    WHILE @i <= @fin
    BEGIN
        -- Verificar si la fecha ya existe en dimTiempo
        IF NOT EXISTS (SELECT 1 FROM Dim_Tiempo WHERE idTiempo = YEAR(@i)*10000 + MONTH(@i)*100 + DAY(@i))
        BEGIN
            INSERT INTO Dim_Tiempo VALUES(
                YEAR(@i)*10000 + MONTH(@i)*100 + DAY(@i),
                DATENAME(mm, @i),
                CASE DATEPART(QUARTER, @i)
                    WHEN 1 THEN 1
                    WHEN 2 THEN 2
                    WHEN 3 THEN 3
                    ELSE 4
                END,
                YEAR(@i)
            );
        END

        SET @i = DATEADD(dd, 1, @i);
    END;
END;
GO
/****** Object:  StoredProcedure [dbo].[cargarDimTiempo2]    Script Date: 13/11/2023 17:41:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[cargarDimTiempo2]
AS
BEGIN
    DECLARE @inicio datetime, @fin datetime, @i datetime

    -- DD/MM/YY
    SET @inicio = (SELECT MIN(Hotel_Realta.HR.work_order_detail.wode_start_date) FROM Hotel_Realta.HR.work_order_detail)
    SET @fin = (SELECT MAX(Hotel_Realta.HR.work_order_detail.wode_end_date) FROM Hotel_Realta.HR.work_order_detail)
    SET @i = @inicio

    WHILE @i <= @fin
    BEGIN
        -- Verificar si la fecha ya existe en dimTiempo
        IF NOT EXISTS (SELECT 1 FROM Dim_Tiempo2 WHERE idTiempo = YEAR(@i)*10000 + MONTH(@i)*100 + DAY(@i))
        BEGIN
            INSERT INTO Dim_Tiempo2 VALUES(
                YEAR(@i)*10000 + MONTH(@i)*100 + DAY(@i),
                DATENAME(mm, @i),
                CASE DATEPART(QUARTER, @i)
                    WHEN 1 THEN 1
                    WHEN 2 THEN 2
                    WHEN 3 THEN 3
                    ELSE 4
                END,
                YEAR(@i)
            );
        END

        SET @i = DATEADD(dd, 1, @i);
    END;
END;
GO
/****** Object:  StoredProcedure [dbo].[cargarDimTiempo3]    Script Date: 13/11/2023 17:41:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[cargarDimTiempo3]
AS
BEGIN
    DECLARE @inicio datetime, @fin datetime, @i datetime

    -- DD/MM/YY
    SET @inicio = (SELECT MIN(Hotel_Realta.Purchasing.purchase_order_header.pohe_order_date) FROM Hotel_Realta.Purchasing.purchase_order_header)
    SET @fin = (SELECT MAX(Hotel_Realta.Purchasing.purchase_order_header.pohe_order_date) FROM Hotel_Realta.Purchasing.purchase_order_header)
    SET @i = @inicio

    WHILE @i <= @fin
    BEGIN
        -- Verificar si la fecha ya existe en dimTiempo
        IF NOT EXISTS (SELECT 1 FROM Dim_Tiempo3 WHERE idTiempo = YEAR(@i)*10000 + MONTH(@i)*100 + DAY(@i))
        BEGIN
            INSERT INTO Dim_Tiempo3 VALUES(
                YEAR(@i)*10000 + MONTH(@i)*100 + DAY(@i),
                DATENAME(mm, @i),
                CASE DATEPART(QUARTER, @i)
                    WHEN 1 THEN 1
                    WHEN 2 THEN 2
                    WHEN 3 THEN 3
                    ELSE 4
                END,
                YEAR(@i)
            );
        END

        SET @i = DATEADD(dd, 1, @i);
    END;
END;
GO
USE [master]
GO
ALTER DATABASE [Hotel_RealtaDM] SET  READ_WRITE 
GO
