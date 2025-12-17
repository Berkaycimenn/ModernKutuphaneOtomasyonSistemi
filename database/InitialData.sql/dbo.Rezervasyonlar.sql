USE [KutuphaneDB]
GO

/****** Object:  Table [dbo].[Rezervasyonlar]    Script Date: 17.12.2025 22:43:19 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Rezervasyonlar](
	[RezervasyonID] [int] IDENTITY(1,1) NOT NULL,
	[KullaniciID] [int] NULL,
	[OdaID] [int] NULL,
	[Tarih] [datetime] NULL,
	[Durum] [nvarchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[RezervasyonID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

