USE [master]
GO
/****** Object:  Database [OULAD_Analytics]    Script Date: 12/14/2025 12:25:12 PM ******/
CREATE DATABASE [OULAD_Analytics]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'OULAD_Analytics', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\OULAD_Analytics.mdf' , SIZE = 794624KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'OULAD_Analytics_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\OULAD_Analytics_log.ldf' , SIZE = 1843200KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [OULAD_Analytics] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [OULAD_Analytics].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [OULAD_Analytics] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [OULAD_Analytics] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [OULAD_Analytics] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [OULAD_Analytics] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [OULAD_Analytics] SET ARITHABORT OFF 
GO
ALTER DATABASE [OULAD_Analytics] SET AUTO_CLOSE ON 
GO
ALTER DATABASE [OULAD_Analytics] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [OULAD_Analytics] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [OULAD_Analytics] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [OULAD_Analytics] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [OULAD_Analytics] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [OULAD_Analytics] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [OULAD_Analytics] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [OULAD_Analytics] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [OULAD_Analytics] SET  ENABLE_BROKER 
GO
ALTER DATABASE [OULAD_Analytics] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [OULAD_Analytics] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [OULAD_Analytics] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [OULAD_Analytics] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [OULAD_Analytics] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [OULAD_Analytics] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [OULAD_Analytics] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [OULAD_Analytics] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [OULAD_Analytics] SET  MULTI_USER 
GO
ALTER DATABASE [OULAD_Analytics] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [OULAD_Analytics] SET DB_CHAINING OFF 
GO
ALTER DATABASE [OULAD_Analytics] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [OULAD_Analytics] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [OULAD_Analytics] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [OULAD_Analytics] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [OULAD_Analytics] SET QUERY_STORE = OFF
GO
USE [OULAD_Analytics]
GO
/****** Object:  Table [dbo].[StudentInfo]    Script Date: 12/14/2025 12:25:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[StudentInfo](
	[id_student] [int] NOT NULL,
	[code_module] [varchar](10) NOT NULL,
	[code_presentation] [varchar](10) NOT NULL,
	[gender] [varchar](10) NULL,
	[region] [varchar](50) NULL,
	[highest_education] [varchar](50) NULL,
	[imd_band] [varchar](20) NULL,
	[age_band] [varchar](20) NULL,
	[num_of_prev_attempts] [int] NULL,
	[studied_credits] [int] NULL,
	[disability] [varchar](10) NULL,
	[final_result] [varchar](20) NULL,
 CONSTRAINT [PK_StudentInfo] PRIMARY KEY CLUSTERED 
(
	[id_student] ASC,
	[code_module] ASC,
	[code_presentation] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[StudentRegistration]    Script Date: 12/14/2025 12:25:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[StudentRegistration](
	[id_student] [int] NOT NULL,
	[code_module] [varchar](10) NOT NULL,
	[code_presentation] [varchar](10) NOT NULL,
	[date_registration] [int] NULL,
	[date_unregistration] [int] NULL,
 CONSTRAINT [PK_StudentRegistration] PRIMARY KEY CLUSTERED 
(
	[id_student] ASC,
	[code_module] ASC,
	[code_presentation] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vw_OULAD_Analytics]    Script Date: 12/14/2025 12:25:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   VIEW [dbo].[vw_OULAD_Analytics] AS
SELECT
    si.id_student,
    si.code_module,
    si.code_presentation,
    si.gender,
    si.region,
    si.highest_education,
    si.imd_band,
    si.age_band,
    si.num_of_prev_attempts,
    si.studied_credits,
    si.disability,
    si.final_result,
    sr.date_registration,
    sr.date_unregistration
FROM dbo.StudentInfo si
LEFT JOIN dbo.StudentRegistration sr
  ON si.id_student = sr.id_student
 AND si.code_module = sr.code_module
 AND si.code_presentation = sr.code_presentation;
GO
/****** Object:  Table [dbo].[VLE]    Script Date: 12/14/2025 12:25:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[VLE](
	[id_site] [int] NOT NULL,
	[code_module] [varchar](10) NOT NULL,
	[code_presentation] [varchar](10) NOT NULL,
	[activity_type] [varchar](50) NULL,
	[week_from] [int] NULL,
	[week_to] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[id_site] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[StudentVLE]    Script Date: 12/14/2025 12:25:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[StudentVLE](
	[id_student] [int] NOT NULL,
	[id_site] [int] NOT NULL,
	[date] [int] NOT NULL,
	[sum_click] [int] NOT NULL,
 CONSTRAINT [PK_StudentVLE] PRIMARY KEY CLUSTERED 
(
	[id_student] ASC,
	[id_site] ASC,
	[date] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vw_OULAD_EarlyRisk]    Script Date: 12/14/2025 12:25:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   VIEW [dbo].[vw_OULAD_EarlyRisk] AS
SELECT
    si.id_student,
    si.code_module,
    si.code_presentation,
    si.final_result,
    si.age_band,
    si.gender,
    si.highest_education,
    si.region,
    SUM(CASE WHEN sv.date BETWEEN 0 AND 21 THEN sv.sum_click ELSE 0 END) AS clicks_day0_21,
    SUM(CASE WHEN sv.date BETWEEN 0 AND 21 THEN 1 ELSE 0 END) AS active_days_0_21
FROM dbo.StudentInfo si
LEFT JOIN dbo.StudentVLE sv
  ON si.id_student = sv.id_student
LEFT JOIN dbo.VLE v
  ON sv.id_site = v.id_site
 AND v.code_module = si.code_module
 AND v.code_presentation = si.code_presentation
GROUP BY
    si.id_student,
    si.code_module,
    si.code_presentation,
    si.final_result,
    si.age_band,
    si.gender,
    si.highest_education,
    si.region;
GO
/****** Object:  Table [dbo].[Courses]    Script Date: 12/14/2025 12:25:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Courses](
	[code_module] [varchar](10) NOT NULL,
	[code_presentation] [varchar](10) NOT NULL,
	[module_length] [int] NULL,
	[module_year] [int] NULL,
 CONSTRAINT [PK_Courses] PRIMARY KEY CLUSTERED 
(
	[code_module] ASC,
	[code_presentation] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[StudentInfo]  WITH CHECK ADD  CONSTRAINT [FK_StudentInfo_Courses] FOREIGN KEY([code_module], [code_presentation])
REFERENCES [dbo].[Courses] ([code_module], [code_presentation])
GO
ALTER TABLE [dbo].[StudentInfo] CHECK CONSTRAINT [FK_StudentInfo_Courses]
GO
ALTER TABLE [dbo].[StudentRegistration]  WITH CHECK ADD  CONSTRAINT [FK_StudentRegistration_Courses] FOREIGN KEY([code_module], [code_presentation])
REFERENCES [dbo].[Courses] ([code_module], [code_presentation])
GO
ALTER TABLE [dbo].[StudentRegistration] CHECK CONSTRAINT [FK_StudentRegistration_Courses]
GO
ALTER TABLE [dbo].[StudentVLE]  WITH CHECK ADD  CONSTRAINT [FK_StudentVLE_VLE] FOREIGN KEY([id_site])
REFERENCES [dbo].[VLE] ([id_site])
GO
ALTER TABLE [dbo].[StudentVLE] CHECK CONSTRAINT [FK_StudentVLE_VLE]
GO
ALTER TABLE [dbo].[VLE]  WITH CHECK ADD  CONSTRAINT [FK_VLE_Courses] FOREIGN KEY([code_module], [code_presentation])
REFERENCES [dbo].[Courses] ([code_module], [code_presentation])
GO
ALTER TABLE [dbo].[VLE] CHECK CONSTRAINT [FK_VLE_Courses]
GO
USE [master]
GO
ALTER DATABASE [OULAD_Analytics] SET  READ_WRITE 
GO

