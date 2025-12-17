USE [KutuphaneDB]
GO

/****** Object:  Table [dbo].[Kullanicilar]    Script Date: 17.12.2025 22:41:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Kullanicilar](
	[KullaniciID] [int] IDENTITY(1,1) NOT NULL,
	[AdSoyad] [nvarchar](100) NOT NULL,
	[Email] [nvarchar](100) NOT NULL,
	[Sifre] [nvarchar](100) NOT NULL,
	[Telefon] [nvarchar](15) NULL,
	[KayitTarihi] [date] NULL,
	[UyeTipi] [nvarchar](20) NULL,
	[RolID] [int] NULL,
	[SonLoginBasarili] [bit] NULL,
	[SonLoginTarihi] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[KullaniciID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Kullanicilar] ADD  DEFAULT (getdate()) FOR [KayitTarihi]
GO

ALTER TABLE [dbo].[Kullanicilar] ADD  DEFAULT ('standart') FOR [UyeTipi]
GO

ALTER TABLE [dbo].[Kullanicilar]  WITH CHECK ADD  CONSTRAINT [FK_Kullanicilar_Roller] FOREIGN KEY([RolID])
REFERENCES [dbo].[Roller] ([RolID])
GO

ALTER TABLE [dbo].[Kullanicilar] CHECK CONSTRAINT [FK_Kullanicilar_Roller]
GO

ALTER TABLE [dbo].[Kullanicilar]  WITH NOCHECK ADD CHECK  (([UyeTipi]='vip' OR [UyeTipi]='ogrenci' OR [UyeTipi]='standart'))
GO

