USE [KutuphaneDB]
GO

/****** Object:  Table [dbo].[Kampanyalar]    Script Date: 17.12.2025 22:40:22 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Kampanyalar](
	[KampanyaID] [int] IDENTITY(1,1) NOT NULL,
	[KampanyaAdi] [nvarchar](100) NULL,
	[IndirimOrani] [decimal](5, 2) NULL,
	[BaslangicTarihi] [date] NULL,
	[BitisTarihi] [date] NULL,
	[KampanyaTuru] [nvarchar](50) NULL,
	[Kosul] [nvarchar](200) NULL,
	[Aktif] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[KampanyaID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Kampanyalar] ADD  DEFAULT ((1)) FOR [Aktif]
GO

