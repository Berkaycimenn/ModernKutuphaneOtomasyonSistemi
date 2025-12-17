USE [KutuphaneDB]
GO

/****** Object:  Table [dbo].[Siparisler]    Script Date: 17.12.2025 22:44:13 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Siparisler](
	[SiparisID] [int] IDENTITY(1,1) NOT NULL,
	[KullaniciID] [int] NULL,
	[Tarih] [date] NULL,
	[Toplam] [decimal](10, 2) NULL,
PRIMARY KEY CLUSTERED 
(
	[SiparisID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Siparisler] ADD  DEFAULT (getdate()) FOR [Tarih]
GO

ALTER TABLE [dbo].[Siparisler] ADD  CONSTRAINT [DF_Siparisler_Toplam]  DEFAULT ((0)) FOR [Toplam]
GO

ALTER TABLE [dbo].[Siparisler]  WITH CHECK ADD FOREIGN KEY([KullaniciID])
REFERENCES [dbo].[Kullanicilar] ([KullaniciID])
GO

