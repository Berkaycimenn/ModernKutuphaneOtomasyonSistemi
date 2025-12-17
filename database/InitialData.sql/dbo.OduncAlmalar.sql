USE [KutuphaneDB]
GO

/****** Object:  Table [dbo].[OduncAlmalar]    Script Date: 17.12.2025 22:43:06 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[OduncAlmalar](
	[OduncID] [int] IDENTITY(1,1) NOT NULL,
	[KullaniciID] [int] NULL,
	[KitapID] [int] NULL,
	[OduncTarihi] [date] NULL,
	[IadeTarihi] [date] NULL,
	[GecikmeGun] [int] NULL,
	[CezaMiktari] [decimal](10, 2) NULL,
PRIMARY KEY CLUSTERED 
(
	[OduncID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[OduncAlmalar] ADD  DEFAULT (getdate()) FOR [OduncTarihi]
GO

ALTER TABLE [dbo].[OduncAlmalar]  WITH CHECK ADD FOREIGN KEY([KitapID])
REFERENCES [dbo].[Kitaplar] ([KitapID])
GO

ALTER TABLE [dbo].[OduncAlmalar]  WITH CHECK ADD FOREIGN KEY([KullaniciID])
REFERENCES [dbo].[Kullanicilar] ([KullaniciID])
GO

