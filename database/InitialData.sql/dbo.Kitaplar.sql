USE [KutuphaneDB]
GO

/****** Object:  Table [dbo].[Kitaplar]    Script Date: 17.12.2025 22:40:45 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Kitaplar](
	[KitapID] [int] IDENTITY(1,1) NOT NULL,
	[Baslik] [nvarchar](200) NOT NULL,
	[Yazar] [nvarchar](100) NULL,
	[YayinYili] [int] NULL,
	[Durum] [nvarchar](20) NULL,
	[StokSayisi] [int] NULL,
	[ISBN] [nvarchar](20) NULL,
PRIMARY KEY CLUSTERED 
(
	[KitapID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Kitaplar] ADD  DEFAULT ('Mevcut') FOR [Durum]
GO

ALTER TABLE [dbo].[Kitaplar] ADD  DEFAULT ((0)) FOR [StokSayisi]
GO

ALTER TABLE [dbo].[Kitaplar]  WITH CHECK ADD CHECK  (([Durum]='OduncAlindi' OR [Durum]='Mevcut'))
GO

