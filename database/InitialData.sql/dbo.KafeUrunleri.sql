USE [KutuphaneDB]
GO

/****** Object:  Table [dbo].[KafeUrunleri]    Script Date: 17.12.2025 22:40:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[KafeUrunleri](
	[UrunID] [int] IDENTITY(1,1) NOT NULL,
	[Ad] [nvarchar](100) NOT NULL,
	[Tip] [nvarchar](50) NULL,
	[Fiyat] [decimal](10, 2) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[UrunID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

