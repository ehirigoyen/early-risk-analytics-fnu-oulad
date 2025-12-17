USE [master]
GO
/****** Object:  Database [FNU_Analytics]    Script Date: 12/17/2025 1:36:47 PM ******/
CREATE DATABASE [FNU_Analytics]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'FNU_Analytics', FILENAME = N'C:\0-EH\SQLServer-Class\Data\FNU_Analytics.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'FNU_Analytics_log', FILENAME = N'C:\0-EH\SQLServer-Class\Data\FNU_Analytics_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [FNU_Analytics] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [FNU_Analytics].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [FNU_Analytics] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [FNU_Analytics] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [FNU_Analytics] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [FNU_Analytics] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [FNU_Analytics] SET ARITHABORT OFF 
GO
ALTER DATABASE [FNU_Analytics] SET AUTO_CLOSE ON 
GO
ALTER DATABASE [FNU_Analytics] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [FNU_Analytics] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [FNU_Analytics] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [FNU_Analytics] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [FNU_Analytics] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [FNU_Analytics] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [FNU_Analytics] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [FNU_Analytics] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [FNU_Analytics] SET  DISABLE_BROKER 
GO
ALTER DATABASE [FNU_Analytics] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [FNU_Analytics] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [FNU_Analytics] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [FNU_Analytics] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [FNU_Analytics] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [FNU_Analytics] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [FNU_Analytics] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [FNU_Analytics] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [FNU_Analytics] SET  MULTI_USER 
GO
ALTER DATABASE [FNU_Analytics] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [FNU_Analytics] SET DB_CHAINING OFF 
GO
ALTER DATABASE [FNU_Analytics] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [FNU_Analytics] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [FNU_Analytics] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [FNU_Analytics] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [FNU_Analytics] SET QUERY_STORE = OFF
GO
USE [FNU_Analytics]
GO
/****** Object:  User [usersql]    Script Date: 12/17/2025 1:36:48 PM ******/
CREATE USER [usersql] WITHOUT LOGIN WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  Table [dbo].[Students]    Script Date: 12/17/2025 1:36:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Students](
	[student_id] [int] NOT NULL,
	[gender] [varchar](10) NULL,
	[age_band] [varchar](20) NULL,
	[region] [varchar](50) NULL,
	[prior_education] [varchar](50) NULL,
	[gpa_prior] [decimal](3, 2) NULL,
	[disability_flag] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[student_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Programs]    Script Date: 12/17/2025 1:36:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Programs](
	[program_code] [varchar](20) NOT NULL,
	[program_name] [varchar](100) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[program_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Courses]    Script Date: 12/17/2025 1:36:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Courses](
	[course_id] [int] NOT NULL,
	[course_code] [varchar](20) NOT NULL,
	[course_name] [varchar](100) NOT NULL,
	[modality] [varchar](20) NOT NULL,
	[credits] [tinyint] NULL,
	[program_code] [varchar](20) NULL,
PRIMARY KEY CLUSTERED 
(
	[course_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Terms]    Script Date: 12/17/2025 1:36:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Terms](
	[term_id] [int] NOT NULL,
	[term_code] [varchar](20) NOT NULL,
	[term_name] [varchar](50) NULL,
	[start_date] [date] NULL,
	[end_date] [date] NULL,
PRIMARY KEY CLUSTERED 
(
	[term_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Enrolments]    Script Date: 12/17/2025 1:36:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Enrolments](
	[enrolment_id] [int] IDENTITY(1,1) NOT NULL,
	[student_id] [int] NOT NULL,
	[course_id] [int] NOT NULL,
	[term_id] [int] NOT NULL,
	[date_enrolled] [date] NULL,
	[date_withdrawn] [date] NULL,
	[final_grade] [decimal](5, 2) NULL,
	[pass_flag] [bit] NOT NULL,
	[withdraw_flag] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[enrolment_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vw_FNU_Analytics]    Script Date: 12/17/2025 1:36:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_FNU_Analytics] AS
  SELECT
    e.enrolment_id,
    s.student_id,
    s.age_band,
    s.gender,
    s.region,
    s.prior_education,
    s.gpa_prior,
    c.course_name,
    c.modality,
    p.program_name,
    t.term_name,
    e.final_grade,
    e.pass_flag,
    e.withdraw_flag
  FROM Enrolments e
  JOIN Students s ON e.student_id = s.student_id
  JOIN Courses c ON e.course_id = c.course_id
  JOIN Programs p ON c.program_code = p.program_code
  JOIN Terms t ON e.term_id = t.term_id;
GO
/****** Object:  Table [dbo].[WeeklyActivity]    Script Date: 12/17/2025 1:36:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WeeklyActivity](
	[activity_id] [int] IDENTITY(1,1) NOT NULL,
	[enrolment_id] [int] NOT NULL,
	[week_no] [tinyint] NOT NULL,
	[num_logins] [int] NULL,
	[minutes_online] [int] NULL,
	[assignments_submitted] [tinyint] NULL,
	[forum_posts] [tinyint] NULL,
PRIMARY KEY CLUSTERED 
(
	[activity_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vw_FNU_EarlyRisk]    Script Date: 12/17/2025 1:36:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_FNU_EarlyRisk] AS
  WITH EarlyActivity AS (
    SELECT
        enrolment_id,
        SUM(num_logins) AS logins_w1_3,
        SUM(minutes_online) AS minutes_w1_3,
        SUM(assignments_submitted) AS assignments_w1_3
    FROM WeeklyActivity
    WHERE week_no BETWEEN 1 AND 3
    GROUP BY enrolment_id
  )
  SELECT
    e.*,
    ea.logins_w1_3,
    ea.minutes_w1_3,
    ea.assignments_w1_3
  FROM Enrolments e
  LEFT JOIN EarlyActivity ea ON e.enrolment_id = ea.enrolment_id;
     -- In R: fnu <- dbReadTable(con, "vw_FNU_EarlyRisk")
GO
ALTER TABLE [dbo].[Courses]  WITH CHECK ADD  CONSTRAINT [FK_Courses_Programs] FOREIGN KEY([program_code])
REFERENCES [dbo].[Programs] ([program_code])
GO
ALTER TABLE [dbo].[Courses] CHECK CONSTRAINT [FK_Courses_Programs]
GO
ALTER TABLE [dbo].[Enrolments]  WITH CHECK ADD  CONSTRAINT [FK_Enrolments_Courses] FOREIGN KEY([course_id])
REFERENCES [dbo].[Courses] ([course_id])
GO
ALTER TABLE [dbo].[Enrolments] CHECK CONSTRAINT [FK_Enrolments_Courses]
GO
ALTER TABLE [dbo].[Enrolments]  WITH CHECK ADD  CONSTRAINT [FK_Enrolments_Students] FOREIGN KEY([student_id])
REFERENCES [dbo].[Students] ([student_id])
GO
ALTER TABLE [dbo].[Enrolments] CHECK CONSTRAINT [FK_Enrolments_Students]
GO
ALTER TABLE [dbo].[Enrolments]  WITH CHECK ADD  CONSTRAINT [FK_Enrolments_Terms] FOREIGN KEY([term_id])
REFERENCES [dbo].[Terms] ([term_id])
GO
ALTER TABLE [dbo].[Enrolments] CHECK CONSTRAINT [FK_Enrolments_Terms]
GO
ALTER TABLE [dbo].[WeeklyActivity]  WITH CHECK ADD  CONSTRAINT [FK_WeeklyActivity_Enrolments] FOREIGN KEY([enrolment_id])
REFERENCES [dbo].[Enrolments] ([enrolment_id])
GO
ALTER TABLE [dbo].[WeeklyActivity] CHECK CONSTRAINT [FK_WeeklyActivity_Enrolments]
GO
USE [master]
GO
ALTER DATABASE [FNU_Analytics] SET  READ_WRITE 
GO
